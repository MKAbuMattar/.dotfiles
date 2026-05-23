# archive-aliases

## NAME

**archive-aliases** — short forms for the most common `tar` invocations.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "archive" ...)
```

## DESCRIPTION

Tiny convenience layer over `tar`: one alias per popular compression algorithm for both create and extract directions, plus a `tarls` for listing contents without extracting. These are deliberately simple — for format auto-detection see `extract`, `compress`, and `archive-ls` in [.docs/utils/archive](../utils/archive.md).

## ALIASES

### Create

| Alias     | Expansion         | Description                                  |
| --------- | ----------------- | -------------------------------------------- |
| `targz`   | `tar czf`         | Create a `.tar.gz`.                          |
| `tarbz2`  | `tar cjf`         | Create a `.tar.bz2`.                         |
| `tarxz`   | `tar cJf`         | Create a `.tar.xz`.                          |
| `tarzst`  | `tar --zstd -cf`  | Create a `.tar.zst` (Zstandard).             |

### Extract

| Alias       | Expansion         | Description                |
| ----------- | ----------------- | -------------------------- |
| `untargz`   | `tar xzf`         | Extract a `.tar.gz`.       |
| `untarbz2`  | `tar xjf`         | Extract a `.tar.bz2`.      |
| `untarxz`   | `tar xJf`         | Extract a `.tar.xz`.       |
| `untarzst`  | `tar --zstd -xf`  | Extract a `.tar.zst`.      |

### Inspect

| Alias    | Expansion   | Description                                  |
| -------- | ----------- | -------------------------------------------- |
| `tarls`  | `tar tf`    | List the contents of a tarball without extracting. |

## REQUIREMENTS

- GNU `tar` (the `--zstd` flag needs tar 1.31+; zstd itself must be installed).
- For `tar.xz`/`tar.bz2` the corresponding `xz`/`bzip2` userland tools are needed (they ship with most distros).

## EXAMPLES

```bash
targz site-backup.tar.gz public_html/
tarzst dump.tar.zst /var/lib/postgres/data
untarxz release.tar.xz
tarls bundle.tar.gz | head
```

## SEE ALSO

- [.docs/utils/archive](../utils/archive.md)
- [.docs/README.md](../README.md)
