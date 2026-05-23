#!/usr/bin/env zsh

# Do nothing if pnpm is not installed
(( ! $+commands[pnpm] )) && return

# Installation
alias pna='pnpm add'
alias pnad='pnpm add --save-dev'
alias pnap='pnpm add --save-peer'
alias pnrm='pnpm remove'

# Scripts
alias pnr='pnpm run'
alias pnst='pnpm start'
alias pnt='pnpm test'
alias pnb='pnpm build'
alias pnd='pnpm dev'

# Install
alias pni='pnpm install'
alias pnif='pnpm install --frozen-lockfile'
alias pnup='pnpm update'
alias pnupi='pnpm update --interactive'
alias pnupl='pnpm update --latest'

# List
alias pnls='pnpm list'
alias pnlsg='pnpm list --global'
alias pnlsd='pnpm list --depth'

# Global
alias pnga='pnpm add --global'
alias pngrm='pnpm remove --global'
alias pngls='pnpm list --global'
alias pngup='pnpm update --global'

# Misc
alias pnin='pnpm init'
alias pnln='pnpm link'
alias pnuln='pnpm unlink'
alias pnout='pnpm outdated'
alias pnwhy='pnpm why'
alias pnex='pnpm exec'
alias pndlx='pnpm dlx'
alias pnpub='pnpm publish'

# Workspace
alias pnwr='pnpm --filter'
alias pnwi='pnpm install --recursive'
alias pnwup='pnpm update --recursive'

# Cache
alias pnsc='pnpm store status'
alias pnsp='pnpm store prune'
alias pnspath='pnpm store path'

# Patch
alias pnpatch='pnpm patch'
alias pnpatchc='pnpm patch-commit'
