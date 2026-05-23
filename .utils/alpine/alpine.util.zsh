#!/usr/bin/env zsh

# Do nothing if apk is not installed (not an Alpine system)
(( ! $+commands[apk] )) && return

# Functions #################################################################

# Print apk install/remove history from the kernel log fallback
# Usage:
#   apk-history install
#   apk-history remove
#   apk-history list
#
# Note: apk does not maintain a structured transaction log like dnf/zypper.
# This function inspects the kernel ring buffer message for apk events plus
# /var/log/apk.log when it exists (some distros enable it via syslog).
function apk-history() {
    local log='/var/log/apk.log'
    case "$1" in
        install)
            if [[ -r "$log" ]]; then
                grep -i 'install ' "$log"
            else
                echo "$log not found — apk does not log transactions by default."
                echo "Enable with: echo '*.*  /var/log/apk.log' >> /etc/syslog.conf"
            fi
            ;;
        remove)
            if [[ -r "$log" ]]; then
                grep -i 'remove ' "$log"
            else
                echo "$log not found."
            fi
            ;;
        list)
            if [[ -r "$log" ]]; then
                cat "$log"
            else
                echo "$log not found."
            fi
            ;;
        *)
            echo "Parameters:"
            echo " install  - List install events from /var/log/apk.log"
            echo " remove   - List remove events"
            echo " list     - Show the full apk log"
            ;;
    esac
}

# List explicitly installed packages (the "world" file)
function apk-list-userinstalled() {
    cat /etc/apk/world
}

# Show on-disk size of every installed package, largest first
function apk-list-packages-by-size() {
    apk info -s 2>/dev/null \
        | awk '/installed size:/ {size=$3 $4} /^[a-zA-Z0-9]/ {if (name) print last_size, name; name=$1; last_size=size} END {if (name) print last_size, name}' \
        | sort -rh \
        | head -n "${1:-30}"
}

# Remove packages that are no longer in the "world" file but still installed
# (apk's closest analog to "orphans")
function apk-prune() {
    if (( $+commands[sudo] )); then
        sudo apk del --purge --no-progress $(apk info | grep -vxFf /etc/apk/world)
    else
        su -lc "apk del --purge --no-progress \$(apk info | grep -vxFf /etc/apk/world)" root
    fi
}

# Save the list of explicitly-installed packages for system duplication
function apk-backup() {
    local backup_file="${1:-packages_$(date +%Y%m%d).txt}"
    cat /etc/apk/world > "$backup_file"
    echo "Package list saved to: $backup_file"
    echo "To restore: sudo apk add \$(< $backup_file)"
}

# Restore packages from a backup file
function apk-restore() {
    if [[ -z "$1" ]]; then
        echo "Usage: apk-restore <backup_file>"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' not found."
        return 1
    fi
    if (( $+commands[sudo] )); then
        sudo apk add $(< "$1")
    else
        su -lc "apk add $(< "$1")" root
    fi
}

# Show running services that need restart after an upgrade
function apk-check-reboot() {
    local current installed
    current=$(uname -r)
    installed=$(apk list --installed 2>/dev/null | awk '/^linux-/ {print $1; exit}')
    echo "Running kernel:   $current"
    echo "Installed kernel: $installed"

    # Alpine doesn't ship `needrestart`; the closest signal is checking for
    # deleted-but-mapped libraries via lsof.
    if (( $+commands[lsof] )); then
        local stale
        stale=$(lsof +c 0 2>/dev/null | awk '/DEL.*lib/ {print $1}' | sort -u | head)
        if [[ -n "$stale" ]]; then
            echo "Services with stale libraries: $stale"
            echo "⚠️  Consider restarting them or rebooting."
        else
            echo "✓ No stale library mappings detected."
        fi
    fi
}

# Search and install package interactively with fzf preview
function apk-search-install() {
    if [[ -z "$1" ]]; then
        echo "Usage: apk-search-install <search_term>"
        return 1
    fi
    if ! (( $+commands[fzf] )); then
        echo "fzf is required for interactive selection."
        return 1
    fi

    local package
    package=$(apk search -q "$1" 2>/dev/null \
        | sort -u \
        | fzf --preview 'apk info {1}')

    if [[ -n "$package" ]]; then
        if (( $+commands[sudo] )); then
            sudo apk add "$package"
        else
            su -lc "apk add $package" root
        fi
    fi
}
