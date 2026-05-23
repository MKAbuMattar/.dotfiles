# rust-utils

## NAME

**rust-utils** — Helpers for Rust toolchain detection and project root resolution.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "rust" ...)
```

## DESCRIPTION

Returns silently unless both `rustup` and `cargo` are on PATH. Provides small functions for reading the current `rustc` version and active toolchain, rendering a prompt fragment, and walking up the directory tree to locate `Cargo.toml`.

## FUNCTIONS

### `rust_version`

Echoes the current `rustc` version number.

**Behavior:**

Runs `rustc --version` and pipes through `awk '{print $2}'` to keep just the version (e.g. `1.81.0`).

### `rust_toolchain`

Echoes the currently active rustup toolchain.

**Behavior:**

Runs `rustup show active-toolchain | awk '{print $1}'`. Includes the channel (`stable-x86_64-unknown-linux-gnu`, `nightly-...`, etc.).

### `rust_prompt_info`

Prompt fragment showing the active Rust version.

**Behavior:**

Calls `rust_version`; if non-empty, echoes `${ZSH_THEME_RUST_PROMPT_PREFIX-[}<version>${ZSH_THEME_RUST_PROMPT_SUFFIX-]}`. Version is percent-escaped via `:gs/%/%%`.

**Example:**

```bash
RPROMPT='$(rust_prompt_info)'
```

### `is_rust_project`

Returns 0 if the cwd or any ancestor contains a `Cargo.toml`.

**Behavior:**

Walks from `$PWD` toward `/` (`dir=${dir:h}`) and returns 0 on the first directory holding a `Cargo.toml`. Returns 1 if the root is reached without a hit.

**Example:**

```bash
is_rust_project && cargo build --release
```

### `rust_project_root`

Echoes the path to the directory containing the nearest `Cargo.toml`.

**Behavior:**

Same ancestor walk as `is_rust_project`; echoes the first matching directory and returns 0. Returns 1 with no output if no Cargo project is found.

**Example:**

```bash
cd "$(rust_project_root)"
```

## REQUIREMENTS

- `rustup` and `cargo` must both be installed; the module returns immediately otherwise.

## EXAMPLES

```bash
# Show rustc version on the right side of the prompt only inside a Rust project
RPROMPT='$(is_rust_project && rust_prompt_info)'

# Hop to the workspace root from anywhere inside it
cd "$(rust_project_root)"
```

## SEE ALSO

- [.docs/aliases/rust](../aliases/rust.md)
- [.docs/plugins/zsh/rust](../plugins/zsh/rust.md)
- [.docs/README.md](../README.md)
