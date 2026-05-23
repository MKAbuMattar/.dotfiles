# tmux-plugin

## NAME

**tmux-plugin** — completion wiring for `tmux`.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "tmux" ...)
```

## DESCRIPTION

Loads zsh completion for `tmux`. The plugin no-ops if `tmux` is not on `$PATH`. Otherwise it makes sure `$ZSH_CACHE_DIR/completions/` exists and is on `fpath`, then symlinks the system-provided `_tmux` completion script into the cache so it sits alongside the other framework completions. The plugin probes two well-known locations (`/usr/share/zsh/site-functions/_tmux` and `/usr/local/share/zsh/site-functions/_tmux`) and links the first one it finds. Completion is then reloaded via `compinit`.

## EFFECTS

- Returns immediately when `tmux` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath` (if not already present).
- Probes `/usr/share/zsh/site-functions/_tmux` then `/usr/local/share/zsh/site-functions/_tmux`; symlinks the first that exists into `$ZSH_CACHE_DIR/completions/_tmux`, only if the target does not already exist.
- Runs `autoload -Uz compinit; compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                          |
| --------------- | ------------------------- | ------------------ | ------------------------------------------------ |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where completion symlinks and the compdump live. |

## FILES

| Path                                            | Role                                                  |
| ----------------------------------------------- | ----------------------------------------------------- |
| `$ZSH_CACHE_DIR/completions/_tmux`              | Symlink to the system `_tmux` completion script.      |
| `$ZSH_CACHE_DIR/.zcompdump`                     | Compinit dump file.                                   |
| `/usr/share/zsh/site-functions/_tmux`           | Source completion (distro package).                   |
| `/usr/local/share/zsh/site-functions/_tmux`     | Source completion (manual install / Homebrew).        |

## REQUIREMENTS

- `tmux` on `$PATH`. The plugin no-ops otherwise.
- One of the listed system `_tmux` files must exist for the symlink to be created. If neither is present the plugin still re-runs `compinit` but no tmux completion is installed.

## SEE ALSO

- [.docs/aliases/tmux](../../aliases/tmux.md)
- [.docs/utils/tmux](../../utils/tmux.md)
- [.docs/README.md](../../README.md)
