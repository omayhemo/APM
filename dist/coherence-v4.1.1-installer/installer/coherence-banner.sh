#!/bin/bash

# Coherence Installer Banner
# Color definitions using ANSI escape codes

# Version detection - reads from multiple sources
get_coherence_version() {
    local version="4.1.1"  # default fallback
    
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

# Function to print the banner
print_banner() {
    clear
    echo
    echo -e "${LIGHT_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
    echo -e "${LIGHT_PURPLE}     ██████╗ ${PURPLE}██████╗ ${BLUE}██╗  ██╗${CYAN}███████╗${LIGHT_CYAN}██████╗ ${LIGHT_BLUE}███████╗${LIGHT_PURPLE}███╗   ██╗ ${PURPLE}██████╗${CYAN}███████╗${RESET}"
    echo -e "${LIGHT_PURPLE}    ██╔════╝${PURPLE}██╔═══██╗${BLUE}██║  ██║${CYAN}██╔════╝${LIGHT_CYAN}██╔══██╗${LIGHT_BLUE}██╔════╝${LIGHT_PURPLE}████╗  ██║${PURPLE}██╔════╝${CYAN}██╔════╝${RESET}"
    echo -e "${LIGHT_PURPLE}    ██║     ${PURPLE}██║   ██║${BLUE}███████║${CYAN}█████╗  ${LIGHT_CYAN}██████╔╝${LIGHT_BLUE}█████╗  ${LIGHT_PURPLE}██╔██╗ ██║${PURPLE}██║     ${CYAN}█████╗  ${RESET}"
    echo -e "${LIGHT_PURPLE}    ██║     ${PURPLE}██║   ██║${BLUE}██╔══██║${CYAN}██╔══╝  ${LIGHT_CYAN}██╔══██╗${LIGHT_BLUE}██╔══╝  ${LIGHT_PURPLE}██║╚██╗██║${PURPLE}██║     ${CYAN}██╔══╝  ${RESET}"
    echo -e "${LIGHT_PURPLE}    ╚██████╗${PURPLE}╚██████╔╝${BLUE}██║  ██║${CYAN}███████╗${LIGHT_CYAN}██║  ██║${LIGHT_BLUE}███████╗${LIGHT_PURPLE}██║ ╚████║${PURPLE}╚██████╗${CYAN}███████╗${RESET}"
    echo -e "${LIGHT_PURPLE}     ╚═════╝ ${PURPLE}╚═════╝ ${BLUE}╚═╝  ╚═╝${CYAN}╚══════╝${LIGHT_CYAN}╚═╝  ╚═╝${LIGHT_BLUE}╚══════╝${LIGHT_PURPLE}╚═╝  ╚═══╝ ${PURPLE}╚═════╝${CYAN}╚══════╝${RESET}"
    echo
    echo -e "${DIM}${CYAN}                        ♪ ♫ ${RESET}${BOLD}${WHITE}Orchestrate AI Personas${RESET}${DIM}${CYAN} ♫ ♪${RESET}"
    echo
    echo -e "${LIGHT_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
    echo -e "${CYAN}  Version:${RESET} ${BOLD}${WHITE}${COHERENCE_VERSION}${RESET}                                    ${CYAN}Many Voices.${RESET} ${BOLD}${LIGHT_PURPLE}One Vision.${RESET}"
    echo
    echo -e "${LIGHT_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

# Animated loading version (optional)
print_animated_banner() {
    clear
    echo
    
    # Draw line with animation
    for i in {1..79}; do
        echo -ne "${LIGHT_BLUE}━${RESET}"
        sleep 0.01
    done
    echo
    echo
    
    # Static logo appears
    echo -e "${LIGHT_PURPLE}     ██████╗ ${PURPLE}██████╗ ${BLUE}██╗  ██╗${CYAN}███████╗${LIGHT_CYAN}██████╗ ${LIGHT_BLUE}███████╗${LIGHT_PURPLE}███╗   ██╗ ${PURPLE}██████╗${CYAN}███████╗${RESET}"
    sleep 0.05
    echo -e "${LIGHT_PURPLE}    ██╔════╝${PURPLE}██╔═══██╗${BLUE}██║  ██║${CYAN}██╔════╝${LIGHT_CYAN}██╔══██╗${LIGHT_BLUE}██╔════╝${LIGHT_PURPLE}████╗  ██║${PURPLE}██╔════╝${CYAN}██╔════╝${RESET}"
    sleep 0.05
    echo -e "${LIGHT_PURPLE}    ██║     ${PURPLE}██║   ██║${BLUE}███████║${CYAN}█████╗  ${LIGHT_CYAN}██████╔╝${LIGHT_BLUE}█████╗  ${LIGHT_PURPLE}██╔██╗ ██║${PURPLE}██║     ${CYAN}█████╗  ${RESET}"
    sleep 0.05
    echo -e "${LIGHT_PURPLE}    ██║     ${PURPLE}██║   ██║${BLUE}██╔══██║${CYAN}██╔══╝  ${LIGHT_CYAN}██╔══██╗${LIGHT_BLUE}██╔══╝  ${LIGHT_PURPLE}██║╚██╗██║${PURPLE}██║     ${CYAN}██╔══╝  ${RESET}"
    sleep 0.05
    echo -e "${LIGHT_PURPLE}    ╚██████╗${PURPLE}╚██████╔╝${BLUE}██║  ██║${CYAN}███████╗${LIGHT_CYAN}██║  ██║${LIGHT_BLUE}███████╗${LIGHT_PURPLE}██║ ╚████║${PURPLE}╚██████╗${CYAN}███████╗${RESET}"
    sleep 0.05
    echo -e "${LIGHT_PURPLE}     ╚═════╝ ${PURPLE}╚═════╝ ${BLUE}╚═╝  ╚═╝${CYAN}╚══════╝${LIGHT_CYAN}╚═╝  ╚═╝${LIGHT_BLUE}╚══════╝${LIGHT_PURPLE}╚═╝  ╚═══╝ ${PURPLE}╚═════╝${CYAN}╚══════╝${RESET}"
    sleep 0.1
    echo
    echo -e "${DIM}${CYAN}                        ♪ ♫ ${RESET}${BOLD}${WHITE}Orchestrate AI Personas${RESET}${DIM}${CYAN} ♫ ♪${RESET}"
    echo
    
    # Draw line with animation
    for i in {1..79}; do
        echo -ne "${LIGHT_BLUE}━${RESET}"
        sleep 0.01
    done
    echo
    echo
    echo -e "${CYAN}  Version:${RESET} ${BOLD}${WHITE}${COHERENCE_VERSION}${RESET}                                    ${CYAN}Many Voices.${RESET} ${BOLD}${LIGHT_PURPLE}One Vision.${RESET}"
    echo
    echo -e "${LIGHT_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

# Compact version for smaller terminals
print_compact_banner() {
    echo
    echo -e "${LIGHT_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo -e "${BOLD}${LIGHT_PURPLE}   COHERENCE ${RESET}${DIM}${WHITE}v${COHERENCE_VERSION}${RESET}   ${CYAN}♫${RESET} ${WHITE}Orchestrate AI Personas${RESET} ${CYAN}♫${RESET}"
    echo -e "${LIGHT_BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo
}

# Installation progress indicator (example usage)
installation_header() {
    print_banner
    echo -e "${BOLD}${WHITE}  Beginning Installation...${RESET}"
    echo
    echo -e "  ${CYAN}[${WHITE}◆◆◆◇◇${CYAN}]${RESET} Preparing environment..."
    sleep 1
    echo -e "  ${CYAN}[${WHITE}◆◆◆◆◇${CYAN}]${RESET} Installing dependencies..."
    sleep 1
    echo -e "  ${CYAN}[${WHITE}◆◆◆◆◆${CYAN}]${RESET} ${BOLD}${LIGHT_PURPLE}Complete!${RESET}"
    echo
}

# Example usage - uncomment the one you want to use:
print_banner              # Static version
# print_animated_banner    # Animated version
# print_compact_banner     # Compact version
# installation_header      # Full installation example