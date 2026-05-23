# kubectx-aliases

## NAME

**kubectx-aliases** — short prefixes for switching Kubernetes contexts and namespaces.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "kubectx" ...)
```

## DESCRIPTION

`kubectx` and `kubens` are kept available under their full names; this
module adds two-letter prefixes (`kx` for contexts, `kn` for namespaces)
and their common sub-actions so you can swap context/namespace with one
or two keystrokes. The module no-ops if neither `kubectx` nor `kubens` is
on PATH.

## ALIASES

### Context (`kx*`)

| Alias | Expansion    | Description                                       |
| ----- | ------------ | ------------------------------------------------- |
| `kx`  | `kubectx`    | List contexts, or switch to one passed as arg.    |
| `kxc` | `kubectx -c` | Print the current context (silent / scriptable).  |
| `kxd` | `kubectx -d` | Delete a context.                                 |
| `kxu` | `kubectx -u` | Unset the current context.                        |
| `kxp` | `kubectx -`  | Switch to the **previous** context.               |

### Namespace (`kn*`)

| Alias | Expansion   | Description                                       |
| ----- | ----------- | ------------------------------------------------- |
| `kn`  | `kubens`    | List namespaces, or switch to one passed as arg.  |
| `knc` | `kubens -c` | Print the current namespace.                      |
| `knp` | `kubens -`  | Switch to the **previous** namespace.             |

## REQUIREMENTS

- `kubectx` and `kubens` on PATH (often shipped together — Debian/Ubuntu:
  `apt install kubectx`; Arch: `pacman -S kubectx`; macOS: `brew install kubectx`).
- Optional: `fzf` on PATH — `kubectx`/`kubens` detect it automatically and
  switch to a fuzzy picker when no argument is given.

## EXAMPLES

```bash
kx                     # interactive picker (if fzf installed) or list
kx prod-eu             # switch context to prod-eu
kxp                    # back to the previous context
kn kube-system         # change namespace to kube-system
knc                    # what namespace am I in?
```

## SEE ALSO

- [.docs/plugins/zsh/kubectx](../plugins/zsh/kubectx.md) — completion wiring
- [.docs/aliases/kubectl](kubectl.md)
- [.docs/README.md](../README.md)
