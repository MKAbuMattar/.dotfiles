#!/usr/bin/env zsh

# Aliases ###################################################################

# Some self-explanatory aliases
alias apks="apk search"
alias apkq="apk info"
alias apkl="apk list"
alias apkli="apk list --installed"
alias apkw="cat /etc/apk/world"          # explicitly installed packages

# superuser operations ######################################################
if (( $+commands[sudo] )); then
# commands using sudo #######
    alias apkupd="sudo apk update"           # refresh repos
    alias apku="sudo apk upgrade"            # upgrade all
    alias apkua="sudo apk upgrade --available"
    alias apki="sudo apk add"                # install
    alias apkp="sudo apk del"                # remove
    alias apkpu="sudo apk del --purge"       # remove + configs
    alias apkr="sudo apk fix"                # repair broken installs
    alias apkc="sudo apk cache clean"        # clean cache
    alias apkv="sudo apk verify"             # verify installed pkgs
    alias apkad="sudo apk audit"             # audit changed files

# commands using su #########
else
    alias apkupd="su -lc 'apk update' root"
    alias apku="su -lc 'apk upgrade' root"
    function apki() {
        local args="${(j: :)${(qq)@}}"
        print "su -lc 'apk add $args' root"
        su -lc "apk add $args" root
    }
    function apkp() {
        local args="${(j: :)${(qq)@}}"
        print "su -lc 'apk del $args' root"
        su -lc "apk del $args" root
    }
    alias apkc="su -lc 'apk cache clean' root"
fi

# Misc. #####################################################################
# List explicitly installed packages from the apk "world" file
alias allpkgs='apk info -e'
