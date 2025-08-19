#!/bin/bash

# Fixed Header COHERENCE Installer
# Based on NVIDIA installer approach + APT non-interfering progress bar

# Burgundy to Purple Gradient Colors
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

# Global progress tracking
CURRENT_PROGRESS=0
CURRENT_STATUS="Initializing..."
ANIMATION_PID=""

# Terminal dimensions
TERM_ROWS=$(tput lines 2>/dev/null || echo "24")
TERM_COLS=$(tput cols 2>/dev/null || echo "80")
HEADER_HEIGHT=5
SCROLL_START=$((HEADER_HEIGHT + 1))
SCROLL_END=$((TERM_ROWS - 1))

# Version detection
get_coherence_version() {
    local version="4.1.5"
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

# Setup terminal regions (NVIDIA approach)
setup_fixed_regions() {
    # Clear screen
    clear
    
    # Hide cursor for cleaner display
    tput civis
    
    # Set scroll region - header area excluded from scrolling
    tput csr $SCROLL_START $SCROLL_END
    
    # Save cursor position
    tput sc
}

# Cleanup terminal
cleanup_terminal() {
    # Stop any running animation
    if [ -n "$ANIMATION_PID" ]; then
        kill $ANIMATION_PID 2>/dev/null
    fi
    rm -f "/tmp/coherence_installer_running"
    
    # Reset scroll region
    tput csr
    
    # Show cursor
    tput cnorm
    
    # Move to bottom
    tput cup $TERM_ROWS 1
    echo ""
}

# Draw COHERENCE text with gradient (simplified)
draw_coherence_logo() {
    tput cup 2 1
    echo -e "                    ${BURGUNDY}C${WINE}O${PURPLE}H${LIGHT_PURPLE}E${VIOLET}R${PURPLE}E${WINE}N${BURGUNDY}C${WINE}E${RESET}"
    
    tput cup 3 1
    echo -e "                ${GRAY}Unified Context Engineering${RESET}"
}

# Draw animated progress bar (APT approach - non-interfering)
draw_animated_progress_bar() {
    local progress=$1
    local status="$2"
    
    # Animated spinner characters
    local spinner_frame=$((SECONDS % 4))
    local spinners=('⣾' '⣽' '⣻' '⢿')
    local current_spinner="${spinners[$spinner_frame]}"
    
    # Progress bar construction
    local bar_width=50
    local filled=$((progress * bar_width / 100))
    local bar=""
    
    # Build gradient progress bar (fixed escape codes)
    for ((i=0; i<bar_width; i++)); do
        if [ $i -lt $filled ]; then
            if [ $i -lt $((bar_width/4)) ]; then
                bar+="\033[38;5;88m█\033[0m"  # BURGUNDY
            elif [ $i -lt $((bar_width/2)) ]; then
                bar+="\033[38;5;125m█\033[0m"  # WINE
            elif [ $i -lt $((bar_width*3/4)) ]; then
                bar+="\033[38;5;135m█\033[0m"  # PURPLE
            else
                bar+="\033[38;5;171m█\033[0m"  # LIGHT_PURPLE
            fi
        else
            bar+="\033[38;5;245m░\033[0m"  # GRAY
        fi
    done
    
    # Position cursor and draw progress line
    tput cup 4 1
    echo -e "${VIOLET}${current_spinner}${RESET} ${WHITE}${status}${RESET} [${bar}] ${BOLD}${WHITE}${progress}%${RESET} ${GRAY}│${RESET} ${CYAN}v${COHERENCE_VERSION}${RESET}"
}

# Draw complete fixed header
draw_fixed_header() {
    local progress=$1
    local status="$2"
    
    # Save current cursor position
    tput sc
    
    # Clear header area
    for ((i=1; i<=HEADER_HEIGHT; i++)); do
        tput cup $i 1
        tput el  # Clear entire line
    done
    
    # Draw header border
    tput cup 1 1
    echo -e "${BURGUNDY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    
    # Draw COHERENCE logo
    draw_coherence_logo
    
    # Draw animated progress bar
    draw_animated_progress_bar $progress "$status"
    
    # Draw bottom border
    tput cup 5 1
    echo -e "${BURGUNDY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    
    # Restore cursor position
    tput rc
}

# Background animation updater
animate_progress() {
    while [ -f "/tmp/coherence_installer_running" ]; do
        draw_fixed_header $CURRENT_PROGRESS "$CURRENT_STATUS"
        sleep 0.3  # Smooth animation
    done
}

# Update progress based on installer output
update_progress_from_line() {
    local line="$1"
    
    case "$line" in
        *"Cleaning previous builds"*)
            CURRENT_PROGRESS=5
            CURRENT_STATUS="Cleaning previous builds..."
            ;;
        *"Creating distribution structure"*)
            CURRENT_PROGRESS=15
            CURRENT_STATUS="Creating distribution structure..."
            ;;
        *"Generating persona templates"*)
            CURRENT_PROGRESS=25
            CURRENT_STATUS="Generating persona templates..."
            ;;
        *"Validating template system"*)
            CURRENT_PROGRESS=35
            CURRENT_STATUS="Validating template system..."
            ;;
        *"Copying payload directory"*)
            CURRENT_PROGRESS=45
            CURRENT_STATUS="Copying payload directory..."
            ;;
        *"Processing templates"*)
            CURRENT_PROGRESS=55
            CURRENT_STATUS="Processing templates..."
            ;;
        *"Installing dependencies"*)
            CURRENT_PROGRESS=65
            CURRENT_STATUS="Installing dependencies..."
            ;;
        *"Configuring environment"*)
            CURRENT_PROGRESS=75
            CURRENT_STATUS="Configuring environment..."
            ;;
        *"Setting up"*)
            CURRENT_PROGRESS=85
            CURRENT_STATUS="Setting up configuration..."
            ;;
        *"Installing Claude"*)
            CURRENT_PROGRESS=90
            CURRENT_STATUS="Installing Claude integration..."
            ;;
        *"Finalizing"*|*"Complete"*)
            CURRENT_PROGRESS=95
            CURRENT_STATUS="Finalizing installation..."
            ;;
        *"Installation complete"*)
            CURRENT_PROGRESS=100
            CURRENT_STATUS="Installation complete!"
            ;;
    esac
}

# Process installer output in scrolling region (FIX DUPLICATE ICONS)
process_installation_output() {
    local cmd="$1"
    
    # Move cursor to scrolling region
    tput cup $SCROLL_START 1
    
    # Execute command and process output line by line
    eval "$cmd" 2>&1 | while IFS= read -r line; do
        # Update progress based on line content
        update_progress_from_line "$line"
        
        # Clean line of duplicate icons (FIX THE DUPLICATE ICON PROBLEM)
        local clean_line="$line"
        clean_line=$(echo "$clean_line" | sed 's/✅ ✅/✅/g; s/⏳ ⏳/⏳/g; s/🔧 🔧/🔧/g; s/📝 📝/📝/g; s/❌ ❌/❌/g; s/⚠️ ⚠️/⚠️/g')
        
        # Add appropriate single icon if none exists
        if [[ ! "$clean_line" =~ ^[[:space:]]*[✅⏳🔧📝❌⚠️▶] ]]; then
            case "$clean_line" in
                *"Complete"*|*"SUCCESS"*|*"successfully"*|*"✅"*)
                    clean_line="  ${GREEN}✅${RESET} $clean_line"
                    ;;
                *"Processing"*|*"Installing"*|*"Creating"*|*"Copying"*)
                    clean_line="  ${CYAN}⏳${RESET} $clean_line"
                    ;;
                *"Configuring"*|*"Setting"*)
                    clean_line="  ${VIOLET}🔧${RESET} $clean_line"
                    ;;
                *"Generating"*|*"Writing"*)
                    clean_line="  ${PURPLE}📝${RESET} $clean_line"
                    ;;
                *"ERROR"*|*"FAILED"*)
                    clean_line="  ${RED}❌${RESET} $clean_line"
                    ;;
                *"WARNING"*)
                    clean_line="  ${YELLOW}⚠️${RESET} $clean_line"
                    ;;
                *)
                    # Only add arrow if line doesn't already have an icon
                    if [[ ! "$clean_line" =~ [✅⏳🔧📝❌⚠️] ]]; then
                        clean_line="  ${GRAY}▶${RESET} $clean_line"
                    fi
                    ;;
            esac
        fi
        
        # Output to scrolling region only
        echo "$clean_line"
    done
    
    # Final progress update
    CURRENT_PROGRESS=100
    CURRENT_STATUS="Installation complete!"
}

# Main installation function
run_fixed_header_installer() {
    local installer_cmd="$1"
    
    # Setup signal handlers
    trap cleanup_terminal EXIT INT TERM
    
    # Initialize terminal regions
    setup_fixed_regions
    
    # Initialize progress
    CURRENT_PROGRESS=0
    CURRENT_STATUS="Starting COHERENCE installation..."
    
    # Start background animation
    touch "/tmp/coherence_installer_running"
    animate_progress &
    ANIMATION_PID=$!
    
    # Draw initial header
    draw_fixed_header 0 "$CURRENT_STATUS"
    
    # Run installation in scrolling region
    process_installation_output "$installer_cmd"
    
    # Stop animation
    rm -f "/tmp/coherence_installer_running"
    kill $ANIMATION_PID 2>/dev/null
    ANIMATION_PID=""
    
    # Final header update
    draw_fixed_header 100 "Installation complete!"
    
    # Show completion message
    tput cup $((SCROLL_START + 2)) 1
    echo ""
    echo -e "${GREEN}🎉 ${BOLD}${WHITE}COHERENCE Installation Complete!${RESET} ${GREEN}🎉${RESET}"
    echo -e "${PURPLE}Unified Context Engineering is now active${RESET}"
    echo -e "${LIGHT_PURPLE}Type ${BOLD}${WHITE}coherence${RESET}${LIGHT_PURPLE} to get started${RESET}"
    echo ""
    
    # Wait a moment to show completion
    sleep 2
    
    # Cleanup
    cleanup_terminal
}

# Export function for use by install.sh
export -f setup_fixed_regions
export -f cleanup_terminal
export -f draw_fixed_header
export -f animate_progress
export -f process_installation_output
export -f run_fixed_header_installer

# Demo mode when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Fixed Header COHERENCE Installer - Demo Mode"
    echo ""
    
    # Demo the installation flow
    run_fixed_header_installer "echo 'Cleaning previous builds'; sleep 1; echo 'Creating distribution structure'; sleep 1; echo 'Generating persona templates'; sleep 1; echo 'Validating template system'; sleep 1; echo 'Installing dependencies'; sleep 1; echo 'Configuring environment'; sleep 1; echo 'Installation complete'"
fi