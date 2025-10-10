#!/bin/bash

# get argument if any
if [ "$1" == "no-notify" ]; then
    NO_NOTIFY=true
else
    NO_NOTIFY=false
fi

_ps=(waybar rofi swaync swww)
for p in "${_ps[@]}"; do
    if pidof "$p" >/dev/null; then
        killall "$p"
    fi
done

sleep 0.5
waybar &
swaync > /dev/null 2>&1 &
swaync-client --reload-config
swww-daemon

hyprctl reload

if [ "$NO_NOTIFY" = false ]; then
    notify-send "Refresh" "Refreshed Hyprland, Waybar and Swaync, Swww"
fi