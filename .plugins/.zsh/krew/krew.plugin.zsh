#!/usr/bin/env zsh

# krew is the kubectl plugin manager — see https://krew.sigs.k8s.io
# Without kubectl this plugin makes no sense.
(( ! $+commands[kubectl] )) && return

# krew installs binaries under ~/.krew/bin and adds them to PATH so that
# kubectl-foo becomes invokable as `kubectl foo`. We just need to wire that
# directory into PATH if the krew install exists.
if [[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]]; then
    case ":$PATH:" in
        *":${KREW_ROOT:-$HOME/.krew}/bin:"*) ;;  # already present
        *) export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" ;;
    esac
fi

# Completions for kubectl plugins (e.g. kubectl-ctx) are auto-provided by
# kubectl's own _kubectl completion via `kubectl plugin list`; no extra
# wiring needed.
