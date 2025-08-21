#!/bin/bash

# Banner Redraw Installer - Periodically shows the large banner
# Simple approach that actually works

# Source the original banner functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/coherence-banner.sh" ]; then
    source "$SCRIPT_DIR/coherence-banner.sh"
fi

# Track what we've shown
LAST_BANNER_TIME=0
BANNER_INTERVAL=30  # Show banner every 30 seconds
PHASE_COUNTER=0

# Show banner at key phases
show_banner_for_phase() {
    local phase_name="$1"
    
    echo ""
    echo ""
    
    # Clear screen and show the large banner
    clear
    print_banner  # This is the large beautiful banner
    
    echo ""
    echo -e "\033[1;36m━━━ $phase_name ━━━\033[0m"
    echo ""
}

# Run installation with banner redraws
run_with_banner_redraws() {
    local cmd="$1"
    
    # Show initial banner
    show_banner_for_phase "COHERENCE Installation Starting"
    
    # Run the installation command, but intercept key phases
    eval "$cmd" | while IFS= read -r line; do
        echo "$line"
        
        # Check for key installation phases and redraw banner
        case "$line" in
            *"Step 1:"*)
                show_banner_for_phase "Step 1: Setting Up Framework"
                ;;
            *"Step 3:"*)
                show_banner_for_phase "Step 3: Configuring Environment"
                ;;
            *"Step 5:"*)
                show_banner_for_phase "Step 5: Installing Components"
                ;;
            *"Installing APM commands"*)
                show_banner_for_phase "Installing COHERENCE Commands"
                ;;
        esac
    done
    
    # Final banner
    echo ""
    show_banner_for_phase "COHERENCE Installation Complete!"
    echo ""
    echo -e "\033[1;35m🎉 COHERENCE is now ready! 🎉\033[0m"
    echo -e "\033[0;36mUnified Context Engineering is active\033[0m"
    echo ""
}

# Export functions
export -f show_banner_for_phase
export -f run_with_banner_redraws

# Demo mode when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Banner Redraw Installer - Demo Mode"
    
    # Demo the banner redraw approach
    run_with_banner_redraws "
        echo 'Step 1: Starting installation...'
        sleep 2
        echo 'Setting up directories...'
        sleep 1
        echo 'Step 3: Configuring environment...'
        sleep 2
        echo 'Installing dependencies...'
        sleep 1
        echo 'Step 5: Installing components...'
        sleep 2
        echo 'Installing APM commands...'
        sleep 1
        echo 'Installation complete!'
    "
fi