# Vi bindings for the line editor. Esc delay is 10ms.
# Insert mode: fj leaves insert, same chord as Cursor and Neovim.
bindkey -v
export KEYTIMEOUT=1

bindkey -M viins 'fj' vi-cmd-mode

# Ctrl-F accepts the gray suggestion. Right arrow does too.
if zle -la | grep -qx autosuggest-accept; then
  bindkey -M viins '^F' autosuggest-accept
  bindkey -M viins '^[[C' autosuggest-accept
fi

# Search and files still work from both insert and command mode.
if zle -la | grep -qx fzf-history-widget; then
  bindkey -M viins '^R' fzf-history-widget
  bindkey -M vicmd '^R' fzf-history-widget
  bindkey -M viins '^T' fzf-file-widget
  bindkey -M vicmd '^T' fzf-file-widget
  bindkey -M viins '\ec' fzf-cd-widget
  bindkey -M vicmd '\ec' fzf-cd-widget
fi

# v in command mode opens the current line in $EDITOR.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Block cursor in command mode, bar in insert mode.
function zle-keymap-select {
  case ${KEYMAP} in
    vicmd) print -n '\e[2 q' ;;
    *) print -n '\e[6 q' ;;
  esac
}
zle -N zle-keymap-select
function zle-line-init {
  print -n '\e[6 q'
}
zle -N zle-line-init
