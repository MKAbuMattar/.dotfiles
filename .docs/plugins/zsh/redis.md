# redis-plugin

## NAME

**redis-plugin** — minimal `fpath` registration stub for the
`redis-cli` completion. Bring-your-own `_redis-cli` file.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "redis" ...)
```

## DESCRIPTION

This plugin is deliberately minimal. It does not invoke `redis-cli` to
generate a completion file (Redis upstream does not ship one). Instead
it sets up `$ZSH_CACHE_DIR/completions` and also adds the plugin's own
local `completions/` directory to `fpath` if one is present, so the
user can drop a hand-written `_redis-cli` file alongside the plugin
and have it picked up automatically.

## EFFECTS

- Returns immediately if `redis-cli` is not on PATH.
- Creates `$ZSH_CACHE_DIR/completions` (default `$HOME/.cache/zsh/completions`).
- Prepends that directory to `fpath` once per shell.
- Adds the plugin-local `completions/` directory to `fpath` when it
  exists.

## FUNCTIONS

This plugin defines no user-callable functions.

## ENVIRONMENT

- `ZSH_CACHE_DIR` — base cache directory. Defaults to `$HOME/.cache/zsh`.

## FILES

- `.plugins/.zsh/redis/completions/_redis-cli` — optional, hand-written
  completion script picked up via `fpath` when present.
- `.plugins/.zsh/redis/redis.plugin.zsh` — the plugin source.

## REQUIREMENTS

- A working `redis-cli` binary on PATH (only for the guard; completion
  itself works as long as a `_redis-cli` definition exists in `fpath`).

## KEY BINDINGS

None.

## SEE ALSO

- [.docs/aliases/redis](../../aliases/redis.md)
- [.docs/utils/redis](../../utils/redis.md)
- [.docs/README.md](../../README.md)
