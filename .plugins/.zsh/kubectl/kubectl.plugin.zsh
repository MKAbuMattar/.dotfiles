#!/usr/bin/env zsh

# Do nothing if kubectl is not installed
if (( ! $+commands[kubectl] )); then
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

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `kubectl`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kubectl" ]]; then
  typeset -g -A _comps
  autoload -Uz _kubectl
  _comps[kubectl]=_kubectl
fi

# Only regenerate completion if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kubectl" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_kubectl" -mtime +7 2>/dev/null)" ]]; then
  kubectl completion zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_kubectl" &|
fi
