#!/usr/bin/env bash
# Renders the tmux session list (with each session's windows nested) for the
# status bar.
# - current session is highlighted; each session's active window is highlighted.
# - sessions needing attention are marked red with a leading dot.
#   "attention" = a native bell alert on any window (monitor-bell), or any
#   window carrying the @claude_waiting option (set this from a Claude Code
#   Notification hook if you want agent-waiting detection).
# - a window that rang the bell is itself flagged red.
#
# Layout: 0[1:nvim|2:sh]  polly[1:.dotfiles|2:logs]
#
# Each session label is wrapped in a clickable range "user|<idx>" and each
# window in "user|<idx>:<window-index>", where <idx> is the 1-based position in
# the creation-ordered session list. The MouseDown1Status binding in
# .tmux.conf feeds the clicked range to session-switch.sh, which resolves it to
# explicit targets (never the mouse "=" target, which segfaults tmux when the
# click lands outside a real window range).
#
# Usage: session-list.sh <current-session-name>

set -u

current="${1:-}"

# ── Active session: bold + bright — the whole group glows ──
cur_sess_style='#[fg=cyan,bold]'
cur_win_active='#[fg=green,bold]'
cur_win_inactive='#[fg=colour252]'
cur_bracket='#[fg=colour245]'

# ── Other sessions: readable but visually recessed ──
other_sess_style='#[fg=colour252]'
other_win_active='#[fg=green,bold]'
other_win_inactive='#[fg=colour245]'
other_bracket='#[fg=colour240]'

alert_style='#[fg=red,bold]'
reset='#[default]'
sep='  '
wsep_cur='#[fg=colour240]|'
wsep_other='#[fg=colour238]|'

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
while IFS= read -r sname; do
    [ -z "$sname" ] && continue
    idx=$((idx + 1))
    [ "$idx" -gt 1 ] && out="${out}${sep}"

    is_current=0
    [ "$sname" = "$current" ] && is_current=1

    # Session label (clickable: switches to this session).
    if [ -n "${attention[$sname]:-}" ]; then
        label="${alert_style}●${idx}:${sname}${reset}"
    elif [ "$is_current" -eq 1 ]; then
        label="${cur_sess_style}${idx}:${sname}${reset}"
    else
        label="${other_sess_style}${idx}:${sname}${reset}"
    fi
    out="${out}#[range=user|${idx}]${label}#[norange]"

    # Pick styles based on whether this is the current session.
    if [ "$is_current" -eq 1 ]; then
        _win_active="$cur_win_active"
        _win_inactive="$cur_win_inactive"
        _bracket="$cur_bracket"
        _wsep="$wsep_cur"
    else
        _win_active="$other_win_active"
        _win_inactive="$other_win_inactive"
        _bracket="$other_bracket"
        _wsep="$wsep_other"
    fi

    # Nested window list (each window clickable: switches session + window).
    wlist=""
    first=1
    while IFS=$'\t' read -r widx wname wactive wbell; do
        [ -z "$widx" ] && continue
        if [ "$wbell" = "1" ]; then
            wstyle="$alert_style"
        elif [ "$wactive" = "1" ]; then
            wstyle="$_win_active"
        else
            wstyle="$_win_inactive"
        fi
        [ "$first" -eq 1 ] || wlist="${wlist}${_wsep}"
        first=0
        wlist="${wlist}#[range=user|${idx}:${widx}]${wstyle}${widx}:${wname}${reset}#[norange]"
    done < <(tmux list-windows -t "$sname" -F '#{window_index}'$'\t''#{window_name}'$'\t''#{window_active}'$'\t''#{window_bell_flag}' 2>/dev/null)

    out="${out}${_bracket}[${reset}${wlist}${_bracket}]${reset}"
done < <(tmux list-sessions -F '#{session_created}'$'\t''#{session_name}' 2>/dev/null | sort -n | cut -f2-)

printf '%s' "$out"
