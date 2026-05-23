#!/usr/bin/env zsh

# Do nothing if hcloud is not installed
(( ! $+commands[hcloud] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Generate hcloud completion if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_hcloud" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_hcloud" -mtime +7 2>/dev/null)" ]]; then
  hcloud completion zsh >| "$ZSH_CACHE_DIR/completions/_hcloud" 2>/dev/null
fi
