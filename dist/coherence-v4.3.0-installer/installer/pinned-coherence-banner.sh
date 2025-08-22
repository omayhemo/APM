#!/bin/bash

# Pinned Coherence Banner - Keep the LARGE banner at top
# Based on the existing coherence-banner.sh but made pinned

# Version detection - reads from multiple sources
get_coherence_version() {
    local version="4.1.5"  # default fallback
    
    # Try to read from VERSION file in same directory as this script
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$script_dir/VERSION" ]; then
        version=$(cat "$script_dir/VERSION" | head -1 | tr -d '\n\r')
    # Try parent directory VERSION file
    elif [ -f "$script_dir/../VERSION" ]; then
        version=$(cat "$script_dir/../VERSION" | head -1 | tr -d '\n\r')
    # Try environment variable
    elif [ -n "$COHERENCE_VERSION" ]; then
        version="$COHERENCE_VERSION"
    fi
    
    echo "$version"
}

# Set version variable for use in banners
COHERENCE_VERSION=$(get_coherence_version)

# Colors
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# Main brand colors - purple/blue gradient effect
PURPLE='\033[35m'
BLUE='\033[34m'
CYAN='\033[36m'
WHITE='\033[37m'
YELLOW='\033[33m'

# Background colors
BG_PURPLE='\033[45m'
BG_BLUE='\033[44m'

# Light versions (using bright colors)
LIGHT_PURPLE='\033[95m'
LIGHT_BLUE='\033[94m'
LIGHT_CYAN='\033[96m'

# Banner height (number of lines the banner takes up)
BANNER_HEIGHT=12

# Draw the pinned large banner
draw_pinned_large_banner() {
    # Save cursor position
    printf '\033[s'
    
    # Go to top of screen
    printf '\033[H'
    
    # Draw top line
    echo -ne "${LIGHT_BLUE}"
    for i in {1..79}; do
        echo -ne "━"
    done
    echo -e "${RESET}"
    echo
    
    # Draw the large COHERENCE logo
    echo -e "${LIGHT_PURPLE}     ██████╗ ${PURPLE}██████╗ ${BLUE}██╗  ██╗${CYAN}███████╗${LIGHT_CYAN}██████╗ ${LIGHT_BLUE}███████╗${LIGHT_PURPLE}███╗   ██╗ ${PURPLE}██████╗${CYAN}███████╗${RESET}"
    echo -e "${LIGHT_PURPLE}    ██╔════╝${PURPLE}██╔═══██╗${BLUE}██║  ██║${CYAN}██╔════╝${LIGHT_CYAN}██╔══██╗${LIGHT_BLUE}██╔════╝${LIGHT_PURPLE}████╗  ██║${PURPLE}██╔════╝${CYAN}██╔════╝${RESET}"
    echo -e "${LIGHT_PURPLE}    ██║     ${PURPLE}██║   ██║${BLUE}███████║${CYAN}█████╗  ${LIGHT_CYAN}██████╔╝${LIGHT_BLUE}█████╗  ${LIGHT_PURPLE}██╔██╗ ██║${PURPLE}██║     ${CYAN}█████╗  ${RESET}"
    echo -e "${LIGHT_PURPLE}    ██║     ${PURPLE}██║   ██║${BLUE}██╔══██║${CYAN}██╔══╝  ${LIGHT_CYAN}██╔══██╗${LIGHT_BLUE}██╔══╝  ${LIGHT_PURPLE}██║╚██╗██║${PURPLE}██║     ${CYAN}██╔══╝  ${RESET}"
    echo -e "${LIGHT_PURPLE}    ╚██████╗${PURPLE}╚██████╔╝${BLUE}██║  ██║${CYAN}███████╗${LIGHT_CYAN}██║  ██║${LIGHT_BLUE}███████╗${LIGHT_PURPLE}██║ ╚████║${PURPLE}╚██████╗${CYAN}███████╗${RESET}"
    echo -e "${LIGHT_PURPLE}     ╚═════╝ ${PURPLE}╚═════╝ ${BLUE}╚═╝  ╚═╝${CYAN}╚══════╝${LIGHT_CYAN}╚═╝  ╚═╝${LIGHT_BLUE}╚══════╝${LIGHT_PURPLE}╚═╝  ╚═══╝ ${PURPLE}╚═════╝${CYAN}╚══════╝${RESET}"
    echo
    echo -e "${DIM}${CYAN}                        ♪ ♫ ${RESET}${BOLD}${WHITE}Orchestrate AI Personas${RESET}${DIM}${CYAN} ♫ ♪${RESET}"
    echo
    echo -ne "${LIGHT_BLUE}"
    for i in {1..79}; do
        echo -ne "━"
    done
    echo -e "${RESET}"
    echo
    echo -e "${CYAN}  Version:${RESET} ${BOLD}${WHITE}${COHERENCE_VERSION}${RESET}                                    ${CYAN}Many Voices.${RESET} ${BOLD}${LIGHT_PURPLE}One Vision.${RESET}"
    echo
    
    # Restore cursor position
    printf '\033[u'
}

# Initialize pinned banner mode
init_pinned_large_banner() {
    # Clear screen
    clear
    
    # Draw the large banner
    draw_pinned_large_banner
    
    # Position cursor below banner for output
    printf "\033[$(($BANNER_HEIGHT + 2));1H"
}

# Run command with large pinned banner
run_with_pinned_large_banner() {
    local cmd="$1"
    
    # Initialize
    init_pinned_large_banner
    
    # Run command, output flows below banner
    eval "$cmd"
    
    # Show completion
    echo
    echo -e "${LIGHT_PURPLE}🎉 ${BOLD}${WHITE}COHERENCE Installation Complete! ${LIGHT_PURPLE}🎉${RESET}"
    echo -e "${PURPLE}Unified Context Engineering is now active${RESET}"
    echo ""
}

# Export functions
export -f draw_pinned_large_banner
export -f init_pinned_large_banner
export -f run_with_pinned_large_banner

# Demo mode when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Pinned Large COHERENCE Banner - Demo Mode"
    echo ""
    
    # Demo the large pinned banner
    run_with_pinned_large_banner "
        sleep 1
        echo '⏳ Installing dependencies...'
        sleep 1
        echo '🔧 Configuring environment...'
        sleep 1
        echo '📝 Generating templates...'
        sleep 1
        echo '✅ Installation complete!'
    "
fi