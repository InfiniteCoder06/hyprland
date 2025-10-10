#!/bin/bash

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

notify-send "Refresh" "Refreshed Hyprland, Waybar and Swaync, Swww"