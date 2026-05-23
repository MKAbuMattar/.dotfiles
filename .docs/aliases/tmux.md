# tmux-aliases

## NAME

**tmux-aliases** — terse forms for the most common `tmux` session and window operations.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "tmux" ...)
```

## DESCRIPTION

A small set of session-management shortcuts. The module no-ops if `tmux` is not on `$PATH`, so it loads cleanly on hosts that do not have it. These aliases all run from a regular shell prompt — for inside-tmux window/pane manipulation, the tmux prefix key remains the right tool. For an fzf-driven session picker plus a few helpers, see [.docs/utils/tmux](../utils/tmux.md).

## ALIASES

### Session management

| Alias    | Expansion                   | Description                                        |
| -------- | --------------------------- | -------------------------------------------------- |
| `tm`     | `tmux`                      | Bare tmux invocation.                              |
| `tma`    | `tmux attach`               | Attach to the default (most-recent) session.       |
| `tmat`   | `tmux attach -t`            | Attach to a named session: `tmat work`.            |
| `tml`    | `tmux list-sessions`        | Print all sessions.                                |
| `tmn`    | `tmux new -s`               | Start a new named session: `tmn work`.             |
| `tmk`    | `tmux kill-session -t`      | Kill one named session: `tmk work`.                |
| `tmka`   | `tmux kill-server`          | Kill the entire tmux server (all sessions).        |

### Inspect from inside tmux

| Alias    | Expansion                   | Description                          |
| -------- | --------------------------- | ------------------------------------ |
| `tmlw`   | `tmux list-windows`         | List windows in the current session. |
| `tmlp`   | `tmux list-panes`           | List panes in the current window.    |

### Config / env

| Alias    | Expansion                              | Description                                              |
| -------- | -------------------------------------- | -------------------------------------------------------- |
| `tmsrc`  | `tmux source-file ~/.tmux.conf`        | Reload `~/.tmux.conf` without restarting tmux.           |
| `tmenv`  | `tmux show-environment`                | Show env vars tmux exports into the current session.     |

## REQUIREMENTS

- `tmux` on `$PATH`. The whole module no-ops otherwise.
- `~/.tmux.conf` must exist for `tmsrc` to do anything useful.

## EXAMPLES

```bash
tmn work             # new session called "work"
tmat work            # attach to it later
tml                  # list sessions
tmlw                 # (inside tmux) windows in current session
tmsrc                # reload config after editing
tmk work             # kill the "work" session
tmka                 # nuke everything
```

## SEE ALSO

- [.docs/utils/tmux](../utils/tmux.md)
- [.docs/plugins/zsh/tmux](../plugins/zsh/tmux.md)
- [.docs/README.md](../README.md)
