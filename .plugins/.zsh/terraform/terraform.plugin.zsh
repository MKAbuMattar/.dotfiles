#!/usr/bin/env zsh

# Do nothing if terraform is not installed
(( ! $+commands[terraform] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Add local terraform completions directory to fpath
local terraform_completion_dir="${0:A:h}/completions"
if [[ -d "$terraform_completion_dir" ]]; then
  fpath=("$terraform_completion_dir" $fpath)
fi

# Generate terraform completion if it doesn't exist in cache or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_terraform" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_terraform" -mtime +7 2>/dev/null)" ]]; then
  terraform -install-autocomplete 2>/dev/null || true
fi
