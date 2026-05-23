#!/usr/bin/env zsh

(( ! $+commands[tmux] )) && return

# Aliases ###################################################################
alias tm='tmux'
alias tma='tmux attach'              # attach to default session
alias tmat='tmux attach -t'          # attach to named: tmat <name>
alias tml='tmux list-sessions'       # list sessions
alias tmn='tmux new -s'              # new named session: tmn work
alias tmk='tmux kill-session -t'     # kill named: tmk <name>
alias tmka='tmux kill-server'        # kill everything

# Window/pane shortcuts (from inside tmux — use the prefix instead)
alias tmlw='tmux list-windows'
alias tmlp='tmux list-panes'

# Source the tmux config without restarting
alias tmsrc='tmux source-file ~/.tmux.conf'

# Show env vars exported into the current tmux session
alias tmenv='tmux show-environment'
