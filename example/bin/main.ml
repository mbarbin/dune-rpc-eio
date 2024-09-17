let () =
  Cmdlang_cmdliner_runner.run
    Dune_rpc_eio_example.main
    ~name:"main"
    ~version:"%%VERSION%%"
;;
