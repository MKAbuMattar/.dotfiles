# web-search

## NAME

**web-search** — search 25+ engines, opening results in your default browser.

## SYNOPSIS

```
web-search -e <engine> -q <query>            # opens in default browser
web-search -e <engine> -q <query> -p         # prints URL only (pipe-safe)
web-search --list-engines
web-search --test
```

## DESCRIPTION

Resolves an engine name (or alias) to a known search URL template, URL-encodes
the query, then opens the result in the user's default browser via Python's
`webbrowser` module. With `-p` / `--print` it instead prints the bare URL to
stdout — no ANSI, no prefix — for piping. A built-in alias map shortens common
engines (`ddg` → `duckduckgo`, `so` → `stackoverflow`, `yt` → `youtube`,
`pip` → `pypi`, …).

The browser selection follows the standard Linux/macOS/Windows rules: it
honors `$BROWSER` if set, otherwise delegates to `xdg-open` (Linux),
`open(1)` (macOS), or the registered file handler (Windows).

## OPTIONS

| Option            | Type   | Default  | Description                                            |
| ----------------- | ------ | -------- | ------------------------------------------------------ |
| `-e`, `--engine`  | string | `google` | Engine name or alias. See `--list-engines`.            |
| `-q`, `--query`   | string | —        | Search query string. Required for normal mode.         |
| `-p`, `--print`   | flag   | off      | Print the URL only on stdout; do not open the browser. |
| `--list-engines`  | flag   | off      | Print all engines (grouped by category) and exit.      |
| `--test`          | flag   | off      | Probe Google, DuckDuckGo, Bing reachability and exit.  |
| `-v`, `--verbose` | flag   | off      | Print URL-building progress.                           |
| `-h`, `--help`    | flag   | —        | Show help and exit.                                    |

## ENGINES

### General Search

`google`, `bing`, `brave`, `duckduckgo`, `startpage`, `yahoo`, `yandex`,
`baidu`, `ecosia`, `qwant`, `ask`.

### Development & Technical

`github`, `stackoverflow`, `scholar`, `wikipedia`, `reddit`, `youtube`,
`dockerhub`, `npm`, `packagist`, `pypi`, `gopkg`, `rscrate`, `rsdoc`.

### AI Assistants

`chatgpt`, `claude`, `perplexity`.

### Aliases

| Alias    | Resolves to     |
| -------- | --------------- |
| `ddg`    | `duckduckgo`    |
| `sp`     | `startpage`     |
| `so`     | `stackoverflow` |
| `docker` | `dockerhub`     |
| `ppai`   | `perplexity`    |
| `yt`     | `youtube`       |
| `pip`    | `pypi`          |

## EXAMPLES

```bash
web-search -e google -q "Python tutorial"                       # opens in browser
web-search -e ddg -q "web development"                          # alias
web-search -e github -q "claude code" -p                        # URL only
web-search -e github -q "claude code" -p | xclip -selection clipboard
BROWSER=firefox web-search -e github -q "claude code"           # force browser
web-search --list-engines
```

## OUTPUT

**Default (open mode):**

```text
[+] Search URL (GitHub):
https://github.com/search?q=claude%20code
```

…immediately followed by the browser launch.

**Print-only (`-p`):**

A single line on stdout, the URL only, with no ANSI codes and no prefix —
safe for piping (`xdg-open`, `xclip`, `wl-copy`, `pbcopy`, etc.).

## EXIT STATUS

| Code | Meaning                                                               |
| ---- | --------------------------------------------------------------------- |
| 0    | URL opened (or printed) successfully                                  |
| 1    | Unknown engine, missing query, `--test` failure, or no usable browser |
| 2    | Invalid CLI arguments (argparse)                                      |

## ENVIRONMENT

| Variable  | Read | Purpose                                                              |
| --------- | ---- | -------------------------------------------------------------------- |
| `BROWSER` | Yes  | Honored by Python's `webbrowser` module — overrides default chooser. |
| `DISPLAY` | Yes  | (Linux) Required for GUI browsers to launch.                         |

## FILES

None — the engine table is hardcoded in the script.

## PLATFORMS

| Platform | Supported | Notes                                                       |
| -------- | --------- | ----------------------------------------------------------- |
| Linux    | Yes       | Uses `xdg-open` or `$BROWSER`; needs `$DISPLAY` for GUI     |
| macOS    | Yes       | Uses `open(1)` via `webbrowser`                             |
| Windows  | Yes       | Uses the registered URL handler                             |
| WSL      | Partial   | Set `BROWSER=wslview` (from `wslu`) for native-Windows open |

## REQUIREMENTS

- Python 3.9+ (stdlib only).
- A graphical environment (or set `$BROWSER` to a text browser like `lynx`).
- Outbound HTTPS only for `--test`; offline otherwise.

## SEE ALSO

- `xdg-open(1)`, `open(1)` — what `webbrowser` ultimately calls
- Python `webbrowser` module — https://docs.python.org/3/library/webbrowser.html
- [.docs/README.md](../../README.md)
