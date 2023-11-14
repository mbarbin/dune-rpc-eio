# dune-rpc-eio

[![CI Status](https://github.com/mbarbin/dune-rpc-eio/workflows/ci/badge.svg)](https://github.com/mbarbin/dune-rpc-eio/actions/workflows/ci.yml)
[![Deploy odoc Status](https://github.com/mbarbin/dune-rpc-eio/workflows/deploy-odoc/badge.svg)](https://github.com/mbarbin/dune-rpc-eio/actions/workflows/deploy-odoc.yml)

Communicate with `dune` using
[dune-rpc](https://opam.ocaml.org/packages/dune-rpc/) and
[eio](https://opam.ocaml.org/packages/eio/).

This library implements an instance of the `dune-rpc` functor to be used by
`Eio` clients.

## Motivations

This is an experimental package that allows me to learn more about dune-rpc and
eio.

## Acknowledgments

The `dune-rpc-eio` package is a direct translation of the
[dune-rpc-lwt](https://opam.ocaml.org/packages/dune-rpc-lwt/) package that is
part of the official `dune` distribution, released under [MIT License](./LICENSE.janestreet).

The tests were heavily inspired by the tests used in `dune-rpc-lwt`.
