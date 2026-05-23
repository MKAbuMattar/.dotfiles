# network-aliases

## NAME

**network-aliases** — quick IP, DNS, port, and HTTP probes from the prompt.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "network" ...)
```

## DESCRIPTION

A grab-bag of one-liners over `curl`, `dig`, `ip`, `ss`/`lsof`, and `ping`. Nothing here installs anything — the aliases just paper over the most common flag combinations. `ports` adapts itself: if `ss` is on `$PATH` it is preferred (faster, kernel-native), otherwise it falls back to `lsof -i -P -n | grep LISTEN`. The `dns*` family uses `dig +short` so output is one record per line, friendly for piping.

Pair with [.docs/utils/network](../utils/network.md) for richer functions (geo lookup, lan scan, port-probe with timeout, formatted HTTP timings).

## ALIASES

### Public / local IP

| Alias     | Expansion                                                       | Description                                |
| --------- | --------------------------------------------------------------- | ------------------------------------------ |
| `myip`    | `curl -s4 https://ifconfig.me && echo`                          | Public IPv4 from `ifconfig.me`.            |
| `myip6`   | `curl -s6 https://ifconfig.me && echo`                          | Public IPv6 from `ifconfig.me`.            |
| `localip` | `ip -4 -brief addr show \| awk '$1!="lo" {print $1, $3}'`       | Local IPv4 addresses, skipping loopback.   |

### Ports (auto-selects `ss` or `lsof`)

| Alias    | Expansion (when `ss` present)         | Description                            |
| -------- | ------------------------------------- | -------------------------------------- |
| `ports`  | `ss -tulpnH`                          | TCP + UDP listening sockets.           |
| `ports4` | `ss -tulpnH -4`                       | IPv4 only.                             |
| `ports6` | `ss -tulpnH -6`                       | IPv6 only.                             |

When `ss` is absent, `ports` becomes `lsof -i -P -n \| grep LISTEN` and `ports4`/`ports6` are not defined.

### DNS (uses `dig +short`)

| Alias     | Expansion             | Description                        |
| --------- | --------------------- | ---------------------------------- |
| `dnsa`    | `dig +short A`        | A record lookup.                   |
| `dnsaaaa` | `dig +short AAAA`     | AAAA record lookup.                |
| `dnsmx`   | `dig +short MX`       | MX record lookup.                  |
| `dnstxt`  | `dig +short TXT`      | TXT record lookup.                 |
| `dnsns`   | `dig +short NS`       | NS record lookup.                  |
| `dnsr`    | `dig +short -x`       | Reverse lookup (`dnsr 1.2.3.4`).   |

### Reachability

| Alias  | Expansion     | Description                            |
| ------ | ------------- | -------------------------------------- |
| `png`  | `ping -c 4`   | Send four pings then exit.             |
| `pngf` | `ping`        | Plain `ping` (continuous; useful with `-i` etc.). |

### HTTP probing

| Alias    | Expansion                                                                                                                                              | Description                            |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------- |
| `hget`  | `curl -sSL`                                                                                                                                            | Silent fetch, follow redirects.        |
| `hhead` | `curl -sSI`                                                                                                                                            | HEAD request only.                     |
| `hcode` | `curl -s -o /dev/null -w "%{http_code}\n"`                                                                                                             | Print just the response status code.   |
| `htime` | `curl -s -o /dev/null -w "dns=%{time_namelookup}s connect=%{time_connect}s tls=%{time_appconnect}s ttfb=%{time_starttransfer}s total=%{time_total}s\n"`| One-line timing breakdown.             |

### Connection summary

| Alias    | Expansion                                                          | Description                                     |
| -------- | ------------------------------------------------------------------ | ----------------------------------------------- |
| `conns`  | `ss -tan \| awk "NR>1 {print \$1}" \| sort \| uniq -c \| sort -rn` | Count active TCP connections grouped by state.  |

## REQUIREMENTS

- `curl` for the `myip*`, `h*` aliases.
- `dig` for the `dns*` family (BIND utils / `bind-utils` / `dnsutils`).
- `ip` from iproute2 for `localip`.
- `ss` from iproute2 for `ports*`/`conns`; `lsof` as a fallback for `ports`.
- `ping` for `png`/`pngf`.

## EXAMPLES

```bash
myip                          # public IPv4
localip                       # local interfaces + addrs
ports | grep ':22 '           # who is listening on 22?
dnsa example.com              # A record
dnsr 1.1.1.1                  # PTR record
hcode https://example.com     # 200
htime https://example.com     # timing breakdown
conns                         # connections grouped by state
```

## SEE ALSO

- [.docs/utils/network](../utils/network.md)
- [.docs/README.md](../README.md)
