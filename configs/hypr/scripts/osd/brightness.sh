#!/usr/bin/env bash

# SETTINGS
STEP=5 # percent per brightness step
APP_NAME="BrightnessOSD"
TITLE="Brightness"
ICON_BRIGHTNESS="display-brightness" # Change if you have a better icon

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
# Get brightness as percentage (e.g., 42%)
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
brightness_percent=$(awk "BEGIN {printf \"%d\", ($brightness / $max_brightness) * 100}")

# --- NOTIFY ---
notify-send -e -a "$APP_NAME" "$TITLE" "${brightness_percent}%" \
    -h string:x-canonical-private-synchronous:$APP_NAME \
    -h int:value:$brightness_percent \
    -i "$ICON_BRIGHTNESS" \
    -u low
