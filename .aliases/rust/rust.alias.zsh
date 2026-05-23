#!/usr/bin/env zsh

# Do nothing if cargo is not installed
(( ! $+commands[cargo] )) && return

# Cargo aliases
alias cb='cargo build'
alias cbr='cargo build --release'
alias cc='cargo check'
alias ccl='cargo clean'
alias cclp='cargo clippy'
alias cd='cargo doc'
alias cdo='cargo doc --open'
alias cf='cargo fmt'
alias cfc='cargo fmt --check'
alias ci='cargo install'
alias cin='cargo init'
alias cn='cargo new'
alias cr='cargo run'
alias crr='cargo run --release'
alias ct='cargo test'
alias ctr='cargo test --release'
alias cu='cargo update'
alias cun='cargo uninstall'
alias cw='cargo watch'
alias cwr='cargo watch -x run'
alias cwt='cargo watch -x test'
alias cwc='cargo watch -x check'

# Cargo publish
alias cpp='cargo publish'
alias cppd='cargo publish --dry-run'

# Cargo tree
alias ctre='cargo tree'

# Cargo fix
alias cfix='cargo fix'

# Cargo bench
alias cbe='cargo bench'

# Cargo add/remove (cargo-edit)
alias cad='cargo add'
alias crm='cargo rm'

# Rustup aliases
alias ruc='rustup check'
alias ruu='rustup update'
alias rus='rustup show'
alias rud='rustup default'
alias rut='rustup target'
alias rutl='rustup target list'
alias ruta='rustup target add'
alias rutr='rustup target remove'
alias ruto='rustup toolchain'
alias rutol='rustup toolchain list'
alias rutoi='rustup toolchain install'
alias rutou='rustup toolchain uninstall'
