#!/bin/bash

# Installer Progress Tracker
# Monitors and parses install.sh output for progress tracking

# Source the live display functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/live-installer-display.sh"

# Enhanced progress markers with more granular tracking
declare -A PROGRESS_MARKERS=(
    # Early setup (0-20%)
    ["Cleaning previous builds"]=5
    ["Creating distribution structure"]=8
    ["Generating persona templates"]=12
    ["Running production persona generation"]=15
    ["Template system validation passed"]=20
    
    # Core installation (20-60%)
    ["Copying payload directory"]=25
    ["sending incremental file list"]=30
    ["templates/"]=35
    ["Claude integration"]=40
    ["Setting up configuration"]=45
    ["Installing dependencies"]=50
    ["Configuring environment"]=55
    ["Processing templates"]=60
    
    # Finalization (60-100%)
    ["Setting up agent personas"]=65
    ["Configuring voice notifications"]=70
    ["Installing Claude settings"]=75
    ["Optimizing performance"]=80
    ["Generating documentation"]=85
    ["Finalizing installation"]=90
    ["Installation completed"]=95
    ["Enjoy using Coherence"]=100
)

# Status message mapping for user-friendly display
declare -A STATUS_MESSAGES=(
    ["Cleaning previous builds"]="Preparing workspace..."
    ["Creating distribution structure"]="Creating directory structure..."
    ["Generating persona templates"]="Building AI agent personas..."
    ["Template system validation"]="Validating templates..."
    ["Copying payload directory"]="Installing core files..."
    ["templates/"]="Processing template files..."
    ["Claude integration"]="Integrating with Claude..."
    ["Setting up configuration"]="Configuring environment..."
    ["Installing dependencies"]="Installing dependencies..."
    ["agent personas"]="Setting up AI agents..."
    ["voice notifications"]="Configuring notifications..."
    ["Claude settings"]="Finalizing Claude setup..."
    ["Generating documentation"]="Building documentation..."
    ["Finalizing installation"]="Completing installation..."
    ["Installation completed"]="Installation successful!"
)

# Advanced progress tracking
track_installation_progress() {
    local current_progress=0
    local last_progress=0
    local line_count=0
    local start_time=$(date +%s)
    
    # Initial display
    setup_terminal
    draw_banner 0 "Initializing Coherence installation..."
    printf "\033[${SCROLL_START};1H"
    
    while IFS= read -r line; do
        ((line_count++))
        
        # Look for specific progress markers
        local found_marker=""
        local new_progress=0
        local status_msg=""
        
        for marker in "${!PROGRESS_MARKERS[@]}"; do
            if [[ "$line" == *"$marker"* ]]; then
                found_marker="$marker"
                new_progress=${PROGRESS_MARKERS[$marker]}
                status_msg="${STATUS_MESSAGES[$marker]:-$marker}"
                break
            fi
        done
        
        # If we found a specific marker, update progress
        if [ -n "$found_marker" ] && [ $new_progress -gt $current_progress ]; then
            current_progress=$new_progress
            draw_banner $current_progress "$status_msg"
        # Otherwise, make incremental progress based on activity
        elif [ $((line_count % 10)) -eq 0 ] && [ $current_progress -lt 90 ]; then
            # Gentle progress increment for active lines
            current_progress=$((current_progress + 1))
            draw_banner $current_progress "Processing installation..."
        fi
        
        # Enhanced output formatting with icons and colors
        format_output_line "$line"
        
        # Update last progress
        last_progress=$current_progress
        
    done
    
    # Ensure we reach 100% at the end
    if [ $current_progress -lt 100 ]; then
        draw_banner 100 "Installation complete! 🎉"
    fi
    
    # Calculate and display installation time
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Final completion message
    echo ""
    echo -e "${WINE}🎉${RESET} ${BOLD}${PURPLE}Coherence installation completed successfully!${RESET}"
    echo -e "${GRAY}Installation took ${WHITE}${duration}s${GRAY} and processed ${WHITE}${line_count}${GRAY} operations.${RESET}"
    echo ""
    
    # Wait for user to see completion
    sleep 3
    
    cleanup_terminal
}

# Format output lines with appropriate icons and colors
format_output_line() {
    local line="$1"
    
    # Skip empty lines
    [ -z "$line" ] && return
    
    # Icons and color coding based on content
    case "$line" in
        # Success messages
        *"✅"*|*"SUCCESS"*|*"Complete"*|*"passed"*|*"successful"*)
            echo -e "${WINE}✅${RESET} ${WHITE}$line${RESET}"
            ;;
        # Error messages  
        *"❌"*|*"ERROR"*|*"FAILED"*|*"failed"*|*"Error:"*)
            echo -e "${BURGUNDY}❌${RESET} ${BURGUNDY}$line${RESET}"
            ;;
        # Warning messages
        *"⚠️"*|*"WARNING"*|*"warning"*)
            echo -e "${VIOLET}⚠️${RESET} ${VIOLET}$line${RESET}"
            ;;
        # Progress/activity messages
        *"⏳"*|*"Processing"*|*"Installing"*|*"Copying"*|*"Creating"*|*"Generating"*)
            echo -e "${PURPLE}⏳${RESET} ${PURPLE}$line${RESET}"
            ;;
        # File operations
        *".template"*|*".md"*|*".sh"*|*".json"*)
            echo -e "${GRAY}📄${RESET} ${GRAY}$line${RESET}"
            ;;
        # Directory operations
        *"/"*|*"mkdir"*|*"directory"*)
            echo -e "${WINE}📁${RESET} ${WINE}$line${RESET}"
            ;;
        # Configuration
        *"config"*|*"setting"*|*"environment"*)
            echo -e "${LIGHT_PURPLE}⚙️${RESET} ${LIGHT_PURPLE}$line${RESET}"
            ;;
        # Default (informational)
        *)
            # Only show non-empty, non-whitespace lines
            if [[ "$line" =~ [^[:space:]] ]]; then
                echo -e "${GRAY}ℹ️${RESET} $line"
            fi
            ;;
    esac
}

# Function to run installer with live tracking
run_installer_with_tracking() {
    local installer_command="$1"
    shift
    local installer_args="$@"
    
    echo -e "${PURPLE}Starting Coherence installation with live progress tracking...${RESET}"
    echo ""
    
    # Execute installer and pipe through progress tracker
    bash "$installer_command" $installer_args 2>&1 | track_installation_progress
    
    local exit_code=${PIPESTATUS[0]}
    
    if [ $exit_code -eq 0 ]; then
        echo -e "${WINE}🎊${RESET} ${BOLD}${PURPLE}Welcome to Coherence!${RESET} ${WINE}Your unified context engineering platform is ready.${RESET}"
    else
        echo -e "${BURGUNDY}💥${RESET} ${BURGUNDY}Installation encountered issues. Exit code: $exit_code${RESET}"
    fi
    
    return $exit_code
}

# Export functions for use by install.sh
export -f track_installation_progress
export -f format_output_line  
export -f run_installer_with_tracking

# Demo mode for testing
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Progress Tracker Demo Mode"
    echo "Simulating installation progress..."
    
    # Simulate installer output
    {
        echo "Cleaning previous builds..."
        sleep 1
        echo "Creating distribution structure..."
        sleep 1
        echo "Generating persona templates from JSON definitions..."
        sleep 2
        echo "✅ Template system validation passed: 451 templates ready"
        sleep 1
        echo "Copying payload directory as installer..."
        sleep 2
        echo "templates/claude/commands/"
        sleep 1
        echo "⏳ Setting up configuration files..."
        sleep 1
        echo "Installing Claude integration..."
        sleep 2
        echo "✅ Installation completed!"
    } | track_installation_progress
fi