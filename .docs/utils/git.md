# git-utils

## NAME

**git-utils** — Helper functions for branch resolution, prompt info, and log rendering used by git aliases and themes.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "git" ...)
```

## DESCRIPTION

Provides helpers used by the git alias suite and zsh themes to resolve the project's "main" and "develop" branches, query ahead/behind status, render prompt fragments, and produce a polished `git log` tree. The module no-ops (`return`) when `git` is not on PATH. It captures `git_version` at load time (using `autoload is-at-least`) and unsets it on exit. All git invocations go through `__git_prompt_git`, which calls `command git` with `GIT_OPTIONAL_LOCKS=0` set to avoid contending with foreground git operations.

## FUNCTIONS

### `git_develop_branch`

Echoes the name of the develop branch.

**Behavior:**

Returns silently if not inside a git repo. Probes local refs in order `dev`, `devel`, `develop`, `development` via `git show-ref -q --verify refs/heads/<name>` and echoes the first match. If none exist, echoes `develop` and returns 1.

**Example:**

```bash
git rebase "$(git_develop_branch)"
```

### `git_main_branch`

Echoes the project's primary branch name.

**Behavior:**

Returns silently if not inside a git repo. Probes `refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}` and echoes the leaf of the first hit. If nothing is found locally, asks `git rev-parse --abbrev-ref origin/HEAD` and `upstream/HEAD` for the remote's symbolic default. Final fallback echoes `master` and returns 1.

**Example:**

```bash
git checkout "$(git_main_branch)"
```

### `grename <old_branch> <new_branch>`

Renames a branch locally and on the `origin` remote.

**Arguments:**

| Arg  | Required | Description              |
| ---- | -------- | ------------------------ |
| `$1` | Yes      | Existing branch name.    |
| `$2` | Yes      | Desired new branch name. |

**Behavior:**

Prints usage and returns 1 if either argument is missing. Otherwise runs `git branch -m`, then `git push origin :<old>`; on success follows with `git push --set-upstream origin <new>`.

**Example:**

```bash
grename feature/old-name feature/new-name
```

### `gunwipall`

Recursively unwinds all consecutive `--wip--` commits at HEAD.

**Behavior:**

Captures the most recent non-WIP commit with `git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H`. If that commit differs from HEAD, runs `git reset <commit>`. Returns 1 if the reset fails.

**Example:**

```bash
gwip; gwip; gwip
gunwipall   # walks all three WIP commits back into the working tree
```

### `work_in_progress`

Echoes `WIP!!` if the latest commit message contains `--wip--`.

**Behavior:**

Runs `git -c log.showSignature=false log -n 1` and greps for the WIP sentinel. Used in prompts.

### `git_remote_status`

Renders a prompt fragment describing the upstream relationship.

**Behavior:**

Reads `${hook_com[branch]}` (set by vcs_info) and resolves its `@{upstream}`. Calls `git rev-list` twice to compute `ahead`/`behind` counts and selects one of `$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE`, `_AHEAD_REMOTE`, `_BEHIND_REMOTE`, or `_DIVERGED_REMOTE`. If `$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED` is non-empty, wraps the status in `_REMOTE_STATUS_PREFIX`/`_SUFFIX` and includes the remote name plus numeric counts in the configured colors.

### `git_previous_branch`

Echoes the previously checked-out branch (`@{-1}`).

**Behavior:**

Calls `git rev-parse --quiet --symbolic-full-name @{-1}`; on success strips the `refs/heads/` prefix and echoes the branch name. Silent if no prior branch is recorded.

### `git_commits_ahead`

Echoes the number of local commits ahead of upstream, wrapped in `$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX`/`_SUFFIX`. Silent when at or behind upstream.

### `git_commits_behind`

Echoes the number of commits behind upstream, wrapped in `$ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX`/`_SUFFIX`. Silent when at or ahead of upstream.

### `git_prompt_ahead`

Echoes `$ZSH_THEME_GIT_PROMPT_AHEAD` if `origin/<current>..HEAD` is non-empty.

### `git_prompt_behind`

Echoes `$ZSH_THEME_GIT_PROMPT_BEHIND` if `HEAD..origin/<current>` is non-empty.

### `git_prompt_remote`

Echoes `$ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS` or `_REMOTE_MISSING` based on whether `origin/<current>` has a ref.

### `git_prompt_short_sha`

Echoes the abbreviated HEAD SHA wrapped in `$ZSH_THEME_GIT_PROMPT_SHA_BEFORE`/`_AFTER`.

### `git_prompt_long_sha`

Same as `git_prompt_short_sha` but emits the full 40-char hash via `git rev-parse HEAD`.

### `git_current_user_name`

Echoes `git config user.name` (empty when unset).

### `git_current_user_email`

Echoes `git config user.email` (empty when unset).

### `git_repo_name`

Echoes the basename of the repository root (`git rev-parse --show-toplevel | basename`). Silent outside a git repo.

### `__git_prompt_git [args...]`

Internal wrapper. Runs `command git` with `GIT_OPTIONAL_LOCKS=0` so prompt queries do not interfere with concurrent git operations.

### `__git_log_tree [extra git log args...]`

Pretty `git log --all --graph` with width-aware column truncation.

**Behavior:**

Reads `$(tput cols)`, computes hash/date/name/message/refs column widths (12/24/40/total-50/total) and feeds them into `--pretty=tformat:` with `%>|`/`%<|` truncation directives. Extra arguments are forwarded to `git log`.

**Example:**

```bash
__git_log_tree
__git_log_tree --since=1.week
```

## VARIABLES

`git_version` is set at module load using `autoload -Uz is-at-least` and `unset` again at the bottom of the file, so it is not visible after sourcing.

## REQUIREMENTS

- `git`. The module returns immediately if `git` is missing.
- A terminal that exposes column width via `tput cols` for `__git_log_tree`.
- Prompt themes that read `$ZSH_THEME_GIT_PROMPT_*` and `hook_com[branch]` (vcs_info) for full prompt integration.

## EXAMPLES

```bash
# Rebase the current branch onto whichever branch is "main" here
git rebase "$(git_main_branch)"

# Show a width-aware log for the last fortnight
__git_log_tree --since=2.weeks
```

## SEE ALSO

- [.docs/aliases/git](../aliases/git.md)
- [.docs/plugins/zsh/git](../plugins/zsh/git.md)
- [.docs/README.md](../README.md)
