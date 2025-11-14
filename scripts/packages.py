#!/usr/bin/env python3
# Description: Install essential packages from official repos and AUR

import sys
import subprocess
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SCRIPT_DIR))

from lib.module import Module
from lib.helper import (
    show_step, show_info, show_success, show_error, show_warning,
    pkg_installed, check_command, repo_chaotic_exists, check_internet, new_line
)

class Packages(Module):
    """Install essential packages from official repos and AUR"""

    name = "Package Installation"
    description = "v1.0"
    title = "This script will install packages"
    messages = [
        "Remove conflicting packages",
        "Install official repository packages",
        "Install paru AUR helper (if needed)",
        "Install AUR packages",
    ]

    OFFICIAL_PACKAGES = [
        "blueman",
        "bluetui",
        "brightnessctl",
        "btop",
        "fastfetch",
        "fd",
        "git",
        "gnome-keyring",
        "gtk-engine-murrine",
        "hypridle",
        "hyprlock",
        "hyprpicker",
        "hyprpolkitagent",
        "imagemagick",
        "kvantum",
        "kvantum-qt5",
        "libnotify",
        "matugen",
        "nautilus",
        "neovim",
        "nwg-look",
        "otf-overpass-nerd",
        "power-profiles-daemon",
        "qt5ct",
        "qt6ct",
        "ripgrep",
        "ripgrep-all",
        "rofi",
        "satty",
        "swaync",
        "swww",
        "ttf-jetbrains-mono-nerd",
        "waybar",
    ]

    AUR_PACKAGES = [
        "clipse",
        "grimblast-git",
        "nautilus-admin-gtk4",
        "nautilus-code-git",
        "nautilus-open-any-terminal",
        "paruz",
        "rofi-bluetooth",
        "visual-studio-code-bin",
        "zen-browser-bin",
    ]

    CONFLICTING_PACKAGES = [
        "dolphin",
        "dunst",
        "htop",
        "polkit-kde-agent",
        "wofi",
        "vim",
        "uwst",
    ]

    def remove_conflicting(self):
        """Remove conflicting packages"""
        show_step("Checking for conflicting packages...")
        
        to_remove = [pkg for pkg in self.CONFLICTING_PACKAGES if pkg_installed(pkg)]
        
        if to_remove:
            show_info(f"Found conflicting packages: {', '.join(to_remove)}")
            # Using gum confirm
            try:
                result = subprocess.run(
                    ["gum", "confirm", "Remove these packages?"],
                )
                if result.returncode == 0:
                    subprocess.run(
                        ["sudo", "pacman", "-Rns", "--noconfirm"] + to_remove,
                        check=True,
                        capture_output=True
                    )
                    show_success("Conflicting packages removed")
            except subprocess.CalledProcessError as e:
                show_warning(f"Failed to remove conflicting packages: {e}")
        else:
            show_success("No conflicting packages found")
        
        new_line()

    def install_official_packages(self):
        """Install official repository packages"""
        show_step("Installing official repository packages...")
        
        to_install = [pkg for pkg in self.OFFICIAL_PACKAGES if not pkg_installed(pkg)]
        
        if to_install:
            show_info(f"Installing: {', '.join(to_install)}")
            try:
                subprocess.run(
                    ["sudo", "pacman", "-S", "--needed", "--noconfirm"] + to_install,
                    check=True,
                    capture_output=True
                )
                show_success("Official repository packages installed")
            except subprocess.CalledProcessError as e:
                show_error(f"Failed to install official packages: {e}")
        else:
            show_success("All official repository packages are already installed")
        
        new_line()

    def install_paru(self):
        """Install paru AUR helper"""
        show_step("Checking for paru AUR helper...")
        
        if not check_command("paru"):
            show_info("Installing paru...")
            
            if repo_chaotic_exists():
                try:
                    subprocess.run(
                        ["sudo", "pacman", "-S", "--needed", "--noconfirm", "paru"],
                        check=True,
                        capture_output=True
                    )
                    show_success("paru installed successfully via Chaotic-AUR")
                    new_line()
                    return
                except subprocess.CalledProcessError as e:
                    show_warning(f"Failed to install paru via Chaotic-AUR: {e}")
            
            # Build from AUR
            try:
                import tempfile
                
                with tempfile.TemporaryDirectory() as tmpdir:
                    clone_dir = Path(tmpdir) / "paru"
                    subprocess.run(
                        ["git", "clone", "https://aur.archlinux.org/paru.git", str(clone_dir)],
                        check=True,
                        capture_output=True
                    )
                    subprocess.run(
                        ["makepkg", "-si", "--noconfirm"],
                        cwd=clone_dir,
                        check=True,
                        capture_output=True
                    )
                show_success("paru installed successfully")
            except subprocess.CalledProcessError as e:
                show_error(f"Failed to install paru: {e}")
        else:
            show_success("paru is already installed")
        
        new_line()

    def install_aur_packages(self):
        """Install AUR packages"""
        show_step("Installing AUR packages...")
        
        if not check_command("paru"):
            show_error("paru not found, skipping AUR packages")
            return
        
        to_install = [pkg for pkg in self.AUR_PACKAGES if not pkg_installed(pkg)]
        
        if to_install:
            show_info(f"Installing from AUR: {', '.join(to_install)}")
            try:
                subprocess.run(
                    ["paru", "-S", "--needed", "--noconfirm"] + to_install,
                    check=True,
                    capture_output=True
                )
                show_success("AUR packages installed")
            except subprocess.CalledProcessError as e:
                show_warning(f"Failed to install AUR packages: {e}")
        else:
            show_success("All AUR packages already installed")
        
        new_line()

    def run(self):
        check_internet()
        self.remove_conflicting()
        self.install_official_packages()
        self.install_paru()
        self.install_aur_packages()
        
        show_success("Package installation complete!")

if __name__ == "__main__":
    packages_module = Packages()
    packages_module.run()
