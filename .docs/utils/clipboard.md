# clipboard-utils

## NAME

**clipboard-utils** — Cross-platform `clipcopy` and `clippaste` shell functions.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "clipboard" ...)
```

## DESCRIPTION

Defines two top-level functions, `clipcopy` and `clippaste`, that adapt to the host platform using essentially the same heuristic as Neovim's clipboard provider. On first invocation, `detect-clipboard` inspects `$OSTYPE`, `$WAYLAND_DISPLAY`, `$DISPLAY`, `$TMUX`, and `$+commands[...]` to pick a backend, then redefines the two functions with concrete implementations. The initial `clipcopy`/`clippaste` shims `unfunction` themselves and re-call into the freshly defined versions, so detection runs lazily exactly once per shell.

Supported backends (probed in order):

- macOS — `pbcopy` / `pbpaste`
- Cygwin / MSYS — `/dev/clipboard`
- Windows from WSL — `clip.exe` + `powershell.exe Get-Clipboard`
- Wayland — `wl-copy` / `wl-paste`
- X11 — `xsel`, then `xclip`
- SSH — `lemonade`, then `doitclient`
- Windows native — `win32yank`
- Android (Termux) — `termux-clipboard-set`/`-get`
- Tmux (when `$TMUX` is set) — `tmux load-buffer` / `save-buffer`

## FUNCTIONS

### `detect-clipboard`

Probes the environment and defines `clipcopy` and `clippaste`.

**Behavior:**

Uses `emulate -L zsh` for local options. Walks the backend list above with `[[ "$OSTYPE" == ... ]]` and `(( ${+commands[...]} ))` tests; the first match wins and replaces the lazy shims with concrete `function clipcopy()`/`function clippaste()` definitions (nested inside this function). If no backend matches, defines a `_retry_clipboard_detection_or_fail` helper that retries detection once and then prints `Platform $OSTYPE not supported or xclip/xsel not installed` on stderr; returns 1.

**Example:**

```bash
detect-clipboard       # rarely called directly; happens on first clipcopy/clippaste
```

### `clipcopy [file]`

Copies data to the system clipboard.

**Arguments:**

| Arg  | Required | Description                                  |
| ---- | -------- | -------------------------------------------- |
| `$1` | No       | File path to copy. Defaults to `/dev/stdin`. |

**Behavior:**

Reads from `$1` (or stdin) and writes to the active backend. Wayland and X11 (xclip) variants run the write in the background (`&>/dev/null &|`) to avoid blocking when no consumer is attached.

**Example:**

```bash
echo "hello" | clipcopy
clipcopy ~/.ssh/id_ed25519.pub
```

### `clippaste`

Writes the clipboard contents to stdout.

**Behavior:**

Invokes the platform's paste command. `wl-paste --no-newline` is used to avoid a trailing newline on Wayland.

**Example:**

```bash
clippaste                # to terminal
clippaste | grep TODO    # pipe to another command
clippaste > snippet.txt  # save to file
```

### `_retry_clipboard_detection_or_fail <clipcmd> [args...]`

Internal fallback registered only when no clipboard backend is detected. Retries `detect-clipboard`; if it succeeds re-invokes the named command, otherwise prints a platform-unsupported error to stderr and returns 1.

## REQUIREMENTS

At least one of: `pbcopy`/`pbpaste`, `wl-copy`/`wl-paste`, `xsel`, `xclip`, `lemonade`, `doitclient`, `win32yank`, `termux-clipboard-set`/`-get`, `clip.exe`+`powershell.exe`, or an active `tmux` session.

## EXAMPLES

```bash
# Copy git diff to clipboard
git diff | clipcopy

# Paste into a Markdown table generator
clippaste | column -t -s ','
```

## SEE ALSO

- [.docs/aliases/clipboard](../aliases/clipboard.md)
- [.docs/plugins/zsh/clipboard](../plugins/zsh/clipboard.md)
- [.docs/README.md](../README.md)
