(*_********************************************************************************)
(*_  dune-rpc-eio - Communicate with dune using rpc and Eio                       *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

module V1 : sig
  module Fiber : sig
    type 'a t = 'a Eio.Promise.or_exn
  end

  (** The type for the two way channel used for communication with dune. The
      type hides behind an GADT constructor since the dune_rpc functor expects
      a non-parametrized type for the channels. You can treat it as an
      abstract type [chan] for all practical purposes, it is only exposed for
      convenience and low-level uses of the library. *)
  type chan = Chan : _ Eio.Net.stream_socket -> chan

  module Client :
    Dune_rpc.V1.Client.S with type 'a fiber := 'a Fiber.t and type chan := chan

  module Where : Dune_rpc.V1.Where.S with type 'a fiber := 'a Fiber.t

  (** We require in this implementation that the file system be initialized
      before any attempt to use the library. In addition to the file system,
      the current implementation needs access to a current eio switch.

      The intended use is to make this initialization call very early in your
      program, with the same Eio environment that you are using in the rest of
      the program.

      {[
        Eio_main.run
        @@ fun env ->
        Eio.Switch.run
        @@ fun sw ->
        Dune_rpc_eio.V1.initialize ~env ~sw;
        (* You can now carry on and use [Dune_rpc_eio.V1.Client]. *)
        ()
      ]} *)
  val initialize : env:< fs : (_ Eio.Path.t as 'a) ; .. > -> sw:Eio.Switch.t -> unit

  val connect_chan
    :  env:< net : (_ Eio.Net.t as 'a) ; .. >
    -> sw:Eio.Switch.t
    -> Dune_rpc.V1.Where.t
    -> chan
end
