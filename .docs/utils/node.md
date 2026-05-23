# node-utils

## NAME

**node-utils** — helpers around nvm, npm-global, pnpm, and yarn for keeping a Node toolchain healthy.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "node" ...)
```

## DESCRIPTION

A no-op when neither `node` nor `nvm` is present on the system. Otherwise
defines a small set of functions for tasks that the underlying tooling
doesn't make convenient: one-shot Node upgrades that survive across
machines (preserves globally-installed packages and bumps npm), global-
package maintenance, pnpm/yarn bootstrap on a fresh nvm install, and a
prune helper that keeps only the default Node version installed.

The module loads `$NVM_DIR/nvm.sh` on demand if nvm is installed but not
yet loaded in the current shell.

## FUNCTIONS

### `update-node [--current|-c]`

Upgrade Node.js via nvm. Defaults to the latest LTS release;
`--current` (or `-c`) targets the latest release including non-LTS.
Re-installs every globally-installed package from the previously active
version and bumps npm to the latest stable. Finally re-points the
`default` nvm alias at the new version so new shells pick it up.

```bash
update-node              # latest LTS
update-node --current    # very latest
```

### `node-versions`

`nvm ls` — list installed Node versions plus which is `default` and
which is currently active.

### `install-pnpm [version]`

Run `npm install -g pnpm@<version>` (default `@latest`). Prints the
resolved binary path and version on success.

```bash
install-pnpm
install-pnpm 9
```

### `install-yarn`

Classic yarn v1 install via `npm install -g yarn`. For yarn berry use
`corepack enable && corepack prepare yarn@stable --activate` instead.

### `npm-outdated-global`

Shortcut for `npm outdated -g --depth=0` — shows globally-installed
packages with an available newer version.

### `npm-upgrade-global`

Run `npm update -g` to upgrade every globally-installed package to the
latest version satisfying its declared range.

### `nvm-prune`

Uninstall every nvm-installed Node version _except_ the one set as the
`default` alias. Refuses to run if no default alias is set, to avoid
wiping the wrong version.

## REQUIREMENTS

- One of:
  - `nvm` installed (the module sources `$NVM_DIR/nvm.sh` if needed)
  - `node` on PATH (subset of functions still work — anything that
    doesn't invoke `nvm` directly)
- `npm` for `install-pnpm`, `install-yarn`, `npm-outdated-global`,
  `npm-upgrade-global`

## EXAMPLES

```bash
update-node                       # upgrade to latest LTS
install-pnpm                      # one-shot pnpm bootstrap
npm-outdated-global               # what's stale?
npm-upgrade-global                # bring everything current
nvm-prune                         # reclaim disk: drop all old node versions
```

## SEE ALSO

- [.docs/aliases/npm](../aliases/npm.md), [.docs/aliases/pnpm](../aliases/pnpm.md)
- [.docs/plugins/zsh/npm](../plugins/zsh/npm.md), [.docs/plugins/zsh/pnpm](../plugins/zsh/pnpm.md)
- nvm — https://github.com/nvm-sh/nvm
- pnpm — https://pnpm.io
- [.docs/README.md](../README.md)
