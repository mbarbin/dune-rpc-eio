# RPC Client Example

This project contains an executable `dune-rpc-eio-example` which connects to the
RPC server started when Dune is run in watch mode. To use this program, start
Dune in watch mode:

```
$ dune build --watch
```

## `stop`` command

Then run `dune-rpc-eio-example stop` from the same directory as `dune` was run
from. This command will connect to the server (`dune build --watch` starts an
RPC server) and perform several RPC calls to it before instructing the server
(over RPC) to shutdown.

Provide `--build-dir /path/to/repo/_build` to talk to another dune instance.

## Acknowledgments

The `dune-rpc-eio` package as well as this example are direct translations of
the [dune-rpc-lwt](https://opam.ocaml.org/packages/dune-rpc-lwt/) package that
is part of the official `dune` distribution.
