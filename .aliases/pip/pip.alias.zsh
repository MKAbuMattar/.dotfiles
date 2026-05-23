#!/usr/bin/env zsh

# Do nothing if pip is not installed
if ! (( $+commands[pip3] || $+commands[pip] )); then
  return
fi

# Prefer pip3 if pip is not available
if (( $+commands[pip3] && !$+commands[pip] )); then
  alias pip="noglob pip3"
else
  alias pip="noglob pip"
fi

alias pipi="pip install"
alias pipu="pip install --upgrade"
alias pipun="pip uninstall"
alias pipgi="pip freeze | grep"
alias piplo="pip list -o"

# Create requirements file
alias pipreq="pip freeze > requirements.txt"

# Install packages from requirements file
alias pipir="pip install -r requirements.txt"
