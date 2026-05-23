#!/usr/bin/env zsh

# Detect bat binary name (Fedora ships it as `bat`, Debian/Ubuntu as `batcat`)
if (( $+commands[bat] )); then
    typeset -g BAT_BIN='bat'
elif (( $+commands[batcat] )); then
    typeset -g BAT_BIN='batcat'
else
    return
fi

# Aliases ###################################################################
alias cat="$BAT_BIN --paging=never"
alias less="$BAT_BIN --paging=always"
alias bcat="$BAT_BIN"
alias bplain="$BAT_BIN --style=plain --paging=never"
alias bjson="$BAT_BIN -l json --paging=never"
alias byaml="$BAT_BIN -l yaml --paging=never"
alias btoml="$BAT_BIN -l toml --paging=never"
alias bmd="$BAT_BIN -l md"
alias bnum="$BAT_BIN --style=numbers"

# Pretty-print piped input as a specific language: e.g.  curl ... | bjson
# (`bjson` already covers JSON; add more as needed.)
