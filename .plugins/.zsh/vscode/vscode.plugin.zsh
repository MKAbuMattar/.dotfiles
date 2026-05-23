#!/usr/bin/env zsh

# VS Code (stable / insiders) / VSCodium / Cursor zsh plugin

# Verify if any manual user choice of VS Code exists first.
if [[ -n "$VSCODE" ]] && ! which $VSCODE &>/dev/null; then
  echo "'$VSCODE' flavour of VS Code not detected."
  unset VSCODE
fi

# Otherwise, try to detect a flavour of VS Code.
if [[ -z "$VSCODE" ]]; then
  if which code &>/dev/null; then
    VSCODE=code
  elif which code-insiders &>/dev/null; then
    VSCODE=code-insiders
  elif which codium &>/dev/null; then
    VSCODE=codium
  elif which cursor &>/dev/null; then
    VSCODE=cursor
  else
    return
  fi
fi

export VSCODE
