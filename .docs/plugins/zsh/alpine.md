# alpine-plugin

## NAME

**alpine-plugin** — completion wiring for `apk` on Alpine Linux.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "alpine" ...)
```

## DESCRIPTION

A no-op on systems without `apk` on PATH. Otherwise: ensures
`$ZSH_CACHE_DIR/completions/` exists and is on `fpath`, symlinks the
`_apk` completion file (if one is present under `/usr/share/zsh/site-functions/`)
into the cache, and re-runs `compinit`.

Alpine's own `zsh` package does **not** ship a stock `_apk` completion at
present. If you've installed `zsh-completions` (from `community`), it
provides one — this plugin will pick it up. Otherwise it's a benign no-op.

## EFFECTS

- Returns immediately if `apk` is not on PATH.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if unset.
- Creates `$ZSH_CACHE_DIR/completions/` (idempotent).
- Prepends that directory to `$fpath` if not already there.
- Symlinks `/usr/share/zsh/site-functions/_apk` → `$ZSH_CACHE_DIR/completions/_apk`
  when present (also checks `/usr/local/share/zsh/site-functions/`).
- Runs `autoload -Uz compinit && compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read | Set            | Default            | Purpose                              |
| --------------- | ---- | -------------- | ------------------ | ------------------------------------ |
| `ZSH_CACHE_DIR` | Yes  | Yes (if unset) | `$HOME/.cache/zsh` | Root of completion + dump cache      |
| `fpath`         | Yes  | Yes            | (extended)         | Search path for completion functions |

## FILES

| Path                                       | Role                                      |
| ------------------------------------------ | ----------------------------------------- |
| `/usr/share/zsh/site-functions/_apk`       | Optional `apk` completion file (input)    |
| `/usr/local/share/zsh/site-functions/_apk` | Alternate location (input)                |
| `$ZSH_CACHE_DIR/completions/_apk`          | Symlink installed by this plugin (output) |
| `$ZSH_CACHE_DIR/.zcompdump`                | Compiled compinit cache                   |

## REQUIREMENTS

- `apk` on PATH (otherwise plugin no-ops).
- Optional: `zsh-completions` package from Alpine's `community` repo to
  provide the `_apk` completion file.

## SEE ALSO

- [.docs/aliases/alpine](../../aliases/alpine.md)
- [.docs/utils/alpine](../../utils/alpine.md)
- [.docs/plugins/zsh/fedora](fedora.md), [.docs/plugins/zsh/debian](debian.md) — sibling distros
- [.docs/README.md](../../README.md)
