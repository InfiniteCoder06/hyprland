#!/usr/bin/env bash

kill_app() {
  local app_name="$1"
  if pidof "$app_name" > /dev/null; then
    pkill "$app_name"
  fi
}

check_dir_exists() {
  local dir_path="$1"

  if [ -d "$dir_path" ]; then
    return 0
  else
    return 1
  fi
}