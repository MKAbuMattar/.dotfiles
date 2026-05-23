#!/usr/bin/env zsh

# Do nothing if gcloud is not installed
(( ! $+commands[gcloud] )) && return

# Set cache directory if not already set
: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

# Create cache and completions directories if they don't exist
mkdir -p "$ZSH_CACHE_DIR/completions"

# Add completions directory to fpath if not already there
if [[ ! "${fpath[@]}" =~ "$ZSH_CACHE_DIR/completions" ]]; then
  fpath=("$ZSH_CACHE_DIR/completions" $fpath)
fi

# Function to find gcloud installation
_gcloud-sdk-location() {
  # Locations to check for gcloud SDK
  local gcloud_sdk_locations=(
    "$HOME/google-cloud-sdk"
    "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
    "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
    "/usr/share/google-cloud-sdk"
    "/snap/google-cloud-sdk/current"
    "/usr/lib/google-cloud-sdk"
    "/opt/google-cloud-sdk"
  )

  for gcloud_sdk_location in $gcloud_sdk_locations; do
    if [[ -d "$gcloud_sdk_location" ]]; then
      echo "$gcloud_sdk_location"
      return 0
    fi
  done

  return 1
}

# Try to source gcloud completion if SDK is installed
GCLOUD_SDK_LOCATION=$(_gcloud-sdk-location)

if [[ -n "$GCLOUD_SDK_LOCATION" ]]; then
  # Source completion file if it exists
  if [[ -f "$GCLOUD_SDK_LOCATION/completion.zsh.inc" ]]; then
    source "$GCLOUD_SDK_LOCATION/completion.zsh.inc"
  fi
  
  # Source path file if it exists
  if [[ -f "$GCLOUD_SDK_LOCATION/path.zsh.inc" ]]; then
    source "$GCLOUD_SDK_LOCATION/path.zsh.inc"
  fi
fi

unset GCLOUD_SDK_LOCATION
