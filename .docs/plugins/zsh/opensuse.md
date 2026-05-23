# opensuse-plugin

## NAME

**opensuse-plugin** — completion wiring for `zypper` on openSUSE and SLES.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "opensuse" ...)
```

## DESCRIPTION

A no-op on systems without `zypper` on PATH. Otherwise: ensures
`$ZSH_CACHE_DIR/completions/` exists and is on `fpath`, symlinks the
system-provided `_zypper` completion from `/usr/share/zsh/site-functions/`
into the cache directory, and re-runs `compinit` against
`$ZSH_CACHE_DIR/.zcompdump` so the completions become active immediately.

## EFFECTS

- Returns immediately if `zypper` is not on PATH.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` (idempotent).
- Prepends that directory to `$fpath` if not already there.
- Symlinks `/usr/share/zsh/site-functions/_zypper` → `$ZSH_CACHE_DIR/completions/_zypper`
  (also checks `/usr/local/share/zsh/site-functions/`).
- Runs `autoload -Uz compinit && compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read | Set            | Default            | Purpose                              |
| --------------- | ---- | -------------- | ------------------ | ------------------------------------ |
| `ZSH_CACHE_DIR` | Yes  | Yes (if unset) | `$HOME/.cache/zsh` | Root of completion + dump cache      |
| `fpath`         | Yes  | Yes            | (extended)         | Search path for completion functions |

## FILES

| Path                                          | Role                                      |
| --------------------------------------------- | ----------------------------------------- |
| `/usr/share/zsh/site-functions/_zypper`       | System-provided zypper completion (input) |
| `/usr/local/share/zsh/site-functions/_zypper` | Alternate location (input)                |
| `$ZSH_CACHE_DIR/completions/_zypper`          | Symlink installed by this plugin (output) |
| `$ZSH_CACHE_DIR/.zcompdump`                   | Compiled compinit cache                   |

## REQUIREMENTS

- `zypper` on PATH (otherwise plugin no-ops).
- The `zypper` completion file under `/usr/share/zsh/site-functions/`
  (shipped by the `zsh` package on openSUSE).

## SEE ALSO

- [.docs/aliases/opensuse](../../aliases/opensuse.md)
- [.docs/utils/opensuse](../../utils/opensuse.md)
- [.docs/plugins/zsh/fedora](fedora.md), [.docs/plugins/zsh/debian](debian.md) — sibling distros
- [.docs/README.md](../../README.md)
