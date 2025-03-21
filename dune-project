(lang dune 3.17)

(name dune-rpc-eio)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/dune-rpc-eio))

(documentation "https://mbarbin.github.io/dune-rpc-eio/")

(implicit_transitive_deps false)

(package
 (name dune-rpc-eio)
 (synopsis "Communicate with dune using rpc and Eio")
 (depends
  (ocaml
   (>= 5.2))
  (csexp
   (>= 1.5.2))
  (dune-rpc
   (>= 3.17))
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
    (= 0.27.0)))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (cmdlang
   (>= 0.0.9))
  (csexp
   (>= 1.5.2))
  (dune-rpc
   (>= 3.17))
  (dune-rpc-eio
   (= :version))
  (eio
   (>= 1.0))
  (eio_main
   (>= 1.0))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.17)
    (< v0.18)))
  (pp
   (>= 2.0.0))
  (pplumbing
   (>= 0.0.9))
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
   (>= 0.33))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
