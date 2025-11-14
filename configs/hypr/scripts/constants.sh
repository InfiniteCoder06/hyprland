#!/usr/bin/env bash

source "$HOME/.config/hypr/scripts/variables.sh"

# SWWW
FPS=144
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
export SWWW_PARAMS=(
  --transition-fps "$FPS"
  --transition-type "$TYPE"
  --transition-duration "$DURATION"
  --transition-bezier "$BEZIER"
)

# Effects
export declare -A effects=(
  ["No Effects"]="no-effects"
  ["Black & White"]="magick $wallpaper_current -colorspace gray -sigmoidal-contrast 10,40% $wallpaper_effects"
  ["Blurred"]="magick $wallpaper_current -blur 0x10 $wallpaper_effects"
  ["Charcoal"]="magick $wallpaper_current -charcoal 0x5 $wallpaper_effects"
  ["Edge Detect"]="magick $wallpaper_current -edge 1 $wallpaper_effects"
  ["Emboss"]="magick $wallpaper_current -emboss 0x5 $wallpaper_effects"
  ["Frame Raised"]="magick $wallpaper_current +raise 150 $wallpaper_effects"
  ["Frame Sunk"]="magick $wallpaper_current -raise 150 $wallpaper_effects"
  ["Negate"]="magick $wallpaper_current -negate $wallpaper_effects"
  ["Oil Paint"]="magick $wallpaper_current -paint 4 $wallpaper_effects"
  ["Posterize"]="magick $wallpaper_current -posterize 4 $wallpaper_effects"
  ["Polaroid"]="magick $wallpaper_current -polaroid 0 $wallpaper_effects"
  ["Sepia Tone"]="magick $wallpaper_current -sepia-tone 65% $wallpaper_effects"
  ["Solarize"]="magick $wallpaper_current -solarize 80% $wallpaper_effects"
  ["Sharpen"]="magick $wallpaper_current -sharpen 0x5 $wallpaper_effects"
  ["Vignette"]="magick $wallpaper_current -vignette 0x3 $wallpaper_effects"
  ["Vignette-black"]="magick $wallpaper_current -background black -vignette 0x3 $wallpaper_effects"
  ["Zoomed"]="magick $wallpaper_current -gravity Center -extent 1:1 $wallpaper_effects"
)
