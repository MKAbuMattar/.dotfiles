#!/usr/bin/env zsh

# Use sudo by default if it's installed
if [[ -e $commands[sudo] ]]; then
    use_sudo=1
fi

# Detect AUR helper (prefer yay, then paru, fallback to pacman)
if [[ -e $commands[yay] ]]; then
    aur_helper='yay'
elif [[ -e $commands[paru] ]]; then
    aur_helper='paru'
else
    aur_helper='pacman'
fi

# Functions #################################################################

# Prints pacman history
# Usage:
#   pac-history install
#   pac-history remove
#   pac-history upgrade
#   pac-history list
function pac-history() {
  case "$1" in
    install)
      grep -i installed /var/log/pacman.log
      ;;
    remove)
      grep -i removed /var/log/pacman.log
      ;;
    upgrade)
      grep -i upgraded /var/log/pacman.log
      ;;
    list)
      cat /var/log/pacman.log
      ;;
    *)
      echo "Parameters:"
      echo " install - Lists all packages that have been installed."
      echo " remove  - Lists all packages that have been removed."
      echo " upgrade - Lists all packages that have been upgraded."
      echo " list    - Lists all pacman log entries."
      ;;
  esac
}

# List packages by size
function pac-list-packages() {
    expac -H M "%011m\t%-20n\t%10d" | sort -n
}

# List packages by installation date
function pac-list-recent() {
    expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort -r | head -n ${1:-20}
}

# Remove orphaned packages
function pac-remove-orphans() {
    local orphans=$(pacman -Qtdq)
    if [[ -z "$orphans" ]]; then
        echo "No orphaned packages found."
    else
        if [[ $use_sudo -eq 1 ]]; then
            sudo pacman -Rns $(pacman -Qtdq)
        else
            su -c "pacman -Rns $(pacman -Qtdq)"
        fi
    fi
}

# Create a list of installed packages for system duplication
function pac-backup() {
    local backup_file="${1:-packages_$(date +%Y%m%d).txt}"
    pacman -Qqe > "$backup_file"
    echo "Package list saved to: $backup_file"
    echo "To restore: sudo pacman -S --needed \$(< $backup_file)"
}

# Restore packages from a backup file
function pac-restore() {
    if [[ -z "$1" ]]; then
        echo "Usage: pac-restore <backup_file>"
        return 1
    fi

    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' not found."
        return 1
    fi

    if [[ $use_sudo -eq 1 ]]; then
        sudo pacman -S --needed $(< "$1")
    else
        su -c "pacman -S --needed $(< $1)"
    fi
}

# Search and install package interactively
function pac-search-install() {
    if [[ -z "$1" ]]; then
        echo "Usage: pac-search-install <search_term>"
        return 1
    fi

    local package=$(pacman -Ss "$1" | fzf --preview 'pacman -Si {1}' | awk '{print $1}' | sed 's/\/.*//')

    if [[ -n "$package" ]]; then
        if [[ $use_sudo -eq 1 ]]; then
            sudo pacman -S "$package"
        else
            su -c "pacman -S $package"
        fi
    fi
}

# Clean package cache except for the latest 3 versions
function pac-clean-cache() {
    if [[ $use_sudo -eq 1 ]]; then
        sudo paccache -rk3
    else
        su -c "paccache -rk3"
    fi
}

# Show packages that need a reboot (typically after kernel update)
function pac-check-reboot() {
    local current_kernel=$(uname -r)
    local installed_kernel=$(pacman -Q linux | awk '{print $2}')

    echo "Current running kernel: $current_kernel"
    echo "Installed kernel version: $installed_kernel"

    if [[ ! "$current_kernel" =~ "$installed_kernel" ]]; then
        echo "⚠️  Reboot recommended - kernel has been updated"
    else
        echo "✓ System is up to date"
    fi
}

# Update mirror list using reflector
function pac-update-mirrors() {
    if [[ ! -e $commands[reflector] ]]; then
        echo "reflector is not installed. Install it with: sudo pacman -S reflector"
        return 1
    fi

    echo "Updating mirror list..."
    if [[ $use_sudo -eq 1 ]]; then
        sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
    else
        su -c "reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist"
    fi
    echo "Mirror list updated successfully!"
}

# Download package without installing
function pac-download() {
    if [[ -z "$1" ]]; then
        echo "Usage: pac-download <package_name>"
        return 1
    fi

    if [[ $use_sudo -eq 1 ]]; then
        sudo pacman -Sw "$@"
    else
        su -c "pacman -Sw $@"
    fi
}

# Show what package provides a file
function pac-whatprovides() {
    if [[ -z "$1" ]]; then
        echo "Usage: pac-whatprovides <file>"
        return 1
    fi

    pkgfile "$1"
}
