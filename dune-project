(lang dune 3.15)

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
   (>= 5.1))
  (csexp
   (>= 1.5.2))
  (dune-rpc
   (>= 3.15))
  (eio
   (>= 1.0))))

(package
 (name dune-rpc-eio-example)
 (synopsis "An example of a client built with dune-rpc-eio")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (command-unix-for-opam
   (>= 0.0.2))
  (core
   (and
    (>= v0.17)
    (< v0.18)))
  (dune-rpc
   (>= 3.15))
  (dune-rpc-eio
   (= :version))
  (eio
   (>= 1.0))
  (eio_main
   (>= 1.0))
  (expect-test-helpers
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
    :dev
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
    (< v0.18)))))
