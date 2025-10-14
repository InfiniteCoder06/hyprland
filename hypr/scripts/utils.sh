#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/constants.sh"

kill_app() {
  local app_name="$1"
  if pidof "$app_name" > /dev/null; then
    pkill "$app_name"
  fi
}

check_dir_exists() {
  local dir_path="$1"

  if [ -d "$dir_path" ]; then
    return 0
  else
    return 1
  fi
}

apply_wallpaper() {
  local wallpaper_path="$1"
  local notify_msg="$2"

  swww img "$wallpaper_path" "${SWWW_PARAMS[@]}"
  matugen image "$wallpaper_path"
  "$scripts_dir/refresh.sh" no-notify
  notify-send "Wallpaper" "$notify_msg"
}