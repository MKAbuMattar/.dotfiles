#!/usr/bin/env zsh

# Functions #################################################################

# Show public IPv4 + IPv6, ASN, country, city in one block
function netinfo() {
    if (( $+commands[curl] )); then
        echo "── Public IPv4 ──"; curl -s4 https://ifconfig.me; echo
        echo "── Public IPv6 ──"; curl -s6 https://ifconfig.me; echo
        if (( $+commands[jq] )); then
            echo "── Geo ─────────"
            curl -s https://ipinfo.io 2>/dev/null \
                | jq -r '"ip:      \(.ip)\nhostname:\(.hostname // "-")\ncity:    \(.city)\nregion:  \(.region)\ncountry: \(.country)\nasn:     \(.org)"'
        fi
    else
        echo "curl is required for netinfo."
        return 1
    fi
}

# Check if a TCP port is open on a host. Uses /dev/tcp (bash/zsh builtin).
# Usage: portcheck <host> <port> [timeout=2]
function portcheck() {
    local host="$1" port="$2" timeout="${3:-2}"
    if [[ -z "$host" || -z "$port" ]]; then
        echo "Usage: portcheck <host> <port> [timeout=2]"
        return 1
    fi
    if (( $+commands[timeout] )); then
        timeout "$timeout" zsh -c "echo > /dev/tcp/$host/$port" 2>/dev/null
    else
        zsh -c "echo > /dev/tcp/$host/$port" 2>/dev/null
    fi
    if [[ $? -eq 0 ]]; then
        echo "✓ $host:$port is open"
    else
        echo "✗ $host:$port is closed or filtered"
        return 1
    fi
}

# Scan a CIDR for live hosts using parallel ping. Light-weight, no nmap needed.
# Usage: lanscan 192.168.1.0/24
function lanscan() {
    if [[ -z "$1" ]]; then
        echo "Usage: lanscan <CIDR>  (e.g. 192.168.1.0/24)"
        return 1
    fi
    if ! (( $+commands[nmap] )); then
        echo "Install nmap for a full scan; falling back to ping sweep."
        local base="${1%.*/*}"
        for i in {1..254}; do
            ( ping -c1 -W1 "${base}.$i" >/dev/null 2>&1 && echo "${base}.$i" ) &
        done
        wait
    else
        nmap -sn "$1" | awk '/Nmap scan report/ {print $NF}'
    fi
}

# Pretty-print HTTP response timings for a URL
function http-time() {
    if [[ -z "$1" ]]; then
        echo "Usage: http-time <url>"
        return 1
    fi
    curl -s -o /dev/null -w \
        "dns_lookup:    %{time_namelookup}s\nconnect:       %{time_connect}s\ntls_handshake: %{time_appconnect}s\nfirst_byte:    %{time_starttransfer}s\ntotal:         %{time_total}s\nhttp_code:     %{http_code}\n" \
        "$1"
}

# Tail an IP for live geo / traceroute breakdown
# Usage: iplookup <ip>
function iplookup() {
    if [[ -z "$1" ]]; then
        echo "Usage: iplookup <ip-or-domain>"
        return 1
    fi
    if (( $+commands[curl] )); then
        curl -s "https://ipinfo.io/$1"
        echo
    fi
}

# List local interface MACs + IPs in a clean table
function ifs() {
    ip -brief addr show \
        | awk '$1!="lo" {printf "%-15s %-10s %s\n", $1, $2, $3}'
}
