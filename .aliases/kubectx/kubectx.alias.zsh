#!/usr/bin/env zsh

(( ! $+commands[kubectx] && ! $+commands[kubens] )) && return

# Aliases ###################################################################
# Short prefixes — keep `kubectx` / `kubens` free for direct use.
alias kx='kubectx'        # switch context, or print current with no args
alias kxc='kubectx -c'    # print current context (silent)
alias kxd='kubectx -d'    # delete a context
alias kxu='kubectx -u'    # unset current context
alias kxp='kubectx -'     # switch to previous context

alias kn='kubens'         # switch namespace
alias knc='kubens -c'     # print current namespace
alias knp='kubens -'      # switch to previous namespace
