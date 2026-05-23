# opensuse-utils

## NAME

**opensuse-utils** — zypper helpers for history queries, package backup/restore, orphan cleanup, restart-needed checks, and interactive search.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "opensuse" ...)
```

## DESCRIPTION

A no-op when `zypper` is not on PATH. Otherwise defines a suite of helper
functions for tasks the underlying `zypper` CLI doesn't make convenient.
Reads from `/var/log/zypp/history` directly (zypper's structured log) for
history queries.

## FUNCTIONS

### `zypper-history <action>`

Filter `/var/log/zypp/history` by transaction type. Requires read access to
the log (typically root, but readable to wheel on most installations).

**Arguments:**

| Arg  | Required | Description                              |
| ---- | -------- | ---------------------------------------- |
| `$1` | Yes      | `install` / `remove` / `update` / `list` |

```bash
zypper-history install
zypper-history update | head
```

### `zypper-list-userinstalled`

List packages that are explicitly installed (not orphaned dependencies),
parsed from `zypper packages --installed-only --orphaned`.

### `zypper-list-packages-by-size [N]`

Show the largest installed packages on disk, sorted descending. `N`
defaults to 30. Uses `rpm -qa --queryformat '%{SIZE}\t%{NAME}\n'`.

### `zypper-remove-orphans`

Run `zypper remove --clean-deps` on every package marked orphaned by
`zypper packages --orphaned`. Prints "No orphaned packages found." when
there's nothing to do.

### `zypper-backup [file]`

Save the explicitly-installed package list to `<file>` (default
`packages_<YYYYMMDD>.txt`).

### `zypper-restore <file>`

Read a package list and install it via `zypper install`.

### `zypper-check-reboot`

Run `zypper ps -s` to show services that are using files which have been
updated and need a restart.

### `zypper-search-install <term>`

Interactive search-and-install: pipes `zypper search` results into `fzf`
with a `zypper info` preview, installs the selected package. Requires
`fzf` on PATH.

## REQUIREMENTS

- `zypper` on PATH.
- `rpm` for `zypper-list-packages-by-size`.
- `sudo` (preferred) or `su` for privileged helpers.
- `fzf` for `zypper-search-install` only.
- Read access to `/var/log/zypp/history` for `zypper-history`.

## EXAMPLES

```bash
zypper-history install | tail -20
zypper-backup ~/Backups/zypper-pkgs.txt
zypper-check-reboot
zypper-search-install neovim
```

## SEE ALSO

- [.docs/aliases/opensuse](../aliases/opensuse.md)
- [.docs/plugins/zsh/opensuse](../plugins/zsh/opensuse.md)
- [.docs/utils/fedora](fedora.md), [.docs/utils/debian](debian.md) — sibling distros
- [.docs/README.md](../README.md)
