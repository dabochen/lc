#!/usr/bin/env bash
# Lightweight per-directory command launcher
# https://github.com/dabochen/lc 

set -euo pipefail

# Location of the registry that stores commands
REG_FILE="${LC_REG_FILE:-$HOME/.lc/registry.json}"
mkdir -p "$(dirname "$REG_FILE")"
touch "$REG_FILE"
[[ -s $REG_FILE ]] || echo '{}' >"$REG_FILE"

# Helpers
json()        { jq "$1" "$REG_FILE"; }
current_key() { realpath "$PWD"; }

# lc add "<full command>"
add_cmd() {
  local key cmd="$*"; key=$(current_key)
  json ". += {\"$key\": ((.[\"$key\"] // []) + [\"$cmd\"] | unique)}" >"$REG_FILE.tmp"
  mv "$REG_FILE.tmp" "$REG_FILE"
  echo "✅ added \"$cmd\""
}

# lc rm "<full command>"
rm_cmd() {
  local key cmd="$*"; key=$(current_key)
  json ". += {\"$key\": ((.[\"$key\"] // []) - [\"$cmd\"])}" >"$REG_FILE.tmp"
  mv "$REG_FILE.tmp" "$REG_FILE"
  echo "🗑️  removed \"$cmd\""
}

# lc ls
list_cmds() { json ".[\"$(current_key)\"] // []"; }

# lc  (choose & run)
launch_cmd() {
  local cmds sel
  cmds=$(list_cmds | jq -r '.[]')
  [[ -z "$cmds" ]] && { echo "⚠️  no commands registered"; exit 1; }

  sel=$(printf '%s\n' "$cmds" | fzf --prompt="cmd> " --reverse --cycle)
  [[ -z "$sel" ]] && exit 0

  echo "▶ $sel"
  eval "$sel"
}

case "${1-}" in
  add) shift; add_cmd "$*";;
  rm)  shift; rm_cmd  "$*";;
  ls)  list_cmds;;
  *)   launch_cmd;;
esac