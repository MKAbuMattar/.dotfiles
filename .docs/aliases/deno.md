# deno-aliases

## NAME

**deno-aliases** — short prefixes for the Deno runtime CLI.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "deno" ...)
```

## DESCRIPTION

Two- to four-character shortcuts for the most common Deno subcommands.
The aliases load unconditionally and do not probe for the `deno` binary,
so install Deno first (e.g. `curl -fsSL https://deno.land/install.sh | sh`).

## ALIASES

### Build and run

| Alias | Expansion             | Description                                              |
| ----- | --------------------- | -------------------------------------------------------- |
| `db`  | `deno bundle`         | Bundle into a single JS file (deprecated in newer Deno). |
| `dc`  | `deno compile`        | Produce a standalone executable.                         |
| `dca` | `deno cache`          | Pre-cache module deps.                                   |
| `drn` | `deno run`            | Run a script.                                            |
| `drA` | `deno run -A`         | Run with all permissions.                                |
| `drw` | `deno run --watch`    | Run with file watcher.                                   |
| `dru` | `deno run --unstable` | Run with unstable APIs enabled.                          |

### Quality

| Alias  | Expansion   | Description     |
| ------ | ----------- | --------------- |
| `dfmt` | `deno fmt`  | Format sources. |
| `dli`  | `deno lint` | Lint sources.   |
| `dts`  | `deno test` | Run tests.      |

### Tooling

| Alias | Expansion      | Description                       |
| ----- | -------------- | --------------------------------- |
| `dh`  | `deno help`    | Show CLI help.                    |
| `dup` | `deno upgrade` | Upgrade the Deno binary in place. |

## REQUIREMENTS

- `deno` on `$PATH`.

## EXAMPLES

```bash
drA main.ts            # Quick prototyping
drw server.ts          # Live-reload server
dfmt && dli && dts     # Pre-commit chain
dc -o app main.ts      # Build a standalone binary
```

## SEE ALSO

- [.docs/README.md](../README.md)
