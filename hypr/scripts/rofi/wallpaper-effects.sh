#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/constants.sh"
source "$HOME/.config/hypr/scripts/utils.sh"
source "$HOME/.config/hypr/scripts/variables.sh"

options=("No Effects")
for effect in "${!effects[@]}"; do
    [[ "$effect" != "No Effects" ]] && options+=("$effect")
done

choice=$(printf "%s\n" "${options[@]}" | LC_COLLATE=C sort | rofi -dmenu -i -config $rofi_default_theme)

if [ -n "$choice" ]; then
    if [[ "$choice" == "No Effects" ]]; then
        apply_wallpaper "$wallpaper_current" "Effects removed"
    elif [[ "${effects[$choice]+exists}" ]]; then
        notify-send -u low "Wallpaper" "Applying effect: $choice"
        eval "${effects[$choice]}" &
        wait $!
        apply_wallpaper "$wallpaper_effects" "Effect applied: $choice"
    else
        echo "Effect '$choice' not recognized."
    fi
else
    notify-send "Wallpaper" "No choice selected"
fi