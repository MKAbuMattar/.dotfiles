#!/usr/bin/env zsh

# Do nothing if poetry is not installed
(( ! $+commands[poetry] )) && return

# Get the current project name from pyproject.toml
function poetry_project_name() {
  if [[ ! -f pyproject.toml ]]; then
    return 1
  fi
  grep -E "^name\s*=" pyproject.toml | sed -E 's/name\s*=\s*"(.+)"/\1/' | head -1
}

# Get the current project version from pyproject.toml
function poetry_project_version() {
  if [[ ! -f pyproject.toml ]]; then
    return 1
  fi
  grep -E "^version\s*=" pyproject.toml | sed -E 's/version\s*=\s*"(.+)"/\1/' | head -1
}

# Show poetry project info
function poetry_info() {
  if [[ ! -f pyproject.toml ]]; then
    echo >&2 "Error: Not in a poetry project directory"
    return 1
  fi

  echo "Project: $(poetry_project_name)"
  echo "Version: $(poetry_project_version)"
  echo "Poetry version: $(poetry --version | cut -d' ' -f3)"

  if poetry env info --path &>/dev/null; then
    echo "Virtual environment: $(poetry env info --path)"
    echo "Python version: $(poetry env info -p | xargs -I {} {}/bin/python --version 2>&1 | cut -d' ' -f2)"
  else
    echo "Virtual environment: Not created"
  fi
}

# Export requirements with extras
function poetry_export_all() {
  local output="${1:-requirements.txt}"
  echo "Exporting all dependencies to ${output}..."
  poetry export --without-hashes --with dev --with test --with docs > "$output"
}

# Export dev requirements
function poetry_export_dev() {
  local output="${1:-requirements-dev.txt}"
  echo "Exporting dev dependencies to ${output}..."
  poetry export --without-hashes --only dev > "$output"
}

# Add a dependency and update lock file
function poetry_add_lock() {
  poetry add "$@" && poetry lock --no-update
}

# Update a specific package
function poetry_update_package() {
  if [[ -z "$1" ]]; then
    echo >&2 "Usage: poetry_update_package <package>"
    return 1
  fi
  poetry update "$1"
}

# Show outdated packages
function poetry_outdated() {
  poetry show --outdated
}

# Create new poetry project with common structure
function poetry_new_project() {
  local name="$1"
  if [[ -z "$name" ]]; then
    echo >&2 "Usage: poetry_new_project <project-name>"
    return 1
  fi

  poetry new "$name" && cd "$name"

  # Create common directories
  mkdir -p tests docs

  echo "Created poetry project: $name"
  echo "Run 'poetry install' to set up the virtual environment"
}

# Bump version (patch, minor, or major)
function poetry_bump() {
  local level="${1:-patch}"

  if [[ ! "$level" =~ ^(patch|minor|major)$ ]]; then
    echo >&2 "Usage: poetry_bump [patch|minor|major]"
    return 1
  fi

  poetry version "$level"
  echo "Version bumped to: $(poetry_project_version)"
}

# Run pytest with poetry
function poetry_test() {
  poetry run pytest "$@"
}

# Run python with poetry environment
function poetry_python() {
  poetry run python "$@"
}

# Show poetry prompt info for themes
function poetry_prompt_info() {
  if [[ -f pyproject.toml ]] && (( $+commands[poetry] )); then
    local name=$(poetry_project_name)
    local version=$(poetry_project_version)
    echo "${ZSH_THEME_POETRY_PREFIX=}${name}:${version}${ZSH_THEME_POETRY_SUFFIX=}"
  fi
}
