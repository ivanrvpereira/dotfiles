#!/usr/bin/env bash
set -euo pipefail

tab_number="${1:?usage: focus-tab.sh TAB_NUMBER}"
herdr_bin="${HERDR_BIN_PATH:-herdr}"
workspace_id="${HERDR_ACTIVE_WORKSPACE_ID:-${HERDR_WORKSPACE_ID:-}}"
[[ -n "$workspace_id" ]] || exit 0

tab_id="$("$herdr_bin" tab list --workspace "$workspace_id" \
    | jq -er --argjson number "$tab_number" \
        '.result.tabs[] | select(.number == $number) | .tab_id' 2>/dev/null)" || exit 0

"$herdr_bin" tab focus "$tab_id" >/dev/null
