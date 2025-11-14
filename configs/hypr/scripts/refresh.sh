#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/utils.sh"

# get argument if any
if [ "$1" == "no-notify" ]; then
    NO_NOTIFY=true
else
    NO_NOTIFY=false
fi

_ps=(waybar rofi swaync swww)
for p in "${_ps[@]}"; do
    kill_app "$p"
done

sleep 0.5
waybar &
swaync > /dev/null 2>&1 &
swaync-client --reload-config
swww-daemon

hyprctl reload

if [ "$NO_NOTIFY" = false ]; then
    notify-send -e -i reload "Refresh" "Refreshed Hyprland, Waybar and Swaync, Swww"
fi