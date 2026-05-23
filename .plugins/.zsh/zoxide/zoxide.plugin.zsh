#!/usr/bin/env zsh

# No-op without zoxide installed
(( ! $+commands[zoxide] )) && return

# Initialize zoxide — defines the `z` and `zi` functions and the chpwd hook
# that records visited directories. `--cmd cd` would replace cd entirely;
# we keep cd as the builtin and use `z` explicitly, which is less surprising.
eval "$(zoxide init zsh)"
