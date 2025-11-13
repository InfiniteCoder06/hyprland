#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/variables.sh"

MENU=$(
  cat <<EOF
󰓅 Performance$([ "$CURRENT" = "performance" ] && printf ' (Active)')
󰾅 Balanced$([ "$CURRENT" = "balanced" ] && printf ' (Active)')
󰾆 Power Saver$([ "$CURRENT" = "power-saver" ] && printf ' (Active)')
 Go Back
EOF
)

PROFILE=$(printf '%s\n' "$MENU" | rofi -dmenu -i -p "Power Profile" -config "$rofi_default_theme")

case "$PROFILE" in
*"Performance"*)
  powerprofilesctl set performance
  notify-send "Power Profile" "Switched to Performance mode"
  ;;
*"Balanced"*)
  powerprofilesctl set balanced
  notify-send "Power Profile" "Switched to Balanced mode"
  ;;
*"Power Saver"*)
  powerprofilesctl set power-saver
  notify-send "Power Profile" "Switched to Power Saver mode"
  ;;
*"Go Back")
  "$scripts_dir/rofi/main-menu.sh"
  ;;
*)
  exit 0
  ;;
esac
