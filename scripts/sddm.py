#!/usr/bin/env python3
# Description: Configure SDDM Theme

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

class SDDM(Module):
    """Configure SDDM theme"""

    name = "SDDM Configuration"
    description = "v1.0"
    title = "This script will install and configure SDDM Theme"
    messages = [
        "Install and Change SDDM Theme",
    ]

    def install_theme(self):
        """Install SDDM theme"""
        show_step("Installing SDDM theme...")

        if pkg_installed("sddm-astronaut-theme"):
            show_info("SDDM theme is already installed")
        else:
            show_info("Installing SDDM theme...")
            try:
                subprocess.run(
                    ["paru", "-S", "--needed", "--noconfirm", "sddm-astronaut-theme"],
                    check=True,
                    capture_output=True
                )
            except subprocess.CalledProcessError as e:
                show_warning(f"Failed to install SDDM theme: {e}")
                new_line()
                return

        show_success("SDDM theme installation complete!")
        new_line()

    def configure_sddm_theme(self):
        """Configure SDDM theme"""
        show_step("Configuring SDDM theme...")

        sddm_config = Path("/etc/sddm.conf")

        if not sddm_config.exists():
            show_warning("SDDM configuration file not found. Creating /etc/sddm.conf.")
            
            subprocess.run(
                ["sudo", "touch", "/etc/sddm.conf"], 
                check=True, 
                capture_output=True
            )

        with open("/etc/sddm.conf", "r") as f:
            content = f.read()

        sections = {
            "General": {"DisplayServer": "wayland"},
            "Theme": {"Current": "sddm-astronaut-theme"}
        }

        for section, settings in sections.items():
            if f"[{section}]" not in content:
                content += f"\n[{section}]\n"
            
            for key, value in settings.items():
                pattern = f"{key}="
                replacement = f"{key}={value}"
            
                if pattern not in content:
                    content += f"{replacement}\n"
                else:
                    content = re.sub(rf"{key}=.*", replacement, content)

        with open("/tmp/sddm", "w") as f:
            f.write(content)

        subprocess.run(["sudo", "cp", "/tmp/sddm", "/etc/sddm.conf"], check=True, capture_output=True)

        show_success("SDDM theme configuration complete!")    

    def run(self):
        self.install_theme()
        self.configure_sddm_theme()
        
        show_success("Plymouth configuration complete!")

if __name__ == "__main__":
    sddm_module = SDDM()
    sddm_module.run()
