#!/bin/bash

show_header() {
    local SCRIPT_NAME="$1"
    local SCRIPT_VERSION="$2"
    gum style \
        --foreground 212 \
        --border-foreground 212 \
        --border double \
        --align center \
        --width 50 \
        --margin "1 2" \
        --padding "1 4" \
        "$SCRIPT_NAME $SCRIPT_VERSION"
}

show_step() {
    gum style --foreground 117 --bold "▶ $1"
}

show_info() {
    gum style --foreground 39 " $1"
}

show_success() {
    gum style --foreground 120 " $1"
}

show_warning() {
    gum style --foreground 220 " $1"
}

show_error() {
    gum style --foreground 196 --bold " $1"
}


check_command() {
    command -v "$1" &>/dev/null
}

check_and_install_gum() {
    if ! command -v gum &> /dev/null; then
        echo "gum not found. Installing gum..."
        sudo pacman -S --needed --noconfirm gum > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            show_success "gum installed successfully."
        else
            echo "Failed to install gum. Please install it manually and re-run the script."
            exit 1
        fi
    else
        show_success "gum is already installed."
    fi
}

check_internet() {
    if ! ping -c 1 -W 2 ping.archlinux.org &>/dev/null; then
        show_error "No internet connection detected"
        exit 1
    fi
}

clear_screen() {
    clear || printf '\033c'
}

pkg_installed() {
    pacman -Qi "$1" &>/dev/null
}

repo_chaotic_exists() {
    grep -q "\[chaotic-aur\]" /etc/pacman.conf
}