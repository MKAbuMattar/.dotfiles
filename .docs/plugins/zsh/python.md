# python-plugin

## NAME

**python-plugin** — defines `PYTHON_VENV_NAMES` and an opt-in `chpwd`
hook that auto-activates Python virtual environments per project.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "python" ...)
```

## DESCRIPTION

This plugin focuses on virtualenv ergonomics rather than completion.
On load it seeds `PYTHON_VENV_NAMES` with the list of directory names
to probe when looking for an in-tree venv. The first existing
`<name>/bin/activate` file wins.

When the environment variable `PYTHON_AUTO_VRUN` is set to the literal
string `"true"`, the plugin defines `auto_vrun` and registers it on
`chpwd`, so changing into a project directory automatically sources
its venv; leaving the project (i.e. moving to a path that is not under
the venv's parent) deactivates it. Activation is opt-in to avoid
surprising users who manage venvs by hand.

## EFFECTS

- Returns immediately if `python3` is not on PATH.
- Sets `PYTHON_VENV_NAME=venv` if unset.
- Declares `typeset -gaU PYTHON_VENV_NAMES`; populates it with
  `($PYTHON_VENV_NAME venv .venv)` when empty.
- If `PYTHON_AUTO_VRUN == "true"`:
  - Defines `auto_vrun`.
  - Registers it via `add-zsh-hook chpwd auto_vrun`.
  - Invokes it once for the current directory.

## FUNCTIONS

- `auto_vrun` — deactivates the current venv if `$PWD` is no longer
  under `${VIRTUAL_ENV:h}`, then walks the names in
  `PYTHON_VENV_NAMES`, sourcing the first matching
  `<name>/bin/activate`. Defined only when `PYTHON_AUTO_VRUN=true`.

## ENVIRONMENT

- `PYTHON_VENV_NAME` — preferred venv directory name. Defaults to
  `venv`.
- `PYTHON_VENV_NAMES` — ordered, deduplicated list of venv directory
  names to probe. Defaults to `($PYTHON_VENV_NAME venv .venv)`.
- `PYTHON_AUTO_VRUN` — set to `"true"` to opt into the automatic
  activation hook. Any other value disables it.
- `VIRTUAL_ENV` — read by `auto_vrun` to detect a currently active
  venv. Set by the standard `activate` script.

## FILES

- `<venv-dir>/bin/activate` for each entry in `PYTHON_VENV_NAMES` —
  sourced when found.
- `.plugins/.zsh/python/python.plugin.zsh` — the plugin source.

## REQUIREMENTS

- A `python3` binary on PATH.
- `add-zsh-hook` available in zsh (only when `PYTHON_AUTO_VRUN=true`).

## KEY BINDINGS

None.

## SEE ALSO

- [.docs/aliases/python](../../aliases/python.md)
- [.docs/utils/python](../../utils/python.md)
- [.docs/README.md](../../README.md)
