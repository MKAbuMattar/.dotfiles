#!/usr/bin/env zsh

# Do nothing if helm is not installed
(( ! $+commands[helm] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Generate helm completion if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_helm" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_helm" -mtime +7 2>/dev/null)" ]]; then
  helm completion zsh >| "$ZSH_CACHE_DIR/completions/_helm" 2>/dev/null
fi
