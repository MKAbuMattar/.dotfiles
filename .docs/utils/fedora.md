# fedora-utils

## NAME

**fedora-utils** — Fedora helpers (not yet implemented).

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "fedora" ...)
```

## DESCRIPTION

Source file `.utils/fedora/fedora.util.zsh` is not present in the repository at the time this page was generated. Once the file is added it will provide Fedora-specific shell functions (likely wrappers around `dnf`, `rpm-ostree`, `flatpak`, and journal/log queries to mirror the `arch` and `debian` utils).

## FUNCTIONS

_None — module is a stub._

## REQUIREMENTS

- Fedora-family distribution (Fedora Workstation, Silverblue, Kinoite, etc.).
- `dnf` (or `dnf5`), `rpm-ostree`, and `flatpak` are the expected targets when the module ships.

## EXAMPLES

_None yet._

## SEE ALSO

- [.docs/aliases/fedora](../aliases/fedora.md)
- [.docs/plugins/zsh/fedora](../plugins/zsh/fedora.md)
- [.docs/utils/arch](arch.md) — parallel module for Arch Linux
- [.docs/utils/debian](debian.md) — parallel module for Debian/Ubuntu
- [.docs/README.md](../README.md)
