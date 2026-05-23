# fd-plugin

## NAME

**fd-plugin** — completion wiring for the `fd` / `fdfind` file-finder.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "fd" ...)
```

## DESCRIPTION

A no-op on systems without `fd` (or its Debian/Ubuntu alias `fdfind`) on
PATH. Otherwise: ensures `$ZSH_CACHE_DIR/completions/` exists and is on
`fpath`, symlinks the stock `_fd` completion into the cache, and re-runs
`compinit`. The plugin handles only completion plumbing — env vars and
the binary-name shim live in the matching aliases module.

## EFFECTS

- Returns immediately if neither `fd` nor `fdfind` is on PATH.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` (idempotent).
- Prepends that directory to `$fpath` if not already there.
- Symlinks `_fd` from `/usr/share/zsh/site-functions/` (or `/usr/local/...`)
  into the cache dir.
- Runs `autoload -Uz compinit && compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read | Set            | Default            | Purpose                              |
| --------------- | ---- | -------------- | ------------------ | ------------------------------------ |
| `ZSH_CACHE_DIR` | Yes  | Yes (if unset) | `$HOME/.cache/zsh` | Root of completion + dump cache.     |
| `fpath`         | Yes  | Yes            | (extended)         | Search path for completion functions. |

## FILES

| Path                                      | Role                                       |
| ----------------------------------------- | ------------------------------------------ |
| `/usr/share/zsh/site-functions/_fd`       | Stock completion file (input).             |
| `/usr/local/share/zsh/site-functions/_fd` | Alternate location (input).                |
| `$ZSH_CACHE_DIR/completions/_fd`          | Symlink installed by this plugin (output). |
| `$ZSH_CACHE_DIR/.zcompdump`               | Compiled compinit cache.                   |

## REQUIREMENTS

- `fd` (Fedora/Arch/macOS) or `fdfind` (Debian/Ubuntu) on PATH.

## SEE ALSO

- [.docs/aliases/fd](../../aliases/fd.md)
- [.docs/README.md](../../README.md)
