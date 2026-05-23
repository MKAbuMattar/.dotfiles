#!/usr/bin/env zsh

(( ! $+commands[systemctl] )) && return

# Aliases ###################################################################
# Read-only (no sudo needed)
alias sc='systemctl'
alias scs='systemctl status'
alias scq='systemctl is-active'
alias sce='systemctl is-enabled'
alias scl='systemctl list-units --type=service'
alias scll='systemctl list-unit-files --type=service'
alias scf='systemctl list-units --state=failed'

# Show all timers + their next firing time
alias sct='systemctl list-timers --all'

# Show socket units
alias scsk='systemctl list-sockets'

# journalctl
alias jctl='journalctl'
alias jctlu='journalctl -u'              # journalctl -u <service>
alias jctlf='journalctl -f'              # follow all
alias jctluf='journalctl -fu'            # follow a specific service
alias jctlb='journalctl -b'              # this boot only
alias jctle='journalctl -p err'          # errors only
alias jctlw='journalctl -p warning'      # warnings + errors

# Privileged actions
if (( $+commands[sudo] )); then
    alias scr='sudo systemctl restart'
    alias scst='sudo systemctl start'
    alias scsp='sudo systemctl stop'
    alias scrl='sudo systemctl reload'
    alias scen='sudo systemctl enable'
    alias scens='sudo systemctl enable --now'
    alias scdis='sudo systemctl disable'
    alias scdiss='sudo systemctl disable --now'
    alias scmsk='sudo systemctl mask'
    alias scumsk='sudo systemctl unmask'
    alias scdr='sudo systemctl daemon-reload'
fi
