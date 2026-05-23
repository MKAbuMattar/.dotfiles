#!/usr/bin/env zsh

# Do nothing if dnf is not installed (not a Fedora/RHEL-based system)
(( ! $+commands[dnf] && ! $+commands[dnf5] )) && return

# Prefer dnf5 if installed, otherwise plain dnf. Override by setting
# $dnf_pref before sourcing.
if [[ -z "${dnf_pref:-}" ]]; then
    if (( $+commands[dnf5] )); then
        typeset -g dnf_pref='dnf5'
    else
        typeset -g dnf_pref='dnf'
    fi
fi

# Functions #################################################################

# Print dnf history filtered by action
# Usage:
#   dnf-history install
#   dnf-history upgrade
#   dnf-history remove
#   dnf-history list
function dnf-history() {
    case "$1" in
        install|upgrade|remove)
            "$dnf_pref" history list | awk -v action="$1" 'tolower($0) ~ action'
            ;;
        list)
            "$dnf_pref" history list
            ;;
        *)
            echo "Parameters:"
            echo " install  - Lists install history entries."
            echo " upgrade  - Lists upgrade history entries."
            echo " remove   - Lists remove history entries."
            echo " list     - Lists all history entries."
            ;;
    esac
}

# List explicitly installed user packages (excludes group/dependency installs)
function dnf-list-userinstalled() {
    "$dnf_pref" repoquery --userinstalled --queryformat '%{name}\n' 2>/dev/null | sort -u
}

# Show on-disk size of every installed package, largest first
function dnf-list-packages-by-size() {
    rpm -qa --queryformat '%{SIZE}\t%{NAME}\n' | sort -rn | head -n "${1:-30}"
}

# Remove orphaned dependencies (auto-installed and no longer needed)
function dnf-remove-orphans() {
    if (( $+commands[sudo] )); then
        sudo "$dnf_pref" autoremove
    else
        su -lc "$dnf_pref autoremove" root
    fi
}

# Save the list of explicitly-installed packages for system duplication
function dnf-backup() {
    local backup_file="${1:-packages_$(date +%Y%m%d).txt}"
    "$dnf_pref" repoquery --userinstalled --queryformat '%{name}\n' > "$backup_file"
    echo "Package list saved to: $backup_file"
    echo "To restore: sudo dnf install \$(< $backup_file)"
}

# Restore packages from a backup file
function dnf-restore() {
    if [[ -z "$1" ]]; then
        echo "Usage: dnf-restore <backup_file>"
        return 1
    fi
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' not found."
        return 1
    fi
    if (( $+commands[sudo] )); then
        sudo "$dnf_pref" install $(< "$1")
    else
        su -lc "$dnf_pref install $(< "$1")" root
    fi
}

# Show packages that need a reboot (typically after a kernel update)
function dnf-check-reboot() {
    local current installed
    current=$(uname -r)
    installed=$(rpm -q --last kernel 2>/dev/null | head -1 | awk '{print $1}' | sed 's/^kernel-//')

    echo "Running kernel:   $current"
    echo "Installed kernel: $installed"
    if [[ "$installed" != *"$current"* ]]; then
        echo "⚠️  Reboot recommended — a newer kernel is installed."
    else
        echo "✓ Kernel is up to date."
    fi
}

# Search and install package interactively with fzf preview
function dnf-search-install() {
    if [[ -z "$1" ]]; then
        echo "Usage: dnf-search-install <search_term>"
        return 1
    fi
    if ! (( $+commands[fzf] )); then
        echo "fzf is required for interactive selection."
        return 1
    fi

    local package
    package=$("$dnf_pref" search "$1" 2>/dev/null \
        | awk -F'[ :]' '/\.(x86_64|aarch64|noarch|i686)/ {print $1}' \
        | sort -u \
        | fzf --preview "$dnf_pref info {1}")

    if [[ -n "$package" ]]; then
        if (( $+commands[sudo] )); then
            sudo "$dnf_pref" install "$package"
        else
            su -lc "$dnf_pref install $package" root
        fi
    fi
}
