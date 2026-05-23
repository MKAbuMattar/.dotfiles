#!/usr/bin/env python3
"""uuid — emit UUID v1 / v3 / v4 / v5 / v7 identifiers.

Usage:
    uuid                                  # one v4 (default)
    uuid -v 4 -n 10                       # ten v4 UUIDs
    uuid -v 5 --namespace dns --name example.com
    uuid -v 7                             # time-ordered (RFC 9562)
    uuid -u                               # uppercase
"""

from __future__ import annotations

import argparse
import logging
import sys
import time
import uuid as _uuid
from os import urandom
from pathlib import Path

logger = logging.getLogger(__name__)
SCRIPT_DIR = Path(__file__).resolve().parent

NAMESPACES = {
    "dns": _uuid.NAMESPACE_DNS,
    "url": _uuid.NAMESPACE_URL,
    "oid": _uuid.NAMESPACE_OID,
    "x500": _uuid.NAMESPACE_X500,
}


def uuid7() -> _uuid.UUID:
    """Generate a UUIDv7 (time-ordered, RFC 9562). Python ≥ 3.14 has stdlib support;
    fall back to a manual implementation otherwise."""
    if hasattr(_uuid, "uuid7"):
        return _uuid.uuid7()  # type: ignore[attr-defined]
    # Manual: 48-bit ms timestamp || 4-bit version || 12-bit random || 2-bit variant || 62-bit random
    ms = int(time.time() * 1000)
    rand_a = int.from_bytes(urandom(2), "big") & 0x0FFF
    rand_b = int.from_bytes(urandom(8), "big") & 0x3FFFFFFFFFFFFFFF
    value = (ms & 0xFFFFFFFFFFFF) << 80
    value |= (0x7 << 76)
    value |= rand_a << 64
    value |= (0b10 << 62)
    value |= rand_b
    return _uuid.UUID(int=value)


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("-v", "--version", type=int, default=4, choices=[1, 3, 4, 5, 7],
                   help="UUID version (default 4)")
    p.add_argument("-n", "--count", type=int, default=1, help="How many to emit")
    p.add_argument("--namespace", choices=list(NAMESPACES), help="(v3/v5) namespace")
    p.add_argument("--name", help="(v3/v5) name within namespace")
    p.add_argument("-u", "--uppercase", action="store_true", help="Uppercase hex")
    p.add_argument("--no-hyphens", action="store_true", help="Omit hyphens")
    return p.parse_args()


def main() -> int:
    """Emit ``count`` UUIDs of the requested version."""
    args = parse_args()
    try:
        for _ in range(args.count):
            if args.version == 1:
                value = _uuid.uuid1()
            elif args.version in (3, 5):
                if not args.namespace or not args.name:
                    print(f"Error: v{args.version} requires --namespace and --name", file=sys.stderr)
                    return 2
                ns = NAMESPACES[args.namespace]
                value = _uuid.uuid3(ns, args.name) if args.version == 3 else _uuid.uuid5(ns, args.name)
            elif args.version == 4:
                value = _uuid.uuid4()
            elif args.version == 7:
                value = uuid7()
            else:
                value = _uuid.uuid4()

            text = str(value)
            if args.no_hyphens:
                text = text.replace("-", "")
            if args.uppercase:
                text = text.upper()
            print(text)
        return 0
    except Exception:
        logger.exception("Unexpected error")
        return 1


if __name__ == "__main__":
    sys.exit(main())
