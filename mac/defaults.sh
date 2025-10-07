#!/bin/bash

set -e

function add-persistent-app () {
    defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>file://$1</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
}
function add-persistent-other () {
    defaults write com.apple.dock persistent-others -array-add "<dict><key>tile-type</key><string>directory-tile</string><key>tile-data</key><dict><key>arrangement</key><integer>2</integer><key>file-data</key><dict><key>_CFURLString</key><string>file://$1</string><key>_CFURLStringType</key><integer>15</integer></dict></dict></dict>"
}

if [ -d "/System/Applications" ]; then
    SYSTEM_APPS="/System/Applications"
else
    SYSTEM_APPS="/Applications"
fi

if [ -d "/System/Volumes/Preboot/Cryptexes/App/System/Applications" ]; then
    SAFARI_APPS="/System/Volumes/Preboot/Cryptexes/App/System/Applications"
else
    SAFARI_APPS="/Applications"
fi


defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock recent-apps -array
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array
defaults write com.apple.dock showhidden -bool true
add-persistent-app "$SYSTEM_APPS/Launchpad.app"
add-persistent-app "$SYSTEM_APPS/QuickTime Player.app"
add-persistent-app "/Applications/IINA.app"
add-persistent-app "$SAFARI_APPS/Safari.app"
add-persistent-app "/Applications/Google Chrome.app"
add-persistent-app "/Applications/Firefox Nightly.app"
add-persistent-app "$SYSTEM_APPS/Messages.app"
add-persistent-app "/Applications/NetNewsWire.app"
add-persistent-app "$SYSTEM_APPS/Mail.app"
add-persistent-app "/Applications/iTerm.app"
add-persistent-app "$SYSTEM_APPS/Utilities/Activity Monitor.app"
if [ -d "$SYSTEM_APPS/System Preferences.app" ]; then
    add-persistent-app "$SYSTEM_APPS/System Preferences.app"
else
    add-persistent-app "$SYSTEM_APPS/System Settings.app"
fi
if [ -d "$SYSTEM_APPS/Music.app" ]; then
    add-persistent-app "$SYSTEM_APPS/Music.app"
else
    add-persistent-app "/Applications/iTunes.app"
fi
#add-persistent-app "/Applications/Spotify.app"
add-persistent-app "/Applications/Xcode.app"
add-persistent-app "/Applications/Xcode-beta.app"
add-persistent-app "/Applications/Visual Studio Code.app"
add-persistent-app "/Applications/CotEditor.app"
add-persistent-app "/Applications/Hex Fiend.app"
add-persistent-app "/Applications/Slack.app"
add-persistent-app "/Applications/Discord.app"
add-persistent-app "/Applications/XLD.app"
add-persistent-app "/Applications/MusicBrainz Picard.app"

mkdir -p ~/Desktop/screenshots

add-persistent-other ~/Downloads
add-persistent-other ~/Desktop/screenshots

killall Dock

defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder FXDefaultSearchScope -string SCcf # デフォルトで現在のフォルダから検索
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

defaults write com.apple.menuextra.clock FlashDateSeparators -bool false # mm:ssの間をチカチカさせない
defaults write com.apple.menuextra.clock IsAnalog -bool false # デジタル時計

defaults write com.apple.controlcenter "AppleLanguages" -array "ja-JP"
defaults write com.apple.controlcenter "NSStatusItem Visible Bluetooth" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible Shortcuts" -bool true
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
defaults -currentHost write com.apple.controlcenter Sound -int 16 # always show sound/volume item
defaults -currentHost write com.apple.controlcenter FocusModes -int 16 # always show DnD mode item
defaults -currentHost write com.apple.Spotlight "MenuItemHidden" -bool true
defaults write com.apple.HIToolbox AppleDictationAutoEnable -int 0

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
defaults write com.apple.ActivityMonitor ShowCategory -int 100
defaults write com.apple.ActivityMonitor UpdatePeriod -int 1

# TODO: Disable True Tone

defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write -g AppleShowScrollBars -string Always

defaults write -g _NS_4445425547 -bool true

# ---
defaults write com.google.drivefs.settings BandwidthRxKBPS -int 1000000
defaults write com.google.drivefs.settings BandwidthTxKBPS -int 1000000
defaults write com.google.drivefs.settings ForceBrowserAuth -bool true

defaults write com.coteditor.CotEditor enablesAutosaveInPlace -int 0
defaults write com.coteditor.CotEditor fontName -string "Menlo-Regular"
defaults write com.coteditor.CotEditor fontSize -int 12

defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/dotfiles/mac/preferences"
defaults write com.googlecode.iterm2 SUEnableAutomaticChecks -bool true

defaults write at.niw.HapticKey ListeningEventType -int 2
defaults write at.niw.HapticKey FeedbackType -int 2

defaults write ch.sudo.cyberduck connection.dns.ipv6 -bool true
defaults write ch.sudo.cyberduck queue.download.checksum.calculate -bool true
defaults write ch.sudo.cyberduck queue.upload.checksum.calculate -bool true

# NOTE: XLD の設定を削除するには `defaults delete jp.tmkk.XLD; rm ~/Library/Application\ Support/XLD/XLD.plist.backup`

defaults write jp.tmkk.XLD AutoMountDisc -int 1
defaults write jp.tmkk.XLD AutoQueryCDDB -int 1
defaults write jp.tmkk.XLD DarkModeSupport -int 1
defaults write jp.tmkk.XLD CDDBServer -string "" # Only MusicBrainz
defaults write jp.tmkk.XLD EjectWhenDone -int 1
defaults write jp.tmkk.XLD FilenameFormat -string 'y%y_%T_disc%D_id%I_mcn%m_/%n(%i) %t'
defaults write jp.tmkk.XLD FilenameFormatRadio -int 1
defaults write jp.tmkk.XLD LogControl -int 1
defaults write jp.tmkk.XLD OutputDir -string "$HOME/Desktop/xld-out"
mkdir -p ~/Desktop/xld-out
defaults write jp.tmkk.XLD OutputFormatName -string "Apple Lossless"
defaults write jp.tmkk.XLD PreferredService -int 1 # MusicBrainz
defaults write jp.tmkk.XLD SelectOutput -int 1
defaults write jp.tmkk.XLD ScaleImage -int 0
defaults write jp.tmkk.XLD TestAndCopy -int 1
defaults write jp.tmkk.XLD UseC2Pointer -int 1
defaults write jp.tmkk.XLD VerifySector -int 1

defaults write com.apple.dt.Xcode IDEFileExtensionDisplayMode -int 1
defaults write com.apple.dt.Xcode DVTTextShowFoldingSidebar -int 1

# フルパスなので AQUASKK_DIR 外も書けそうに見えるし、実際書けて動くが、
# AquaSKKの環境設定ウインドウを開いてすぐ閉じるだけで動かなくなる
# ので素直に置く
AQUASKK_DIR="$HOME/Library/Application Support/AquaSKK"
mkdir -p "$AQUASKK_DIR"
if [[ ! -f "$AQUASKK_DIR/zenkaku-kigou.rule" ]]; then
    if [[ -L "$AQUASKK_DIR/zenkaku-kigou.rule" ]]; then
        rm "$AQUASKK_DIR/zenkaku-kigou.rule"
    fi
    ln -s "$HOME/dotfiles/skk/zenkaku-kigou.rule" "$AQUASKK_DIR/"
fi

defaults write jp.sourceforge.inputmethod.aquaskk sub_rules -array "$AQUASKK_DIR/zenkaku-kigou.rule"
defaults write jp.sourceforge.inputmethod.aquaskk enable_dynamic_completion -bool YES
defaults write jp.sourceforge.inputmethod.aquaskk enable_annotation -bool YES
defaults write jp.sourceforge.inputmethod.aquaskk dynamic_completion_range -int 3

echo " --- Downloading AquaSKK Dictionaries... ---"
pushd ../skk
make clean
make
popd
./aquaskk-dictionary-downloader.py
echo " --- Done ---"
killall AquaSKK
