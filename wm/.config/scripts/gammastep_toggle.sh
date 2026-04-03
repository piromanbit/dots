#!/usr/bin/env bash
set -euo pipefail

# Toggle / autostart for gammastep (Wayland / niri). State: XDG_STATE_HOME/gammastep/disabled
# Usage: gammastep_toggle.sh autostart | toggle | on | off

CONFIG="${GAMMASTEP_CONFIG:-${XDG_CONFIG_HOME:-$HOME/.config}/gammastep/config.ini}"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/gammastep"
DISABLED_FLAG="$STATE_DIR/disabled"

notify() {
  command -v notify-send >/dev/null 2>&1 && notify-send -a gammastep -t 2500 "$1" "$2" || true
}

daemon_running() {
  pgrep -x gammastep >/dev/null 2>&1
}

reset_gamma() {
  # One-shot neutral temperature and default brightness; clears filter after pkill.
  gammastep -m wayland -o -O 6500 -P -b 1.0:1.0 2>/dev/null || true
}

start_daemon() {
  if [[ ! -f "$CONFIG" ]]; then
    echo "gammastep: missing config $CONFIG" >&2
    notify "Gammastep" "Missing config: $CONFIG"
    exit 1
  fi
  if daemon_running; then
    return 0
  fi
  gammastep -c "$CONFIG" &
}

case "${1:-}" in
  autostart)
    mkdir -p "$STATE_DIR"
    if [[ -f "$DISABLED_FLAG" ]]; then
      reset_gamma
    else
      start_daemon
    fi
    ;;
  on)
    mkdir -p "$STATE_DIR"
    rm -f "$DISABLED_FLAG"
    pkill -x gammastep 2>/dev/null || true
    start_daemon
    notify "Gammastep" "Night mode schedule on (see ~/.config/gammastep/config.ini)"
    ;;
  off)
    mkdir -p "$STATE_DIR"
    touch "$DISABLED_FLAG"
    pkill -x gammastep 2>/dev/null || true
    reset_gamma
    notify "Gammastep" "Filter off (neutral screen)"
    ;;
  toggle)
    mkdir -p "$STATE_DIR"
    if [[ -f "$DISABLED_FLAG" ]] || ! daemon_running; then
      exec "$0" on
    else
      exec "$0" off
    fi
    ;;
  *)
    echo "usage: $(basename "$0") autostart | toggle | on | off" >&2
    exit 1
    ;;
esac
