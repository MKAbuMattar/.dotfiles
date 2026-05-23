# matrix

## NAME

**matrix** — "The Matrix" rain animation for the terminal.

## SYNOPSIS

```
matrix [-s <ms>] [-h]
```

## DESCRIPTION

Renders falling green katakana/ASCII characters across the full terminal,
emulating the digital-rain effect from the film. Hides the cursor on start
and restores it on exit; clears the screen rather than leaving residue.
Stops on `Q` keypress or `Ctrl+C`.

## OPTIONS

| Option          | Type  | Default | Description                                              |
| --------------- | ----- | ------- | -------------------------------------------------------- |
| `-s`, `--sleep` | float | `50`    | Frame delay in milliseconds. Smaller = faster animation. |
| `-h`, `--help`  | flag  | —       | Show help and exit.                                      |

## KEY BINDINGS

| Key      | Action        |
| -------- | ------------- |
| `Q`      | Stop and exit |
| `Ctrl+C` | Stop and exit |

## EXAMPLES

```bash
matrix                  # default 50ms delay
matrix --sleep 20       # faster
matrix --sleep 100      # slower / more meditative
```

## OUTPUT

ANSI control sequences to stdout — cursor hide, position-set, color,
character. Final line on exit: `Matrix Animation Stopped!` in red.

## EXIT STATUS

| Code | Meaning                          |
| ---- | -------------------------------- |
| 0    | Normal exit (Q or Ctrl+C)        |
| 1    | Negative `--sleep` value         |
| 2    | Invalid CLI arguments (argparse) |

## ENVIRONMENT

None.

## FILES

None.

## PLATFORMS

| Platform           | Supported | Notes                                                 |
| ------------------ | --------- | ----------------------------------------------------- |
| Linux              | Yes       | Uses `termios`/`tty`/`select` for raw key reads       |
| macOS              | Yes       | Same as Linux                                         |
| Windows (cmd / PS) | Partial   | Uses `msvcrt`; some terminals do not honor `color 0A` |
| Windows (WSL)      | Yes       | Same as Linux                                         |

## REQUIREMENTS

- Python 3.9+ (stdlib only; no third-party packages)

## SEE ALSO

- `cmatrix(1)` — long-running C implementation of the same effect
- [.docs/README.md](../../README.md)
