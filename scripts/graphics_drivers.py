#!/usr/bin/env python3
# Description: Install graphics drivers (AMD/Intel/Nvidia)

import sys
import subprocess
import shlex
from os import popen
from pathlib import Path
from enum import Enum

SCRIPT_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(SCRIPT_DIR))

from lib.module import Module
from lib.helper import (
    show_step, show_info, show_success, show_error, show_warning,
    pkg_installed, check_internet, new_line
)

class GfxPackage(Enum):
    """Graphics driver packages"""
    Dkms = 'dkms'
    IntelMediaDriver = 'intel-media-driver'
    LibvaIntelDriver = 'libva-intel-driver'
    LibvaMesaDriver = 'libva-mesa-driver'
    LibvaNvidiaDriver = 'libva-nvidia-driver'
    Mesa = 'mesa'
    NvidiaDkms = 'nvidia-dkms'
    NvidiaOpenDkms = 'nvidia-open-dkms'
    VulkanIntel = 'vulkan-intel'
    VulkanRadeon = 'vulkan-radeon'
    VulkanNouveau = 'vulkan-nouveau'
    Xf86VideoAmdgpu = 'xf86-video-amdgpu'
    Xf86VideoAti = 'xf86-video-ati'
    Xf86VideoNouveau = 'xf86-video-nouveau'
    XorgServer = 'xorg-server'
    XorgXinit = 'xorg-xinit'

class GfxDriver(Enum):
    """Graphics driver types"""
    AllOpenSource = 'all-open-source'
    AmdOpenSource = 'amd-open-source'
    IntelOpenSource = 'intel-open-source'
    NvidiaOpenKernel = 'nvidia-open-kernel'
    NvidiaOpenSource = 'nvidia-open-source'
    NvidiaProprietary = 'nvidia-proprietary'
    VMOpenSource = 'vm-open-source'

    def get_packages(self) -> list[str]:
        """Get list of packages for this driver type"""
        packages = []
        
        match self:
            case GfxDriver.AllOpenSource:
                packages += [
                    GfxPackage.Mesa,
                    GfxPackage.Xf86VideoAmdgpu,
                    GfxPackage.Xf86VideoAti,
                    GfxPackage.Xf86VideoNouveau,
                    GfxPackage.LibvaMesaDriver,
                    GfxPackage.LibvaIntelDriver,
                    GfxPackage.IntelMediaDriver,
                    GfxPackage.VulkanRadeon,
                    GfxPackage.VulkanIntel,
                    GfxPackage.VulkanNouveau,
                ]
            case GfxDriver.AmdOpenSource:
                packages += [
                    GfxPackage.Mesa,
                    GfxPackage.Xf86VideoAmdgpu,
                    GfxPackage.Xf86VideoAti,
                    GfxPackage.LibvaMesaDriver,
                    GfxPackage.VulkanRadeon,
                ]
            case GfxDriver.IntelOpenSource:
                packages += [
                    GfxPackage.Mesa,
                    GfxPackage.LibvaIntelDriver,
                    GfxPackage.IntelMediaDriver,
                    GfxPackage.VulkanIntel,
                ]
            case GfxDriver.NvidiaOpenKernel:
                packages += [
                    GfxPackage.NvidiaOpenDkms,
                    GfxPackage.Dkms,
                    GfxPackage.LibvaNvidiaDriver,
                ]
            case GfxDriver.NvidiaOpenSource:
                packages += [
                    GfxPackage.Mesa,
                    GfxPackage.Xf86VideoNouveau,
                    GfxPackage.LibvaMesaDriver,
                    GfxPackage.VulkanNouveau,
                ]
            case GfxDriver.NvidiaProprietary:
                packages += [
                    GfxPackage.NvidiaDkms,
                    GfxPackage.Dkms,
                    GfxPackage.LibvaNvidiaDriver,
                ]
            case GfxDriver.VMOpenSource:
                packages += [
                    GfxPackage.Mesa,
                ]
        
        return [pkg.value for pkg in packages]

class GraphicsDrivers(Module):
    """Install graphics drivers for AMD, Intel, or Nvidia"""

    name = "Graphics Driver Installation"
    description = "v1.0"
    title = "This script will install graphics drivers"
    messages = [
        "Detect or select graphics driver type",
        "Remove conflicting driver packages",
        "Install selected graphics drivers",
    ]

    # All possible graphics packages that might conflict
    ALL_GFX_PACKAGES = [pkg.value for pkg in GfxPackage]

    def detect_gpu(self) -> str:
        """Detect GPU vendor from lspci"""
        try:
            result = subprocess.run(
                ["lspci"],
                capture_output=True,
                text=True,
                check=True
            )
            output = result.stdout.lower()
            
            if "nvidia" in output and "vga" in output:
                return "nvidia"
            elif "amd" in output and ("vga" in output or "display" in output):
                return "amd"
            elif "intel" in output and ("vga" in output or "display" in output):
                return "intel"
            else:
                return "unknown"
        except subprocess.CalledProcessError:
            return "unknown"

    def select_driver_type(self) -> list[GfxDriver]:
        """Prompt user to select driver type"""
        show_step("Detecting GPU...")
        gpu_vendor = self.detect_gpu()
        
        if gpu_vendor != "unknown":
            show_info(f"Detected {gpu_vendor.upper()} GPU")
        else:
            show_warning("Could not detect GPU vendor")
        
        new_line()
        show_step("Select graphics driver type:")
        
        # Create options for gum choose
        options = [
            "AMD Open Source",
            "Intel Open Source",
            "Nvidia Proprietary",
            "Nvidia Open Kernel",
            "Nvidia Open Source (Nouveau)",
            "VM/Generic Open Source",
            "All Open Source Drivers",
        ]
        
        try:
            result = popen("gum choose --no-limit " + " ".join(shlex.quote(opt) for opt in options)).read()
            # Multiple Choices
            choice = result.strip().splitlines()


            # Map choice to GfxDriver enum
            driver_map = {
                "AMD Open Source": GfxDriver.AmdOpenSource,
                "Intel Open Source": GfxDriver.IntelOpenSource,
                "Nvidia Proprietary": GfxDriver.NvidiaProprietary,
                "Nvidia Open Kernel": GfxDriver.NvidiaOpenKernel,
                "Nvidia Open Source (Nouveau)": GfxDriver.NvidiaOpenSource,
                "VM/Generic Open Source": GfxDriver.VMOpenSource,
                "All Open Source Drivers": GfxDriver.AllOpenSource,
            }

            selected_drivers = []
            for line in choice:
                print(f"User selected: {line}")
                driver = driver_map.get(line)
                print(f"Mapped to driver: {driver}")
                if driver:
                    selected_drivers.append(driver)
            if selected_drivers:
                show_success(f"Selected: {', '.join(choice)}")
                new_line()
                return selected_drivers
            else:
                show_error("Invalid selection")
                sys.exit(1)
                
        except subprocess.CalledProcessError:
            show_error("Driver selection cancelled or failed")
            sys.exit(1)

    def remove_conflicting_drivers(self, selected_packages: list[str]):
        """Remove conflicting graphics driver packages"""
        show_step("Checking for conflicting graphics drivers...")
        
        # Find installed graphics packages that are NOT in the selected list
        conflicting = [
            pkg for pkg in self.ALL_GFX_PACKAGES 
            if pkg not in selected_packages and pkg_installed(pkg)
        ]
        
        if conflicting:
            show_warning(f"Found conflicting packages: {', '.join(conflicting)}")
            try:
                result = subprocess.run(
                    ["gum", "confirm", "Remove conflicting driver packages?"],
                )
                if result.returncode == 0:
                    show_info("Removing conflicting packages...")
                    subprocess.run(
                        ["sudo", "pacman", "-Rns", "--noconfirm"] + conflicting,
                        check=True,
                        capture_output=True
                    )
                    show_success("Conflicting packages removed")
                else:
                    show_warning("Skipping removal of conflicting packages")
            except subprocess.CalledProcessError as e:
                show_warning(f"Failed to remove conflicting packages: {e}")
        else:
            show_success("No conflicting packages found")
        
        new_line()

    def install_drivers(self, packages: list[str]):
        """Install selected graphics driver packages"""
        show_step("Installing graphics drivers...")
        
        to_install = [pkg for pkg in packages if not pkg_installed(pkg)]
        
        if to_install:
            show_info(f"Installing: {', '.join(to_install)}")
            try:
                subprocess.run(
                    ["sudo", "pacman", "-S", "--needed", "--noconfirm"] + to_install,
                    check=True,
                    capture_output=True
                )
                show_success("Graphics drivers installed successfully")
            except subprocess.CalledProcessError as e:
                show_error(f"Failed to install graphics drivers: {e}")
        else:
            show_success("All required graphics drivers are already installed")
        
        new_line()

    def run(self):
        check_internet()
        
        # Select driver type
        driver_type = self.select_driver_type()
        
        # Get packages for selected driver
        packages = []
        for driver in driver_type:
            packages += driver.get_packages()
        
        show_info(f"Will install: {', '.join(packages)}")
        new_line()
        
        # Remove conflicting drivers
        self.remove_conflicting_drivers(packages)
        
        # Install selected drivers
        self.install_drivers(packages)
        
        show_success("Graphics driver installation complete!")
        show_info("Please reboot your system for changes to take effect.")

if __name__ == "__main__":
    graphics_module = GraphicsDrivers()
    graphics_module.run()
