#!/usr/bin/env zsh

(( ! $+commands[rg] )) && return

# Aliases ###################################################################
alias rgi='rg -i'                       # case-insensitive
alias rgh='rg --hidden --no-ignore'     # include hidden + ignored files
alias rgs='rg --smart-case'             # case-sensitive iff query has caps
alias rgc='rg --count-matches'          # count matches per file
alias rgl='rg --files-with-matches'     # only show matching filenames
alias rgw='rg -w'                       # whole-word matches
alias rgf='rg --type'                   # limit to file type, e.g. `rgf py`
alias rgctx='rg -C 3'                   # 3 lines of context above + below
alias rgjson='rg --json'                # machine-readable output (jq-friendly)
