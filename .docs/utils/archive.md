# archive-utils

## NAME

**archive-utils** — extension-aware extract, compress, and listing helpers.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "archive" ...)
```

## DESCRIPTION

Three top-level functions that dispatch on filename extension so the caller does not have to remember the right `tar` flag. `extract` and `archive-ls` cover the long tail of archive formats; `compress` infers the output format from the target's extension and falls back to `.tar.zst` (or `.tar.xz` if `zstd` is absent) when none is given.

## FUNCTIONS

### `extract <archive> [<archive>...]`

Universal extractor that dispatches on filename.

**Arguments:**

| Arg  | Required | Description                                |
| ---- | -------- | ------------------------------------------ |
| `$@` | Yes      | One or more archive files to extract.      |

**Behavior:**

Loops over each argument. Skips with a `not a regular file` message when the path is not a file. Otherwise picks the right tool from the extension:

| Extension(s)                  | Tool used                       |
| ----------------------------- | ------------------------------- |
| `.tar.bz2`, `.tbz2`           | `tar xjf`                       |
| `.tar.gz`, `.tgz`             | `tar xzf`                       |
| `.tar.xz`, `.txz`             | `tar xJf`                       |
| `.tar.zst`, `.tzst`           | `tar --zstd -xf`                |
| `.tar.lz4`                    | `tar --lz4 -xf`                 |
| `.tar`                        | `tar xf`                        |
| `.bz2`                        | `bunzip2`                       |
| `.gz`                         | `gunzip`                        |
| `.xz`                         | `unxz`                          |
| `.zst`                        | `unzstd`                        |
| `.lz4`                        | `lz4 -d`                        |
| `.zip`, `.jar`, `.war`        | `unzip`                         |
| `.7z`                         | `7z x`                          |
| `.rar`                        | `unrar x`                       |
| `.Z`                          | `uncompress`                    |
| `.deb`                        | `ar x`                          |
| `.rpm`                        | `rpm2cpio … \| cpio -idmv`      |
| anything else                 | `unknown archive type` warning  |

**Example:**

```bash
extract backup.tar.zst release.zip kernel-6.7.6-200.fc39.src.rpm
```

### `compress <output.archive> <path> [<path>...]`

Universal compressor that infers format from the output's extension.

**Arguments:**

| Arg     | Required | Description                                                          |
| ------- | -------- | -------------------------------------------------------------------- |
| `$1`    | Yes      | Output archive name (extension drives algorithm).                    |
| `$2..`  | Yes      | One or more paths to include.                                        |

**Behavior:**

| Output extension              | Command                  |
| ----------------------------- | ------------------------ |
| `.tar.gz`, `.tgz`             | `tar czf`                |
| `.tar.bz2`, `.tbz2`           | `tar cjf`                |
| `.tar.xz`, `.txz`             | `tar cJf`                |
| `.tar.zst`, `.tzst`           | `tar --zstd -cf`         |
| `.tar`                        | `tar cf`                 |
| `.zip`                        | `zip -r`                 |
| `.7z`                         | `7z a`                   |

If the name has no recognised extension the function appends `.tar.zst` when `zstd` is on `$PATH`, otherwise `.tar.xz`, prints a notice, and recurses with the corrected name.

**Example:**

```bash
compress backup.tar.zst src/ docs/
compress release.zip dist/
compress arbitraryname src/        # becomes arbitraryname.tar.zst
```

### `archive-ls <archive>`

Show an archive's contents without extracting.

**Arguments:**

| Arg  | Required | Description                |
| ---- | -------- | -------------------------- |
| `$1` | Yes      | Archive to list.           |

**Behavior:**

Picks the right inspector by extension:

| Extension(s)                  | Command       |
| ----------------------------- | ------------- |
| `*.tar*`                      | `tar tf`      |
| `.zip`, `.jar`, `.war`        | `unzip -l`    |
| `.7z`                         | `7z l`        |
| `.rar`                        | `unrar l`     |

Anything else prints `Unsupported archive type for listing`.

**Example:**

```bash
archive-ls backup.tar.gz
archive-ls release.zip
```

## REQUIREMENTS

- `tar`, plus the per-format helper for the algorithm you need: `gzip`, `bzip2`, `xz`, `zstd`, `lz4`.
- `unzip`/`zip` for `.zip`, `7z` for `.7z`, `unrar` for `.rar` extraction.
- `rpm2cpio` and `cpio` for `.rpm`.
- `ar` (binutils) for `.deb`.
- `ncompress` for `.Z`.

## EXAMPLES

```bash
extract archive.tar.gz another.zip      # extract many at once
compress backup.tar.zst project/        # zstd tarball
compress release.zip dist/              # zip
archive-ls release.tar.zst              # peek without unpacking
```

## SEE ALSO

- [.docs/aliases/archive](../aliases/archive.md)
- [.docs/README.md](../README.md)
