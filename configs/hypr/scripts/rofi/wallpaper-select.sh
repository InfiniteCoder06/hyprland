#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/constants.sh"
source "$HOME/.config/hypr/scripts/utils.sh"
source "$HOME/.config/hypr/scripts/variables.sh"

check_dir_exists "$wallpaper_dir" || {
  notify-send -e -i dialog-warning-symbolic "Wallpaper Error" "$wallpaper_dir does not exist"
  exit 1
}

mapfile -t WALLPAPERS < <(find "$wallpaper_dir" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  notify-send -e -i dialog-warning-symbolic "Wallpaper Error" "No wallpapers found in $wallpaper_dir"
  cd "$CWD" || exit
  exit 1
fi

ROFI_INPUT=""
for wallpaper in "${WALLPAPERS[@]}"; do
  display_name=$(basename "$wallpaper")
  ROFI_INPUT+="$display_name\x00icon\x1f$wallpaper\n"
done

SELECTED_WALL=$(printf "%b" "$ROFI_INPUT" | rofi -dmenu -p "Wallpaper" -show-icons -config "$rofi_image_theme" -p "")

if [ -n "$SELECTED_WALL" ]; then
  if [[ -f "$wallpaper_dir/$SELECTED_WALL" ]]; then
    cp -f "$wallpaper_dir/$SELECTED_WALL" "$wallpaper_current"
    apply_wallpaper "$wallpaper_current" "Wallpaper set to $SELECTED_WALL" checkmark-symbolic
  else
    notify-send -e -i dialog-warning-symbolic "Wallpaper Error" "Selected wallpaper file not found"
  fi
fi
