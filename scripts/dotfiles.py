#!/usr/bin/env python3
# Description: Install and configure dotfiles

import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SCRIPT_DIR))

from lib.module import Module
from lib.helper import show_step, show_info, show_warning, show_success, new_line
import os
import shutil

CONFIG_DIR = SCRIPT_DIR / "configs"

class DotFiles(Module):
    """Install and configure dotfiles"""

    name = "Dotfiles Configuration"
    description = "v1.0"
    title = "This script will configure dotfiles"
    messages = [
        "Creating symlinks",
    ]

    configs = [
        "btop",
        "fastfetch",
        "hypr",
        "kitty",
        "matugen",
        "quickshell",
        "rofi",
        "swaync",
        "waybar",
    ]
    
    def run(self):
        show_step("Configuring symlinks...")

        for config in self.configs:
            src_dir = CONFIG_DIR / config
            dest_dir = Path.home() / f".config/{config}"

            if not src_dir.exists():
                show_warning(f"Source directory {src_dir} does not exist. Skipping...")
                continue

            if dest_dir.exists() and dest_dir.is_symlink():
                show_info(f"Replacing existing symlink: {dest_dir}")
                dest_dir.unlink()
            elif dest_dir.exists() and not dest_dir.is_symlink():
                show_info(f"Destination {dest_dir} already exists. Deleting...")
                shutil.rmtree(dest_dir)
            
            os.symlink(src_dir, dest_dir)
            show_success(f"Created symlink: {dest_dir} -> {src_dir}")

        new_line()
        show_success("Dotfiles configuration completed successfully.")

if __name__ == "__main__":
    dotfiles_module = DotFiles()
    dotfiles_module.run()