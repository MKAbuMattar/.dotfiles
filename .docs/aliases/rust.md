# rust-aliases

## NAME

**rust-aliases** — short aliases for `cargo` (build/test/run/publish/watch/edit) and `rustup` (toolchain/target management).

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "rust" ...)
```

## DESCRIPTION

Provides short `c*` aliases for `cargo` operations — build, check, clippy, doc, fmt, install, new/init, run, test, update, watch — plus `cargo publish`/`tree`/`fix`/`bench` and the `cargo-edit` `add`/`rm` helpers. Also provides `ru*` aliases for `rustup` toolchain and target management. The module is gated by `(( ! $+commands[cargo] )) && return`, so it loads only when `cargo` is on `$PATH`.

## ALIASES

### Cargo — Build / Check

| Alias  | Expansion               | Description                            |
| ------ | ----------------------- | -------------------------------------- |
| `cb`   | `cargo build`           | Build (debug)                          |
| `cbr`  | `cargo build --release` | Build (release)                        |
| `cc`   | `cargo check`           | Type-check without producing artifacts |
| `ccl`  | `cargo clean`           | Remove the `target` directory          |
| `cclp` | `cargo clippy`          | Run clippy lints                       |
| `cf`   | `cargo fmt`             | Format the workspace                   |
| `cfc`  | `cargo fmt --check`     | Check formatting without applying      |
| `cfix` | `cargo fix`             | Apply rustc/cargo suggested fixes      |

### Cargo — Doc

| Alias | Expansion          | Description                  |
| ----- | ------------------ | ---------------------------- |
| `cd`  | `cargo doc`        | Build documentation          |
| `cdo` | `cargo doc --open` | Build and open documentation |

### Cargo — Run / Test / Bench

| Alias | Expansion              | Description    |
| ----- | ---------------------- | -------------- |
| `cr`  | `cargo run`            | Run (debug)    |
| `crr` | `cargo run --release`  | Run (release)  |
| `ct`  | `cargo test`           | Test (debug)   |
| `ctr` | `cargo test --release` | Test (release) |
| `cbe` | `cargo bench`          | Run benchmarks |

### Cargo — Project / Packages

| Alias  | Expansion         | Description                           |
| ------ | ----------------- | ------------------------------------- |
| `ci`   | `cargo install`   | Install a binary crate                |
| `cun`  | `cargo uninstall` | Uninstall an installed binary         |
| `cin`  | `cargo init`      | Initialize a crate in the current dir |
| `cn`   | `cargo new`       | Create a new crate in a new dir       |
| `cu`   | `cargo update`    | Update `Cargo.lock`                   |
| `ctre` | `cargo tree`      | Show the dependency tree              |
| `cad`  | `cargo add`       | Add a dependency (cargo-edit)         |
| `crm`  | `cargo rm`        | Remove a dependency (cargo-edit)      |

### Cargo — Watch

| Alias | Expansion              | Description       |
| ----- | ---------------------- | ----------------- |
| `cw`  | `cargo watch`          | Watch for changes |
| `cwr` | `cargo watch -x run`   | Watch + run       |
| `cwt` | `cargo watch -x test`  | Watch + test      |
| `cwc` | `cargo watch -x check` | Watch + check     |

### Cargo — Publish

| Alias  | Expansion                 | Description          |
| ------ | ------------------------- | -------------------- |
| `cpp`  | `cargo publish`           | Publish to crates.io |
| `cppd` | `cargo publish --dry-run` | Dry-run publish      |

### Rustup

| Alias   | Expansion                    | Description                   |
| ------- | ---------------------------- | ----------------------------- |
| `ruc`   | `rustup check`               | Check for updates             |
| `ruu`   | `rustup update`              | Update toolchains             |
| `rus`   | `rustup show`                | Show active toolchain/targets |
| `rud`   | `rustup default`             | Set default toolchain         |
| `rut`   | `rustup target`              | Target subcommand             |
| `rutl`  | `rustup target list`         | List targets                  |
| `ruta`  | `rustup target add`          | Add a target                  |
| `rutr`  | `rustup target remove`       | Remove a target               |
| `ruto`  | `rustup toolchain`           | Toolchain subcommand          |
| `rutol` | `rustup toolchain list`      | List toolchains               |
| `rutoi` | `rustup toolchain install`   | Install a toolchain           |
| `rutou` | `rustup toolchain uninstall` | Uninstall a toolchain         |

## REQUIREMENTS

- `cargo` installed and on `$PATH`.
- `rustup` for the `ru*` aliases.
- `cargo-watch` for the `cw*` aliases.
- `cargo-edit` for `cad` / `crm`.

## EXAMPLES

```bash
# Bootstrap a new binary crate
cn my-tool
cd my-tool
cb

# Watch and re-run on save
cwr

# Add a dependency and rebuild
cad serde --features derive
cb

# Switch the default toolchain
rud stable
rus
```

## SEE ALSO

- [.docs/README.md](../README.md)
