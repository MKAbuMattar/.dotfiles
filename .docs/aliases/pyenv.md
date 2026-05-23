# pyenv-aliases

## NAME

**pyenv-aliases** — short aliases for `pyenv` Python version management, including `pyenv-virtualenv` helpers.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "pyenv" ...)
```

## DESCRIPTION

Provides short `py*` aliases for `pyenv` operations: listing/installing/uninstalling Python versions, setting global/local/shell versions, rehashing shims, finding executables, updating pyenv itself, and managing virtualenvs (when `pyenv-virtualenv` is installed). The module is gated by `(( ! $+commands[pyenv] )) && return`, so it loads only when `pyenv` is on `$PATH`.

## ALIASES

### Versions

| Alias  | Expansion               | Description                    |
| ------ | ----------------------- | ------------------------------ |
| `pyl`  | `pyenv versions`        | List installed versions        |
| `pyls` | `pyenv versions --bare` | List installed versions (bare) |
| `pyi`  | `pyenv install`         | Install a Python version       |
| `pyui` | `pyenv uninstall`       | Uninstall a Python version     |
| `pyv`  | `pyenv version`         | Show current version           |

### Activation

| Alias  | Expansion      | Description                                  |
| ------ | -------------- | -------------------------------------------- |
| `pyg`  | `pyenv global` | Set the global version                       |
| `pys`  | `pyenv local`  | Set the local (per-directory) version        |
| `pysh` | `pyenv shell`  | Set the shell version (current session only) |

### Maintenance

| Alias | Expansion                                              | Description                                 |
| ----- | ------------------------------------------------------ | ------------------------------------------- |
| `pyr` | `pyenv rehash`                                         | Rehash shims after installing new packages  |
| `pyw` | `pyenv which`                                          | Show the path of a shim-resolved executable |
| `pyc` | `pyenv commands`                                       | List all pyenv subcommands                  |
| `pyu` | `cd "${PYENV_ROOT:-$HOME/.pyenv}" && git pull && cd -` | Self-update pyenv via git                   |

### pyenv-virtualenv

| Alias   | Expansion                 | Description                       |
| ------- | ------------------------- | --------------------------------- |
| `pyva`  | `pyenv activate`          | Activate a virtualenv             |
| `pyvd`  | `pyenv deactivate`        | Deactivate the current virtualenv |
| `pyvl`  | `pyenv virtualenvs`       | List virtualenvs                  |
| `pyvi`  | `pyenv virtualenv`        | Create a virtualenv               |
| `pyvui` | `pyenv virtualenv-delete` | Delete a virtualenv               |

## REQUIREMENTS

- `pyenv` installed and on `$PATH`.
- The `pyenv` init shim must be sourced in your shell rc (`eval "$(pyenv init -)"`).
- For the `pyv*` aliases: the [`pyenv-virtualenv`](https://github.com/pyenv/pyenv-virtualenv) plugin must be installed.

## EXAMPLES

```bash
# Install and use a new Python
pyi 3.12.4
pyg 3.12.4

# Create and activate a project venv
pyvi 3.12.4 my-app
pyva my-app

# Pin a directory to a specific version
cd my-project
pys 3.11.9
```

## SEE ALSO

- [.docs/aliases/python](python.md)
- [.docs/aliases/pip](pip.md)
- [.docs/aliases/pipenv](pipenv.md)
- [.docs/aliases/poetry](poetry.md)
- [.docs/README.md](../README.md)
