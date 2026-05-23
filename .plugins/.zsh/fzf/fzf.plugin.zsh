#!/usr/bin/env zsh

# ==========================
# FZF Plugin Integration
# ==========================

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
  return
fi

# Common fzf integration file locations
FZF_LOCATIONS=(
  "/usr/share/doc/fzf/examples/key-bindings.zsh"
  "/usr/share/fzf/key-bindings.zsh"
  "/usr/share/doc/fzf/examples/completion.zsh"
  "/usr/share/fzf/completion.zsh"
  "$HOME/.fzf/shell/key-bindings.zsh"
  "$HOME/.fzf/shell/completion.zsh"
  "$HOME/.fzf.zsh"
)

# Source key-bindings
for location in "${FZF_LOCATIONS[@]}"; do
  if [[ "$location" == *"key-bindings"* ]] && [[ -f "$location" ]]; then
    source "$location"
    break
  fi
done

# Source completion
for location in "${FZF_LOCATIONS[@]}"; do
  if [[ "$location" == *"completion"* ]] && [[ -f "$location" ]]; then
    source "$location"
    break
  fi
done

# Source .fzf.zsh if exists (common setup)
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"
