#!/usr/bin/env zsh

# Do nothing if redis-cli is not installed
(( ! $+commands[redis-cli] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Add local redis completions directory to fpath
local redis_completion_dir="${0:A:h}/completions"
if [[ -d "$redis_completion_dir" ]]; then
  fpath=("$redis_completion_dir" $fpath)
fi
