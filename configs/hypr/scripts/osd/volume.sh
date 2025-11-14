#!/usr/bin/env bash

# SETTINGS
STEP=5 # percent per volume step
APP_NAME="VolumeOSD"
TITLE="Volume"
SINK="@DEFAULT_AUDIO_SINK@"

get_icon_volume() {
  local volume_value=$1
  if [ "$volume_value" -eq 0 ]; then
    echo "audio-volume-muted"
  elif [ "$volume_value" -le 30 ]; then
    echo "audio-volume-low"
  elif [ "$volume_value" -le 70 ]; then
    echo "audio-volume-medium"
  else
    echo "audio-volume-high"
  fi
}

get_volume() {
  volume=$(wpctl get-volume "$SINK" | awk '{printf "%.0f", $2 * 100}')
  echo "$volume"
}

# --- ARGUMENT PARSING ---
case "$1" in
up)
  if [ "$(get_volume)" -lt 100 ]; then
    wpctl set-volume "$SINK" ${STEP}%+
  fi
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

# --- GET STATUS ---
volume=$(get_volume)
muted=$(wpctl get-volume "$SINK" | grep -q MUTED && echo true || echo false)

# --- NOTIFY ---
if [ "$muted" = "true" ]; then
  notify-send -e -a "$APP_NAME" "$TITLE" "Muted" \
    -h boolean:SWAYNC_BYPASS_DND:true \
    -h string:x-canonical-private-synchronous:$APP_NAME \
    -h int:value:0 \
    -i "$(get_icon_volume 0)"
else
  notify-send -e -a "$APP_NAME" "$TITLE" "$volume%" \
    -h boolean:SWAYNC_BYPASS_DND:true \
    -h string:x-canonical-private-synchronous:$APP_NAME \
    -h int:value:"$volume" \
    -i "$(get_icon_volume "$volume")"
fi
