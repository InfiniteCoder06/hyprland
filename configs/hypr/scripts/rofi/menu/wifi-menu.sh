#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/variables.sh"

prompt_rofi() {
  rofi -dmenu -i -p "$1" -config "$rofi_default_theme"
}

get_options() {
  cat <<EOF
󰖩 Connect/Disconnect
󰖩 Turn On
󰖪 Turn Off
󰑓 Restart
 Go Back
EOF
}
ACTION=$(get_options | prompt_rofi "WiFi Menu")
case "$ACTION" in
*"Connect/Disconnect")
  NETWORK_LIST=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list --rescan yes | awk -F: '$1{ if(!seen[$1]++){print $0}}')
  CHOICE=$(printf '%s\n' "$NETWORK_LIST" | prompt_rofi "Select Network")
  [ -z "${CHOICE:-}" ] && exit 0
  SSID=${CHOICE%%:*}
  SSID=$(printf '%s' "$SSID")

  if nmcli -t -f ACTIVE,SSID dev wifi | awk -F: '$1=="yes"{print $2}' | grep -Fxq "$SSID"; then
    nmcli connection down "$SSID" && notify-send -e -i network-wireless-disabled-symbolic "WiFi" "Disconnected from $SSID"
    exit 0
  fi

  SECURITY=${CHOICE#*:}
  SECURITY=${SECURITY%%:*}
  if [ "$SECURITY" = "--" ] || [ -z "$SECURITY" ]; then
    if nmcli device wifi connect "$SSID"; then
      notify-send -e -i network-wireless-connected-symbolic "WiFi" "Connected to $SSID (open)"
    else
      notify-send -e -i network-wireless-error-symbolic "WiFi" "Failed to connect to $SSID"
    fi
  else
    PASSWORD=$(rofi -dmenu -password -p "Password for $SSID" -config "$rofi_default_theme")
    if [ -z "${PASSWORD:-}" ]; then
      notify-send -e -i network-wireless-error-symbolic "WiFi" "No password provided"
      exit 0
    fi
    if nmcli device wifi connect "$SSID" password "$PASSWORD"; then
      notify-send -e -i network-wireless-connected-symbolic "WiFi" "Connected to $SSID"
    else
      notify-send -e -i network-wireless-error-symbolic "WiFi" "Failed to connect to $SSID"
    fi
  fi
  ;;
*"Turn On")
  if nmcli radio wifi on; then
    notify-send -e -i network-wireless-connected-symbolic "WiFi" "WiFi turned on"
  else
    notify-send -e -i network-wireless-error-symbolic "WiFi" "Failed to turn WiFi on"
  fi
  ;;
*"Turn Off")
  if nmcli radio wifi off; then
    notify-send -e -i network-wireless-disabled-symbolic "WiFi" "WiFi turned off"
  else
    notify-send -e -i network-wireless-error-symbolic "WiFi" "Failed to turn WiFi off"
  fi
  ;;
*"Restart")
  if nmcli radio wifi off && sleep 2 && nmcli radio wifi on; then
    notify-send -e -i network-wireless-connected-symbolic "WiFi" "WiFi restarted"
  else
    notify-send -e -i network-wireless-error-symbolic "WiFi" "Failed to restart WiFi"
  fi
  ;;
*"Go Back")
  "$scripts_dir/rofi/main-menu.sh"
  ;;
*)
  exit 0
  ;;
esac
