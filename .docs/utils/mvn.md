# mvn-utils

## NAME

**mvn-utils** — Maven wrappers that prefer the project's `mvnw` and colorize output.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "mvn" ...)
```

## DESCRIPTION

Returns immediately when `mvn` is not on PATH. Provides two convenience functions: `mvn-or-mvnw`, which transparently delegates to a project-local `mvnw` when one exists, and `mvn-color`, an ANSI-colorizing pipeline around `mvn` output. Both functions take arbitrary arguments and forward them to the underlying tool.

## FUNCTIONS

### `mvn-or-mvnw [args...]`

Runs `./mvnw` when one is found in the current directory or any ancestor; falls back to system `mvn` otherwise.

**Arguments:**

| Arg  | Required | Description                                     |
| ---- | -------- | ----------------------------------------------- |
| `$@` | No       | Arguments forwarded verbatim to `mvnw` / `mvn`. |

**Behavior:**

Walks up from `$PWD` toward `/` looking for an executable file named `mvnw`. If found, prints `Running '<path>/mvnw'...` to stderr and execs it with `"$@"`, returning its exit status. If no `mvnw` is found, runs `command mvn "$@"`.

**Example:**

```bash
mvn-or-mvnw clean install -DskipTests
```

### `mvn-color [args...]`

Runs `mvn "$@"` and colorizes the log output via `sed`.

**Arguments:**

| Arg  | Required | Description                   |
| ---- | -------- | ----------------------------- |
| `$@` | No       | Arguments forwarded to `mvn`. |

**Behavior:**

Captures terminal capabilities via `echoti bold`, `echoti setaf <n>`, `echoti sgr0`. Inside a subshell, unsets `LANG` and forces `LC_CTYPE=C` to keep `sed` from choking on invalid UTF-8 sequences. Pipes `mvn` stdout through a `sed` script that rewrites `[INFO]`, `[DEBUG]`, `[WARNING]`, `[ERROR]`, the `BUILD SUCCESSFUL` line, and the `Tests run: a, Failures: b, Errors: c, Skipped: d` summary into appropriately colored variants. Emits a final `sgr0` reset.

**Example:**

```bash
mvn-color package
```

## REQUIREMENTS

- `mvn` (module returns silently otherwise).
- `sed` and `tput`/`echoti` for `mvn-color`.

## EXAMPLES

```bash
# Build from anywhere inside the project, honoring the bundled wrapper
mvn-or-mvnw verify

# Colorize a Maven run for easier scanning
mvn-color clean test
```

## SEE ALSO

- [.docs/aliases/mvn](../aliases/mvn.md)
- [.docs/plugins/zsh/mvn](../plugins/zsh/mvn.md)
- [.docs/README.md](../README.md)
