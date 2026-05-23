# bun-plugin

## NAME

**bun-plugin** — zsh completion for the Bun JavaScript runtime/package manager.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "bun" ...)
```

## DESCRIPTION

Generates and caches zsh completion for `bun` by invoking
`SHELL=zsh bun completions`. The cached file lives at
`$ZSH_CACHE_DIR/completions/_bun` and is refreshed whenever it is missing or
older than seven days.

## EFFECTS

- Returns immediately if `bun` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Regenerates `$ZSH_CACHE_DIR/completions/_bun` via
  `SHELL=zsh bun completions` if the file is missing or older than 7 days.

## ENVIRONMENT

| Variable        | Read/Set                                  | Default            | Purpose                                        |
| --------------- | ----------------------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset)                 | `$HOME/.cache/zsh` | Where the generated completion file is stored. |
| `SHELL`         | Set inline for the `bun completions` call | —                  | Forces Bun to emit zsh completion.             |

## FILES

| Path                              | Role                                |
| --------------------------------- | ----------------------------------- |
| `$ZSH_CACHE_DIR/completions/_bun` | Generated zsh completion for `bun`. |

## REQUIREMENTS

- `bun` on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
