#!/usr/bin/env bash
source "$HOME/.config/hypr/scripts/variables.sh"

show_main_menu() {
  cat <<EOF
 About
󰀻 Apps
󰂯 Bluetooth
󰒓 Customize
󰏘 Packages
󰓅 Power Profiles
 Power Menu
 Task Manager
󰚥 Tools
 Key bindings
󰖩 WiFi
EOF
}

# --- Main ---
pkill rofi &>/dev/null || true

# Show menu and capture user choice
choice=$(show_main_menu | rofi -dmenu -i -p "System Menu" -config "$rofi_default_theme")

# --- Actions ---
case "$choice" in
*"About")
  "$terminal" --class tui -e zsh -ic "fastfetch; read -s -k '?Press enter to close...'"
  ;;
*"Apps")
  rofi -i -show drun -show-icons -config "$rofi_default_theme"
  ;;
*"Bluetooth")
  rofi-bluetooth
  ;;
*"Customize")
  "$scripts_dir/rofi/menu/customize-menu.sh"
  ;;
*"Key bindings")
  "$scripts_dir/rofi/menu/keymap-menu.sh"
  ;;
*"Packages")
  "$scripts_dir/rofi/menu/packages-menu.sh"
  ;;
*"Power Menu")
  "$scripts_dir/rofi/menu/power-menu.sh"
  ;;
*"Power Profiles")
  "$scripts_dir/rofi/menu/profiles-menu.sh"
  ;;
*"Task Manager")
  "$terminal" --class tui -e btop
  ;;
*"Tools")
  "$scripts_dir/rofi/menu/tools-menu.sh"
  ;;
*"WiFi")
  "$scripts_dir/rofi/menu/wifi-menu.sh"
  ;;
*)
  exit 0
  ;;
esac
