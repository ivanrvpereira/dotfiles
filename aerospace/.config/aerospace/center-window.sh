#!/bin/bash
# Reset floating window position for the focused window.
#
# AeroSpace actively overrides floating window positions via its internal
# position tracking (prevUnhiddenEmulationPosition), so AppleScript-based
# moves get immediately reverted. The only reliable workaround:
#
# - Finder: close window and create a fresh one at the same path
#   (new windows get clean position tracking from AeroSpace)
# - Other apps: toggle AeroSpace fullscreen to make the window visible

APP_ID=$(aerospace list-windows --focused --format '%{app-bundle-id}' 2>/dev/null | head -1)
WINDOW_ID=$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null | head -1)
[ -z "$WINDOW_ID" ] && exit 1

if [ "$APP_ID" = "com.apple.finder" ]; then
    # Create a fresh Finder window at the same path (bypasses corrupted position)
    osascript -e '
    tell application "Finder"
        try
            set fw to front Finder window
            set targetFolder to (target of fw) as alias
            close fw
            delay 0.2
            set newWin to make new Finder window
            set target of newWin to targetFolder
        on error
            make new Finder window
        end try
    end tell
    '
else
    # For other floating apps: toggle fullscreen to make visible
    aerospace fullscreen --window-id "$WINDOW_ID" 2>/dev/null
fi
