# fedora-aliases

## NAME

**fedora-aliases** — short aliases for the DNF package manager on Fedora and RHEL-based distributions.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "fedora" ...)
```

## DESCRIPTION

Provides shortcuts for `dnf` — search, install, upgrade, remove, history,
group operations — plus a couple of helpers for installing local `.rpm`
files via `rpm -i`. Privileged operations are guarded by an inline
`(( $+commands[sudo] ))` check: when sudo is available they prepend `sudo`,
otherwise they fall back to `su -lc` with safely-quoted arguments (using
zsh's `${(j: :)${(qq)@}}` to neutralize quote injection).

## ALIASES

### Read-only

| Alias   | Expansion            | Description                        |
| ------- | -------------------- | ---------------------------------- |
| `dnfs`  | `dnf search`         | Search package names and summaries |
| `dnfq`  | `dnf info`           | Show package metadata              |
| `dnfg`  | `dnf grouplist`      | List package groups                |
| `dnfl`  | `dnf list`           | List packages (all)                |
| `dnfli` | `dnf list installed` | List only installed packages       |

### Privileged (sudo branch)

| Alias   | Expansion               | Description                       |
| ------- | ----------------------- | --------------------------------- |
| `dnfc`  | `sudo dnf clean all`    | Clean caches                      |
| `dnfu`  | `sudo dnf upgrade`      | Upgrade packages                  |
| `dnfuy` | `sudo dnf upgrade -y`   | Upgrade without prompting         |
| `dnfi`  | `sudo dnf install`      | Install packages                  |
| `dnfiy` | `sudo dnf install -y`   | Install without prompting         |
| `dnfp`  | `sudo dnf remove`       | Remove packages                   |
| `dnfpy` | `sudo dnf remove -y`    | Remove without prompting          |
| `dnfar` | `sudo dnf autoremove`   | Remove orphaned dependencies      |
| `dnfd`  | `sudo dnf downgrade`    | Downgrade a package               |
| `dnfr`  | `sudo dnf reinstall`    | Reinstall a package               |
| `dnfh`  | `sudo dnf history`      | Show transaction history          |
| `dnfgi` | `sudo dnf groupinstall` | Install a group                   |
| `dnfgu` | `sudo dnf groupupdate`  | Update a group                    |
| `dnfgp` | `sudo dnf groupremove`  | Remove a group                    |
| `dia`   | `sudo rpm -i ./*.rpm`   | Install every .rpm in current dir |
| `di`    | `sudo rpm -i`           | Install a specific .rpm           |

When `sudo` is not on PATH the same aliases fall back to `su -lc '...' root`
form, and the `dnfi`/`dnfp`/`dnfar` aliases become functions that quote
arguments safely.

### Misc

| Alias     | Expansion | Description              |
| --------- | --------- | ------------------------ |
| `allpkgs` | `rpm -qa` | List every installed RPM |

## FUNCTIONS

### `dnfi [pkg...]` / `dnfp [pkg...]` / `dnfar [pkg...]`

Only defined in the `su` fallback branch (no sudo on PATH). Each builds a
`su -lc 'dnf <verb> <args>' root` command, prints it for visibility, then
executes it. Arguments are passed through zsh's `${(qq)@}` quoting so a
package name containing a quote can't escape the inner single-quote context.

## REQUIREMENTS

- `dnf` on PATH (the entire module is a no-op without it).
- `sudo` (preferred) or `su`.
- `rpm` for the `dia` / `di` / `allpkgs` aliases.

## EXAMPLES

```bash
dnfu                              # upgrade everything
dnfiy htop ripgrep                # batch install, no prompt
dnfgi "Development Tools"          # install a group
dnfh | head                        # recent transactions
dia                                # install all .rpms in PWD
```

## SEE ALSO

- [.docs/plugins/zsh/fedora](../plugins/zsh/fedora.md)
- [.docs/utils/fedora](../utils/fedora.md)
- [.docs/aliases/debian](debian.md), [.docs/aliases/arch](arch.md) — sibling distros
- [.docs/README.md](../README.md)
