# alpine-utils

## NAME

**alpine-utils** — apk helpers for log queries, package backup/restore, pruning, restart checks, and interactive search.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "alpine" ...)
```

## DESCRIPTION

A no-op when `apk` is not on PATH. Otherwise defines helper functions
tailored to Alpine's specifics: apk doesn't maintain a structured
transaction log like dnf or zypper, so history functions inspect
`/var/log/apk.log` (only present when syslog routes apk events there).
The "world" file at `/etc/apk/world` is treated as the source of truth
for explicitly-installed packages.

## FUNCTIONS

### `apk-history <action>`

Inspect `/var/log/apk.log` if present. Prints a helpful message about
enabling syslog for apk if the log file isn't there.

**Arguments:**

| Arg  | Required | Description                          |
| ---- | -------- | ------------------------------------ |
| `$1` | Yes      | `install` / `remove` / `list`        |

### `apk-list-userinstalled`

`cat /etc/apk/world` — the canonical list of explicitly-installed
packages on Alpine.

### `apk-list-packages-by-size [N]`

Show the largest installed packages by on-disk size, sorted descending.
`N` defaults to 30. Parses `apk info -s` output.

### `apk-prune`

Remove any installed packages that aren't in `/etc/apk/world` — Alpine's
closest analog to "orphans". Uses `apk del --purge --no-progress`.

### `apk-backup [file]`

Copy `/etc/apk/world` to `<file>` (default `packages_<YYYYMMDD>.txt`).

### `apk-restore <file>`

Read a package list and install via `apk add`.

### `apk-check-reboot`

Compare the running kernel to the installed kernel package. If `lsof` is
available, also inspects mapped libraries for deleted entries, which
signals services with stale code that should be restarted.

### `apk-search-install <term>`

Interactive search-and-install: pipes `apk search -q` results into `fzf`
with an `apk info` preview. Requires `fzf`.

## REQUIREMENTS

- `apk` on PATH (entire module no-ops otherwise).
- `sudo` (preferred) or `su` for privileged helpers.
- `fzf` for `apk-search-install` only.
- `lsof` (optional, for the deeper `apk-check-reboot` analysis).

## EXAMPLES

```bash
apk-list-userinstalled | wc -l
apk-list-packages-by-size 10
apk-backup ~/Backups/apk-pkgs.txt
apk-check-reboot
```

## SEE ALSO

- [.docs/aliases/alpine](../aliases/alpine.md)
- [.docs/plugins/zsh/alpine](../plugins/zsh/alpine.md)
- [.docs/utils/debian](debian.md), [.docs/utils/fedora](fedora.md) — sibling distros
- [.docs/README.md](../README.md)
