#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/variables.sh"

get_options() {
  cat <<EOF
󰗘 Animations
󰸉 Wallpapers
󰸉 Wallpaper Effects
 Reload Config
 Go Back
EOF
}

chosen=$(get_options | rofi -dmenu -p "Customize" -config "$rofi_default_theme")

case "$chosen" in
*"Animations")
  "$scripts_dir/rofi/menu/animations-menu.sh"
  ;;
*"Wallpapers")
  "$scripts_dir/rofi/wallpaper-select.sh"
  ;;
*"Wallpaper Effects")
  "$scripts_dir/rofi/wallpaper-effects.sh"
  ;;
*"Reload Config")
  "$scripts_dir/refresh.sh"
  ;;
*"Go Back")
  "$scripts_dir/rofi/main-menu.sh"
  ;;
*)
  exit 0
  ;;
esac
