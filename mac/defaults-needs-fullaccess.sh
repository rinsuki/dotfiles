#!/bin/bash

# Full Disk Access is required to run this script

defaults write com.apple.universalaccess showToolbarButtonShapes -bool true
defaults write com.apple.universalaccess showWindowTitlebarIcons -bool true

defaults write com.apple.mail ColumnLayoutMessageList -bool true
defaults write com.apple.mail ConversationViewMarkAllAsRead -bool true
defaults write com.apple.mail ShouldShowUnreadMessagesInBold -bool true
defaults write com.apple.mail ColumnLayoutMessageList -bool true
defaults write com.apple.mail BottomPreview -bool false

defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "WebKitPreferences.developerExtrasEnabled" -bool true
