#!/usr/bin/env python3
"""port-check — check TCP port reachability for one or more host:port targets.

Usage:
    port-check example.com 80 443
    port-check -t 1.0 redis-server 6379 5432
    port-check --range 192.168.1.1 22 80 443 3000-3010
"""

from __future__ import annotations

import argparse
import logging
import socket
import sys
from pathlib import Path

logger = logging.getLogger(__name__)
SCRIPT_DIR = Path(__file__).resolve().parent


def expand_ports(specs: list[str]) -> list[int]:
    """Expand a list of `N` or `N-M` port specs into a flat sorted list."""
    out: set[int] = set()
    for spec in specs:
        if "-" in spec:
            lo, hi = spec.split("-", 1)
            for p in range(int(lo), int(hi) + 1):
                out.add(p)
        else:
            out.add(int(spec))
    return sorted(out)


def check_port(host: str, port: int, timeout: float) -> bool:
    """Return True iff a TCP connection to ``host:port`` succeeds inside ``timeout``."""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.settimeout(timeout)
        try:
            s.connect((host, port))
            return True
        except (socket.timeout, ConnectionRefusedError, OSError):
            return False


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("host", help="Hostname or IP to check")
    p.add_argument("ports", nargs="+", help="Port(s) or ranges (e.g. 22 80 3000-3010)")
    p.add_argument("-t", "--timeout", type=float, default=2.0, help="Per-port timeout in seconds")
    p.add_argument("-q", "--quiet", action="store_true", help="Print only open ports")
    return p.parse_args()


def main() -> int:
    """Check each requested port on ``args.host`` and report status."""
    args = parse_args()
    try:
        ports = expand_ports(args.ports)
    except ValueError as e:
        print(f"Error: invalid port spec ({e})", file=sys.stderr)
        return 2

    try:
        host_ip = socket.gethostbyname(args.host)
    except socket.gaierror as e:
        print(f"Error: cannot resolve {args.host}: {e}", file=sys.stderr)
        return 1

    if not args.quiet:
        print(f"Probing {args.host} ({host_ip})")

    open_count = 0
    for port in ports:
        if check_port(host_ip, port, args.timeout):
            print(f"  ✓ {args.host}:{port} open")
            open_count += 1
        elif not args.quiet:
            print(f"  ✗ {args.host}:{port} closed/filtered")

    return 0 if open_count > 0 else 1


if __name__ == "__main__":
    sys.exit(main())
