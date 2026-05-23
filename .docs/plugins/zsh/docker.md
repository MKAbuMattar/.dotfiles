# docker-plugin

## NAME

**docker-plugin** — zsh completion for Docker, with a vendored fallback.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "docker" ...)
```

## DESCRIPTION

Sets up zsh completion for `docker` with the following priority. When the
cached file is missing or older than seven days the plugin first looks for a
vendored copy at `<plugin-dir>/completions/_docker`; if present it is copied
into the cache. Otherwise, when the installed Docker is at least version
23.0.0, `docker completion zsh` is used to generate fresh completion. On
older Docker versions no automatic generation happens and the vendored copy
(if any) is the only source.

## EFFECTS

- Returns immediately if `docker` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Performs the standard `0=` self-path normalization so `${0:h}` resolves to
  the plugin directory.
- If `$ZSH_CACHE_DIR/completions/_docker` is missing or older than 7 days:
  - Copies `<plugin-dir>/completions/_docker` into the cache if it exists.
  - Otherwise, when `docker --version` reports >= 23.0.0, runs
    `docker completion zsh` and writes the result to the cache.

## ENVIRONMENT

| Variable        | Read/Set                  | Default            | Purpose                                        |
| --------------- | ------------------------- | ------------------ | ---------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted if unset) | `$HOME/.cache/zsh` | Where the generated completion file is stored. |

## FILES

| Path                                 | Role                                                      |
| ------------------------------------ | --------------------------------------------------------- |
| `$ZSH_CACHE_DIR/completions/_docker` | Active zsh completion for `docker`.                       |
| `<plugin-dir>/completions/_docker`   | Optional vendored fallback used on older Docker versions. |

## REQUIREMENTS

- `docker` on `$PATH`. The plugin no-ops otherwise.
- Docker >= 23.0.0 for automatic generation; older versions rely on the
  vendored file.

## SEE ALSO

- [.docs/README.md](../../README.md)
