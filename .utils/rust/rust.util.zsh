#!/usr/bin/env zsh

# Do nothing if rustup and cargo are not installed
if ! (( $+commands[rustup] && $+commands[cargo] )); then
  return
fi

# Get the current Rust version
function rust_version() {
  rustc --version 2>/dev/null | awk '{print $2}'
}

# Get the current Rust toolchain
function rust_toolchain() {
  rustup show active-toolchain 2>/dev/null | awk '{print $1}'
}

# Rust prompt info function
function rust_prompt_info() {
  local rust_version=$(rust_version)
  if [[ -n "$rust_version" ]]; then
    echo "${ZSH_THEME_RUST_PROMPT_PREFIX-[}${rust_version:gs/%/%%}${ZSH_THEME_RUST_PROMPT_SUFFIX-]}"
  fi
}

# Check if Cargo.toml exists in current directory or parent directories
function is_rust_project() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/Cargo.toml" ]]; then
      return 0
    fi
    dir="${dir:h}"
  done
  return 1
}

# Get the Rust project root directory
function rust_project_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/Cargo.toml" ]]; then
      echo "$dir"
      return 0
    fi
    dir="${dir:h}"
  done
  return 1
}
