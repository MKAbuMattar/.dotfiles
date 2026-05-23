#!/usr/bin/env zsh

# Do nothing if python3 is not installed
(( ! $+commands[python3] )) && return

# set python command if 'py' not installed
builtin which py > /dev/null || alias py='python3'

# Find python file
alias pyfind='find . -name "*.py"'

# Grep among .py files
alias pygrep='grep -nr --include="*.py"'

# Share local directory as a HTTP server
alias pyserver="python3 -m http.server"
