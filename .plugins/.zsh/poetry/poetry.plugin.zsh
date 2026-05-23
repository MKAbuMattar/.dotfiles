#!/usr/bin/env zsh

# Return immediately if poetry is not found
(( ! $+commands[poetry] )) && return

# Set up completion cache
ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-${HOME}/.cache/zsh}"
[[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `poetry`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_poetry" ]]; then
  typeset -g -A _comps
  autoload -Uz _poetry
  _comps[poetry]=_poetry
fi

# Only regenerate completion if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_poetry" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_poetry" -mtime +7 2>/dev/null)" ]]; then
  poetry completions zsh >| "$ZSH_CACHE_DIR/completions/_poetry" &|
fi
