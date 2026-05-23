#!/usr/bin/env zsh

# Do nothing if git is not installed
(( ! $+commands[git] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Git version checking
autoload -Uz is-at-least
git_version="${${(As: :)$(git version 2>/dev/null)}[3]}"

# The git prompt's git commands are read-only and should not interfere with
# other processes. This environment variable is equivalent to running with `git
# --no-optional-locks`, but falls back gracefully for older versions of git.
function __git_prompt_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

function _omz_git_prompt_info() {
  # If we are on a folder not tracked by git, get out.
  if ! __git_prompt_git rev-parse --git-dir &> /dev/null \
    || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]; then
    return 0
  fi

  local ref
  ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
  || return 0

  local upstream
  if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
    upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
    && upstream=" -> ${upstream}"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${upstream:gs/%/%%}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

function _omz_git_prompt_status() {
  [[ "$(__git_prompt_git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]] && return

  local -A prefix_constant_map
  prefix_constant_map=(
    '\?\? '     'UNTRACKED'
    'A  '       'ADDED'
    'M  '       'MODIFIED'
    'MM '       'MODIFIED'
    ' M '       'MODIFIED'
    'AM '       'MODIFIED'
    ' T '       'MODIFIED'
    'R  '       'RENAMED'
    ' D '       'DELETED'
    'D  '       'DELETED'
    'UU '       'UNMERGED'
    'ahead'     'AHEAD'
    'behind'    'BEHIND'
    'diverged'  'DIVERGED'
    'stashed'   'STASHED'
  )

  local -A constant_prompt_map
  constant_prompt_map=(
    'UNTRACKED' "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    'ADDED'     "$ZSH_THEME_GIT_PROMPT_ADDED"
    'MODIFIED'  "$ZSH_THEME_GIT_PROMPT_MODIFIED"
    'RENAMED'   "$ZSH_THEME_GIT_PROMPT_RENAMED"
    'DELETED'   "$ZSH_THEME_GIT_PROMPT_DELETED"
    'UNMERGED'  "$ZSH_THEME_GIT_PROMPT_UNMERGED"
    'AHEAD'     "$ZSH_THEME_GIT_PROMPT_AHEAD"
    'BEHIND'    "$ZSH_THEME_GIT_PROMPT_BEHIND"
    'DIVERGED'  "$ZSH_THEME_GIT_PROMPT_DIVERGED"
    'STASHED'   "$ZSH_THEME_GIT_PROMPT_STASHED"
  )

  local status_constants
  status_constants=(
    UNTRACKED ADDED MODIFIED RENAMED DELETED
    STASHED UNMERGED AHEAD BEHIND DIVERGED
  )

  local status_text
  status_text="$(__git_prompt_git status --porcelain -b 2> /dev/null)"

  [[ $? -eq 128 ]] && return 1

  local -A statuses_seen

  if __git_prompt_git rev-parse --verify refs/stash &>/dev/null; then
    statuses_seen[STASHED]=1
  fi

  local status_lines
  status_lines=("${(@f)${status_text}}")

  if [[ "$status_lines[1]" =~ "^## [^ ]+ \[(.*)\]" ]]; then
    local branch_statuses
    branch_statuses=("${(@s/,/)match}")
    for branch_status in $branch_statuses; do
      if [[ ! $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]]; then
        continue
      fi
      local last_parsed_status=$prefix_constant_map[$match[1]]
      statuses_seen[$last_parsed_status]=$match[2]
    done
  fi

  for status_prefix in "${(@k)prefix_constant_map}"; do
    local status_constant="${prefix_constant_map[$status_prefix]}"
    local status_regex=$'(^|\n)'"$status_prefix"

    if [[ "$status_text" =~ $status_regex ]]; then
      statuses_seen[$status_constant]=1
    fi
  done

  local status_prompt
  for status_constant in $status_constants; do
    if (( ${+statuses_seen[$status_constant]} )); then
      local next_display=$constant_prompt_map[$status_constant]
      status_prompt="$next_display$status_prompt"
    fi
  done

  echo $status_prompt
}

function git_prompt_info() {
  _omz_git_prompt_info
}

function git_prompt_status() {
  _omz_git_prompt_status
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(__git_prompt_git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    case "${GIT_STATUS_IGNORE_SUBMODULES:-}" in
      git) ;;
      *)
        FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
        ;;
    esac
    STATUS=$(__git_prompt_git status ${FLAGS} 2> /dev/null | tail -n 1)
  fi
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Outputs the name of the current branch
function git_current_branch() {
  local ref
  ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return
    ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

unset git_version
