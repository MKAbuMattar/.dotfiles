# emoji

## NAME

**emoji** — search Unicode emoji by name or codepoint and copy to clipboard.

## SYNOPSIS

```
emoji rocket                 # search by substring of name
emoji --list                 # dump every supported emoji
emoji --copy rocket          # search + copy first match to clipboard
```

## DESCRIPTION

Enumerates a curated set of Unicode emoji codepoint ranges (Misc Symbols &
Pictographs, Supplemental Pictographs, Symbols-Extended-A, Misc Symbols,
Dingbats, Regional Indicators) and uses `unicodedata.name()` to resolve each
codepoint to its canonical Unicode name — no third-party emoji table needed.
Search is case-insensitive and whitespace-insensitive (the query and each
candidate name are both uppercased and have spaces stripped before
comparison). With `--copy`, the first match is piped to whichever clipboard
helper is available on `$PATH`. No network access.

## OPTIONS

| Option           | Type | Default | Description                                                          |
| ---------------- | ---- | ------- | -------------------------------------------------------------------- |
| `query` (pos.)   | str  | —       | Case-insensitive substring of the emoji's Unicode name.              |
| `--list`         | flag | off     | Dump every supported emoji + its name and exit.                      |
| `-c`, `--copy`   | flag | off     | Copy the first match to the system clipboard.                        |
| `-n`, `--limit`  | int  | `50`    | Max matches printed (extras summarised as `... and N more`).         |
| `-h`, `--help`   | flag | —       | Show help and exit.                                                  |

### Codepoint ranges scanned

| Range                | Block                                  |
| -------------------- | -------------------------------------- |
| `U+1F300 – U+1F6FF`  | Misc symbols and pictographs + transport |
| `U+1F900 – U+1F9FF`  | Supplemental symbols and pictographs   |
| `U+1FA70 – U+1FAFF`  | Symbols and pictographs extended-A     |
| `U+2600 – U+26FF`    | Misc symbols                           |
| `U+2700 – U+27BF`    | Dingbats                               |
| `U+1F1E6 – U+1F1FF`  | Regional indicators (flags)            |

### Clipboard helpers (tried in order)

1. `wl-copy` (Wayland)
2. `xclip -selection clipboard` (X11)
3. `xsel --clipboard --input` (X11)
4. `pbcopy` (macOS)
5. `clip.exe` (Windows / WSL)

The first one found on `$PATH` wins; failures fall through to the next.

## EXAMPLES

```bash
emoji rocket                         # list every emoji whose name contains ROCKET
emoji "smiling face"                 # multi-word substring
emoji --copy heart                   # copy first HEART-named emoji to clipboard
emoji --list | grep -i flag          # full dump + grep
emoji -n 5 face                      # cap output at 5 lines
```

## OUTPUT

Per match, a line of the form `<emoji>  <NAME>` (two spaces). When the
match count exceeds `--limit`, a trailing `... and N more` line is added.
With `--copy`, prints `Copied <emoji>  (<NAME>)` on success.

## EXIT STATUS

| Code | Meaning                                                                |
| ---- | ---------------------------------------------------------------------- |
| 0    | At least one match (or successful `--list` / `--copy`)                 |
| 1    | No matches, or `--copy` could not find a clipboard helper, or error    |
| 2    | No query and no `--list`                                               |

## ENVIRONMENT

None directly. `--copy` honours `$PATH` to locate the clipboard helper, and
the relevant display server (Wayland / X11) must be running for GUI helpers.

## FILES

None.

## PLATFORMS

| Platform | Supported | Notes                                                       |
| -------- | --------- | ----------------------------------------------------------- |
| Linux    | Yes       | `--copy` needs `wl-copy`, `xclip`, or `xsel`                |
| macOS    | Yes       | `--copy` uses `pbcopy`                                      |
| Windows  | Yes       | `--copy` uses `clip.exe` (also works under WSL)             |

## REQUIREMENTS

- Python 3.9+ (stdlib only: `unicodedata`, `argparse`, `subprocess`).
- Optional for `--copy`: one of `wl-copy`, `xclip`, `xsel`, `pbcopy`, `clip.exe`.

## SEE ALSO

- `unicodedata` — https://docs.python.org/3/library/unicodedata.html
- [.docs/README.md](../../README.md)
