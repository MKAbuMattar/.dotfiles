#!/usr/bin/env zsh

# Do nothing if dnf is not installed (not a Fedora/RHEL-based system)
(( ! $+commands[dnf] && ! $+commands[dnf5] )) && return

# Cache directory (created lazily, idempotent)
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"

# Make the cache completions directory discoverable
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Completion ################################################################
# dnf ships its own _dnf in /usr/share/zsh/site-functions on Fedora; symlink
# it into the cache so completions work without a full fpath rebuild.
for dnf_completion in /usr/share/zsh/site-functions/_dnf /usr/local/share/zsh/site-functions/_dnf; do
    if [[ -f "$dnf_completion" && ! -e "$ZSH_CACHE_DIR/completions/_dnf" ]]; then
        ln -sf "$dnf_completion" "$ZSH_CACHE_DIR/completions/_dnf"
        break
    fi
done
unset dnf_completion

# If dnf5 is the active binary, alias its completion under the same name so
# zsh picks it up automatically.
if (( $+commands[dnf5] )) && [[ ! -e "$ZSH_CACHE_DIR/completions/_dnf5" ]]; then
    for dnf5_completion in /usr/share/zsh/site-functions/_dnf5 /usr/local/share/zsh/site-functions/_dnf5; do
        if [[ -f "$dnf5_completion" ]]; then
            ln -sf "$dnf5_completion" "$ZSH_CACHE_DIR/completions/_dnf5"
            break
        fi
    done
    unset dnf5_completion
fi

# Reload completions so the newly-installed files are picked up. This is
# idempotent and cheap thanks to the .zcompdump cache.
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
