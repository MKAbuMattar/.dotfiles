#!/usr/bin/env zsh

# Do nothing if redis-cli is not installed
(( ! $+commands[redis-cli] )) && return

# Get Redis version
function redis_version() {
  redis-cli --version 2>/dev/null | awk '{print $2}'
}

# Get Redis server info
function redis_info() {
  local section="${1:-server}"
  redis-cli info "$section" 2>/dev/null
}

# Check if Redis is running
function redis_is_running() {
  redis-cli ping &>/dev/null
  return $?
}

# Get Redis memory usage
function redis_memory() {
  redis-cli info memory 2>/dev/null | grep -E "used_memory_human|used_memory_peak_human"
}

# Get Redis connected clients
function redis_clients() {
  redis-cli info clients 2>/dev/null | grep "connected_clients"
}

# Get Redis uptime
function redis_uptime() {
  redis-cli info server 2>/dev/null | grep -E "uptime_in_seconds|uptime_in_days"
}

# Redis prompt info function
function redis_prompt_info() {
  if redis_is_running; then
    local redis_version=$(redis_version)
    echo "${ZSH_THEME_REDIS_PROMPT_PREFIX-[redis:}${redis_version:gs/%/%%}${ZSH_THEME_REDIS_PROMPT_SUFFIX-]}"
  fi
}

# Quick Redis stats
function redis_stats() {
  if redis_is_running; then
    echo "Redis Server Stats:"
    echo "==================="
    redis_version
    redis_uptime
    redis_memory
    redis_clients
    echo ""
    redis-cli dbsize
  else
    echo "Redis server is not running"
    return 1
  fi
}

# Connect to Redis with custom host and port
function redis_connect() {
  local host="${1:-localhost}"
  local port="${2:-6379}"
  local password="${3}"

  if [[ -n "$password" ]]; then
    redis-cli -h "$host" -p "$port" -a "$password"
  else
    redis-cli -h "$host" -p "$port"
  fi
}
