# clock

## NAME

**clock** — terminal countdown, stopwatch, and live wall-clock utility.

## SYNOPSIS

```
clock countdown  -d <duration>  [-t <title>] [-u]
clock stopwatch              [-t <title>]
clock wallclock              [-t <title>] [--24hour] [-z <timezone>]
```

Subcommand aliases: `countdown|cd`, `stopwatch|sw`, `wallclock|wc|clock`.

## DESCRIPTION

Centers large ANSI-shaded ASCII art (rendered via pyfiglet) for one of three
clock modes:

- **countdown** — counts a duration down to zero (or up to it, with `--countup`).
- **stopwatch** — counts up from zero; press `P` to pause/resume.
- **wallclock** — shows current wall time, optionally in a named timezone.

All modes redraw once per second and exit when `Q` is pressed or `Ctrl+C` is
received.

## OPTIONS

### Common

| Option          | Type   | Default | Description                   |
| --------------- | ------ | ------- | ----------------------------- |
| `-t`, `--title` | string | (empty) | Title rendered below the time |

### `countdown` only

| Option             | Type   | Default | Description                                      |
| ------------------ | ------ | ------- | ------------------------------------------------ |
| `-d`, `--duration` | string | —       | Required. Examples: `25s`, `5m`, `1h`, `02:15PM` |
| `-u`, `--countup`  | flag   | off     | Count up to the duration instead of down from it |

### `wallclock` only

| Option             | Type   | Default | Description                             |
| ------------------ | ------ | ------- | --------------------------------------- |
| `--24hour`         | flag   | off     | Use 24-hour format (`HH:MM:SS`)         |
| `-z`, `--timezone` | string | `Local` | IANA tz name (e.g. `UTC`, `Asia/Amman`) |

### Duration syntax (`-d/--duration`)

| Form       | Meaning                                               |
| ---------- | ----------------------------------------------------- |
| `<N>s`     | N seconds                                             |
| `<N>m`     | N minutes                                             |
| `<N>h`     | N hours                                               |
| `<N>`      | N seconds (bare float)                                |
| `HH:MM`    | Wall-clock time today (or tomorrow if already passed) |
| `HH:MM AM` | Same, 12-hour                                         |
| `HH:MMPM`  | Same, no space                                        |

## KEY BINDINGS

| Key      | Mode      | Action         |
| -------- | --------- | -------------- |
| `Q`      | all       | Abort and exit |
| `P`      | stopwatch | Toggle pause   |
| `Ctrl+C` | all       | Same as `Q`    |

## EXAMPLES

```bash
clock countdown -d 25m -t "Focus"
clock countdown -d 02:00PM -t "Standup"
clock stopwatch -t "Workout"
clock wallclock -t "Amman" -z "Asia/Amman" --24hour
```

## OUTPUT

ANSI-styled, centered ASCII art written to stdout. The screen is cleared
between frames; on exit, the screen clears once more and a single line
summary is printed (e.g. `[+] Countdown Complete!`).

## EXIT STATUS

| Code | Meaning                                 |
| ---- | --------------------------------------- |
| 0    | Normal completion (including `Q` abort) |
| 1    | Missing `pyfiglet`, invalid duration    |
| 2    | Invalid CLI arguments (argparse)        |

## ENVIRONMENT

| Variable        | Set by                   | Purpose                                                 |
| --------------- | ------------------------ | ------------------------------------------------------- |
| `PYFIGLET_PATH` | clock itself, at runtime | Points pyfiglet at the dotfiles font directory if found |

## FILES

| Path                          | Role                                            |
| ----------------------------- | ----------------------------------------------- |
| `~/.config/.figlet/`          | Preferred custom figlet font directory          |
| `<dotfiles>/.config/.figlet/` | Fallback bundled font directory (auto-detected) |

## PLATFORMS

| Platform               | Supported | Notes                                                  |
| ---------------------- | --------- | ------------------------------------------------------ |
| Linux                  | Yes       | Uses `termios`/`tty`/`select` for non-blocking keys    |
| macOS                  | Yes       | Same as Linux                                          |
| Windows (Git Bash/WSL) | Partial   | WSL is full-featured; native cmd falls back via msvcrt |

## REQUIREMENTS

- Python 3.9+
- `pyfiglet` (PyPI). Install with `pip install pyfiglet`.

## SEE ALSO

- `watch(1)`, `sleep(1)`
- pyfiglet — https://pypi.org/project/pyfiglet/
- [.docs/README.md](../../README.md)
