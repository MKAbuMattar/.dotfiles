#!/usr/bin/env zsh

# Do nothing if screen is not installed
(( ! $+commands[screen] )) && return

# GNU Screen aliases
alias sl='screen -ls'
alias sn='screen -S'
alias sr='screen -r'
alias sx='screen -x'
alias sd='screen -d'
alias sdr='screen -dr'
alias sX='screen -X'
alias sq='screen -X quit'

# Quick screen session management
alias scr='screen -r'
alias scrd='screen -d -r'
alias scrn='screen -S'
alias scrl='screen -ls'
