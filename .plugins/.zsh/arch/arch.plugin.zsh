#!/usr/bin/env zsh

# Do nothing if pacman is not installed (not an Arch-based system)
(( ! $+commands[pacman] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Completion ################################################################

# Enable pacman completion
if [[ ! -f "$ZSH_CACHE_DIR/completions/_pacman" ]]; then
    # Check if pacman completion exists in the system
    for completion_path in /usr/share/zsh/site-functions/_pacman /usr/local/share/zsh/site-functions/_pacman; do
        if [[ -f "$completion_path" ]]; then
            ln -sf "$completion_path" "$ZSH_CACHE_DIR/completions/_pacman"
            break
        fi
    done
fi

# Enable yay completion if yay is installed
if [[ -e $commands[yay] ]] && [[ ! -f "$ZSH_CACHE_DIR/completions/_yay" ]]; then
    for completion_path in /usr/share/zsh/site-functions/_yay /usr/local/share/zsh/site-functions/_yay; do
        if [[ -f "$completion_path" ]]; then
            ln -sf "$completion_path" "$ZSH_CACHE_DIR/completions/_yay"
            break
        fi
    done
fi

# Enable paru completion if paru is installed
if [[ -e $commands[paru] ]] && [[ ! -f "$ZSH_CACHE_DIR/completions/_paru" ]]; then
    for completion_path in /usr/share/zsh/site-functions/_paru /usr/local/share/zsh/site-functions/_paru; do
        if [[ -f "$completion_path" ]]; then
            ln -sf "$completion_path" "$ZSH_CACHE_DIR/completions/_paru"
            break
        fi
    done
fi

# Reload completions
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
