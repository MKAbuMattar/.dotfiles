#!/usr/bin/env zsh

# Do nothing if apk is not installed (not an Alpine system)
(( ! $+commands[apk] )) && return

# Cache directory (created lazily, idempotent)
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"

# Make the cache completions directory discoverable
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Completion ################################################################
# Alpine's `zsh` package doesn't ship a stock _apk completion; if one is
# present (e.g. from the user's own zsh-users/zsh-completions), pick it up.
for apk_completion in /usr/share/zsh/site-functions/_apk /usr/local/share/zsh/site-functions/_apk; do
    if [[ -f "$apk_completion" && ! -e "$ZSH_CACHE_DIR/completions/_apk" ]]; then
        ln -sf "$apk_completion" "$ZSH_CACHE_DIR/completions/_apk"
        break
    fi
done
unset apk_completion

# Reload completions so newly-installed files are picked up. Idempotent and
# cheap thanks to the .zcompdump cache.
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
