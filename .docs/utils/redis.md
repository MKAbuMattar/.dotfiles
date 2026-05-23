# redis-utils

## NAME

**redis-utils** — Diagnostic helpers around `redis-cli`.

## SYNOPSIS

```text
# Enable by adding to the UTILS array in ~/.zshrc:
UTILS=(... "redis" ...)
```

## DESCRIPTION

Returns silently when `redis-cli` is not on PATH. Provides quick-access functions for Redis version, server info sections, ping checks, memory and client counts, uptime, an aggregated stats line, a prompt fragment, and a parameterized `redis-cli` connector that accepts optional host/port/password.

## FUNCTIONS

### `redis_version`

Echoes the redis-cli version.

**Behavior:**

Runs `redis-cli --version` and extracts the second whitespace-separated field with `awk '{print $2}'`. Silent if `redis-cli` errors.

### `redis_info [section]`

Prints a Redis `INFO` section.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Section name. Defaults to `server`. |

**Behavior:**

Runs `redis-cli info "$section"`. Standard sections include `server`, `clients`, `memory`, `persistence`, `stats`, `replication`, `cpu`, `commandstats`, `keyspace`.

**Example:**

```bash
redis_info memory
redis_info keyspace
```

### `redis_is_running`

Returns 0 if a Redis server responds to `PING`.

**Behavior:**

Runs `redis-cli ping &>/dev/null` and propagates its exit status.

### `redis_memory`

Prints human-readable memory usage.

**Behavior:**

`redis-cli info memory | grep -E "used_memory_human|used_memory_peak_human"`.

### `redis_clients`

Prints the `connected_clients` line from `redis-cli info clients`.

### `redis_uptime`

Prints uptime in seconds and days from the `server` section.

**Behavior:**

`redis-cli info server | grep -E "uptime_in_seconds|uptime_in_days"`.

### `redis_prompt_info`

Prompt fragment showing the Redis version.

**Behavior:**

If `redis_is_running` returns 0, echoes `${ZSH_THEME_REDIS_PROMPT_PREFIX-[redis:}<version>${ZSH_THEME_REDIS_PROMPT_SUFFIX-]}`. Percent-escapes the version with `:gs/%/%%`.

### `redis_stats`

Aggregated server stats.

**Behavior:**

If Redis is not running, prints `Redis server is not running` and returns 1. Otherwise prints a header, then `redis_version`, `redis_uptime`, `redis_memory`, `redis_clients`, and finally `redis-cli dbsize`.

**Example:**

```bash
redis_stats
```

### `redis_connect [host] [port] [password]`

Opens an interactive `redis-cli` session.

**Arguments:**

| Arg | Required | Description |
| --- | -------- | ----------- |
| `$1` | No | Host. Defaults to `localhost`. |
| `$2` | No | Port. Defaults to `6379`. |
| `$3` | No | Password. When non-empty, passed via `-a`. |

**Behavior:**

Runs `redis-cli -h "$host" -p "$port"` (adding `-a "$password"` if given). Note: passing the password as a command-line argument is visible to other users via `ps`; prefer the `REDISCLI_AUTH` environment variable in production.

**Example:**

```bash
redis_connect cache.internal 6380
```

## REQUIREMENTS

- `redis-cli` (module no-ops otherwise).
- A reachable Redis server for any function that talks to one.

## EXAMPLES

```bash
# Quick health check
redis_is_running && redis_stats

# Add the prompt fragment to a theme
RPROMPT='$(redis_prompt_info)'
```

## SEE ALSO

- [.docs/aliases/redis](../aliases/redis.md)
- [.docs/plugins/zsh/redis](../plugins/zsh/redis.md)
- [.docs/README.md](../README.md)
