# poetry-utils

## NAME

**poetry-utils** — Helpers around the Poetry Python project manager.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "poetry" ...)
```

## DESCRIPTION

Returns silently when `poetry` is not on PATH. Provides shell-level conveniences for reading project metadata from `pyproject.toml`, exporting requirements files, scaffolding a new project, bumping versions, running pytest/python through the project's environment, and emitting a prompt fragment. All helpers operate against the `pyproject.toml` in the current working directory.

## FUNCTIONS

### `poetry_project_name`

Echoes the `name` value from `pyproject.toml`.

**Behavior:**

Returns 1 if `pyproject.toml` is missing. Otherwise greps for `^name\s*=` and pipes through `sed -E 's/name\s*=\s*"(.+)"/\1/' | head -1`.

**Example:**

```bash
poetry_project_name
```

### `poetry_project_version`

Echoes the `version` value from `pyproject.toml`.

**Behavior:**

Same approach as `poetry_project_name` but targeting the `version` key.

### `poetry_info`

Prints a summary of the current Poetry project and environment.

**Behavior:**

Errors to stderr and returns 1 if `pyproject.toml` is missing. Otherwise prints `Project:` (`poetry_project_name`), `Version:` (`poetry_project_version`), and `Poetry version:` (`poetry --version | cut -d' ' -f3`). If `poetry env info --path` succeeds, also prints the virtualenv path and the Python version reported by `<venv>/bin/python --version`. Otherwise prints `Virtual environment: Not created`.

**Example:**

```bash
poetry_info
```

### `poetry_export_all [output]`

Exports all dependency groups (main, dev, test, docs) to a requirements file.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Output filename. Defaults to `requirements.txt`. |

**Behavior:**

Prints `Exporting all dependencies to <file>...` then runs `poetry export --without-hashes --with dev --with test --with docs > "$output"`.

**Example:**

```bash
poetry_export_all requirements-full.txt
```

### `poetry_export_dev [output]`

Exports only the `dev` dependency group.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Output filename. Defaults to `requirements-dev.txt`. |

**Behavior:**

Runs `poetry export --without-hashes --only dev > "$output"`.

### `poetry_add_lock <packages...>`

Adds a dependency and refreshes the lock file without updating other packages.

**Behavior:**

Runs `poetry add "$@"` and on success follows with `poetry lock --no-update`.

**Example:**

```bash
poetry_add_lock "requests@^2.32"
```

### `poetry_update_package <package>`

Updates a single named package.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | Yes | Package name. |

**Behavior:**

Prints usage on stderr and returns 1 if `$1` is empty. Otherwise runs `poetry update "$1"`.

### `poetry_outdated`

Lists outdated packages via `poetry show --outdated`.

### `poetry_new_project <name>`

Scaffolds a new Poetry project with extra directories.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | Yes | Project directory name. |

**Behavior:**

Errors to stderr and returns 1 if `$1` is missing. Otherwise runs `poetry new "$name" && cd "$name"`, then `mkdir -p tests docs`, and prints a follow-up hint to run `poetry install`.

**Example:**

```bash
poetry_new_project my-package
```

### `poetry_bump [patch|minor|major]`

Bumps the project's version using semver levels.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | One of `patch`, `minor`, `major`. Defaults to `patch`. |

**Behavior:**

Validates the argument against `^(patch|minor|major)$`. On failure, prints usage to stderr and returns 1. On success runs `poetry version <level>` and echoes the new version using `poetry_project_version`.

**Example:**

```bash
poetry_bump minor
```

### `poetry_test [args...]`

Runs pytest inside the project's environment via `poetry run pytest "$@"`.

### `poetry_python [args...]`

Runs python inside the project's environment via `poetry run python "$@"`.

### `poetry_prompt_info`

Echoes a prompt fragment when inside a Poetry project.

**Behavior:**

Only produces output when `pyproject.toml` exists and `poetry` is on PATH. Renders `${ZSH_THEME_POETRY_PREFIX}<name>:<version>${ZSH_THEME_POETRY_SUFFIX}` using the cached helpers.

## REQUIREMENTS

- `poetry` (module no-ops otherwise).
- `poetry-plugin-export` for the `poetry export` invocations in `poetry_export_*`.
- Standard POSIX `grep`, `sed`, `xargs`, `head`, `cut`.

## EXAMPLES

```bash
# Add a dep and only refresh its own pins
poetry_add_lock "httpx@^0.27"

# Cut a patch release
poetry_bump patch
git commit -am "chore: release $(poetry_project_version)"
```

## SEE ALSO

- [.docs/aliases/poetry](../aliases/poetry.md)
- [.docs/plugins/zsh/poetry](../plugins/zsh/poetry.md)
- [.docs/README.md](../README.md)
