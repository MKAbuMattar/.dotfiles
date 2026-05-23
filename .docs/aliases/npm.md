# npm-aliases

## NAME

**npm-aliases** — short aliases for `npm` install/run/list operations, using camelCase to avoid clashing with other npm-related tools.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "npm" ...)
```

## DESCRIPTION

Provides short aliases for the most common `npm` operations: installing globally / as a dependency / as a dev-dependency, listing packages, running scripts, and publishing. The module is gated by `(( ! $+commands[npm] )) && return`, so it loads only when `npm` is on `$PATH`.

npm package names are lowercase, so the module deliberately uses **camelCase** for several aliases to avoid clashing with installable packages: `npmS` (vs the [`npms`](https://www.npmjs.com/package/npms) package) and `npmD` (vs [`npmd`](https://github.com/dominictarr/npmd)) are notable examples.

## ALIASES

### Install

| Alias  | Expansion  | Description                               |
| ------ | ---------- | ----------------------------------------- |
| `npmg` | `npm i -g` | Install globally                          |
| `npmS` | `npm i -S` | Install and save to `dependencies`        |
| `npmD` | `npm i -D` | Install and save to `devDependencies`     |
| `npmF` | `npm i -f` | Force install, re-fetching even if cached |
| `npmI` | `npm init` | Initialize a `package.json`               |

### Inspect / Maintenance

| Alias   | Expansion          | Description                            |
| ------- | ------------------ | -------------------------------------- |
| `npmO`  | `npm outdated`     | List outdated packages                 |
| `npmU`  | `npm update`       | Update packages                        |
| `npmV`  | `npm -v`           | Show npm version                       |
| `npmL`  | `npm list`         | List installed packages                |
| `npmL0` | `npm ls --depth=0` | List top-level packages only           |
| `npmi`  | `npm info`         | Show package info (note lowercase `i`) |
| `npmSe` | `npm search`       | Search the registry                    |

### Scripts

| Alias   | Expansion       | Description            |
| ------- | --------------- | ---------------------- |
| `npmR`  | `npm run`       | Run an npm script      |
| `npmst` | `npm start`     | `npm start`            |
| `npmt`  | `npm test`      | `npm test`             |
| `npmrd` | `npm run dev`   | Run the `dev` script   |
| `npmrb` | `npm run build` | Run the `build` script |

### Publish / Path

| Alias  | Expansion                   | Description                                                              |
| ------ | --------------------------- | ------------------------------------------------------------------------ |
| `npmP` | `npm publish`               | Publish the package                                                      |
| `npmE` | `PATH="$(npm bin)":"$PATH"` | Prepend the local `node_modules/.bin` to `$PATH` for the current command |

## REQUIREMENTS

- `npm` installed and on `$PATH` (typically via Node.js).

## EXAMPLES

```bash
# Initialize a new package and install Express as a dependency
npmI -y
npmS express

# Add a dev tool
npmD typescript

# Run a local binary without installing globally
npmE gulp build

# Check top-level installed packages
npmL0
```

## SEE ALSO

- [.docs/plugins/zsh/npm](../plugins/zsh/npm.md)
- [.docs/aliases/pnpm](pnpm.md)
- [.docs/README.md](../README.md)
