# kubectl-fzf-plugin

## NAME

**kubectl-fzf-plugin** — sources the upstream `kubectl-fzf` plugin for fast fuzzy kubectl completion.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "kubectl-fzf" ...)
```

## DESCRIPTION

[`kubectl-fzf`](https://github.com/bonnefoa/kubectl-fzf) replaces
`kubectl`'s slow completion with a fzf-driven picker backed by a local
cache that's continuously updated by a `cache_builder` daemon. This
repo's plugin file does **not** ship the upstream code — it just locates
and sources whichever copy of `kubectl_fzf.plugin.zsh` is installed on
the system, checking a small set of standard install paths in order. If
neither `kubectl` nor `fzf` is on PATH, or if no upstream install is
found, the plugin silently no-ops.

## EFFECTS

- Returns immediately if `kubectl` is not on PATH.
- Returns immediately if `fzf` is not on PATH.
- Searches the install locations below in order and sources the first
  `kubectl_fzf.plugin.zsh` it finds.
- Returns silently if none are found (uncomment the hint line in the
  source to print an install reminder instead).

## ENVIRONMENT

This plugin sets nothing itself. The upstream `kubectl_fzf.plugin.zsh`
honours `KUBECTL_FZF_OPTIONS`, `KUBECTL_FZF_CACHE`, and similar
variables — set them in your `~/.zshenv` before this plugin sources.

## FILES

Searched in order, first match wins:

| Path                                                   | Role                                  |
| ------------------------------------------------------ | ------------------------------------- |
| `$HOME/.kubectl_fzf/kubectl_fzf.plugin.zsh`            | Default upstream install location.    |
| `$HOME/.local/share/kubectl-fzf/kubectl_fzf.plugin.zsh` | XDG-style local install.             |
| `/opt/kubectl-fzf/kubectl_fzf.plugin.zsh`              | System-wide custom install.           |
| `/usr/local/share/kubectl-fzf/kubectl_fzf.plugin.zsh`  | System-wide standard install.         |

## REQUIREMENTS

- `kubectl` on PATH.
- `fzf` on PATH.
- An installed copy of `kubectl-fzf` from
  <https://github.com/bonnefoa/kubectl-fzf>.
- The `cache_builder` daemon running (`kubectl fzf cache_builder` or the
  upstream systemd unit) so completion data stays fresh.

## SEE ALSO

- [.docs/aliases/kubectl](../../aliases/kubectl.md)
- [.docs/plugins/zsh/kubectx](kubectx.md) — context/namespace switching
- [.docs/plugins/zsh/krew](krew.md) — kubectl plugin manager
- [.docs/README.md](../../README.md)
