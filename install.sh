#!/bin/bash

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/helper.sh"

SCRIPTS_DIR="${SCRIPT_DIR}/scripts"

# Check and install gum if needed
check_and_install_gum

# Function to display header
display_header() {
    show_header "Arch Linux Modular Installation Script" "v1.0"
    echo
    gum style --foreground 147 "Select scripts to run from the scripts directory"
    gum style --foreground 147 "Tip: Prefix scripts with . or _ to hide them"
}

# Function to get available scripts
# Scripts starting with . or _ are hidden from the menu
get_available_scripts() {
    local scripts=()
    if [ -d "$SCRIPTS_DIR" ]; then
        for script in "$SCRIPTS_DIR"/*.{sh,py}; do
            if [ -f "$script" ] && [ -x "$script" ]; then
                local basename_script="$(basename "$script")"
                # Skip scripts starting with . or _
                if [[ ! "$basename_script" =~ ^[._] ]]; then
                    scripts+=("$basename_script")
                fi
            fi
        done
    fi
    echo "${scripts[@]}"
}

# Function to get script description
get_script_description() {
    local script_path="$1"
    # Extract description from script comments (looks for # Description: lines)
    grep -m 1 "^# Description:" "$script_path" | sed 's/# Description: //'
}

# Function to display script info
display_script_info() {
    local script_name="$1"
    local script_path="${SCRIPTS_DIR}/${script_name}"
    
    if [ -f "$script_path" ]; then
        local description=$(get_script_description "$script_path")
        if [ -n "$description" ]; then
            echo "$script_name - $description"
        else
            echo "$script_name"
        fi
    fi
}

# Main function
main() {
    clear_screen
    display_header
    
    # Check if scripts directory exists
    if [ ! -d "$SCRIPTS_DIR" ]; then
        show_error "Scripts directory not found: $SCRIPTS_DIR"
        exit 1
    fi
    
    # Get available scripts
    local available_scripts=($(get_available_scripts))
    
    if [ ${#available_scripts[@]} -eq 0 ]; then
        show_error "No executable scripts found in $SCRIPTS_DIR"
        echo "Make sure your scripts have .sh or .py extension and are executable (chmod +x)"
        exit 1
    fi
    
    # Create options array with descriptions
    local options=()
    for script in "${available_scripts[@]}"; do
        options+=("$(display_script_info "$script")")
    done
    
    # Let user select scripts to run
    gum style --foreground 212 --bold "Available scripts:"
    echo
    
    selected=$(gum choose --no-limit --height 15 --cursor-prefix "[ ] " --selected-prefix "[✓] " "${options[@]}")
    
    if [ -z "$selected" ]; then
        echo
        show_warning "No scripts selected. Exiting..."
        exit 0
    fi
    
    # Convert selected options back to script names
    local selected_scripts=()
    while IFS= read -r line; do
        script_name=$(echo "$line" | awk '{print $1}')
        selected_scripts+=("$script_name")
    done <<< "$selected"
    
    echo
    gum style --foreground 212 --bold "Selected scripts:"
    for script in "${selected_scripts[@]}"; do
        echo "  • $script"
    done
    echo
    
    # Confirm execution
    gum confirm "Do you want to run the selected scripts?" || {
        show_warning "Installation cancelled"
        exit 0
    }
    
    echo
    gum style --border normal --border-foreground 212 --padding "0 2" "Starting installation..."
    echo
    
    # Run selected scripts
    for script in "${selected_scripts[@]}"; do
        script_path="${SCRIPTS_DIR}/${script}"
        
        gum style --foreground 212 --bold "═══════════════════════════════════════════════════════"
        gum style --foreground 212 --bold "Running: $script"
        gum style --foreground 212 --bold "═══════════════════════════════════════════════════════"
        echo
        
        if [ -f "$script_path" ] && [ -x "$script_path" ]; then
            # Run the script based on its extension
            if [[ "$script" == *.py ]]; then
                # Run Python scripts from the dotfiles root directory
                (cd "$SCRIPT_DIR" && python "$script_path")
            else
                # Source the script to run in the same shell context
                bash "$script_path"
            fi
            
            if [ $? -eq 0 ]; then
                echo
            else
                echo
                show_error "$script failed with exit code $?"
                
                if ! gum confirm "Continue with remaining scripts?"; then
                    show_warning "Installation stopped"
                    exit 1
                fi
            fi
        else
            show_error "Script not found or not executable: $script_path"
        fi
        
        echo
    done
    
    # Final summary
    gum style \
        --border double \
        --border-foreground 76 \
        --padding "1 2" \
        --margin "1" \
        "Installation Complete!" \
        "" \
        "All selected scripts have been executed."
    
}

# Run main function
main
