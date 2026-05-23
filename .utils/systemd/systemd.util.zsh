#!/usr/bin/env zsh

(( ! $+commands[systemctl] )) && return

# Functions #################################################################

# Interactive service picker: lists active services + lets you pick one via
# fzf, then prints its status. Requires fzf.
function sc-pick() {
    if ! (( $+commands[fzf] )); then
        echo "fzf is required for interactive service selection."
        return 1
    fi
    local unit
    unit=$(systemctl list-units --type=service --all --no-legend \
        | awk '{print $1}' \
        | fzf --preview 'systemctl status {1} --no-pager -l')
    [[ -n "$unit" ]] && systemctl status "$unit" --no-pager -l
}

# Tail the journal for the last N entries of a specific service
# Usage: sc-tail <service> [count]
function sc-tail() {
    if [[ -z "$1" ]]; then
        echo "Usage: sc-tail <service> [count=50]"
        return 1
    fi
    journalctl -u "$1" -n "${2:-50}" --no-pager
}

# List all FAILED units with their description in a clean table
function sc-failed() {
    systemctl list-units --state=failed --no-legend \
        | awk '{name=$1; $1=$2=$3=$4=""; sub(/^ +/,""); printf "%-40s %s\n", name, $0}'
}

# Show which service most recently consumed CPU / wall-time (handy for
# debugging a slow boot)
function sc-blame() {
    systemd-analyze blame 2>/dev/null | head -n "${1:-20}"
}

# Quick reboot-required check based on /var/run/reboot-required
function sc-reboot-needed() {
    if [[ -f /var/run/reboot-required ]]; then
        echo "⚠️  Reboot required"
        cat /var/run/reboot-required.pkgs 2>/dev/null
        return 0
    fi
    # Fallback: compare running kernel to installed
    local running installed
    running=$(uname -r)
    if command -v dnf >/dev/null 2>&1; then
        installed=$(rpm -q --last kernel 2>/dev/null | head -1 | awk '{print $1}' | sed 's/^kernel-//')
    elif command -v dpkg >/dev/null 2>&1; then
        installed=$(dpkg -l | awk '/linux-image-[0-9]/ {print $2}' | tail -1 | sed 's/^linux-image-//')
    fi
    if [[ -n "$installed" && "$installed" != *"$running"* ]]; then
        echo "Kernel: running=$running installed=$installed"
        echo "⚠️  Reboot recommended"
    else
        echo "✓ No reboot needed"
    fi
}
