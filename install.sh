#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

CONFIGS=(
  btop
  fastfetch
  hypr
  kitty
  matugen
  quickshell
  rofi
  swaync
  waybar
)

# Target base directory for configs
TARGET_DIR="$HOME/.config"

# Loop over each config and create symlink
for config in "${CONFIGS[@]}"; do
  SRC="$DOTFILES_DIR/$config"
  DEST="$TARGET_DIR/$config"

  # Check if source exists
  if [ ! -d "$SRC" ]; then
    echo "Source not found: $SRC"
    continue
  fi

  # Remove existing destination if it's a symlink
  if [ -L "$DEST" ]; then
    echo "Replacing existing symlink: $DEST"
    rm "$DEST"
  elif [ -e "$DEST" ]; then
    echo "Skipping existing real file/folder: $DEST"
    continue
  fi

  # Create symlink
  ln -s "$SRC" "$DEST"
  echo "Linked $SRC → $DEST"
done
