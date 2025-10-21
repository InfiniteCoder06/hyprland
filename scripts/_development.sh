#!/bin/bash
# Description: Install development tools and environments

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../helper.sh"

clear_screen
show_header "Development Tools" "v1.0"

show_step "This script will install development tools"
gum style --foreground 147 "  • Programming languages (Python, Node.js, Rust, Go)"
gum style --foreground 147 "  • Development tools and utilities"
gum style --foreground 147 "  • Version managers"
echo

# Install programming languages
install_languages() {
    show_step "Installing programming languages..."
    
    local packages=(
        "python"
        "python-pip"
        "python-pipenv"
        "python-poetry"
        "nodejs"
        "npm"
        "yarn"
        "rust"
        "cargo"
        "go"
        "lua"
        "ruby"
    )
    
    local to_install=()
    for pkg in "${packages[@]}"; do
        if ! pkg_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done
    
    if [ ${#to_install[@]} -gt 0 ]; then
        sudo pacman -S --needed --noconfirm "${to_install[@]}"
        show_success "Programming languages installed"
    else
        show_success "All programming languages already installed"
    fi
    echo
}

# Install development tools
install_dev_tools() {
    show_step "Installing development tools..."
    
    local packages=(
        "code"
        "git"
        "github-cli"
        "lazygit"
        "docker"
        "docker-compose"
        "kubectl"
        "terraform"
        "ansible"
        "make"
        "cmake"
        "gdb"
        "valgrind"
        "strace"
    )
    
    local to_install=()
    for pkg in "${packages[@]}"; do
        if ! pkg_installed "$pkg"; then
            to_install+=("$pkg")
        fi
    done
    
    if [ ${#to_install[@]} -gt 0 ]; then
        sudo pacman -S --needed --noconfirm "${to_install[@]}"
        show_success "Development tools installed"
    else
        show_success "All development tools already installed"
    fi
    echo
}

# Setup Docker
setup_docker() {
    show_step "Configuring Docker..."
    
    if pkg_installed "docker"; then
        sudo systemctl enable docker.service
        sudo systemctl start docker.service
        
        if ! groups $USER | grep -q docker; then
            sudo usermod -aG docker $USER
            show_warning "Added user to docker group. Please log out and log back in."
        fi
        
        show_success "Docker configured"
    else
        show_warning "Docker not installed, skipping configuration"
    fi
    echo
}

# Install version managers
install_version_managers() {
    show_step "Installing version managers..."
    
    # NVM for Node.js
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        show_success "NVM installed"
    else
        show_success "NVM already installed"
    fi
    
    # pyenv for Python
    if [ ! -d "$HOME/.pyenv" ]; then
        curl https://pyenv.run | bash
        show_success "pyenv installed"
    else
        show_success "pyenv already installed"
    fi
    
    echo
}

main() {
    check_internet
    install_languages
    install_dev_tools
    setup_docker
    install_version_managers
    
    show_success "Development environment setup complete!"
}

main
