#!/usr/bin/env zsh

# Do nothing if VSCODE is not set
[[ -z "$VSCODE" ]] && return

function vsc {
  if (( $# )); then
    $VSCODE $@
  else
    $VSCODE .
  fi
}

alias vsca="$VSCODE --add"
alias vscd="$VSCODE --diff"
alias vscg="$VSCODE --goto"
alias vscn="$VSCODE --new-window"
alias vscr="$VSCODE --reuse-window"
alias vscw="$VSCODE --wait"
alias vscu="$VSCODE --user-data-dir"
alias vscp="$VSCODE --profile"

alias vsced="$VSCODE --extensions-dir"
alias vscie="$VSCODE --install-extension"
alias vscue="$VSCODE --uninstall-extension"

alias vscv="$VSCODE --verbose"
alias vscl="$VSCODE --log"
alias vscde="$VSCODE --disable-extensions"
