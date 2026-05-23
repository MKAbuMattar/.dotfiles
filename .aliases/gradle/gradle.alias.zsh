#!/usr/bin/env zsh

# Do nothing if gradle is not installed
(( ! $+commands[gradle] )) && return

# Gradle Wrapper aliases
alias gw='./gradlew'
alias gwb='./gradlew build'
alias gwc='./gradlew clean'
alias gwcb='./gradlew clean build'
alias gwt='./gradlew test'
alias gwbt='./gradlew build test'
alias gwct='./gradlew clean test'
alias gwcbt='./gradlew clean build test'
alias gwr='./gradlew run'
alias gwi='./gradlew init'
alias gwp='./gradlew publish'
alias gwd='./gradlew dependencies'
alias gwu='./gradlew --refresh-dependencies'
alias gwup='./gradlew dependencies --update-locks'

# Gradle aliases
alias gradle-init='gradle init'
alias gradle-build='gradle build'
alias gradle-clean='gradle clean'
alias gradle-test='gradle test'
alias gradle-run='gradle run'
alias gradle-dependencies='gradle dependencies'
alias gradle-tasks='gradle tasks'
alias gradle-projects='gradle projects'

# Common task aliases
alias gwas='./gradlew assemble'
alias gwch='./gradlew check'
alias gwjar='./gradlew jar'
alias gwwar='./gradlew war'
alias gwboot='./gradlew bootRun'
alias gwbootjar='./gradlew bootJar'
alias gwinstall='./gradlew install'
alias gwpub='./gradlew publish'

# Multi-module project helpers
alias gwba='./gradlew build --parallel'
alias gwta='./gradlew test --parallel'
alias gwca='./gradlew clean --parallel'

# Daemon management
alias gwstop='./gradlew --stop'
alias gwstatus='./gradlew --status'

# Help and info
alias gwhelp='./gradlew help'
alias gwtasks='./gradlew tasks'
alias gwprops='./gradlew properties'
alias gwprojects='./gradlew projects'

# Verbose and debug
alias gwv='./gradlew --console=verbose'
alias gwdebug='./gradlew --debug'
alias gwinfo='./gradlew --info'

# Offline mode
alias gwo='./gradlew --offline'

# Continue on failure
alias gwcont='./gradlew --continue'

# No daemon
alias gwnd='./gradlew --no-daemon'
