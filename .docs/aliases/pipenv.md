# pipenv-aliases

## NAME

**pipenv-aliases** — short aliases for `pipenv` virtualenv and dependency management.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "pipenv" ...)
```

## DESCRIPTION

Provides short `p*` aliases for `pipenv` operations: installing dependencies, locking, syncing, running commands and shells inside the project virtualenv, and inspecting paths. The module is gated by `(( ! $+commands[pipenv] )) && return`, so it loads only when `pipenv` is on `$PATH`.

**Note:** several alias names overlap with the [poetry](poetry.md) module — `pch`, `psh`, and `prun`. If you enable both `pipenv` and `poetry`, the later-loaded module wins. Pick one as your primary Python dependency manager per shell.

## ALIASES

### Install / Lock / Sync

| Alias   | Expansion              | Description                                |
| ------- | ---------------------- | ------------------------------------------ |
| `pi`    | `pipenv install`       | Install dependencies from `Pipfile`        |
| `pidev` | `pipenv install --dev` | Install including dev dependencies         |
| `pl`    | `pipenv lock`          | Generate `Pipfile.lock`                    |
| `psy`   | `pipenv sync`          | Install exact versions from `Pipfile.lock` |
| `pu`    | `pipenv uninstall`     | Remove a package                           |
| `pupd`  | `pipenv update`        | Update locked packages                     |

### Run / Shell

| Alias  | Expansion      | Description                                                |
| ------ | -------------- | ---------------------------------------------------------- |
| `prun` | `pipenv run`   | Run a command inside the venv (shared name with poetry)    |
| `psh`  | `pipenv shell` | Spawn a subshell inside the venv (shared name with poetry) |
| `po`   | `pipenv open`  | Open a package's source in `$EDITOR`                       |

### Inspect / Check

| Alias   | Expansion        | Description                                                  |
| ------- | ---------------- | ------------------------------------------------------------ |
| `pch`   | `pipenv check`   | Run pipenv's vulnerability checker (shared name with poetry) |
| `pcl`   | `pipenv clean`   | Uninstall packages not in `Pipfile.lock`                     |
| `pgr`   | `pipenv graph`   | Show dependency graph                                        |
| `pwh`   | `pipenv --where` | Print the project root                                       |
| `pvenv` | `pipenv --venv`  | Print the venv path                                          |
| `ppy`   | `pipenv --py`    | Print the venv Python interpreter                            |

## REQUIREMENTS

- `pipenv` installed and on `$PATH`.

## EXAMPLES

```bash
# Install all locked deps including dev tooling
pidev

# Drop into the project venv
psh

# Run a single command inside the venv
prun pytest -k integration

# Check for known security issues
pch
```

## SEE ALSO

- [.docs/aliases/poetry](poetry.md) — note overlapping `pch` / `psh` / `prun` names
- [.docs/aliases/pip](pip.md)
- [.docs/aliases/uv](uv.md)
- [.docs/aliases/pyenv](pyenv.md)
- [.docs/README.md](../README.md)
