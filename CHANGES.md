## 0.0.8 (unreleased)

### Added

### Changed

- Upgrade to `cmdlang.0.0.5`.

### Deprecated

### Fixed

### Removed

## 0.0.7 (2024-09-08)

### Added

- Configure dev-setup dependencies

### Changed

- Use `cmdlang` for the CLI.
- Use `expect_test_helpers_core`.

### Fixed

- Improve example trace determinism. The example no longer show additional events under certain brittle conditions.

## 0.0.6 (2024-07-26)

### Added

- Added dependabot config for automatically upgrading action files.

### Changed

- Upgrade `ppxlib` to `0.33` - activate unused items warnings.
- Upgrade `ocaml` to `5.2`.
- Upgrade `dune` to `3.16`.
- Upgrade base & co to `0.17`.

## 0.0.5 (2024-03-13)

### Changed

- Upgrade `eio` to `1.0` (no change required).
- Uses `expect-test-helpers` (reduce core dependencies)
- Upgrade `eio` to `0.15`.
- Run `ppx_js_style` as a linter & make it a `dev` dependency.
- Upgrade GitHub workflows `actions/checkout` to v4.
- In CI, specify build target `@all`, and add `@lint`.
- List ppxs instead of `ppx_jane`.

## 0.0.4 (2024-02-14)

### Changed

- Upgrade dune to `3.14`.
- Build the doc with sherlodoc available to enable the doc search bar.

## 0.0.3 (2024-02-09)

### Changed

- Internal changes related to the release process.
- Upgrade dune and internal dependencies.

## 0.0.2 (2024-01-18)

### Changed

- Internal changes related to build and release process.

## 0.0.1 (2023-11-14)

Initial release translated from `dune-rpc-lwt`.

- Added instance of `Dune_rpc.V1` functor for `Eio` clients.
- Added a rpc-client example similar to `rpc_client` from `dune-rpc-lwt`.
