# pnpm-aliases

## NAME

**pnpm-aliases** — short aliases for the `pnpm` package manager covering install, scripts, workspaces, global packages, store, and patching.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "pnpm" ...)
```

## DESCRIPTION

Provides short `pn*` aliases for `pnpm` operations: adding/removing packages, running scripts, installing with or without a frozen lockfile, updating, listing, managing the global store, working with workspaces (recursive and `--filter`), patching dependencies, and publishing. The module is gated by `(( ! $+commands[pnpm] )) && return`, so it loads only when `pnpm` is on `$PATH`.

## ALIASES

### Install / Add / Remove

| Alias   | Expansion                        | Description                            |
| ------- | -------------------------------- | -------------------------------------- |
| `pna`   | `pnpm add`                       | Add a dependency                       |
| `pnad`  | `pnpm add --save-dev`            | Add a dev dependency                   |
| `pnap`  | `pnpm add --save-peer`           | Add a peer dependency                  |
| `pnrm`  | `pnpm remove`                    | Remove a dependency                    |
| `pni`   | `pnpm install`                   | Install dependencies                   |
| `pnif`  | `pnpm install --frozen-lockfile` | Install with frozen lockfile (CI mode) |
| `pnup`  | `pnpm update`                    | Update dependencies                    |
| `pnupi` | `pnpm update --interactive`      | Interactive update                     |
| `pnupl` | `pnpm update --latest`           | Update to latest, ignoring ranges      |

### Scripts

| Alias  | Expansion    | Description  |
| ------ | ------------ | ------------ |
| `pnr`  | `pnpm run`   | Run a script |
| `pnst` | `pnpm start` | Run `start`  |
| `pnt`  | `pnpm test`  | Run `test`   |
| `pnb`  | `pnpm build` | Run `build`  |
| `pnd`  | `pnpm dev`   | Run `dev`    |

### List

| Alias   | Expansion            | Description                     |
| ------- | -------------------- | ------------------------------- |
| `pnls`  | `pnpm list`          | List dependencies               |
| `pnlsg` | `pnpm list --global` | List global packages            |
| `pnlsd` | `pnpm list --depth`  | List with depth (pass a number) |

### Global

| Alias   | Expansion              | Description             |
| ------- | ---------------------- | ----------------------- |
| `pnga`  | `pnpm add --global`    | Add a global package    |
| `pngrm` | `pnpm remove --global` | Remove a global package |
| `pngls` | `pnpm list --global`   | List global packages    |
| `pngup` | `pnpm update --global` | Update global packages  |

### Misc

| Alias   | Expansion       | Description                                      |
| ------- | --------------- | ------------------------------------------------ |
| `pnin`  | `pnpm init`     | Initialize a `package.json`                      |
| `pnln`  | `pnpm link`     | Link a package                                   |
| `pnuln` | `pnpm unlink`   | Unlink a package                                 |
| `pnout` | `pnpm outdated` | List outdated packages                           |
| `pnwhy` | `pnpm why`      | Explain why a package is installed               |
| `pnex`  | `pnpm exec`     | Run a binary from `node_modules/.bin`            |
| `pndlx` | `pnpm dlx`      | Run a package without installing it persistently |
| `pnpub` | `pnpm publish`  | Publish the package                              |

### Workspace

| Alias   | Expansion                  | Description                   |
| ------- | -------------------------- | ----------------------------- |
| `pnwr`  | `pnpm --filter`            | Filter to a workspace package |
| `pnwi`  | `pnpm install --recursive` | Install across all workspaces |
| `pnwup` | `pnpm update --recursive`  | Update across all workspaces  |

### Store

| Alias     | Expansion           | Description                                |
| --------- | ------------------- | ------------------------------------------ |
| `pnsc`    | `pnpm store status` | Show store status                          |
| `pnsp`    | `pnpm store prune`  | Prune unreferenced packages from the store |
| `pnspath` | `pnpm store path`   | Print the store path                       |

### Patch

| Alias      | Expansion           | Description              |
| ---------- | ------------------- | ------------------------ |
| `pnpatch`  | `pnpm patch`        | Begin patching a package |
| `pnpatchc` | `pnpm patch-commit` | Commit a patch           |

## REQUIREMENTS

- `pnpm` installed and on `$PATH`.

## EXAMPLES

```bash
# Install with a frozen lockfile (CI)
pnif

# Add TypeScript as a dev dependency
pnad typescript

# Update everything in the workspace
pnwup

# Filter a script to a single workspace
pnwr @scope/app run build

# Run a one-off binary
pndlx create-vite my-app
```

## SEE ALSO

- [.docs/aliases/npm](npm.md)
- [.docs/README.md](../README.md)
