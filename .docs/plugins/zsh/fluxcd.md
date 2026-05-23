# fluxcd-plugin

## NAME

**fluxcd-plugin** — zsh completion for the Flux CD CLI (`flux`).

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "fluxcd" ...)
```

## DESCRIPTION

Generates and caches zsh completion for `flux` by invoking
`flux completion zsh`. The cached file lives at
`$ZSH_CACHE_DIR/completions/_flux` and is refreshed whenever it is missing or
older than seven days.

## EFFECTS

- Returns immediately if `flux` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Regenerates `$ZSH_CACHE_DIR/completions/_flux` via `flux completion zsh` if
  the file is missing or older than 7 days.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                        |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where the generated completion file is stored. |

## FILES

| Path                               | Role                                 |
| ---------------------------------- | ------------------------------------ |
| `$ZSH_CACHE_DIR/completions/_flux` | Generated zsh completion for `flux`. |

## REQUIREMENTS

- `flux` on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
