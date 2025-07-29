#!/bin/bash

# AP Mapping Installation Script
# Template-based installer

set -e

# Script identification for cleanup
INSTALLER_SIGNATURE="AP Mapping Installation Script - Template-based installer"

# Colors
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check for --defaults flag
USE_DEFAULTS=false
if [ "$1" = "--defaults" ] || [ "$1" = "-d" ]; then
    USE_DEFAULTS=true
    shift # Remove the flag from arguments
fi

echo "=========================================="
echo "   APM Framework Installation v3.2.0"
echo "   Native Sub-Agent Architecture"
echo "=========================================="
echo ""

# Get the directory where this script is located (installer dir)
INSTALLER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIST_DIR="$(dirname "$INSTALLER_DIR")"

# Get target directory (default to current directory)
TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    echo "Error: Target directory '$1' does not exist"
    exit 1
}

# Special handling when running from distribution directory without arguments
if [ "$#" -eq 0 ] && [ -f "$INSTALLER_DIR/install.sh" ] && [ -d "$DIST_DIR/.apm/agents" ]; then
    if [ "$USE_DEFAULTS" = true ]; then
        echo "Running with defaults - using current directory as project"
        TARGET_DIR="$DIST_DIR"
        SKIP_COPY="true"
    else
        echo "=========================================="
        echo "APM Framework Quick Setup v3.2.0"
        echo "=========================================="
        echo ""
        echo "You're running the installer from the extracted distribution."
        echo ""
        echo -e "${GREEN}Where would you like to install APM Framework?${NC}"
        echo -e "${BLUE}"
        echo "1) Use this directory as the project (quick start)"
        echo "2) Create new project in parent directory"
        echo "3) Install to existing project (specify path)"
        echo "4) Show manual installation options"
        echo -e "${NC}"
        printf "${YELLOW}Enter choice (1-4) [1]: ${NC}"
        read CHOICE
        CHOICE="${CHOICE:-1}"
        
        case $CHOICE in
            1)
                echo ""
                echo "Using current directory as project directory."
                echo "This will configure AP Mapping in-place without copying files."
                TARGET_DIR="$DIST_DIR"
                SKIP_COPY="true"
                echo ""
                ;;
            2)
                echo ""
                printf "${YELLOW}Enter project name [my-project]: ${NC}"
                read PROJ_NAME
                PROJ_NAME="${PROJ_NAME:-my-project}"
                TARGET_DIR="../$PROJ_NAME"
                
                # Create project directory
                mkdir -p "$TARGET_DIR"
                TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
                echo "Creating new project at: $TARGET_DIR"
                echo ""
                ;;
            3)
                echo ""
                printf "${YELLOW}Enter path to existing project: ${NC}"
                read PROJ_PATH
                if [ -z "$PROJ_PATH" ]; then
                    echo "Error: No path specified"
                    exit 1
                fi
                TARGET_DIR="$(cd "$PROJ_PATH" 2>/dev/null && pwd)" || {
                    echo "Error: Invalid path '$PROJ_PATH'"
                    exit 1
                }
                ;;
            4)
                echo ""
                echo "Manual Installation Options:"
                echo ""
                echo "  # Install to specific directory:"
                echo "  ./install.sh /path/to/your/project"
                echo ""
                echo "  # Install to parent directory:"
                echo "  ./install.sh .."
                echo ""
                echo "  # Create and install to new project:"
                echo "  mkdir ../my-project && ./install.sh ../my-project"
                echo ""
                exit 0
                ;;
            *)
                echo "Invalid choice. Exiting."
                exit 1
                ;;
        esac
    fi
fi

# Set project root
PROJECT_ROOT="$TARGET_DIR"

# Set up workspace structure with APM infrastructure hidden (early setup)
APM_ROOT="$PROJECT_ROOT/.apm"
AP_ROOT="$APM_ROOT/agents"

# Function to get user input with default
get_input() {
    local prompt="$1"
    local default="$2"
    local response

    if [ "$USE_DEFAULTS" = true ]; then
        echo "$default"
    else
        printf "${YELLOW}%s [%s]: ${NC}" "$prompt" "$default" >&2
        read response
        echo "${response:-$default}"
    fi
}

# Function to create directory if it doesn't exist
ensure_dir() {
    local dir="$1"
    if [ ! -d "$dir" ]; then
        echo "Creating directory: $dir"
        mkdir -p "$dir"
    fi
}

# Function to check and install audio dependencies
check_audio_dependencies() {
    local provider="$1"
    
    case "$provider" in
        elevenlabs)
            # ElevenLabs needs MP3 player
            if ! command -v mpg123 >/dev/null 2>&1 && \
               ! command -v ffplay >/dev/null 2>&1 && \
               ! command -v afplay >/dev/null 2>&1; then
                return 1
            fi
            ;;
        piper|system)
            # Piper/System need WAV player
            if ! command -v aplay >/dev/null 2>&1 && \
               ! command -v play >/dev/null 2>&1 && \
               ! command -v afplay >/dev/null 2>&1; then
                return 1
            fi
            ;;
    esac
    return 0
}

# Function to detect available audio players
detect_audio_player() {
    echo "Detecting available audio players..."
    
    # Detect WSL2 environment
    IS_WSL2=false
    if grep -qi microsoft /proc/version 2>/dev/null; then
        IS_WSL2=true
        echo "✓ Detected WSL2 environment"
    fi
    
    # Check for WAV players first (needed for Piper)
    # Priority order for WSL2: paplay, aplay, play
    # Priority order for others: aplay, paplay, play
    if [ "$IS_WSL2" = true ]; then
        # WSL2: Prefer paplay (PulseAudio)
        if command -v paplay >/dev/null 2>&1; then
            WAV_PLAYER="paplay"
            WAV_PLAYER_ARGS=""
            echo "✓ Found paplay (PulseAudio) for WAV playback - preferred for WSL2"
        elif command -v aplay >/dev/null 2>&1; then
            WAV_PLAYER="aplay"
            WAV_PLAYER_ARGS="-q"
            echo "✓ Found aplay (ALSA) for WAV playback"
        elif command -v play >/dev/null 2>&1; then
            WAV_PLAYER="play"
            WAV_PLAYER_ARGS="-q"
            echo "✓ Found play (SoX) for WAV playback"
        else
            WAV_PLAYER="none"
            WAV_PLAYER_ARGS=""
        fi
    else
        # Non-WSL2: Standard order
        if command -v aplay >/dev/null 2>&1; then
            WAV_PLAYER="aplay"
            WAV_PLAYER_ARGS="-q"
            echo "✓ Found aplay (ALSA) for WAV playback"
        elif command -v paplay >/dev/null 2>&1; then
            WAV_PLAYER="paplay"
            WAV_PLAYER_ARGS=""
            echo "✓ Found paplay (PulseAudio) for WAV playback"
        elif command -v play >/dev/null 2>&1; then
            WAV_PLAYER="play"
            WAV_PLAYER_ARGS="-q"
            echo "✓ Found play (SoX) for WAV playback"
        elif command -v afplay >/dev/null 2>&1; then
            WAV_PLAYER="afplay"
            WAV_PLAYER_ARGS=""
            echo "✓ Found afplay (macOS) for WAV playback"
        else
            WAV_PLAYER="none"
            WAV_PLAYER_ARGS=""
        fi
    fi
    
    # Check for MP3 players
    if command -v mpg123 >/dev/null 2>&1; then
        AUDIO_PLAYER="mpg123"
        AUDIO_PLAYER_ARGS="-q"
        echo "✓ Found mpg123 for MP3 playback"
    elif command -v play >/dev/null 2>&1; then
        AUDIO_PLAYER="play"
        AUDIO_PLAYER_ARGS="-q"
        echo "✓ Found sox/play for audio playback"
    elif command -v afplay >/dev/null 2>&1; then
        AUDIO_PLAYER="afplay"
        AUDIO_PLAYER_ARGS=""
        echo "✓ Found afplay (macOS) for audio playback"
    elif command -v ffplay >/dev/null 2>&1; then
        AUDIO_PLAYER="ffplay"
        AUDIO_PLAYER_ARGS="-nodisp -autoexit -loglevel quiet"
        echo "✓ Found ffplay for audio playback"
    else
        AUDIO_PLAYER="none"
        AUDIO_PLAYER_ARGS=""
        if [ "$WAV_PLAYER" = "none" ]; then
            echo -e "${YELLOW}⚠ No audio players found. Audio will not work.${NC}"
            echo ""
            echo "To enable audio, install one of:"
            if [ "$IS_WSL2" = true ]; then
                echo "  - WSL2: sudo apt-get install pulseaudio-utils (recommended)"
                echo "  - WSL2: sudo apt-get install alsa-utils"
            else
                echo "  - Linux: sudo apt-get install alsa-utils"
                echo "  - Linux: sudo apt-get install mpg123"
            fi
            echo "  - macOS: brew install mpg123"
        fi
    fi
    
    # For Piper, use WAV player as primary audio player if no MP3 player
    if [ "$TTS_PROVIDER" = "piper" ] && [ "$AUDIO_PLAYER" = "none" ] && [ "$WAV_PLAYER" != "none" ]; then
        AUDIO_PLAYER="$WAV_PLAYER"
        AUDIO_PLAYER_ARGS="$WAV_PLAYER_ARGS"
        echo "✓ Using $WAV_PLAYER for Piper TTS audio output"
    fi
    
    # Check for ffmpeg (for conversion)
    if command -v ffmpeg >/dev/null 2>&1; then
        FFMPEG_AVAILABLE="true"
        echo "✓ Found ffmpeg for audio conversion"
    else
        FFMPEG_AVAILABLE="false"
    fi
}

# Function to replace variables in templates
replace_variables() {
    local input_file="$1"
    local output_file="$2"
    
    # Create a temporary file for processing
    local temp_file=$(mktemp)
    
    # Copy input to temp file
    cp "$input_file" "$temp_file"
    
    # Determine sed syntax based on OS
    local sed_inplace=""
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS requires empty string for backup extension
        sed_inplace="-i ''"
    else
        # Linux/other systems
        sed_inplace="-i"
    fi
    
    # Replace all variables using OS-appropriate sed syntax
    sed $sed_inplace "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" "$temp_file"
    sed $sed_inplace "s|{{PROJECT_ROOT}}|$PROJECT_ROOT|g" "$temp_file"
    sed $sed_inplace "s|{{AP_ROOT}}|$AP_ROOT|g" "$temp_file"
    sed $sed_inplace "s|{{PROJECT_DOCS}}|$PROJECT_DOCS|g" "$temp_file"
    sed $sed_inplace "s|{{BACKLOG_PATH}}|$BACKLOG_PATH|g" "$temp_file"
    sed $sed_inplace "s|{{CLAUDE_DIR}}|$CLAUDE_DIR|g" "$temp_file"
    sed $sed_inplace "s|{{CLAUDE_COMMANDS_DIR}}|$CLAUDE_COMMANDS_DIR|g" "$temp_file"
    sed $sed_inplace "s|{{NOTES_TYPE}}|$NOTES_TYPE|g" "$temp_file"
    sed $sed_inplace "s|{{SESSION_NOTES_PATH}}|$SESSION_NOTES_PATH|g" "$temp_file"
    sed $sed_inplace "s|{{RULES_PATH}}|$RULES_PATH|g" "$temp_file"
    sed $sed_inplace "s|{{ARCHIVE_PATH}}|$ARCHIVE_PATH|g" "$temp_file"
    sed $sed_inplace "s|{{FALLBACK_SESSION_NOTES_PATH}}|$FALLBACK_SESSION_NOTES_PATH|g" "$temp_file"
    sed $sed_inplace "s|{{FALLBACK_RULES_PATH}}|$FALLBACK_RULES_PATH|g" "$temp_file"
    sed $sed_inplace "s|{{FALLBACK_ARCHIVE_PATH}}|$FALLBACK_ARCHIVE_PATH|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_ORCHESTRATOR}}|$SPEAK_ORCHESTRATOR|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_DEVELOPER}}|$SPEAK_DEVELOPER|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_ARCHITECT}}|$SPEAK_ARCHITECT|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_ANALYST}}|$SPEAK_ANALYST|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_QA}}|$SPEAK_QA|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_PM}}|$SPEAK_PM|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_PO}}|$SPEAK_PO|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_SM}}|$SPEAK_SM|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_DESIGN_ARCHITECT}}|$SPEAK_DESIGN_ARCHITECT|g" "$temp_file"
    sed $sed_inplace "s|{{AP_CONFIG_FILE}}|$AP_CONFIG_FILE|g" "$temp_file"
    sed $sed_inplace "s|{{AP_KB_FILE}}|$AP_KB_FILE|g" "$temp_file"
    sed $sed_inplace "s|{{AP_CHECKLISTS}}|$AP_CHECKLISTS|g" "$temp_file"
    sed $sed_inplace "s|{{AP_DATA}}|$AP_DATA|g" "$temp_file"
    sed $sed_inplace "s|{{AP_PERSONAS}}|$AP_PERSONAS|g" "$temp_file"
    sed $sed_inplace "s|{{AP_TASKS}}|$AP_TASKS|g" "$temp_file"
    sed $sed_inplace "s|{{AP_TEMPLATES}}|$AP_TEMPLATES|g" "$temp_file"
    sed $sed_inplace "s|{{AP_DOCS}}|$AP_DOCS|g" "$temp_file"
    sed $sed_inplace "s|{{AP_VOICE}}|$AP_VOICE|g" "$temp_file"
    sed $sed_inplace "s|{{AP_PYTHON}}|$AP_PYTHON|g" "$temp_file"
    sed $sed_inplace "s|{{AP_MONITORING}}|$AP_MONITORING|g" "$temp_file"
    sed $sed_inplace "s|{{AP_SCRIPTS}}|$AP_SCRIPTS|g" "$temp_file"
    sed $sed_inplace "s|{{AP_SUBTASKS}}|$AP_SUBTASKS|g" "$temp_file"
    sed $sed_inplace "s|{{SPEAK_AGENT}}|$SPEAK_AGENT|g" "$temp_file"
    sed $sed_inplace "s|{{APM_ROOT}}|$APM_ROOT|g" "$temp_file"
    sed $sed_inplace "s|{{PLANNING_ROOT}}|$PLANNING_ROOT|g" "$temp_file"
    
    # Move the processed file to the output location
    mv "$temp_file" "$output_file"
}

# Function to merge APM section into user's root CLAUDE.md file
merge_apm_section() {
    local root_claude_md="$1"
    local template_file="$INSTALLER_DIR/template.claude.md"
    
    echo "Merging APM section into root CLAUDE.md..."
    
    # If the file doesn't exist, create it with just the APM section
    if [ ! -f "$root_claude_md" ]; then
        echo "Creating new CLAUDE.md file in project root..."
        cp "$template_file" "$root_claude_md"
        echo "✓ Created CLAUDE.md with APM section"
        return 0
    fi
    
    # File exists, check for APM section and merge
    if grep -q "<BEGIN-APM-CLAUDE-MERGE>" "$root_claude_md"; then
        echo "Existing APM section(s) found, cleaning and replacing with latest version..."
        
        # Create temporary files
        local temp_clean=$(mktemp)
        local temp_new=$(mktemp)
        
        # First, remove ALL APM sections (in case of duplicates)
        # This awk script removes everything between BEGIN and END tags, inclusive
        awk '
            /<BEGIN-APM-CLAUDE-MERGE>/ { in_apm = 1; next }
            /<END-APM-CLAUDE-MERGE>/ { in_apm = 0; next }
            !in_apm { print }
        ' "$root_claude_md" > "$temp_clean"
        
        # Remove any trailing blank lines from the cleaned content
        sed -i -e :a -e '/^\s*$/d;N;ba' "$temp_clean"
        
        # Now build the new file
        if [ -s "$temp_clean" ]; then
            # If there's content before APM section
            cat "$temp_clean" > "$temp_new"
            echo "" >> "$temp_new"  # Add separator
        fi
        
        # Add the new APM section
        cat "$template_file" >> "$temp_new"
        
        # Replace original file
        mv "$temp_new" "$root_claude_md"
        
        # Cleanup
        rm -f "$temp_clean"
        
        echo "✓ Cleaned duplicates and updated APM section in CLAUDE.md"
    else
        echo "No existing APM section found, appending to end of file..."
        
        # Add a newline if file doesn't end with one
        if [ -s "$root_claude_md" ] && [ "$(tail -c1 "$root_claude_md" | wc -l)" -eq 0 ]; then
            echo "" >> "$root_claude_md"
        fi
        
        # Append APM section
        cat "$template_file" >> "$root_claude_md"
        
        echo "✓ Added APM section to CLAUDE.md"
    fi
}

# Function to generate agents directory from templates
generate_agents_from_templates() {
    echo "Processing template files..."
    
    # Find all template files and process them
    find "$INSTALLER_DIR/templates/agents" -name "*.template" -type f | while read template_file; do
        # Calculate relative path from templates/agents
        rel_path="${template_file#$INSTALLER_DIR/templates/agents/}"
        
        # Remove .template extension
        rel_path="${rel_path%.template}"
        
        # Create output file path
        output_file="$AP_ROOT/$rel_path"
        
        # Create output directory
        mkdir -p "$(dirname "$output_file")"
        
        # Process template through replace_variables
        replace_variables "$template_file" "$output_file"
        
        echo "  Generated: $rel_path"
    done
    
    echo "✅ Generated agents directory from templates"
}

echo ""
echo "Step 1: Generating Agents Directory from Templates"
echo "------------------------------------------------"

# Generate agents directory from templates
if [ "$SKIP_COPY" != "true" ]; then
    if [ -d "$INSTALLER_DIR/templates/agents" ]; then
        echo "Generating agents directory from templates to: $AP_ROOT"
        
        # Clean up existing .apm folder to ensure fresh installation
        if [ -d "$APM_ROOT" ]; then
            echo "Removing existing .apm folder for clean installation..."
            rm -rf "$APM_ROOT"
            echo "✓ Existing .apm folder removed"
        fi
        
        ensure_dir "$APM_ROOT"
        
        # Generate agents directory structure from templates
        generate_agents_from_templates
        
        # Copy non-template documentation files
        echo "Copying documentation files..."
        if [ -d "$INSTALLER_DIR/templates/agents/docs" ]; then
            if [ -n "$AP_DOCS" ]; then
                mkdir -p "$AP_DOCS"
                cp -r "$INSTALLER_DIR/templates/agents/docs"/* "$AP_DOCS/" 2>/dev/null || true
                echo "✅ Copied documentation files to $AP_DOCS"
            else
                echo "⚠️  Skipping documentation copy - AP_DOCS path not set"
            fi
        fi
        
        # Copy index files
        if [ -f "$INSTALLER_DIR/templates/index.md" ]; then
            cp "$INSTALLER_DIR/templates/index.md" "$APM_ROOT/index.md"
            echo "✅ Copied templates index.md"
        fi
        if [ -f "$INSTALLER_DIR/templates/templates/index.md" ]; then
            mkdir -p "$APM_ROOT/.templates"
            cp "$INSTALLER_DIR/templates/templates/index.md" "$APM_ROOT/.templates/index.md"
            echo "✅ Copied templates/templates index.md"
        fi
    else
        echo "Error: templates/agents directory not found in installer"
        exit 1
    fi
else
    echo "Using existing agents directory in APM structure"
    if [ ! -d "$AP_ROOT" ]; then
        echo "Error: APM agents directory not found at $AP_ROOT"
        exit 1
    fi
fi

# Create additional files that Claude Code expects
echo "Creating additional required files..."
SESSION_NOTES_DIR="$APM_ROOT/session_notes"
ORCHESTRATOR_DIR="$AP_ROOT/orchestrator"

# Create session_notes.md file to prevent Claude Code errors
if [ ! -f "$SESSION_NOTES_DIR/session_notes.md" ]; then
    mkdir -p "$SESSION_NOTES_DIR"
    cat > "$SESSION_NOTES_DIR/session_notes.md" << 'EOF'
# Session Notes

This directory contains session notes for AP agent interactions.

## Usage

Session notes are automatically created with timestamps when AP agents are activated:
- Format: `YYYY-MM-DD-HH-mm-ss-Description.md`
- Location: This directory
- Archive: `archive/` subdirectory

## Current Sessions

For current session files, use the LS tool to list this directory and read individual session files as needed.

## Instructions for Claude

**IMPORTANT**: This file exists only to prevent Read errors. AP agents should:
1. Use LS tool to list the session_notes directory
2. Read individual timestamped session files as needed
3. Create new session files with proper timestamps
4. Archive completed sessions in the archive/ subdirectory
EOF
    echo "- Created session_notes/session_notes.md"
fi

# Create orchestrator/rules.md file to prevent Claude Code errors
if [ ! -f "$ORCHESTRATOR_DIR/rules.md" ]; then
    mkdir -p "$ORCHESTRATOR_DIR"
    cat > "$ORCHESTRATOR_DIR/rules.md" << 'EOF'
# Orchestrator Rules

This file contains behavioral rules for the AP Orchestrator agent.

## Core Rules

1. **Use LS tool** to list directories before attempting to read files
2. **Use voice scripts** for all major announcements and transitions
3. **Create session notes** with proper timestamps
4. **Follow communication standards** from loaded configuration

## File Structure

**IMPORTANT**: This file exists only to prevent Read errors. The actual rules are located in:
- Rules directory (use LS tool to explore)
- Communication standards: `personas/communication_standards.md`

## Instructions for Claude

When activating as AP Orchestrator:
1. List session notes directory using LS tool
2. List rules directory using LS tool
3. Create new session note with timestamp
4. Use voice script for greeting
5. Continue as the orchestrator persona

Refer to the actual persona files and communication standards for detailed behavioral rules.
EOF
    echo "- Created orchestrator/rules.md"
fi

# Replace voice scripts with TTS-manager versions
echo "Installing updated voice scripts..."
rm -rf "$AP_ROOT/voice"
mkdir -p "$AP_ROOT/voice"
cp "$INSTALLER_DIR/templates/voice"/*.sh "$AP_ROOT/voice/"
chmod +x "$AP_ROOT/voice"/*.sh

# Install ap-manager.sh
echo "Installing APM Framework Manager..."
if [ -f "$INSTALLER_DIR/templates/scripts/ap-manager.sh" ]; then
    cp "$INSTALLER_DIR/templates/scripts/ap-manager.sh" "$AP_ROOT/scripts/"
    chmod +x "$AP_ROOT/scripts/ap-manager.sh"
    echo "- Installed ap-manager.sh for updates and management"
else
    echo "- Warning: ap-manager.sh not found in installer"
fi

echo ""
echo "Step 2: Project Configuration"
echo "-----------------------------"

# Get project name
PROJECT_NAME=$(get_input "Enter project name" "$(basename "$PROJECT_ROOT")")

# Set up workspace structure with APM infrastructure hidden (variables already set)
CLAUDE_DIR="$PROJECT_ROOT/.claude"
CLAUDE_COMMANDS_DIR="$CLAUDE_DIR/commands"
PROJECT_DOCS="$PROJECT_ROOT/project_docs"
BACKLOG_PATH="project_docs"
SESSION_NOTES_PATH="$APM_ROOT/session_notes"
RULES_PATH="$APM_ROOT/rules"
ARCHIVE_PATH="$APM_ROOT/session_notes/archive"

echo ""
echo "Step 3: Session Notes Configuration"
echo "-----------------------------------"

# Always use markdown files (Obsidian integration removed)
NOTES_TYPE="markdown"
echo "Using: Markdown files"

# Markdown mode uses APM structure - session notes always in .apm/
SESSION_NOTES_PATH="$APM_ROOT/session_notes"
RULES_PATH="$APM_ROOT/rules"
ARCHIVE_PATH="$APM_ROOT/session_notes/archive"

# Create APM infrastructure directories
ensure_dir "$APM_ROOT"
ensure_dir "$SESSION_NOTES_PATH"
ensure_dir "$RULES_PATH"
ensure_dir "$ARCHIVE_PATH"

# Set voice script paths
SPEAK_ORCHESTRATOR="$AP_ROOT/voice/speakOrchestrator.sh"
SPEAK_DEVELOPER="$AP_ROOT/voice/speakDeveloper.sh"
SPEAK_ARCHITECT="$AP_ROOT/voice/speakArchitect.sh"
SPEAK_ANALYST="$AP_ROOT/voice/speakAnalyst.sh"
SPEAK_QA="$AP_ROOT/voice/speakQA.sh"
SPEAK_PM="$AP_ROOT/voice/speakPM.sh"
SPEAK_PO="$AP_ROOT/voice/speakPO.sh"
SPEAK_SM="$AP_ROOT/voice/speakSM.sh"
SPEAK_DESIGN_ARCHITECT="$AP_ROOT/voice/speakDesignArchitect.sh"

# AP Orchestrator IDE configuration paths
AP_CONFIG_FILE="$AP_ROOT/ide-ap-orchestrator.cfg.md"
AP_KB_FILE="$AP_ROOT/data/ap-kb.md"
AP_CHECKLISTS="$AP_ROOT/checklists"
AP_DATA="$AP_ROOT/data"
AP_PERSONAS="$AP_ROOT/personas"
AP_TASKS="$AP_ROOT/tasks"
AP_TEMPLATES="$AP_ROOT/templates"
AP_DOCS="$AP_ROOT/docs"
AP_VOICE="$AP_ROOT/voice"
AP_PYTHON="$AP_ROOT/python"
AP_MONITORING="$AP_ROOT/monitoring"
AP_SCRIPTS="$AP_ROOT/scripts"
AP_SUBTASKS="$AP_ROOT/tasks/subtasks"
SPEAK_AGENT="$AP_ROOT/voice/speakAgent.sh"

echo ""
echo "Step 4: Creating Project Structure"
echo "------------------------------------"

# Create project documentation structure
ensure_dir "$PROJECT_DOCS"
ensure_dir "$PROJECT_DOCS/requirements"
ensure_dir "$PROJECT_DOCS/architecture"
ensure_dir "$PROJECT_DOCS/specifications"
ensure_dir "$PROJECT_DOCS/artifacts"
ensure_dir "$PROJECT_DOCS/releases"
ensure_dir "$PROJECT_DOCS/reports"

# Create modern APM structure (v3.2.0)
ensure_dir "$PROJECT_DOCS/epics"
ensure_dir "$PROJECT_DOCS/stories"
ensure_dir "$PROJECT_DOCS/sprints"
ensure_dir "$PROJECT_DOCS/time-tracking"
ensure_dir "$PROJECT_DOCS/docs"
ensure_dir "$PROJECT_DOCS/qa"
ensure_dir "$PROJECT_DOCS/qa/test-plans"

# Copy project documentation README from template
replace_variables "$INSTALLER_DIR/templates/project_documentation/README.md.template" "$PROJECT_DOCS/README.md"

# Copy project_docs index.md if it exists
if [ -f "$PROJECT_ROOT/project_docs/index.md" ]; then
    echo "Project documentation index.md already exists"
elif [ -f "$INSTALLER_DIR/../project_docs/index.md" ]; then
    cp "$INSTALLER_DIR/../project_docs/index.md" "$PROJECT_DOCS/index.md"
    echo "✅ Copied project_docs/index.md"
fi

echo "Created project documentation structure at: $PROJECT_DOCS"

echo ""
echo "Step 5: Creating Claude Configuration"
echo "-------------------------------------"

# Create .claude/settings.json from template at project root
ensure_dir "$CLAUDE_DIR"
replace_variables "$INSTALLER_DIR/templates/claude/settings.json.template" "$CLAUDE_DIR/settings.json"
echo "Created Claude settings configuration: $CLAUDE_DIR/settings.json"

# Set SETTINGS_FILE for use in later steps
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

# Create .claude/hooks directory and copy hook scripts
ensure_dir "$CLAUDE_DIR/hooks"
if [ -d "$INSTALLER_DIR/templates/hooks" ]; then
    cp "$INSTALLER_DIR/templates/hooks"/*.py "$CLAUDE_DIR/hooks/" 2>/dev/null || true
    chmod +x "$CLAUDE_DIR/hooks"/*.py 2>/dev/null || true
    echo "Created Claude hooks: $CLAUDE_DIR/hooks/"
fi

echo ""
echo "Step 6: Creating .claude Commands"
echo "---------------------------------"

ensure_dir "$CLAUDE_COMMANDS_DIR"

echo "Installing APM commands (replacing APM commands, preserving user commands)..."

# Create ap_orchestrator.md command (primary)
replace_variables "$INSTALLER_DIR/templates/claude/commands/ap_orchestrator.md.template" "$CLAUDE_COMMANDS_DIR/ap_orchestrator.md"

# Create ap.md command (alias)
replace_variables "$INSTALLER_DIR/templates/claude/commands/ap.md.template" "$CLAUDE_COMMANDS_DIR/ap.md"

# Create handoff.md command
replace_variables "$INSTALLER_DIR/templates/claude/commands/handoff.md.template" "$CLAUDE_COMMANDS_DIR/handoff.md"

# Create wrap.md command (always use markdown template)
replace_variables "$INSTALLER_DIR/templates/claude/commands/wrap.md.markdown.template" "$CLAUDE_COMMANDS_DIR/wrap.md"

# Create session-note-setup.md command (always use markdown template)
replace_variables "$INSTALLER_DIR/templates/claude/commands/session-note-setup.md.markdown.template" "$CLAUDE_COMMANDS_DIR/session-note-setup.md"

# Create switch.md command
replace_variables "$INSTALLER_DIR/templates/claude/commands/switch.md.template" "$CLAUDE_COMMANDS_DIR/switch.md"

# Create direct persona activation commands
echo "Installing persona activation commands..."
replace_variables "$INSTALLER_DIR/templates/claude/commands/analyst.md.template" "$CLAUDE_COMMANDS_DIR/analyst.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/architect.md.template" "$CLAUDE_COMMANDS_DIR/architect.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/design-architect.md.template" "$CLAUDE_COMMANDS_DIR/design-architect.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/dev.md.template" "$CLAUDE_COMMANDS_DIR/dev.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/developer.md.template" "$CLAUDE_COMMANDS_DIR/developer.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/personas.md.template" "$CLAUDE_COMMANDS_DIR/personas.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/pm.md.template" "$CLAUDE_COMMANDS_DIR/pm.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/po.md.template" "$CLAUDE_COMMANDS_DIR/po.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/qa.md.template" "$CLAUDE_COMMANDS_DIR/qa.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/sm.md.template" "$CLAUDE_COMMANDS_DIR/sm.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/parallel-sprint.md.template" "$CLAUDE_COMMANDS_DIR/parallel-sprint.md"
replace_variables "$INSTALLER_DIR/templates/claude/commands/subtask.md.template" "$CLAUDE_COMMANDS_DIR/subtask.md"

# Install organize-docs command if template exists
if [ -f "$INSTALLER_DIR/templates/claude/commands/organize-docs.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/organize-docs.md.template" "$CLAUDE_COMMANDS_DIR/organize-docs.md"
    echo "✓ Installed organize-docs command"
fi

# Install git-commit-all command if template exists
if [ -f "$INSTALLER_DIR/templates/claude/commands/git-commit-all.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/git-commit-all.md.template" "$CLAUDE_COMMANDS_DIR/git-commit-all.md"
    echo "✓ Installed git-commit-all command"
fi

# Install QA framework commands if templates exist
echo "Installing QA Framework commands..."
if [ -f "$INSTALLER_DIR/templates/claude/commands/qa-framework.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/qa-framework.md.template" "$CLAUDE_COMMANDS_DIR/qa-framework.md"
    echo "✓ Installed qa-framework command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/qa-predict.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/qa-predict.md.template" "$CLAUDE_COMMANDS_DIR/qa-predict.md"
    echo "✓ Installed qa-predict command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/qa-optimize.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/qa-optimize.md.template" "$CLAUDE_COMMANDS_DIR/qa-optimize.md"
    echo "✓ Installed qa-optimize command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/qa-anomaly.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/qa-anomaly.md.template" "$CLAUDE_COMMANDS_DIR/qa-anomaly.md"
    echo "✓ Installed qa-anomaly command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/qa-insights.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/qa-insights.md.template" "$CLAUDE_COMMANDS_DIR/qa-insights.md"
    echo "✓ Installed qa-insights command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/parallel-qa-framework.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/parallel-qa-framework.md.template" "$CLAUDE_COMMANDS_DIR/parallel-qa-framework.md"
    echo "✓ Installed parallel-qa-framework command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/parallel-regression-suite.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/parallel-regression-suite.md.template" "$CLAUDE_COMMANDS_DIR/parallel-regression-suite.md"
    echo "✓ Installed parallel-regression-suite command"
fi

# Install test monitoring commands if templates exist
echo "Installing Test Monitoring commands..."
if [ -f "$INSTALLER_DIR/templates/claude/commands/monitor-tests.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/monitor-tests.md.template" "$CLAUDE_COMMANDS_DIR/monitor-tests.md"
    echo "✓ Installed monitor-tests command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/test-dashboard.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/test-dashboard.md.template" "$CLAUDE_COMMANDS_DIR/test-dashboard.md"
    echo "✓ Installed test-dashboard command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/test-metrics.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/test-metrics.md.template" "$CLAUDE_COMMANDS_DIR/test-metrics.md"
    echo "✓ Installed test-metrics command"
fi

if [ -f "$INSTALLER_DIR/templates/claude/commands/show-test-status.md.template" ]; then
    replace_variables "$INSTALLER_DIR/templates/claude/commands/show-test-status.md.template" "$CLAUDE_COMMANDS_DIR/show-test-status.md"
    echo "✓ Installed show-test-status command"
fi

echo "✓ APM commands installed/updated (including parallel-sprint, QA framework, and test monitoring)"

# Process persona templates
echo ""
echo "Processing persona templates..."
PERSONAS_DIR="$AP_ROOT/personas"
if [ -d "$INSTALLER_DIR/templates/personas" ]; then
    echo "Creating persona files from templates..."
    replace_variables "$INSTALLER_DIR/templates/personas/analyst.md.template" "$PERSONAS_DIR/analyst.md"
    replace_variables "$INSTALLER_DIR/templates/personas/architect.md.template" "$PERSONAS_DIR/architect.md"
    replace_variables "$INSTALLER_DIR/templates/personas/design-architect.md.template" "$PERSONAS_DIR/design-architect.md"
    replace_variables "$INSTALLER_DIR/templates/personas/dev.md.template" "$PERSONAS_DIR/dev.md"
    replace_variables "$INSTALLER_DIR/templates/personas/pm.md.template" "$PERSONAS_DIR/pm.md"
    replace_variables "$INSTALLER_DIR/templates/personas/po.md.template" "$PERSONAS_DIR/po.md"
    replace_variables "$INSTALLER_DIR/templates/personas/qa.md.template" "$PERSONAS_DIR/qa.md"
    replace_variables "$INSTALLER_DIR/templates/personas/sm.md.template" "$PERSONAS_DIR/sm.md"
    echo "✓ Persona files created with proper variable substitution"
else
    echo "Warning: Persona templates not found in installer"
fi

# Process AP Orchestrator IDE templates
echo ""
echo "Processing Claude Sub-Agent templates..."
if [ -d "$INSTALLER_DIR/templates/claude/agents" ]; then
    echo "Installing Claude Code sub-agent infrastructure..."
    
    # Create .claude/agents directory structure
    ensure_dir "$CLAUDE_DIR/agents"
    ensure_dir "$CLAUDE_DIR/agents/personas"
    ensure_dir "$CLAUDE_DIR/agents/config"
    ensure_dir "$CLAUDE_DIR/agents/migration"
    ensure_dir "$CLAUDE_DIR/agents/qa-framework"
    ensure_dir "$CLAUDE_DIR/agents/sprint-coordination"
    ensure_dir "$CLAUDE_DIR/agents/chaining"
    ensure_dir "$CLAUDE_DIR/agents/dual-mode"
    ensure_dir "$CLAUDE_DIR/agents/user-guide"
    ensure_dir "$CLAUDE_DIR/agents/documentation"
    ensure_dir "$CLAUDE_DIR/agents/voice"
    # Epic 17 Native Sub-Agents directories
    ensure_dir "$CLAUDE_DIR/agents/coordination"
    ensure_dir "$CLAUDE_DIR/agents/context"
    ensure_dir "$CLAUDE_DIR/agents/monitoring"
    ensure_dir "$CLAUDE_DIR/agents/compatibility"
    
    # Process all template files in claude/agents directory
    echo "Processing Claude sub-agent templates..."
    find "$INSTALLER_DIR/templates/claude/agents" -name "*.template" -type f | while read template_file; do
        # Calculate relative path from templates/claude/agents
        rel_path="${template_file#$INSTALLER_DIR/templates/claude/agents/}"
        
        # Remove .template extension
        output_path="${rel_path%.template}"
        
        # Create output file path
        output_file="$CLAUDE_DIR/agents/$output_path"
        
        # Ensure directory exists
        output_dir=$(dirname "$output_file")
        ensure_dir "$output_dir"
        
        # Process template
        replace_variables "$template_file" "$output_file"
        
        # Make executable if it's a shell script
        if [[ "$output_file" == *.sh ]]; then
            chmod +x "$output_file"
        fi
    done
    
    echo "✓ Claude sub-agent infrastructure installed (65+ templates processed)"
else
    echo "✓ Claude sub-agent templates not found - using standard APM installation"
fi

# Process Epic 17 deprecation framework
echo ""
echo "Processing Epic 17 Task-Based Deprecation Framework..."
if [ -d "$INSTALLER_DIR/templates/agents/deprecation" ]; then
    ensure_dir "$AP_ROOT/deprecation"
    find "$INSTALLER_DIR/templates/agents/deprecation" -name "*.template" -type f | while read template_file; do
        filename=$(basename "$template_file" .template)
        replace_variables "$template_file" "$AP_ROOT/deprecation/$filename"
    done
    echo "✓ Task-based deprecation framework installed"
else
    echo "✓ Deprecation templates not found - skipping"
fi

# Process test monitoring framework templates
echo ""
echo "Processing Test Monitoring Framework Templates..."
if [ -d "$INSTALLER_DIR/templates/scripts/test-monitoring" ]; then
    ensure_dir "$AP_ROOT/scripts/test-monitoring"
    find "$INSTALLER_DIR/templates/scripts/test-monitoring" -name "*.template" -type f | while read template_file; do
        filename=$(basename "$template_file" .template)
        replace_variables "$template_file" "$AP_ROOT/scripts/test-monitoring/$filename"
        chmod +x "$AP_ROOT/scripts/test-monitoring/$filename" 2>/dev/null || true
    done
    echo "✓ Test monitoring framework templates processed"
    
    # Create test monitoring configuration
    ensure_dir "$APM_ROOT/config"
    if [ ! -f "$APM_ROOT/config/test-monitoring.yaml" ]; then
        cat > "$APM_ROOT/config/test-monitoring.yaml" << 'EOF'
# APM Framework Test Monitoring Configuration
monitoring:
  refresh_interval: 5
  dashboard:
    default_port: 8080
    auto_refresh: true
  notifications:
    enabled: true
    tts_enabled: true
  features:
    process_monitoring: true
    file_watching: true
    coverage_tracking: true
    ai_ml_integration: true
EOF
        echo "✓ Test monitoring configuration created"
    fi
else
    echo "✓ Test monitoring templates not found - skipping"
fi

# Process Epic 17 documentation
echo ""
echo "Processing Epic 17 Native Sub-Agents Documentation..."
if [ -d "$PROJECT_DOCS/docs" ]; then
    echo "Epic 17 documentation already installed"
else
    echo "Installing Epic 17 documentation..."
    ensure_dir "$PROJECT_DOCS/docs"
    ensure_dir "$PROJECT_DOCS/docs/api"
    ensure_dir "$PROJECT_DOCS/docs/architecture"
    ensure_dir "$PROJECT_DOCS/docs/migration"
    ensure_dir "$PROJECT_DOCS/docs/releases"
    
    # Copy documentation files (these were created directly, not from templates)
    if [ -f "$PROJECT_DOCS/docs/api/parallel-commands.md" ]; then
        echo "✓ Epic 17 documentation already present"
    else
        echo "✓ Epic 17 documentation will be available after first run"
    fi
fi

echo ""
echo "Processing AP Orchestrator IDE templates..."
if [ -f "$INSTALLER_DIR/templates/ide-ap-orchestrator.md.template" ]; then
    echo "Creating AP Orchestrator IDE configuration from templates..."
    replace_variables "$INSTALLER_DIR/templates/ide-ap-orchestrator.md.template" "$AP_ROOT/ide-ap-orchestrator.md"
    replace_variables "$INSTALLER_DIR/templates/ide-ap-orchestrator.cfg.md.template" "$AP_ROOT/ide-ap-orchestrator.cfg.md"
    echo "✓ AP Orchestrator IDE files created with proper variable substitution"
else
    echo "Warning: AP Orchestrator IDE templates not found in installer"
fi

echo ""
echo "Step 7: Setting Up Python Hooks"
echo "-------------------------------"

# Python hooks are already copied and made executable in Step 5
echo "✓ Python hooks configured in $CLAUDE_DIR/hooks/"

echo ""
echo "Step 8: Configuring Text-to-Speech (TTS) System"
echo "-----------------------------------------------"

# Install TTS manager
echo "Installing TTS manager..."
cp "$INSTALLER_DIR/templates/scripts/tts-manager.sh" "$AP_ROOT/scripts/"
chmod +x "$AP_ROOT/scripts/tts-manager.sh"

# Install TTS configuration utility
cp "$INSTALLER_DIR/templates/scripts/configure-tts.sh" "$AP_ROOT/scripts/"
chmod +x "$AP_ROOT/scripts/configure-tts.sh"

# Create TTS providers directory
mkdir -p "$AP_ROOT/scripts/tts-providers"
cp "$INSTALLER_DIR/templates/scripts/tts-providers"/*.sh "$AP_ROOT/scripts/tts-providers/"
chmod +x "$AP_ROOT/scripts/tts-providers"/*.sh

# Create TTS setup directory
mkdir -p "$AP_ROOT/scripts/tts-setup"
cp "$INSTALLER_DIR/templates/scripts/tts-setup"/*.sh "$AP_ROOT/scripts/tts-setup/"
chmod +x "$AP_ROOT/scripts/tts-setup"/*.sh

# Configure TTS provider
if [ "$USE_DEFAULTS" = true ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Using default TTS configuration (System TTS - macOS)"
        TTS_PROVIDER="system"
    else
        echo "Using default TTS configuration (Piper - offline)"
        TTS_PROVIDER="piper"
    fi
else
    echo ""
    echo -e "${GREEN}Select a Text-to-Speech (TTS) provider:${NC}"
    echo -e "${BLUE}"
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "1) Piper (local, offline - Note: Requires building from source on macOS)"
        echo "2) ElevenLabs (cloud, high quality, requires API key)"
        echo "3) System TTS (Recommended for macOS - uses built-in 'say' command)"
        echo "4) Discord (send notifications to Discord channel)"
        echo "5) None (silent mode, no audio)"
        echo -e "${NC}"
        printf "${YELLOW}Select TTS provider (1-5) [3]: ${NC}"
    else
        echo "1) Piper (local, offline, ~100MB download)"
        echo "2) ElevenLabs (cloud, high quality, requires API key)"
        echo "3) System TTS (uses OS built-in TTS)"
        echo "4) Discord (send notifications to Discord channel)"
        echo "5) None (silent mode, no audio)"
        echo -e "${NC}"
        printf "${YELLOW}Select TTS provider (1-5) [1]: ${NC}"
    fi
    read tts_choice
    
    # Set appropriate default based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        tts_choice="${tts_choice:-3}"  # Default to System TTS on macOS
    else
        tts_choice="${tts_choice:-1}"  # Default to Piper on Linux
    fi
    
    case "$tts_choice" in
        1)
            TTS_PROVIDER="piper"
            ;;
        2)
            TTS_PROVIDER="elevenlabs"
            echo ""
            echo "Checking for MP3 audio player..."
            
            # Check for MP3-capable players
            if command -v mpg123 >/dev/null 2>&1; then
                echo "✓ Found mpg123"
            elif command -v ffplay >/dev/null 2>&1; then
                echo "✓ Found ffplay (ffmpeg)"
            elif command -v afplay >/dev/null 2>&1; then
                echo "✓ Found afplay (macOS)"
            else
                echo "No MP3-capable player found."
                echo ""
                
                # Check if we can install mpg123
                if command -v apt-get >/dev/null 2>&1; then
                    if [ "$USE_DEFAULTS" = true ]; then
                        INSTALL_MPG123="y"
                    else
                        printf "${YELLOW}Would you like to install mpg123 for audio playback? (Y/n): ${NC}"
                        read -n 1 -r
                        echo
                        INSTALL_MPG123="${REPLY:-y}"
                    fi
                    
                    if [[ $INSTALL_MPG123 =~ ^[Yy]$ ]]; then
                        echo "Installing mpg123..."
                        sudo apt-get update >/dev/null 2>&1
                        if sudo apt-get install -y mpg123; then
                            echo "✓ mpg123 installed successfully"
                        else
                            echo "⚠ Failed to install mpg123. Audio playback may not work correctly."
                            echo "  You can install it manually later with: sudo apt-get install mpg123"
                        fi
                    else
                        echo "⚠ Warning: Without an MP3 player, you may hear static instead of speech."
                        echo "  Install mpg123 later with: sudo apt-get install mpg123"
                    fi
                elif command -v brew >/dev/null 2>&1; then
                    # macOS with Homebrew
                    echo "To install mpg123 on macOS: brew install mpg123"
                else
                    echo "⚠ Please install mpg123 manually for audio playback"
                fi
            fi
            echo ""
            ;;
        3)
            TTS_PROVIDER="system"
            echo ""
            echo "System TTS uses your operating system's built-in text-to-speech."
            echo "Make sure you have TTS configured in your OS settings."
            ;;
        4)
            TTS_PROVIDER="discord"
            ;;
        5)
            TTS_PROVIDER="none"
            ;;
        *)
            echo "Invalid choice. Using Piper."
            TTS_PROVIDER="piper"
            ;;
    esac
fi

echo ""
echo "Selected TTS provider: $TTS_PROVIDER"

# If TTS is enabled, detect audio players early
if [ "$TTS_PROVIDER" != "none" ]; then
    echo ""
    echo "Detecting audio players for TTS..."
    detect_audio_player
    
    # Save audio player configuration immediately
    if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
        tmp_file=$(mktemp)
        jq ".env.AUDIO_PLAYER = \"$AUDIO_PLAYER\" |
            .env.AUDIO_PLAYER_ARGS = \"$AUDIO_PLAYER_ARGS\" |
            .env.WAV_PLAYER = \"$WAV_PLAYER\" |
            .env.WAV_PLAYER_ARGS = \"$WAV_PLAYER_ARGS\" |
            .env.FFMPEG_AVAILABLE = \"$FFMPEG_AVAILABLE\"" "$SETTINGS_FILE" > "$tmp_file" && mv "$tmp_file" "$SETTINGS_FILE"
    fi
fi

# Configure the selected provider
case "$TTS_PROVIDER" in
    piper)
        echo ""
        echo "Checking for audio player..."
        
        # Detect WSL2
        IS_WSL2=false
        if grep -qi microsoft /proc/version 2>/dev/null; then
            IS_WSL2=true
        fi
        
        # Check for audio players that can handle WAV files
        FOUND_PLAYER=false
        if [ "$IS_WSL2" = true ]; then
            # WSL2: Check paplay first
            if command -v paplay >/dev/null 2>&1; then
                echo "✓ Found paplay (PulseAudio) - recommended for WSL2"
                FOUND_PLAYER=true
            elif command -v aplay >/dev/null 2>&1; then
                echo "✓ Found aplay (ALSA)"
                FOUND_PLAYER=true
            fi
        else
            # Non-WSL2: Check aplay first
            if command -v aplay >/dev/null 2>&1; then
                echo "✓ Found aplay (ALSA)"
                FOUND_PLAYER=true
            elif command -v paplay >/dev/null 2>&1; then
                echo "✓ Found paplay (PulseAudio)"
                FOUND_PLAYER=true
            fi
        fi
        
        # Check other players
        if [ "$FOUND_PLAYER" = false ]; then
            if command -v play >/dev/null 2>&1; then
                echo "✓ Found play (SoX)"
                FOUND_PLAYER=true
            elif command -v afplay >/dev/null 2>&1; then
                echo "✓ Found afplay (macOS)"
                FOUND_PLAYER=true
            elif command -v mpg123 >/dev/null 2>&1; then
                echo "✓ Found mpg123"
                FOUND_PLAYER=true
            elif command -v ffplay >/dev/null 2>&1; then
                echo "✓ Found ffplay (ffmpeg)"
                FOUND_PLAYER=true
            fi
        fi
        
        if [ "$FOUND_PLAYER" = false ]; then
            echo "No audio player found."
            echo ""
            
            # Try to install audio player
            if command -v apt-get >/dev/null 2>&1; then
                if [ "$IS_WSL2" = true ]; then
                    echo "Installing PulseAudio utilities (recommended for WSL2)..."
                    sudo apt-get update >/dev/null 2>&1
                    if sudo apt-get install -y pulseaudio-utils; then
                        echo "✓ PulseAudio utilities installed successfully"
                    else
                        echo "Trying ALSA utilities as fallback..."
                        if sudo apt-get install -y alsa-utils; then
                            echo "✓ ALSA utilities installed successfully"
                        else
                            echo "⚠ Failed to install audio player. Audio playback may not work."
                        fi
                    fi
                else
                    echo "Installing ALSA audio utilities..."
                    sudo apt-get update >/dev/null 2>&1
                    if sudo apt-get install -y alsa-utils; then
                        echo "✓ ALSA utilities installed successfully"
                    else
                        echo "⚠ Failed to install audio player. Audio playback may not work."
                    fi
                fi
            else
                echo "⚠ Please install an audio player manually"
                if [ "$IS_WSL2" = true ]; then
                    echo "  For WSL2: sudo apt-get install pulseaudio-utils"
                fi
            fi
            
            # Re-detect audio players after installation attempt
            echo ""
            echo "Re-detecting audio players..."
            detect_audio_player
            
            # Update settings with newly detected audio players
            if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
                tmp_file=$(mktemp)
                jq ".env.AUDIO_PLAYER = \"$AUDIO_PLAYER\" |
                    .env.AUDIO_PLAYER_ARGS = \"$AUDIO_PLAYER_ARGS\" |
                    .env.WAV_PLAYER = \"$WAV_PLAYER\" |
                    .env.WAV_PLAYER_ARGS = \"$WAV_PLAYER_ARGS\" |
                    .env.FFMPEG_AVAILABLE = \"$FFMPEG_AVAILABLE\"" "$SETTINGS_FILE" > "$tmp_file" && mv "$tmp_file" "$SETTINGS_FILE"
            fi
        fi
        
        echo ""
        echo "Installing Piper TTS system..."
        
        # Check if setup script exists
        PIPER_SETUP_SCRIPT="$INSTALLER_DIR/templates/scripts/tts-setup/setup-piper-chat.sh"
        if [ -f "$PIPER_SETUP_SCRIPT" ]; then
            # Run the piper setup script
            if [ "$USE_DEFAULTS" = true ]; then
                USE_DEFAULTS=true bash "$PIPER_SETUP_SCRIPT" "$PROJECT_ROOT/.piper"
            else
                bash "$PIPER_SETUP_SCRIPT" "$PROJECT_ROOT/.piper"
            fi
            
            if [ $? -eq 0 ]; then
                echo "✓ Piper installation completed successfully!"
                
                # Ensure TTS_PROVIDER is set to piper in settings
                if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
                    tmp_file=$(mktemp)
                    jq '.env.TTS_PROVIDER = "piper" | .env.TTS_ENABLED = "true"' "$SETTINGS_FILE" > "$tmp_file" && mv "$tmp_file" "$SETTINGS_FILE"
                    echo "✓ TTS provider set to Piper"
                fi
                
                # Skip audio test - removed per configuration
                        echo "Playing test message..."
                        # Different players need different parameters for raw audio
                        case "$WAV_PLAYER" in
                            paplay)
                                echo "" | \
                                    "$PROJECT_ROOT/.piper/piper" \
                                    --model "$PROJECT_ROOT/.piper/models/en_US-ryan-medium.onnx" \
                                    --output-raw 2>/dev/null | \
                                    paplay --raw --rate=22050 --format=s16le --channels=1
                                ;;
                            aplay)
                                echo "" | \
                                    "$PROJECT_ROOT/.piper/piper" \
                                    --model "$PROJECT_ROOT/.piper/models/en_US-ryan-medium.onnx" \
                                    --output-raw 2>/dev/null | \
                                    aplay -q -r 22050 -f S16_LE -t raw -c 1 -
                                ;;
                            play)
                                echo "" | \
                                    "$PROJECT_ROOT/.piper/piper" \
                                    --model "$PROJECT_ROOT/.piper/models/en_US-ryan-medium.onnx" \
                                    --output-raw 2>/dev/null | \
                                    play -q -t raw -r 22050 -e signed -b 16 -c 1 -
                                ;;
                            *)
                                echo "" | \
                                    "$PROJECT_ROOT/.piper/piper" \
                                    --model "$PROJECT_ROOT/.piper/models/en_US-ryan-medium.onnx" \
                                    --output-raw 2>/dev/null | \
                                    $WAV_PLAYER $WAV_PLAYER_ARGS
                                ;;
                        esac
                        
            else
                echo "⚠ Piper installation encountered issues."
                echo "You can manually install it later."
                
                # Set TTS provider to none if installation failed
                if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
                    tmp_file=$(mktemp)
                    jq '.env.TTS_PROVIDER = "none" | .env.TTS_ENABLED = "false"' "$SETTINGS_FILE" > "$tmp_file" && mv "$tmp_file" "$SETTINGS_FILE"
                fi
            fi
        fi
        ;;
        
    elevenlabs)
        echo ""
        # Run ElevenLabs configuration
        "$AP_ROOT/scripts/tts-providers/elevenlabs.sh" configure
        ;;
        
    system)
        echo ""
        # Check system TTS availability
        "$AP_ROOT/scripts/tts-providers/system.sh" configure
        ;;
        
    discord)
        echo ""
        # Configure Discord webhook
        "$AP_ROOT/scripts/tts-providers/discord.sh" configure
        ;;
        
    none)
        echo "Silent mode selected. No audio output will be produced."
        ;;
esac

# Update settings with TTS provider - but only for non-piper providers
# (Piper updates its own setting after successful installation)
if [ "$TTS_PROVIDER" != "piper" ] && [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
    tmp_file=$(mktemp)
    TTS_ENABLED_VAL=$([[ "$TTS_PROVIDER" != "none" ]] && echo "true" || echo "false")
    jq ".env.TTS_PROVIDER = \"$TTS_PROVIDER\" | .env.TTS_ENABLED = \"$TTS_ENABLED_VAL\"" "$SETTINGS_FILE" > "$tmp_file" && mv "$tmp_file" "$SETTINGS_FILE"
    echo "✓ TTS provider set to $TTS_PROVIDER"
fi

echo ""
echo "Step 8a: Configuring Notification System"
echo "----------------------------------------"

# Function to configure individual hook
configure_hook() {
    local hook_name="$1"
    local hook_display="$2"
    local hook_var_prefix="$3"
    
    echo ""
    echo -e "${GREEN}Configuring $hook_display hook:${NC}"
    echo -e "${BLUE}"
    echo "1) No notification"
    echo "2) Audible notification sound"
    echo -e "${NC}"
    if [ "$USE_DEFAULTS" = true ]; then
        # Set default values based on hook type
        case "$hook_name" in
            "stop"|"subagent_stop"|"user_prompt_submit"|"pre_compact")
                hook_option="2"  # Default to audible notification
                echo "Using default: 2 (Audible notification sound)"
                ;;
            *)
                hook_option="1"  # Default to no notification for others
                echo "Using default: 1 (No notification)"
                ;;
        esac
    else
        # Set default display and value based on hook type
        case "$hook_name" in
            "stop"|"subagent_stop"|"user_prompt_submit"|"pre_compact")
                printf "${YELLOW}Select option (1-2) [2]: ${NC}"
                read hook_option
                hook_option="${hook_option:-2}"
                ;;
            *)
                printf "${YELLOW}Select option (1-2) [1]: ${NC}"
                read hook_option
                hook_option="${hook_option:-1}"
                ;;
        esac
    fi
    
    # Set variables based on selection
    eval "${hook_var_prefix}_ENABLED=false"
    
    case "$hook_option" in
        2)
            eval "${hook_var_prefix}_ENABLED=true"
            ;;
    esac
}

# Check if user wants to configure notifications
if [ "$USE_DEFAULTS" = true ]; then
    SETUP_NOTIFICATIONS=true
    echo "Using default notification configuration (stop, subagent_stop, user_prompt_submit, and pre_compact hooks enabled)"
else
    printf "${YELLOW}Would you like to setup audible notifications? (Y/n): ${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        SETUP_NOTIFICATIONS=false
    else
        SETUP_NOTIFICATIONS=true
    fi
fi

if [ "$SETUP_NOTIFICATIONS" = true ]; then
    # Detect audio players first
    echo ""
    detect_audio_player
    
    # Warn if no audio player available
    if [ "$AUDIO_PLAYER" = "none" ] && [ "$WAV_PLAYER" = "none" ]; then
        echo ""
        echo -e "${YELLOW}WARNING: No audio player detected!${NC}"
        echo "Audio notifications will not work without an audio player."
        echo ""
        echo -e "${GREEN}Would you like to:${NC}"
        echo -e "${BLUE}"
        echo "1) Install mpg123 now (recommended)"
        echo "2) Continue without audio support"
        echo "3) Cancel notification setup"
        echo -e "${NC}"
        printf "${YELLOW}Select option (1-3) [2]: ${NC}"
        read install_choice
        install_choice="${install_choice:-2}"
        
        case "$install_choice" in
            1)
                echo ""
                echo "Installing mpg123..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    if command -v apt-get >/dev/null 2>&1; then
                        sudo apt-get update && sudo apt-get install -y mpg123
                    elif command -v yum >/dev/null 2>&1; then
                        sudo yum install -y mpg123
                    elif command -v pacman >/dev/null 2>&1; then
                        sudo pacman -S mpg123
                    else
                        echo -e "${RED}Unable to install mpg123 automatically${NC}"
                        echo "Please install manually: sudo apt-get install mpg123"
                    fi
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    if command -v brew >/dev/null 2>&1; then
                        brew install mpg123
                    else
                        echo -e "${RED}Unable to install mpg123 automatically${NC}"
                        echo "Please install Homebrew first: https://brew.sh"
                    fi
                fi
                # Re-detect after installation
                detect_audio_player
                ;;
            3)
                SETUP_NOTIFICATIONS=false
                ;;
        esac
    fi
fi

if [ "$SETUP_NOTIFICATIONS" = true ]; then
    # If using defaults, set the default hook values before configuration
    if [ "$USE_DEFAULTS" = true ]; then
        # Set default enabled hooks
        HOOK_NOTIFICATION_ENABLED=false
        HOOK_PRE_TOOL_ENABLED=false
        HOOK_POST_TOOL_ENABLED=false
        HOOK_STOP_ENABLED=true
        HOOK_SUBAGENT_STOP_ENABLED=true
        HOOK_USER_PROMPT_SUBMIT_ENABLED=true
        HOOK_PRE_COMPACT_ENABLED=true
    fi
    
    # Copy notification sounds
    echo ""
    echo "Installing notification sounds..."
    mkdir -p "$AP_ROOT/sounds"
    if [ -d "$INSTALLER_DIR/templates/sounds" ]; then
        cp "$INSTALLER_DIR/templates/sounds"/*.mp3 "$AP_ROOT/sounds/" 2>/dev/null || true
        chmod 644 "$AP_ROOT/sounds"/*.mp3 2>/dev/null || true
    fi
    
    # Copy notification manager
    if [ -f "$INSTALLER_DIR/templates/scripts/notification-manager.sh" ]; then
        cp "$INSTALLER_DIR/templates/scripts/notification-manager.sh" "$AP_ROOT/scripts/"
        chmod +x "$AP_ROOT/scripts/notification-manager.sh"
    fi
    
    # Explain hooks
    echo ""
    echo "Audible notifications are available on 7 hooks:"
    echo "- Notification: General notifications and alerts"
    echo "- Pre-tool: Before Claude uses a tool"
    echo "- Post-tool: After Claude completes a tool"
    echo "- Stop: When Claude stops/exits"
    echo "- Subagent Stop: When a subagent completes"
    echo "- User Prompt Submit: When user submits a prompt"
    echo "- Pre-Compact: Before context compaction"
    echo ""
    echo "Each hook can be configured independently."
    
    # Configure each hook - skip if using defaults
    if [ "$USE_DEFAULTS" != true ]; then
        configure_hook "notification" "Notification" "HOOK_NOTIFICATION"
        configure_hook "pre_tool" "Pre-tool" "HOOK_PRE_TOOL"
        configure_hook "post_tool" "Post-tool" "HOOK_POST_TOOL"
        configure_hook "stop" "Stop" "HOOK_STOP"
        configure_hook "subagent_stop" "Subagent Stop" "HOOK_SUBAGENT_STOP"
        configure_hook "user_prompt_submit" "User Prompt Submit" "HOOK_USER_PROMPT_SUBMIT"
        configure_hook "pre_compact" "Pre-Compact" "HOOK_PRE_COMPACT"
    else
        echo ""
        echo "Applied default notification settings:"
        echo "- Stop: Enabled"
        echo "- Subagent Stop: Enabled"
        echo "- User Prompt Submit: Enabled"
        echo "- Pre-Compact: Enabled"
    fi
    
    # Save notification configuration to settings
    echo ""
    echo "Saving notification configuration..."
    
    # Update settings.json with notification config
    if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
        tmp_file=$(mktemp)
        jq ".env.AUDIO_PLAYER = \"$AUDIO_PLAYER\" |
            .env.AUDIO_PLAYER_ARGS = \"$AUDIO_PLAYER_ARGS\" |
            .env.WAV_PLAYER = \"$WAV_PLAYER\" |
            .env.WAV_PLAYER_ARGS = \"$WAV_PLAYER_ARGS\" |
            .env.FFMPEG_AVAILABLE = \"$FFMPEG_AVAILABLE\" |
            .env.HOOK_NOTIFICATION_ENABLED = \"$HOOK_NOTIFICATION_ENABLED\" |
            .env.HOOK_PRE_TOOL_ENABLED = \"$HOOK_PRE_TOOL_ENABLED\" |
            .env.HOOK_POST_TOOL_ENABLED = \"$HOOK_POST_TOOL_ENABLED\" |
            .env.HOOK_STOP_ENABLED = \"$HOOK_STOP_ENABLED\" |
            .env.HOOK_SUBAGENT_STOP_ENABLED = \"$HOOK_SUBAGENT_STOP_ENABLED\" |
            .env.HOOK_USER_PROMPT_SUBMIT_ENABLED = \"$HOOK_USER_PROMPT_SUBMIT_ENABLED\" |
            .env.HOOK_PRE_COMPACT_ENABLED = \"$HOOK_PRE_COMPACT_ENABLED\"" "$SETTINGS_FILE" > "$tmp_file" && mv "$tmp_file" "$SETTINGS_FILE"
    fi
    
    echo "✓ Notification system configured"
    echo ""
    echo "📁 Hook logs will be written to: .claude/hooks/logs/ in your project directory"
else
    # Even if notifications are disabled, set all hooks to false
    HOOK_NOTIFICATION_ENABLED=false
    HOOK_PRE_TOOL_ENABLED=false
    HOOK_POST_TOOL_ENABLED=false
    HOOK_STOP_ENABLED=false
    HOOK_SUBAGENT_STOP_ENABLED=false
    HOOK_USER_PROMPT_SUBMIT_ENABLED=false
    HOOK_PRE_COMPACT_ENABLED=false
    
    # Even if notifications are disabled, detect and save audio player info
    echo ""
    echo "Detecting audio players for TTS support..."
    detect_audio_player
    
    # Save audio player configuration for future use
    if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
        tmp_file=$(mktemp)
        jq ".env.AUDIO_PLAYER = \"$AUDIO_PLAYER\" |
            .env.AUDIO_PLAYER_ARGS = \"$AUDIO_PLAYER_ARGS\" |
            .env.WAV_PLAYER = \"$WAV_PLAYER\" |
            .env.WAV_PLAYER_ARGS = \"$WAV_PLAYER_ARGS\" |
            .env.FFMPEG_AVAILABLE = \"$FFMPEG_AVAILABLE\" |
            .env.HOOK_NOTIFICATION_ENABLED = \"$HOOK_NOTIFICATION_ENABLED\" |
            .env.HOOK_PRE_TOOL_ENABLED = \"$HOOK_PRE_TOOL_ENABLED\" |
            .env.HOOK_POST_TOOL_ENABLED = \"$HOOK_POST_TOOL_ENABLED\" |
            .env.HOOK_STOP_ENABLED = \"$HOOK_STOP_ENABLED\" |
            .env.HOOK_SUBAGENT_STOP_ENABLED = \"$HOOK_SUBAGENT_STOP_ENABLED\" |
            .env.HOOK_USER_PROMPT_SUBMIT_ENABLED = \"$HOOK_USER_PROMPT_SUBMIT_ENABLED\" |
            .env.HOOK_PRE_COMPACT_ENABLED = \"$HOOK_PRE_COMPACT_ENABLED\"" "$SETTINGS_FILE" > "$tmp_file" && mv "$tmp_file" "$SETTINGS_FILE"
    fi
fi

echo ""
echo "Step 9: Setting Up Python Support (Optional)"
echo "-------------------------------------------"

# Ask if user wants to set up Python support
if [ "$USE_DEFAULTS" = true ]; then
    echo "Skipping Python support setup (use --python to include)"
    SETUP_PYTHON=false
else
    echo "Python support includes:"
    echo "  - Virtual environment management"
    echo "  - Python wrapper scripts"
    echo "  - Requirements management"
    echo ""
    printf "${YELLOW}Would you like to set up Python support for hooks and scripts? (Y/n): ${NC}"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        SETUP_PYTHON=false
    else
        SETUP_PYTHON=true
    fi
fi

if [ "$SETUP_PYTHON" = true ]; then
    echo "Installing Python support..."
    if [ -f "$INSTALLER_DIR/templates/python-support/install-python-support.sh" ]; then
        bash "$INSTALLER_DIR/templates/python-support/install-python-support.sh" "$PROJECT_ROOT"
        echo "✓ Python support installed"
    else
        echo "⚠ Python support files not found in installer"
    fi
else
    echo "Skipping Python support setup."
    echo "Hooks will use system Python if available."
fi

echo ""
echo "Step 10: Creating and Merging CLAUDE.md Files"
echo "---------------------------------------------"

# Always create/replace the .apm/CLAUDE.md file
APM_CLAUDE_MD="$AP_ROOT/CLAUDE.md"
echo "Creating .apm/CLAUDE.md from template..."
replace_variables "$INSTALLER_DIR/templates/CLAUDE.md.markdown.template" "$APM_CLAUDE_MD"
echo "✓ Created: $APM_CLAUDE_MD"

# Handle the root project CLAUDE.md file with intelligent merge
ROOT_CLAUDE_MD="$PROJECT_ROOT/CLAUDE.md"
echo ""
echo "Handling root project CLAUDE.md file..."

# Set up merge system paths
MERGE_SYSTEM="${APM_ROOT}/.installer/claude-merge-system"
MERGE_ORCHESTRATOR="${MERGE_SYSTEM}/merge-orchestrator.sh"
TEMPLATE_FILE="${INSTALLER_DIR}/template.claude.md"

# Determine merge approach based on availability and user preference
USE_INTELLIGENT_MERGE=false
if [[ -f "$MERGE_ORCHESTRATOR" ]] && [[ -x "$MERGE_ORCHESTRATOR" ]]; then
    USE_INTELLIGENT_MERGE=true
fi

if [[ -f "$ROOT_CLAUDE_MD" ]]; then
    echo "Existing CLAUDE.md found."
    
    # Offer user choice if intelligent merge is available
    if [[ "$USE_INTELLIGENT_MERGE" = true ]] && [[ "$USE_DEFAULTS" != true ]]; then
        printf "${YELLOW}Use intelligent merge to preserve your customizations? (Y/n): ${NC}"
        read MERGE_CHOICE
        MERGE_CHOICE="${MERGE_CHOICE:-Y}"
        
        if [[ ! "$MERGE_CHOICE" =~ ^[Yy]$ ]]; then
            USE_INTELLIGENT_MERGE=false
            echo "Using standard APM section merge instead."
        fi
    fi
    
    if [[ "$USE_INTELLIGENT_MERGE" = true ]]; then
        echo "Performing intelligent merge to preserve customizations..."
        
        # Create backup directory with timestamp
        BACKUP_DIR="${APM_ROOT}/backups/claude-md"
        BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        mkdir -p "$BACKUP_DIR"
        
        # Create manual backup first
        cp "$ROOT_CLAUDE_MD" "${BACKUP_DIR}/CLAUDE.md.backup.${BACKUP_TIMESTAMP}"
        echo "  Created backup: ${BACKUP_DIR}/CLAUDE.md.backup.${BACKUP_TIMESTAMP}"
        
        # Run merge orchestrator with proper error handling
        MERGE_OUTPUT="${ROOT_CLAUDE_MD}.merged"
        MERGE_LOG="${BACKUP_DIR}/merge-${BACKUP_TIMESTAMP}.log"
        
        if "${MERGE_ORCHESTRATOR}" \
            --template "$TEMPLATE_FILE" \
            --user "$ROOT_CLAUDE_MD" \
            --output "$MERGE_OUTPUT" \
            --backup-dir "$BACKUP_DIR" \
            --strategy auto \
            --quiet 2>"$MERGE_LOG"; then
            
            # Success - verify output exists and has content
            if [[ -f "$MERGE_OUTPUT" ]] && [[ -s "$MERGE_OUTPUT" ]]; then
                # Check if custom sections were preserved
                CUSTOM_PRESERVED=true
                if [[ -f "$ROOT_CLAUDE_MD" ]]; then
                    # Simple check: see if file size increased (indicating merge worked)
                    ORIG_SIZE=$(stat -c%s "$ROOT_CLAUDE_MD" 2>/dev/null || stat -f%z "$ROOT_CLAUDE_MD" 2>/dev/null || echo 0)
                    NEW_SIZE=$(stat -c%s "$MERGE_OUTPUT" 2>/dev/null || stat -f%z "$MERGE_OUTPUT" 2>/dev/null || echo 0)
                    
                    if [[ $NEW_SIZE -lt $((ORIG_SIZE / 2)) ]]; then
                        CUSTOM_PRESERVED=false
                    fi
                fi
                
                if [[ "$CUSTOM_PRESERVED" = true ]]; then
                    mv "$MERGE_OUTPUT" "$ROOT_CLAUDE_MD"
                    echo "✓ CLAUDE.md successfully merged"
                    echo "  - Your customizations have been preserved"
                    echo "  - APM commands have been updated to latest version"
                    echo "  - Backup saved to: ${BACKUP_DIR}/"
                else
                    echo "⚠ Merge completed but may have lost content. Using legacy method..."
                    rm -f "$MERGE_OUTPUT"
                    merge_apm_section "$ROOT_CLAUDE_MD"
                fi
            else
                # Output file missing or empty
                echo "⚠ Merge produced no output. Using legacy APM section merge..."
                rm -f "$MERGE_OUTPUT"
                merge_apm_section "$ROOT_CLAUDE_MD"
            fi
        else
            # Merge command failed
            MERGE_EXIT_CODE=$?
            echo "⚠ Intelligent merge encountered an issue (code: $MERGE_EXIT_CODE)."
            echo "  Using legacy APM section merge to ensure compatibility..."
            
            # Clean up failed merge output
            rm -f "$MERGE_OUTPUT"
            
            # Log details for debugging if needed
            if [[ -f "$MERGE_LOG" ]] && [[ -s "$MERGE_LOG" ]]; then
                echo "  (Details saved to: $MERGE_LOG)"
            fi
            
            # Use legacy method
            merge_apm_section "$ROOT_CLAUDE_MD"
        fi
    else
        # Use legacy merge method
        echo "Using standard APM section merge..."
        merge_apm_section "$ROOT_CLAUDE_MD"
    fi
else
    # No existing file - create from template
    echo "Creating new CLAUDE.md from template..."
    cp "$TEMPLATE_FILE" "$ROOT_CLAUDE_MD"
    echo "✓ Created new CLAUDE.md"
    echo "  - Contains APM commands and project instructions"
    echo "  - You can customize this file with your own sections"
fi

echo ""
echo "Step 11: Configuring .gitignore"
echo "-------------------------------"

# Configure .gitignore
GITIGNORE_FILE="$PROJECT_ROOT/.gitignore"
if [ -f "$GITIGNORE_FILE" ]; then
    echo "Updating existing .gitignore file..."
    
    # Check if session notes entries already exist
    if ! grep -q "# Session notes" "$GITIGNORE_FILE"; then
        echo "" >> "$GITIGNORE_FILE"
        echo "# Session notes (APM infrastructure)" >> "$GITIGNORE_FILE"
        echo ".apm/session_notes/" >> "$GITIGNORE_FILE"
        echo ".apm/rules/" >> "$GITIGNORE_FILE"
        echo "" >> "$GITIGNORE_FILE"
        echo "# AP Mapping generated files" >> "$GITIGNORE_FILE"
        echo ".apm/CLAUDE.md" >> "$GITIGNORE_FILE"
        echo "harmonization.log" >> "$GITIGNORE_FILE"
        echo "" >> "$GITIGNORE_FILE"
        echo "# Piper TTS installation (project-local)" >> "$GITIGNORE_FILE"
        echo ".piper/" >> "$GITIGNORE_FILE"
        
        echo "Added AP method entries to .gitignore"
    else
        echo ".gitignore already contains session notes entries"
    fi
else
    echo "Creating new .gitignore file..."
    cp "$INSTALLER_DIR/templates/gitignore.template" "$GITIGNORE_FILE"
    echo "Created .gitignore with AP method entries"
fi

# Read VERSION file
VERSION=$(cat "$DIST_DIR/VERSION" 2>/dev/null || echo "unknown")

# Copy LICENSE and VERSION to .apm folder
if [ -f "$DIST_DIR/LICENSE" ]; then
    cp "$DIST_DIR/LICENSE" "$APM_ROOT/LICENSE"
    echo "Copied LICENSE to .apm folder"
fi

if [ -f "$DIST_DIR/VERSION" ]; then
    cp "$DIST_DIR/VERSION" "$APM_ROOT/VERSION"
    echo "Copied VERSION to .apm folder"
fi

echo ""
echo "Step 12: Validating Installation"
echo "--------------------------------"

# Obsidian integration removed - no additional configuration needed

# Test TTS if Piper was installed
if [ "$TTS_PROVIDER" = "piper" ] && [ -f "$PROJECT_ROOT/.piper/piper" ]; then
    echo ""
    echo "Testing Piper TTS audio..."
    
    # Test audio playback
    if [ "$WAV_PLAYER" != "none" ]; then
        # Use proper parameters for each audio player
        case "$WAV_PLAYER" in
            paplay)
                echo "" | "$PROJECT_ROOT/.piper/piper" \
                    --model "$PROJECT_ROOT/.piper/models/en_US-ryan-medium.onnx" \
                    --output-raw 2>/dev/null | \
                    paplay --raw --rate=22050 --format=s16le --channels=1 2>/dev/null
                ;;
            aplay)
                echo "" | "$PROJECT_ROOT/.piper/piper" \
                    --model "$PROJECT_ROOT/.piper/models/en_US-ryan-medium.onnx" \
                    --output-raw 2>/dev/null | \
                    aplay -q -r 22050 -f S16_LE -t raw -c 1 - 2>/dev/null
                ;;
            play)
                echo "" | "$PROJECT_ROOT/.piper/piper" \
                    --model "$PROJECT_ROOT/.piper/models/en_US-ryan-medium.onnx" \
                    --output-raw 2>/dev/null | \
                    play -q -t raw -r 22050 -e signed -b 16 -c 1 - 2>/dev/null
                ;;
            *)
                echo "" | "$PROJECT_ROOT/.piper/piper" \
                    --model "$PROJECT_ROOT/.piper/models/en_US-ryan-medium.onnx" \
                    --output-raw 2>/dev/null | \
                    $WAV_PLAYER $WAV_PLAYER_ARGS 2>/dev/null
                ;;
        esac
        
        if [ $? -eq 0 ]; then
            echo "✓ Audio test successful!"
        else
            echo -e "${YELLOW}⚠ Audio test failed. Please check:${NC}"
            echo "  - WSL2: Is PulseAudio running? (pulseaudio --start)"
            echo "  - Are audio devices configured correctly?"
            echo "  - Try: pactl info"
        fi
    else
        echo -e "${YELLOW}⚠ No audio player found for testing${NC}"
    fi
fi

# Verify settings
echo ""
echo "Verifying configuration..."
if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
    TTS_CHECK=$(jq -r '.env.TTS_PROVIDER // "none"' "$SETTINGS_FILE")
    AUDIO_CHECK=$(jq -r '.env.AUDIO_PLAYER // "none"' "$SETTINGS_FILE")
    WAV_CHECK=$(jq -r '.env.WAV_PLAYER // "none"' "$SETTINGS_FILE")
    NOTES_CHECK=$(jq -r '.env.NOTES_TYPE // "unknown"' "$SETTINGS_FILE")
    
    echo "- Session notes: $NOTES_CHECK"
    echo "- TTS provider: $TTS_CHECK"
    echo "- Audio player: $AUDIO_CHECK"
    echo "- WAV player: $WAV_CHECK"
    
    # Check for configuration mismatches
    NEEDS_FIX=false
    
    if [ "$TTS_PROVIDER" = "piper" ] && [ "$TTS_CHECK" != "piper" ]; then
        echo -e "${RED}⚠ WARNING: TTS provider mismatch! Expected 'piper', found '$TTS_CHECK'${NC}"
        NEEDS_FIX=true
    fi
    
    if [ "$AUDIO_PLAYER" != "none" ] && [ "$AUDIO_CHECK" = "none" ]; then
        echo -e "${RED}⚠ WARNING: Audio player not saved! Expected '$AUDIO_PLAYER', found 'none'${NC}"
        NEEDS_FIX=true
    fi
    
    if [ "$WAV_PLAYER" != "none" ] && [ "$WAV_CHECK" = "none" ]; then
        echo -e "${RED}⚠ WARNING: WAV player not saved! Expected '$WAV_PLAYER', found 'none'${NC}"
        NEEDS_FIX=true
    fi
    
    # Fix all issues if needed
    if [ "$NEEDS_FIX" = true ]; then
        echo "Fixing configuration..."
        tmp_file=$(mktemp)
        jq ".env.TTS_PROVIDER = \"$TTS_PROVIDER\" |
            .env.TTS_ENABLED = \"$([[ "$TTS_PROVIDER" != "none" ]] && echo "true" || echo "false")\" |
            .env.AUDIO_PLAYER = \"$AUDIO_PLAYER\" |
            .env.AUDIO_PLAYER_ARGS = \"$AUDIO_PLAYER_ARGS\" |
            .env.WAV_PLAYER = \"$WAV_PLAYER\" |
            .env.WAV_PLAYER_ARGS = \"$WAV_PLAYER_ARGS\"" "$SETTINGS_FILE" > "$tmp_file" && mv "$tmp_file" "$SETTINGS_FILE"
        echo "✓ Configuration fixed"
    fi
fi

echo ""
echo "Step 13: Setting Up QA Framework Integration"
echo "--------------------------------------------"

# QA Framework commands are now installed via templates above
echo "✓ QA Framework commands installed via templates"
echo ""
echo "Available QA Framework Commands:"
echo "- /qa-framework - Comprehensive QA Framework access"
echo "- /qa-predict - ML-powered test failure prediction"
echo "- /qa-optimize - Test execution optimization"
echo "- /qa-anomaly - Quality anomaly detection"
echo "- /qa-insights - AI-powered quality insights"
echo "- /parallel-qa-framework - 4x faster parallel execution"
echo "- /parallel-regression-suite - Parallel regression testing"

echo ""
echo "Step 14: Setting Up Test Monitoring Framework"
echo "----------------------------------------------"

# Create test monitoring infrastructure
echo "Installing test monitoring capabilities..."

# Create test monitoring directories
ensure_dir "$APM_ROOT/scripts/test-monitoring"
ensure_dir "$PROJECT_DOCS/qa/metrics"
ensure_dir "$PROJECT_DOCS/qa/reports"
ensure_dir "$PROJECT_DOCS/qa/test-results"
ensure_dir "$PROJECT_DOCS/qa/dashboards"

# Test monitoring scripts are installed via templates above
echo "✓ Test monitoring scripts installed via templates"
echo ""
echo "Available Test Monitoring Commands:"
echo "- monitor tests - Real-time CLI test monitoring"
echo "- test dashboard - Web-based monitoring dashboard"
echo "- test metrics - Comprehensive metrics collection"
echo "- show test status - Quick test status overview"
echo ""
echo "Test Monitoring Features:"
echo "- Real-time process monitoring"
echo "- Web dashboard with auto-refresh"
echo "- Metrics collection and export (CSV, JSON, YAML)"
echo "- Integration with QA agent personas"
echo "- AI/ML analytics integration"
echo "- Notification system (TTS and webhooks)"

echo ""
echo "=========================================="
echo "APM Framework installation completed!"
echo "=========================================="
echo ""
echo "Installation Summary:"
echo "- Version: $VERSION (Native Sub-Agent Architecture)"
echo "- Performance: 4-8x faster parallel execution"
echo "- Location: $PROJECT_ROOT"
echo "- Project: $PROJECT_NAME"
echo ""

# Version file is already in place from earlier copy
# Just verify it exists
if [ -f "$APM_ROOT/VERSION" ]; then
    echo "Version file verified: $APM_ROOT/VERSION"
else
    # Fallback: Create version file if it wasn't copied
    echo "$VERSION" > "$APM_ROOT/VERSION"
    echo "Created version file: $APM_ROOT/VERSION"
fi

# Preserve installer for future management
echo "Preserving installer for updates and management..."

# Move installer to hidden directory in APM_ROOT
INSTALLER_PRESERVE_DIR="$APM_ROOT/.installer"
if [ ! -d "$INSTALLER_PRESERVE_DIR" ]; then
    mkdir -p "$INSTALLER_PRESERVE_DIR"
    # Copy from the actual installer directory
    if [ -d "$INSTALLER_DIR" ]; then
        cp -r "$INSTALLER_DIR"/* "$INSTALLER_PRESERVE_DIR/"
        echo "- Installer preserved at: $INSTALLER_PRESERVE_DIR"
    else
        echo "- Warning: Could not preserve installer - source directory not found"
    fi
else
    echo "- Installer already preserved at: $INSTALLER_PRESERVE_DIR"
fi

# Change to project root before cleaning up
cd "$PROJECT_ROOT" 2>/dev/null || true

# Remove the tar.gz file if it exists in the project root
if [ -f "$PROJECT_ROOT/apm-v$VERSION.tar.gz" ]; then
    rm -f "$PROJECT_ROOT/apm-v$VERSION.tar.gz"
    echo "- Removed distribution archive"
fi

# Remove distribution files from project root (they're now in .apm folder)
if [ -f "$PROJECT_ROOT/LICENSE" ] && [ "$SKIP_COPY" != "true" ]; then
    rm -f "$PROJECT_ROOT/LICENSE"
    echo "- Removed LICENSE file from root (now in .apm folder)"
fi

if [ -f "$PROJECT_ROOT/VERSION" ]; then
    rm -f "$PROJECT_ROOT/VERSION"
    echo "- Removed VERSION file from root (now in .apm folder)"
fi

# Note: Distribution README is now placed in .apm directory to avoid overwriting user README
# Legacy cleanup for old installations that placed README in root
if [ -f "$PROJECT_ROOT/README.md" ] && grep -q "AP Mapping - Agentic Persona Mapping Framework" "$PROJECT_ROOT/README.md" 2>/dev/null; then
    rm -f "$PROJECT_ROOT/README.md"
    echo "- Removed legacy distribution README from root"
fi

# Clean up installer files from project root (simplified)
echo ""
echo "Cleaning up installer files..."

# Remove installer directory if it exists and we've preserved it
if [ -d "$INSTALLER_PRESERVE_DIR" ] && [ "$SKIP_COPY" != "true" ]; then
    if [ -d "$PROJECT_ROOT/installer" ]; then
        rm -rf "$PROJECT_ROOT/installer"
        echo "- Removed installer directory from project root (preserved in .apm/.installer)"
    fi
    # Also remove from distribution directory if different from project root
    if [ -d "$DIST_DIR/installer" ] && [ "$DIST_DIR" != "$PROJECT_ROOT" ]; then
        rm -rf "$DIST_DIR/installer"
        echo "- Removed installer directory from distribution (preserved in .apm/.installer)"
    fi
fi

# Remove installer script from project root (but not if we're running from it)
installer_script="$PROJECT_ROOT/install.sh"
current_script="$(readlink -f "$0" 2>/dev/null || echo "$0")"
target_script="$(readlink -f "$installer_script" 2>/dev/null || echo "$installer_script")"

if [ -f "$installer_script" ] && [ "$current_script" != "$target_script" ]; then
    # Safe to remove directly - verify it's our installer
    if grep -q "AP Mapping Installation Script" "$installer_script" 2>/dev/null; then
        rm -f "$installer_script"
        echo "- Removed installer script from project root"
    fi
elif [ -f "$installer_script" ] && [ "$current_script" = "$target_script" ]; then
    echo "- Installer script will remain (currently executing from this location)"
    echo "  You can manually remove it after installation: rm install.sh"
fi

echo ""
echo "Next steps:"
echo ""
echo "1. Open the project in Claude Code"
echo "2. Try running: /ap"
echo "3. Test QA Framework: /qa-framework"
echo "4. Explore AI/ML commands: /qa-predict, /qa-optimize, /qa-anomaly, /qa-insights"
echo "5. Try parallel testing: /parallel-qa-framework, /parallel-regression-suite"
echo "6. Check out the documentation at: $PROJECT_DOCS"
echo ""
echo "Management commands:"
echo "- Check for updates: $AP_ROOT/scripts/ap-manager.sh update"
echo "- Verify installation: $AP_ROOT/scripts/ap-manager.sh verify"
echo "- Show version: $AP_ROOT/scripts/ap-manager.sh version"
echo ""
echo "For more information, see:"
echo "- Main instructions: $CLAUDE_MD"
echo "- Agents directory: $AP_ROOT"
echo ""
echo "Enjoy using the APM Framework v3.2.0 with 4-8x performance!"