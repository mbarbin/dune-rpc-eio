let stop_cmd =
  Command.make
    ~summary:"Connect to a dune-rpc instance and instruct it to stop."
    ~readme:(fun () ->
      "This commands will connect to the dune server, perform several RPC calls to it \
       before instructing the server (over RPC) to shutdown.")
    (let%map_open.Command () = Log_cli.set_config ()
     and build_dir =
       Arg.named_with_default
         [ "build-dir" ]
         Param.string
         ~default:"_build"
         ~docv:"PATH"
         ~doc:"Path to the build directory of the running `dune -w` instance."
     in
     Eio_main.run
     @@ fun env ->
     Eio.Switch.run
     @@ fun sw ->
     Dune_rpc_eio.V1.initialize ~env ~sw;
     let init =
       Dune_rpc.V1.Initialize.create
         ~id:(Dune_rpc.V1.Id.make (Csexp.Atom "example_rpc_client"))
     in
     let where = Dune_rpc_eio.V1.Where.default ~build_dir () in
     Eio.traceln "Connecting to RPC server...";
     let chan = Dune_rpc_eio.V1.connect_chan ~env ~sw where in
     Dune_rpc_eio.V1.Client.connect chan init ~f:(fun client ->
       Eio.traceln "Sending ping to server...";
       let () =
         let request =
           Dune_rpc_eio.V1.Client.Versioned.prepare_request
             client
             Dune_rpc.V1.Request.ping
           |> Eio.Promise.await_exn
           |> Stdlib.Result.get_ok
         in
         Dune_rpc_eio.V1.Client.request client request ()
         |> Eio.Promise.await_exn
         |> Stdlib.Result.get_ok
       in
       Eio.traceln "Got response from server...";
       Eio.traceln "Creating progress stream...";
       let progress_stream =
         Dune_rpc_eio.V1.Client.poll client Dune_rpc.V1.Sub.progress
         |> Eio.Promise.await_exn
         |> Stdlib.Result.get_ok
       in
       Eio.traceln "Waiting for success event...";
       let rec loop () =
         let progress_event =
           Dune_rpc_eio.V1.Client.Stream.next progress_stream |> Eio.Promise.await_exn
         in
         let message =
           match progress_event with
           | None -> "(none)"
           | Some Success -> "Success"
           | Some Failed -> "Failed"
           | Some Interrupted -> "Interrupted"
           | Some (In_progress { complete; remaining; failed }) ->
             Printf.sprintf
               "In_progress { complete = %d;  remaining = %d;  failed = %d }"
               complete
               remaining
               failed
           | Some Waiting -> "Waiting"
         in
         Err.info [ Pp.textf "Got progress_event: %s" message ];
         match progress_event with
         | Some Success -> ()
         | Some (In_progress _) -> loop ()
         | None | Some Failed | Some Interrupted | Some Waiting ->
           Err.raise [ Pp.textf "Unexpected event: %s" message ]
       in
       loop ();
       Eio.traceln "Shutting down RPC server...";
       let shutdown_notification =
         Dune_rpc_eio.V1.Client.Versioned.prepare_notification
           client
           Dune_rpc.V1.Notification.shutdown
         |> Eio.Promise.await_exn
         |> Stdlib.Result.get_ok
       in
       Dune_rpc_eio.V1.Client.notification client shutdown_notification ())
     |> Eio.Promise.await_exn)
;;

let main =
  Command.group
    ~summary:"Connect to a dune-rpc instance and perform some RPC calls."
    ~readme:(fun () ->
      "This example executable offers commands to connect to the RPC server\n\
       started when Dune is run watch mode.\n\n\
       To use this program, start Dune in watch mode:\n\n\
       ```\n\
       $ dune build --watch\n\
       ```")
    [ "stop", stop_cmd ]
;;
