# completion

## NAME

**completion** — initialize the zsh completion system with a shared cache directory.

## SYNOPSIS

Sourced automatically by [`~/.zshrc`](../../.zshrc) immediately after
`options.zsh`:

```text
source $HOME/.config/.dotfiles/.zsh/completion.zsh
```

## DESCRIPTION

Bootstraps the completion subsystem so individual plugins don't each need to
do it. After sourcing:

- `$ZSH_CACHE_DIR/completions/` is on `$fpath`.
- `compinit` has run, so per-plugin `compdef` calls work.
- `bashcompinit` is loaded for plugins that ship bash completion only.
- Sensible `zstyle` defaults are set.

## EFFECTS

- Sets `ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` (idempotent).
- Prepends that directory to `$fpath`.
- Runs `autoload -Uz compinit && compinit`.
- Runs `autoload -U +X bashcompinit && bashcompinit`.

## ZSTYLE SETTINGS

| Style pattern                         | Value                                     | Effect                                               |
| ------------------------------------- | ----------------------------------------- | ---------------------------------------------------- |
| `:completion:*` `matcher-list`        | `'m:{a-zA-Z}={A-Za-z}'`                   | Case-insensitive tab completion                      |
| `:completion:*` `rehash`              | `true`                                    | Auto-detect newly installed executables on `$PATH`   |
| `:completion:*` `list-colors`         | `"${(s.:.)LS_COLORS}"`                    | Color dirs/files/etc using `$LS_COLORS`              |
| `:completion:*` `completer`           | `_expand _complete _ignored _approximate` | Order of completion attempts                         |
| `:completion:*` `menu`                | `select`                                  | Use selectable menu rather than just listing         |
| `:completion:*:descriptions` `format` | `'%U%F{cyan}%d%f%u'`                      | Underlined cyan group headers                        |
| `:completion:*` `accept-exact`        | `'*(N)'`                                  | Skip approx matching when an exact glob match exists |
| `:completion:*` `use-cache`           | `on`                                      | Cache results to disk                                |
| `:completion:*` `cache-path`          | `~/.cache/zcache`                         | Where to put the cache                               |

## ENVIRONMENT

| Variable        | Read | Set            | Default                  | Purpose                              |
| --------------- | ---- | -------------- | ------------------------ | ------------------------------------ |
| `ZSH_CACHE_DIR` | Yes  | Yes (if unset) | `$HOME/.cache/zsh`       | Root of completion + dump cache      |
| `LS_COLORS`     | Yes  | No             | (whatever your env sets) | Colorizes match lists                |
| `fpath`         | Yes  | Yes            | (extended)               | Search path for completion functions |

## FILES

| Path                          | Role                                             |
| ----------------------------- | ------------------------------------------------ |
| `$ZSH_CACHE_DIR/completions/` | Per-plugin completion files (e.g. `_kubectl`)    |
| `$ZSH_CACHE_DIR/.zcompdump`   | Hash of registered compdefs (regenerated lazily) |
| `~/.cache/zcache`             | On-disk result cache (`use-cache on`)            |

## SEE ALSO

- `zshcompsys(1)`
- [zsh-core/options](options.md)
- [zsh-core/keybindings](keybindings.md)
- [.docs/README.md](../README.md)
