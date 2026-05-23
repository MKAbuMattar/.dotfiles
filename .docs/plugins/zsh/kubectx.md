# kubectx-plugin

## NAME

**kubectx-plugin** — completion wiring for `kubectx` and `kubens`.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "kubectx" ...)
```

## DESCRIPTION

A no-op on systems without `kubectx` or `kubens` on PATH. Otherwise:
ensures `$ZSH_CACHE_DIR/completions/` exists and is on `fpath`, symlinks
the stock `_kubectx` and `_kubens` completion files (whichever locations
exist — Linux `/usr/share`, `/usr/local/share`, or Homebrew
`/opt/homebrew/share`) into the cache, and re-runs `compinit`.

`kubectx` and `kubens` already detect `fzf` at runtime and present a
fuzzy picker when invoked without arguments — no extra wiring is needed
for that.

## EFFECTS

- Returns immediately if neither `kubectx` nor `kubens` is on PATH.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` (idempotent).
- Prepends that directory to `$fpath` if not already there.
- Symlinks `_kubectx` from the first existing system location into the cache.
- Symlinks `_kubens` likewise.
- Runs `autoload -Uz compinit && compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read | Set            | Default            | Purpose                              |
| --------------- | ---- | -------------- | ------------------ | ------------------------------------ |
| `ZSH_CACHE_DIR` | Yes  | Yes (if unset) | `$HOME/.cache/zsh` | Root of completion + dump cache.     |
| `fpath`         | Yes  | Yes            | (extended)         | Search path for completion functions. |

## FILES

| Path                                                | Role                                         |
| --------------------------------------------------- | -------------------------------------------- |
| `/usr/share/zsh/site-functions/_kubectx`            | Stock completion (Linux, input).             |
| `/usr/local/share/zsh/site-functions/_kubectx`      | Alternate (Linux/manual install, input).     |
| `/opt/homebrew/share/zsh/site-functions/_kubectx`   | Homebrew (Apple Silicon, input).             |
| `/usr/share/zsh/site-functions/_kubens`             | Stock completion (input).                    |
| `/usr/local/share/zsh/site-functions/_kubens`       | Alternate (input).                           |
| `/opt/homebrew/share/zsh/site-functions/_kubens`    | Homebrew (input).                            |
| `$ZSH_CACHE_DIR/completions/_kubectx`               | Symlink installed by this plugin (output).   |
| `$ZSH_CACHE_DIR/completions/_kubens`                | Symlink installed by this plugin (output).   |
| `$ZSH_CACHE_DIR/.zcompdump`                         | Compiled compinit cache.                     |

## REQUIREMENTS

- `kubectx` and/or `kubens` on PATH.
- Optional: `fzf` on PATH for the interactive picker (detected automatically).

## SEE ALSO

- [.docs/aliases/kubectx](../../aliases/kubectx.md)
- [.docs/plugins/zsh/kubectl-fzf](kubectl-fzf.md) — fuzzy completion for `kubectl` itself
- [.docs/README.md](../../README.md)
