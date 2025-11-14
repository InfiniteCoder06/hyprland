#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/constants.sh"
source "$HOME/.config/hypr/scripts/utils.sh"
source "$HOME/.config/hypr/scripts/variables.sh"

options=("No Effects")
for effect in "${!effects[@]}"; do
  [[ "$effect" != "No Effects" ]] && options+=("$effect")
done

choice=$(printf "%s\n" "${options[@]}" | LC_COLLATE=C sort | rofi -dmenu -p "Effects" -i -config "$rofi_default_theme")

if [ -n "$choice" ]; then
  if [[ "$choice" == "No Effects" ]]; then
    apply_wallpaper "$wallpaper_current" "Effects removed" cross-small-symbolic
  elif [[ "${effects[$choice]+exists}" ]]; then
    notify-send -e -i process-working-symbolic "Wallpaper" "Applying effect: $choice"
    eval "${effects[$choice]}" &
    wait $!
    apply_wallpaper "$wallpaper_effects" "Effect applied: $choice" checkmark-symbolic
  else
    echo "Effect '$choice' not recognized."
  fi
fi
