#!/usr/bin/env zsh

# Do nothing if rustup and cargo are not installed
if ! (( $+commands[rustup] && $+commands[cargo] )); then
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

# Add local rust completions directory to fpath
local rust_completion_dir="${0:A:h}/completions"
if [[ -d "$rust_completion_dir" ]]; then
  fpath=("$rust_completion_dir" $fpath)
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `cargo`. Otherwise, compinit will have already done that
if [[ ! -f "$ZSH_CACHE_DIR/completions/_cargo" ]]; then
  autoload -Uz _cargo
  typeset -g -A _comps
  _comps[cargo]=_cargo
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rustup`. Otherwise, compinit will have already done that
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rustup" ]]; then
  autoload -Uz _rustup
  typeset -g -A _comps
  _comps[rustup]=_rustup
fi

# Only regenerate completions if they don't exist or are older than 7 days
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rustup" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_rustup" -mtime +7 2>/dev/null)" ]]; then
  rustup completions zsh >| "$ZSH_CACHE_DIR/completions/_rustup" &|
fi

if [[ ! -f "$ZSH_CACHE_DIR/completions/_cargo" ]] || \
   [[ -n "$(find "$ZSH_CACHE_DIR/completions/_cargo" -mtime +7 2>/dev/null)" ]]; then
  cat >| "$ZSH_CACHE_DIR/completions/_cargo" <<'EOF' &
#compdef cargo
source "$(rustup run ${${(z)$(rustup default)}[1]} rustc --print sysroot)"/share/zsh/site-functions/_cargo
EOF
fi
EOF
