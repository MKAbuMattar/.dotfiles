# options

## NAME

**options** — shell behavior, globbing, MANPATH wiring, and history configuration for zsh.

## SYNOPSIS

Sourced automatically by [`~/.zshrc`](../../.zshrc) before any util, plugin, or
alias module:

```text
source $HOME/.config/.dotfiles/.zsh/options.zsh
```

## DESCRIPTION

Centralizes shell options, MANPATH for the dotfiles man-page system, and
history-file logic. Three concerns live here:

1. **MANPATH** — prepends `$HOME/.config/.dotfiles/.man` so `man <module>` and
   `apropos <keyword>` resolve dotfiles pages.
2. **Interactive shell options** — autocorrect, globbing, beep, autocd, `pushd` stack.
3. **History** — file path (with per-terminal-app split), size, dedup behavior, sharing.

## ZSH OPTIONS

### General shell behavior

| Option              | Effect                                                             |
| ------------------- | ------------------------------------------------------------------ |
| `correct`           | Suggest a correction when a typo'd command might mean another one. |
| `extendedglob`      | Enable extended globbing (`^`, `~`, `#`, etc).                     |
| `nocaseglob`        | Case-insensitive globbing.                                         |
| `rcexpandparam`     | Array expansion with parameters.                                   |
| `nocheckjobs`       | Don't warn about background jobs on exit.                          |
| `numericglobsort`   | Sort numerically when globs contain numbers.                       |
| `nobeep`            | Silence terminal bell.                                             |
| `autocd`            | Bare directory path → `cd` into it.                                |
| `auto_pushd`        | Each `cd` pushes the prior dir onto the stack.                     |
| `pushd_ignore_dups` | Don't push duplicate entries.                                      |
| `pushdminus`        | Swap `+`/`-` semantics for `cd ~+N`/`cd ~-N`.                      |

### History

| Option                   | Effect                                                |
| ------------------------ | ----------------------------------------------------- |
| `appendhistory`          | Append on exit instead of overwriting.                |
| `histignorealldups`      | Drop older duplicates from the history list.          |
| `SHARE_HISTORY`          | Share history live between concurrent shells.         |
| `HIST_IGNORE_DUPS`       | Don't record a command identical to the previous one. |
| `HIST_IGNORE_ALL_DUPS`   | Across the entire history.                            |
| `HIST_REDUCE_BLANKS`     | Compress runs of whitespace.                          |
| `INC_APPEND_HISTORY`     | Write each command as soon as it's typed.             |
| `HIST_VERIFY`            | Recalls expand via `!!` to a prompt for confirmation. |
| `HIST_FIND_NO_DUPS`      | Skip dupes when searching history.                    |
| `HIST_SAVE_NO_DUPS`      | Skip dupes when writing the history file.             |
| `HIST_EXPIRE_DUPS_FIRST` | When history overflows, drop dupes before uniques.    |

History size: `HISTSIZE=SAVEHIST=10,000,000`.

## FUNCTIONS

### `set_app_history`

Picks the active `$HISTFILE` based on the terminal emulator.

| Condition                              | `HISTFILE`                                     |
| -------------------------------------- | ---------------------------------------------- |
| `$TERM_PROGRAM` == `Ghostty` on Linux  | `$HOME/.zsh/.zsh_history` (shared)             |
| `$TERM_PROGRAM` == `Apple_Terminal`    | `$HOME/.zsh/.zsh_history` (shared)             |
| Anything else (incl. iTerm2, Kitty, …) | `$HOME/.zsh/.zsh_history_<APP>` (per-terminal) |

App names are sanitized: non-alphanumerics → `_`.

## ENVIRONMENT

| Variable       | Read | Set | Notes                                       |
| -------------- | ---- | --- | ------------------------------------------- |
| `TERM_PROGRAM` | Yes  | No  | Used by `set_app_history` to pick the file. |
| `HISTFILE`     | No   | Yes | Exported.                                   |
| `HISTSIZE`     | No   | Set | `10000000`                                  |
| `SAVEHIST`     | No   | Set | `10000000`                                  |
| `MANPATH`      | Yes  | Yes | Prepends `$HOME/.config/.dotfiles/.man`     |

## FILES

| Path                            | Role                             |
| ------------------------------- | -------------------------------- |
| `$HOME/.zsh/.zsh_history`       | Default + Apple_Terminal/Ghostty |
| `$HOME/.zsh/.zsh_history_<APP>` | Per-app variants                 |

## SEE ALSO

- `zshoptions(1)`, `zshparam(1)`
- [zsh-core/completion](completion.md)
- [zsh-core/keybindings](keybindings.md)
- [.docs/README.md](../README.md)
