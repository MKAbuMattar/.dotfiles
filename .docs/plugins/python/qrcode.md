# qrcode

## NAME

**qrcode** — QR-code generator via the qrcode.show HTTP service.

## SYNOPSIS

```
qrcode [<text>] [-f png|svg] [-s] [-o <path>] [-i] [-v]
qrcode --test
```

## DESCRIPTION

Encodes text or URL content into a QR code by POST-ing to qrcode.show and
either writing the response to stdout or saving it to a file. Supports both
raster (PNG) and vector (SVG) output, plus an interactive multi-line input
mode for content with newlines.

## OPTIONS

| Option                | Type   | Default | Description                                              |
| --------------------- | ------ | ------- | -------------------------------------------------------- |
| `text` (positional)   | string | —       | Text to encode. Omit to use interactive mode.            |
| `-f`, `--format`      | enum   | `png`   | Output format: `png` or `svg`.                           |
| `-s`, `--save`        | flag   | off     | Save to `~/.QRCode/<sanitized>-<timestamp>.<ext>`.       |
| `-o`, `--output-path` | path   | —       | Custom output file path. Implies save.                   |
| `-i`, `--interactive` | flag   | off     | Force interactive multi-line input mode.                 |
| `-t`, `--test`        | flag   | off     | Test qrcode.show reachability and exit.                  |
| `-v`, `--verbose`     | flag   | off     | Show URL-building and request progress.                  |
| `-h`, `--help`        | flag   | —       | Show help and exit.                                      |

## EXAMPLES

```bash
qrcode "Hello World" > hello.png                      # PNG to stdout
qrcode "https://github.com" -f svg -s                  # SVG saved to ~/.QRCode/
qrcode "secret" -o ~/Desktop/qr.png                    # Custom path
qrcode -i -f svg                                        # Interactive multi-line input
qrcode --test                                           # Service health check
```

## OUTPUT

Without `--save`/`--output-path`:
- **PNG**: raw bytes to stdout — pipe to a file or viewer.
- **SVG**: SVG text to stdout.

With save: a confirmation line on stdout; the file is created with
`parents=True, exist_ok=True`.

## EXIT STATUS

| Code | Meaning                                                     |
| ---- | ----------------------------------------------------------- |
| 0    | Success (or successful `--test`)                            |
| 1    | Empty interactive input, network error, or `--test` failure |
| 2    | Invalid CLI arguments (argparse)                            |

## ENVIRONMENT

None.

## FILES

| Path         | Role                                          |
| ------------ | --------------------------------------------- |
| `~/.QRCode/` | Auto-generated save location (created lazily) |

## PLATFORMS

| Platform      | Supported | Notes              |
| ------------- | --------- | ------------------ |
| Linux / macOS | Yes       | Python 3.9+ stdlib |
| Windows       | Yes       | Same               |

## REQUIREMENTS

- Python 3.9+ (stdlib only).
- Outbound HTTPS to `qrcode.show`.

## SEE ALSO

- qrcode.show — https://qrcode.show
- [.docs/README.md](../../README.md)
