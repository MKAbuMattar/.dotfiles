#!/usr/bin/env python3
"""emoji — search Unicode emoji by name or codepoint and copy to clipboard.

Uses the Unicode CLDR Annotations data baked into Python's ``unicodedata``
module to map emoji codepoints to human-readable names. Search is case
and whitespace insensitive.

Usage:
    emoji rocket                 # search by substring of name
    emoji --list                 # dump every supported emoji
    emoji --copy rocket          # search + copy first match to clipboard
"""

from __future__ import annotations

import argparse
import logging
import shutil
import subprocess
import sys
import unicodedata
from pathlib import Path

logger = logging.getLogger(__name__)
SCRIPT_DIR = Path(__file__).resolve().parent


# A small curated list. Python's stdlib doesn't ship a full emoji ↔ name
# mapping, but unicodedata.name() does name every codepoint individually,
# so we enumerate the BMP + emoji block ranges and let unicodedata do the rest.
EMOJI_RANGES: tuple[tuple[int, int], ...] = (
    (0x1F300, 0x1F6FF),   # Misc symbols and pictographs + transport
    (0x1F900, 0x1F9FF),   # Supplemental symbols and pictographs
    (0x1FA70, 0x1FAFF),   # Symbols and pictographs extended-A
    (0x2600, 0x26FF),     # Misc symbols
    (0x2700, 0x27BF),     # Dingbats
    (0x1F1E6, 0x1F1FF),   # Regional indicators (flags)
)


def all_emoji() -> list[tuple[str, str]]:
    """Return a list of ``(emoji, name)`` tuples for every supported codepoint."""
    out: list[tuple[str, str]] = []
    for lo, hi in EMOJI_RANGES:
        for cp in range(lo, hi + 1):
            ch = chr(cp)
            try:
                name = unicodedata.name(ch)
            except ValueError:
                continue
            out.append((ch, name))
    return out


def search(query: str) -> list[tuple[str, str]]:
    """Return every emoji whose name contains ``query`` (case-insensitive)."""
    q = query.upper().replace(" ", "")
    return [
        (ch, name)
        for ch, name in all_emoji()
        if q in name.replace(" ", "")
    ]


def copy_to_clipboard(text: str) -> bool:
    """Pipe ``text`` to the platform clipboard helper. Returns True on success."""
    candidates = (
        ["wl-copy"],
        ["xclip", "-selection", "clipboard"],
        ["xsel", "--clipboard", "--input"],
        ["pbcopy"],
        ["clip.exe"],
    )
    for cmd in candidates:
        if shutil.which(cmd[0]):
            try:
                subprocess.run(cmd, input=text.encode("utf-8"), check=True)
                return True
            except subprocess.SubprocessError:
                continue
    return False


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("query", nargs="?", help="Substring of emoji name to search for")
    p.add_argument("--list", action="store_true", help="Dump every supported emoji + name")
    p.add_argument("-c", "--copy", action="store_true",
                   help="Copy the first match to the clipboard")
    p.add_argument("-n", "--limit", type=int, default=50, help="Max matches to print (default 50)")
    return p.parse_args()


def main() -> int:
    """Search or list emoji; optionally copy the first match to the clipboard."""
    args = parse_args()
    try:
        if args.list:
            for ch, name in all_emoji():
                print(f"{ch}  {name}")
            return 0

        if not args.query:
            print("Provide a search term or use --list", file=sys.stderr)
            return 2

        results = search(args.query)
        if not results:
            print(f"No emoji matches '{args.query}'", file=sys.stderr)
            return 1

        if args.copy:
            ch, name = results[0]
            if copy_to_clipboard(ch):
                print(f"Copied {ch}  ({name})")
                return 0
            print("No clipboard helper found (install wl-copy / xclip / xsel / pbcopy)",
                  file=sys.stderr)
            print(f"{ch}  {name}")
            return 1

        for ch, name in results[: args.limit]:
            print(f"{ch}  {name}")
        if len(results) > args.limit:
            print(f"... and {len(results) - args.limit} more")
        return 0
    except Exception:
        logger.exception("Unexpected error")
        return 1


if __name__ == "__main__":
    sys.exit(main())
