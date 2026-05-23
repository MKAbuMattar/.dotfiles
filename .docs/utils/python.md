# python-utils

## NAME

**python-utils** — Python virtualenv and cache helpers (`pyclean`, `pyuserpaths`, `vrun`, `mkv`).

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "python" ...)
```

## DESCRIPTION

Returns silently when `python3` is not on PATH. Provides four helpers: `pyclean` deletes bytecode and mypy/pytest caches; `pyuserpaths` injects the user `site-packages` directory for the installed Python versions into `$PYTHONPATH`; `vrun` activates an existing virtualenv; and `mkv` creates and activates a new one. The latter two are driven by the `$PYTHON_VENV_NAMES` array and the `$PYTHON_VENV_NAME` scalar.

## FUNCTIONS

### `pyclean [dirs...]`

Removes Python compiled bytecode and tool caches recursively.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$@` | No | One or more directories to clean. Defaults to `.` (the current directory). |

**Behavior:**

Runs four `find` invocations against the targets:

- `-type f -name "*.py[co]" -delete` — `.pyc` and `.pyo` files.
- `-type d -name "__pycache__" -delete` — empty `__pycache__` directories.
- `-depth -type d -name ".mypy_cache" -exec rm -r {} +` — mypy caches.
- `-depth -type d -name ".pytest_cache" -exec rm -r {} +` — pytest caches.

**Example:**

```bash
pyclean              # clean cwd
pyclean src tests    # clean specific subtrees
```

### `pyuserpaths`

Adds user `site-packages` directories to `$PYTHONPATH`.

**Behavior:**

Enables `setopt localoptions extendedglob`. Resolves `user_base="${PYTHONUSERBASE:-${HOME}/.local}"`. Iterates `python2` and `python3` (skipping any that are not installed). For each, calls `python -V`, extracts the major.minor portion via zsh string manipulation, then composes `<user_base>/lib/python<X.Y>/site-packages`. Appends the path to `$PYTHONPATH` only when it exists on disk and is not already present.

**Example:**

```bash
# Add to ~/.zshrc to run once per shell:
pyuserpaths
```

### `vrun [name]`

Activates a virtualenv found in the current directory.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Virtualenv directory name. When absent, walks `$PYTHON_VENV_NAMES` and recurses into the first directory that exists. |

**Behavior:**

- Without an argument: iterates `$PYTHON_VENV_NAMES`, resolves each with the `${name:P}` (realpath) modifier, and recursively calls `vrun "$name"` for the first existing directory. If none are found, errors to stderr.
- With an argument: defaults to `$PYTHON_VENV_NAME` if empty. Errors and returns 1 if `<venv>` is not a directory or `<venv>/bin/activate` is missing. Otherwise sources `bin/activate` and prints `Activated virtual environment <name>`.

**Example:**

```bash
PYTHON_VENV_NAMES=(.venv venv env)
vrun                # auto-pick whichever exists in cwd
vrun custom-env     # explicit
```

### `mkv [name]`

Creates a new virtualenv and activates it via `vrun`.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Directory name for the new virtualenv. Defaults to `$PYTHON_VENV_NAME`. |

**Behavior:**

Resolves `name` and `venvpath` (realpath of `name`). Runs `python3 -m venv "$name"` and returns immediately if that fails. On success, prints `Created venv in '<path>'` to stderr and then calls `vrun "$name"` to activate it.

**Example:**

```bash
PYTHON_VENV_NAME=.venv
mkv          # → creates ./.venv and activates it
```

## VARIABLES

| Variable | Description |
| -------- | ----------- |
| `PYTHON_VENV_NAMES` | Array of candidate virtualenv directory names searched by `vrun` when called without args. |
| `PYTHON_VENV_NAME` | Default name used by `vrun` and `mkv` when no argument is given. |
| `PYTHONUSERBASE` | Read by `pyuserpaths`; defaults to `$HOME/.local` when unset. |
| `PYTHONPATH` | Appended to by `pyuserpaths`. |

These variables are read by the helpers but are not set by the module itself.

## REQUIREMENTS

- `python3` (module returns silently otherwise).
- `find` for `pyclean`.

## EXAMPLES

```bash
# Strip every cache directory in a monorepo
pyclean services workers libs

# One-shot venv lifecycle
mkv .venv
deactivate
vrun .venv
```

## SEE ALSO

- [.docs/aliases/python](../aliases/python.md)
- [.docs/plugins/zsh/python](../plugins/zsh/python.md)
- [.docs/utils/pyenv](pyenv.md)
- [.docs/utils/poetry](poetry.md)
- [.docs/README.md](../README.md)
