#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/variables.sh"

# Power menu options
options="  Logout\n  Reboot\n⏻  Shutdown\n  Suspend\n  Lock"

# Launch Rofi with the options
chosen=$(echo -e "$options" | rofi -dmenu -p "Power Menu" -config $rofi_default_theme)

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
    "  Suspend")
        systemctl suspend
        ;;
    "  Lock")
        hyprlock
        ;;
    *)
        exit 1
        ;;
esac