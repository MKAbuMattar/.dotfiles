# random-quote

## NAME

**random-quote** — fetch a random quote from the Quotable API.

## SYNOPSIS

```
random-quote [-f default|simple|json] [-v] [-t]
```

## DESCRIPTION

Retrieves a single random quote from api.quotable.io and prints it in one of
three formats. Useful as a `motd`, terminal greeting, or in scripted
contexts (via the `json` format).

## OPTIONS

| Option            | Type | Default   | Description                                    |
| ----------------- | ---- | --------- | ---------------------------------------------- |
| `-f`, `--format`  | enum | `default` | Display style: `default`, `simple`, or `json`. |
| `-v`, `--verbose` | flag | off       | Show fetch progress.                           |
| `-t`, `--test`    | flag | off       | Test API reachability and exit.                |
| `-h`, `--help`    | flag | —         | Show help and exit.                            |

### Format styles

| Value     | Sample output                                            |
| --------- | -------------------------------------------------------- |
| `default` | Boxed colorized layout with author + first 3 tags        |
| `simple`  | `"<content>"` then `" - <author>"`                       |
| `json`    | Pretty-printed JSON (2-space indent) of the API response |

## EXAMPLES

```bash
random-quote
random-quote -f simple
random-quote -f json | jq '.content'
random-quote --test
```

## OUTPUT

Stdout. The `json` form is parser-friendly; the `default` form contains ANSI
color codes when stdout is a TTY.

## EXIT STATUS

| Code | Meaning                                        |
| ---- | ---------------------------------------------- |
| 0    | Success (or successful `--test`)               |
| 1    | API error / network failure / `--test` failure |
| 2    | Invalid CLI arguments (argparse)               |

## ENVIRONMENT

None.

## FILES

None.

## PLATFORMS

| Platform                | Supported | Notes              |
| ----------------------- | --------- | ------------------ |
| Linux / macOS / Windows | Yes       | Python 3.9+ stdlib |

## REQUIREMENTS

- Python 3.9+ (stdlib only).
- Outbound HTTP to `api.quotable.io`.

## SEE ALSO

- Quotable — https://github.com/lukePeavey/quotable
- `fortune(6)` — local quote-of-the-day equivalent
- [.docs/README.md](../../README.md)
