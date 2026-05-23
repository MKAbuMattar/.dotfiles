#!/usr/bin/env python3
"""password-gen — generate strong passwords (random or diceware passphrases).

Usage:
    password-gen [-l N] [-n COUNT] [--no-symbols] [--no-digits] [--no-upper]
    password-gen --diceware [-w N] [-s SEP] [-n COUNT]
"""

from __future__ import annotations

import argparse
import logging
import secrets
import string
import sys
from pathlib import Path

logger = logging.getLogger(__name__)
SCRIPT_DIR = Path(__file__).resolve().parent

DEFAULT_DICEWARE_WORDS = (
    "apple banana carrot dragon eagle forest galaxy hammer island jungle "
    "kettle lantern meadow nebula orchid piano quartz raven sunset tiger "
    "umbrella violet whisper xenon yarrow zenith".split()
)


def random_password(length: int, *, upper: bool, digits: bool, symbols: bool) -> str:
    """Generate a single cryptographically-random password."""
    alphabet = string.ascii_lowercase
    if upper:
        alphabet += string.ascii_uppercase
    if digits:
        alphabet += string.digits
    if symbols:
        alphabet += "!@#$%^&*()-_=+[]{};:,.<>/?"
    if length < 4:
        raise ValueError("length must be at least 4")
    return "".join(secrets.choice(alphabet) for _ in range(length))


def diceware_passphrase(word_count: int, sep: str, wordlist: list[str]) -> str:
    """Generate a diceware-style passphrase from ``wordlist``."""
    if word_count < 3:
        raise ValueError("diceware passphrases need at least 3 words")
    return sep.join(secrets.choice(wordlist) for _ in range(word_count))


def parse_args() -> argparse.Namespace:
    """Parse CLI arguments."""
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("-l", "--length", type=int, default=20, help="Password length (default 20)")
    p.add_argument("-n", "--count", type=int, default=1, help="Number of passwords to emit")
    p.add_argument("--no-upper", action="store_true", help="Exclude uppercase letters")
    p.add_argument("--no-digits", action="store_true", help="Exclude digits")
    p.add_argument("--no-symbols", action="store_true", help="Exclude punctuation symbols")
    p.add_argument("--diceware", action="store_true", help="Generate a diceware passphrase instead")
    p.add_argument("-w", "--words", type=int, default=6, help="Words per passphrase (diceware mode)")
    p.add_argument("-s", "--sep", default="-", help="Word separator (diceware mode)")
    return p.parse_args()


def main() -> int:
    """Print ``count`` passwords or passphrases to stdout."""
    args = parse_args()
    try:
        for _ in range(args.count):
            if args.diceware:
                print(diceware_passphrase(args.words, args.sep, DEFAULT_DICEWARE_WORDS))
            else:
                print(random_password(
                    args.length,
                    upper=not args.no_upper,
                    digits=not args.no_digits,
                    symbols=not args.no_symbols,
                ))
        return 0
    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 2
    except Exception:
        logger.exception("Unexpected error")
        return 1


if __name__ == "__main__":
    sys.exit(main())
