# krew-plugin

## NAME

**krew-plugin** — puts `krew`-installed `kubectl` plugins on PATH.

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "krew" ...)
```

## DESCRIPTION

[Krew](https://krew.sigs.k8s.io) is the package manager for `kubectl`
plugins; it installs binaries named `kubectl-foo` under `~/.krew/bin`
(or `$KREW_ROOT/bin`), where `kubectl` discovers them automatically and
exposes each as a `kubectl foo` subcommand. This plugin just prepends
that bin directory to `$PATH` (idempotently) when it exists. Without
`kubectl` on PATH the plugin no-ops, since `krew` has nothing to do
in that case.

Completion for individual plugins is handled by `kubectl`'s own
`_kubectl` completion via `kubectl plugin list`, so no extra completion
wiring is needed here.

## EFFECTS

- Returns immediately if `kubectl` is not on PATH.
- If `${KREW_ROOT:-$HOME/.krew}/bin` exists and isn't already on `$PATH`,
  prepends it.

## ENVIRONMENT

| Variable    | Read | Set | Default        | Purpose                                            |
| ----------- | ---- | --- | -------------- | -------------------------------------------------- |
| `KREW_ROOT` | Yes  | -   | `$HOME/.krew`  | Where `krew` installs plugins. Override to relocate. |
| `PATH`      | Yes  | Yes | (extended)     | Gains `$KREW_ROOT/bin` when that dir exists.       |

## FILES

| Path                       | Role                                                    |
| -------------------------- | ------------------------------------------------------- |
| `${KREW_ROOT:-$HOME/.krew}/bin` | Directory holding `kubectl-*` plugin binaries.     |
| `${KREW_ROOT:-$HOME/.krew}/index/` | Plugin index clones (managed by `kubectl krew`). |

## REQUIREMENTS

- `kubectl` on PATH.
- `krew` itself bootstrapped — see the upstream install guide at
  <https://krew.sigs.k8s.io/docs/user-guide/setup/install/>. Once
  bootstrapped, manage plugins with `kubectl krew install <name>` /
  `kubectl krew update` / `kubectl krew upgrade`.

## SEE ALSO

- [.docs/aliases/kubectl](../../aliases/kubectl.md)
- [.docs/plugins/zsh/kubectx](kubectx.md) — context/namespace switching
- [.docs/plugins/zsh/kubectl-fzf](kubectl-fzf.md) — fuzzy completion
- [.docs/README.md](../../README.md)
