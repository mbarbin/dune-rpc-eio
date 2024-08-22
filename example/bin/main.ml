let () =
  Commandlang_to_cmdliner.run
    Dune_rpc_eio_example.main
    ~name:"main"
    ~version:"%%VERSION%%"
;;
