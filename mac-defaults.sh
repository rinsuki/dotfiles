#!/bin/bash

function add-persistent-app () {
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file://$1</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
}

if [ -d "/System/Applications" ]; then
    SYSTEM_APPS="/System/Applications"
else
    SYSTEM_APPS="/Applications"
fi

defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock tilesize -int 24
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock recent-apps -array
defaults write com.apple.dock persistent-apps -array
add-persistent-app "$SYSTEM_APPS/Launchpad.app"
add-persistent-app "$SYSTEM_APPS/QuickTime Player.app"
add-persistent-app "/Applications/Safari.app"
add-persistent-app "/Applications/Firefox Nightly.app"
add-persistent-app "/Applications/NetNewsWire.app"
add-persistent-app "$SYSTEM_APPS/Mail.app"
add-persistent-app "$SYSTEM_APPS/Messages.app"
add-persistent-app "/Applications/iTerm.app"
add-persistent-app "$SYSTEM_APPS/Utilities/Activity Monitor.app"
add-persistent-app "$SYSTEM_APPS/System Preferences.app"
if [ -d "$SYSTEM_APPS/Music.app" ]; then
    add-persistent-app "$SYSTEM_APPS/Music.app"
else
    add-persistent-app "/Applications/iTunes.app"
fi
#add-persistent-app "/Applications/Spotify.app"
add-persistent-app "/Volumes/Xcode13/Applications/Xcode.app"
add-persistent-app "/Applications/Visual Studio Code.app"
add-persistent-app "/Applications/CotEditor.app"
add-persistent-app "/Applications/Hex Fiend.app"
add-persistent-app "/Applications/Slack.app"
add-persistent-app "/Applications/Discord.app"

killall Dock

defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.Finder ShowPathbar -bool true
defaults write com.apple.Finder ShowStatusBar -bool true
defaults write com.apple.Finder _FXSortFoldersFirst -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

defaults write com.apple.menuextra.clock DateFormat -string 'M月d日(EEE)  H:mm:ss' # 8月10日(水) 1:02:03
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false # mm:ssの間をチカチカさせない
defaults write com.apple.menuextra.clock IsAnalog -bool false # デジタル時計

defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
defaults -currentHost write com.apple.controlcenter Sound -int 16 # always show sound/volume item
defaults -currentHost write com.apple.controlcenter FocusModes -int 16 # always show DnD mode item
defaults -currentHost write com.apple.Spotlight "MenuItemHidden" -bool true

# no need to kill ControlCenter because Control Center watching defaults and immediately apply new settings.

defaults write com.apple.Terminal "Default Window Settings" -string Pro
defaults write com.apple.Terminal "Startup Window Settings" -string Pro

defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool false

defaults write com.apple.iphonesimulator ScreenShotSaveLocation -string "~/Desktop/screenshots"

defaults write com.apple.screencapture location -string "~/Desktop/screenshots"
defaults write com.apple.screencapture show-thumbnail -bool false

defaults write -g com.apple.swipescrolldirection -bool false

# Disable Spotlight shortcut key
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "<dict><key>enabled</key><false/></dict>"

# Activity Monitor icon to CPU Usage History Graph
defaults write com.apple.ActivityMonitor IconType -int 6

# TODO: Disable True Tone

# ---
defaults write com.google.drivefs.settings BandwidthRxKBPS -int 1000000
defaults write com.google.drivefs.settings BandwidthTxKBPS -int 1000000
defaults write com.google.drivefs.settings ForceBrowserAuth -bool true

defaults write com.coteditor.CotEditor enablesAutosaveInPlace -int 0
defaults write com.coteditor.CotEditor fontName -string "Menlo-Regular"
defaults write com.coteditor.CotEditor fontSize -int 12

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/dotfiles/mac-preferences"

defaults write at.niw.HapticKey ListeningEventType -int 2
defaults write at.niw.HapticKey FeedbackType -int 2