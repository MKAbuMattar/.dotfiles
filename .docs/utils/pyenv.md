# pyenv-utils

## NAME

**pyenv-utils** — Convenience wrappers around the pyenv version manager.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "pyenv" ...)
```

## DESCRIPTION

Returns silently when `pyenv` is not on PATH. Provides helpers to install the latest patch release of a Python series, query installation state, resolve the on-disk path of a version, summarize the active environment, switch the current shell to the newest installed release of a series, and update pyenv together with all of its plugins via git.

## FUNCTIONS

### `pyenv_install_latest [series]`

Installs the latest patch release for a given Python series.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Major or `major.minor` series, e.g. `3` or `3.12`. Defaults to `3`. |

**Behavior:**

Runs `pyenv install --list`, filters with `grep -E "^\s*<series>\.[0-9]+\.[0-9]+$"`, picks the last match via `tail -1 | tr -d ' '`. If none is found, errors to stderr and returns 1. Otherwise prints `Installing Python <version>...` and runs `pyenv install <version>`.

**Example:**

```bash
pyenv_install_latest 3.12
```

### `pyenv_list`

Lists installed Python versions without aliases.

**Behavior:**

Runs `pyenv versions --bare --skip-aliases`.

### `pyenv_is_installed <version>`

Returns 0 if the given version is installed.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | Yes | Exact pyenv version string. |

**Behavior:**

Errors and returns 1 if `$1` is empty. Otherwise pipes `pyenv versions --bare` into `grep -q "^<version>$"`.

**Example:**

```bash
pyenv_is_installed 3.12.6 && echo present
```

### `pyenv_version_path [version]`

Echoes the on-disk path of an installed version.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Version name. Defaults to `pyenv version-name` (the active version). |

**Behavior:**

Echoes `$(pyenv root)/versions/<version>`. Does not verify existence.

### `pyenv_info`

Prints a summary of the active pyenv configuration.

**Behavior:**

Prints `Pyenv root:`, `Current version:`, and `Global version:`. If `./.python-version` exists, also prints `Local version:`. If `$PYENV_VIRTUAL_ENV` is set, also prints `Active virtualenv:`.

**Example:**

```bash
pyenv_info
```

### `pyenv_use_latest [major]`

Switches the current shell to the newest installed release of a major series.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Major version (`2` or `3`). Defaults to `3`. |

**Behavior:**

Filters installed versions with `grep -E "^<major>\.[0-9]+\.[0-9]+$"` and picks the last entry. If none, errors and returns 1. Otherwise prints `Switching to Python <ver>...` and runs `pyenv shell <ver>`.

**Example:**

```bash
pyenv_use_latest 3
```

### `pyenv_update`

Updates pyenv itself plus every plugin in `$PYENV_ROOT/plugins`.

**Behavior:**

`cd "${PYENV_ROOT:-$HOME/.pyenv}"` (returns 1 on cd failure), runs `git pull`, then iterates `plugins/*` and runs `git pull` inside any plugin that has a `.git` directory, returning to the previous directory between iterations. After the loop, `cd - > /dev/null` back to the original cwd and runs `pyenv rehash`. Prints `Update complete!` when done.

**Example:**

```bash
pyenv_update
```

## REQUIREMENTS

- `pyenv` (module no-ops otherwise).
- `git` for `pyenv_update`.
- POSIX `grep`, `tail`, `tr`, `basename`.

## EXAMPLES

```bash
# Get on the freshest 3.12 patch
pyenv_install_latest 3.12

# Jump to whichever 3.x is newest right now
pyenv_use_latest 3
```

## SEE ALSO

- [.docs/aliases/pyenv](../aliases/pyenv.md)
- [.docs/plugins/zsh/pyenv](../plugins/zsh/pyenv.md)
- [.docs/utils/python](python.md)
- [.docs/README.md](../README.md)
