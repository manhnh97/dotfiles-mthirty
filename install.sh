#!/usr/bin/env bash
# Link this repo into $HOME. Safe to run again.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL="$HOME/.config/mthirty/local.zsh"
PACK="$HOME/.local/share/nvim/site/pack/mthirty/opt/fzf-lua"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "${dest}.pre-dotfiles"
    echo "backed up $dest"
  fi
  ln -sfn "$src" "$dest"
}

mkdir -p "$HOME/.config/mthirty" "$HOME/.config/tmux"

if [[ ! -f "$LOCAL" ]]; then
  cp "$DOTFILES/shell/local.zsh.example" "$LOCAL"
  echo "wrote $LOCAL"
fi

link "$DOTFILES/shell/zshrc" "$HOME/.zshrc"
link "$DOTFILES/shell/p10k.zsh" "$HOME/.p10k.zsh"
link "$DOTFILES/.config/nvim" "$HOME/.config/nvim"
link "$DOTFILES/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

if command -v brew >/dev/null 2>&1; then
  missing=()
  command -v nvim >/dev/null 2>&1 || missing+=(neovim)
  command -v tmux >/dev/null 2>&1 || missing+=(tmux)
  if [[ ${#missing[@]} -gt 0 ]]; then
    # Homebrew can exit non-zero after a successful pour when an unrelated
    # formula fails to symlink. Keep going when both binaries are present.
    HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ENV_HINTS=1 brew install "${missing[@]}" || true
    command -v nvim >/dev/null 2>&1 || exit 1
    command -v tmux >/dev/null 2>&1 || exit 1
  fi
fi

if [[ ! -d "$PACK/.git" ]]; then
  mkdir -p "$(dirname "$PACK")"
  git clone --depth 1 https://github.com/ibhagwan/fzf-lua.git "$PACK"
fi

BASHRC="$HOME/.bashrc"
ALIAS_FILE="$DOTFILES/.scripts/.alias.sh"
if [[ -f "$BASHRC" ]] && ! grep -q "$ALIAS_FILE" "$BASHRC"; then
  cat >> "$BASHRC" << EOF

# Load dotfiles aliases
if [ -f "$ALIAS_FILE" ]; then
  source "$ALIAS_FILE"
fi
EOF
fi

GITCONFIG="$DOTFILES/git/config"
if command -v git >/dev/null 2>&1; then
  if ! git config --global --get-all include.path 2>/dev/null | grep -qx "$GITCONFIG"; then
    git config --global --add include.path "$GITCONFIG"
  fi
fi

echo "Dotfiles linked from $DOTFILES"
echo "Open a new terminal, or run: exec zsh"
