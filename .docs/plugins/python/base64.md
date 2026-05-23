# base64

## NAME

**base64** — Base64 encoder/decoder for text and files.

## SYNOPSIS

```
base64 (-e | --encode) <text> [-v]
base64 (-d | --decode) <text> [-v]
base64 --encode-file <path> [-o <output>] [-v]
base64 --decode-file <path> [-o <output>] [-v]
```

## DESCRIPTION

A self-contained Base64 utility using only the Python standard library.
Operates in four mutually-exclusive modes (`--encode`, `--decode`,
`--encode-file`, `--decode-file`). Input encoding is UTF-8; file input is
read as raw bytes.

## OPTIONS

| Option            | Type   | Default | Description                                      |
| ----------------- | ------ | ------- | ------------------------------------------------ |
| `-e`, `--encode`  | string | —       | Encode the given text to Base64                  |
| `-d`, `--decode`  | string | —       | Decode the given Base64 text back to UTF-8       |
| `--encode-file`   | path   | —       | Encode the file at the given path                |
| `--decode-file`   | path   | —       | Decode the Base64-encoded file at the given path |
| `-o`, `--output`  | path   | auto    | Output file path (file modes only)               |
| `-v`, `--verbose` | flag   | off     | Print encode/decode progress to stdout           |
| `-h`, `--help`    | flag   | —       | Show help and exit                               |

Default output paths for file modes:

- **encode-file**: `<input>.txt`
- **decode-file**: strips `.txt`/`.b64` if present, otherwise `<input>.decoded`

## EXAMPLES

```bash
base64 --encode "Hello World"           # SGVsbG8gV29ybGQ=
base64 --decode "SGVsbG8gV29ybGQ="      # Hello World
base64 --encode-file document.pdf       # [+] File encoded: document.pdf.txt
base64 --decode-file encoded.txt -o restored.pdf
```

## OUTPUT

Text-mode output goes to stdout, colorized cyan when stdout is a TTY.
File-mode output goes to the resolved output path; the success line
`[+] File encoded: <path>` (or decoded) is printed to stdout.

## EXIT STATUS

| Code | Meaning                                            |
| ---- | -------------------------------------------------- |
| 0    | Success                                            |
| 1    | I/O error, missing input file, or decoding failure |
| 2    | Invalid CLI arguments (argparse)                   |

## ENVIRONMENT

None.

## FILES

Reads from / writes to the paths given on the command line. No persistent state.

## PLATFORMS

| Platform             | Supported | Notes       |
| -------------------- | --------- | ----------- |
| Linux                | Yes       | Python 3.9+ |
| macOS                | Yes       | Python 3.9+ |
| Windows (WSL/native) | Yes       | Python 3.9+ |

## SEE ALSO

- `coreutils base64(1)` — the system base64 tool
- [.docs/README.md](../../README.md)
