# npm-plugin

## NAME

**npm-plugin** — registers a `compdef` callback that delegates `npm`
completion to `npm completion` at request time.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "npm" ...)
```

## DESCRIPTION

This plugin does not cache a completion script on disk. Instead, it
defines a shell function `_npm_completion` and binds it via `compdef`
so each completion event calls `npm completion` directly with the
current `COMP_*` context. The returned candidates are added via
`compadd`.

The plugin also removes a legacy `${ZSH_CACHE_DIR}/npm_completion`
cache file left over from earlier revisions of this dotfiles
collection, so stale data does not interfere with fresh completions.

Note: there is no NVM bootstrap inside this file. If you use NVM,
ensure `nvm.sh` is sourced from your `~/.zshrc` (or another plugin)
before this one so `command -v npm` succeeds.

## EFFECTS

- Returns immediately if `npm` is not on PATH.
- Removes the legacy cache file
  `${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/npm_completion` if present.
- Defines the function `_npm_completion`.
- Registers it with `compdef _npm_completion npm`.

## FUNCTIONS

- `_npm_completion` — invoked by `compsys` whenever completion is
  requested on the `npm` command. Forwards `BUFFER`, the cursor
  position, and the current word array to `npm completion --` and
  feeds the results to `compadd`.

## ENVIRONMENT

- `ZSH_CACHE_DIR` — used only to locate (and remove) the legacy
  `npm_completion` file. Defaults to `$HOME/.cache/zsh` when unset.

## FILES

- `${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/npm_completion` — legacy cache,
  deleted on every load.
- `.plugins/.zsh/npm/npm.plugin.zsh` — the plugin source.

## REQUIREMENTS

- A working `npm` binary on PATH that understands `npm completion`.
- A zsh with `compdef` available (`compinit` must have been called).

## KEY BINDINGS

None.

## SEE ALSO

- [.docs/aliases/npm](../../aliases/npm.md)
- [.docs/utils/npm](../../utils/npm.md)
- [.docs/README.md](../../README.md)
