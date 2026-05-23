# ripgrep-plugin

## NAME

**ripgrep-plugin** — completion wiring and config-file path for `rg`.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "ripgrep" ...)
```

## DESCRIPTION

A no-op on systems without `rg` on PATH. Otherwise: ensures
`$ZSH_CACHE_DIR/completions/` exists and is on `fpath`, symlinks the
stock `_rg` completion file (ripgrep ships one) into the cache, exports
`RIPGREP_CONFIG_PATH` to `~/.config/ripgreprc` (only when unset) so user
defaults are picked up automatically, and re-runs `compinit`.

## EFFECTS

- Returns immediately if `rg` is not on PATH.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` (idempotent).
- Prepends that directory to `$fpath` if not already there.
- Symlinks `_rg` from `/usr/share/zsh/site-functions/` (or `/usr/local/...`)
  into the cache dir.
- Exports `RIPGREP_CONFIG_PATH=$HOME/.config/ripgreprc` if unset.
- Runs `autoload -Uz compinit && compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable              | Read | Set            | Default                  | Purpose                                  |
| --------------------- | ---- | -------------- | ------------------------ | ---------------------------------------- |
| `RIPGREP_CONFIG_PATH` | Yes  | Yes (if unset) | `$HOME/.config/ripgreprc` | Per-user `rg` defaults file.            |
| `ZSH_CACHE_DIR`       | Yes  | Yes (if unset) | `$HOME/.cache/zsh`       | Root of completion + dump cache.         |
| `fpath`               | Yes  | Yes            | (extended)               | Search path for completion functions.    |

## FILES

| Path                                      | Role                                         |
| ----------------------------------------- | -------------------------------------------- |
| `/usr/share/zsh/site-functions/_rg`       | Stock completion file (input).               |
| `/usr/local/share/zsh/site-functions/_rg` | Alternate location (input).                  |
| `$ZSH_CACHE_DIR/completions/_rg`          | Symlink installed by this plugin (output).   |
| `$RIPGREP_CONFIG_PATH`                    | Optional ripgrep config (one flag per line). |
| `$ZSH_CACHE_DIR/.zcompdump`               | Compiled compinit cache.                     |

## REQUIREMENTS

- `rg` on PATH.

## SEE ALSO

- [.docs/aliases/ripgrep](../../aliases/ripgrep.md)
- [.docs/README.md](../../README.md)
