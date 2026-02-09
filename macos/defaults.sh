#!/usr/bin/env bash
# macOS defaults — Sequoia (15.x) validated
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
# Hostname                                                                    #
###############################################################################

if [[ -n "${HOSTNAME_TO_SET:-}" ]]; then
    info "Setting hostname to '$HOSTNAME_TO_SET'..."
    sudo scutil --set ComputerName "$HOSTNAME_TO_SET"
    sudo scutil --set HostName "$HOSTNAME_TO_SET"
    sudo scutil --set LocalHostName "$HOSTNAME_TO_SET"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$HOSTNAME_TO_SET"
fi

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

# Disable all auto-correction nonsense
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

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

# Disable tiled window margins (Sequoia)
defaults write -g EnableTiledWindowMargins -bool false

###############################################################################
# Restart affected applications                                               #
###############################################################################

info "Restarting affected applications..."

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

echo ""
info "macOS defaults applied!"
warn "Some settings (keyboard repeat, trackpad) require logout/reboot to take effect."
