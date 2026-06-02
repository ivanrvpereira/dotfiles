#!/usr/bin/env bash
# Renders the tmux session list (with each session's windows nested) for the
# status bar.
# - current session is highlighted red; each session's active window is highlighted.
# - sessions needing attention are marked red with a leading dot.
#   "attention" = a native bell alert on any window (monitor-bell), or any
#   window carrying the @claude_waiting option (set this from a Claude Code
#   Notification hook if you want agent-waiting detection).
# - a window that rang the bell is itself flagged red.
#
# Layout: 1:0[1:nvim|2:sh]  2:polly[1:.dotfiles|2:logs]
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

workspace_style='#[fg=colour39]'
active_workspace_style='#[fg=colour203,bold]'

cur_win_active='#[fg=green,bold]'
cur_win_inactive='#[fg=colour252]'
cur_bracket='#[fg=colour245]'

other_win_active='#[fg=green,bold]'
other_win_inactive='#[fg=colour245]'
other_bracket='#[fg=colour240]'

alert_style='#[fg=red,bold]'
reset='#[default]'
sep='  '
wsep_cur='#[fg=colour240]|'
wsep_other='#[fg=colour238]|'

# Internal separators for tmux output and cached window rows. tmux names are not
# expected to contain ASCII record/unit separators. Unit separator is used for
# fields because Bash collapses empty tab fields when reading with IFS=$'\t'.
rs=$'\036'
fs=$'\037'

declare -a sessions
declare -A seen attention window_rows

idx=0
# One tmux query provides session + window state. The shell sort keeps session
# positions stable by creation time and windows ordered by index.
while IFS="$fs" read -r _created sname alerts widx wname wactive wbell waiting; do
    [ -n "$sname" ] || continue

    if [ -z "${seen[$sname]:-}" ]; then
        idx=$((idx + 1))
        seen["$sname"]=$idx
        sessions[$idx]="$sname"
    fi

    [ -n "$alerts" ] && attention["$sname"]=1
    [ "$waiting" = "1" ] && attention["$sname"]=1

    window_rows["$sname"]+="${widx}${fs}${wname}${fs}${wactive}${fs}${wbell}${rs}"
done < <(
    tmux list-windows -a \
        -F "#{session_created}${fs}#{session_name}${fs}#{session_alerts}${fs}#{window_index}${fs}#{window_name}${fs}#{window_active}${fs}#{window_bell_flag}${fs}#{@claude_waiting}" \
        2>/dev/null \
        | LC_ALL=C sort -t "$fs" -k1,1n -k4,4n
)

out=""
for ((i = 1; i <= idx; i++)); do
    sname="${sessions[$i]}"
    [ "$i" -gt 1 ] && out="${out}${sep}"

    is_current=0
    [ "$sname" = "$current" ] && is_current=1

    # Session label (clickable: switches to this session).
    if [ -n "${attention[$sname]:-}" ]; then
        label="${alert_style}●${i}:${sname}${reset}"
    elif [ "$is_current" -eq 1 ]; then
        label="${active_workspace_style}${i}:${sname}${reset}"
    else
        label="${workspace_style}${i}:${sname}${reset}"
    fi
    out="${out}#[range=user|${i}]${label}#[norange]"

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
    while IFS="$fs" read -r widx wname wactive wbell; do
        [ -n "$widx" ] || continue
        if [ "$wbell" = "1" ]; then
            wstyle="$alert_style"
        elif [ "$wactive" = "1" ]; then
            wstyle="$_win_active"
        else
            wstyle="$_win_inactive"
        fi
        [ "$first" -eq 1 ] || wlist="${wlist}${_wsep}"
        first=0
        wlist="${wlist}#[range=user|${i}:${widx}]${wstyle}${widx}:${wname}${reset}#[norange]"
    done < <(printf '%s' "${window_rows[$sname]:-}" | tr "$rs" '\n')

    out="${out}${_bracket}[${reset}${wlist}${_bracket}]${reset}"
done

printf '%s' "$out"
