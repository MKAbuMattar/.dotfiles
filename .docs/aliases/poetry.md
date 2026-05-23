# poetry-aliases

## NAME

**poetry-aliases** — short aliases for `poetry` dependency and project management.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "poetry" ...)
```

## DESCRIPTION

Provides short `p*` aliases for `poetry` operations: adding and removing dependencies, installing/locking/syncing, running commands in the project venv, project bootstrapping (`new`/`init`), packaging and publishing, and managing the virtualenv and plugins. The module is gated by `(( ! $+commands[poetry] )) && return`, so it loads only when `poetry` is on `$PATH`.

**Note:** several alias names overlap with the [pipenv](pipenv.md) module — `pch`, `psh`, and `prun`. If both modules are enabled, the later-loaded one wins. Pick one as your primary Python dependency manager per shell.

## ALIASES

### Dependencies

| Alias  | Expansion                | Description                |
| ------ | ------------------------ | -------------------------- |
| `pad`  | `poetry add`             | Add a dependency           |
| `padd` | `poetry add --group dev` | Add a dev-group dependency |
| `prm`  | `poetry remove`          | Remove a dependency        |

### Environment

| Alias   | Expansion               | Description                                         |
| ------- | ----------------------- | --------------------------------------------------- |
| `pin`   | `poetry init`           | Initialize a `pyproject.toml`                       |
| `pinst` | `poetry install`        | Install dependencies                                |
| `psync` | `poetry install --sync` | Install and remove anything not locked              |
| `psh`   | `poetry shell`          | Spawn a venv subshell (shared name with pipenv)     |
| `prun`  | `poetry run`            | Run a command in the venv (shared name with pipenv) |

### Project

| Alias  | Expansion        | Description                                         |
| ------ | ---------------- | --------------------------------------------------- |
| `pnew` | `poetry new`     | Scaffold a new project                              |
| `pbld` | `poetry build`   | Build sdist / wheel                                 |
| `ppub` | `poetry publish` | Publish to a package index                          |
| `pch`  | `poetry check`   | Validate `pyproject.toml` (shared name with pipenv) |
| `plck` | `poetry lock`    | Generate `poetry.lock`                              |

### Package Info

| Alias   | Expansion              | Description                         |
| ------- | ---------------------- | ----------------------------------- |
| `pshw`  | `poetry show`          | Show installed packages             |
| `ptree` | `poetry show --tree`   | Show dependency tree                |
| `pslt`  | `poetry show --latest` | Show packages with latest available |
| `pcmd`  | `poetry list`          | List available poetry commands      |

### Configuration

| Alias   | Expansion                                | Description                 |
| ------- | ---------------------------------------- | --------------------------- |
| `pconf` | `poetry config --list`                   | List poetry configuration   |
| `pvoff` | `poetry config virtualenvs.create false` | Disable virtualenv creation |

### Virtual Environment

| Alias   | Expansion                | Description                         |
| ------- | ------------------------ | ----------------------------------- |
| `pvinf` | `poetry env info`        | Show env info                       |
| `ppath` | `poetry env info --path` | Print the venv path                 |
| `pvu`   | `poetry env use`         | Switch the env to a specific Python |
| `pvrm`  | `poetry env remove`      | Remove an env                       |

### Export / Update / Plugins

| Alias   | Expansion                                           | Description                       |
| ------- | --------------------------------------------------- | --------------------------------- |
| `pexp`  | `poetry export --without-hashes > requirements.txt` | Export deps to `requirements.txt` |
| `pup`   | `poetry update`                                     | Update locked packages            |
| `psup`  | `poetry self update`                                | Update poetry itself              |
| `pplug` | `poetry self show plugins`                          | List installed plugins            |
| `psad`  | `poetry self add`                                   | Install a poetry plugin           |

## REQUIREMENTS

- `poetry` installed and on `$PATH`.

## EXAMPLES

```bash
# Bootstrap a new project
pnew my-package
cd my-package

# Add a dev dependency
padd pytest

# Lock + install in one step
plck && pinst

# Run inside the venv
prun pytest

# Export a requirements.txt for non-poetry consumers
pexp
```

## SEE ALSO

- [.docs/aliases/pipenv](pipenv.md) — note overlapping `pch` / `psh` / `prun` names
- [.docs/aliases/pip](pip.md)
- [.docs/aliases/uv](uv.md)
- [.docs/aliases/pyenv](pyenv.md)
- [.docs/README.md](../README.md)
