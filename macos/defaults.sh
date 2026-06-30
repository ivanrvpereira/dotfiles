#!/usr/bin/env bash
# macOS defaults — Tahoe (26.x) validated
# Run: ./macos/defaults.sh
# Can be re-run safely at any time.
set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }

# Close System Settings to prevent it from overriding our changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
sleep 1

###############################################################################
# Keyboard & Input                                                            #
###############################################################################

info "Configuring keyboard & input..."

# Disable press-and-hold for accented characters (required for key repeat)
defaults write -g ApplePressAndHoldEnabled -bool false

# Maximum key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1

# Short initial key repeat delay (don't go below 10 — causes double-input)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Full keyboard access in all controls (Sequoia uses 2, not 3)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Use F1, F2, etc. as standard function keys (hold Globe/fn for special features)
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Disable all auto-correction nonsense
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Caps Lock -> Control (native per-keyboard Modifier Keys mapping).
# Detect the built-in Apple keyboard's vendor/product so it works across Mac
# models, then map 0x700000039 (Caps Lock) -> 0x7000000E0 (Left Control).
# This is the same pref the GUI Modifier Keys panel writes; takes effect after
# logout/login.
kbline=$(hidutil list 2>/dev/null | awk '/AppleHIDKeyboardEventDriverV2/ {print $1, $2; exit}' || true)
if [[ -n "$kbline" ]]; then
    read -r vh ph <<<"$kbline"
    kbd="$((vh))-$((ph))-0"
    info "Mapping Caps Lock -> Control (keyboard $kbd)..."
    defaults -currentHost write -g "com.apple.keyboard.modifiermapping.$kbd" -array \
        '{"HIDKeyboardModifierMappingSrc"=30064771129;"HIDKeyboardModifierMappingDst"=30064771296;}'
else
    warn "Could not detect built-in keyboard for Caps Lock->Control remap"
fi

###############################################################################
# Trackpad                                                                    #
###############################################################################

info "Configuring trackpad..."

# Three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Disable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################
# Dock                                                                        #
###############################################################################

info "Configuring Dock..."

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock expose-animation-duration -float 0.01

###############################################################################
# Finder                                                                      #
###############################################################################

info "Configuring Finder..."

defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Screenshots                                                                 #
###############################################################################

info "Configuring screenshots..."

mkdir -p "${HOME}/Desktop/screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Desktop/screenshots"
defaults write com.apple.screencapture type -string "png"

# Swap region-screenshot shortcuts: Cmd+Shift+4 copies to clipboard, while
# Cmd+Ctrl+Shift+4 saves to the file/folder above. params = (charCode, keycode, modifiers):
#   key '4' = charCode 52, keycode 21; Cmd+Shift = 1179648, Cmd+Ctrl+Shift = 1441792.
# Hotkey 30 = save selected area to file; 31 = copy selected area to clipboard.
# (IDs 28/29 are the full-screen Cmd+Shift+3 shortcuts — leave them alone.)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 30 '{enabled=1;value={parameters=(52,21,1441792);type=standard;};}'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 31 '{enabled=1;value={parameters=(52,21,1179648);type=standard;};}'

###############################################################################
# Global UI/UX                                                                #
###############################################################################

info "Configuring global UI..."

# Save to disk by default, not iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Expand save and print dialogs by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# 24-hour clock
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Disable tiled window margins (Sequoia)
defaults write -g EnableTiledWindowMargins -bool false

# Menu bar: tighten spacing between status items (Tahoe defaults are very roomy).
# Affects third-party/extra menu bar icons. Requires logout/login to take effect.
defaults -currentHost write -globalDomain NSStatusItemSpacing -int 6
defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 6

###############################################################################
# Restart affected applications                                               #
###############################################################################

info "Restarting affected applications..."

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

echo ""
info "macOS defaults applied!"
warn "Some settings (keyboard repeat, trackpad, menu bar spacing) require logout/reboot to take effect."
