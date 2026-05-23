#!/usr/bin/env zsh

# Do nothing if npm is not installed
(( ! $+commands[npm] )) && return

# Remove old completion cache
command rm -f "${ZSH_CACHE_DIR:-$HOME/.cache/zsh}/npm_completion"

_npm_completion() {
  local si=$IFS
  compadd -- $(COMP_CWORD=$((CURRENT-1)) \
               COMP_LINE=$BUFFER \
               COMP_POINT=0 \
               npm completion -- "${words[@]}" \
               2>/dev/null)
  IFS=$si
}

compdef _npm_completion npm
