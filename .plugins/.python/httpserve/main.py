#!/usr/bin/env python3
"""httpserve — quick HTTP server with auto-port, LAN URL, and terminal QR code.

Usage:
    httpserve                       # serve PWD on an auto-picked port
    httpserve -d /tmp -p 8000       # specific dir + port
    httpserve --no-qr               # skip the QR code (still print URL)
"""

from __future__ import annotations

import argparse
import http.server
import logging
import socket
import socketserver
import sys
from pathlib import Path

logger = logging.getLogger(__name__)
SCRIPT_DIR = Path(__file__).resolve().parent


def lan_ip() -> str:
    """Best-effort guess of the host's LAN IP address."""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # Doesn't actually send; just picks the egress interface.
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]
    except OSError:
        return "127.0.0.1"
    finally:
        s.close()


def find_free_port(preferred: int) -> int:
    """Return ``preferred`` if it's free, else pick a random free TCP port.

    SO_REUSEADDR is set on the probe socket so a recently-closed listener in
    TIME_WAIT does not push us off our preferred port.
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        s.bind(("", preferred))
        return preferred
    except OSError:
        s.close()
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        s.bind(("", 0))
        return s.getsockname()[1]
    finally:
        s.close()


def render_ascii_qr(text: str) -> str:
    """Render ``text`` as a UTF-8 block-character QR code.

    Uses the ``qrcode`` PyPI package if available; otherwise returns an
    empty string and the caller will skip the QR display.
    """
    try:
        import qrcode  # noqa: PLC0415
    except ImportError:
        return ""

    qr = qrcode.QRCode(border=1)
    qr.add_data(text)
    qr.make(fit=True)
    matrix = qr.get_matrix()
    out = []
    # Two rows per line via half-block characters
    for i in range(0, len(matrix), 2):
        line = []
        for j in range(len(matrix[0])):
            top = matrix[i][j]
            bot = matrix[i + 1][j] if i + 1 < len(matrix) else False
            if top and bot:
                line.append("█")
            elif top:
                line.append("▀")
            elif bot:
                line.append("▄")
            else:
                line.append(" ")
        out.append("".join(line))
    return "\n".join(out)


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("-d", "--directory", type=Path, default=Path.cwd(),
                   help="Directory to serve (default: cwd)")
    p.add_argument("-p", "--port", type=int, default=8000,
                   help="Preferred port (auto-picks free port on collision)")
    p.add_argument("-b", "--bind", default="",
                   help="Bind address (default: all interfaces)")
    p.add_argument("--no-qr", action="store_true", help="Don't print the QR code")
    return p.parse_args()


def main() -> int:
    """Serve ``--directory`` on the LAN and print URL + optional QR code."""
    args = parse_args()
    if not args.directory.is_dir():
        print(f"Error: {args.directory} is not a directory", file=sys.stderr)
        return 2

    port = find_free_port(args.port)
    url = f"http://{lan_ip()}:{port}"

    print(f"Serving {args.directory.resolve()}")
    print(f"  ▸ Local:   http://127.0.0.1:{port}")
    print(f"  ▸ LAN:     {url}")

    if not args.no_qr:
        qr = render_ascii_qr(url)
        if qr:
            print()
            print(qr)
        else:
            print("(install python3-qrcode to get an in-terminal QR code)")
    print()

    class Handler(http.server.SimpleHTTPRequestHandler):
        def __init__(self, *a, **kw) -> None:
            super().__init__(*a, directory=str(args.directory), **kw)

    socketserver.TCPServer.allow_reuse_address = True
    try:
        with socketserver.TCPServer((args.bind, port), Handler) as httpd:
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n[+] stopped")
        return 0
    except OSError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
