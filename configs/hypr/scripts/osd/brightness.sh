#!/usr/bin/env bash

# SETTINGS
STEP=5 # percent per brightness step
APP_NAME="BrightnessOSD"
TITLE="Brightness"
ICON_BRIGHTNESS="display-brightness"

# --- ARGUMENT PARSING ---
case "$1" in
up)
  brightnessctl set ${STEP}%+
  ;;
down)
  brightnessctl set ${STEP}%-
  ;;
*)
  echo "Usage: $0 {up|down}"
  exit 1
  ;;
esac

# --- GET STATUS ---
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
brightness_percent=$(awk "BEGIN {printf \"%d\", ($brightness / $max_brightness) * 100}")

# --- NOTIFY ---
notify-send -e -a "$APP_NAME" "$TITLE" "${brightness_percent}%" \
  -h boolean:SWAYNC_BYPASS_DND:true \
  -h string:x-canonical-private-synchronous:$APP_NAME \
  -h int:value:"$brightness_percent" \
  -i "$ICON_BRIGHTNESS" \
  -u low
