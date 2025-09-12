(*********************************************************************************)
(*  dune-rpc-eio - Communicate with dune using rpc and Eio                       *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module V1 = struct
  type eio_state =
    { fs : Eio.Fs.dir_ty Eio.Path.t
    ; sw : Eio.Switch.t
    }

  let eio_state = ref None

  let initialize ~env ~sw =
    match !eio_state with
    | Some _ -> failwith "Dune_rpc_eio was already initialized"
    | None ->
      eio_state := Some { fs = (Eio.Stdenv.fs env :> Eio.Fs.dir_ty Eio.Path.t); sw }
  ;;

  let eio_state () =
    match !eio_state with
    | None -> failwith "Dune_rpc_eio is not initialized"
    | Some x -> x
  ;;

  let fs () = (eio_state ()).fs
  let sw () = (eio_state ()).sw

  module Fiber = struct
    type 'a t = 'a Eio.Promise.or_exn

    let return x = Eio.Promise.create_resolved (Ok x)

    let map t ~f =
      Eio.Fiber.fork_promise ~sw:(sw ()) (fun () -> f (Eio.Promise.await_exn t))
    ;;

    let bind t ~f =
      Eio.Fiber.fork_promise ~sw:(sw ()) (fun () ->
        f (Eio.Promise.await_exn t) |> Eio.Promise.await_exn)
    ;;

    let fork_and_join_unit x y =
      Eio.Fiber.fork_promise ~sw:(sw ()) (fun () ->
        Eio.Fiber.pair
          (fun () -> x () |> Eio.Promise.await_exn)
          (fun () -> y () |> Eio.Promise.await_exn)
        |> snd)
    ;;

    let parallel_iter ls ~f =
      Eio.Fiber.fork_promise ~sw:(sw ()) (fun () ->
        let rec iter d =
          match d |> Eio.Promise.await_exn with
          | None -> ()
          | Some data ->
            Eio.Fiber.both
              (fun () -> f data |> Eio.Promise.await_exn)
              (fun () -> ls () |> iter)
        in
        iter (ls ()))
    ;;

    let finalize f ~finally =
      Eio.Fiber.fork_promise ~sw:(sw ()) (fun () ->
        match f () |> Eio.Promise.await_exn with
        | res ->
          finally () |> Eio.Promise.await_exn;
          res
        | exception exn ->
          let bt = Printexc.get_raw_backtrace () in
          finally () |> Eio.Promise.await_exn;
          Printexc.raise_with_backtrace exn bt)
    ;;

    module Ivar = struct
      type 'a t = 'a Eio.Promise.or_exn * ('a, exn) result Eio.Promise.u

      let create () = Eio.Promise.create ()

      let fill (_, u) x =
        Eio.Promise.resolve u (Ok x);
        Eio.Promise.create_resolved (Ok ())
      ;;

      let read (x, _) = x
    end

    module O = struct
      let ( let* ) a f = bind a ~f
      let ( let+ ) a f = map a ~f
    end
  end

  type chan = Chan : _ Eio.Net.stream_socket -> chan

  module Client =
    Dune_rpc.V1.Client.Make
      (Fiber)
      (struct
        type t = chan

        let read (Chan t) =
          (* The input and output channels share the same file descriptor. If
             the output channel has been closed, reading from the input channel
             will result in an error. *)
          let buf = Eio.Buf_read.of_flow ~max_size:1_000_000 t in
          let open Csexp.Parser in
          let lexer = Lexer.create () in
          let rec loop depth stack =
            match Eio.Buf_read.any_char buf with
            | exception End_of_file ->
              Lexer.feed_eoi lexer;
              None
            | c ->
              (match Lexer.feed lexer c with
               | Await -> loop depth stack
               | Lparen -> loop (depth + 1) (Stack.open_paren stack)
               | Rparen ->
                 let stack = Stack.close_paren stack in
                 let depth = depth - 1 in
                 if depth = 0
                 then (
                   let sexps = Stack.to_list stack in
                   sexps |> List.hd |> Option.some)
                 else loop depth stack
               | Atom count ->
                 if Eio.Buf_read.at_end_of_input buf
                 then (
                   Lexer.feed_eoi lexer;
                   None)
                 else (
                   let atom = Eio.Buf_read.take count buf in
                   loop depth (Stack.add_atom atom stack)))
          in
          Eio.Fiber.fork_promise ~sw:(sw ()) (fun () -> loop 0 Stack.Empty)
        ;;

        let write (Chan t) d =
          Eio.Fiber.fork_promise ~sw:(sw ()) (fun () ->
            match d with
            | None -> Eio.Flow.close t
            | Some csexps ->
              Eio.Buf_write.with_flow t (fun w ->
                List.iter
                  (fun sexp -> Eio.Buf_write.string w (Csexp.to_string sexp))
                  csexps))
        ;;
      end)

  module Where =
    Dune_rpc.V1.Where.Make
      (Fiber)
      (struct
        let try_with f =
          Eio.Fiber.fork_promise ~sw:(sw ()) (fun () ->
            match f () with
            | r -> Ok r
            | exception exn -> Error exn)
        ;;

        let read_file s =
          try_with (fun () ->
            let path = Eio.Path.(fs () / s) in
            Eio.Path.load path)
        ;;

        let analyze_path s =
          try_with (fun () ->
            let path = Eio.Path.(fs () / s) in
            match Eio.Path.kind ~follow:true path with
            | `Not_found -> failwith (Printf.sprintf "Dune_rpc_eio: File not found %S" s)
            | `Symbolic_link ->
              failwith (Printf.sprintf "Dune_rpc_eio: Unresolved symbolic link %S" s)
            | `Socket -> `Unix_socket
            | `Regular_file -> `Normal_file
            | `Unknown | `Fifo | `Character_special | `Directory | `Block_device -> `Other)
        ;;
      end)

  let connect_chan ~env ~sw where : chan =
    let stream : Eio.Net.Sockaddr.stream =
      match where with
      | `Unix _ as socket -> socket
      | `Ip (`Host host, `Port port) -> `Tcp (Eio.Net.Ipaddr.of_raw host, port)
    in
    Chan (Eio.Net.connect ~sw (Eio.Stdenv.net env) stream)
  ;;
end
