#!/usr/bin/env bash
# Renders the tmux session list for the status bar.
# - current session is highlighted
# - sessions needing attention are marked red with a leading dot.
#   "attention" = a native bell alert on any window (monitor-bell), or any
#   window carrying the @claude_waiting option (set this from a Claude Code
#   Notification hook if you want agent-waiting detection).
#
# Usage: session-list.sh <current-session-name>

set -u

current="${1:-}"

cur_style='#[fg=cyan,bold]'
norm_style='#[fg=colour245]'
alert_style='#[fg=red,bold]'
reset='#[default]'
sep='  '

declare -A attention

# Session-level alerts (bell/activity/silence depending on monitor-* settings).
while IFS=$'\t' read -r sname alerts; do
    [ -n "$alerts" ] && attention["$sname"]=1
done < <(tmux list-sessions -F '#{session_name}'$'\t''#{session_alerts}' 2>/dev/null)

# Any window flagged as waiting on user input.
while IFS=$'\t' read -r sname waiting; do
    [ "$waiting" = "1" ] && attention["$sname"]=1
done < <(tmux list-windows -a -F '#{session_name}'$'\t''#{@claude_waiting}' 2>/dev/null)

out=""
idx=0
# Ordered by creation time (oldest first) so positions are stable.
# Each entry is wrapped in a clickable range so a left-click switches to it
# (handled by the MouseDown1StatusLeft binding in .tmux.conf).
while IFS= read -r sname; do
    [ -z "$sname" ] && continue
    idx=$((idx + 1))
    [ "$idx" -gt 1 ] && out="${out}${sep}"
    label="${idx}:${sname}"
    if [ -n "${attention[$sname]:-}" ]; then
        body="${alert_style}●${label}${reset}"
    elif [ "$sname" = "$current" ]; then
        body="${cur_style}${label}${reset}"
    else
        body="${norm_style}${label}${reset}"
    fi
    out="${out}#[range=user|${idx}]${body}#[norange]"
done < <(tmux list-sessions -F '#{session_created}'$'\t''#{session_name}' 2>/dev/null | sort -n | cut -f2-)

printf '%s' "$out"
