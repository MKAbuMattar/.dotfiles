# argocd-plugin

## NAME

**argocd-plugin** — zsh completion for the Argo CD CLI.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "argocd" ...)
```

## DESCRIPTION

Installs zsh completion for the `argocd` CLI by asking the binary itself to
emit a completion script (`argocd completion zsh`) and caching it under
`$ZSH_CACHE_DIR/completions/_argocd`. The cached file is refreshed whenever it
is missing or older than seven days. No helper functions or prompt segments
are defined.

## EFFECTS

- Returns immediately if `argocd` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Regenerates `$ZSH_CACHE_DIR/completions/_argocd` via `argocd completion zsh`
  if the file is missing or older than 7 days.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                        |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where the generated completion file is stored. |

## FILES

| Path                                 | Role                                   |
| ------------------------------------ | -------------------------------------- |
| `$ZSH_CACHE_DIR/completions/_argocd` | Generated zsh completion for `argocd`. |

## REQUIREMENTS

- `argocd` on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
