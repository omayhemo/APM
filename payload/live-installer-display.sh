#!/bin/bash

# Live Installation Display Master Controller
# Creates fixed banner with scrolling installation output

# Burgundy to Purple Gradient Colors
BURGUNDY='\033[38;5;88m'      # Dark burgundy
WINE='\033[38;5;125m'         # Wine red
PURPLE='\033[38;5;135m'       # Medium purple
LIGHT_PURPLE='\033[38;5;171m' # Light purple
VIOLET='\033[38;5;207m'       # Violet
CYAN='\033[38;5;51m'          # Accent cyan
WHITE='\033[38;5;255m'        # Pure white
GRAY='\033[38;5;245m'         # Gray
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# Progress tracking variables
TOTAL_STEPS=0
CURRENT_STEP=0
CURRENT_STATUS="Initializing..."
SPINNER_POS=0
SPINNER_CHARS=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

# Get terminal dimensions with fallbacks
TERM_WIDTH=$(tput cols 2>/dev/null || echo "80")
TERM_HEIGHT=$(tput lines 2>/dev/null || echo "24")
BANNER_HEIGHT=9
SCROLL_START=$((BANNER_HEIGHT + 1))

# Validate terminal dimensions
if [ -z "$TERM_WIDTH" ] || [ "$TERM_WIDTH" -lt 40 ]; then
    TERM_WIDTH=80
fi
if [ -z "$TERM_HEIGHT" ] || [ "$TERM_HEIGHT" -lt 15 ]; then
    TERM_HEIGHT=24
fi

# Version detection (reuse from coherence-banner.sh)
get_coherence_version() {
    local version="4.1.1"
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [ -f "$script_dir/VERSION" ]; then
        version=$(cat "$script_dir/VERSION" | head -1 | tr -d '\n\r')
    elif [ -f "$script_dir/../VERSION" ]; then
        version=$(cat "$script_dir/../VERSION" | head -1 | tr -d '\n\r')
    elif [ -n "$COHERENCE_VERSION" ]; then
        version="$COHERENCE_VERSION"
    fi
    
    echo "$version"
}

COHERENCE_VERSION=$(get_coherence_version)

# Terminal control functions
setup_terminal() {
    clear
    # Don't try to set scrolling regions - just clear and start fresh
    printf "\033[?25l" 2>/dev/null || true                           # Hide cursor
}

cleanup_terminal() {
    printf "\033[r" 2>/dev/null || true                              # Reset scrolling region
    printf "\033[?25h" 2>/dev/null || true                           # Show cursor
    printf "\033[${TERM_HEIGHT};1H" 2>/dev/null || true              # Move to bottom
    echo ""
}

# Draw the wave forms logo (two concentric circular wave forms)
draw_wave_logo() {
    local line1="${BURGUNDY}    ${WINE}◉${PURPLE}∾∾∾${LIGHT_PURPLE}∾∾${PURPLE}∾${WINE}◉${BURGUNDY}∾∾${WINE}∾${PURPLE}∾∾${LIGHT_PURPLE}∾∾${VIOLET}∾${PURPLE}∾${WINE}◉${PURPLE}∾∾∾${LIGHT_PURPLE}∾∾${BURGUNDY}    ${RESET}"
    local line2="${WINE}  ${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾${WINE}◉${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${LIGHT_PURPLE}∾${PURPLE}∾${WINE}∾${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾${WINE}◉${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾${WINE}  ${RESET}"
    local line3="${BURGUNDY} ${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾${WINE}∾${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${LIGHT_PURPLE}∾${PURPLE}∾${WINE}∾${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${LIGHT_PURPLE}∾${PURPLE}∾${WINE}∾${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾ ${RESET}"
    
    echo -e "$line1"
    echo -e "$line2"  
    echo -e "$line3"
}

# Draw the fixed banner
draw_banner() {
    local progress=$1
    local status="$2"
    local spinner_char="${SPINNER_CHARS[$SPINNER_POS]}"
    
    # Save position, reset scroll region, move to top
    printf "\033[s\033[r\033[1;1H"
    
    # Clear banner area
    for ((i=1; i<=BANNER_HEIGHT; i++)); do
        printf "\033[${i};1H\033[K"
    done
    
    # Move to top and draw banner
    printf "\033[1;1H"
    
    # Top border
    echo -e "${BURGUNDY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    
    # Logo
    draw_wave_logo
    
    # Title
    echo -e "${BOLD}${PURPLE}                    COHERENCE ${WINE}• ${LIGHT_PURPLE}Unified Context Engineering${RESET}"
    
    # Progress bar
    local bar_width=50
    local filled=$((progress * bar_width / 100))
    local bar=""
    
    # Build progress bar with gradient
    for ((i=0; i<filled; i++)); do 
        if [ $i -lt $((bar_width/4)) ]; then
            bar+="${BURGUNDY}█${RESET}"
        elif [ $i -lt $((bar_width/2)) ]; then
            bar+="${WINE}█${RESET}"
        elif [ $i -lt $((bar_width*3/4)) ]; then
            bar+="${PURPLE}█${RESET}"
        else
            bar+="${LIGHT_PURPLE}█${RESET}"
        fi
    done
    
    for ((i=filled; i<bar_width; i++)); do 
        bar+="${GRAY}░${RESET}"
    done
    
    # Status line with spinner, progress bar, and info
    printf "${VIOLET}${spinner_char}${RESET} ${WHITE}${status}${RESET}\n"
    printf "[${bar}] ${BOLD}${WHITE}${progress}%%${RESET} ${GRAY}│${RESET} ${CYAN}v${COHERENCE_VERSION}${RESET} ${GRAY}│${RESET} ${PURPLE}Many Voices.${RESET} ${BOLD}${LIGHT_PURPLE}One Vision.${RESET}\n"
    
    # Bottom border
    echo -e "${BURGUNDY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    
    # Restore position and scroll region
    printf "\033[u\033[${SCROLL_START};${TERM_HEIGHT}r"
    
    # Increment spinner
    SPINNER_POS=$(((SPINNER_POS + 1) % ${#SPINNER_CHARS[@]}))
}

# Update progress
update_progress() {
    local new_step=$1
    local new_status="$2"
    
    if [ $new_step -gt $CURRENT_STEP ]; then
        CURRENT_STEP=$new_step
    fi
    
    if [ -n "$new_status" ]; then
        CURRENT_STATUS="$new_status"
    fi
    
    local progress=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    draw_banner $progress "$CURRENT_STATUS"
}

# Parse installer output and extract progress
parse_installer_output() {
    local line="$1"
    
    # Look for progress markers
    case "$line" in
        *"Cleaning previous builds"*)
            update_progress 1 "Cleaning previous builds..."
            ;;
        *"Creating distribution structure"*)
            update_progress 2 "Creating distribution structure..."
            ;;
        *"Generating persona templates"*)
            update_progress 3 "Generating persona templates..."
            ;;
        *"Validating template system"*)
            update_progress 4 "Validating template system..."
            ;;
        *"Copying payload directory"*)
            update_progress 5 "Copying payload directory..."
            ;;
        *"Processing templates"*)
            update_progress 6 "Processing templates..."
            ;;
        *"Installing dependencies"*)
            update_progress 7 "Installing dependencies..."
            ;;
        *"Configuring environment"*)
            update_progress 8 "Configuring environment..."
            ;;
        *"Setting up"*)
            update_progress 9 "Setting up configuration..."
            ;;
        *"Installing Claude"*)
            update_progress 10 "Installing Claude integration..."
            ;;
        *"Finalizing"*|*"Complete"*)
            update_progress 12 "Installation complete!"
            ;;
        *)
            # Generic progress updates based on any activity
            if [ $CURRENT_STEP -lt $TOTAL_STEPS ]; then
                draw_banner $((CURRENT_STEP * 100 / TOTAL_STEPS)) "$CURRENT_STATUS"
            fi
            ;;
    esac
}

# Main execution function
run_live_installer() {
    local installer_cmd="$1"
    
    # Setup terminal
    setup_terminal
    
    # Show banner once at start
    draw_banner 0 "Starting Coherence Installation..."
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Run installer normally without trying to maintain fixed banner
    eval "$installer_cmd"
    
    # Final message
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 Coherence installation completed successfully!"
    
    # Cleanup
    cleanup_terminal
}

# Export functions for use by install.sh
export -f setup_terminal
export -f cleanup_terminal  
export -f draw_banner
export -f update_progress
export -f parse_installer_output
export -f run_live_installer

# If run directly, show demo
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Live Installer Display - Demo Mode"
    echo "This would normally be called by install.sh"
    
    # Demo the banner
    setup_terminal
    for i in {0..100..10}; do
        draw_banner $i "Demo progress step $((i/10))..."
        sleep 0.5
    done
    cleanup_terminal
fi