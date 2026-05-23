#!/usr/bin/env zsh

# Do nothing if uv is not installed
if (( ! $+commands[uv] )); then
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
# bind it. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_uv" ]]; then
  typeset -g -A _comps
  autoload -Uz _uv
  _comps[uv]=_uv
fi

if [[ ! -f "$ZSH_CACHE_DIR/completions/_uvx" ]]; then
  typeset -g -A _comps
  autoload -Uz _uvx
  _comps[uvx]=_uvx
fi

# Only regenerate completions if they don't exist or are older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_uv" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_uv" -mtime +7 2>/dev/null)" ]]; then
  uv generate-shell-completion zsh >| "$ZSH_CACHE_DIR/completions/_uv" &|
fi

if [[ ! -f "$ZSH_CACHE_DIR/completions/_uvx" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_uvx" -mtime +7 2>/dev/null)" ]]; then
  uvx --generate-shell-completion zsh >| "$ZSH_CACHE_DIR/completions/_uvx" &|
fi
