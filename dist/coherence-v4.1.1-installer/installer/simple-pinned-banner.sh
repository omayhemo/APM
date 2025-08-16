#!/bin/bash

# Simple Pinned COHERENCE Banner - No complex terminal control
# Uses basic cursor positioning to keep banner at top

# Burgundy to Purple Gradient Colors  
BURGUNDY='\033[38;5;88m'
WINE='\033[38;5;125m' 
PURPLE='\033[38;5;135m'
LIGHT_PURPLE='\033[38;5;171m'
VIOLET='\033[38;5;207m'
GRAY='\033[38;5;245m'
WHITE='\033[38;5;255m'
RESET='\033[0m'

# Banner height (number of lines)
BANNER_HEIGHT=5

# Draw the COHERENCE banner at top
draw_pinned_banner() {
    # Save current position
    printf '\033[s'
    
    # Go to top of screen
    printf '\033[H'
    
    # Draw banner
    echo -e "${BURGUNDY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "                    ${BURGUNDY}C${WINE}O${PURPLE}H${LIGHT_PURPLE}E${VIOLET}R${PURPLE}E${WINE}N${BURGUNDY}C${WINE}E${RESET}"
    echo -e "                ${GRAY}Unified Context Engineering${RESET}"
    echo -e "${BURGUNDY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${WHITE}Starting installation...${RESET}"
    
    # Restore position
    printf '\033[u'
}

# Initialize pinned banner mode
init_pinned_banner() {
    # Clear screen
    clear
    
    # Draw initial banner
    draw_pinned_banner
    
    # Position cursor below banner for output
    printf "\033[$(($BANNER_HEIGHT + 2));1H"
}

# Process command with pinned banner
run_with_pinned_banner() {
    local cmd="$1"
    
    # Initialize
    init_pinned_banner
    
    # Run command, redirect output to show below banner
    eval "$cmd" | while IFS= read -r line; do
        # Check if we need to redraw banner (optional - only if cursor gets to top)
        echo "$line"
    done
    
    # Final completion message
    echo ""
    echo -e "${VIOLET}🎉 ${WHITE}COHERENCE Installation Complete! ${VIOLET}🎉${RESET}"
    echo -e "${PURPLE}Unified Context Engineering is now active${RESET}"
    echo ""
}

# Export functions
export -f draw_pinned_banner
export -f init_pinned_banner  
export -f run_with_pinned_banner

# Demo mode when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Simple Pinned COHERENCE Banner - Demo Mode"
    echo ""
    
    # Demo the pinned banner
    run_with_pinned_banner "
        sleep 1
        echo '⏳ Installing dependencies...'
        sleep 1
        echo '🔧 Configuring environment...'
        sleep 1
        echo '📝 Generating templates...'
        sleep 1
        echo '✅ Installation steps completed!'
    "
fi