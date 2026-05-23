#!/usr/bin/env zsh

# Do nothing if zypper is not installed (not an openSUSE/SLES system)
(( ! $+commands[zypper] )) && return

# Cache directory (created lazily, idempotent)
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"

# Make the cache completions directory discoverable
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Completion ################################################################
# zypper ships its own _zypper in /usr/share/zsh/site-functions on openSUSE;
# symlink it into the cache so completions work without a full fpath rebuild.
for zypper_completion in /usr/share/zsh/site-functions/_zypper /usr/local/share/zsh/site-functions/_zypper; do
    if [[ -f "$zypper_completion" && ! -e "$ZSH_CACHE_DIR/completions/_zypper" ]]; then
        ln -sf "$zypper_completion" "$ZSH_CACHE_DIR/completions/_zypper"
        break
    fi
done
unset zypper_completion

# Reload completions so newly-installed files are picked up. Idempotent and
# cheap thanks to the .zcompdump cache.
autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
