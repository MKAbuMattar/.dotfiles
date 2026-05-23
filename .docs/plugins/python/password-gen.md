# password-gen

## NAME

**password-gen** — generate strong passwords (random or diceware passphrases).

## SYNOPSIS

```
password-gen [-l N] [-n COUNT] [--no-symbols] [--no-digits] [--no-upper]
password-gen --diceware [-w N] [-s SEP] [-n COUNT]
```

## DESCRIPTION

Emits cryptographically-random passwords using `secrets.choice` over a tunable
alphabet (lowercase + optional uppercase, digits and a fixed punctuation set),
or diceware-style passphrases drawn from a small built-in 26-word list joined
by a configurable separator. No third-party dependencies, no network access.

## OPTIONS

| Option           | Type | Default | Description                                                   |
| ---------------- | ---- | ------- | ------------------------------------------------------------- |
| `-l`, `--length` | int  | `20`    | Password length (random mode). Must be `>= 4`.                |
| `-n`, `--count`  | int  | `1`     | Number of passwords / passphrases to emit.                    |
| `--no-upper`     | flag | off     | Exclude uppercase ASCII letters from the random alphabet.     |
| `--no-digits`    | flag | off     | Exclude digits `0-9` from the random alphabet.                |
| `--no-symbols`   | flag | off     | Exclude punctuation `!@#$%^&*()-_=+[]{};:,.<>/?`.             |
| `--diceware`     | flag | off     | Switch to diceware mode (word-based passphrase).              |
| `-w`, `--words`  | int  | `6`     | Words per passphrase (diceware mode). Must be `>= 3`.         |
| `-s`, `--sep`    | str  | `-`     | Word separator (diceware mode).                               |
| `-h`, `--help`   | flag | —       | Show help and exit.                                           |

### Modes

- **Random** (default): builds an alphabet from `string.ascii_lowercase` plus
  any of upper/digits/symbols not turned off, then draws `length` chars via
  `secrets.choice`.
- **Diceware**: picks `--words` words uniformly at random from a hard-coded
  26-word demo list (`apple banana carrot ...`) and joins them with `--sep`.
  The list is intentionally short — swap in a real EFF wordlist for production use.

## EXAMPLES

```bash
password-gen                                # one 20-char random password
password-gen -l 32 -n 5                     # five 32-char passwords
password-gen --no-symbols --no-upper        # lowercase + digits only
password-gen --diceware -w 5 -s .           # five-word passphrase, dot-separated
password-gen --diceware -n 3                # three 6-word passphrases
```

## OUTPUT

One password (or passphrase) per line on stdout. Nothing else.

## EXIT STATUS

| Code | Meaning                                                     |
| ---- | ----------------------------------------------------------- |
| 0    | Success                                                     |
| 1    | Unexpected error (logged via `logger.exception`)            |
| 2    | Invalid arguments (length `< 4`, words `< 3`, argparse fail)|

## ENVIRONMENT

None.

## FILES

None.

## PLATFORMS

| Platform                | Supported | Notes              |
| ----------------------- | --------- | ------------------ |
| Linux / macOS / Windows | Yes       | Python 3.9+ stdlib |

## REQUIREMENTS

- Python 3.9+ (stdlib only: `secrets`, `string`, `argparse`).

## SEE ALSO

- [.docs/README.md](../../README.md)
