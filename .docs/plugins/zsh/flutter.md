# flutter-plugin

## NAME

**flutter-plugin** — zsh completion for the Flutter SDK CLI.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "flutter" ...)
```

## DESCRIPTION

Generates and caches zsh completion for `flutter` by invoking
`flutter zsh-completion` with stdin redirected from `/dev/null` (some Flutter
versions try to read from the terminal otherwise). The cached file lives at
`$ZSH_CACHE_DIR/completions/_flutter` and is refreshed whenever it is missing
or older than seven days.

## EFFECTS

- Returns immediately if `flutter` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Regenerates `$ZSH_CACHE_DIR/completions/_flutter` via
  `flutter zsh-completion < /dev/null` if the file is missing or older than
  7 days.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                        |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where the generated completion file is stored. |

## FILES

| Path                                  | Role                                    |
| ------------------------------------- | --------------------------------------- |
| `$ZSH_CACHE_DIR/completions/_flutter` | Generated zsh completion for `flutter`. |

## REQUIREMENTS

- `flutter` on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
