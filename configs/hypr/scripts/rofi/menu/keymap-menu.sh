#!/bin/bash

show_keymaps() {
  cat <<EOF
󰌌 SUPER + RETURN → Open Terminal
󰖙 SUPER + Q → Close Active Window
󰖟 SUPER + B → Open Browser
󰉋 SUPER + E → Open File Manager
󰍉 SUPER + C → Main Menu
󰍉 SUPER + SPACE → Application Launcher
󰑓 SUPER + ALT + R → Refresh Scripts
󰅖 SUPER + V → Clipboard Manager
󰌾 SUPER + L → Lock Screen
󰊓 SUPER + SHIFT + F → Fullscreen
󰉌 SUPER + F → Toggle Floating
󰉌 SUPER + ALT + SPACE → All Float
󰐥 CTRL + ALT + DELETE → Power Menu
󰁍 SUPER + CTRL + D → Remove Master
󰁍 SUPER + I → Add Master
󰁍 SUPER + J → Cycle Next
󰁍 SUPER + K → Cycle Prev
󰁍 SUPER + CTRL + RETURN → Swap with Master
󰯌 SUPER + SHIFT + I → Toggle Split
󰘶 SUPER + P → Pseudo Tiling
󰐃 SUPER + M → Set Split Ratio 0.3
󰐃 SUPER + G → Toggle Group
󰐃 SUPER + CTRL + TAB → Change Group Active
󰖯 ALT + TAB → Cycle Next Window
󰖯 ALT + TAB → Bring Active to Top
󰍬 XF86AudioMicMute → Mic Mute
󰖁 XF86AudioMute → Toggle Mute
󰃞 XF86MonBrightnessUp → Brightness Up
󰃝 XF86MonBrightnessDown → Brightness Down
󰕾 XF86AudioRaiseVolume → Volume Up
󰕿 XF86AudioLowerVolume → Volume Down
󰹑 PRINT → Screenshot Screen
󰹑 SUPER + PRINT → Screenshot Area
󰩨 SUPER + SHIFT + ← → Resize Left
󰩨 SUPER + SHIFT + → → Resize Right
󰩨 SUPER + SHIFT + ↑ → Resize Up
󰩨 SUPER + SHIFT + ↓ → Resize Down
󰜸 SUPER + CTRL + ← → Move Window Left
󰜸 SUPER + CTRL + → → Move Window Right
󰜸 SUPER + CTRL + ↑ → Move Window Up
󰜸 SUPER + CTRL + ↓ → Move Window Down
󰜸 SUPER + ALT + ← → Swap Window Left
󰜸 SUPER + ALT + → → Swap Window Right
󰜸 SUPER + ALT + ↑ → Swap Window Up
󰜸 SUPER + ALT + ↓ → Swap Window Down
󰁍 SUPER + ← → Move Focus Left
󰁍 SUPER + → → Move Focus Right
󰁍 SUPER + ↑ → Move Focus Up
󰁍 SUPER + ↓ → Move Focus Down
󰍽 SUPER + TAB → Next Workspace
󰍽 SUPER + SHIFT + TAB → Previous Workspace
󱂩 SUPER + U → Toggle Special Workspace
󰜸 SUPER + SHIFT + U → Move to Special Workspace
󱂬 SUPER + 1 → Switch to Workspace 1
󱂬 SUPER + 2 → Switch to Workspace 2
󱂬 SUPER + 3 → Switch to Workspace 3
󱂬 SUPER + 4 → Switch to Workspace 4
󱂬 SUPER + 5 → Switch to Workspace 5
󱂬 SUPER + 6 → Switch to Workspace 6
󱂬 SUPER + 7 → Switch to Workspace 7
󱂬 SUPER + 8 → Switch to Workspace 8
󱂬 SUPER + 9 → Switch to Workspace 9
󱂬 SUPER + 0 → Switch to Workspace 10
󰜸 SUPER + SHIFT + 1 → Move to Workspace 1
󰜸 SUPER + SHIFT + 2 → Move to Workspace 2
󰜸 SUPER + SHIFT + 3 → Move to Workspace 3
󰜸 SUPER + SHIFT + 4 → Move to Workspace 4
󰜸 SUPER + SHIFT + 5 → Move to Workspace 5
󰜸 SUPER + SHIFT + 6 → Move to Workspace 6
󰜸 SUPER + SHIFT + 7 → Move to Workspace 7
󰜸 SUPER + SHIFT + 8 → Move to Workspace 8
󰜸 SUPER + SHIFT + 9 → Move to Workspace 9
󰜸 SUPER + SHIFT + 0 → Move to Workspace 10
󰜸 SUPER + CTRL + 1 → Move Silent to Workspace 1
󰜸 SUPER + CTRL + 2 → Move Silent to Workspace 2
󰜸 SUPER + CTRL + 3 → Move Silent to Workspace 3
󰜸 SUPER + CTRL + 4 → Move Silent to Workspace 4
󰜸 SUPER + CTRL + 5 → Move Silent to Workspace 5
󰜸 SUPER + CTRL + 6 → Move Silent to Workspace 6
󰜸 SUPER + CTRL + 7 → Move Silent to Workspace 7
󰜸 SUPER + CTRL + 8 → Move Silent to Workspace 8
󰜸 SUPER + CTRL + 9 → Move Silent to Workspace 9
󰜸 SUPER + CTRL + 0 → Move Silent to Workspace 10
󰜸 SUPER + SHIFT + [ → Move to Workspace -1
󰜸 SUPER + SHIFT + ] → Move to Workspace +1
󰜸 SUPER + CTRL + [ → Move Silent to Workspace -1
󰜸 SUPER + CTRL + ] → Move Silent to Workspace +1
󰍽 SUPER + MOUSE DOWN → Next Workspace
󰍽 SUPER + MOUSE UP → Previous Workspace
󰍽 SUPER + . → Next Workspace
󰍽 SUPER + , → Previous Workspace
󰆧 SUPER + LMB DRAG → Move Window
󰩨 SUPER + RMB DRAG → Resize Window
EOF
}

# Function to show category-based view
show_categories() {
  CATEGORY=$(echo -e "󰍉 All Keybindings\n󰇘 Window Management\n󱂬 Workspaces\n󰝚 Media Controls\n󰕾 System Controls\n󰹑 Screenshots\n󰍉 Applications" | rofi -dmenu -i -p "Keymap Categories")

  case "$CATEGORY" in
  *"All Keybindings")
    show_keymaps | rofi -dmenu -i -p "Keybindings" -no-custom
    ;;
  *"Window Management")
    show_keymaps | grep -E "(Move Focus|Move Window|Resize|Close|Float|Split|Fullscreen|Drag)" | rofi -dmenu -i -p "Window Management" -no-custom
    ;;
  *"Workspaces")
    show_keymaps | grep -E "(Workspace|Special)" | rofi -dmenu -i -p "Workspace Keys" -no-custom
    ;;
  *"Media Controls")
    show_keymaps | grep -E "(Volume|Brightness|Mute)" | rofi -dmenu -i -p "Media Controls" -no-custom
    ;;
  *"System Controls")
    show_keymaps | grep -E "(Power|Lock|Mute)" | rofi -dmenu -i -p "System Controls" -no-custom
    ;;
  *"Screenshots")
    show_keymaps | grep -E "(Screenshot|PRINT)" | rofi -dmenu -i -p "Screenshot Keys" -no-custom
    ;;
  *"Applications")
    show_keymaps | grep -E "(Terminal|Browser|File Manager|Menu|Clipboard)" | rofi -dmenu -i -p "Application Keys" -no-custom
    ;;
  esac
}

# Main logic - directly show categories
show_categories
