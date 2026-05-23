# fedora-plugin

## NAME

**fedora-plugin** — placeholder documentation; plugin source not present.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "fedora" ...)
```

## DESCRIPTION

No source file was found at
`.plugins/.zsh/fedora/fedora.plugin.zsh` at the time this documentation was
generated. By analogy with the `arch` and `debian` plugins, the expected role
is to wire up zsh completion for Fedora's package manager (`dnf`, possibly
`rpm`), no-op on non-Fedora systems, and follow the standard
`ZSH_CACHE_DIR/completions/` + `fpath` pattern. Update this document once the
plugin is added.

## EFFECTS

- _To be documented when the plugin is implemented._

## REQUIREMENTS

- Fedora-family system with `dnf` (and/or `rpm`) on `$PATH`.

## SEE ALSO

- [.docs/aliases/fedora.md](../../aliases/fedora.md) — if applicable
- [.docs/utils/fedora.md](../../utils/fedora.md) — if applicable
- [.docs/plugins/zsh/arch.md](arch.md) — sibling distro plugin to mirror.
- [.docs/plugins/zsh/debian.md](debian.md) — sibling distro plugin to mirror.
- [.docs/README.md](../../README.md)
