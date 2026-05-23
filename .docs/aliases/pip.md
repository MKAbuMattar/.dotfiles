# pip-aliases

## NAME

**pip-aliases** — short aliases for `pip` package management with `noglob` quoting so version specifiers work without escaping.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "pip" ...)
```

## DESCRIPTION

Provides short aliases for the most common `pip` operations: installing, upgrading, uninstalling, freezing, and managing `requirements.txt`. The module checks for both `pip3` and `pip`: it loads if either is present and prefers `pip3` when `pip` is missing.

**`noglob` wrapping:** `pip` itself is re-aliased to `noglob pip` (or `noglob pip3`) so that shell glob characters in package specifiers — most importantly `<`, `>`, and `*` — are passed through unexpanded. This lets you type `pipi 'django>=4,<5'` without quoting every operator.

## ALIASES

### Core

| Alias   | Expansion                       | Description                              |
| ------- | ------------------------------- | ---------------------------------------- |
| `pip`   | `noglob pip` (or `noglob pip3`) | pip with shell-glob expansion suppressed |
| `pipi`  | `pip install`                   | Install a package                        |
| `pipu`  | `pip install --upgrade`         | Upgrade a package                        |
| `pipun` | `pip uninstall`                 | Uninstall a package                      |

### Inspect

| Alias   | Expansion            | Description                   |
| ------- | -------------------- | ----------------------------- |
| `pipgi` | `pip freeze \| grep` | Search the frozen environment |
| `piplo` | `pip list -o`        | List outdated packages        |

### Requirements Files

| Alias    | Expansion                         | Description                             |
| -------- | --------------------------------- | --------------------------------------- |
| `pipreq` | `pip freeze > requirements.txt`   | Write current env to `requirements.txt` |
| `pipir`  | `pip install -r requirements.txt` | Install from `requirements.txt`         |

## REQUIREMENTS

- `pip` or `pip3` installed and on `$PATH`.

## EXAMPLES

```bash
# Install with a version range (no quoting needed because of noglob)
pipi 'requests>=2.31,<3'

# Upgrade everything that's outdated
piplo
pipu $(pip list -o --format=columns | awk 'NR>2 {print $1}')

# Snapshot and restore an environment
pipreq
pipir
```

## SEE ALSO

- [.docs/aliases/pipenv](pipenv.md)
- [.docs/aliases/poetry](poetry.md)
- [.docs/aliases/uv](uv.md)
- [.docs/aliases/pyenv](pyenv.md)
- [.docs/README.md](../README.md)
