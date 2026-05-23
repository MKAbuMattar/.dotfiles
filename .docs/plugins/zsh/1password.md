# 1password-plugin

## NAME

**1password-plugin** — completion and helpers for the 1Password CLI (`op`).

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "1password" ...)
```

## DESCRIPTION

Loads zsh completion for the 1Password command-line tool (`op`) and, if
available, autoloads the `opswd` helper function. The plugin uses the standard
cache-and-fpath pattern: it asks `op` itself to emit a completion file, stores
it under `$ZSH_CACHE_DIR/completions/_op`, and refreshes it whenever the cached
copy is missing or older than seven days. The plugin is a silent no-op when the
`op` binary is not on `$PATH`.

## EFFECTS

- Returns immediately if `op` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Regenerates `$ZSH_CACHE_DIR/completions/_op` via `op completion zsh` if the
  file is missing or older than 7 days.
- Autoloads the `opswd` function if a sibling file named `opswd` exists next to
  the plugin script.

## FUNCTIONS

| Function | Source                                      | Purpose                                                                    |
| -------- | ------------------------------------------- | -------------------------------------------------------------------------- |
| `opswd`  | autoloaded from `${0:A:h}/opswd` if present | User helper shipped alongside the plugin (typically retrieves a password). |

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                        |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where the generated completion file is stored. |

## FILES

| Path                             | Role                                 |
| -------------------------------- | ------------------------------------ |
| `$ZSH_CACHE_DIR/completions/_op` | Generated zsh completion for `op`.   |
| `${0:A:h}/opswd`                 | Optional autoloaded helper function. |

## REQUIREMENTS

- `op` (1Password CLI) on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
