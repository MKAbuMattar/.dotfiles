#!/usr/bin/env zsh

# Aliases ###################################################################
# These work regardless of distro; util functions in .utils/network do the
# heavier interactive work.

# IP info
alias myip='curl -s4 https://ifconfig.me 2>/dev/null && echo'
alias myip6='curl -s6 https://ifconfig.me 2>/dev/null && echo'
alias localip="ip -4 -brief addr show | awk '\$1!=\"lo\" {print \$1, \$3}'"

# Listening ports (Linux ss; falls back to lsof)
if (( $+commands[ss] )); then
    alias ports='ss -tulpnH'
    alias ports4='ss -tulpnH -4'
    alias ports6='ss -tulpnH -6'
else
    alias ports='lsof -i -P -n | grep LISTEN'
fi

# Quick DNS lookup helpers
alias dnsa='dig +short A'
alias dnsaaaa='dig +short AAAA'
alias dnsmx='dig +short MX'
alias dnstxt='dig +short TXT'
alias dnsns='dig +short NS'
alias dnsr='dig +short -x'              # reverse: dnsr 1.2.3.4

# Latency / reachability
alias png='ping -c 4'
alias pngf='ping'

# HTTP probing (prefers curl)
alias hget='curl -sSL'
alias hhead='curl -sSI'
alias hcode='curl -s -o /dev/null -w "%{http_code}\n"'
alias htime='curl -s -o /dev/null -w "dns=%{time_namelookup}s connect=%{time_connect}s tls=%{time_appconnect}s ttfb=%{time_starttransfer}s total=%{time_total}s\n"'

# Active connections summary
alias conns='ss -tan | awk "NR>1 {print \$1}" | sort | uniq -c | sort -rn'
