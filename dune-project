(lang dune 3.12)

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
   (>= 3.12))
  (eio
   (>= 0.13))))

(package
 (name dune-rpc-eio-example)
 (synopsis "An example of a client built with dune-rpc-eio")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (command-unix-for-opam
   (>= 0.0.1))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (dune-rpc
   (>= 3.12))
  (dune-rpc-eio
   (= :version))
  (eio
   (>= 0.13))
  (eio_main
   (>= 0.13))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    (>= v0.16)
    (< v0.17)))))
