#!/usr/bin/env zsh

DISABLE_AUTO_TITLE="true"

# Feature flags
: ${TITLE_SHOW_METRICS:=1}
: ${TITLE_SHOW_STASH:=1}

# Global Cache Variables
typeset -g __TITLE_CACHE=""
typeset -g __TITLE_CACHE_KEY=""

# Icons
ICON_GIT=""
ICON_REPO=""
ICON_FOLDER=""
ICON_STAGED="󰄬"
ICON_UNTRACKED="󰝒"

_set_term_title() {
  printf "\033]0;%s\007" "$1"
}

set_name() {
  local git_dir
  # Use Zsh built-in check for git dir if possible, otherwise subshell
  git_dir=$(git rev-parse --git-dir 2>/dev/null)

  if [[ -z "$git_dir" ]]; then
    _set_term_title "${ICON_FOLDER} ${PWD:t}"
    return
  fi

  # --- DYNAMIC CACHE KEY ---
  # 1. PWD (if we change directories)
  # 2. HEAD (if we change branches)
  # 3. Index mtime (if we git add/commit)
  # 4. A 'dirty' check using a lightweight ls-files (to catch file saves)

  local head_val=""
  [[ -f "$git_dir/HEAD" ]] && head_val=$(<"$git_dir/HEAD")

  local index_mtime=""
  [[ -f "$git_dir/index" ]] && index_mtime=$(zstat +mtime "$git_dir/index")

  # This small command catches unsaved/new changes without the overhead of 'status'
  local dirty_check=$(git ls-files -m --others --exclude-standard | head -n 1)

  local current_key="${PWD}${head_val}${index_mtime}${dirty_check}"

  # If nothing changed, exit early with cache
  if [[ "$current_key" == "$__TITLE_CACHE_KEY" ]]; then
    _set_term_title "$__TITLE_CACHE"
    return
  fi
  # -------------------------

  # COLLECTION (Porcelain V2)
  local stats
  stats=$(git status --porcelain=v2 --branch 2>/dev/null)
  local top=$(git rev-parse --show-toplevel 2>/dev/null)

  local branch="" ahead=0 behind=0 staged=0 changed=0 untracked=0

  while IFS= read -r line; do
    case "$line" in
      "# branch.head "*) branch="${line#*head }" ;;
      "# branch.ab "*)
        local ab=(${(z)line})
        ahead=${ab[3]#+}
        behind=${ab[4]#-}
        ;;
      "1 "*|"2 "*)
        [[ "${line:2:1}" != "." ]] && ((staged++))
        [[ "${line:3:1}" != "." ]] && ((changed++))
        ;;
      "? "*) ((untracked++)) ;;
    esac
  done <<< "$stats"

  # BUILD TITLE
  local res="${ICON_REPO} ${top:t} (${ICON_GIT} ${branch})"

  if (( TITLE_SHOW_METRICS && changed )); then
    local ins=0 del=0
    while read i d f; do
      [[ "$i" != "-" ]] && ((ins += i))
      [[ "$d" != "-" ]] && ((del += d))
    done <<< "$(git diff --numstat 2>/dev/null)"
    res+=" [+${ins} -${del}]"
  fi

  (( staged )) && res+=" ${ICON_STAGED}"
  (( untracked )) && res+=" ${ICON_UNTRACKED}"
  (( ahead > 0 )) && res+=" ⇡${ahead}"
  (( behind > 0 )) && res+=" ⇣${behind}"

  if (( TITLE_SHOW_STASH )) && [[ -f "$git_dir/logs/refs/stash" ]]; then
    local scount=$(grep -c '^' "$git_dir/logs/refs/stash")
    (( scount > 0 )) && res+=" ≡${scount}"
  fi

  # UPDATE CACHE
  __TITLE_CACHE="$res"
  __TITLE_CACHE_KEY="$current_key"
  _set_term_title "$res"
}

# Hook into precmd to update title before each prompt
zmodload zsh/stat 2>/dev/null
autoload -Uz add-zsh-hook
add-zsh-hook precmd set_name
