#!/bin/bash

# Simple Live Installer Display
# Based on proven approaches from Oh My Zsh, Rustup, and other successful installers
# Uses simple progress indicators that work reliably on WSL, Mac, and Linux

# Colors (with terminal capability detection)
if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
    # Burgundy to Purple Gradient Colors (256-color)
    BURGUNDY='\033[38;5;88m'      # Dark burgundy
    WINE='\033[38;5;125m'         # Wine red
    PURPLE='\033[38;5;135m'       # Medium purple
    LIGHT_PURPLE='\033[38;5;171m' # Light purple
    VIOLET='\033[38;5;207m'       # Violet
    CYAN='\033[38;5;51m'          # Accent cyan
    WHITE='\033[38;5;255m'        # Pure white
    GRAY='\033[38;5;245m'         # Gray
    GREEN='\033[38;5;82m'         # Success green
    RED='\033[38;5;196m'          # Error red
    YELLOW='\033[38;5;226m'       # Warning yellow
    BOLD='\033[1m'
    DIM='\033[2m'
    RESET='\033[0m'
else
    # Fallback for basic terminals
    BURGUNDY=''
    WINE=''
    PURPLE=''
    LIGHT_PURPLE=''
    VIOLET=''
    CYAN=''
    WHITE=''
    GRAY=''
    GREEN=''
    RED=''
    YELLOW=''
    BOLD=''
    DIM=''
    RESET=''
fi

# Get terminal width for responsive design
TERM_WIDTH=$(tput cols 2>/dev/null || echo "80")
if [ "$TERM_WIDTH" -lt 60 ]; then
    TERM_WIDTH=80
fi

# Version detection
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

# Progress tracking
PROGRESS_CURRENT=0
PROGRESS_TOTAL=100
PROGRESS_STATUS="Initializing..."

# Create a horizontal border
create_border() {
    local char="${1:-━}"
    local width="${2:-$TERM_WIDTH}"
    printf "%*s\n" "$width" "" | tr ' ' "$char"
}

# Draw the wave forms logo (simplified for reliability)
draw_wave_logo() {
    echo -e "${BURGUNDY}    ${WINE}◉${PURPLE}∾∾∾${LIGHT_PURPLE}∾∾${PURPLE}∾${WINE}◉${BURGUNDY}∾∾${WINE}∾${PURPLE}∾∾${LIGHT_PURPLE}∾∾${VIOLET}∾${PURPLE}∾${WINE}◉${PURPLE}∾∾∾${LIGHT_PURPLE}∾∾${BURGUNDY}    ${RESET}"
    echo -e "${WINE}  ${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾${WINE}◉${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${LIGHT_PURPLE}∾${PURPLE}∾${WINE}∾${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾${WINE}◉${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾${WINE}  ${RESET}"
    echo -e "${BURGUNDY} ${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾${WINE}∾${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${LIGHT_PURPLE}∾${PURPLE}∾${WINE}∾${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${LIGHT_PURPLE}∾${PURPLE}∾${WINE}∾${BURGUNDY}∾${WINE}∾${PURPLE}∾${LIGHT_PURPLE}∾${VIOLET}∾${PURPLE}∾ ${RESET}"
}

# Show initial banner (Oh My Zsh style)
show_startup_banner() {
    clear
    echo ""
    echo -e "${BURGUNDY}$(create_border ━ $TERM_WIDTH)${RESET}"
    echo ""
    draw_wave_logo
    echo ""
    echo -e "${BOLD}${PURPLE}                    COHERENCE ${WINE}• ${LIGHT_PURPLE}Unified Context Engineering${RESET}"
    echo -e "${GRAY}                        v${COHERENCE_VERSION} ${WINE}• ${PURPLE}Many Voices. ${BOLD}${LIGHT_PURPLE}One Vision.${RESET}"
    echo ""
    echo -e "${BURGUNDY}$(create_border ━ $TERM_WIDTH)${RESET}"
    echo ""
    echo -e "${CYAN}🚀 Starting Coherence installation...${RESET}"
    echo ""
}

# Update progress line (using carriage return method)
update_progress() {
    local current=$1
    local total=${2:-100}
    local status="$3"
    
    # Calculate percentage
    local percent=$((current * 100 / total))
    
    # Create progress bar (50 chars wide)
    local bar_width=50
    local filled=$((percent * bar_width / 100))
    local empty=$((bar_width - filled))
    
    # Build progress bar with gradient colors
    local bar=""
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
    
    for ((i=0; i<empty; i++)); do
        bar+="${GRAY}░${RESET}"
    done
    
    # Show progress line with carriage return (proven method)
    printf "\r${VIOLET}⏳${RESET} ${WHITE}%s${RESET} [%s] ${BOLD}${WHITE}%d%%${RESET}" "$status" "$bar" "$percent"
    
    # Store current progress
    PROGRESS_CURRENT=$current
    PROGRESS_STATUS="$status"
}

# Process installer output and show with colors
process_installer_line() {
    local line="$1"
    
    # Move to new line after progress bar
    echo ""
    
    # Add appropriate icon and color based on content
    case "$line" in
        *"✅"*|*"SUCCESS"*|*"Complete"*|*"successfully"*)
            echo -e "  ${GREEN}✅${RESET} $line"
            ;;
        *"❌"*|*"ERROR"*|*"FAILED"*|*"error"*)
            echo -e "  ${RED}❌${RESET} $line"
            ;;
        *"⚠️"*|*"WARNING"*|*"warning"*)
            echo -e "  ${YELLOW}⚠️${RESET} $line"
            ;;
        *"⏳"*|*"Processing"*|*"Installing"*|*"Creating"*|*"Copying"*)
            echo -e "  ${CYAN}⏳${RESET} $line"
            ;;
        *"📝"*|*"Generating"*|*"Writing"*)
            echo -e "  ${PURPLE}📝${RESET} $line"
            ;;
        *"🔧"*|*"Configuring"*|*"Setting"*)
            echo -e "  ${VIOLET}🔧${RESET} $line"
            ;;
        *)
            echo -e "  ${GRAY}▶${RESET} $line"
            ;;
    esac
}

# Map installer output to progress steps
map_progress() {
    local line="$1"
    
    case "$line" in
        *"Cleaning previous builds"*)
            update_progress 5 100 "Cleaning previous builds..."
            ;;
        *"Creating distribution structure"*)
            update_progress 15 100 "Creating distribution structure..."
            ;;
        *"Generating persona templates"*)
            update_progress 25 100 "Generating persona templates..."
            ;;
        *"Validating template system"*)
            update_progress 35 100 "Validating template system..."
            ;;
        *"Copying payload directory"*)
            update_progress 45 100 "Copying payload directory..."
            ;;
        *"Processing templates"*)
            update_progress 55 100 "Processing templates..."
            ;;
        *"Installing dependencies"*)
            update_progress 65 100 "Installing dependencies..."
            ;;
        *"Configuring environment"*)
            update_progress 75 100 "Configuring environment..."
            ;;
        *"Setting up"*)
            update_progress 85 100 "Setting up configuration..."
            ;;
        *"Installing Claude"*)
            update_progress 90 100 "Installing Claude integration..."
            ;;
        *"Finalizing"*|*"Complete"*)
            update_progress 95 100 "Finalizing installation..."
            ;;
    esac
}

# Show completion banner (Oh My Zsh style success)
show_completion_banner() {
    # Final progress
    update_progress 100 100 "Installation complete!"
    echo -e "\n"
    
    # Success banner
    echo -e "${BURGUNDY}$(create_border ━ $TERM_WIDTH)${RESET}"
    echo ""
    echo -e "${GREEN}🎉 ${BOLD}${WHITE}COHERENCE INSTALLATION COMPLETE!${RESET} ${GREEN}🎉${RESET}"
    echo ""
    draw_wave_logo
    echo ""
    echo -e "${CYAN}✨ Unified Context Engineering is now active${RESET}"
    echo -e "${PURPLE}🎭 All specialized agent personas are ready${RESET}"
    echo -e "${LIGHT_PURPLE}🚀 Type ${BOLD}${WHITE}coherence${RESET}${LIGHT_PURPLE} to get started${RESET}"
    echo ""
    echo -e "${BURGUNDY}$(create_border ━ $TERM_WIDTH)${RESET}"
    echo ""
}

# Main installer function
run_simple_live_installer() {
    local installer_cmd="$1"
    
    # Show startup banner
    show_startup_banner
    
    # Initial progress
    update_progress 0 100 "Starting installation..."
    
    # Run installer and process output
    eval "$installer_cmd" 2>&1 | while IFS= read -r line; do
        # Map line to progress if applicable
        map_progress "$line"
        
        # Display the line with appropriate formatting
        process_installer_line "$line"
    done
    
    # Show completion banner
    show_completion_banner
}

# Export function for use by install.sh
export -f show_startup_banner
export -f update_progress
export -f process_installer_line
export -f map_progress
export -f show_completion_banner
export -f run_simple_live_installer

# Demo mode when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Simple Live Installer Display - Demo Mode"
    echo ""
    
    # Demo the installation flow
    show_startup_banner
    
    # Simulate installation steps
    steps=(
        "Cleaning previous builds"
        "Creating distribution structure" 
        "Generating persona templates"
        "Validating template system"
        "Copying payload directory"
        "Processing templates"
        "Installing dependencies"
        "Configuring environment"
        "Setting up configuration"
        "Installing Claude integration"
        "Finalizing installation"
    )
    
    for step in "${steps[@]}"; do
        map_progress "$step"
        process_installer_line "$step"
        sleep 1
    done
    
    show_completion_banner
fi