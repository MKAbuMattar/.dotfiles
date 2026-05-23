#!/usr/bin/env zsh

(( ! $+commands[systemctl] )) && return

: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}
mkdir -p "$ZSH_CACHE_DIR/completions"
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
    fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# systemd ships completion as _systemctl + _journalctl + _systemd-* in
# /usr/share/zsh/site-functions on most distros — already on fpath by
# default, but symlink them into the cache for consistency.
for f in /usr/share/zsh/site-functions/_systemctl /usr/share/zsh/site-functions/_journalctl; do
    local target="$ZSH_CACHE_DIR/completions/$(basename "$f")"
    if [[ -f "$f" && ! -e "$target" ]]; then
        ln -sf "$f" "$target"
    fi
done
unset f target

autoload -Uz compinit
compinit -d "$ZSH_CACHE_DIR/.zcompdump"
