# arch-plugin

## NAME

**arch-plugin** — completion wiring for `pacman` and common AUR helpers on
Arch-based systems.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "arch" ...)
```

## DESCRIPTION

Targets Arch-based distributions. The plugin no-ops if `pacman` is not on
`$PATH`. Otherwise it sets up `$ZSH_CACHE_DIR/completions/` and symlinks the
system-provided zsh completion scripts for `pacman`, and for the AUR helpers
`yay` and `paru` when each is installed. Existing system completions in
`/usr/share/zsh/site-functions/` or `/usr/local/share/zsh/site-functions/` are
preferred — the plugin does not regenerate them, only links them into the user
cache. Completion is then reloaded via `compinit`.

## EFFECTS

- Returns immediately if `pacman` is not on `$PATH` (non-Arch systems).
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Symlinks `_pacman` from the first matching system location into the cache.
- If `yay` is on `$PATH`, symlinks `_yay` similarly.
- If `paru` is on `$PATH`, symlinks `_paru` similarly.
- Runs `autoload -Uz compinit; compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                          |
| --------------- | ------------------------- | ------------------ | ------------------------------------------------ |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where completion symlinks and the compdump live. |

## FILES

| Path                                          | Role                                                  |
| --------------------------------------------- | ----------------------------------------------------- |
| `$ZSH_CACHE_DIR/completions/_pacman`          | Symlink to system `_pacman` completion.               |
| `$ZSH_CACHE_DIR/completions/_yay`             | Symlink to system `_yay` (only if `yay` installed).   |
| `$ZSH_CACHE_DIR/completions/_paru`            | Symlink to system `_paru` (only if `paru` installed). |
| `$ZSH_CACHE_DIR/.zcompdump`                   | Compinit dump file.                                   |
| `/usr/share/zsh/site-functions/_pacman`       | Source completion (Arch package).                     |
| `/usr/local/share/zsh/site-functions/_pacman` | Source completion (manual install).                   |

## REQUIREMENTS

- `pacman` on `$PATH`. The plugin no-ops otherwise.
- One of the listed system completion files must exist for the corresponding
  symlink to be created.

## SEE ALSO

- [.docs/aliases/arch.md](../../aliases/arch.md)
- [.docs/README.md](../../README.md)
