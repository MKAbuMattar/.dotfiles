#!/usr/bin/env zsh

# Do nothing if dotnet is not installed
(( ! $+commands[dotnet] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# This script is copied from (MIT License):
# https://raw.githubusercontent.com/dotnet/sdk/main/scripts/register-completions.zsh

#compdef dotnet
_dotnet_completion() {
  local -a completions=("${(@f)$(dotnet complete "${words}")}")
  compadd -a completions
  _files
}

compdef _dotnet_completion dotnet
