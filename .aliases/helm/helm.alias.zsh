#!/usr/bin/env zsh

# Do nothing if helm is not installed
(( ! $+commands[helm] )) && return

# General aliases
alias h='helm'
alias hv='helm version'
alias hh='helm help'

# Repository management
alias hr='helm repo'
alias hra='helm repo add'
alias hrr='helm repo remove'
alias hrl='helm repo list'
alias hru='helm repo update'
alias hri='helm repo index'

# Chart management
alias hc='helm create'
alias hpkg='helm package'
alias hlint='helm lint'
alias hshow='helm show'
alias hshowa='helm show all'
alias hshowc='helm show chart'
alias hshowv='helm show values'
alias hshowcrd='helm show crds'

# Release management
alias hi='helm install'
alias hup='helm upgrade'
alias hui='helm upgrade --install'
alias huir='helm upgrade --install --reuse-values'
alias hun='helm uninstall'
alias hdel='helm uninstall'
alias hls='helm list'
alias hlsa='helm list --all'
alias hlsan='helm list --all-namespaces'
alias hget='helm get'
alias hgeta='helm get all'
alias hgetv='helm get values'
alias hgetm='helm get manifest'
alias hgeth='helm get hooks'
alias hgetn='helm get notes'

# Status and history
alias hst='helm status'
alias hhist='helm history'
alias hroll='helm rollback'

# Testing and debugging
alias htest='helm test'
alias hdry='helm install --dry-run --debug'
alias htemp='helm template'
alias htempdebug='helm template --debug'

# Dependency management
alias hdep='helm dependency'
alias hdepu='helm dependency update'
alias hdepb='helm dependency build'
alias hdepl='helm dependency list'

# Search
alias hsearch='helm search'
alias hsearchr='helm search repo'
alias hsearchh='helm search hub'

# Plugin management
alias hpl='helm plugin'
alias hpli='helm plugin install'
alias hpll='helm plugin list'
alias hplu='helm plugin update'
alias hplun='helm plugin uninstall'

# Environment and config
alias henv='helm env'

# Pull and download
alias hpull='helm pull'
alias hfetch='helm pull'

# Verify
alias hverify='helm verify'

# Common workflows
alias hia='helm install --atomic'
alias huia='helm upgrade --install --atomic'
alias huiaf='helm upgrade --install --atomic --force'
alias hwatch='watch helm list'
