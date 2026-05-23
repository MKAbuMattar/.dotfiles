#!/usr/bin/env zsh

# Autocompletion for doctl, the command line tool for DigitalOcean service
#
# doctl project: https://github.com/digitalocean/doctl
#
# Author: https://github.com/HalisCz

# Do nothing if doctl is not installed
(( ${+commands[doctl]} )) || return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Generate completion file if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_doctl" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_doctl" -mtime +7 2>/dev/null)" ]]; then
  doctl completion zsh >| "$ZSH_CACHE_DIR/completions/_doctl" 2>/dev/null
fi
