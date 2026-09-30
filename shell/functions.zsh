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

# SSH config, with Include lines expanded in place. Wildcards stay out of the list.
_ssh_stream_config() {
  local file=$1 line rest token path
  local -a matches
  [[ -f $file ]] || return
  [[ -n ${seen[$file]} ]] && return
  seen[$file]=1
  while IFS= read -r line || [[ -n $line ]]; do
    if [[ $line =~ '^[[:space:]]*Include[[:space:]]+(.*)$' ]]; then
      rest=${match[1]}
      rest=${rest%%#*}
      for token in ${(z)rest}; do
        token=${token#\"}
        token=${token%\"}
        token=${token#\'}
        token=${token%\'}
        [[ $token == /* ]] || token="${file:h}/$token"
        matches=(${~token}(N.))
        for path in $matches; do
          _ssh_stream_config "$path"
        done
      done
    else
      print -r -- "$line"
    fi
  done < "$file"
}

# name, user, address, port. One row per Host name in ~/.ssh/config.
_ssh_host_rows() {
  local -A seen
  _ssh_stream_config "${HOME}/.ssh/config" | awk '
    function flush(   i, n, a, hn, p) {
      if (!pending) return
      n = split(names, a, /[[:space:]]+/)
      for (i = 1; i <= n; i++) {
        if (a[i] == "" || a[i] ~ /[*?]/) continue
        hn = (hostname == "" ? a[i] : hostname)
        p = (port == "" ? "22" : port)
        printf "%s\t%s\t%s\t%s\n", a[i], (user == "" ? "-" : user), hn, p
      }
      pending = 0
    }
    /^[[:space:]]*(#|$)/ { next }
    /^[[:space:]]*Match[[:space:]]+/ { flush(); next }
    /^[[:space:]]*Host[[:space:]]+/ {
      flush()
      pending = 1
      hostname = ""
      user = ""
      port = ""
      sub(/^[[:space:]]*Host[[:space:]]+/, "")
      names = $0
      next
    }
    /^[[:space:]]*HostName[[:space:]]+/ { if (pending) hostname = $2; next }
    /^[[:space:]]*User[[:space:]]+/ { if (pending) user = $2; next }
    /^[[:space:]]*Port[[:space:]]+/ { if (pending) port = $2; next }
    END { flush() }
  '
}

# Print the servers `ssh` can open by name.
hosts() {
  local rows
  rows=$(_ssh_host_rows) || return
  [[ -n $rows ]] || return
  print -r -- $'name\tuser\taddress\tport\n'"$rows" | column -t -s $'\t'
}

# Pick a server the way the VS Code host list does. `s name` connects directly.
s() {
  if [[ $# -gt 0 ]]; then
    ssh "$@"
    return
  fi
  (( $+commands[fzf] )) || { print -u2 "fzf is not installed"; return 1 }
  local rows pick
  rows=$(_ssh_host_rows) || return
  [[ -n $rows ]] || { print -u2 "no hosts in ~/.ssh/config"; return 1 }
  pick=$(print -r -- "$rows" | fzf \
    --prompt='host > ' \
    --header='type to filter, enter connects' \
    --delimiter=$'\t' \
    --with-nth=1,2,3 \
    --cycle) || return
  pick=${pick%%$'\t'*}
  [[ -n $pick ]] || return
  ssh "$pick"
}

if (( $+functions[compdef] )); then
  compdef s=ssh
fi

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
