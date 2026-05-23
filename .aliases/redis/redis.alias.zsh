#!/usr/bin/env zsh

# Do nothing if redis-cli is not installed
(( ! $+commands[redis-cli] )) && return

# Redis CLI aliases
alias rcli='redis-cli'
alias rclip='redis-cli -p'
alias rclih='redis-cli -h'
alias rclia='redis-cli -a'

# Redis server aliases
alias rserv='redis-server'
alias rservconf='redis-server /etc/redis/redis.conf'

# Common Redis commands via redis-cli
alias rping='redis-cli ping'
alias rinfo='redis-cli info'
alias rkeys='redis-cli keys'
alias rget='redis-cli get'
alias rset='redis-cli set'
alias rdel='redis-cli del'
alias rflush='redis-cli flushall'
alias rflushdb='redis-cli flushdb'
alias rdbsize='redis-cli dbsize'
alias rsave='redis-cli save'
alias rbgsave='redis-cli bgsave'
alias rshutdown='redis-cli shutdown'
alias rmonitor='redis-cli monitor'
alias rclientlist='redis-cli client list'
alias rconfig='redis-cli config'
alias rconfigget='redis-cli config get'
alias rconfigset='redis-cli config set'

# Redis benchmark
alias rbench='redis-benchmark'

# Redis check utilities
alias rcheck='redis-check-aof'
alias rcheckrdb='redis-check-rdb'
