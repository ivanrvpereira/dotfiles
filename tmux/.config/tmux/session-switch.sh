#!/usr/bin/env bash
# Switch to a session (and optionally a specific window) from a status-bar
# click or a numbered key binding, matching the layout drawn by
# session-list.sh.
#
# Input forms:
#   <pos>            switch to the Nth session (1-based, creation order)
#   <pos>:<winidx>   switch to that session AND select window index <winidx>
#
# All targets are resolved explicitly (session name + window index) — we never
# use tmux's "=" mouse target, which segfaults the server when a click lands
# outside a real window range.
#
# Usage: session-switch.sh <pos[:winidx]>

set -u

arg="${1:-}"
sess_pos="${arg%%:*}"
win_idx=""
case "$arg" in
    *:*) win_idx="${arg#*:}" ;;
esac

# Session position must be numeric; bail quietly on empty/garbage clicks.
case "$sess_pos" in
    ''|*[!0-9]*) exit 0 ;;
esac

target=$(tmux list-sessions -F '#{session_created}'$'\t''#{session_name}' 2>/dev/null \
    | sort -n | sed -n "${sess_pos}p" | cut -f2-)

[ -n "$target" ] || exit 0

tmux switch-client -t "$target"

# Optional window selection (explicit "session:index" target — no mouse "=").
case "$win_idx" in
    ''|*[!0-9]*) : ;;
    *) tmux select-window -t "${target}:${win_idx}" 2>/dev/null ;;
esac

tmux refresh-client -S
