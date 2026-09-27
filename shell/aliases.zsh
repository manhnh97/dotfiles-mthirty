# Short paths. `cd` itself stays zoxide when that is installed.
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias work='cd ~/workspaces'
alias -- -='cd -'

alias g='git'
alias lg='lazygit'
alias reload='exec zsh'

if (( $+commands[eza] )); then
  alias ls='eza --group-directories-first'
  alias ll='eza -lah --git --group-directories-first --time-style=long-iso'
  alias la='eza -a --group-directories-first'
  alias lt='eza -aT --git --group-directories-first -L 2'
else
  alias ll='ls -lah'
  alias la='ls -a'
fi

if (( $+commands[bat] )); then
  alias cat='bat --paging=never'
  export BAT_THEME="${BAT_THEME:-ansi}"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

if (( $+commands[hexyl] )); then
  alias hex='hexyl'
fi

if (( $+commands[nvim] )); then
  alias v='nvim'
  alias vi='nvim'
  alias vim='nvim'
fi

if [[ -x /opt/homebrew/opt/ghidra/bin/ghidraRun ]]; then
  alias ghidra='/opt/homebrew/opt/ghidra/bin/ghidraRun'
fi
