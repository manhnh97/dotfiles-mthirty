#!/bin/bash
# Bash fallback. zsh uses shell/aliases.zsh from the repo root.

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias work="cd ~/workspaces"

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --group-directories-first"
  alias ll="eza -lah --git --group-directories-first"
  alias la="eza -a --group-directories-first"
elif ls --color=auto /dev/null >/dev/null 2>&1; then
  alias ll="ls -lF --group-directories-first --color=auto"
  alias la="ls -laF --group-directories-first --color=auto"
else
  alias ll="ls -lah"
  alias la="ls -a"
fi

if command -v nvim >/dev/null 2>&1; then
  alias v="nvim"
  alias vi="nvim"
  alias vim="nvim"
fi
