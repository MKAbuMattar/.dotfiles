#!/usr/bin/env zsh

# Do nothing if python3 is not installed
(( ! $+commands[python3] )) && return

# Virtual environment settings
: ${PYTHON_VENV_NAME:=venv}

# Array of possible virtual environment names to look for, in order
# -U for removing duplicates
typeset -gaU PYTHON_VENV_NAMES
[[ -n "$PYTHON_VENV_NAMES" ]] || PYTHON_VENV_NAMES=($PYTHON_VENV_NAME venv .venv)

if [[ "$PYTHON_AUTO_VRUN" == "true" ]]; then
  # Automatically activate venv when changing dir
  function auto_vrun() {
    # deactivate if we're on a different dir than VIRTUAL_ENV states
    # we don't deactivate subdirectories!
    if (( $+functions[deactivate] )) && [[ $PWD != ${VIRTUAL_ENV:h}* ]]; then
      deactivate > /dev/null 2>&1
    fi

    if [[ $PWD != ${VIRTUAL_ENV:h} ]]; then
      local file
      for file in "${^PYTHON_VENV_NAMES[@]}"/bin/activate(N.); do
        # make sure we're not in a venv already
        (( $+functions[deactivate] )) && deactivate > /dev/null 2>&1
        source $file > /dev/null 2>&1
        break
      done
    fi
  }
  add-zsh-hook chpwd auto_vrun
  auto_vrun
fi
