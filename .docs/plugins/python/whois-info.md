# whois-info

## NAME

**whois-info** — lightweight WHOIS lookup for domains and IPs.

## SYNOPSIS

```
whois-info example.com
whois-info 8.8.8.8
whois-info --raw github.com
```

## DESCRIPTION

Speaks the WHOIS protocol directly over TCP/43, starting at `whois.iana.org`
and chasing the `refer:` / `whois:` / `registrar whois server:` referral
chain up to 3 hops to reach the authoritative server for the query. Returns
either a summarized field block (default) or the full raw response
(`--raw`). With `--system`, delegates to the local `whois(1)` binary when
present — useful for TLDs whose registrars don't follow the IANA refer
convention. No third-party dependencies. Outbound TCP to port 43 required
(unless `--system` is used and the local binary handles network itself).

## OPTIONS

| Option         | Type   | Default | Description                                                                  |
| -------------- | ------ | ------- | ---------------------------------------------------------------------------- |
| `query` (pos.) | string | —       | Domain name or IP address to look up. Required.                              |
| `--raw`        | flag   | off     | Print the full raw WHOIS response instead of a summarized block.             |
| `--system`     | flag   | off     | Use the local `whois` binary instead of speaking TCP/43 directly.            |
| `-h`, `--help` | flag   | —       | Show help and exit.                                                          |

### Engines

| Mode           | How it works                                                                                                             |
| -------------- | ------------------------------------------------------------------------------------------------------------------------ |
| Direct (def.)  | TCP connect to `whois.iana.org:43`, send query + CRLF, read all, follow `refer:` chain up to 3 hops with a 10 s timeout. |
| `--system`     | `subprocess.run(["whois", query], timeout=15)` if `whois` is on `$PATH`; otherwise silently falls back to direct mode.   |

### Summary fields

The default output extracts only these recognised keys (case-insensitive,
deduped, in encounter order):

`domain name`, `registrar`, `creation date`, `registry expiry date`,
`updated date`, `registrant name`, `registrant country`, `name server`,
`status`, `inetnum`, `netname`, `country`, `org-name`, `orgname`, `descr`,
`owner`, `responsible`, `created`, `changed`, `source`.

If none of these appear in the response, prints `(no recognisable fields)`.

## EXAMPLES

```bash
whois-info example.com                            # summarized lookup
whois-info 8.8.8.8                                # IP block
whois-info --raw github.com                       # full raw response
whois-info --system stackoverflow.com             # delegate to whois(1)
whois-info --raw --system 1.1.1.1                 # raw + system binary
```

## OUTPUT

Default — a banner plus an aligned `key  value` block:

```
WHOIS for example.com
  Domain Name           EXAMPLE.COM
  Registrar             RESERVED-Internet Assigned Numbers Authority
  Creation Date         1995-08-14T04:00:00Z
  ...
```

With `--raw`, the unmodified concatenated WHOIS response bytes
(decoded as UTF-8, replacement errors).

## EXIT STATUS

| Code | Meaning                                                  |
| ---- | -------------------------------------------------------- |
| 0    | Success                                                  |
| 1    | Network / DNS / socket error, or unexpected exception    |
| 2    | Invalid arguments (argparse)                             |

## ENVIRONMENT

None directly. `--system` uses whatever `whois` binary `$PATH` finds.

## FILES

None.

## PLATFORMS

| Platform        | Supported | Notes                                                       |
| --------------- | --------- | ----------------------------------------------------------- |
| Linux / macOS   | Yes       | Native TCP/43; `--system` requires the `whois` package      |
| Windows         | Partial   | TCP/43 works; `--system` only if a `whois.exe` is on `PATH` |

## REQUIREMENTS

- Python 3.9+ (stdlib: `socket`, `subprocess`, `shutil`).
- Outbound TCP to port 43 (for direct mode).
- Optional: `whois(1)` binary on `$PATH` for `--system`.

## SEE ALSO

- `whois(1)`, RFC 3912
- [.docs/README.md](../../README.md)
