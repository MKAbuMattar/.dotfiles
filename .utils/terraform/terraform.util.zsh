#!/usr/bin/env zsh

# Do nothing if terraform is not installed
(( ! $+commands[terraform] )) && return

function tf_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" != ~ ]] || return
  # check if in terraform dir and file exists
  [[ -d "${TF_DATA_DIR:-.terraform}" && -r "${TF_DATA_DIR:-.terraform}/environment" ]] || return

  local workspace="$(< "${TF_DATA_DIR:-.terraform}/environment")"
  echo "${ZSH_THEME_TF_PROMPT_PREFIX-[}${workspace:gs/%/%%}${ZSH_THEME_TF_PROMPT_SUFFIX-]}"
}

function tf_version_prompt_info() {
    local terraform_version
    terraform_version=$(terraform --version | head -n 1 | cut -d ' ' -f 2)
    echo "${ZSH_THEME_TF_VERSION_PROMPT_PREFIX-[}${terraform_version:gs/%/%%}${ZSH_THEME_TF_VERSION_PROMPT_SUFFIX-]}"
}
