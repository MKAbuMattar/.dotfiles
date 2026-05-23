# zoxide-plugin

## NAME

**zoxide-plugin** — initialises `zoxide` and defines the `z` / `zi` commands.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "zoxide" ...)
```

## DESCRIPTION

`zoxide` is a smarter `cd`: it keeps a ranked database of every directory
you visit and lets you jump back with a few characters of its name. This
plugin simply runs `eval "$(zoxide init zsh)"`, which:

- Defines `z <query>` — jump to the highest-ranked matching directory.
- Defines `zi <query>` — interactive fzf-style picker over matches.
- Installs a `chpwd` hook that records every directory you `cd` into.

The plugin deliberately does **not** pass `--cmd cd` to `init`, so the
shell builtin `cd` keeps its standard behaviour; you opt into `z`
explicitly. No-ops if `zoxide` is not on PATH.

## EFFECTS

- Returns immediately if `zoxide` is not on PATH.
- Runs `eval "$(zoxide init zsh)"`, which defines `z`, `zi`, and a
  `chpwd` hook.

## ENVIRONMENT

| Variable          | Read | Set | Purpose                                                |
| ----------------- | ---- | --- | ------------------------------------------------------ |
| `_ZO_DATA_DIR`    | -    | -   | Read by `zoxide` for database location (not set here). |
| `_ZO_ECHO`        | -    | -   | If `1`, `z` prints the matched dir before cd'ing.      |
| `_ZO_EXCLUDE_DIRS` | -   | -   | Colon-separated patterns to never index.               |

Set these in `~/.zshenv` (before this plugin sources) if you want to
customise; the plugin itself sets nothing.

## FILES

| Path                                      | Role                                        |
| ----------------------------------------- | ------------------------------------------- |
| `${_ZO_DATA_DIR:-$XDG_DATA_HOME}/zoxide/db.zo` | The ranked directory database (managed by zoxide). |

## REQUIREMENTS

- `zoxide` on PATH (`cargo install zoxide` or your package manager).
- Optional: `fzf` for the prettier `zi` picker.

## SEE ALSO

- [.docs/aliases/zoxide](../../aliases/zoxide.md) — supplemental shortcuts (`zb`, `zq`, …)
- [.docs/README.md](../../README.md)
