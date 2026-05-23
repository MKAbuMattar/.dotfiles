#!/usr/bin/env zsh

# Node / nvm / pnpm helpers. Skips entirely when there's no Node toolchain.
(( ! $+commands[node] && ! $+functions[nvm] )) && [[ ! -s "$NVM_DIR/nvm.sh" ]] && return

# Functions #################################################################

# Update Node.js to the latest LTS (or the very latest if --current is passed)
# and re-point the `default` nvm alias at it. Reloads nvm first if it's not
# already in this shell.
#
# Usage:
#   update-node             # latest LTS
#   update-node --current   # latest, including non-LTS releases
function update-node() {
    if ! (( $+functions[nvm] )); then
        # nvm isn't loaded in this shell — try to load it
        local nvm_dir="${NVM_DIR:-$HOME/.nvm}"
        if [[ -s "$nvm_dir/nvm.sh" ]]; then
            . "$nvm_dir/nvm.sh"
        else
            echo "update-node: nvm is not installed. See https://github.com/nvm-sh/nvm" >&2
            return 1
        fi
    fi

    local target='--lts'
    if [[ "$1" == "--current" || "$1" == "-c" ]]; then
        target='node'
    fi

    nvm install "$target" --reinstall-packages-from=current --latest-npm
    nvm alias default "$target"
    echo "✓ default node → $(nvm version "$target")"
}

# List installed Node versions plus which one is "default" and "current"
function node-versions() {
    if ! (( $+functions[nvm] )); then
        echo "nvm is not loaded; install or source it first." >&2
        return 1
    fi
    nvm ls
}

# Install pnpm globally via npm. Handy on fresh nvm installs.
# Usage: install-pnpm  [version]   (defaults to @latest)
function install-pnpm() {
    if ! (( $+commands[npm] )); then
        echo "install-pnpm: npm is required (install Node first)" >&2
        return 1
    fi
    local target="${1:-latest}"
    npm install -g "pnpm@${target}" \
        && echo "✓ pnpm $(pnpm --version) installed → $(command -v pnpm)"
}

# Install yarn globally (classic v1; for berry use corepack)
function install-yarn() {
    if ! (( $+commands[npm] )); then
        echo "install-yarn: npm is required" >&2
        return 1
    fi
    npm install -g yarn \
        && echo "✓ yarn $(yarn --version) installed → $(command -v yarn)"
}

# Show outdated globally-installed npm packages
function npm-outdated-global() {
    if ! (( $+commands[npm] )); then
        echo "npm is not installed" >&2
        return 1
    fi
    npm outdated -g --depth=0
}

# Upgrade every globally-installed npm package to its latest version
function npm-upgrade-global() {
    if ! (( $+commands[npm] )); then
        echo "npm is not installed" >&2
        return 1
    fi
    npm update -g
}

# Clean up nvm: remove every installed Node version except the default
function nvm-prune() {
    if ! (( $+functions[nvm] )); then
        echo "nvm is not loaded" >&2
        return 1
    fi
    local default_version
    default_version=$(nvm version default 2>/dev/null)
    if [[ -z "$default_version" || "$default_version" == "N/A" ]]; then
        echo "No default nvm alias set; aborting to avoid removing the wrong version."
        return 1
    fi
    echo "Keeping default: $default_version"
    local v
    for v in $(nvm ls --no-colors | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+'); do
        if [[ "$v" != "$default_version" ]]; then
            echo "Uninstalling $v"
            nvm uninstall "$v"
        fi
    done
}
