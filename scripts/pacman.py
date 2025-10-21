#!/usr/bin/env python3
# Description: Configure system settings and optimizations

import sys
import subprocess
import re
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SCRIPT_DIR))

from lib.module import Module
from lib.helper import (
    show_step, show_info, show_success, show_warning, new_line
)

class Pacman(Module):
    """Configure system settings and optimizations"""

    name = "System Configuration"
    description = "v1.0"
    title = "This script will configure system settings"
    messages = [
        "Enable multilib repository",
        "Modify pacman settings",
    ]

    lines_to_edit = [
        "Color",
        "CheckSpace",
        "VerbosePkgLists",
        "ParallelDownloads",
    ]

    def configure_multilib(self):
        """Enable multilib repository"""
        show_step("Configuring multilib repository...")
        
        try:
            with open("/etc/pacman.conf", "r") as f:
                content = f.read()
            
            # Check if multilib is already enabled
            if re.search(r'^\[multilib\]', content, re.MULTILINE):
                show_success("Multilib repository already enabled")
            else:
                show_info("Enabling multilib...")
                # Uncomment [multilib] and Include line
                content = re.sub(
                    r'^#(\[multilib\])\n#(Include = /etc/pacman.d/mirrorlist)',
                    r'\1\n\2',
                    content,
                    flags=re.MULTILINE
                )
                
                # Write back to file
                with open("/tmp/pacman.conf", "w") as f:
                    f.write(content)
                
                subprocess.run(["sudo", "cp", "/tmp/pacman.conf", "/etc/pacman.conf"], check=True, capture_output=True)
                subprocess.run(["sudo", "pacman", "-Sy"], check=True, capture_output=True)
                show_success("Multilib repository enabled")
        except Exception as e:
            show_warning(f"Failed to configure multilib: {e}")
        
        new_line()

    def configure_pacman(self):
        """Configure pacman settings"""
        show_step("Configuring pacman...")
        
        try:
            with open("/etc/pacman.conf", "r") as f:
                content = f.read()
            
            modified = False
            
            # Enable specified options
            for option in self.lines_to_edit:
                if re.search(rf'^{option}', content, re.MULTILINE):
                    continue
                
                content = re.sub(
                    rf'^#{option}',
                    option,
                    content,
                    flags=re.MULTILINE
                )
                show_info(f"Enabled: {option}")
                modified = True
            
            # Add ILoveCandy if not present
            if "ILoveCandy" not in content:
                content = re.sub(
                    r'^Color',
                    'Color\nILoveCandy',
                    content,
                    flags=re.MULTILINE
                )
                show_info("Enabled: ILoveCandy")
                modified = True
            
            if modified:
                # Write back to file
                with open("/tmp/pacman.conf", "w") as f:
                    f.write(content)
                
                subprocess.run(["sudo", "cp", "/tmp/pacman.conf", "/etc/pacman.conf"], check=True, capture_output=True)
            
            show_success("Pacman configured successfully!")
        except Exception as e:
            show_warning(f"Failed to configure pacman: {e}")
        
        new_line()

    def run(self):
        self.configure_multilib()
        self.configure_pacman()
        
        show_success("System configuration complete!")

if __name__ == "__main__":
    pacman_module = Pacman()
    pacman_module.run()
