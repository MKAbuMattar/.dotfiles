# weather-forecast

## NAME

**weather-forecast** — terminal weather and moon-phase via wttr.in.

## SYNOPSIS

```
weather-forecast [<location>] [--no-glyphs] [-m] [-f <0-6>] [-l <lang>] [-v] [-t]
```

## DESCRIPTION

Fetches the wttr.in plain-text weather report for the given location (or the
caller's auto-detected IP location when omitted) and prints it directly to
stdout. Supports the full set of wttr.in display knobs: glyphs on/off,
moon-phase mode, language, and the 0-6 compact format codes.

## OPTIONS

| Option            | Type | Default | Description                                                  |
| ----------------- | ---- | ------- | ------------------------------------------------------------ |
| `location` (pos)  | str  | —       | City name, e.g. `London`, `"New York"`, `Amman`              |
| `-g`, `--glyphs`  | flag | on      | Enable weather glyphs (default).                             |
| `--no-glyphs`     | flag | —       | Disable weather glyphs.                                      |
| `-m`, `--moon`    | flag | off     | Show moon phases instead of weather (location ignored).      |
| `-f`, `--format`  | str  | —       | Custom wttr.in format code (`0`-`4` short, `j1` JSON, etc.). |
| `-l`, `--lang`    | enum | `en`    | Language code (see "LANGUAGES" below).                       |
| `-t`, `--test`    | flag | off     | Test wttr.in reachability and exit.                          |
| `-v`, `--verbose` | flag | off     | Print URL construction details on stdout.                    |
| `-h`, `--help`    | flag | —       | Show help and exit.                                          |

### Languages

`en`, `ar`, `de`, `es`, `fr`, `it`, `nl`, `pl`, `pt`, `ro`, `ru`, `tr`, `uk`,
`ja`, `zh`, `vi`, `th`, `fa`.

## EXAMPLES

```bash
weather-forecast                            # auto-detect location
weather-forecast "London"
weather-forecast "New York" --no-glyphs
weather-forecast "Tokyo" -f 3
weather-forecast --moon
weather-forecast "Paris" --lang fr
```

## OUTPUT

Plain-text response body from wttr.in, written to stdout.

## EXIT STATUS

| Code | Meaning                                  |
| ---- | ---------------------------------------- |
| 0    | Success (or successful `--test`)         |
| 1    | wttr.in network error / `--test` failure |
| 2    | Invalid CLI arguments (argparse)         |

## ENVIRONMENT

None.

## FILES

None.

## PLATFORMS

| Platform             | Supported | Notes                                                             |
| -------------------- | --------- | ----------------------------------------------------------------- |
| Linux / macOS        | Yes       | Python 3.9+ stdlib                                                |
| Windows (WSL/cmd/PS) | Yes       | Falls back to `errors='replace'` if console encoding can't render |

## REQUIREMENTS

- Python 3.9+ (stdlib only).
- Outbound HTTPS to `wttr.in`.

## SEE ALSO

- wttr.in — https://wttr.in/:help
- [.docs/README.md](../../README.md)
