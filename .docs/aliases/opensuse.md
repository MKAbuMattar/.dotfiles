# opensuse-aliases

## NAME

**opensuse-aliases** — short aliases for the zypper package manager on openSUSE and SLES.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "opensuse" ...)
```

## DESCRIPTION

Provides shortcuts for `zypper` — search, install, upgrade, remove, refresh,
patterns, services, repos, history — plus helpers for installing local
`.rpm` files. Privileged operations are guarded by an inline
`(( $+commands[sudo] ))` check: when sudo is on PATH they prepend `sudo`,
otherwise they fall back to `su -lc` with safely-quoted arguments via
zsh's `${(j: :)${(qq)@}}`.

## ALIASES

### Read-only

| Alias   | Expansion                          | Description                  |
| ------- | ---------------------------------- | ---------------------------- |
| `zys`   | `zypper search`                    | Search for a package         |
| `zyq`   | `zypper info`                      | Show package metadata        |
| `zyl`   | `zypper packages`                  | List all packages in repos   |
| `zyli`  | `zypper packages --installed-only` | List installed packages      |
| `zypl`  | `zypper patterns`                  | List available patterns      |
| `zysrv` | `zypper services`                  | Show configured services     |
| `zyrep` | `zypper repos`                     | Show configured repositories |

### Privileged (sudo branch)

| Alias    | Expansion                         | Description                       |
| -------- | --------------------------------- | --------------------------------- |
| `zyc`    | `sudo zypper clean -a`            | Clean all caches                  |
| `zyr`    | `sudo zypper refresh`             | Refresh repo metadata             |
| `zyu`    | `sudo zypper update`              | Update packages (within release)  |
| `zyuy`   | `sudo zypper update -y`           | Same, non-interactive             |
| `zyup`   | `sudo zypper dist-upgrade`        | Cross-release upgrade             |
| `zyupy`  | `sudo zypper dist-upgrade -y`     | Same, non-interactive             |
| `zyi`    | `sudo zypper install`             | Install package(s)                |
| `zyiy`   | `sudo zypper install -y`          | Install, non-interactive          |
| `zyp`    | `sudo zypper remove`              | Remove package(s)                 |
| `zypy`   | `sudo zypper remove -y`           | Remove, non-interactive           |
| `zyar`   | `sudo zypper packages --orphaned` | Show orphaned packages            |
| `zyptni` | `sudo zypper install -t pattern`  | Install a pattern                 |
| `zyptnp` | `sudo zypper remove -t pattern`   | Remove a pattern                  |
| `zyh`    | `zypper history`                  | Show transaction history          |
| `zyps`   | `sudo zypper ps -s`               | Show services needing restart     |
| `dia`    | `sudo rpm -i ./*.rpm`             | Install every .rpm in current dir |
| `di`     | `sudo rpm -i`                     | Install a specific .rpm           |

When `sudo` is not on PATH, the same aliases fall back to `su -lc '...' root`
form, and `zyi`/`zyp` become functions that quote arguments safely.

### Misc

| Alias     | Expansion | Description              |
| --------- | --------- | ------------------------ |
| `allpkgs` | `rpm -qa` | List every installed RPM |

## FUNCTIONS

### `zyi [pkg...]` / `zyp [pkg...]`

Only defined in the `su` fallback branch. Each builds a
`su -lc 'zypper <verb> <args>' root` command and runs it after printing.
Arguments are passed through zsh's `${(qq)@}` quoting.

## REQUIREMENTS

- `zypper` on PATH (the entire module is a no-op without it).
- `sudo` (preferred) or `su`.
- `rpm` for the `dia` / `di` / `allpkgs` aliases.

## EXAMPLES

```bash
zyu                                # update
zyiy htop ripgrep                  # batch install, no prompt
zyptni devel_basis                 # install the "devel_basis" pattern
zyps                               # which services need restart?
```

## SEE ALSO

- [.docs/plugins/zsh/opensuse](../plugins/zsh/opensuse.md)
- [.docs/utils/opensuse](../utils/opensuse.md)
- [.docs/aliases/fedora](fedora.md), [.docs/aliases/debian](debian.md) — sibling distros
- [.docs/README.md](../README.md)
