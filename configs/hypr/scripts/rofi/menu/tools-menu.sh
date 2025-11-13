#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/variables.sh"

: "${SAVED_FILE:=$HOME/Pictures/Screenshots/shot-$(date +%s).png}"

prompt_rofi() {
  rofi -dmenu -i -p "$1" -config "$rofi_default_theme"
}

get_options() {
  cat <<EOF
 Screenshot Area
 Screenshot Area (Edit)
 Screenshot Full
 Screenshot Full (Edit)
 Clipboard Manager
 Color Picker
󰞅 Emoji Picker
 Go Back
EOF
}

ensure_screenshot_dir() {
  mkdir -p "$HOME/Pictures/Screenshots"
}

ACTION=$(get_options | prompt_rofi "Tools")

case "$ACTION" in
*"Screenshot Area")
  ensure_screenshot_dir
  grimblast -n -w 0.8 -f copysave area "$SAVED_FILE"
  ;;
*"Screenshot Area (Edit)")
  ensure_screenshot_dir
  grimblast -w 0.8 edit area
  ;;
*"Screenshot Full")
  ensure_screenshot_dir
  grimblast -n -w 0.8 copysave screen "$SAVED_FILE"
  ;;
*"Screenshot Full (Edit)")
  ensure_screenshot_dir
  grimblast -w 0.8 edit screen
  ;;
*"Clipboard Manager")
  "$terminal" --class tui -e clipse
  ;;
*"Color Picker")
  pkill rofi || true
  sleep 0.8
  hyprpicker -a
  ;;
*"Emoji Picker")
  rofi -modi emoji -show emoji -config "$rofi_emoji_theme"
  ;;
*"Go Back")
  "$scripts_dir/rofi/main-menu.sh"
  ;;
*)
  exit 0
  ;;
esac

