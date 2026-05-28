#!/usr/bin/env bash
# Switch to the Nth session ordered by creation time, matching the numbering
# shown in the status-bar session list (session-list.sh).
#
# Usage: session-switch.sh <position>

set -u

n="${1:-}"
case "$n" in
    ''|*[!0-9]*) exit 0 ;;
esac

target=$(tmux list-sessions -F '#{session_created}'$'\t''#{session_name}' 2>/dev/null \
    | sort -n | sed -n "${n}p" | cut -f2-)

[ -n "$target" ] || exit 0

tmux switch-client -t "$target"
tmux refresh-client -S
