# network-utils

## NAME

**network-utils** — IP, port, and HTTP investigation helpers.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "network" ...)
```

## DESCRIPTION

A handful of functions for diagnosing reachability, geolocation, and HTTP latency. They lean on `curl`, optional `jq`, and shell built-in `/dev/tcp` probes so most of them work even on minimally provisioned hosts. `lanscan` upgrades to `nmap` when available and degrades gracefully to a parallel `ping` sweep otherwise. None of these functions assume root.

## FUNCTIONS

### `netinfo`

One-shot dashboard of the host's public-facing identity.

**Arguments:** none.

**Behavior:**

1. Prints the public IPv4 from `https://ifconfig.me` (via `curl -s4`).
2. Prints the public IPv6 the same way (via `curl -s6`).
3. If `jq` is installed, also fetches `https://ipinfo.io` and prints `ip / hostname / city / region / country / asn` formatted with jq.

Returns 1 with a hint when `curl` is missing.

**Example:**

```bash
netinfo
# -- Public IPv4 --
# 203.0.113.10
# -- Public IPv6 --
# 2001:db8::1
# -- Geo ---------
# ip:      203.0.113.10
# city:    Amman
# country: JO
# asn:     AS12345 Example
```

### `portcheck <host> <port> [timeout=2]`

Check whether a TCP port is reachable.

**Arguments:**

| Arg  | Required | Default | Description                                          |
| ---- | -------- | ------- | ---------------------------------------------------- |
| `$1` | Yes      | —       | Target host or IP.                                   |
| `$2` | Yes      | —       | Target port.                                         |
| `$3` | No       | `2`     | Seconds to wait before giving up (needs `timeout`).  |

**Behavior:**

Opens `/dev/tcp/$host/$port` from inside a child `zsh -c` so a hung connect cannot block the parent. If the `timeout` binary is present, the whole probe is wrapped in `timeout $timeout`. On success prints `host:port is open`; on failure prints `closed or filtered` and returns 1.

**Example:**

```bash
portcheck github.com 443
portcheck db.internal 5432 5
```

### `lanscan <CIDR>`

Discover live hosts on a subnet.

**Arguments:**

| Arg  | Required | Description                                |
| ---- | -------- | ------------------------------------------ |
| `$1` | Yes      | CIDR-style target (e.g. `192.168.1.0/24`). |

**Behavior:**

- If `nmap` is installed: runs `nmap -sn "$1"` and prints only the discovered host columns.
- Otherwise: warns, then runs a parallel `ping -c1 -W1` against `$base.1`..`$base.254` (where `$base` is `${CIDR%.*/*}`), backgrounds each ping, and `wait`s for completion. Only addresses that reply are printed.

The ping fallback assumes a `/24`-shaped CIDR; for larger subnets, install `nmap`.

**Example:**

```bash
lanscan 192.168.1.0/24
```

### `http-time <url>`

Pretty multi-line HTTP timing breakdown.

**Arguments:**

| Arg  | Required | Description     |
| ---- | -------- | --------------- |
| `$1` | Yes      | URL to fetch.   |

**Behavior:**

Invokes `curl -s -o /dev/null -w '<template>' "$1"`, where the template prints labelled lines for `dns_lookup`, `connect`, `tls_handshake`, `first_byte`, `total`, and `http_code`. The body is discarded; only the timing report reaches stdout.

**Example:**

```bash
http-time https://example.com
# dns_lookup:    0.012s
# connect:       0.043s
# tls_handshake: 0.108s
# first_byte:    0.187s
# total:         0.187s
# http_code:     200
```

### `iplookup <ip-or-domain>`

Raw ipinfo.io lookup.

**Arguments:**

| Arg  | Required | Description                       |
| ---- | -------- | --------------------------------- |
| `$1` | Yes      | IP address or hostname to query.  |

**Behavior:**

Runs `curl -s "https://ipinfo.io/$1"` when `curl` is present and appends a trailing newline. Output is the raw JSON returned by ipinfo.io — combine with `jq` for filtering.

**Example:**

```bash
iplookup 8.8.8.8 | jq .city
```

### `ifs`

Table of local interfaces.

**Arguments:** none.

**Behavior:**

Calls `ip -brief addr show` and formats the columns (interface, state, address) with `awk`, dropping `lo`.

**Example:**

```bash
ifs
# eth0   UP   192.168.1.10/24
# wlan0  UP   192.168.1.20/24
```

## REQUIREMENTS

- `curl` (mandatory for `netinfo`, `http-time`, `iplookup`).
- `jq` is optional but unlocks the geo block in `netinfo`.
- `timeout` enables the bounded variant of `portcheck`.
- `nmap` upgrades `lanscan`; otherwise `ping` suffices.
- `ip` from iproute2 for `ifs`.

## EXAMPLES

```bash
netinfo                       # public ip + geo
portcheck db.example.com 5432 # quick reachability probe
lanscan 192.168.0.0/24        # discover live hosts
http-time https://github.com  # timing breakdown
iplookup 1.1.1.1              # raw ipinfo JSON
ifs                           # local interface table
```

## SEE ALSO

- [.docs/aliases/network](../aliases/network.md)
- [.docs/README.md](../README.md)
