#!/usr/bin/env zsh

# Do nothing if poetry is not installed
(( ! $+commands[poetry] )) && return

# Dependencies
alias pad='poetry add'
alias padd='poetry add --group dev'
alias prm='poetry remove'

# Environment
alias pin='poetry init'
alias pinst='poetry install'
alias psync='poetry install --sync'
alias psh='poetry shell'
alias prun='poetry run'

# Project management
alias pnew='poetry new'
alias pbld='poetry build'
alias ppub='poetry publish'
alias pch='poetry check'
alias plck='poetry lock'

# Package information
alias pshw='poetry show'
alias ptree='poetry show --tree'
alias pslt='poetry show --latest'
alias pcmd='poetry list'

# Configuration
alias pconf='poetry config --list'
alias pvoff='poetry config virtualenvs.create false'

# Virtual environment
alias pvinf='poetry env info'
alias ppath='poetry env info --path'
alias pvu='poetry env use'
alias pvrm='poetry env remove'

# Export
alias pexp='poetry export --without-hashes > requirements.txt'

# Updates
alias pup='poetry update'
alias psup='poetry self update'

# Plugins
alias pplug='poetry self show plugins'
alias psad='poetry self add'
