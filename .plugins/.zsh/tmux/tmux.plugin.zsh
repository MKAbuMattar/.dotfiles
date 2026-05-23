#!/usr/bin/env zsh

(( ! $+commands[tmux] )) && return

: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# tmux ships its own _tmux completion in /usr/share/zsh/site-functions; pick
# whichever location exists and link it into the cache for consistency.
for src in /usr/share/zsh/site-functions/_tmux /usr/local/share/zsh/site-functions/_tmux; do
    if [[ -f "$src" && ! -e "$ZSH_CACHE_DIR/completions/_tmux" ]]; then
        ln -sf "$src" "$ZSH_CACHE_DIR/completions/_tmux"
        break
    fi
done
unset src

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
