#!/usr/bin/env bash

set -e

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHRC="$HOME/.bashrc"
ALIAS_FILE="$DOTFILES/.scripts/.alias.sh"

mkdir -p "$HOME/.config"

if [ -d "$DOTFILES/.config/nvim" ]; then
  ln -sfn "$DOTFILES/.config/nvim" "$HOME/.config/nvim"
fi

if ! grep -q "$ALIAS_FILE" "$BASHRC"; then
  cat >> "$BASHRC" << EOF

# Load dotfiles aliases
if [ -f "$ALIAS_FILE" ]; then
  source "$ALIAS_FILE"
fi
EOF
fi

echo "Dotfiles installed from: $DOTFILES"
echo "Alias file: $ALIAS_FILE"
echo "Run: source ~/.bashrc"