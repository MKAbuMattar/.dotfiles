# doctl-plugin

## NAME

**doctl-plugin** — zsh completion for the DigitalOcean CLI.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "doctl" ...)
```

## DESCRIPTION

Generates and caches zsh completion for `doctl` by invoking
`doctl completion zsh`. The cached file lives at
`$ZSH_CACHE_DIR/completions/_doctl` and is refreshed whenever it is missing or
older than seven days.

## EFFECTS

- Returns immediately if `doctl` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Regenerates `$ZSH_CACHE_DIR/completions/_doctl` via `doctl completion zsh`
  if the file is missing or older than 7 days.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                        |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where the generated completion file is stored. |

## FILES

| Path                                | Role                                  |
| ----------------------------------- | ------------------------------------- |
| `$ZSH_CACHE_DIR/completions/_doctl` | Generated zsh completion for `doctl`. |

## REQUIREMENTS

- `doctl` on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
