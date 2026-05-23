#!/usr/bin/env zsh

# Detect binary name: Fedora ships `fd`, Debian/Ubuntu ship `fdfind`
if (( $+commands[fd] )); then
    typeset -g FD_BIN='fd'
elif (( $+commands[fdfind] )); then
    typeset -g FD_BIN='fdfind'
else
    return
fi

# Aliases ###################################################################
# Note: this re-aliases the underlying tool name to itself; if the binary is
# fdfind on Debian/Ubuntu, alias `fd` to it so commands stay portable.
if [[ "$FD_BIN" == 'fdfind' ]] && ! (( $+commands[fd] )); then
    alias fd='fdfind'
fi

alias fdh="$FD_BIN --hidden"
alias fdH="$FD_BIN --hidden --no-ignore"        # ignore .gitignore too
alias fde="$FD_BIN --extension"                 # by extension: `fde py`
alias fdt="$FD_BIN --type"                      # by type: `fdt d`, `fdt f`, `fdt l`
alias fdx="$FD_BIN --exec"                      # exec: `fdx -e py -- ruff check`
alias fdfx="$FD_BIN -t x"                       # executables only
alias fdsz="$FD_BIN --type f --size"            # by size: `fdsz +1M`
alias fdold="$FD_BIN --type f --changed-before" # `fdold 30d`
alias fdnew="$FD_BIN --type f --changed-within" # `fdnew 1d`
