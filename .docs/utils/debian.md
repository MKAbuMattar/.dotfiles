# debian-utils

## NAME

**debian-utils** — Debian/Ubuntu package manager helpers around apt/aptitude/apt-get.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "debian" ...)
```

## DESCRIPTION

Selects a preferred apt frontend (`aptitude` > `apt` > `apt-get`) and exports the choice via the `apt_pref` and `apt_upgr` globals (the latter is the corresponding upgrade subcommand — `safe-upgrade` for aptitude, otherwise `upgrade`). Detects whether `sudo` is on PATH and sets `use_sudo=1`. Provides a small set of functions for cloning a system's package selection, querying dpkg history, building custom kernels via `make-kpkg`, and listing packages by size.

## FUNCTIONS

### `apt-copy`

Generates a shell script (`apt-copy.sh`) that installs every package currently installed on the system.

**Behavior:**

Writes a shebang into `apt-copy.sh`, then iterates over `aptitude search -F "%p" --disable-columns \~i` (installed packages) and appends each package name to a single `$apt_pref install ...` line. Marks the script executable with `chmod +x`. Note: the `$apt_pref` reference is single-quoted, so the literal text `$apt_pref` is written into the script for later expansion.

**Example:**

```bash
apt-copy
scp apt-copy.sh other-host:
ssh other-host './apt-copy.sh'
```

### `apt-history [install|upgrade|remove|rollback <from> <to>|list]`

Prints package history from `/var/log/dpkg*` logs.

**Arguments:**

| Arg  | Required     | Description                                                |
| ---- | ------------ | ---------------------------------------------------------- |
| `$1` | No           | One of `install`, `upgrade`, `remove`, `rollback`, `list`. |
| `$2` | For rollback | Start date/pattern (passed to `grep -A`).                  |
| `$3` | For rollback | End date/pattern (passed to `grep -B`).                    |

**Behavior:**

Greps the dpkg logs (ordered by mtime, oldest first) with `zgrep --no-filename`. The `rollback` form filters `upgrade` entries between two anchors and emits `pkg=version` pairs via `awk`. Unknown arguments print a usage hint.

**Example:**

```bash
apt-history install
apt-history rollback "2024-01-01" "2024-02-01"
```

### `kerndeb`

Kernel-package building shortcut using `make-kpkg`.

**Behavior:**

Strips `-j<n>` flags from `$MAKEFLAGS` (because `make-kpkg` does not handle parallel make), prints the resulting value, sets `appendage='-custom'` and `revision=$(date +%Y%m%d)`, then runs `make-kpkg clean` followed by a timed `fakeroot make-kpkg --append-to-version "$appendage" --revision "$revision" kernel_image kernel_headers`.

**Example:**

```bash
cd /usr/src/linux
kerndeb
```

### `apt-list-packages`

Lists installed packages sorted ascending by installed size.

**Behavior:**

Runs `dpkg-query -W --showformat='${Installed-Size} ${Package} ${Status}\n'`, filters out `deinstall` rows, sorts numerically, and emits `size pkg` columns via `awk`.

**Example:**

```bash
apt-list-packages | tail -n 25     # 25 largest installed packages
```

## VARIABLES

| Variable   | Type                                      | Description                                                                                                               |
| ---------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| `apt_pref` | `typeset -g` (implicit, top-level scalar) | The preferred apt frontend: `aptitude`, `apt`, or `apt-get`. Override by exporting in `~/.zshrc` before loading the util. |
| `apt_upgr` | scalar                                    | The upgrade subcommand matching `apt_pref`: `safe-upgrade` for aptitude, `upgrade` otherwise.                             |
| `use_sudo` | scalar                                    | `1` when `sudo` is installed.                                                                                             |

## REQUIREMENTS

- One of: `aptitude`, `apt`, `apt-get`.
- `dpkg-query` for `apt-list-packages`.
- `zgrep`/`awk` for `apt-history`.
- `make-kpkg` and `fakeroot` for `kerndeb` (kernel-package suite).
- `aptitude` is required for the package listing in `apt-copy`.

## EXAMPLES

```bash
# See what got installed last
apt-history install | tail -n 20

# Largest installed packages
apt-list-packages | tail -n 30
```

## SEE ALSO

- [.docs/aliases/debian](../aliases/debian.md)
- [.docs/plugins/zsh/debian](../plugins/zsh/debian.md)
- [.docs/README.md](../README.md)
