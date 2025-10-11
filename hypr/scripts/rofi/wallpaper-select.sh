#!/bin/bash

# Directories and config
WALL_DIR="$HOME/Pictures/Wallpapers"
ROFI_DIR="$HOME/.config/rofi"
ROFI_THEME="$ROFI_DIR/config-wallpaper.rasi"
WALLPAPER_CURRENT="$HOME/.config/.wallpaper_current"
SCRIPTS_DIR="$HOME/.config/hypr/scripts"

# Save current working directory to return later
CWD="$(pwd)"

# swww transition configuration
FPS=144
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS=(
  --transition-fps "$FPS"
  --transition-type "$TYPE"
  --transition-duration "$DURATION"
  --transition-bezier "$BEZIER"
)

cd "$WALL_DIR" || {
  notify-send "Wallpaper Error" "Cannot access $WALL_DIR"
  exit 1
}

mapfile -t WALLPAPERS < <(find . -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  notify-send "Wallpaper Error" "No wallpapers found in $WALL_DIR"
  cd "$CWD"
  exit 1
fi

ROFI_INPUT=""
for wallpaper in "${WALLPAPERS[@]}"; do
  display_name=$(basename "$wallpaper")
  ROFI_INPUT+="$display_name\x00icon\x1f$wallpaper\n"
done

SELECTED_WALL=$(printf "%b" "$ROFI_INPUT" | rofi -dmenu -show-icons -config "$ROFI_THEME" -p "")

if [ -n "$SELECTED_WALL" ]; then
  if [[ -f "$WALL_DIR/$SELECTED_WALL" ]]; then
    mkdir -p "$(dirname "$WALLPAPER_CURRENT")"
    cp -f "$WALL_DIR/$SELECTED_WALL" "$WALLPAPER_CURRENT"


    swww img "$WALLPAPER_CURRENT" "${SWWW_PARAMS[@]}"
    matugen image "$WALLPAPER_CURRENT"
    "$SCRIPTS_DIR/refresh.sh" no-notify
    notify-send "Wallpaper Set" "$WALLPAPER_CURRENT"
  else
    notify-send "Wallpaper Error" "Selected wallpaper file not found"
  fi
else
  notify-send "Wallpaper" "No wallpaper selected"
fi

cd "$CWD"
