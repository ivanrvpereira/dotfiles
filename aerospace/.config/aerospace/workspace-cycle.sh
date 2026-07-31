#!/bin/bash
# Cycle non-empty workspaces on a monitor relative to that monitor's visible workspace.
# Usage: workspace-cycle.sh <mouse|focused> <next|prev>

set -euo pipefail

MONITOR="${1:-mouse}"
DIRECTION="${2:-next}"

case "$DIRECTION" in
    next|prev) ;;
    *) echo "Usage: $0 <mouse|focused> <next|prev>" >&2; exit 2 ;;
esac

CURRENT=$(aerospace list-workspaces --monitor "$MONITOR" --visible | head -n 1 || true)

TARGET=$(
    aerospace list-workspaces --monitor "$MONITOR" --empty no |
        awk -v current="$CURRENT" -v direction="$DIRECTION" '
            BEGIN { idx = 0 }
            { workspaces[++count] = $0; if ($0 == current) idx = count }
            END {
                if (count == 0) exit
                if (idx == 0) {
                    print (direction == "prev" ? workspaces[count] : workspaces[1])
                } else if (direction == "next") {
                    print workspaces[(idx % count) + 1]
                } else {
                    print workspaces[((idx + count - 2) % count) + 1]
                }
            }
        '
)

[ -n "$TARGET" ] || exit 0
exec aerospace workspace "$TARGET"
