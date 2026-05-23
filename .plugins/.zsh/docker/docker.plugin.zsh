#!/usr/bin/env zsh

# Do nothing if docker is not installed
(( ! $+commands[docker] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Standardized $0 handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Generate completion file if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_docker" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_docker" -mtime +7 2>/dev/null)" ]]; then
  # Check if we have a local completion file first
  if [[ -f "${0:h}/completions/_docker" ]]; then
    command cp "${0:h}/completions/_docker" "$ZSH_CACHE_DIR/completions/_docker"
  else
    # `docker completion` is only available from 23.0.0 on
    autoload -Uz is-at-least

    if is-at-least 23.0.0 ${${(s:,:z)"$(command docker --version 2>/dev/null)"}[3]:-0.0.0}; then
      # Use docker's built-in completion for version 23.0.0+
      command docker completion zsh >| "$ZSH_CACHE_DIR/completions/_docker" 2>/dev/null
    fi
  fi
fi
