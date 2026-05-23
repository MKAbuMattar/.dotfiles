#!/usr/bin/env zsh

# Skip when neither bat nor batcat is installed
(( ! $+commands[bat] && ! $+commands[batcat] )) && return

# Default theme + style if the user hasn't set them. Override per-shell by
# setting BAT_THEME / BAT_STYLE before sourcing.
: ${BAT_THEME:='ansi'}
: ${BAT_STYLE:='numbers,changes,header'}
export BAT_THEME BAT_STYLE

# Make bat the colored pager for man(1) — colored headers + paging.
if (( $+commands[bat] )); then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
elif (( $+commands[batcat] )); then
    export MANPAGER="sh -c 'col -bx | batcat -l man -p'"
    export MANROFFOPT="-c"
fi

# Cache + fpath setup
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Wire system-installed completion file when present
for bat_completion in /usr/share/zsh/site-functions/_bat /usr/local/share/zsh/site-functions/_bat; do
    if [[ -f "$bat_completion" && ! -e "$ZSH_CACHE_DIR/completions/_bat" ]]; then
        ln -sf "$bat_completion" "$ZSH_CACHE_DIR/completions/_bat"
        break
    fi
done
unset bat_completion

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
