# screen-aliases

## NAME

**screen-aliases** — short aliases for GNU `screen` session management.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "screen" ...)
```

## DESCRIPTION

Provides short aliases for the most common GNU Screen operations: listing sessions, creating named sessions, reattaching, sharing a session (`-x`), detaching, sending commands (`-X`), and quitting. The module is gated by `(( ! $+commands[screen] )) && return`, so it loads only when `screen` is on `$PATH`.

## ALIASES

### Short Forms

| Alias | Expansion        | Description                                        |
| ----- | ---------------- | -------------------------------------------------- |
| `sl`  | `screen -ls`     | List sessions                                      |
| `sn`  | `screen -S`      | Start a new named session                          |
| `sr`  | `screen -r`      | Reattach to a detached session                     |
| `sx`  | `screen -x`      | Attach to a session in shared (multi-display) mode |
| `sd`  | `screen -d`      | Detach a session running elsewhere                 |
| `sdr` | `screen -dr`     | Detach if needed, then reattach                    |
| `sX`  | `screen -X`      | Send a screen command to a running session         |
| `sq`  | `screen -X quit` | Quit a running session                             |

### Verbose Forms

| Alias  | Expansion      | Description                              |
| ------ | -------------- | ---------------------------------------- |
| `scr`  | `screen -r`    | Reattach (verbose form)                  |
| `scrd` | `screen -d -r` | Detach + reattach (verbose form)         |
| `scrn` | `screen -S`    | Start a new named session (verbose form) |
| `scrl` | `screen -ls`   | List sessions (verbose form)             |

## REQUIREMENTS

- `screen` installed and on `$PATH`.

## EXAMPLES

```bash
# Start a named work session
sn work

# List sessions
sl

# Reattach to a session, kicking off any existing attachment
sdr work

# Quit a session by name
sq -S work
```

## SEE ALSO

- [.docs/README.md](../README.md)
