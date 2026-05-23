# hasher

## NAME

**hasher** — compute md5/sha1/sha256/sha384/sha512/blake2b digests of strings or files.

## SYNOPSIS

```
hasher sha256 --text "hello world"
hasher sha256 --file /path/to/file
hasher md5    --file file1 file2 file3
```

## DESCRIPTION

Wraps `hasherlib.new(algo)` to produce hex digests for either a single UTF-8
string or one or more files. Files are streamed in 64 KiB chunks
(`chunk_size = 1 << 16`) so arbitrarily large inputs hasher with constant
memory. No third-party dependencies, no network access.

## OPTIONS

| Option           | Type    | Default | Description                                                                                       |
| ---------------- | ------- | ------- | ------------------------------------------------------------------------------------------------- |
| `algo` (pos.)    | enum    | —       | Hash algorithm. Required. One of the values listed under **Algorithms** below.                    |
| `-t`, `--text`   | string  | —       | Text to hasher (encoded as UTF-8). Mutually exclusive with `--file`.                                |
| `-f`, `--file`   | path... | —       | One or more files to hasher. Mutually exclusive with `--text`.                                      |
| `-h`, `--help`   | flag    | —       | Show help and exit.                                                                               |

Exactly one of `--text` or `--file` must be provided (argparse mutually
exclusive group, `required=True`).

### Algorithms

| Name      | Digest size | Notes                                |
| --------- | ----------- | ------------------------------------ |
| `md5`     | 128 bit     | Legacy; not cryptographically secure |
| `sha1`    | 160 bit     | Legacy; deprecated for signatures    |
| `sha224`  | 224 bit     | SHA-2 family                         |
| `sha256`  | 256 bit     | SHA-2 family (recommended default)   |
| `sha384`  | 384 bit     | SHA-2 family                         |
| `sha512`  | 512 bit     | SHA-2 family                         |
| `blake2b` | up to 512 b | Modern, fast on 64-bit               |
| `blake2s` | up to 256 b | Modern, fast on 32-bit / embedded    |

## EXAMPLES

```bash
hasher sha256 --text "hello world"                       # single digest
hasher md5 --file ./Downloads/iso.img                    # one file
hasher sha512 --file *.tar.gz                            # many files
hasher blake2b --text "$(cat /etc/hostname)"             # piped input via shell
hasher sha1 -f a.bin b.bin c.bin                         # short flag
```

## OUTPUT

- `--text`: just the hex digest, one line.
- `--file`: one line per file in the form `<digest>  <path>` (two-space
  separator, GNU-coreutils style).

## EXIT STATUS

| Code | Meaning                                          |
| ---- | ------------------------------------------------ |
| 0    | Success                                          |
| 1    | A file was not found, or an unexpected error     |
| 2    | Invalid arguments (argparse)                     |
| 3    | Permission denied reading one of the input files |

## ENVIRONMENT

None.

## FILES

Any files passed via `--file` (read-only).

## PLATFORMS

| Platform                | Supported | Notes              |
| ----------------------- | --------- | ------------------ |
| Linux / macOS / Windows | Yes       | Python 3.9+ stdlib |

## REQUIREMENTS

- Python 3.9+ (stdlib only: `hasherlib`, `argparse`, `pathlib`).

## SEE ALSO

- `sha256sum(1)`, `md5sum(1)`, `shasum(1)`
- [.docs/README.md](../../README.md)
