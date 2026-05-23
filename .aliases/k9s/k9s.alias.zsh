#!/usr/bin/env zsh

# Do nothing if k9s is not installed
(( ! $+commands[k9s] )) && return

# General aliases
alias k9='k9s'
alias k9s-info='k9s info'
alias k9s-version='k9s version'
alias k9s-help='k9s help'

# Start k9s in specific namespace
alias k9n='k9s -n'
alias k9sa='k9s --all-namespaces'

# Start k9s with specific context
alias k9c='k9s --context'

# Start k9s in read-only mode
alias k9ro='k9s --readonly'

# Start k9s with specific command
alias k9p='k9s -c pod'
alias k9d='k9s -c deploy'
alias k9svc='k9s -c svc'
alias k9ing='k9s -c ingress'
alias k9cm='k9s -c configmap'
alias k9sec='k9s -c secret'
alias k9ns='k9s -c namespace'
alias k9no='k9s -c node'
alias k9pv='k9s -c pv'
alias k9pvc='k9s -c pvc'
alias k9sts='k9s -c statefulset'
alias k9ds='k9s -c daemonset'
alias k9job='k9s -c job'
alias k9cj='k9s -c cronjob'

# Start k9s with logging
alias k9sl='k9s --logLevel'
alias k9sdebug='k9s --logLevel debug'

# Screen dump
alias k9dump='k9s --screen-dump'

# Headless mode (for screen recording)
alias k9head='k9s --headless'

# Write mode (default)
alias k9rw='k9s --write'
