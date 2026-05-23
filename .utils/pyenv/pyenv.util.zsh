#!/usr/bin/env zsh

# Do nothing if pyenv is not installed
(( ! $+commands[pyenv] )) && return

# Install the latest Python version
function pyenv_install_latest() {
  local version="${1:-3}"
  local latest=$(pyenv install --list | grep -E "^\s*${version}\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')

  if [[ -z "$latest" ]]; then
    echo >&2 "Error: No Python ${version}.x.x version found"
    return 1
  fi

  echo "Installing Python ${latest}..."
  pyenv install "$latest"
}

# List installed Python versions (simplified)
function pyenv_list() {
  pyenv versions --bare --skip-aliases
}

# Check if a specific Python version is installed
function pyenv_is_installed() {
  local version="$1"
  if [[ -z "$version" ]]; then
    echo >&2 "Usage: pyenv_is_installed <version>"
    return 1
  fi

  pyenv versions --bare | grep -q "^${version}$"
}

# Get the path to a specific Python version
function pyenv_version_path() {
  local version="${1:-$(pyenv version-name)}"
  echo "$(pyenv root)/versions/${version}"
}

# Show detailed information about current Python environment
function pyenv_info() {
  echo "Pyenv root: ${PYENV_ROOT:-$(pyenv root)}"
  echo "Current version: $(pyenv version)"
  echo "Global version: $(pyenv global)"

  if [[ -f .python-version ]]; then
    echo "Local version: $(pyenv local)"
  fi

  if [[ -n "$PYENV_VIRTUAL_ENV" ]]; then
    echo "Active virtualenv: $PYENV_VIRTUAL_ENV"
  fi
}

# Quickly switch to latest installed version of a major release
function pyenv_use_latest() {
  local major="${1:-3}"
  local latest=$(pyenv versions --bare | grep -E "^${major}\.[0-9]+\.[0-9]+$" | tail -1)

  if [[ -z "$latest" ]]; then
    echo >&2 "Error: No installed Python ${major}.x.x version found"
    return 1
  fi

  echo "Switching to Python ${latest}..."
  pyenv shell "$latest"
}

# Update all pyenv plugins
function pyenv_update() {
  echo "Updating pyenv..."
  cd "${PYENV_ROOT:-$HOME/.pyenv}" || return 1
  git pull

  # Update plugins
  for plugin in plugins/*; do
    if [[ -d "$plugin/.git" ]]; then
      echo "Updating $(basename $plugin)..."
      cd "$plugin" && git pull && cd - > /dev/null
    fi
  done

  cd - > /dev/null
  pyenv rehash
  echo "Update complete!"
}
