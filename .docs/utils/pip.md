# pip-utils

## NAME

**pip-utils** — Helpers for the pip package index cache, bulk upgrade/uninstall, and GitHub installs.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "pip" ...)
```

## DESCRIPTION

Returns silently unless either `pip` or `pip3` is on PATH. Provides cache-warming and cleanup helpers for a package-index completion cache (driven by the `$ZSH_PIP_CACHE_FILE` and `$ZSH_PIP_INDEXES` globals), `pipupall`/`pipunall` to upgrade or uninstall every installed package, and three thin wrappers (`pipig`, `pipigb`, `pipigp`) that install directly from GitHub repos, branches, or pull requests. Each install helper registers `compdef _pip <fn>` so that pip's own completion applies.

## FUNCTIONS

### `zsh-pip-clear-cache`

Deletes the package-index cache.

**Behavior:**

Runs `rm $ZSH_PIP_CACHE_FILE` and `unset piplist`.

**Example:**

```bash
zsh-pip-clear-cache
```

### `zsh-pip-clean-packages`

Streams pip simple-index HTML on stdin and emits one package name per line on stdout.

**Behavior:**

Uses `sed -n '/<a href/ s/.*>\([^<]\{1,\}\).*/\1/p'` to extract the visible text of `<a href=...>` entries. Helper for `zsh-pip-cache-packages`.

### `zsh-pip-cache-packages`

Builds the completion cache by downloading every `$ZSH_PIP_INDEXES` URL.

**Behavior:**

Creates the cache directory (`mkdir -p ${ZSH_PIP_CACHE_FILE:h}`) if missing. If `$ZSH_PIP_CACHE_FILE` does not yet exist, prints `(...caching package index...)`, then for each URL in `$ZSH_PIP_INDEXES` runs `curl -L "$index" | zsh-pip-clean-packages` into a `/tmp/zsh_tmp_cache` accumulator. Finally pipes through `sort | uniq | tr '\n' ' '` and writes the result to `$ZSH_PIP_CACHE_FILE`, removing the temp file.

**Example:**

```bash
export ZSH_PIP_CACHE_FILE=~/.cache/zsh/pip_index
export ZSH_PIP_INDEXES=(https://pypi.org/simple/)
zsh-pip-cache-packages
```

### `zsh-pip-test-clean-packages`

Regression test for the simple-index regex used by `zsh-pip-clean-packages`.

**Behavior:**

Pipes two hand-built HTML fixtures (one resembling PyPI's simple index, one resembling djangopypi2) into `zsh-pip-clean-packages` and prints either `python's simple index is fine` / `the djangopypi2 index is fine` or a diff against the expected output. No arguments.

### `pipupall`

Upgrades every outdated package in the active environment.

**Behavior:**

Picks GNU `xargs` if available (`xargs --no-run-if-empty`), else plain `xargs`. Pipes `pip list --outdated | awk 'NR > 2 { print $1 }'` through that xargs into `pip install --upgrade`.

**Example:**

```bash
pipupall
```

### `pipunall`

Uninstalls every package in the active environment.

**Behavior:**

Same xargs detection as above. Runs `pip list --format freeze | cut -d= -f1 | xargs pip uninstall` (no `-y`, so pip prompts for each package).

**Example:**

```bash
pipunall   # destructive: confirm prompts as they appear
```

### `pipig <user/repo>`

Installs a package directly from a GitHub repo's default branch.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | Yes | `user/repo` slug. |

**Behavior:**

Runs `pip install "git+https://github.com/$1.git"`. Pip completion is wired up via `compdef _pip pipig`.

**Example:**

```bash
pipig psf/requests
```

### `pipigb <user/repo> <branch-or-tag>`

Installs from a specific GitHub branch or tag.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | Yes | `user/repo` slug. |
| `$2` | Yes | Branch, tag, or ref. |

**Behavior:**

Runs `pip install "git+https://github.com/$1.git@$2"`. `compdef _pip pipigb`.

**Example:**

```bash
pipigb psf/requests main
```

### `pipigp <user/repo> <pr-number>`

Installs the head of a GitHub pull request.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | Yes | `user/repo` slug. |
| `$2` | Yes | Pull request number. |

**Behavior:**

Runs `pip install "git+https://github.com/$1.git@refs/pull/$2/head"`. `compdef _pip pipigp`.

**Example:**

```bash
pipigp psf/requests 6789
```

## VARIABLES

| Variable | Description |
| -------- | ----------- |
| `ZSH_PIP_CACHE_FILE` | Path to the cached package-name list used by completion. Defaults are not set by this module — export it yourself. |
| `ZSH_PIP_INDEXES` | Array of simple-index URLs to scrape when warming the cache. |

## REQUIREMENTS

- `pip` or `pip3`.
- `curl` and `sed` for cache warming.
- GNU `xargs` is preferred; BusyBox xargs works without `--no-run-if-empty`.

## EXAMPLES

```bash
# Upgrade everything in the current venv
pipupall

# Install Black from a specific tag
pipigb psf/black 24.10.0
```

## SEE ALSO

- [.docs/aliases/pip](../aliases/pip.md)
- [.docs/plugins/zsh/pip](../plugins/zsh/pip.md)
- [.docs/README.md](../README.md)
