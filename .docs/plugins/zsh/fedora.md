# fedora-plugin

## NAME

**fedora-plugin** — completion wiring for `dnf` / `dnf5` on Fedora and RHEL-based distributions.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "fedora" ...)
```

## DESCRIPTION

A no-op on systems without `dnf` or `dnf5` on PATH. Otherwise: ensures
`$ZSH_CACHE_DIR/completions/` exists and is on `fpath`, symlinks the
system-provided `_dnf` (and `_dnf5` when applicable) completion file from
`/usr/share/zsh/site-functions/` into the cache directory, then re-runs
`compinit` against `$ZSH_CACHE_DIR/.zcompdump` so the new completions
become active immediately.

## EFFECTS

- Returns immediately if neither `dnf` nor `dnf5` is on PATH.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` (idempotent).
- Prepends that directory to `$fpath` if not already there.
- Symlinks `/usr/share/zsh/site-functions/_dnf` → `$ZSH_CACHE_DIR/completions/_dnf`
  (also checks `/usr/local/share/zsh/site-functions/`).
- If `dnf5` is on PATH, also symlinks `_dnf5` the same way.
- Runs `autoload -Uz compinit && compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read | Set            | Default            | Purpose                              |
| --------------- | ---- | -------------- | ------------------ | ------------------------------------ |
| `ZSH_CACHE_DIR` | Yes  | Yes (if unset) | `$HOME/.cache/zsh` | Root of completion + dump cache      |
| `fpath`         | Yes  | Yes            | (extended)         | Search path for completion functions |

## FILES

| Path                                              | Role                                     |
| ------------------------------------------------- | ---------------------------------------- |
| `/usr/share/zsh/site-functions/_dnf`              | System-provided dnf completion (input)   |
| `/usr/local/share/zsh/site-functions/_dnf`        | Alternate location (input)               |
| `$ZSH_CACHE_DIR/completions/_dnf`                 | Symlink installed by this plugin (output) |
| `$ZSH_CACHE_DIR/completions/_dnf5`                | Same, for dnf5 when present              |
| `$ZSH_CACHE_DIR/.zcompdump`                       | Compiled compinit cache                  |

## REQUIREMENTS

- `dnf` or `dnf5` on PATH (otherwise plugin no-ops).
- A system-installed `_dnf` completion file (Fedora ships one in the
  `dnf-data` or `zsh` package).

## SEE ALSO

- [.docs/aliases/fedora](../../aliases/fedora.md)
- [.docs/utils/fedora](../../utils/fedora.md)
- [.docs/plugins/zsh/debian](debian.md), [.docs/plugins/zsh/arch](arch.md) — sibling distros
- [.docs/README.md](../../README.md)
