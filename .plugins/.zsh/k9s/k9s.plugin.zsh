#!/usr/bin/env zsh

# Do nothing if k9s is not installed
if (( ! $+commands[k9s] )); then
  return
fi

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# If the completion file does not exist, fake it and load it
if [[ ! -f "$ZSH_CACHE_DIR/completions/_k9s" ]]; then
  typeset -g -A _comps
  autoload -Uz _k9s
  _comps[k9s]=_k9s
fi

# Only regenerate completion if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_k9s" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_k9s" -mtime +7 2>/dev/null)" ]]; then
  k9s completion zsh >| "$ZSH_CACHE_DIR/completions/_k9s" &|
fi
