#!/usr/bin/env python3
# Description: Configure Plymouth boot splash screen

import sys
import subprocess
import re
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SCRIPT_DIR))

from lib.module import Module
from lib.helper import (
    show_step, show_info, show_success, show_warning, pkg_installed, new_line
)

class Plymouth(Module):
    """Configure Plymouth boot splash screen"""

    name = "Plymouth Configuration"
    description = "v1.0"
    title = "This script will install and configure Plymouth boot splash screen"
    messages = [
        "Install Plymouth and themes",
        "Set up Plymouth to work with the bootloader",
    ]

    def install_plymouth(self):
        """Install Plymouth and themes"""
        show_step("Installing Plymouth and themes...")
        
        if pkg_installed("plymouth"):
            show_info("Plymouth is already installed")
        else:
            show_info("Installing Plymouth...")
            try:
                subprocess.run(
                    ["sudo", "pacman", "-S", "--needed", "--noconfirm", "plymouth"],
                    check=True,
                    capture_output=True
                )
            except subprocess.CalledProcessError as e:
                show_warning(f"Failed to install Plymouth: {e}")
                new_line()
                return
        
        show_success("Plymouth and themes installation complete!")
        new_line()

    def configure_plymouth(self):
        """Configure Plymouth with bootloader"""
        show_step("Configuring Plymouth with bootloader...")
        
        grub_config = Path("/etc/default/grub")
        
        if not grub_config.exists():
            show_warning("GRUB configuration not found. Please configure Plymouth manually for your bootloader.")
            new_line()
            return
        
        try:
            with open(grub_config, "r") as f:
                content = f.read()
            
            required_params = ["quiet", "splash"]
            params_to_add = []
            needs_update = False
            
            # Check which parameters are missing
            for param in required_params:
                if not re.search(rf'GRUB_CMDLINE_LINUX_DEFAULT=.*{param}', content):
                    params_to_add.append(param)
                    needs_update = True
                else:
                    show_info(f"'{param}' parameter already present in GRUB config")
            
            # Add missing parameters
            if needs_update:
                params_str = " ".join(params_to_add) + " "
                content = re.sub(
                    r'GRUB_CMDLINE_LINUX_DEFAULT="',
                    f'GRUB_CMDLINE_LINUX_DEFAULT="{params_str}',
                    content
                )
                
                # Write back to file
                with open("/tmp/grub", "w") as f:
                    f.write(content)
                
                subprocess.run(["sudo", "cp", "/tmp/grub", "/etc/default/grub"], check=True, capture_output=True)
                subprocess.run(
                    ["sudo", "grub-mkconfig", "-o", "/boot/grub/grub.cfg"],
                    check=True,
                    capture_output=True
                )
                show_success(f"Added missing Plymouth parameters: {' '.join(params_to_add)}")
            else:
                show_success("Plymouth parameters already configured in GRUB")
        except Exception as e:
            show_warning(f"Failed to configure Plymouth: {e}")
        
        new_line()

    def run(self):
        self.install_plymouth()
        self.configure_plymouth()
        
        show_success("Plymouth configuration complete!")

if __name__ == "__main__":
    plymouth_module = Plymouth()
    plymouth_module.run()
