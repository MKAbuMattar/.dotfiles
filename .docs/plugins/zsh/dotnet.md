# dotnet-plugin

## NAME

**dotnet-plugin** — dynamic zsh completion for the .NET CLI driven by
`dotnet complete`.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "dotnet" ...)
```

## DESCRIPTION

Rather than caching a completion file, this plugin defines an in-place
completion function that calls `dotnet complete "$words"` at completion time
and feeds the results into `compadd`, falling through to `_files` if `dotnet`
returns nothing. This is the upstream-recommended pattern (originally from
`dotnet/sdk/scripts/register-completions.zsh`).

## EFFECTS

- Returns immediately if `dotnet` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath` (kept for
  consistency with other plugins; no file is written there by this plugin).
- Defines `_dotnet_completion` and registers it via `compdef _dotnet_completion dotnet`.

## FUNCTIONS

| Function             | Purpose                                                                                                                                          |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| `_dotnet_completion` | Calls `dotnet complete "${words}"`, splits the output by line, and feeds it to `compadd`; finishes with `_files` so file completion still works. |

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                              |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Completion cache directory (created/added to fpath). |

## REQUIREMENTS

- `dotnet` on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
