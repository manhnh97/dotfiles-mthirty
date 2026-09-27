# cd and show the directory.
cs() {
  cd "${1:-.}" && ll
}

# Listening TCP sockets. `ports 8200` limits the listing to one port.
ports() {
  if [[ -n "$1" ]]; then
    lsof -nP -iTCP:"$1" -sTCP:LISTEN
  else
    lsof -nP -iTCP -sTCP:LISTEN
  fi
}

# Project virtualenv. Prefers uv, then python3 -m venv.
venv() {
  local dir="${1:-.venv}"
  if (( $+commands[uv] )); then
    uv venv "$dir"
  else
    python3 -m venv "$dir"
  fi
  source "$dir/bin/activate"
}

# File type plus the first 64 bytes.
identify() {
  file "$@"
  if [[ $# -eq 1 && -f "$1" ]]; then
    print
    if (( $+commands[hexyl] )); then
      hexyl --length 64 "$1"
    else
      xxd -l 64 "$1"
    fi
  fi
}

# One tmux session per directory. `tm api` names it yourself.
# Inside tmux this switches; outside it attaches.
tm() {
  (( $+commands[tmux] )) || { print -u2 "tmux is not installed"; return 1 }
  local name="${1:-${PWD:t}}"
  name="${name//./_}"
  if [[ -n "$TMUX" ]]; then
    tmux has-session -t "$name" 2>/dev/null || tmux new-session -ds "$name" -c "$PWD"
    tmux switch-client -t "$name"
  else
    tmux new-session -A -s "$name" -c "$PWD"
  fi
}
