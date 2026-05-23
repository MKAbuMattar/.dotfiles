#!/usr/bin/env python3
"""hash — compute md5/sha1/sha256/sha384/sha512/blake2b digests of strings or files.

Usage:
    hash sha256 --text "hello world"
    hash sha256 --file /path/to/file
    hash md5    --file file1 file2 file3
"""

from __future__ import annotations

import argparse
import hashlib
import logging
import sys
from pathlib import Path

logger = logging.getLogger(__name__)
SCRIPT_DIR = Path(__file__).resolve().parent

ALGORITHMS = ("md5", "sha1", "sha224", "sha256", "sha384", "sha512", "blake2b", "blake2s")


def hash_text(algo: str, text: str) -> str:
    """Return the hex digest of ``text`` under ``algo``."""
    h = hashlib.new(algo)
    h.update(text.encode("utf-8"))
    return h.hexdigest()


def hash_file(algo: str, path: Path, chunk_size: int = 1 << 16) -> str:
    """Return the hex digest of the file at ``path`` under ``algo``."""
    h = hashlib.new(algo)
    with path.open("rb") as f:
        while chunk := f.read(chunk_size):
            h.update(chunk)
    return h.hexdigest()


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("algo", choices=ALGORITHMS, help="Hash algorithm")
    g = p.add_mutually_exclusive_group(required=True)
    g.add_argument("-t", "--text", help="Text to hash (UTF-8)")
    g.add_argument("-f", "--file", nargs="+", type=Path, help="One or more files to hash")
    return p.parse_args()


def main() -> int:
    """Hash either a text string or one or more files and print results."""
    args = parse_args()
    try:
        if args.text is not None:
            print(hash_text(args.algo, args.text))
            return 0

        for path in args.file:
            try:
                digest = hash_file(args.algo, path)
                print(f"{digest}  {path}")
            except FileNotFoundError:
                print(f"Error: {path} not found", file=sys.stderr)
                return 1
            except PermissionError:
                print(f"Error: cannot read {path}", file=sys.stderr)
                return 3
        return 0
    except Exception:
        logger.exception("Unexpected error")
        return 1


if __name__ == "__main__":
    sys.exit(main())
