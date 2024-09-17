(lang dune 3.16)

(name dune-rpc-eio)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/dune-rpc-eio))

(documentation "https://mbarbin.github.io/dune-rpc-eio/")

(package
 (name dune-rpc-eio)
 (synopsis "Communicate with dune using rpc and Eio")
 (depends
  (ocaml
   (>= 5.2))
  (csexp
   (>= 1.5.2))
  (dune-rpc
   (>= 3.16))
  (eio
   (>= 1.0))))

(package
 (name dune-rpc-eio-example)
 (synopsis "An example of a client built with dune-rpc-eio")
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.26.2)))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (cmdlang
   (>= 0.0.5))
  (cmdlang-cmdliner-runner
   (>= 0.0.5))
  (cmdlang-to-cmdliner
   (>= 0.0.5))
  (cmdliner
   (= 1.3.0))
  (dune-rpc
   (>= 3.16))
  (dune-rpc-eio
   (= :version))
  (eio
   (>= 1.0))
  (eio_main
   (>= 1.0))
  (err
   (>= 0.0.5))
  (err-cli
   (>= 0.0.5))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.17)
    (< v0.18)))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_expect
   (and
    :with-test
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))))
