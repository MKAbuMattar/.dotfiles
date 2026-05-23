# uv-aliases

## NAME

**uv-aliases** — short aliases for the `uv` Python package & project manager with `noglob` wrapping for version specifiers.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "uv" ...)
```

## DESCRIPTION

Provides short `uv*` aliases for the `uv` workflow: project init (with/without workspace), add/remove dependencies, lock and sync (with refresh / upgrade), running commands, managing the embedded `uv pip` interface, managing Python interpreters (`uv python install/list/uninstall/pin`), inspecting the tree, exporting `requirements.txt`, and self-updating. The module is gated by `(( ! $+commands[uv] )) && return`, so it loads only when `uv` is on `$PATH`.

**`noglob` wrapping:** `uv` itself is re-aliased to `noglob uv` so that shell glob characters in version specifiers — most importantly `<`, `>`, and `*` — pass through unexpanded. This lets you type `uva 'django>=4,<5'` without quoting every operator.

## ALIASES

### Core

| Alias | Expansion   | Description                             |
| ----- | ----------- | --------------------------------------- |
| `uv`  | `noglob uv` | uv with shell-glob expansion suppressed |

### Project

| Alias   | Expansion                | Description                                |
| ------- | ------------------------ | ------------------------------------------ |
| `uvi`   | `uv init`                | Initialize a new project                   |
| `uvinw` | `uv init --no-workspace` | Initialize a project outside any workspace |
| `uva`   | `uv add`                 | Add a dependency                           |
| `uvrm`  | `uv remove`              | Remove a dependency                        |

### Lock / Sync

| Alias  | Expansion           | Description                   |
| ------ | ------------------- | ----------------------------- |
| `uvl`  | `uv lock`           | Lock dependencies             |
| `uvlr` | `uv lock --refresh` | Lock with refreshed index     |
| `uvlu` | `uv lock --upgrade` | Lock, upgrading within ranges |
| `uvs`  | `uv sync`           | Install locked dependencies   |
| `uvsr` | `uv sync --refresh` | Sync with refresh             |
| `uvsu` | `uv sync --upgrade` | Sync with upgrade             |

### Run / Inspect

| Alias  | Expansion | Description                          |
| ------ | --------- | ------------------------------------ |
| `uvr`  | `uv run`  | Run a command inside the project env |
| `uvtr` | `uv tree` | Show dependency tree                 |
| `uvv`  | `uv venv` | Create a virtualenv                  |

### pip Compatibility

| Alias | Expansion | Description                   |
| ----- | --------- | ----------------------------- |
| `uvp` | `uv pip`  | uv's pip-compatible interface |

### Python Interpreter Management

| Alias  | Expansion             | Description                      |
| ------ | --------------------- | -------------------------------- |
| `uvpy` | `uv python`           | Python subcommand entry          |
| `uvpi` | `uv python install`   | Install a Python version         |
| `uvpu` | `uv python uninstall` | Uninstall a Python version       |
| `uvpl` | `uv python list`      | List Python versions             |
| `uvpp` | `uv python pin`       | Pin the project's Python version |

### Export / Self-Update

| Alias   | Expansion                                                                                | Description                           |
| ------- | ---------------------------------------------------------------------------------------- | ------------------------------------- |
| `uvexp` | `uv export --format requirements-txt --no-hashes --output-file requirements.txt --quiet` | Export a hash-free `requirements.txt` |
| `uvup`  | `uv self update`                                                                         | Update uv itself                      |

## REQUIREMENTS

- `uv` installed and on `$PATH`.

## EXAMPLES

```bash
# Bootstrap a project
uvi my-app
cd my-app

# Add deps with a version range (no quoting needed because of noglob)
uva 'httpx>=0.27,<1'
uva --dev pytest

# Run tests
uvr pytest

# Pin a Python interpreter
uvpi 3.12
uvpp 3.12

# Export requirements.txt for non-uv consumers
uvexp
```

## SEE ALSO

- [.docs/aliases/pip](pip.md)
- [.docs/aliases/pipenv](pipenv.md)
- [.docs/aliases/poetry](poetry.md)
- [.docs/aliases/pyenv](pyenv.md)
- [.docs/README.md](../README.md)
