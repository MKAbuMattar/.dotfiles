#!/usr/bin/env zsh

(( ! $+commands[kubectx] && ! $+commands[kubens] )) && return

: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# kubectx ships completion files; symlink whichever locations exist.
for src in \
    /usr/share/zsh/site-functions/_kubectx \
    /usr/local/share/zsh/site-functions/_kubectx \
    /opt/homebrew/share/zsh/site-functions/_kubectx; do
    if [[ -f "$src" && ! -e "$ZSH_CACHE_DIR/completions/_kubectx" ]]; then
        ln -sf "$src" "$ZSH_CACHE_DIR/completions/_kubectx"
        break
    fi
done

for src in \
    /usr/share/zsh/site-functions/_kubens \
    /usr/local/share/zsh/site-functions/_kubens \
    /opt/homebrew/share/zsh/site-functions/_kubens; do
    if [[ -f "$src" && ! -e "$ZSH_CACHE_DIR/completions/_kubens" ]]; then
        ln -sf "$src" "$ZSH_CACHE_DIR/completions/_kubens"
        break
    fi
done
unset src

# kubectx/kubens detect fzf at runtime — nothing to configure here, but if
# fzf is on $PATH the tools automatically present a fuzzy picker.

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
