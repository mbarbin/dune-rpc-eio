(*********************************************************************************)
(*  dune-rpc-eio - Communicate with dune using rpc and Eio                       *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let () =
  Cmdlang_cmdliner_runner.run
    Dune_rpc_eio_example.main
    ~name:"main"
    ~version:"%%VERSION%%"
;;
