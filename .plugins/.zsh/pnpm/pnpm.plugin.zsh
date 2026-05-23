#!/usr/bin/env zsh

# Return immediately if pnpm is not found
(( ! $+commands[pnpm] )) && return

# Set up completion cache
ZSH_CACHE_DIR="${ZSH_CACHE_DIR:-${HOME}/.cache/zsh}"
[[ -d "$ZSH_CACHE_DIR/completions" ]] || mkdir -p "$ZSH_CACHE_DIR/completions"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `pnpm`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_pnpm" ]]; then
  typeset -g -A _comps
  autoload -Uz _pnpm
  _comps[pnpm]=_pnpm
fi

# Only regenerate completion if it doesn't exist or is older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_pnpm" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_pnpm" -mtime +7 2>/dev/null)" ]]; then
  pnpm completion zsh >| "$ZSH_CACHE_DIR/completions/_pnpm" &|
fi
