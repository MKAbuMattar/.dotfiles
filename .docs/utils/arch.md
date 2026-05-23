# arch-utils

## NAME

**arch-utils** — Arch Linux package management helpers built on `pacman`, `expac`, `paccache`, `reflector`, and AUR helpers.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "arch" ...)
```

## DESCRIPTION

Loads a suite of `pac-*` shell functions that wrap common Arch Linux maintenance tasks: querying the pacman log, listing packages by size or installation date, removing orphans, backing up and restoring package selections, interactive search/install via `fzf`, cache cleanup, mirror updates with `reflector`, and AUR-aware operations. On load it sets two globals: `use_sudo` (1 when `sudo` is on PATH) and `aur_helper` (prefers `yay`, then `paru`, falling back to `pacman`). When `use_sudo` is unset the helpers fall back to invoking `su -c`.

## FUNCTIONS

### `pac-history [install|remove|upgrade|list]`

Filters `/var/log/pacman.log` for a class of events.

**Arguments:**

| Arg  | Required | Description                                                                       |
| ---- | -------- | --------------------------------------------------------------------------------- |
| `$1` | No       | One of `install`, `remove`, `upgrade`, `list`. Anything else prints a usage hint. |

**Behavior:**

Greps `/var/log/pacman.log` for the relevant verb (case-insensitive) or `cat`s the entire file for `list`. No arguments prints a parameter list to stdout.

**Example:**

```bash
pac-history install
pac-history upgrade | tail -20
```

### `pac-list-packages`

Lists every installed package sorted ascending by on-disk size.

**Behavior:**

Calls `expac -H M "%011m\t%-20n\t%10d"` and pipes through `sort -n`. Requires the `expac` package.

**Example:**

```bash
pac-list-packages | tail -n 30   # 30 largest packages
```

### `pac-list-recent [count]`

Lists most recently installed packages.

**Arguments:**

| Arg  | Required | Description                                  |
| ---- | -------- | -------------------------------------------- |
| `$1` | No       | Number of entries to show. Defaults to `20`. |

**Behavior:**

Uses `expac --timefmt='%Y-%m-%d %T' '%l\t%n'`, reverses, and trims with `head -n`.

**Example:**

```bash
pac-list-recent 50
```

### `pac-remove-orphans`

Removes packages installed as dependencies but no longer required.

**Behavior:**

Captures `pacman -Qtdq`; if empty, prints a notice. Otherwise re-queries and runs `pacman -Rns` either with `sudo` (when `$use_sudo` is 1) or via `su -c`.

**Example:**

```bash
pac-remove-orphans
```

### `pac-backup [file]`

Writes a list of explicitly-installed packages to a backup file.

**Arguments:**

| Arg  | Required | Description                                       |
| ---- | -------- | ------------------------------------------------- |
| `$1` | No       | Output path. Defaults to `packages_YYYYMMDD.txt`. |

**Behavior:**

Runs `pacman -Qqe > $backup_file` and prints both the path and a restore hint.

**Example:**

```bash
pac-backup ~/backups/pkgs.txt
```

### `pac-restore <file>`

Reinstalls packages from a list produced by `pac-backup`.

**Arguments:**

| Arg  | Required | Description                               |
| ---- | -------- | ----------------------------------------- |
| `$1` | Yes      | Path to a newline-separated package list. |

**Behavior:**

Validates the file exists, then runs `pacman -S --needed $(< "$file")` under `sudo` or `su -c`. Returns 1 if the argument is missing or the file is not found.

**Example:**

```bash
pac-restore ~/backups/pkgs.txt
```

### `pac-search-install <term>`

Interactive package search and install.

**Arguments:**

| Arg  | Required | Description                         |
| ---- | -------- | ----------------------------------- |
| `$1` | Yes      | Search term passed to `pacman -Ss`. |

**Behavior:**

Pipes `pacman -Ss` results through `fzf --preview 'pacman -Si {1}'`, parses the selected line with `awk`/`sed` to strip the repo prefix, and installs the result with `pacman -S` (under `sudo` or `su`).

**Example:**

```bash
pac-search-install neovim
```

### `pac-clean-cache`

Trims the package cache, keeping the three most recent versions per package.

**Behavior:**

Runs `paccache -rk3` with `sudo` or `su -c`. Requires `pacman-contrib` for `paccache`.

**Example:**

```bash
pac-clean-cache
```

### `pac-check-reboot`

Compares the running kernel against the installed kernel package.

**Behavior:**

Captures `uname -r` and `pacman -Q linux | awk '{print $2}'`. If the running version does not contain the installed version string, prints a reboot-recommended warning; otherwise prints an up-to-date confirmation.

**Example:**

```bash
pac-check-reboot
```

### `pac-update-mirrors`

Regenerates `/etc/pacman.d/mirrorlist` using `reflector`.

**Behavior:**

Aborts with a hint if `reflector` is not installed. Otherwise runs `reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist` under `sudo` or `su -c`.

**Example:**

```bash
pac-update-mirrors
```

### `pac-download <pkg> [pkg...]`

Downloads packages without installing them.

**Arguments:**

| Arg  | Required | Description                |
| ---- | -------- | -------------------------- |
| `$@` | Yes      | One or more package names. |

**Behavior:**

Runs `pacman -Sw "$@"` under `sudo` or `su -c`. Returns 1 if no argument is given.

**Example:**

```bash
pac-download linux-firmware
```

### `pac-whatprovides <file>`

Reports which package provides a given file.

**Arguments:**

| Arg  | Required | Description                |
| ---- | -------- | -------------------------- |
| `$1` | Yes      | Filename or path fragment. |

**Behavior:**

Shells out to `pkgfile "$1"`. Requires the `pkgfile` package and an up-to-date `pkgfile -u` database.

**Example:**

```bash
pac-whatprovides /usr/bin/htop
```

## VARIABLES

| Variable     | Description                                                                                                               |
| ------------ | ------------------------------------------------------------------------------------------------------------------------- |
| `use_sudo`   | Set to `1` if `sudo` is on PATH. Falsy → helpers fall back to `su -c`.                                                    |
| `aur_helper` | Set to `yay`, `paru`, or `pacman` based on availability. Reserved for future use; current helpers call `pacman` directly. |

## REQUIREMENTS

- `pacman` (always present on Arch).
- `expac` for `pac-list-packages` and `pac-list-recent`.
- `pacman-contrib` for `pac-clean-cache` (`paccache`).
- `reflector` for `pac-update-mirrors`.
- `pkgfile` for `pac-whatprovides`.
- `fzf` for `pac-search-install`.
- Optional: `yay` or `paru` to populate `aur_helper`.

## EXAMPLES

```bash
# Daily maintenance combo
pac-clean-cache
pac-remove-orphans
pac-check-reboot

# Replicate the current selection on another host
pac-backup ~/sync/pkgs.txt
# ... on the new host:
pac-restore ~/sync/pkgs.txt
```

## SEE ALSO

- [.docs/aliases/arch](../aliases/arch.md)
- [.docs/plugins/zsh/arch](../plugins/zsh/arch.md)
- [.docs/README.md](../README.md)
