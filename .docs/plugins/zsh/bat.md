# bat-plugin

## NAME

**bat-plugin** — default theme + style for `bat`, and a colourised `man` pager.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "bat" ...)
```

## DESCRIPTION

Wires `bat` (or `batcat` on Debian/Ubuntu) into the interactive shell:
exports a default `BAT_THEME` and `BAT_STYLE` (only when the user hasn't
already set them), turns `man(1)` into a colourised, headered view via
`MANPAGER`, and symlinks the system-installed `_bat` zsh completion into
`$ZSH_CACHE_DIR/completions/` so completions are available without extra
configuration. No-ops if neither binary is present.

## EFFECTS

- Returns immediately if neither `bat` nor `batcat` is on PATH.
- Exports `BAT_THEME=ansi` and `BAT_STYLE=numbers,changes,header` if unset.
- Exports `MANPAGER` to pipe `man` through `col -bx | bat -l man -p`
  (uses `batcat` automatically when that's the available binary).
- Exports `MANROFFOPT="-c"` (required when `man` output goes through `col`).
- Ensures `$ZSH_CACHE_DIR/completions/` exists and is on `$fpath`.
- Symlinks `_bat` from `/usr/share/zsh/site-functions/` (or `/usr/local/...`)
  into the cache dir.
- Runs `autoload -Uz compinit && compinit -d "$ZSH_CACHE_DIR/.zcompdump"`.

## ENVIRONMENT

| Variable        | Read | Set            | Default                       | Purpose                                   |
| --------------- | ---- | -------------- | ----------------------------- | ----------------------------------------- |
| `BAT_THEME`     | Yes  | Yes (if unset) | `ansi`                        | Syntax-highlighting colour theme.         |
| `BAT_STYLE`     | Yes  | Yes (if unset) | `numbers,changes,header`      | Decorations rendered around output.       |
| `MANPAGER`      | -    | Yes            | `sh -c 'col -bx \| bat -l man -p'` | Colourises `man(1)` via `bat`.       |
| `MANROFFOPT`    | -    | Yes            | `-c`                          | Tells groff to be `col`-friendly.         |
| `ZSH_CACHE_DIR` | Yes  | Yes (if unset) | `$HOME/.cache/zsh`            | Root of completion + dump cache.          |
| `fpath`         | Yes  | Yes            | (extended)                    | Search path for completion functions.     |

## FILES

| Path                                       | Role                                      |
| ------------------------------------------ | ----------------------------------------- |
| `/usr/share/zsh/site-functions/_bat`       | Stock completion file (input)             |
| `/usr/local/share/zsh/site-functions/_bat` | Alternate location (input)                |
| `$ZSH_CACHE_DIR/completions/_bat`          | Symlink installed by this plugin (output) |
| `$ZSH_CACHE_DIR/.zcompdump`                | Compiled compinit cache                   |

## REQUIREMENTS

- `bat` (Fedora/Arch/macOS) or `batcat` (Debian/Ubuntu) on PATH.
- For the `MANPAGER` integration: `col` (in `util-linux`) and `groff`.

## SEE ALSO

- [.docs/aliases/bat](../../aliases/bat.md)
- [.docs/README.md](../../README.md)
