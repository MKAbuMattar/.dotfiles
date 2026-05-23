#!/usr/bin/env zsh

# Aliases ###################################################################
# Pacman aliases
alias pacman='pacman --color auto'
alias p='pacman'

# Search and info
alias pacs='pacman -Ss'
alias paci='pacman -Si'
alias paclo='pacman -Qdt'
alias pacls='pacman -Ql'
alias pacq='pacman -Q'

# superuser operations ######################################################
if (( $+commands[sudo] )); then
# commands using sudo #######
    alias pacu="sudo pacman -Syu"          # Update and upgrade packages
    alias paci="sudo pacman -S"            # Install packages
    alias pacr="sudo pacman -R"            # Remove packages
    alias pacrr="sudo pacman -Rns"         # Remove packages with dependencies
    alias pacc="sudo pacman -Sc"           # Clean old packages
    alias paccc="sudo pacman -Scc"         # Clean all packages
    alias pacro="sudo pacman -Rns \$(pacman -Qtdq)"  # Remove orphans

    # Useful pacman aliases
    alias pacmir="sudo pacman -Syy"        # Force refresh package databases
    alias pacup="sudo pacman -Sy"          # Update package databases
    alias pacupg="sudo pacman -Syu"        # Upgrade packages
    alias pacin="sudo pacman -S"           # Install specific package
    alias pacins="sudo pacman -U"          # Install local package
    alias pacre="sudo pacman -R"           # Remove package
    alias pacrem="sudo pacman -Rns"        # Remove package with deps

# commands using su #########
else
    alias pacu="su -c 'pacman -Syu'"
    alias paci="su -c 'pacman -S'"
    alias pacr="su -c 'pacman -R'"
    alias pacrr="su -c 'pacman -Rns'"
    alias pacc="su -c 'pacman -Sc'"
    alias paccc="su -c 'pacman -Scc'"

    alias pacmir="su -c 'pacman -Syy'"
    alias pacup="su -c 'pacman -Sy'"
    alias pacupg="su -c 'pacman -Syu'"
    alias pacin="su -c 'pacman -S'"
    alias pacins="su -c 'pacman -U'"
    alias pacre="su -c 'pacman -R'"
    alias pacrem="su -c 'pacman -Rns'"
fi

# AUR helper aliases (prefer yay, then paru) ################################
if (( $+commands[yay] )); then
    alias yacu="yay -Syu"                  # Update all packages including AUR
    alias yaci="yay -S"                    # Install from official repos and AUR
    alias yacs="yay -Ss"                   # Search in official repos and AUR
    alias yacr="yay -R"                    # Remove packages
    alias yacrr="yay -Rns"                 # Remove packages with dependencies
    alias yacc="yay -Sc"                   # Clean old packages
    alias yaccc="yay -Scc"                 # Clean all packages
elif (( $+commands[paru] )); then
    alias yacu="paru -Syu"
    alias yaci="paru -S"
    alias yacs="paru -Ss"
    alias yacr="paru -R"
    alias yacrr="paru -Rns"
    alias yacc="paru -Sc"
    alias yaccc="paru -Scc"
fi

# Misc. #####################################################################
# List all installed packages
alias paclist='pacman -Qqe'
alias paclistall='pacman -Q'

# List explicitly installed packages
alias pacexp='pacman -Qe'

# List foreign packages (AUR)
alias pacfor='pacman -Qm'

# List native packages (official repos)
alias pacnat='pacman -Qn'

# Show package information
alias pacinfo='pacman -Qi'

# List files installed by a package
alias pacfiles='pacman -Ql'

# Find which package owns a file
alias pacown='pacman -Qo'

# Check for missing dependencies
alias paccheck='pacman -Dk'

# Unlock pacman database
alias pacunlock='sudo rm /var/lib/pacman/db.lck'

# List orphaned packages
alias pacorphans='pacman -Qdt'
