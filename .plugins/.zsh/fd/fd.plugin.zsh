#!/usr/bin/env zsh

(( ! $+commands[fd] && ! $+commands[fdfind] )) && return

: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Symlink stock _fd completion
for fd_completion in /usr/share/zsh/site-functions/_fd /usr/local/share/zsh/site-functions/_fd; do
    if [[ -f "$fd_completion" && ! -e "$ZSH_CACHE_DIR/completions/_fd" ]]; then
        ln -sf "$fd_completion" "$ZSH_CACHE_DIR/completions/_fd"
        break
    fi
done
unset fd_completion

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
