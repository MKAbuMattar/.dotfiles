#!/usr/bin/env zsh

# Do nothing if op is not installed
(( ${+commands[op]} )) || return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Generate completion file if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_op" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_op" -mtime +7 2>/dev/null)" ]]; then
  op completion zsh >| "$ZSH_CACHE_DIR/completions/_op" 2>/dev/null
fi

# Load opswd function if it exists
[[ -f "${0:A:h}/opswd" ]] && autoload -Uz opswd
