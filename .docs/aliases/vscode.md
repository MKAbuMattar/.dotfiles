# vscode-aliases

## NAME

**vscode-aliases** — short aliases for the active VS Code-style editor selected via the `$VSCODE` env var (`code`, `code-insiders`, `cursor`, `codium`, …).

## SYNOPSIS

```text
# Set VSCODE to the launcher you want (one of: code, code-insiders, cursor, codium, ...),
# then enable by adding to the ALIASES array in ~/.zshrc:
export VSCODE="code"
ALIASES=(... "vscode" ...)
```

## DESCRIPTION

Provides short aliases for the most-used flags of the VS Code-family CLI: `--add`, `--diff`, `--goto`, `--new-window`, `--reuse-window`, `--wait`, `--user-data-dir`, `--profile`, `--extensions-dir`, `--install-extension`, `--uninstall-extension`, `--verbose`, `--log`, and `--disable-extensions`. It also defines a `vsc` function that opens a path (or the current directory if no args) in the chosen editor.

**Gating:** unlike every other module in this directory, `vscode` is *not* gated by a `$+commands[...]` check. Instead it requires the `$VSCODE` environment variable to be set to the launcher you want to use — the module bails out via `[[ -z "$VSCODE" ]] && return` if it is empty. This lets the same aliases work transparently for `code`, `code-insiders`, `cursor`, `codium`, or any other compatible editor binary, as long as `$VSCODE` is exported *before* the alias file is sourced.

## ALIASES

### Windows / Files

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `vsca` | `$VSCODE --add` | Add a folder to the last active window |
| `vscd` | `$VSCODE --diff` | Open two files in diff mode |
| `vscg` | `$VSCODE --goto` | Open `file:line:column` |
| `vscn` | `$VSCODE --new-window` | Force a new window |
| `vscr` | `$VSCODE --reuse-window` | Force reuse of the last window |
| `vscw` | `$VSCODE --wait` | Wait for the window to be closed before returning |

### Profiles / Data Dirs

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `vscu` | `$VSCODE --user-data-dir` | Use a custom user data directory |
| `vscp` | `$VSCODE --profile` | Open with a named profile |

### Extensions

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `vsced` | `$VSCODE --extensions-dir` | Use a custom extensions directory |
| `vscie` | `$VSCODE --install-extension` | Install an extension by id |
| `vscue` | `$VSCODE --uninstall-extension` | Uninstall an extension by id |
| `vscde` | `$VSCODE --disable-extensions` | Launch with all extensions disabled |

### Diagnostics

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `vscv` | `$VSCODE --verbose` | Verbose output |
| `vscl` | `$VSCODE --log` | Set log level |

## FUNCTIONS

- **`vsc [path...]`** — opens the given paths in `$VSCODE`. With no arguments, opens the current directory (`.`).

## REQUIREMENTS

- A VS Code-compatible CLI on `$PATH` (`code`, `code-insiders`, `cursor`, `codium`, etc.).
- `$VSCODE` exported to the chosen launcher name **before** the alias file is sourced (e.g. in `~/.zshenv` or earlier in `~/.zshrc`).

## EXAMPLES

```bash
# Configure once, in ~/.zshenv or near the top of ~/.zshrc
export VSCODE="code"

# Open the current project
vsc

# Open a specific file at line:column
vscg src/index.ts:42:8

# Diff two files
vscd a.json b.json

# Manage extensions
vscie esbenp.prettier-vscode
vscue ms-python.python

# Open in a fresh profile / new window for screen sharing
vscp demo
vscn
```

## SEE ALSO

- [.docs/README.md](../README.md)
