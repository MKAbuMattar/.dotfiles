# deno-plugin

## NAME

**deno-plugin** — zsh completion for the Deno runtime CLI.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "deno" ...)
```

## DESCRIPTION

Generates and caches zsh completion for `deno` by invoking
`deno completions zsh`. The cached file lives at
`$ZSH_CACHE_DIR/completions/_deno` and is refreshed whenever it is missing or
older than seven days.

## EFFECTS

- Returns immediately if `deno` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Regenerates `$ZSH_CACHE_DIR/completions/_deno` via `deno completions zsh` if
  the file is missing or older than 7 days.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                        |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where the generated completion file is stored. |

## FILES

| Path                               | Role                                 |
| ---------------------------------- | ------------------------------------ |
| `$ZSH_CACHE_DIR/completions/_deno` | Generated zsh completion for `deno`. |

## REQUIREMENTS

- `deno` on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
