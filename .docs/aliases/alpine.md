# alpine-aliases

## NAME

**alpine-aliases** — short aliases for `apk`, the Alpine Linux package manager.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "alpine" ...)
```

## DESCRIPTION

Provides shortcuts for `apk` — search, info, list, add (install), del
(remove), update, upgrade, fix, audit, verify, and cache cleanup.
Privileged operations are guarded by an inline `(( $+commands[sudo] ))`
check: with sudo on PATH they prepend `sudo`, otherwise they fall back to
`su -lc` with safely-quoted arguments via zsh's `${(j: :)${(qq)@}}`.

apk uses non-standard verbs compared to apt/dnf/zypper:

- `apk add` → install
- `apk del` → remove
- `apk fix` → repair broken installs
- `apk audit` → check changed files
- `apk verify` → verify installed packages against their checksums

The aliases below normalize them to the same prefix scheme as the other
distro modules so muscle memory still works.

## ALIASES

### Read-only

| Alias   | Expansion              | Description                            |
| ------- | ---------------------- | -------------------------------------- |
| `apks`  | `apk search`           | Search the package index               |
| `apkq`  | `apk info`             | Show package metadata                  |
| `apkl`  | `apk list`             | List all known packages                |
| `apkli` | `apk list --installed` | List only installed packages           |
| `apkw`  | `cat /etc/apk/world`   | Show explicitly-installed package list |

### Privileged (sudo branch)

| Alias    | Expansion                      | Description                        |
| -------- | ------------------------------ | ---------------------------------- |
| `apkupd` | `sudo apk update`              | Refresh repository indexes         |
| `apku`   | `sudo apk upgrade`             | Upgrade all packages               |
| `apkua`  | `sudo apk upgrade --available` | Upgrade available packages         |
| `apki`   | `sudo apk add`                 | Install package(s)                 |
| `apkp`   | `sudo apk del`                 | Remove package(s)                  |
| `apkpu`  | `sudo apk del --purge`         | Remove + delete configs            |
| `apkr`   | `sudo apk fix`                 | Repair broken installs             |
| `apkc`   | `sudo apk cache clean`         | Clean the package cache            |
| `apkv`   | `sudo apk verify`              | Verify installed package checksums |
| `apkad`  | `sudo apk audit`               | Audit files changed since install  |

When `sudo` is not on PATH, `apkupd`/`apku`/`apkc` fall back to `su -lc`
form, and `apki`/`apkp` become functions that quote arguments safely.

### Misc

| Alias     | Expansion     | Description                                |
| --------- | ------------- | ------------------------------------------ |
| `allpkgs` | `apk info -e` | List explicitly-installed packages (world) |

## FUNCTIONS

### `apki [pkg...]` / `apkp [pkg...]`

Only defined in the `su` fallback branch. Each builds a
`su -lc 'apk add|del <args>' root` command after safely quoting arguments.

## REQUIREMENTS

- `apk` on PATH (the entire module is a no-op without it).
- `sudo` (preferred) or `su`.
- Alpine doesn't ship bash by default — the aliases work fine in zsh, but
  if you also run the `setup` script, install `bash` first: `apk add bash`.

## EXAMPLES

```bash
apkupd && apku                  # refresh repos and upgrade
apki htop ripgrep               # install
apkad                           # audit changed files
apkw | head                     # explicitly installed
```

## SEE ALSO

- [.docs/plugins/zsh/alpine](../plugins/zsh/alpine.md)
- [.docs/utils/alpine](../utils/alpine.md)
- [.docs/aliases/debian](debian.md), [.docs/aliases/fedora](fedora.md) — sibling distros
- [.docs/README.md](../README.md)
