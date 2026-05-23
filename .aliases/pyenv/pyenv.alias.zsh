#!/usr/bin/env zsh

# Do nothing if pyenv is not installed
(( ! $+commands[pyenv] )) && return

# List all available versions
alias pyl='pyenv versions'

# List all installed versions
alias pyls='pyenv versions --bare'

# Install a Python version
alias pyi='pyenv install'

# Uninstall a Python version
alias pyui='pyenv uninstall'

# Set global Python version
alias pyg='pyenv global'

# Set local Python version
alias pys='pyenv local'

# Set shell Python version
alias pysh='pyenv shell'

# Show current Python version
alias pyv='pyenv version'

# Rehash shims
alias pyr='pyenv rehash'

# Which Python executable
alias pyw='pyenv which'

# List all pyenv commands
alias pyc='pyenv commands'

# Update pyenv
alias pyu='cd "${PYENV_ROOT:-$HOME/.pyenv}" && git pull && cd -'

# Virtualenv commands (if pyenv-virtualenv is installed)
alias pyva='pyenv activate'
alias pyvd='pyenv deactivate'
alias pyvl='pyenv virtualenvs'
alias pyvi='pyenv virtualenv'
alias pyvui='pyenv virtualenv-delete'
