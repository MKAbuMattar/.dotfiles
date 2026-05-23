#!/usr/bin/env zsh

# Do nothing if pip is not installed
if ! (( $+commands[pip3] || $+commands[pip] )); then
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

# Add local pip completions directory to fpath
local pip_completion_dir="${0:A:h}/completions"
if [[ -d "$pip_completion_dir" ]]; then
  fpath=("$pip_completion_dir" $fpath)
fi

# Generate pip completion if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_pip" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_pip" -mtime +7 2>/dev/null)" ]]; then
  if (( $+commands[pip] )); then
    pip completion --zsh >| "$ZSH_CACHE_DIR/completions/_pip" 2>/dev/null
  elif (( $+commands[pip3] )); then
    pip3 completion --zsh >| "$ZSH_CACHE_DIR/completions/_pip" 2>/dev/null
  fi
fi

# Set up pip package cache
if [[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/pip" ]]; then
  ZSH_PIP_CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/pip/zsh-cache"
else
  ZSH_PIP_CACHE_FILE=~/.pip/zsh-cache
fi
ZSH_PIP_INDEXES=(https://pypi.org/simple/)
