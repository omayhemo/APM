#!/bin/bash

# Fixed Banner Installer - Terminal scrolling regions approach
# Keeps banner truly fixed at top while output scrolls below

# Source the original banner functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/coherence-banner.sh" ]; then
    source "$SCRIPT_DIR/coherence-banner.sh"
fi

# Terminal dimensions
TOP_PADDING=3    # Rows of padding above banner
BANNER_HEIGHT=8  # Height needed for banner
TERM_HEIGHT=$(tput lines)
TERM_WIDTH=$(tput cols)
OUTPUT_START_ROW=$((TOP_PADDING + BANNER_HEIGHT + 1))

# Initialize fixed banner display
init_fixed_banner() {
    # Clear screen
    clear
    
    # Hide cursor during setup
    tput civis
    
    # Draw the banner with padding from top
    tput cup $TOP_PADDING 0
    print_banner
    
    # Set scrolling region to start below banner
    tput csr $OUTPUT_START_ROW $TERM_HEIGHT
    
    # Position cursor at start of output area
    tput cup $OUTPUT_START_ROW 0
    
    # Show cursor
    tput cnorm
}

# Cleanup function to restore terminal
cleanup_terminal() {
    # Restore full scrolling region
    tput csr 0 $TERM_HEIGHT
    # Show cursor
    tput cnorm
    # Move to bottom
    tput cup $TERM_HEIGHT 0
}

# Redraw banner (in case of terminal resize or corruption)
redraw_banner() {
    # Save current cursor position
    local current_row current_col
    current_row=$(tput cup)
    
    # Draw banner with padding from top
    tput cup $TOP_PADDING 0
    print_banner
    
    # Restore scrolling region
    tput csr $OUTPUT_START_ROW $TERM_HEIGHT
    
    # Return to output area
    tput cup $OUTPUT_START_ROW 0
}

# Run installation with fixed banner
run_with_fixed_banner() {
    local cmd="$1"
    
    # Set up signal handlers for cleanup
    trap cleanup_terminal EXIT INT TERM
    
    # Initialize the fixed banner
    init_fixed_banner
    
    # Execute the installation command
    # All output will be confined to the scrolling region
    eval "$cmd"
    
    # Installation complete
    echo ""
    echo -e "\033[1;35m🎉 COHERENCE Installation Complete! 🎉\033[0m"
    echo -e "\033[0;36mUnified Context Engineering is active\033[0m"
    echo ""
}

# Export functions
export -f init_fixed_banner
export -f cleanup_terminal  
export -f redraw_banner
export -f run_with_fixed_banner

# Demo mode when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Fixed Banner Installer - Demo Mode"
    
    # Demo the fixed banner approach
    run_with_fixed_banner "
        echo 'Step 1: Starting installation...'
        sleep 2
        echo 'Setting up directories...'
        echo 'Creating configuration files...'
        echo 'Downloading dependencies...'
        sleep 1
        echo 'Step 2: Configuring environment...'
        echo 'Installing packages...'
        echo 'Setting permissions...'
        sleep 2
        echo 'Step 3: Installing components...'
        for i in {1..20}; do
            echo \"Installing component \$i...\"
            sleep 0.2
        done
        echo 'Step 4: Finalizing installation...'
        echo 'Cleaning up temporary files...'
        echo 'Installation complete!'
    "
fi