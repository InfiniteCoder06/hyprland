#!/bin/bash

# Directories and config
WALL_DIR="$HOME/Pictures/Wallpapers"
ROFI_DIR="$HOME/.config/rofi"
ROFI_THEME="$ROFI_DIR/config-wallpaper.rasi"
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

# Move to wallpaper directory or exit if not accessible
cd "$WALL_DIR" || {
  notify-send "Wallpaper Error" "Cannot access $WALL_DIR"
  exit 1
}

# Gather wallpaper files (case-insensitive extensions)
mapfile -t WALLPAPERS < <(find . -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.png' \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  notify-send "Wallpaper Error" "No wallpapers found in $WALL_DIR"
  cd "$CWD"
  exit 1
fi

# Build rofi menu input with icons
ROFI_INPUT=""
for wallpaper in "${WALLPAPERS[@]}"; do
  display_name=$(basename "$wallpaper")
  # Append with null char and icon metadata for rofi
  ROFI_INPUT+="$display_name\x00icon\x1f$wallpaper\n"
done

# Launch rofi menu to select wallpaper
SELECTED_WALL=$(printf "%b" "$ROFI_INPUT" | rofi -dmenu -show-icons -config "$ROFI_THEME" -p "")

if [ -n "$SELECTED_WALL" ]; then
  # Confirm file exists before setting wallpaper
  if [[ -f "$WALL_DIR/$SELECTED_WALL" ]]; then
    swww img "$WALL_DIR/$SELECTED_WALL" "${SWWW_PARAMS[@]}"
    matugen image "$WALL_DIR/$SELECTED_WALL"
    "$SCRIPTS_DIR/refresh.sh" no-notify
    notify-send "Wallpaper Set" "$SELECTED_WALL"
  else
    notify-send "Wallpaper Error" "Selected wallpaper file not found"
  fi
else
  notify-send "Wallpaper" "No wallpaper selected"
fi

# Return to original directory
cd "$CWD"
