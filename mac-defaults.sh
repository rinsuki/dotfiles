#!/bin/bash

defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64

killall Dock

defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

defaults write com.apple.menuextra.clock 'DateFormat' -string 'YYYY'