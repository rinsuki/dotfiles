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
add-persistent-app "/Applications/Firefox.app"
add-persistent-app "/Applications/NetNewsWire.app"
add-persistent-app "$SYSTEM_APPS/Mail.app"
add-persistent-app "$SYSTEM_APPS/Messages.app"
add-persistent-app "$SYSTEM_APPS/Utilities/Terminal.app"
add-persistent-app "$SYSTEM_APPS/Utilities/Activity Monitor.app"
add-persistent-app "$SYSTEM_APPS/System Preferences.app"
if [ -d "$SYSTEM_APPS/Music.app" ]; then
    add-persistent-app "$SYSTEM_APPS/Music.app"
else
    add-persistent-app "/Applications/iTunes.app"
fi
add-persistent-app "/Applications/Spotify.app"
add-persistent-app "/Applications/Xcode.app"
add-persistent-app "/Applications/Visual Studio Code.app"
add-persistent-app "/Applications/CotEditor.app"
add-persistent-app "/Applications/Slack.app"
add-persistent-app "/Applications/Discord.app"

killall Dock

defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

defaults write com.apple.menuextra.clock DateFormat -string 'M月d日(EEE)  H:mm:ss' # 8月10日(水) 1:02:03
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false # mm:ssの間をチカチカさせない
defaults write com.apple.menuextra.clock IsAnalog -bool false # デジタル時計
defaults write com.apple.menuextra.battery ShowPercent -bool true # バッテリーの%値表示

killall -HUP SystemUIServer

# ---

defaults write com.apple.Terminal "Default Window Settings" -string Pro
defaults write com.apple.Terminal "Startup Window Settings" -string Pro