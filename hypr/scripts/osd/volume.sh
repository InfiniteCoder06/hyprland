#!/usr/bin/env bash

# SETTINGS
STEP=5 # percent per volume step
APP_NAME="VolumeOSD"
TITLE="Volume"
ICON_VOLUME="audio-volume-high"
ICON_MUTED="audio-volume-muted"
SINK="@DEFAULT_AUDIO_SINK@"

# --- ARGUMENT PARSING ---
case "$1" in
    up)
        wpctl set-volume "$SINK" ${STEP}%+
        ;;
    down)
        wpctl set-volume "$SINK" ${STEP}%-
        ;;
    mute)
        wpctl set-mute "$SINK" toggle
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac

# --- GET STATUSrightnessctl s 5%+ ---
volume_raw=$(wpctl get-volume "$SINK" | awk '{print $2}')
muted=$(wpctl get-volume "$SINK" | grep -q MUTED && echo true || echo false)
volume=$(awk "BEGIN {printf \"%d\", $volume_raw * 100}")

# --- NOTIFY ---
if [ "$muted" = "true" ]; then
    notify-send -e -a "$APP_NAME" "$TITLE" "Muted" \
        -h string:x-canonical-private-synchronous:$APP_NAME \
        -h int:value:0 \
        -i "$ICON_MUTED" \
        -u low
else
    notify-send -e -a "$APP_NAME" "$TITLE" "$volume%" \
        -h string:x-canonical-private-synchronous:$APP_NAME \
        -h int:value:$volume \
        -i "$ICON_VOLUME" \
        -u low
fi
