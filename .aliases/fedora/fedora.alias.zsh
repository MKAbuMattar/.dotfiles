#!/usr/bin/env zsh

# Aliases ###################################################################

# Some self-explanatory aliases
alias dnfs="dnf search"
alias dnfq="dnf info"
alias dnfg="dnf grouplist"
alias dnfl="dnf list"
alias dnfli="dnf list installed"

# superuser operations ######################################################
if (( $+commands[sudo] )); then
# commands using sudo #######
    alias dnfc="sudo dnf clean all"
    alias dnfu="sudo dnf upgrade"
    alias dnfuy="sudo dnf upgrade -y"
    alias dnfi="sudo dnf install"
    alias dnfiy="sudo dnf install -y"
    alias dnfp="sudo dnf remove"
    alias dnfpy="sudo dnf remove -y"
    alias dnfar="sudo dnf autoremove"
    alias dnfd="sudo dnf downgrade"
    alias dnfr="sudo dnf reinstall"
    alias dnfh="sudo dnf history"
    alias dnfgi="sudo dnf groupinstall"
    alias dnfgu="sudo dnf groupupdate"
    alias dnfgp="sudo dnf groupremove"

    # Install all .rpm files in the current directory.
    alias dia="sudo rpm -i ./*.rpm"
    alias di="sudo rpm -i"

# commands using su #########
else
    alias dnfc="su -lc 'dnf clean all' root"
    alias dnfu="su -lc 'dnf upgrade' root"
    alias dnfuy="su -lc 'dnf upgrade -y' root"
    function dnfi() {
        local args="${(j: :)${(qq)@}}"
        print "su -lc 'dnf install $args' root"
        su -lc "dnf install $args" root
    }
    function dnfp() {
        local args="${(j: :)${(qq)@}}"
        print "su -lc 'dnf remove $args' root"
        su -lc "dnf remove $args" root
    }
    function dnfar() {
        local args="${(j: :)${(qq)@}}"
        print "su -lc 'dnf autoremove $args' root"
        su -lc "dnf autoremove $args" root
    }

    alias dia="su -lc 'rpm -i ./*.rpm' root"
    alias di="su -lc 'rpm -i' root"
fi

# Misc. #####################################################################
# Print all installed packages
alias allpkgs='rpm -qa'
