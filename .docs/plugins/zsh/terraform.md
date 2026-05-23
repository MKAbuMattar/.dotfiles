# terraform-plugin

## NAME

**terraform-plugin** — registers the HashiCorp `terraform` autocomplete
helper via `terraform -install-autocomplete`.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "terraform" ...)
```

## DESCRIPTION

Terraform's CLI completion is unusual: rather than emitting a `_compsys`
script, it expects to install a `complete -C terraform terraform` entry
into the user's shell rc via `terraform -install-autocomplete`. This
plugin defers to that mechanism: it does not generate a `_terraform`
file directly. Instead it ensures the cache and `fpath` are wired up,
and triggers the official installer when no cached completion exists
or the existing one is older than seven days.

Because `complete -C` is a bash builtin, you must have `bashcompinit`
loaded (typically `autoload -Uz bashcompinit && bashcompinit`) in
your zsh init for the installer's entry to actually work. This plugin
relies on the host configuration to provide that.

The plugin also adds the plugin-local `completions/` directory to
`fpath` so any user-supplied `_terraform` definition shipped alongside
the plugin is discoverable.

## EFFECTS

- Returns immediately if `terraform` is not on PATH.
- Creates `$ZSH_CACHE_DIR/completions` (default `$HOME/.cache/zsh/completions`).
- Prepends that directory to `fpath` once per shell.
- Adds the plugin-local `completions/` directory to `fpath` when it
  exists.
- Runs `terraform -install-autocomplete` (errors swallowed) when
  `_terraform` is missing or older than 7 days.

## FUNCTIONS

This plugin defines no user-callable functions.

## ENVIRONMENT

- `ZSH_CACHE_DIR` — base cache directory. Defaults to `$HOME/.cache/zsh`.

## FILES

- `~/.bashrc` and `~/.zshrc` — `terraform -install-autocomplete`
  appends a `complete -C terraform terraform` line to these files on
  first run; the plugin does not manage that side effect.
- `$ZSH_CACHE_DIR/completions/_terraform` — checked for freshness;
  may be supplied by the user.
- `.plugins/.zsh/terraform/terraform.plugin.zsh` — the plugin source.

## REQUIREMENTS

- A working `terraform` binary on PATH.
- `bashcompinit` available in zsh (the user must call it once after
  `compinit`) so that the installer's `complete -C terraform` line is
  honoured.

## KEY BINDINGS

None.

## SEE ALSO

- [.docs/aliases/terraform](../../aliases/terraform.md)
- [.docs/utils/terraform](../../utils/terraform.md)
- [.docs/README.md](../../README.md)
