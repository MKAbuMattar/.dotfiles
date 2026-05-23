#!/usr/bin/env zsh

(( ! $+commands[tmux] )) && return

# Functions #################################################################

# Attach to an existing tmux session via fzf, or create one named after the
# current directory if no sessions exist. Requires fzf.
function tms() {
    if ! (( $+commands[fzf] )); then
        # Plain fallback: just attach to default, or create new
        if tmux has-session 2>/dev/null; then
            tmux attach
        else
            tmux new -s "${PWD:t}"
        fi
        return
    fi

    local session
    session=$(tmux list-sessions -F '#S' 2>/dev/null | fzf \
        --print-query \
        --no-multi \
        --prompt='tmux> ' \
        --preview 'tmux list-windows -t {} 2>/dev/null' \
        | tail -1)

    if [[ -z "$session" ]]; then
        return 0
    elif tmux has-session -t "$session" 2>/dev/null; then
        if [[ -z "$TMUX" ]]; then
            tmux attach -t "$session"
        else
            tmux switch-client -t "$session"
        fi
    else
        # Session doesn't exist — create it with the typed name
        tmux new -s "$session"
    fi
}

# Quickly rename the current tmux window from anywhere
# Usage: tm-rename <new-name>
function tm-rename() {
    if [[ -z "$TMUX" ]]; then
        echo "Not inside tmux."
        return 1
    fi
    if [[ -z "$1" ]]; then
        echo "Usage: tm-rename <new-window-name>"
        return 1
    fi
    tmux rename-window "$1"
}

# List sessions in a clean table with window counts
function tm-list() {
    tmux list-sessions -F '#{session_name}|#{session_windows}|#{?session_attached,attached,detached}|#{session_created_string}' \
        | column -t -s '|'
}
