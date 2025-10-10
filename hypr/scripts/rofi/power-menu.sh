#!/bin/bash

# Power menu options
options="  Logout\n  Reboot\n⏻  Shutdown\n  Suspend\n  Lock"

# Launch Rofi with the options
chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -config ~/.config/rofi/config.rasi)

case $chosen in
    "  Logout")
        hyprctl dispatch exit
        ;;
    "  Reboot")
        systemctl reboot
        ;;
    "⏻  Shutdown")
        systemctl poweroff
        ;;
    "  Suspend")
        systemctl suspend
        ;;
    "  Lock")
        hyprlock
        ;;
    *)
        exit 1
        ;;
esac