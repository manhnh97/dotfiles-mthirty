#!/usr/bin/env bash
# Keyboard-first macOS settings. Safe to run again.
set -euo pipefail

# Hold a key to repeat it. The accent popup blocks Vim.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Delay before repeat, then repeat rate. Lower is faster. Units are 15ms.
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2

# Tab moves through every control, not only text fields.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write com.apple.Accessibility FullKeyboardAccessEnabled -bool true

# Typing stays literal in code and the shell.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Windows and spaces appear immediately, and spaces stay in a fixed order.
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder is a list you can drive with the arrows. Folders sort first.
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

if [[ -d /Applications/Rectangle.app ]]; then
  defaults write com.knollsoft.Rectangle launchOnLogin -bool true
  open -g -a Rectangle
fi

killall Finder >/dev/null 2>&1 || true
killall Dock >/dev/null 2>&1 || true

echo "Keyboard settings applied."
echo "Log out once if Tab still skips buttons. Rectangle snaps windows with Control-Option and an arrow."
