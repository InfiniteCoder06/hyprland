#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/utils.sh"
source "$HOME/.config/hypr/scripts/variables.sh"

mapfile -t ANIMATIONS < <(find "$animations_dir" -maxdepth 1 -type f -name '*.conf' -printf '%f\n' | sort)

if [ ${#ANIMATIONS[@]} -eq 0 ]; then
  notify-send -e -u low "Error" "No animation files found"
  exit 1
fi

for i in "${!ANIMATIONS[@]}"; do
  name="${ANIMATIONS[$i]}"
  ANIMATIONS[$i]="${ANIMATIONS[$i]%.conf}"
done

chosen_file=$(printf '%s\n' "${ANIMATIONS[@]}" | rofi -i -dmenu -config "$rofi_default_theme" -p "Animations")

if [[ -n "$chosen_file" ]]; then
  full_path="$animations_dir/$chosen_file.conf"
  cp "$full_path" "$hypr_config_dir/animations.conf"
  notify-send -e -u low "$chosen_file" "Hyprland Animation Loaded"
fi
