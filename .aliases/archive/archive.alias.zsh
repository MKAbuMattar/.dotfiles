#!/usr/bin/env zsh

# Aliases ###################################################################
# Short conveniences. The real work is in the `extract` and `compress`
# functions defined in .utils/archive.
alias targz='tar czf'
alias tarbz2='tar cjf'
alias tarxz='tar cJf'
alias tarzst='tar --zstd -cf'
alias untargz='tar xzf'
alias untarbz2='tar xjf'
alias untarxz='tar xJf'
alias untarzst='tar --zstd -xf'
alias tarls='tar tf'                 # list contents of a tarball
