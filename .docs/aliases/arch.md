# arch-aliases

## NAME

**arch-aliases** — pacman and AUR-helper shortcuts for Arch-based distros.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "arch" ...)
```

## DESCRIPTION

Provides short prefixes for `pacman` plus a parallel set of `yac*` aliases
that bind to whichever AUR helper is available. Privileged operations are
gated by an inline `(( $+commands[sudo] ))` check: when `sudo` is present
the destructive aliases use `sudo pacman ...`; otherwise they fall back to
`su -c '...'`. AUR aliases are only defined when `yay` (preferred) or `paru`
is on `$PATH` — neither installed means no `yac*` shortcuts. Read-only
listing aliases (`paclist`, `pacinfo`, `pacown`, …) load unconditionally.

## ALIASES

### Pacman base

| Alias    | Expansion             | Description             |
| -------- | --------------------- | ----------------------- |
| `pacman` | `pacman --color auto` | Force coloured output.  |
| `p`      | `pacman`              | Two-character shortcut. |

### Search and info (read-only)

| Alias   | Expansion     | Description                                                              |
| ------- | ------------- | ------------------------------------------------------------------------ |
| `pacs`  | `pacman -Ss`  | Search remote repos.                                                     |
| `paci`  | `pacman -Si`  | Show remote package info (overridden to install when `sudo` is present). |
| `paclo` | `pacman -Qdt` | List orphan packages.                                                    |
| `pacls` | `pacman -Ql`  | List files in an installed package.                                      |
| `pacq`  | `pacman -Q`   | Query installed packages.                                                |

### Superuser operations (with `sudo`, when `(( $+commands[sudo] ))`)

| Alias    | Expansion                          | Description                     |
| -------- | ---------------------------------- | ------------------------------- |
| `pacu`   | `sudo pacman -Syu`                 | Sync databases and upgrade.     |
| `paci`   | `sudo pacman -S`                   | Install package(s).             |
| `pacr`   | `sudo pacman -R`                   | Remove.                         |
| `pacrr`  | `sudo pacman -Rns`                 | Remove with deps and config.    |
| `pacc`   | `sudo pacman -Sc`                  | Clean cached packages.          |
| `paccc`  | `sudo pacman -Scc`                 | Clean all cached packages.      |
| `pacro`  | `sudo pacman -Rns $(pacman -Qtdq)` | Remove orphans.                 |
| `pacmir` | `sudo pacman -Syy`                 | Force-refresh databases.        |
| `pacup`  | `sudo pacman -Sy`                  | Refresh databases.              |
| `pacupg` | `sudo pacman -Syu`                 | Upgrade.                        |
| `pacin`  | `sudo pacman -S`                   | Install (alias of `paci`).      |
| `pacins` | `sudo pacman -U`                   | Install a local `.pkg.tar.zst`. |
| `pacre`  | `sudo pacman -R`                   | Remove.                         |
| `pacrem` | `sudo pacman -Rns`                 | Remove with deps.               |

### Superuser operations (fallback to `su -c`)

When `sudo` is **not** found, the same alias names instead wrap the command
in `su -c '...'`, e.g. `pacu="su -c 'pacman -Syu'"`. `pacro` is omitted in
this branch.

### AUR helper (yay preferred, paru fallback)

Only defined when `yay` **or** `paru` is on `$PATH`. Expansions use the
detected helper.

| Alias   | Expansion (`yay` present) | Description                        |
| ------- | ------------------------- | ---------------------------------- |
| `yacu`  | `yay -Syu`                | Update all packages including AUR. |
| `yaci`  | `yay -S`                  | Install from official + AUR.       |
| `yacs`  | `yay -Ss`                 | Search official + AUR.             |
| `yacr`  | `yay -R`                  | Remove.                            |
| `yacrr` | `yay -Rns`                | Remove with deps.                  |
| `yacc`  | `yay -Sc`                 | Clean.                             |
| `yaccc` | `yay -Scc`                | Clean all.                         |

### Miscellaneous queries (no sudo)

| Alias        | Expansion                        | Description                            |
| ------------ | -------------------------------- | -------------------------------------- |
| `paclist`    | `pacman -Qqe`                    | All explicitly installed (names only). |
| `paclistall` | `pacman -Q`                      | All installed packages.                |
| `pacexp`     | `pacman -Qe`                     | Explicitly installed.                  |
| `pacfor`     | `pacman -Qm`                     | Foreign (AUR) packages.                |
| `pacnat`     | `pacman -Qn`                     | Native (official repo) packages.       |
| `pacinfo`    | `pacman -Qi`                     | Detailed info on an installed package. |
| `pacfiles`   | `pacman -Ql`                     | List files owned by a package.         |
| `pacown`     | `pacman -Qo`                     | Find owner of a file.                  |
| `paccheck`   | `pacman -Dk`                     | Check missing dependencies.            |
| `pacunlock`  | `sudo rm /var/lib/pacman/db.lck` | Remove stale db lock.                  |
| `pacorphans` | `pacman -Qdt`                    | List orphans.                          |

## REQUIREMENTS

- `pacman` (Arch / Manjaro / EndeavourOS / …).
- `sudo` is preferred; `su` is used as a fallback when sudo is absent.
- Optional: `yay` or `paru` for AUR aliases (`yac*`). The module probes them
  with `(( $+commands[yay] ))` then `(( $+commands[paru] ))`.

## EXAMPLES

```bash
pacs neovim                # Search remote repos
pacu                       # Sync and upgrade (sudo)
pacro                      # Remove every orphan in one go
yacs godot                 # Search AUR + repos
pacown /usr/bin/zsh        # Which package owns this file?
```

## SEE ALSO

- [.docs/plugins/zsh/arch.md](../plugins/zsh/arch.md)
- [.docs/utils/arch.md](../utils/arch.md)
- [.docs/README.md](../README.md)
