#!/bin/bash

# COHERENCE Opening Banner - Simple and Reliable
# Shows beautiful banner once, then allows normal output flow

# Burgundy to Purple Gradient Colors  
BURGUNDY='\033[38;5;88m'
WINE='\033[38;5;125m' 
PURPLE='\033[38;5;135m'
LIGHT_PURPLE='\033[38;5;171m'
VIOLET='\033[38;5;207m'
GRAY='\033[38;5;245m'
WHITE='\033[38;5;255m'
RESET='\033[0m'

# Draw the beautiful COHERENCE banner once
show_coherence_banner() {
    echo ""
    echo -e "${BURGUNDY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "                    ${BURGUNDY}C${WINE}O${PURPLE}H${LIGHT_PURPLE}E${VIOLET}R${PURPLE}E${WINE}N${BURGUNDY}C${WINE}E${RESET}"
    echo ""
    echo -e "                ${GRAY}Unified Context Engineering${RESET}"
    echo ""
    echo -e "${BURGUNDY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${WHITE}Starting installation...${RESET}"
    echo ""
}

# Run command with opening banner
run_with_opening_banner() {
    local cmd="$1"
    
    # Show the beautiful banner
    show_coherence_banner
    
    # Run the command - output flows naturally below banner
    eval "$cmd"
    
    echo ""
    echo -e "${VIOLET}🎉 ${WHITE}COHERENCE Installation Complete! ${VIOLET}🎉${RESET}"
    echo -e "${PURPLE}Unified Context Engineering is now active${RESET}"
    echo ""
}

# Export functions
export -f show_coherence_banner
export -f run_with_opening_banner

# Demo mode when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "COHERENCE Opening Banner - Demo Mode"
    
    # Demo the banner with some output
    run_with_opening_banner "
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