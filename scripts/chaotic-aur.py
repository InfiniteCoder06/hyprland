#!/usr/bin/env python3
# Description: Add Chaotic-AUR repository to the system

import sys
import subprocess
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SCRIPT_DIR))

from lib.module import Module
from lib.helper import show_step, show_info, show_warning, show_success, pkg_installed, new_line, repo_chaotic_exists

class ChaoticAUR(Module):
    """Add Chaotic-AUR repository to the system"""

    name = "Chaotic-AUR Repository"
    description = "v1.0"
    title = "This script will configure the Chaotic-AUR repository"
    messages = [
        "Install Chaotic-AUR keyring",
        "Add repository to pacman.conf",
        "Update package database",
    ]

    def install_keyring(self):
        show_step("Installing Chaotic-AUR keyring...")

        if pkg_installed("chaotic-keyring"):
            show_info("Chaotic-AUR keyring is already installed. Skipping...")
            return

        commands = [
            ["sudo", "pacman-key", "--recv-key", "3056513887B78AEB", "--keyserver", "keyserver.ubuntu.com"],
            ["sudo", "pacman-key", "--lsign-key", "3056513887B78AEB"],
            ["sudo", "pacman", "-U", "--noconfirm", "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst"],
            ["sudo", "pacman", "-U", "--noconfirm", "https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst"]
        ]

        try:
            for command in commands:
                subprocess.run(command, check=True, capture_output=True)
        except subprocess.CalledProcessError as e:
            show_warning(f"Failed to install Chaotic-AUR keyring: {e}")
            return

        show_success("Chaotic-AUR keyring installed successfully.")
    
    def add_repository(self):
        show_step("Adding Chaotic-AUR repository to pacman.conf...")

        try:
            if repo_chaotic_exists():
                show_info("Chaotic-AUR repository already exists in pacman.conf. Skipping...")
                return

            repo_entry = "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n"
            subprocess.run(["sudo", "tee", "-a", "/etc/pacman.conf"], input=repo_entry.encode(), check=True, capture_output=True)

            show_success("Chaotic-AUR repository added to pacman.conf successfully.")
        except Exception as e:
            show_warning(f"Failed to add Chaotic-AUR repository: {e}")

    def update_package_database(self):
        show_step("Updating package database...")
        try:
            subprocess.run(["sudo", "pacman", "-Sy"], check=True, capture_output=True)
            show_success("Package database updated successfully.")
        except subprocess.CalledProcessError as e:
            show_warning(f"Failed to update package database: {e}")

    def run(self):
        self.install_keyring()
        self.add_repository()
        self.update_package_database()

        new_line()
        show_success("Chaotic-AUR configuration completed successfully.")

if __name__ == "__main__":
    chaoticaur_module = ChaoticAUR()
    chaoticaur_module.run()