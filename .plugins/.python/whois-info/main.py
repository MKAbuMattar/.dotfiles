#!/usr/bin/env python3
"""whois-info — lightweight WHOIS lookup for domains and IPs.

Talks directly to the IANA WHOIS chain over TCP/43. Falls back to the system
``whois`` binary when present and more reliable for some TLDs.

Usage:
    whois-info example.com
    whois-info 8.8.8.8
    whois-info --raw github.com
"""

from __future__ import annotations

import argparse
import logging
import shutil
import socket
import subprocess
import sys
from pathlib import Path

logger = logging.getLogger(__name__)
SCRIPT_DIR = Path(__file__).resolve().parent

IANA_HOST = "whois.iana.org"
WHOIS_PORT = 43
TIMEOUT = 10


def whois_query(server: str, query: str) -> str:
    """Send a WHOIS query to ``server`` and return the response."""
    with socket.create_connection((server, WHOIS_PORT), timeout=TIMEOUT) as s:
        s.sendall((query + "\r\n").encode("ascii"))
        chunks: list[bytes] = []
        while True:
            try:
                data = s.recv(4096)
            except socket.timeout:
                break
            if not data:
                break
            chunks.append(data)
    return b"".join(chunks).decode("utf-8", errors="replace")


def find_refer(response: str) -> str | None:
    """Find the next WHOIS server referred to by the response, if any."""
    for line in response.splitlines():
        if ":" in line:
            key, _, value = line.partition(":")
            key = key.strip().lower()
            if key in ("refer", "whois", "registrar whois server"):
                return value.strip()
    return None


def chain_lookup(query: str, max_hops: int = 3) -> str:
    """Follow WHOIS refer chain up to ``max_hops`` and return the final response."""
    server = IANA_HOST
    last = ""
    for _ in range(max_hops):
        last = whois_query(server, query)
        nxt = find_refer(last)
        if nxt and nxt != server:
            server = nxt
        else:
            break
    return last


def summarize(response: str) -> str:
    """Pick the most useful keys out of a WHOIS response and return a clean block."""
    interesting = {
        "domain name", "registrar", "creation date", "registry expiry date",
        "updated date", "registrant name", "registrant country",
        "name server", "status",
        # IP-style records:
        "inetnum", "netname", "country", "org-name", "orgname", "descr",
        "owner", "responsible", "created", "changed", "source",
    }
    lines = []
    seen: set[str] = set()
    for line in response.splitlines():
        if ":" not in line:
            continue
        key, _, value = line.partition(":")
        k = key.strip().lower()
        if k in interesting:
            tag = f"{k}={value.strip()}"
            if tag in seen:
                continue
            seen.add(tag)
            lines.append(f"  {key.strip():22} {value.strip()}")
    return "\n".join(lines) if lines else "(no recognisable fields)"


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("query", help="Domain name or IP address")
    p.add_argument("--raw", action="store_true", help="Print the full raw WHOIS response")
    p.add_argument("--system", action="store_true",
                   help="Use the system `whois` binary instead of TCP/43")
    return p.parse_args()


def main() -> int:
    """Perform a WHOIS lookup and print a summarized or raw response."""
    args = parse_args()
    try:
        if args.system and shutil.which("whois"):
            result = subprocess.run(
                ["whois", args.query], capture_output=True, text=True, timeout=15, check=False
            )
            response = result.stdout
        else:
            response = chain_lookup(args.query)
        if args.raw:
            print(response)
        else:
            print(f"WHOIS for {args.query}")
            print(summarize(response))
        return 0
    except (socket.timeout, socket.gaierror, OSError) as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1
    except Exception:
        logger.exception("Unexpected error")
        return 1


if __name__ == "__main__":
    sys.exit(main())
