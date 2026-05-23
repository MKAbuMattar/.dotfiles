# git-plugin

## NAME

**git-plugin** — prompt support functions for git (branch, dirtiness, status
symbols).

## SYNOPSIS

```text
# Enable by adding to the PLUGINS array in ~/.zshrc:
PLUGINS=(... "git" ...)
```

## DESCRIPTION

This plugin does not register a new completer (the system `_git` continues to
serve that role). Instead it provides the prompt-side helpers familiar from
oh-my-zsh — `git_prompt_info`, `git_prompt_status`, `parse_git_dirty`, and
`git_current_branch` — used by theme files in `RPROMPT`/`PROMPT` strings. All
git calls go through `__git_prompt_git`, which forces
`GIT_OPTIONAL_LOCKS=0` so the prompt never contends with concurrent git
operations for the index lock.

`git_prompt_info` reports the current ref (branch, exact tag, or short hash)
optionally followed by `" -> upstream"` when `ZSH_THEME_GIT_SHOW_UPSTREAM` is
set, plus a dirty/clean marker. `git_prompt_status` parses
`git status --porcelain -b` and concatenates a sequence of
`ZSH_THEME_GIT_PROMPT_*` glyphs for each detected condition (untracked, added,
modified, renamed, deleted, unmerged, stashed, ahead, behind, diverged).
`parse_git_dirty` returns the dirty/clean marker on its own. Both honour
`oh-my-zsh.hide-info` / `oh-my-zsh.hide-status` / `oh-my-zsh.hide-dirty`
git-config switches and the `DISABLE_UNTRACKED_FILES_DIRTY` and
`GIT_STATUS_IGNORE_SUBMODULES` env vars.

## EFFECTS

- Returns immediately if `git` is not on `$PATH`.
- Sets `$ZSH_CACHE_DIR` to `$HOME/.cache/zsh` if not already set.
- Creates `$ZSH_CACHE_DIR/completions/` and prepends it to `fpath` (kept for
  consistency; this plugin does not write into it).
- Autoloads `is-at-least` and captures the git version into the local
  `$git_version` (which is then unset on exit).
- Defines the helper functions described in FUNCTIONS.

## FUNCTIONS

| Function | Purpose |
| -------- | ------- |
| `__git_prompt_git ARGS...` | Runs `git "$@"` with `GIT_OPTIONAL_LOCKS=0` so prompt invocations never block other git processes. |
| `_omz_git_prompt_info` | Builds `"${ZSH_THEME_GIT_PROMPT_PREFIX}<ref>[ -> upstream](dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"`. Respects `oh-my-zsh.hide-info`. `%` characters in the ref/upstream are escaped. |
| `_omz_git_prompt_status` | Walks `git status --porcelain -b` and the stash and emits a string of `ZSH_THEME_GIT_PROMPT_*` markers in the order UNTRACKED, ADDED, MODIFIED, RENAMED, DELETED, STASHED, UNMERGED, AHEAD, BEHIND, DIVERGED. Respects `oh-my-zsh.hide-status`. |
| `git_prompt_info` | Public wrapper around `_omz_git_prompt_info`. |
| `git_prompt_status` | Public wrapper around `_omz_git_prompt_status`. |
| `parse_git_dirty` | Returns `$ZSH_THEME_GIT_PROMPT_DIRTY` or `$ZSH_THEME_GIT_PROMPT_CLEAN` based on `git status --porcelain`. Honours `oh-my-zsh.hide-dirty`, `DISABLE_UNTRACKED_FILES_DIRTY`, and `GIT_STATUS_IGNORE_SUBMODULES`. |
| `git_current_branch` | Prints the current branch via `git symbolic-ref --quiet HEAD`, falling back to a short hash when detached; silent outside a repo. |

## ENVIRONMENT

| Variable | Read/Set | Default | Purpose |
| -------- | -------- | ------- | ------- |
| `ZSH_CACHE_DIR` | Read (defaulted) | `$HOME/.cache/zsh` | Completion cache directory (created/added to fpath). |
| `ZSH_THEME_GIT_PROMPT_PREFIX` / `_SUFFIX` | Read | — | Wraps the output of `git_prompt_info`. |
| `ZSH_THEME_GIT_PROMPT_DIRTY` / `_CLEAN` | Read | — | Markers appended by `parse_git_dirty`. |
| `ZSH_THEME_GIT_PROMPT_UNTRACKED`, `_ADDED`, `_MODIFIED`, `_RENAMED`, `_DELETED`, `_UNMERGED`, `_AHEAD`, `_BEHIND`, `_DIVERGED`, `_STASHED` | Read | — | Per-condition markers used by `git_prompt_status`. |
| `ZSH_THEME_GIT_SHOW_UPSTREAM` | Read | unset | When set, append `" -> upstream-ref"` to `git_prompt_info`. |
| `DISABLE_UNTRACKED_FILES_DIRTY` | Read | unset | When `true`, `parse_git_dirty` passes `--untracked-files=no`. |
| `GIT_STATUS_IGNORE_SUBMODULES` | Read | `dirty` | Value (or `git` to drop the flag) for `git status --ignore-submodules=`. |
| `GIT_OPTIONAL_LOCKS` | Set inline to `0` for each call | — | Prevents prompt git from touching `index.lock`. |

## FILES

| Path | Role |
| ---- | ---- |
| `<repo>/.git/config` | Read for the `oh-my-zsh.hide-info`, `oh-my-zsh.hide-status`, `oh-my-zsh.hide-dirty` keys. |

## REQUIREMENTS

- `git` on `$PATH`. The plugin no-ops otherwise.

## SEE ALSO

- [.docs/README.md](../../README.md)
