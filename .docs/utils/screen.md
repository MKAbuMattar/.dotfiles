# screen-utils

## NAME

**screen-utils** — GNU `screen` integration that drives tab titles and hardstatus from zsh.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "screen" ...)
```

## DESCRIPTION

Returns silently when `screen` is not on PATH. When `$TERM` matches `screen*`, the module overrides the zsh-global `title()` function with a no-op so the framework's standard title machinery cannot clobber screen's tab labels, then registers `preexec` and `precmd` hooks that emit the appropriate escape sequences to keep both the screen tab title (`%t`) and the hardstatus (`%h`) in sync with the running command or active shell.

Defines the helper `screen_set` (under `if [[ "$TERM" == screen* ]]`) and the `preexec`/`precmd` hook functions. Outside a screen session the file loads cleanly but installs no hooks.

## FUNCTIONS

### `screen_set <tab_title> <hardstatus>` (only when `$TERM == screen*`)

Pushes new tab title and hardstatus values to the surrounding screen session.

**Arguments:**

| Arg  | Required | Description                                 |
| ---- | -------- | ------------------------------------------- |
| `$1` | Yes      | Text used for `%t` (the screen tab title).  |
| `$2` | Yes      | Text used for `%h` (the screen hardstatus). |

**Behavior:**

Emits two raw escape sequences via `print -nR`:

- `\033k<title>\033\\` — sets the screen tab title.
- `\033]0;<status>\a` — sets the screen tab hardstatus (the xterm OSC 0 form that screen forwards into `%h`).

### `preexec()` (only when `$TERM == screen*`)

Called by zsh just before executing each command.

**Behavior:**

Splits the command line with `cmd=(${(z)1})`, then `eval`s `tab_title=$TAB_TITLE_PREFIX:$TAB_TITLE_EXEC` and `tab_hardstatus=$TAB_HARDSTATUS_PREFIX:$TAB_HARDSTATUS_EXEC`, finally calling `screen_set "$tab_title" "$tab_hardstatus"`.

### `precmd()` (only when `$TERM == screen*`)

Called by zsh before each prompt redraw.

**Behavior:**

Same shape as `preexec`, but composes the title and hardstatus from `*_PREFIX` and `*_PROMPT` templates instead of `*_EXEC`.

### `title()` (only when `$TERM == screen*`)

Overridden to an empty function so any standard title-setting code from the framework or themes becomes a no-op while screen mode is active.

## VARIABLES

These globals are populated only when `$TERM == screen*`. They are evaluated (via `eval`) inside the `preexec`/`precmd` hooks, so they are command templates rather than literal strings.

| Variable                | Description                                                                                                                  |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `_GET_PATH`             | Command that prints a shortened `$PWD` (`~` substitution for `/Users/...` and `/home/...`). Set only if not already defined. |
| `_GET_HOST`             | Command that prints the short hostname (`$HOST` truncated at the first dot). Set only if not already defined.                |
| `TAB_TITLE_PREFIX`      | Common prefix for tab titles: `<host>:<basename-of-PWD><PROMPT_CHAR>`.                                                       |
| `TAB_TITLE_PROMPT`      | Suffix used during prompt redraw — the shell binary name (`$SHELL:t`).                                                       |
| `TAB_TITLE_EXEC`        | Suffix used while a command runs — the command's basename (`$cmd[1]:t`).                                                     |
| `TAB_HARDSTATUS_PREFIX` | Common prefix for hardstatus: `[<full-PWD>] `.                                                                               |
| `TAB_HARDSTATUS_PROMPT` | Hardstatus suffix at the prompt — the shell name.                                                                            |
| `TAB_HARDSTATUS_EXEC`   | Hardstatus suffix while running — the full command line (`$cmd`).                                                            |

Override any of these in `~/.zshrc` before loading the util to customize labels.

## REQUIREMENTS

- GNU `screen` (the module returns silently otherwise).
- The hooks only activate inside an actual screen session (`$TERM == screen*`).

## EXAMPLES

```bash
# Customize the tab title prefix to drop the hostname
TAB_TITLE_PREFIX='"`echo $PWD | sed "s:..*/::"`$PROMPT_CHAR"'
```

## SEE ALSO

- [.docs/aliases/screen](../aliases/screen.md)
- [.docs/plugins/zsh/screen](../plugins/zsh/screen.md)
- [.docs/README.md](../README.md)
