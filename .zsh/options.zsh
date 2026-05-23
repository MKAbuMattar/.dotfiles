#!/usr/bin/env zsh

# ==========================
# MANPATH
# ==========================
# Make `man <module>` and `apropos <keyword>` find the dotfiles man pages
# (built by .scripts/build-man-pages.py into <repo>/.man/).
if [[ -d "$HOME/.config/.dotfiles/.man" ]]; then
    if [[ ":$MANPATH:" != *":$HOME/.config/.dotfiles/.man:"* ]]; then
        export MANPATH="$HOME/.config/.dotfiles/.man${MANPATH:+:$MANPATH}"
    fi
fi

# ==========================
# General Options
# ==========================

setopt correct                    # Auto correct mistakes
setopt extendedglob              # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                # Case insensitive globbing
setopt rcexpandparam             # Array expension with parameters
setopt nocheckjobs               # Don't warn about running processes when exiting
setopt numericglobsort           # Sort filenames numerically when it makes sense
setopt nobeep                    # No beep
setopt appendhistory             # Immediately append history instead of overwriting
setopt histignorealldups         # If a new command is a duplicate, remove the older one
setopt autocd                    # if only directory path is entered, cd there.
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# ==========================
# History Configuration
# ==========================

function set_app_history() {
  # Get terminal app name (fallback: Apple_Terminal)
  local app=${TERM_PROGRAM:-Apple_Terminal}

  # Default history file
  HISTFILE="$HOME/.zsh/.zsh_history"

  # Ghostty on Linux / WSL → use default history
  if [[ "$app" == "Ghostty" && "$(uname -s)" == "Linux" ]]; then
    export HISTFILE
    return
  fi

  # Apple Terminal → use default history
  if [[ "$app" == "Apple_Terminal" ]]; then
    export HISTFILE
    return
  fi

  # Everything else → per-app history
  app=${app//[^A-Za-z0-9]/_}
  HISTFILE="$HOME/.zsh/.zsh_history_${app}"
  export HISTFILE
}

set_app_history

HISTSIZE=10000000
SAVEHIST=10000000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt HIST_VERIFY
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
