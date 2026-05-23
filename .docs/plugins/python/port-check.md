# port-check

## NAME

**port-check** — check TCP port reachability for one or more host:port targets.

## SYNOPSIS

```
port-check example.com 80 443
port-check -t 1.0 redis-server 6379 5432
port-check --range 192.168.1.1 22 80 443 3000-3010
```

## DESCRIPTION

Resolves the host with `socket.gethostbyname` and attempts a TCP `connect()`
to each requested port with a configurable per-port timeout. Ports may be
listed individually (`22 80`) or as inclusive ranges (`3000-3010`); all
specs are deduped and sorted before probing. No third-party dependencies,
no UDP / SYN-scan tricks — just plain blocking TCP connect.

## OPTIONS

| Option            | Type    | Default | Description                                                       |
| ----------------- | ------- | ------- | ----------------------------------------------------------------- |
| `host` (pos.)     | string  | —       | Hostname or IP to probe. Required.                                |
| `ports` (pos.)    | spec... | —       | One or more port specs. Each is `N` or `N-M`. Required.           |
| `-t`, `--timeout` | float   | `2.0`   | Per-port connect timeout in seconds.                              |
| `-q`, `--quiet`   | flag    | off     | Print only open ports (no resolved-IP banner, no closed lines).   |
| `-h`, `--help`    | flag    | —       | Show help and exit.                                               |

### Port specs

| Form         | Expands to                          |
| ------------ | ----------------------------------- |
| `22`         | `[22]`                              |
| `3000-3010`  | `[3000, 3001, ..., 3010]` inclusive |
| Multiple     | Union, deduped, sorted ascending    |

## EXAMPLES

```bash
port-check example.com 80 443                          # two ports
port-check -t 0.5 192.168.1.1 22 80 8080               # short timeout
port-check --quiet db.local 5432 6379 27017            # only print open ones
port-check host.lan 3000-3010                          # whole range
port-check 10.0.0.1 22 80 443 8000-8010 9000           # mix singles + range
```

## OUTPUT

Without `--quiet`:

```
Probing example.com (93.184.216.34)
  ✓ example.com:80 open
  ✗ example.com:443 closed/filtered
```

With `--quiet`, only the `✓ host:port open` lines (suitable for piping).

## EXIT STATUS

| Code | Meaning                                          |
| ---- | ------------------------------------------------ |
| 0    | At least one port was open                       |
| 1    | DNS resolution failed, or no ports were open     |
| 2    | Invalid port spec (e.g. non-numeric, bad range)  |

## ENVIRONMENT

None.

## FILES

None.

## PLATFORMS

| Platform                | Supported | Notes              |
| ----------------------- | --------- | ------------------ |
| Linux / macOS / Windows | Yes       | Python 3.9+ stdlib |

## REQUIREMENTS

- Python 3.9+ (stdlib only: `socket`, `argparse`).

## SEE ALSO

- `nc -zv host port`, `nmap -sT`
- [.docs/README.md](../../README.md)
