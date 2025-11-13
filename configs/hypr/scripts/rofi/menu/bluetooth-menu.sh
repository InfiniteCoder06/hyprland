#!/usr/bin/env bash
source "$HOME/.config/hypr/scripts/variables.sh"

get_options() {
  cat <<EOF
󰂯 Connect/Disconnect Device
󰂯 Turn On
󰂲 Turn Off
󰑓 Restart
 Go Back
EOF
}

show_devices() {
  bluetoothctl devices | sed 's/^Device //' | while read -r mac name_rest; do
    mac_addr="$mac"
    name=$(echo "$name_rest" | sed 's/^ *//')
    if bluetoothctl info "$mac_addr" | grep -q "Connected: yes"; then
      echo " $mac_addr $name (Connected)"
    else
      echo " $mac_addr $name"
    fi
  done
}

pkill -u "$USER" -x rofi &>/dev/null || true

ACTION=$(get_options | rofi -dmenu -i -p "Bluetooth" -config "$rofi_default_theme")

case "$ACTION" in
*"Connect/Disconnect"*)
  if ! bluetoothctl show | grep -q "Powered: yes"; then
    notify-send "Bluetooth" "Bluetooth is off. Turning it on..."
    bluetoothctl power on
    sleep 2
  fi

  DEVICE_LIST=$(show_devices)
  if [ -z "$DEVICE_LIST" ]; then
    notify-send "Bluetooth" "No devices found."
    exit 0
  fi

  DEVICE=$(echo "$DEVICE_LIST" | rofi -dmenu -i -p "Select Device" -config "$rofi_default_theme")
  [ -z "$DEVICE" ] && exit 0

  MAC=$(echo "$DEVICE" | awk '{print $2}')
  if bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$MAC" >/dev/null
    notify-send "󰂲 Bluetooth" "Disconnected from $(echo "$DEVICE" | cut -d' ' -f3-)"
  else
    bluetoothctl connect "$MAC" >/dev/null
    notify-send "󰂯 Bluetooth" "Connected to $(echo "$DEVICE" | cut -d' ' -f3-)"
  fi
  ;;

*"Turn On"*)
  bluetoothctl power on >/dev/null
  notify-send "󰂯 Bluetooth" "Bluetooth turned on"
  ;;

*"Turn Off"*)
  bluetoothctl power off >/dev/null
  notify-send "󰂲 Bluetooth" "Bluetooth turned off"
  ;;

*"Restart"*)
  bluetoothctl power off >/dev/null
  sleep 2
  bluetoothctl power on >/dev/null
  notify-send "󰑓 Bluetooth" "Bluetooth restarted"
  ;;
*"Go Back"*)
  "$scripts_dir/rofi/main-menu.sh"
  ;;
*)
  exit 0
  ;;
esac
