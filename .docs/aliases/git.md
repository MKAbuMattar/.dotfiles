# git-aliases

## NAME

**git-aliases** — large, opinionated alias and helper set for `git` (Oh-My-Zsh-compatible).

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "git" ...)
```

## DESCRIPTION

The module exits early via `(( ! $+commands[git] )) && return` when `git`
is missing. Otherwise it autoloads `is-at-least`, probes the installed
git version (stored in `$git_version`), and conditionally chooses
between modern and legacy expansions for `gfa`, `gpf`, `gpsupf`, and
`gsta`. A pile of helper **functions** (`gccd`, `ggu`, `ggl`, `ggp`,
`ggf`, `ggfl`, `gbda`, `gbds`, `gdv`, `gdnolock`, `ggpnp`,
`_git_log_prettily`) are bound with `compdef _git` so they tab-complete
like real `git` subcommands. The module assumes two functions exist in
the surrounding plugin environment: `git_main_branch` and
`git_develop_branch` (provided by the git plugin under `.plugins/.zsh/git/`).

The two-letter naming scheme follows Oh-My-Zsh's well-known `g…` map:
`g`, `ga`, `gc`, `gd`, `gp`, `gl`, `gst`, etc. Aliases for **destructive**
operations end in `!` (e.g. `gc!`, `gpf!`, `gca!`); these clobber history.

## ALIASES

### Top-level

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `g` | `git` | Bare git. |
| `grt` | `cd "$(git rev-parse --show-toplevel \|\| echo .)"` | Jump to the repo root. |
| `gcf` | `git config --list` | List config. |

### Add

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `ga` | `git add` | Add path(s). |
| `gaa` | `git add --all` | Stage everything. |
| `gapa` | `git add --patch` | Interactive hunks. |
| `gau` | `git add --update` | Only tracked files. |
| `gav` | `git add --verbose` | Verbose add. |
| `gwip` | `git add -A; git rm $(git ls-files --deleted) 2>/dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"` | Throwaway WIP commit. |

### Apply / am

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gam` | `git am` | Apply mailbox. |
| `gama` | `git am --abort` | Abort am. |
| `gamc` | `git am --continue` | Continue am. |
| `gamscp` | `git am --show-current-patch` | Inspect current patch. |
| `gams` | `git am --skip` | Skip patch. |
| `gap` | `git apply` | Apply patch. |
| `gapt` | `git apply --3way` | 3-way apply. |

### Bisect

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gbs` | `git bisect` | |
| `gbsb` | `git bisect bad` | |
| `gbsg` | `git bisect good` | |
| `gbsn` | `git bisect new` | |
| `gbso` | `git bisect old` | |
| `gbsr` | `git bisect reset` | |
| `gbss` | `git bisect start` | |

### Blame / branch

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gbl` | `git blame -w` | Ignore whitespace. |
| `gb` | `git branch` | |
| `gba` | `git branch --all` | |
| `gbd` | `git branch --delete` | |
| `gbD` | `git branch --delete --force` | |
| `gbm` | `git branch --move` | Rename branch. |
| `gbnm` | `git branch --no-merged` | |
| `gbr` | `git branch --remote` | |
| `gbg` | `LANG=C git branch -vv \| grep ": gone\]"` | List branches whose upstream is gone. |
| `gbgd` | `LANG=C git branch --no-color -vv \| grep ": gone\]" \| cut -c 3- \| awk '{print $1}' \| xargs git branch -d` | Delete gone branches (safe). |
| `gbgD` | `LANG=C git branch --no-color -vv \| grep ": gone\]" \| cut -c 3- \| awk '{print $1}' \| xargs git branch -D` | Force-delete gone branches. |
| `ggsup` | `git branch --set-upstream-to=origin/$(git_current_branch)` | Track origin/cur. |

### Checkout / switch

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gco` | `git checkout` | |
| `gcor` | `git checkout --recurse-submodules` | |
| `gcb` | `git checkout -b` | Create + check out. |
| `gcB` | `git checkout -B` | Force create + check out. |
| `gcd` | `git checkout $(git_develop_branch)` | Go to develop branch. |
| `gcm` | `git checkout $(git_main_branch)` | Go to main branch. |
| `gsw` | `git switch` | |
| `gswc` | `git switch --create` | |
| `gswd` | `git switch $(git_develop_branch)` | |
| `gswm` | `git switch $(git_main_branch)` | |

### Cherry-pick / clean / clone

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gcp` | `git cherry-pick` | |
| `gcpa` | `git cherry-pick --abort` | |
| `gcpc` | `git cherry-pick --continue` | |
| `gclean` | `git clean --interactive -d` | Interactive clean. |
| `gcl` | `git clone --recurse-submodules` | |
| `gclf` | `git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules` | Partial clone. |

### Commit

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gc` | `git commit --verbose` | |
| `gca` | `git commit --verbose --all` | |
| `gc!` | `git commit --verbose --amend` | |
| `gca!` | `git commit --verbose --all --amend` | |
| `gcn!` | `git commit --verbose --no-edit --amend` | |
| `gcan!` | `git commit --verbose --all --no-edit --amend` | |
| `gcans!` | `git commit --verbose --all --signoff --no-edit --amend` | |
| `gcann!` | `git commit --verbose --all --date=now --no-edit --amend` | |
| `gcn` | `git commit --verbose --no-edit` | |
| `gcam` | `git commit --all --message` | |
| `gcas` | `git commit --all --signoff` | |
| `gcasm` | `git commit --all --signoff --message` | |
| `gcs` | `git commit --gpg-sign` | |
| `gcss` | `git commit --gpg-sign --signoff` | |
| `gcssm` | `git commit --gpg-sign --signoff --message` | |
| `gcmsg` | `git commit --message` | |
| `gcsm` | `git commit --signoff --message` | |
| `gcfu` | `git commit --fixup` | |

### Describe / diff

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gdct` | `git describe --tags $(git rev-list --tags --max-count=1)` | Latest tag name. |
| `gd` | `git diff` | |
| `gdca` | `git diff --cached` | |
| `gdcw` | `git diff --cached --word-diff` | |
| `gds` | `git diff --staged` | |
| `gdw` | `git diff --word-diff` | |
| `gdup` | `git diff @{upstream}` | |
| `gdt` | `git diff-tree --no-commit-id --name-only -r` | |

### Fetch / GUI / help

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gf` | `git fetch` | |
| `gfa` | `git fetch --all --tags --prune --jobs=10` (legacy: no `--jobs`) | Version-gated on git ≥ 2.8. |
| `gfo` | `git fetch origin` | |
| `gg` | `git gui citool` | |
| `gga` | `git gui citool --amend` | |
| `ghh` | `git help` | |
| `gk` | `\gitk --all --branches &!` | Detached gitk. |
| `gke` | `\gitk --all $(git log --walk-reflogs --pretty=%h) &!` | gitk over reflogs. |

### Log

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `glo` | `git log --oneline --decorate` | |
| `glog` | `git log --oneline --decorate --graph` | |
| `gloga` | `git log --oneline --decorate --graph --all` | |
| `glgg` | `git log --graph` | |
| `glgga` | `git log --graph --decorate --all` | |
| `glgm` | `git log --graph --max-count=10` | |
| `glg` | `git log --stat` | |
| `glgp` | `git log --stat --patch` | |
| `glol` | `git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"` | Pretty graph (relative dates). |
| `glols` | `… --stat` | Same with `--stat`. |
| `glola` | `… --all` | Same with `--all`. |
| `glod` | `… %Cgreen(%ad) …` | Absolute dates. |
| `glods` | `glod` + `--date=short` | Short dates. |
| `glp` | `_git_log_prettily` | Pass a `--pretty` format via function. |
| `gwch` | `git log --patch --abbrev-commit --pretty=medium --raw` | Detailed log. |
| `gt` | `__git_log_tree` | Custom tree-log helper from the git plugin. |

### ls-files

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gignored` | `git ls-files -v \| grep "^[[:lower:]]"` | List skip-worktree / assume-unchanged. |
| `gfg` | `git ls-files \| grep` | Search tracked filenames. |
| `gignore` | `git update-index --assume-unchanged` | |
| `gunignore` | `git update-index --no-assume-unchanged` | |

### Merge / mergetool

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gm` | `git merge` | |
| `gma` | `git merge --abort` | |
| `gmc` | `git merge --continue` | |
| `gms` | `git merge --squash` | |
| `gmff` | `git merge --ff-only` | |
| `gmom` | `git merge origin/$(git_main_branch)` | |
| `gmum` | `git merge upstream/$(git_main_branch)` | |
| `gmtl` | `git mergetool --no-prompt` | |
| `gmtlvim` | `git mergetool --no-prompt --tool=vimdiff` | |

### Pull

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gl` | `git pull` | |
| `gpr` | `git pull --rebase` | |
| `gprv` | `git pull --rebase -v` | |
| `gpra` | `git pull --rebase --autostash` | |
| `gprav` | `git pull --rebase --autostash -v` | |
| `gprom` | `git pull --rebase origin $(git_main_branch)` | |
| `gpromi` | `git pull --rebase=interactive origin $(git_main_branch)` | |
| `gprum` | `git pull --rebase upstream $(git_main_branch)` | |
| `gprumi` | `git pull --rebase=interactive upstream $(git_main_branch)` | |
| `ggpull` | `git pull origin "$(git_current_branch)"` | |
| `gluc` | `git pull upstream $(git_current_branch)` | |
| `glum` | `git pull upstream $(git_main_branch)` | |
| `ggpur` | `ggu` | Alias to the `ggu` function. |

### Push

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gp` | `git push` | |
| `gpd` | `git push --dry-run` | |
| `gpf!` | `git push --force` | Hard force-push. |
| `gpf` | `git push --force-with-lease --force-if-includes` (legacy: no `--force-if-includes`) | Version-gated on git ≥ 2.30. |
| `gpsup` | `git push --set-upstream origin $(git_current_branch)` | |
| `gpsupf` | `git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes` (legacy without `--force-if-includes`) | Version-gated on git ≥ 2.30. |
| `gpv` | `git push --verbose` | |
| `gpoat` | `git push origin --all && git push origin --tags` | |
| `gpod` | `git push origin --delete` | |
| `ggpush` | `git push origin "$(git_current_branch)"` | |
| `gpu` | `git push upstream` | |

### Rebase

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `grb` | `git rebase` | |
| `grba` | `git rebase --abort` | |
| `grbc` | `git rebase --continue` | |
| `grbi` | `git rebase --interactive` | |
| `grbo` | `git rebase --onto` | |
| `grbs` | `git rebase --skip` | |
| `grbd` | `git rebase $(git_develop_branch)` | |
| `grbm` | `git rebase $(git_main_branch)` | |
| `grbom` | `git rebase origin/$(git_main_branch)` | |
| `grbum` | `git rebase upstream/$(git_main_branch)` | |

### Remote / reflog / reset / restore

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gr` | `git remote` | |
| `grv` | `git remote --verbose` | |
| `gra` | `git remote add` | |
| `grrm` | `git remote remove` | |
| `grmv` | `git remote rename` | |
| `grset` | `git remote set-url` | |
| `grup` | `git remote update` | |
| `grf` | `git reflog` | |
| `grh` | `git reset` | |
| `gru` | `git reset --` | |
| `grhh` | `git reset --hard` | |
| `grhk` | `git reset --keep` | |
| `grhs` | `git reset --soft` | |
| `groh` | `git reset origin/$(git_current_branch) --hard` | |
| `gpristine` | `git reset --hard && git clean --force -dfx` | Hard wipe (untracked + ignored). |
| `gwipe` | `git reset --hard && git clean --force -df` | Hard wipe (untracked, keep ignored). |
| `grs` | `git restore` | |
| `grss` | `git restore --source` | |
| `grst` | `git restore --staged` | |

### Revert / rm / shortlog / show

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `grev` | `git revert` | |
| `greva` | `git revert --abort` | |
| `grevc` | `git revert --continue` | |
| `grm` | `git rm` | |
| `grmc` | `git rm --cached` | |
| `gcount` | `git shortlog --summary --numbered` | |
| `gsh` | `git show` | |
| `gsps` | `git show --pretty=short --show-signature` | |
| `gunwip` | `git rev-list --max-count=1 --format="%s" HEAD \| grep -q "\--wip--" && git reset HEAD~1` | Undo a `gwip` commit. |

### Stash

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gsta` | `git stash push` (legacy: `git stash save`) | Version-gated on git ≥ 2.13. |
| `gstall` | `git stash --all` | Include ignored. |
| `gstaa` | `git stash apply` | |
| `gstc` | `git stash clear` | |
| `gstd` | `git stash drop` | |
| `gstl` | `git stash list` | |
| `gstp` | `git stash pop` | |
| `gsts` | `git stash show --patch` | |
| `gstu` | `gsta --include-untracked` | |

### Status / submodule

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gst` | `git status` | |
| `gss` | `git status --short` | |
| `gsb` | `git status --short --branch` | |
| `gsi` | `git submodule init` | |
| `gsu` | `git submodule update` | |

### SVN

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gsd` | `git svn dcommit` | |
| `gsr` | `git svn rebase` | |
| `git-svn-dcommit-push` | `git svn dcommit && git push github $(git_main_branch):svntrunk` | |

### Tag / worktree

| Alias | Expansion | Description |
| ----- | --------- | ----------- |
| `gta` | `git tag --annotate` | |
| `gts` | `git tag --sign` | |
| `gtv` | `git tag \| sort -V` | Version-sorted tag list. |
| `gtl` | `gtl(){ git tag --sort=-v:refname -n --list "${1}*" }; noglob gtl` | List tags matching a prefix. |
| `gwt` | `git worktree` | |
| `gwta` | `git worktree add` | |
| `gwtls` | `git worktree list` | |
| `gwtmv` | `git worktree move` | |
| `gwtrm` | `git worktree remove` | |

## FUNCTIONS

All of the helper functions are wired to git's own completion via
`compdef _git <fn>=git-<subcommand>` so they tab-complete naturally.

### `gccd <clone-args…>`

Run `git clone --recurse-submodules <args>`. On success, `cd` into the
newly created directory. Detects the repo name from the URL with a zsh
extended-glob and falls back to `cd "$_"`.

### `ggu [branch]`

Rebase-pull the current (or named) branch from `origin`. Equivalent to
`git pull --rebase origin "${b:-$1}"`.

### `ggl [refspec…]`

Pull from `origin`. With 0 or 1 args, pulls `origin <current-branch>`; with
more, forwards all args.

### `ggp [refspec…]`

Push to `origin`. Same arg semantics as `ggl`.

### `ggf [branch]`

`git push --force origin <branch-or-current>`. Hard force-push.

### `ggfl [branch]`

`git push --force-with-lease origin <branch-or-current>`. Safer force-push.

### `ggpnp [refspec…]`

"Pull-and-push": run `ggl` then `ggp` with the same args. Handy after an
interactive rebase.

### `gbda`

Delete every local branch that is fully merged into either the main or the
develop branch. Skips the current branch and protects main/develop with a
grep filter.

### `gbds`

"Delete-squashed". For every local branch, compute the merge-base against
the default branch, build a synthetic commit-tree, and check
`git cherry`. If the diff has already landed (as a squash), the branch is
deleted with `git branch -D`.

### `gdv [path…]`

`git diff -w "$@" | view -` — open the diff in `view` (read-only Vim).

### `gdnolock [path…]`

Run `git diff` but exclude lockfiles (`package-lock.json`, `*.lock`).

### `_git_log_prettily <format>`

Internal helper bound to `glp`: forwards `$1` as `--pretty=…` to `git log`.

## REQUIREMENTS

- `git` on `$PATH` at shell-startup (probed with
  `(( ! $+commands[git] )) && return`).
- The companion git plugin under `.plugins/.zsh/git/` (provides
  `git_main_branch`, `git_develop_branch`, `__git_log_tree`, and
  `git_current_branch`).
- Some aliases require modern git: `gfa` benefits from ≥ 2.8, `gsta` from
  ≥ 2.13, `gpf`/`gpsupf` from ≥ 2.30. The module probes the version with
  `is-at-least` and silently falls back where needed.
- `view` (Vim) for `gdv`. `gitk` for `gk`/`gke`.

## EXAMPLES

```bash
gst                            # quick status
gaa && gcmsg "wip"             # stage all + commit with message
gpsup                          # set upstream to origin/<cur>
gpf                            # safe force-push
ggfl feature/x                 # safe force-push to origin/feature/x
gbda                           # tidy up merged branches
glola                          # pretty graph of all branches
gdnolock -- src/               # diff without lockfile noise
gccd git@github.com:foo/bar.git
gwip                           # checkpoint
# … later
gunwip                         # undo it
```

## SEE ALSO

- [.docs/plugins/zsh/git.md](../plugins/zsh/git.md)
- [.docs/README.md](../README.md)
