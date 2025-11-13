#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/variables.sh"

get_options() {
  cat <<EOF
 Shutdown
 Reboot
 Suspend
 Lock
 Go Back
EOF
}

chosen=$(get_options | rofi -dmenu -p "Power Menu" -config "$rofi_default_theme")

case "$chosen" in
*"Reboot")
  systemctl reboot
  ;;
*"Shutdown")
  systemctl poweroff
  ;;
*"Suspend")
  systemctl suspend
  ;;
*"Lock")
  hyprlock
  ;;
*"Go Back")
  "$scripts_dir/rofi/main-menu.sh"
  ;;
*)
  exit 0
  ;;
esac
