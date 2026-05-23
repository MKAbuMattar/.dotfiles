#!/usr/bin/env zsh

# Do nothing if zypper is not installed (not an openSUSE/SLES system)
(( ! $+commands[zypper] )) && return

# Functions #################################################################

# Print zypper history filtered by action
# Usage:
#   zypper-history install
#   zypper-history remove
#   zypper-history update
#   zypper-history list
function zypper-history() {
    local log='/var/log/zypp/history'
    [[ -r "$log" ]] || { echo "Cannot read $log (try as root)"; return 1; }

    case "$1" in
        install)
            grep '|install|' "$log" | awk -F'|' '{print $1, $3}'
            ;;
        remove)
            grep '|remove|' "$log" | awk -F'|' '{print $1, $3}'
            ;;
        update)
            grep -E '\|(upgrade|update)\|' "$log" | awk -F'|' '{print $1, $3}'
            ;;
        list)
            cat "$log"
            ;;
        *)
            echo "Parameters:"
            echo " install  - List install transactions"
            echo " remove   - List remove transactions"
            echo " update   - List update/upgrade transactions"
            echo " list     - Show the full zypp history log"
            ;;
    esac
}

# List packages explicitly installed by the user (excludes patterns and deps)
function zypper-list-userinstalled() {
    zypper packages --installed-only --orphaned 2>/dev/null \
        | awk '/^i/ {print $5}' \
        | sort -u
}

# Show on-disk size of every installed package, largest first
function zypper-list-packages-by-size() {
    rpm -qa --queryformat '%{SIZE}\t%{NAME}\n' | sort -rn | head -n "${1:-30}"
}

# Remove orphaned packages (no longer required by anything)
function zypper-remove-orphans() {
    local orphans
    orphans=$(zypper packages --orphaned 2>/dev/null | awk '/^i/ {print $5}')
    if [[ -z "$orphans" ]]; then
        echo "No orphaned packages found."
        return 0
    fi
    if (( $+commands[sudo] )); then
        sudo zypper remove --clean-deps $orphans
    else
        su -lc "zypper remove --clean-deps $orphans" root
    fi
}

# Save the list of explicitly-installed packages for system duplication
function zypper-backup() {
    local backup_file="${1:-packages_$(date +%Y%m%d).txt}"
    zypper-list-userinstalled > "$backup_file"
    echo "Package list saved to: $backup_file"
    echo "To restore: sudo zypper install \$(< $backup_file)"
}

# Restore packages from a backup file
function zypper-restore() {
    if [[ -z "$1" ]]; then
        echo "Usage: zypper-restore <backup_file>"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' not found."
        return 1
    fi
    if (( $+commands[sudo] )); then
        sudo zypper install $(< "$1")
    else
        su -lc "zypper install $(< "$1")" root
    fi
}

# Show services that need restart after an update (zypper ps integration)
function zypper-check-reboot() {
    if (( $+commands[sudo] )); then
        sudo zypper ps -s
    else
        su -lc "zypper ps -s" root
    fi
}

# Search and install package interactively with fzf preview
function zypper-search-install() {
    if [[ -z "$1" ]]; then
        echo "Usage: zypper-search-install <search_term>"
        return 1
    fi
    if ! (( $+commands[fzf] )); then
        echo "fzf is required for interactive selection."
        return 1
    fi

    local package
    package=$(zypper search "$1" 2>/dev/null \
        | awk '/^[i ]/ {print $3}' \
        | sort -u \
        | grep -v '^$' \
        | fzf --preview 'zypper info {1}')

    if [[ -n "$package" ]]; then
        if (( $+commands[sudo] )); then
            sudo zypper install "$package"
        else
            su -lc "zypper install $package" root
        fi
    fi
}
