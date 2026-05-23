# httpserve

## NAME

**httpserve** — quick HTTP server with auto-port, LAN URL, and terminal QR code.

## SYNOPSIS

```
httpserve                       # serve PWD on an auto-picked port
httpserve -d /tmp -p 8000       # specific dir + port
httpserve --no-qr               # skip the QR code (still print URL)
```

## DESCRIPTION

A one-shot static file server built on `http.server.SimpleHTTPRequestHandler`
wrapped in `socketserver.TCPServer`. It tries the preferred port and falls
back to an OS-assigned free port if that one is busy, prints both the local
(127.0.0.1) and LAN (egress-interface) URLs, and renders the LAN URL as a
UTF-8 half-block QR code in the terminal — provided the optional `qrcode`
PyPI package is installed. Without `qrcode`, a hint is printed and the
server still starts. Runs until `Ctrl+C`.

The LAN IP is discovered by opening a UDP socket to `8.8.8.8:80` (no packets
are actually sent) and reading the kernel's chosen source address; falls back
to `127.0.0.1` on OSError.

## OPTIONS

| Option              | Type | Default | Description                                                                |
| ------------------- | ---- | ------- | -------------------------------------------------------------------------- |
| `-d`, `--directory` | path | `cwd`   | Directory to serve. Must exist and be a directory.                         |
| `-p`, `--port`      | int  | `8000`  | Preferred TCP port. Auto-picks a free port if it's already bound.          |
| `-b`, `--bind`      | str  | `""`    | Bind address. Empty string = all interfaces.                               |
| `--no-qr`           | flag | off     | Don't print the QR code (URL still shown).                                 |
| `-h`, `--help`      | flag | —       | Show help and exit.                                                        |

## EXAMPLES

```bash
httpserve                                      # serve $PWD on :8000 or next free
httpserve -d ~/Downloads -p 9000               # specific dir + port
httpserve -b 127.0.0.1                         # localhost-only
httpserve --no-qr                              # quiet startup (no QR)
cd /tmp/share && httpserve                     # share /tmp/share quickly
```

## OUTPUT

Startup banner on stdout, e.g.:

```
Serving /home/me/share
  ▸ Local:   http://127.0.0.1:8000
  ▸ LAN:     http://192.168.1.42:8000

█▀▀▀▀▀█  ...
```

If `qrcode` is missing:

```
(install python3-qrcode to get an in-terminal QR code)
```

Then standard `SimpleHTTPRequestHandler` access logs to stderr while the
server runs. On `Ctrl+C` prints `[+] stopped` and exits 0.

## EXIT STATUS

| Code | Meaning                                                              |
| ---- | -------------------------------------------------------------------- |
| 0    | Clean shutdown via `Ctrl+C`                                          |
| 1    | OS error binding / serving (e.g. permission denied)                  |
| 2    | `--directory` doesn't exist or isn't a directory                     |

## ENVIRONMENT

None.

## FILES

Serves every file under `--directory` over HTTP. No files written.

## PLATFORMS

| Platform                | Supported | Notes                                                      |
| ----------------------- | --------- | ---------------------------------------------------------- |
| Linux / macOS / Windows | Yes       | Stdlib only; QR rendering requires the `qrcode` PyPI pkg   |

## REQUIREMENTS

- Python 3.9+ (stdlib: `http.server`, `socketserver`, `socket`).
- Optional: `qrcode` (`pip install qrcode` or distro pkg `python3-qrcode`) for
  the in-terminal QR code.

## SEE ALSO

- `python3 -m http.server`
- [.docs/README.md](../../README.md)
