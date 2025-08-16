#!/bin/bash

# Simple Fixed COHERENCE Banner - No complex terminal control
# Just redraw banner at top periodically while output scrolls below

# Burgundy to Purple Gradient Colors  
BURGUNDY='\033[38;5;88m'
WINE='\033[38;5;125m' 
PURPLE='\033[38;5;135m'
LIGHT_PURPLE='\033[38;5;171m'
VIOLET='\033[38;5;207m'
GRAY='\033[38;5;245m'
RESET='\033[0m'

# Animation control
BANNER_PID=""
BANNER_RUNNING=false

# Draw COHERENCE banner at top of screen
draw_coherence_banner() {
    # Save current cursor position
    tput sc
    
    # Move to top of screen and draw banner
    tput cup 0 0
    
    # Clear the top 4 lines
    tput el
    echo ""
    tput el
    echo ""
    tput el
    echo ""
    tput el
    
    # Go back to top and draw the banner
    tput cup 0 0
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    tput cup 1 0
    echo -e "                    ${BURGUNDY}C${WINE}O${PURPLE}H${LIGHT_PURPLE}E${VIOLET}R${PURPLE}E${WINE}N${BURGUNDY}C${WINE}E${RESET}"
    tput cup 2 0  
    echo -e "                ${GRAY}Unified Context Engineering${RESET}"
    tput cup 3 0
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Restore cursor position
    tput rc
}

# Background banner animation
animate_banner() {
    while [ "$BANNER_RUNNING" = true ]; do
        if [ -f "/tmp/coherence_banner_active" ]; then
            draw_coherence_banner
            sleep 0.5  # Refresh every half second
        else
            break
        fi
    done
}

# Start banner animation
start_banner() {
    BANNER_RUNNING=true
    touch "/tmp/coherence_banner_active"
    
    # Initial draw
    draw_coherence_banner
    
    # Move cursor below banner for output
    tput cup 4 0
    
    # Start background animation
    animate_banner &
    BANNER_PID=$!
}

# Stop banner animation  
stop_banner() {
    BANNER_RUNNING=false
    rm -f "/tmp/coherence_banner_active"
    
    if [ -n "$BANNER_PID" ]; then
        kill $BANNER_PID 2>/dev/null
        BANNER_PID=""
    fi
    
    # Final banner draw
    draw_coherence_banner
    
    # Move cursor below banner
    tput cup 4 0
    echo ""
}

# Run command with banner
run_with_banner() {
    local cmd="$1"
    
    # Setup
    start_banner
    
    # Run the command - output will naturally scroll below banner
    eval "$cmd"
    
    # Cleanup
    stop_banner
}

# Export functions
export -f draw_coherence_banner
export -f start_banner
export -f stop_banner
export -f run_with_banner

# Demo mode when run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Simple Fixed COHERENCE Banner - Demo Mode"
    echo ""
    
    # Demo the banner with some output
    run_with_banner "
        sleep 1
        echo 'Starting installation...'
        sleep 1
        echo 'Installing dependencies...' 
        sleep 1
        echo 'Configuring environment...'
        sleep 1
        echo 'Generating templates...'
        sleep 1
        echo 'Installation complete!'
    "
fi