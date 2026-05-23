# uuid

## NAME

**uuid** — emit UUID v1 / v3 / v4 / v5 / v7 identifiers.

## SYNOPSIS

```
uuid                                  # one v4 (default)
uuid -v 4 -n 10                       # ten v4 UUIDs
uuid -v 5 --namespace dns --name example.com
uuid -v 7                             # time-ordered (RFC 9562)
uuid -u                               # uppercase
```

## DESCRIPTION

Generates UUIDs using Python's stdlib `uuid` module. Supports the standard
versions 1 (MAC + time), 3 (MD5 of name), 4 (random), and 5 (SHA-1 of name),
plus version 7 (time-ordered, RFC 9562). On Python `>= 3.14` `uuid.uuid7()`
is used directly; older interpreters fall back to a manual implementation
(48-bit ms timestamp || 4-bit version 7 || 12-bit random || 2-bit variant ||
62-bit random) seeded from `os.urandom`. No third-party dependencies, no
network access.

## OPTIONS

| Option            | Type | Default | Description                                                            |
| ----------------- | ---- | ------- | ---------------------------------------------------------------------- |
| `-v`, `--version` | int  | `4`     | UUID version. Choices: `1`, `3`, `4`, `5`, `7`.                        |
| `-n`, `--count`   | int  | `1`     | Number of UUIDs to emit.                                               |
| `--namespace`     | enum | —       | Required for v3 / v5. One of `dns`, `url`, `oid`, `x500`.              |
| `--name`          | str  | —       | Required for v3 / v5. The name within the chosen namespace.            |
| `-u`, `--uppercase` | flag | off   | Uppercase the hex output.                                              |
| `--no-hyphens`    | flag | off     | Strip the `8-4-4-4-12` hyphens.                                        |
| `-h`, `--help`    | flag | —       | Show help and exit.                                                    |

### Versions

| `-v` | Source                                               | Stable for same input? |
| ---- | ---------------------------------------------------- | ---------------------- |
| 1    | Host MAC + timestamp (`uuid.uuid1`)                  | No (time-based)        |
| 3    | MD5(namespace + name) (`uuid.uuid3`)                 | Yes                    |
| 4    | CSPRNG random (`uuid.uuid4`)                         | No                     |
| 5    | SHA-1(namespace + name) (`uuid.uuid5`)               | Yes                    |
| 7    | Unix-ms timestamp + random (RFC 9562)                | No (time-ordered)      |

### Namespaces (for v3 / v5)

| Name   | Constant                |
| ------ | ----------------------- |
| `dns`  | `uuid.NAMESPACE_DNS`    |
| `url`  | `uuid.NAMESPACE_URL`    |
| `oid`  | `uuid.NAMESPACE_OID`    |
| `x500` | `uuid.NAMESPACE_X500`   |

## EXAMPLES

```bash
uuid                                                  # one v4
uuid -v 4 -n 10                                       # ten v4s
uuid -v 5 --namespace dns --name example.com          # deterministic v5
uuid -v 7 -n 100                                      # 100 time-ordered ids
uuid -v 4 -u --no-hyphens                             # 32 uppercase hex chars
```

## OUTPUT

One UUID per line on stdout, formatted (hyphens, case) per flags.

## EXIT STATUS

| Code | Meaning                                                            |
| ---- | ------------------------------------------------------------------ |
| 0    | Success                                                            |
| 1    | Unexpected error (logged via `logger.exception`)                   |
| 2    | Invalid arguments — including v3/v5 missing `--namespace`/`--name` |

## ENVIRONMENT

None.

## FILES

None.

## PLATFORMS

| Platform                | Supported | Notes                                                 |
| ----------------------- | --------- | ----------------------------------------------------- |
| Linux / macOS / Windows | Yes       | Python 3.9+ stdlib; v7 uses stdlib on 3.14+ else fallback |

## REQUIREMENTS

- Python 3.9+ (stdlib only: `uuid`, `os.urandom`, `time`).

## SEE ALSO

- RFC 4122 (UUIDs v1/v3/v4/v5), RFC 9562 (UUIDv7)
- [.docs/README.md](../../README.md)
