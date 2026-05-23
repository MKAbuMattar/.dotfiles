# debian-plugin

## NAME

**debian-plugin** — apt completion glue for the Debian alias family.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "debian" ...)
```

## DESCRIPTION

Targets Debian/Ubuntu-style systems. The plugin no-ops if neither `apt` nor
`apt-get` is on `$PATH`. Otherwise it sets up `$ZSH_CACHE_DIR/completions/` and
defines an `apt_pref_compdef` helper that generates a small completion shim
delegating to either the system `_apt` or `_aptitude` completer (depending on
`$apt_pref`). The helper is then used to attach completion to a fixed set of
short aliases (`aac`, `abd`, `ac`, `ad`, `afu`, `au`, `ai`, `ail`, `ap`,
`aar`, `ads`) that are expected to be provided elsewhere.

## EFFECTS

- Returns immediately if both `apt` and `apt-get` are missing from `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath`.
- Defines the `apt_pref_compdef` helper function.
- Registers completion for each alias listed below via `compdef`.

## FUNCTIONS

| Function                                | Purpose                                                                                                                                                                                                                      |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `apt_pref_compdef <alias> <subcommand>` | Creates `_apt_pref_<subcommand>` that pre-pends `$apt_pref <subcommand>` into the completion word array and dispatches to `_aptitude` (if `$apt_pref == aptitude`) or `_apt`, then registers it for `<alias>` via `compdef`. |

## ENVIRONMENT

| Variable        | Read/Set                          | Default            | Purpose                                                                                 |
| --------------- | --------------------------------- | ------------------ | --------------------------------------------------------------------------------------- |
| `ZSH_CACHE_DIR` | Read (defaulted)                  | `$HOME/.cache/zsh` | Completion cache directory (created/added to fpath).                                    |
| `apt_pref`      | Read at completion time           | —                  | Selects `_aptitude` vs `_apt` dispatch; expected to be `apt`, `apt-get`, or `aptitude`. |
| `apt_upgr`      | Read at compdef-registration time | —                  | Subcommand name used for the `au` alias (e.g. `upgrade` or `dist-upgrade`).             |

## COMPLETIONS REGISTERED

| Alias | Underlying subcommand |
| ----- | --------------------- |
| `aac` | `autoclean`           |
| `abd` | `build-dep`           |
| `ac`  | `clean`               |
| `ad`  | `update`              |
| `afu` | `update`              |
| `au`  | `$apt_upgr`           |
| `ai`  | `install`             |
| `ail` | `install`             |
| `ap`  | `purge`               |
| `aar` | `autoremove`          |
| `ads` | `dselect-upgrade`     |

## REQUIREMENTS

- `apt` or `apt-get` on `$PATH`. The plugin no-ops otherwise.
- The companion aliases (`aac`, `abd`, …) and the `apt_pref` / `apt_upgr`
  variables are expected to be defined by another file (e.g. a Debian aliases
  module).

## SEE ALSO

- [.docs/README.md](../../README.md)
