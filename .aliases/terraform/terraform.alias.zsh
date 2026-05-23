#!/usr/bin/env zsh

# Do nothing if terraform is not installed
(( ! $+commands[terraform] )) && return

alias tf='terraform'
alias tfa='terraform apply'
alias tfa!='terraform apply -auto-approve'
alias tfap='terraform apply -parallelism=1'
alias tfc='terraform console'
alias tfd='terraform destroy'
alias tfd!='terraform destroy -auto-approve'
alias tfdp='terraform destroy -parallelism=1'
alias tff='terraform fmt'
alias tffr='terraform fmt -recursive'
alias tfi='terraform init'
alias tfir='terraform init -reconfigure'
alias tfiu='terraform init -upgrade'
alias tfiur='terraform init -upgrade -reconfigure'
alias tfo='terraform output'
alias tfp='terraform plan'
alias tfv='terraform validate'
alias tfs='terraform state'
alias tft='terraform test'
alias tfsh='terraform show'
alias tfw='terraform workspace'
alias tfwl='terraform workspace list'
alias tfws='terraform workspace select'
