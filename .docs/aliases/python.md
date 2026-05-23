# python-aliases

## NAME

**python-aliases** — minimal helpers for `python3`: a `py` shim and quick file/grep/HTTP-server utilities.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "python" ...)
```

## DESCRIPTION

A tiny module that does two things: it makes `py` available as a shortcut for `python3` (only when a real `py` launcher is not already on `$PATH`, as on Windows), and provides quick filesystem helpers for working with Python files plus a one-liner to serve the current directory over HTTP. The module is gated by `(( ! $+commands[python3] )) && return`, so it loads only when `python3` is on `$PATH`.

## ALIASES

### Core

| Alias | Expansion | Description                                                   |
| ----- | --------- | ------------------------------------------------------------- |
| `py`  | `python3` | Run Python 3 (only defined if no real `py` exists on `$PATH`) |

### File Helpers

| Alias      | Expansion                   | Description                                               |
| ---------- | --------------------------- | --------------------------------------------------------- |
| `pyfind`   | `find . -name "*.py"`       | Find Python source files under the cwd                    |
| `pygrep`   | `grep -nr --include="*.py"` | Recursive grep limited to `*.py` files                    |
| `pyserver` | `python3 -m http.server`    | Serve the current directory over HTTP (default port 8000) |

## REQUIREMENTS

- `python3` installed and on `$PATH`.

## EXAMPLES

```bash
# Quick REPL
py

# Find all references to a name in Python sources under cwd
pygrep MyClass .

# Share the build output over HTTP for a colleague on the LAN
cd ./dist && pyserver 9000
```

## SEE ALSO

- [.docs/aliases/pyenv](pyenv.md)
- [.docs/aliases/pip](pip.md)
- [.docs/aliases/pipenv](pipenv.md)
- [.docs/aliases/poetry](poetry.md)
- [.docs/aliases/uv](uv.md)
- [.docs/README.md](../README.md)
