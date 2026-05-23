# keybindings

## NAME

**keybindings** — Emacs-style line editor bindings + cursor-key normalization.

## SYNOPSIS

Sourced automatically by [`~/.zshrc`](../../.zshrc) after `completion.zsh`:

```text
source $HOME/.config/.dotfiles/.zsh/keybindings.zsh
```

## DESCRIPTION

Sets ZLE to the emacs keymap and then wires terminal-specific escape sequences
(read from `$terminfo`) to standard movement and history actions, so the
bindings work identically across xterm, Konsole, Kitty, iTerm2, Ghostty, GNU
screen, tmux, etc. — even when each terminal sends a different escape
sequence for the same key.

For each binding it also applies under the `viins` and `vicmd` keymaps so
users who later switch with `bindkey -v` get the same behavior.

## KEYMAP

`bindkey -e` — emacs keymap (default).

## KEY BINDINGS

| Key         | Action                                  | Source                       |
| ----------- | --------------------------------------- | ---------------------------- |
| `PageUp`    | History line up                         | `terminfo[kpp]`              |
| `PageDown`  | History line down                       | `terminfo[knp]`              |
| `↑`         | Fuzzy history search backward by prefix | `terminfo[kcuu1]` + autoload |
| `↓`         | Fuzzy history search forward by prefix  | `terminfo[kcud1]` + autoload |
| `Home`      | Beginning of line                       | `terminfo[khome]`            |
| `End`       | End of line                             | `terminfo[kend]`             |
| `Shift+Tab` | Reverse menu completion                 | `terminfo[kcbt]`             |
| `Backspace` | `backward-delete-char`                  | `^?`                         |
| `Delete`    | `delete-char`                           | `terminfo[kdch1]` or `^[[3~` |
| `Ctrl+←`    | Move backward one word                  | `terminfo[kLFT5]`            |
| `Ctrl+→`    | Move forward one word                   | `terminfo[kRIT5]`            |
| `Alt+←`     | Move backward one word                  | `terminfo[kLFT3]`            |
| `Alt+→`     | Move forward one word                   | `terminfo[kRIT3]`            |

All bindings are applied to three keymaps: `emacs`, `viins`, `vicmd`.

## APPLICATION MODE

When the terminfo entries `smkx`/`rmkx` exist, the script registers ZLE hooks
that switch the terminal in/out of "application mode" each time the editor
opens or closes.

```text
zle-line-init   → echoti smkx       (enter application mode)
zle-line-finish → echoti rmkx       (leave application mode)
```

## CUSTOM WIDGETS

- `up-line-or-beginning-search` (autoloaded) — bound to `↑`.
- `down-line-or-beginning-search` (autoloaded) — bound to `↓`.

## ENVIRONMENT

| Variable   | Read | Set | Notes                                        |
| ---------- | ---- | --- | -------------------------------------------- |
| `terminfo` | Yes  | No  | Provided by zsh; queried for each capability |
| `key`     | No   | Yes | `typeset -g -A key` — internal binding table  |

## FILES

None. Pure ZLE configuration.

## SEE ALSO

- `zshzle(1)`
- [zsh-core/options](options.md)
- [zsh-core/completion](completion.md)
- [.docs/README.md](../README.md)
