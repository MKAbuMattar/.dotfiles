# tmux-utils

## NAME

**tmux-utils** — interactive session picker and small management helpers for tmux.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "tmux" ...)
```

## DESCRIPTION

Three shell functions around tmux session and window management. The file no-ops if `tmux` is not on `$PATH`. `tms` uses `fzf` when available to fuzzy-pick a session, switch to it if already inside tmux, attach from outside, or create it on the fly if the typed name does not yet exist. `tm-rename` is a quick wrapper around `rename-window`. `tm-list` formats sessions in a fixed-width table.

## FUNCTIONS

### `tms`

fzf-driven session switcher / creator.

**Arguments:** none.

**Behavior:**

- If `fzf` is not on `$PATH`: degrade to a plain `tmux attach` when there is an existing session, otherwise create a new session named after the current directory's basename (`${PWD:t}`).
- Otherwise: list sessions with `tmux list-sessions -F '#S'` and pipe them through `fzf --print-query --no-multi --prompt='tmux> ' --preview 'tmux list-windows -t {}'`. Take the last line of fzf's output (this is the chosen session or, if none matched, the typed query).
- If the chosen name resolves to an existing session: `tmux switch-client -t` when already inside tmux (`$TMUX` is set), else `tmux attach -t`.
- If the name does not yet exist: `tmux new -s "$session"` — so typing a fresh name in the picker creates it.

**Example:**

```bash
tms
# (fzf prompt)
# type "work" → switch-client to existing
# type "scratch" → new session called scratch
```

### `tm-rename <new-window-name>`

Rename the current tmux window without touching the prefix.

**Arguments:**

| Arg  | Required | Description                          |
| ---- | -------- | ------------------------------------ |
| `$1` | Yes      | New window name.                     |

**Behavior:**

Refuses to run with a message if `$TMUX` is unset (not inside tmux). With a name, runs `tmux rename-window "$1"`.

**Example:**

```bash
tm-rename build
```

### `tm-list`

Tabular session listing.

**Arguments:** none.

**Behavior:**

Calls `tmux list-sessions -F '#{session_name}|#{session_windows}|#{?session_attached,attached,detached}|#{session_created_string}'` and pipes through `column -t -s '|'` so the four columns line up.

**Example:**

```bash
tm-list
# work     5  attached  Sun May 19 10:14:21 2025
# scratch  1  detached  Sun May 19 12:02:00 2025
```

## REQUIREMENTS

- `tmux` on `$PATH` (the module no-ops otherwise).
- `fzf` for the interactive path of `tms` (without it, `tms` still works in degraded form).
- `column` (from `util-linux` / `bsdmainutils`) for `tm-list`.

## EXAMPLES

```bash
tms                 # fuzzy-pick / switch / create a session
tm-rename build     # rename current window
tm-list             # table of sessions
```

## SEE ALSO

- [.docs/aliases/tmux](../aliases/tmux.md)
- [.docs/plugins/zsh/tmux](../plugins/zsh/tmux.md)
- [.docs/README.md](../README.md)
