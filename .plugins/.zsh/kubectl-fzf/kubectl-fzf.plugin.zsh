#!/usr/bin/env zsh

# kubectl-fzf provides fast, fuzzy completion for kubectl. Requires:
#   - kubectl on PATH
#   - the kubectl-fzf binary (`cache_builder`) running or its cache available
#   - fzf on PATH
# Source: https://github.com/bonnefoa/kubectl-fzf
(( ! $+commands[kubectl] )) && return
(( ! $+commands[fzf] )) && return

# Locate the plugin's .plugin.zsh shipped by the upstream project. The user
# is expected to clone or install kubectl-fzf into one of these standard
# locations; we just source whichever exists first.
local kubectl_fzf_sources=(
    "$HOME/.kubectl_fzf/kubectl_fzf.plugin.zsh"
    "$HOME/.local/share/kubectl-fzf/kubectl_fzf.plugin.zsh"
    /opt/kubectl-fzf/kubectl_fzf.plugin.zsh
    /usr/local/share/kubectl-fzf/kubectl_fzf.plugin.zsh
)
for src in "${kubectl_fzf_sources[@]}"; do
    if [[ -f "$src" ]]; then
        source "$src"
        return
    fi
done

# Optional: print a hint the first time the plugin loads with no source
# file present. Comment out if noisy.
# echo "[kubectl-fzf] not installed — see https://github.com/bonnefoa/kubectl-fzf" >&2
