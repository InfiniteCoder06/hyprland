#!/usr/bin/env bash

# SWWW
FPS=144
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS=(
  --transition-fps "$FPS"
  --transition-type "$TYPE"
  --transition-duration "$DURATION"
  --transition-bezier "$BEZIER"
)