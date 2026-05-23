#!/usr/bin/env zsh

(( ! $+commands[zoxide] )) && return

# Aliases ###################################################################
# zoxide installs `z` and `zi` (interactive) as functions on `eval "$(zoxide init zsh)"`.
# These complement them; keep `cd` as the builtin so muscle memory still works.
alias zb='z -'                # jump back (previous dir)
alias zq='zoxide query'       # show ranked entries
alias zql='zoxide query --list'
alias zqi='zoxide query --interactive'
alias zr='zoxide remove'      # remove an entry by path
alias za='zoxide add'         # manually add a directory
