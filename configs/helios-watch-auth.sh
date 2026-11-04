#!/usr/bin/bash
set -euo pipefail

readonly TAG=helios-watch-auth
readonly LOCK=/run/helios-watch-auth.lock
readonly STATE=/var/lib/helios/blocked.txt
readonly IPSET=helios-blacklist
readonly THRESHOLD=5
readonly WINDOW='10 min ago'
readonly WHITELIST=(192.168.56.1 192.168.56.10)

log() { logger -t "$TAG" -p "auth.$1" -- "$2"; }

exec 9>"$LOCK"
if ! flock -n 9; then
    log warning "instance deja en cours, sortie"
    exit 2
fi

mkdir -p "$(dirname "$STATE")"
touch "$STATE"

journalctl -u sshd --since "$WINDOW" -o cat --no-pager \
  | grep -E 'Failed password|Invalid user|authentication failure' \
  | grep -oE 'from [0-9]+(\.[0-9]+){3}' \
  | awk '{print $2}' \
  | sort | uniq -c \
  | while read -r count ip; do
        for w in "${WHITELIST[@]}"; do
            [[ "$ip" == "$w" ]] && continue 2
        done
        (( count > THRESHOLD )) || continue
        if grep -qx "$ip" "$STATE"; then
            continue
        fi
        firewall-cmd --ipset="$IPSET" --add-entry="$ip" >/dev/null
        echo "$ip" >> "$STATE"
        log crit "adresse $ip bloquee ($count echecs en 10 min)"
    done

log info "passage termine"
exit 0
