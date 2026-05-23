#!/usr/bin/env zsh

(( ! $+commands[rg] )) && return

: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Symlink stock _rg completion (ripgrep ships one)
for rg_completion in /usr/share/zsh/site-functions/_rg /usr/local/share/zsh/site-functions/_rg; do
    if [[ -f "$rg_completion" && ! -e "$ZSH_CACHE_DIR/completions/_rg" ]]; then
        ln -sf "$rg_completion" "$ZSH_CACHE_DIR/completions/_rg"
        break
    fi
done
unset rg_completion

# Default config file location (rg reads $RIPGREP_CONFIG_PATH if set)
: ${RIPGREP_CONFIG_PATH:="$HOME/.config/ripgreprc"}
export RIPGREP_CONFIG_PATH

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
