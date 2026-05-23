# redis-aliases

## NAME

**redis-aliases** — short aliases for the Redis CLI, server, benchmark, and check utilities.

## SYNOPSIS

```text
# Enable by adding to the ALIASES array in ~/.zshrc:
ALIASES=(... "redis" ...)
```

## DESCRIPTION

Provides short `r*` aliases for `redis-cli`, `redis-server`, `redis-benchmark`, and the `redis-check-aof` / `redis-check-rdb` utilities, plus convenient shortcuts for the most-used CLI commands (`PING`, `INFO`, `KEYS`, `GET`/`SET`/`DEL`, `FLUSHALL`/`FLUSHDB`, `MONITOR`, etc.). The module is gated by `(( ! $+commands[redis-cli] )) && return`, so it loads only when `redis-cli` is on `$PATH`.

## ALIASES

### CLI

| Alias   | Expansion      | Description                  |
| ------- | -------------- | ---------------------------- |
| `rcli`  | `redis-cli`    | Run redis-cli                |
| `rclip` | `redis-cli -p` | redis-cli with port flag     |
| `rclih` | `redis-cli -h` | redis-cli with host flag     |
| `rclia` | `redis-cli -a` | redis-cli with auth password |

### Server

| Alias       | Expansion                            | Description                             |
| ----------- | ------------------------------------ | --------------------------------------- |
| `rserv`     | `redis-server`                       | Run redis-server                        |
| `rservconf` | `redis-server /etc/redis/redis.conf` | Run with the default Debian config path |

### Common Commands

| Alias         | Expansion               | Description                                                |
| ------------- | ----------------------- | ---------------------------------------------------------- |
| `rping`       | `redis-cli ping`        | Ping the server                                            |
| `rinfo`       | `redis-cli info`        | Server info                                                |
| `rkeys`       | `redis-cli keys`        | List keys matching a pattern (use sparingly in production) |
| `rget`        | `redis-cli get`         | GET a key                                                  |
| `rset`        | `redis-cli set`         | SET a key                                                  |
| `rdel`        | `redis-cli del`         | DEL a key                                                  |
| `rflush`      | `redis-cli flushall`    | FLUSHALL (drop all databases)                              |
| `rflushdb`    | `redis-cli flushdb`     | FLUSHDB (drop current database)                            |
| `rdbsize`     | `redis-cli dbsize`      | Number of keys in the current db                           |
| `rsave`       | `redis-cli save`        | Synchronous save                                           |
| `rbgsave`     | `redis-cli bgsave`      | Background save                                            |
| `rshutdown`   | `redis-cli shutdown`    | Shut the server down                                       |
| `rmonitor`    | `redis-cli monitor`     | Stream every command in real time                          |
| `rclientlist` | `redis-cli client list` | List connected clients                                     |

### Configuration

| Alias        | Expansion              | Description             |
| ------------ | ---------------------- | ----------------------- |
| `rconfig`    | `redis-cli config`     | CONFIG subcommand entry |
| `rconfigget` | `redis-cli config get` | CONFIG GET              |
| `rconfigset` | `redis-cli config set` | CONFIG SET              |

### Benchmark / Check

| Alias       | Expansion         | Description                |
| ----------- | ----------------- | -------------------------- |
| `rbench`    | `redis-benchmark` | Run the benchmark utility  |
| `rcheck`    | `redis-check-aof` | Check / repair an AOF file |
| `rcheckrdb` | `redis-check-rdb` | Check an RDB file          |

## REQUIREMENTS

- `redis-cli` installed and on `$PATH`.
- For the corresponding aliases: `redis-server`, `redis-benchmark`, `redis-check-aof`, and `redis-check-rdb`.

## EXAMPLES

```bash
# Quick connectivity check
rping

# Connect to a remote instance with auth
rclih cache.example.com -p 6380 -a "$REDIS_PASS"

# Snapshot the database
rbgsave

# Watch all commands for debugging
rmonitor
```

## SEE ALSO

- [.docs/README.md](../README.md)
