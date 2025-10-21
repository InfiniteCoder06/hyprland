#!/usr/bin/env python3

import subprocess
import shutil
import socket
import sys
import os

def run_gum_style(*args):
    """Run gum style with given arguments"""
    try:
        subprocess.run(["gum", "style", *args], check=True)
    except subprocess.CalledProcessError:
        print("Failed to run gum style")
        sys.exit(1)

def show_header(script_name, script_version):
    run_gum_style(
        "--foreground", "212",
        "--border-foreground", "212",
        "--border", "double",
        "--align", "center",
        "--width", "50",
        "--margin", "1 2",
        "--padding", "1 4",
        f"{script_name} {script_version}"
    )

def show_step(message):
    run_gum_style(
        "--foreground", "117",
        "--bold",
        f"▶ {message}"
    )

def show_sub_step(message):
    run_gum_style(
        "--foreground", "147",
        f"  • {message}"
    )

def show_info(message):
    run_gum_style(
        "--foreground", "39",
        f" {message}"
    )

def show_success(message):
    run_gum_style(
        "--foreground", "120",
        f" {message}"
    )

def show_warning(message):
    run_gum_style(
        "--foreground", "220",
        f" {message}"
    )

def show_error(message):
    run_gum_style(
        "--foreground", "196",
        "--bold",
        f" {message}"
    )
    sys.exit(1)

def check_command(cmd):
    return shutil.which(cmd) is not None

def check_and_install_gum():
    if not check_command("gum"):
        print("gum not found. Attempting to install gum via pacman...")
        try:
            subprocess.run(
                ["sudo", "pacman", "-S", "--needed", "--noconfirm", "gum"],
                check=True,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            show_success("gum installed successfully.")
        except subprocess.CalledProcessError:
            print("Failed to install gum. Please install it manually and re-run the script.")
            sys.exit(1)
    else:
        show_success("gum is already installed.")

def check_internet(host="ping.archlinux.org", port=80, timeout=2):
    try:
        socket.create_connection((host, port), timeout=timeout)
        return True
    except OSError:
        show_error("No internet connection detected")
        return False

def clear_screen():
    os.system('clear' if os.name == 'posix' else 'cls')

def new_line():
    print()

def pkg_installed(pkg_name):
    result = subprocess.run(
        ["pacman", "-Qi", pkg_name],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    return result.returncode == 0

def repo_chaotic_exists():
    try:
        with open("/etc/pacman.conf", "r") as f:
            return "[chaotic-aur]" in f.read()
    except FileNotFoundError:
        show_error("/etc/pacman.conf not found.")
        return False