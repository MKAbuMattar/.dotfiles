# fedora-utils

## NAME

**fedora-utils** — DNF helpers for history queries, package backup/restore, kernel-reboot detection, and interactive search.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "fedora" ...)
```

## DESCRIPTION

A no-op when `dnf` is not on PATH. Otherwise, sets the global `$dnf_pref`
to `dnf5` if installed (the new Fedora 41+ default), else `dnf`, and
defines six helper functions for tasks that the underlying `dnf` CLI
doesn't make convenient. Each privileged function falls back to `su -lc`
when sudo isn't available.

## FUNCTIONS

### `dnf-history <action>`

Filter the `dnf history list` output by transaction type.

**Arguments:**

| Arg  | Required | Description                               |
| ---- | -------- | ----------------------------------------- |
| `$1` | Yes      | `install` / `upgrade` / `remove` / `list` |

**Behavior:** runs `dnf history list` and `awk`-filters by lowercase match.
With no argument or an unknown action, prints a short help message.

```bash
dnf-history install
dnf-history list | head
```

### `dnf-list-userinstalled`

List packages that were explicitly installed by the user (excludes group
installs and pulled-in dependencies). Uses `dnf repoquery --userinstalled`.

```bash
dnf-list-userinstalled
```

### `dnf-list-packages-by-size [N]`

Show the largest installed packages on disk, sorted descending. `N`
defaults to 30. Uses `rpm -qa --queryformat '%{SIZE}\t%{NAME}\n'`.

```bash
dnf-list-packages-by-size 50
```

### `dnf-remove-orphans`

Run `dnf autoremove` to clean up automatically-installed dependencies that
nothing depends on anymore. Wraps with `sudo` (or falls back to `su -lc`).

### `dnf-backup [file]`

Save the list of explicitly-installed packages to `<file>` (default
`packages_<YYYYMMDD>.txt`). Restore with `dnf-restore` or
`sudo dnf install $(< <file>)`.

```bash
dnf-backup ~/Backups/fedora-pkgs.txt
```

### `dnf-restore <file>`

Read a package list (one per line) and install via `dnf install`. Exits
non-zero if the file is missing or empty.

### `dnf-check-reboot`

Compare the running kernel (`uname -r`) against the most recently installed
`kernel` RPM. If they differ, prints a "reboot recommended" message.

```bash
dnf-check-reboot
```

### `dnf-search-install <term>`

Interactive search-and-install. Runs `dnf search <term>`, pipes the
package-name column into `fzf` with a live `dnf info` preview, and
installs whatever you select. Requires `fzf` on PATH; aborts with an error
message if missing.

```bash
dnf-search-install ripgrep
```

## VARIABLES

| Variable   | Set when                          | Value                                |
| ---------- | --------------------------------- | ------------------------------------ |
| `dnf_pref` | Module is loaded with dnf present | `dnf5` if installed, otherwise `dnf` |

## REQUIREMENTS

- `dnf` or `dnf5` on PATH.
- `rpm` for `dnf-list-packages-by-size` and `dnf-check-reboot`.
- `sudo` (preferred) or `su` for the privileged helpers.
- `fzf` for `dnf-search-install` only.

## EXAMPLES

```bash
dnf-history install | head -20
dnf-backup ~/Backups/pkgs.txt
dnf-check-reboot
dnf-search-install neovim
```

## SEE ALSO

- [.docs/aliases/fedora](../aliases/fedora.md)
- [.docs/plugins/zsh/fedora](../plugins/zsh/fedora.md)
- [.docs/utils/debian](debian.md), [.docs/utils/arch](arch.md) — sibling distros
- [.docs/README.md](../README.md)
