#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/variables.sh"

get_options() {
  cat <<EOF
󰏗 Install Package
󰏘 Remove Package
󰏙 Update Package
 Go Back
EOF
}

prompt_rofi() {
  rofi -dmenu -i -p "$1" -config "$rofi_default_theme"
}

sanitize_for_shell() {
  printf '%s' "$1" | tr -d "'"
}

install_package() {
  PACKAGE=$(paru -Slq | prompt_rofi "Install Package:")
  if [ -n "$PACKAGE" ]; then
    PACKAGE=$(sanitize_for_shell "$PACKAGE")
    "$terminal" --class tui -e zsh -ic "paru -S '$PACKAGE'; read -s -k '?Press enter to close...'"
  fi
}

remove_package() {
  PACKAGES=$(pacman -Qq | prompt_rofi "Select package to remove:")
  if [ -n "$PACKAGES" ]; then
    PACKAGES=$(sanitize_for_shell "$PACKAGES")
    "$terminal" --class tui -e zsh -ic "paru -Rns $PACKAGES; read -s -k '?Press enter to close...'"
  fi
}

update_packages() {
  "$terminal" --class tui -e zsh -ic "paru -Syu; read -s -k '?Press enter to close...'"
}

ACTION=$(get_options | rofi -dmenu -i -p "Packages" -config "$rofi_default_theme")

case "$ACTION" in
*"Install Package")
  install_package
  ;;
*"Remove Package")
  remove_package
  ;;
*"Update Package")
  update_packages
  ;;
*"Go Back")
  "$scripts_dir/rofi/main-menu.sh"
  ;;
*)
  exit 0
  ;;
esac
