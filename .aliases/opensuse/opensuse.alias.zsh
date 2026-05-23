#!/usr/bin/env zsh

# Aliases ###################################################################

# Some self-explanatory aliases
alias zys="zypper search"
alias zyq="zypper info"
alias zyl="zypper packages"
alias zyli="zypper packages --installed-only"
alias zypl="zypper patterns"
alias zysrv="zypper services"
alias zyrep="zypper repos"

# superuser operations ######################################################
if (( $+commands[sudo] )); then
# commands using sudo #######
    alias zyc="sudo zypper clean -a"
    alias zyr="sudo zypper refresh"
    alias zyu="sudo zypper update"
    alias zyuy="sudo zypper update -y"
    alias zyup="sudo zypper dist-upgrade"
    alias zyupy="sudo zypper dist-upgrade -y"
    alias zyi="sudo zypper install"
    alias zyiy="sudo zypper install -y"
    alias zyp="sudo zypper remove"
    alias zypy="sudo zypper remove -y"
    alias zyar="sudo zypper packages --orphaned"
    alias zyptni="sudo zypper install -t pattern"
    alias zyptnp="sudo zypper remove -t pattern"
    alias zyh="zypper history"
    alias zyps="sudo zypper ps -s"

    # Install all .rpm files in the current directory.
    alias dia="sudo rpm -i ./*.rpm"
    alias di="sudo rpm -i"

# commands using su #########
else
    alias zyc="su -lc 'zypper clean -a' root"
    alias zyr="su -lc 'zypper refresh' root"
    alias zyu="su -lc 'zypper update' root"
    alias zyuy="su -lc 'zypper update -y' root"
    alias zyup="su -lc 'zypper dist-upgrade' root"
    function zyi() {
        local args="${(j: :)${(qq)@}}"
        print "su -lc 'zypper install $args' root"
        su -lc "zypper install $args" root
    }
    function zyp() {
        local args="${(j: :)${(qq)@}}"
        print "su -lc 'zypper remove $args' root"
        su -lc "zypper remove $args" root
    }
    alias dia="su -lc 'rpm -i ./*.rpm' root"
    alias di="su -lc 'rpm -i' root"
fi

# Misc. #####################################################################
# Print all installed packages
alias allpkgs='rpm -qa'
