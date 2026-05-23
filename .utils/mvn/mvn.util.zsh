#!/usr/bin/env zsh

# Do nothing if mvn is not installed
(( ! $+commands[mvn] )) && return

# Calls mvnw if found in the current project, otherwise execute the original mvn
mvn-or-mvnw() {
  local dir="$PWD"
  while [[ ! -x "$dir/mvnw" && "$dir" != / ]]; do
    dir="${dir:h}"
  done

  if [[ -x "$dir/mvnw" ]]; then
    echo "Running \`$dir/mvnw\`..." >&2
    "$dir/mvnw" "$@"
    return $?
  fi

  command mvn "$@"
}

# Wrapper function for Maven's mvn command. Based on https://gist.github.com/1027800
mvn-color() {
  local BOLD=$(echoti bold)
  local TEXT_RED=$(echoti setaf 1)
  local TEXT_GREEN=$(echoti setaf 2)
  local TEXT_YELLOW=$(echoti setaf 3)
  local TEXT_BLUE=$(echoti setaf 4)
  local TEXT_WHITE=$(echoti setaf 7)
  local RESET_FORMATTING=$(echoti sgr0)

  (
    # Filter mvn output using sed. Before filtering set the locale to C, so invalid characters won't break some sed implementations
    unset LANG
    LC_CTYPE=C mvn "$@" | sed \
      -e "s/\(\[INFO\]\)\(.*\)/${TEXT_BLUE}${BOLD}\1${RESET_FORMATTING}\2/g" \
      -e "s/\(\[DEBUG\]\)\(.*\)/${TEXT_WHITE}${BOLD}\1${RESET_FORMATTING}\2/g" \
      -e "s/\(\[INFO\]\ BUILD SUCCESSFUL\)/${BOLD}${TEXT_GREEN}\1${RESET_FORMATTING}/g" \
      -e "s/\(\[WARNING\]\)\(.*\)/${BOLD}${TEXT_YELLOW}\1${RESET_FORMATTING}\2/g" \
      -e "s/\(\[ERROR\]\)\(.*\)/${BOLD}${TEXT_RED}\1${RESET_FORMATTING}\2/g" \
      -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/${BOLD}${TEXT_GREEN}Tests run: \1${RESET_FORMATTING}, Failures: ${BOLD}${TEXT_RED}\2${RESET_FORMATTING}, Errors: ${BOLD}${TEXT_RED}\3${RESET_FORMATTING}, Skipped: ${BOLD}${TEXT_YELLOW}\4${RESET_FORMATTING}/g"

    # Make sure formatting is reset
    echo -ne "${RESET_FORMATTING}"
  )
}
