#!/bin/bash
# Voice Persona Scripts Generation Template
# This script generates all persona-specific voice scripts from the main template
# Generated from voice-persona-scripts-template.sh.template

# =============================================================================
# CONFIGURATION
# =============================================================================

# Script directory and paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VOICE_TEMPLATE_DIR="$SCRIPT_DIR"
TARGET_VOICE_DIR="{{VOICE_SCRIPT_PATH}}"

# Template information
TEMPLATE_VERSION="{{TEMPLATE_VERSION}}"
GENERATION_TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# Persona definitions with detailed characteristics
declare -A PERSONAS=(
    ["orchestrator"]="AP Orchestrator|Central coordination and delegation persona|authoritative|measured|professional"
    ["developer"]="Developer Agent|Implementation and coding persona|focused|steady|technical"
    ["architect"]="System Architect|Design and architecture persona|thoughtful|deliberate|strategic"
    ["analyst"]="System Analyst|Analysis and research persona|analytical|methodical|detailed"
    ["qa"]="QA Agent|Quality assurance and testing persona|meticulous|thorough|quality-focused"
    ["pm"]="Project Manager|Project coordination persona|organized|efficient|coordinating"
    ["po"]="Product Owner|Product strategy persona|visionary|purposeful|business-focused"
    ["sm"]="Scrum Master|Agile process persona|facilitating|energetic|team-focused"
    ["design_architect"]="Design Architect|UI/UX design persona|creative|inspired|user-focused"
)

# Voice provider settings per persona
declare -A PIPER_VOICES=(
    ["orchestrator"]="ryan"
    ["developer"]="joe"
    ["architect"]="ryan"
    ["analyst"]="amy"
    ["qa"]="hfc_female"
    ["pm"]="joe"
    ["po"]="ryan"
    ["sm"]="joe"
    ["design_architect"]="kusal"
)

declare -A ELEVENLABS_VOICES=(
    ["orchestrator"]="{{TTS_VOICE_ORCHESTRATOR_ELEVENLABS}}"
    ["developer"]="{{TTS_VOICE_DEVELOPER_ELEVENLABS}}"
    ["architect"]="{{TTS_VOICE_ARCHITECT_ELEVENLABS}}"
    ["analyst"]="{{TTS_VOICE_ANALYST_ELEVENLABS}}"
    ["qa"]="{{TTS_VOICE_QA_ELEVENLABS}}"
    ["pm"]="{{TTS_VOICE_PM_ELEVENLABS}}"
    ["po"]="{{TTS_VOICE_PO_ELEVENLABS}}"
    ["sm"]="{{TTS_VOICE_SM_ELEVENLABS}}"
    ["design_architect"]="{{TTS_VOICE_DESIGNARCHITECT_ELEVENLABS}}"
)

declare -A SYSTEM_VOICES=(
    ["orchestrator"]="{{TTS_VOICE_ORCHESTRATOR_SYSTEM}}"
    ["developer"]="{{TTS_VOICE_DEVELOPER_SYSTEM}}"
    ["architect"]="{{TTS_VOICE_ARCHITECT_SYSTEM}}"
    ["analyst"]="{{TTS_VOICE_ANALYST_SYSTEM}}"
    ["qa"]="{{TTS_VOICE_QA_SYSTEM}}"
    ["pm"]="{{TTS_VOICE_PM_SYSTEM}}"
    ["po"]="{{TTS_VOICE_PO_SYSTEM}}"
    ["sm"]="{{TTS_VOICE_SM_SYSTEM}}"
    ["design_architect"]="{{TTS_VOICE_DESIGNARCHITECT_SYSTEM}}"
)

# TTS Provider-specific settings per persona
declare -A ELEVENLABS_STABILITY=(
    ["orchestrator"]="0.75"
    ["developer"]="0.80"
    ["architect"]="0.70"
    ["analyst"]="0.85"
    ["qa"]="0.90"
    ["pm"]="0.75"
    ["po"]="0.70"
    ["sm"]="0.65"
    ["design_architect"]="0.60"
)

declare -A ELEVENLABS_SIMILARITY=(
    ["orchestrator"]="0.75"
    ["developer"]="0.80"
    ["architect"]="0.75"
    ["analyst"]="0.85"
    ["qa"]="0.90"
    ["pm"]="0.75"
    ["po"]="0.70"
    ["sm"]="0.65"
    ["design_architect"]="0.70"
)

declare -A PIPER_SPEED=(
    ["orchestrator"]="1.0"
    ["developer"]="1.1"
    ["architect"]="0.9"
    ["analyst"]="1.0"
    ["qa"]="1.0"
    ["pm"]="1.1"
    ["po"]="1.0"
    ["sm"]="1.2"
    ["design_architect"]="1.0"
)

declare -A SYSTEM_RATE=(
    ["orchestrator"]="175"
    ["developer"]="180"
    ["architect"]="160"
    ["analyst"]="170"
    ["qa"]="175"
    ["pm"]="180"
    ["po"]="175"
    ["sm"]="190"
    ["design_architect"]="175"
)

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Logging function
log_generation() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message"
    
    # Also log to file if directory exists
    if [ -d "/mnt/c/Code/agentic-persona-mapping/.cache/tts" ]; then
        echo "[$timestamp] [$level] [Voice-Generation] $message" >> "/mnt/c/Code/agentic-persona-mapping/.cache/tts/voice-generation.log"
    fi
}

# Parse persona information
parse_persona_info() {
    local persona="$1"
    local info="${PERSONAS[$persona]}"
    
    if [ -z "$info" ]; then
        echo "Error: Unknown persona '$persona'"
        return 1
    fi
    
    # Split the pipe-separated values
    IFS='|' read -r display_name description tone pace style <<< "$info"
    
    echo "$display_name|$description|$tone|$pace|$style"
}

# Capitalize first letter of each word
capitalize_words() {
    echo "$1" | sed 's/\b\w/\U&/g'
}

# Convert to uppercase with underscores
to_upper_underscore() {
    echo "$1" | tr '[:lower:]' '[:upper:]' | tr '-' '_'
}

# =============================================================================
# SCRIPT GENERATION FUNCTIONS
# =============================================================================

# Generate voice script for a specific persona
generate_persona_script() {
    local persona="$1"
    local output_file="$2"
    
    log_generation "INFO" "Generating voice script for persona: $persona"
    
    # Parse persona information
    local persona_info=$(parse_persona_info "$persona")
    if [ $? -ne 0 ]; then
        log_generation "ERROR" "$persona_info"
        return 1
    fi
    
    IFS='|' read -r display_name description tone pace style <<< "$persona_info"
    
    # Prepare template variables
    local persona_name="$persona"
    local persona_name_capitalized=$(capitalize_words "${persona//_/ }")
    local persona_name_upper=$(to_upper_underscore "$persona")
    local persona_display_name="$display_name"
    local persona_description="$description"
    local voice_tone="$tone"
    local voice_pace="$pace"
    local voice_style="$style"
    
    # Voice provider settings
    local piper_voice="${PIPER_VOICES[$persona]:-ryan}"
    local elevenlabs_voice="${ELEVENLABS_VOICES[$persona]:-default}"
    local system_voice="${SYSTEM_VOICES[$persona]:-default}"
    
    local elevenlabs_stability="${ELEVENLABS_STABILITY[$persona]:-0.75}"
    local elevenlabs_similarity="${ELEVENLABS_SIMILARITY[$persona]:-0.75}"
    local piper_speed="${PIPER_SPEED[$persona]:-1.0}"
    local piper_pitch="1.0"
    local system_rate="${SYSTEM_RATE[$persona]:-175}"
    local system_pitch="50"
    
    # Read the voice script template
    local template_file="$VOICE_TEMPLATE_DIR/voice-script-template.sh.template"
    if [ ! -f "$template_file" ]; then
        log_generation "ERROR" "Template file not found: $template_file"
        return 1
    fi
    
    log_generation "DEBUG" "Reading template: $template_file"
    local template_content=$(cat "$template_file")
    
    # Replace template variables
    local script_content="$template_content"
    
    # Basic persona information
    script_content="${script_content//\{\{PERSONA_NAME\}\}/$persona_name}"
    script_content="${script_content//\{\{PERSONA_NAME_CAPITALIZED\}\}/$persona_name_capitalized}"
    script_content="${script_content//\{\{PERSONA_NAME_UPPER\}\}/$persona_name_upper}"
    script_content="${script_content//\{\{PERSONA_DISPLAY_NAME\}\}/$persona_display_name}"
    script_content="${script_content//\{\{PERSONA_DESCRIPTION\}\}/$persona_description}"
    
    # Voice characteristics
    script_content="${script_content//\{\{VOICE_TONE\}\}/$voice_tone}"
    script_content="${script_content//\{\{VOICE_PACE\}\}/$voice_pace}"
    script_content="${script_content//\{\{VOICE_STYLE\}\}/$voice_style}"
    
    # TTS provider settings
    script_content="${script_content//\{\{ELEVENLABS_STABILITY\}\}/$elevenlabs_stability}"
    script_content="${script_content//\{\{ELEVENLABS_SIMILARITY\}\}/$elevenlabs_similarity}"
    script_content="${script_content//\{\{PIPER_SPEED\}\}/$piper_speed}"
    script_content="${script_content//\{\{PIPER_PITCH\}\}/$piper_pitch}"
    script_content="${script_content//\{\{SYSTEM_RATE\}\}/$system_rate}"
    script_content="${script_content//\{\{SYSTEM_PITCH\}\}/$system_pitch}"
    
    # Paths and configuration
    script_content="${script_content//\{\{VOICE_SCRIPT_PATH\}\}/{{VOICE_SCRIPT_PATH}}}"
    script_content="${script_content//\{\{PROJECT_ROOT\}\}//mnt/c/Code/agentic-persona-mapping}"
    script_content="${script_content//\{\{SETTINGS_FILE\}\}/{{SETTINGS_FILE}}}"
    
    # Template metadata
    script_content="${script_content//\{\{TEMPLATE_VERSION\}\}/$TEMPLATE_VERSION}"
    script_content="${script_content//\{\{GENERATION_TIMESTAMP\}\}/$GENERATION_TIMESTAMP}"
    script_content="${script_content//\{\{VERSION\}\}/{{VERSION}}}"
    
    # Write the generated script
    if echo "$script_content" > "$output_file"; then
        chmod +x "$output_file"
        log_generation "INFO" "Generated voice script: $output_file"
        return 0
    else
        log_generation "ERROR" "Failed to write voice script: $output_file"
        return 1
    fi
}

# Generate the base voice script (speakBase.sh)
generate_base_script() {
    local output_file="$TARGET_VOICE_DIR/speakBase.sh"
    
    log_generation "INFO" "Generating base voice script: $output_file"
    
    cat > "$output_file" << 'EOF'
#!/bin/bash
# Base script for voice synthesis using TTS manager
# This script provides common functionality for all voice scripts
# Generated by voice-persona-scripts-template.sh.template

# Get the script directory
VOICE_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AP_ROOT="$(dirname "$VOICE_SCRIPT_DIR")"
APM_ROOT="$(dirname "$AP_ROOT")"
PROJECT_ROOT="$(dirname "$APM_ROOT")"

# TTS Manager location
TTS_MANAGER="$AP_ROOT/scripts/tts-manager.sh"

# Function to check if TTS manager is available
check_tts_manager() {
    if [ ! -f "$TTS_MANAGER" ] || [ ! -x "$TTS_MANAGER" ]; then
        # Silent fail - no audio but don't break execution
        return 1
    fi
    return 0
}

# Function to synthesize speech using TTS manager
synthesize_speech() {
    local persona="$1"
    local text="$2"
    
    # Check TTS manager availability
    if ! check_tts_manager; then
        # Silent fail
        return 0
    fi
    
    # Use TTS manager to speak
    "$TTS_MANAGER" speak "$persona" "$text" 2>/dev/null || true
}

# Function to handle input (from arguments or stdin)
handle_input() {
    local persona="$1"
    local text=""
    
    # Check if text is provided as arguments
    if [ $# -gt 1 ]; then
        # Shift to remove persona from arguments
        shift
        text="$*"
    else
        # Read from stdin
        if [ -t 0 ]; then
            # No stdin and no arguments - just exit silently
            exit 0
        fi
        text=$(cat)
    fi
    
    # Check if we have text
    if [ -z "$text" ]; then
        # No text - exit silently
        exit 0
    fi
    
    # Synthesize and play speech
    synthesize_speech "$persona" "$text"
}

# Export functions for use in other scripts
export -f check_tts_manager
export -f synthesize_speech
EOF
    
    chmod +x "$output_file"
    log_generation "INFO" "Generated base script: $output_file"
}

# Generate all persona voice scripts
generate_all_scripts() {
    log_generation "INFO" "Starting voice script generation for all personas"
    
    # Create target directory if it doesn't exist
    if [ ! -d "$TARGET_VOICE_DIR" ]; then
        mkdir -p "$TARGET_VOICE_DIR"
        log_generation "INFO" "Created target directory: $TARGET_VOICE_DIR"
    fi
    
    # Generate base script first
    generate_base_script
    
    # Generate scripts for each persona
    local success_count=0
    local total_count=0
    
    for persona in "${!PERSONAS[@]}"; do
        ((total_count++))
        
        # Determine output filename
        local capitalized_persona=$(capitalize_words "${persona//_/ }" | tr -d ' ')
        local output_file="$TARGET_VOICE_DIR/speak${capitalized_persona}.sh"
        
        if generate_persona_script "$persona" "$output_file"; then
            ((success_count++))
        fi
    done
    
    log_generation "INFO" "Voice script generation completed: $success_count/$total_count successful"
    
    if [ $success_count -eq $total_count ]; then
        return 0
    else
        return 1
    fi
}

# Validate generated scripts
validate_generated_scripts() {
    log_generation "INFO" "Validating generated voice scripts"
    
    local validation_errors=0
    
    # Check base script
    local base_script="$TARGET_VOICE_DIR/speakBase.sh"
    if [ ! -f "$base_script" ]; then
        log_generation "ERROR" "Base script not found: $base_script"
        ((validation_errors++))
    elif [ ! -x "$base_script" ]; then
        log_generation "ERROR" "Base script not executable: $base_script"
        ((validation_errors++))
    fi
    
    # Check each persona script
    for persona in "${!PERSONAS[@]}"; do
        local capitalized_persona=$(capitalize_words "${persona//_/ }" | tr -d ' ')
        local script_file="$TARGET_VOICE_DIR/speak${capitalized_persona}.sh"
        
        if [ ! -f "$script_file" ]; then
            log_generation "ERROR" "Persona script not found: $script_file"
            ((validation_errors++))
        elif [ ! -x "$script_file" ]; then
            log_generation "ERROR" "Persona script not executable: $script_file"
            ((validation_errors++))
        else
            # Test script syntax
            if ! bash -n "$script_file" 2>/dev/null; then
                log_generation "ERROR" "Syntax error in script: $script_file"
                ((validation_errors++))
            fi
        fi
    done
    
    if [ $validation_errors -eq 0 ]; then
        log_generation "INFO" "All voice scripts validated successfully"
        return 0
    else
        log_generation "ERROR" "Validation failed with $validation_errors errors"
        return 1
    fi
}

# =============================================================================
# TESTING FUNCTIONS
# =============================================================================

# Test generated voice scripts
test_voice_scripts() {
    log_generation "INFO" "Testing generated voice scripts"
    
    local test_errors=0
    
    for persona in "${!PERSONAS[@]}"; do
        local capitalized_persona=$(capitalize_words "${persona//_/ }" | tr -d ' ')
        local script_file="$TARGET_VOICE_DIR/speak${capitalized_persona}.sh"
        
        if [ -f "$script_file" ] && [ -x "$script_file" ]; then
            log_generation "DEBUG" "Testing script: $script_file"
            
            # Test help function
            if ! "$script_file" --help >/dev/null 2>&1; then
                log_generation "WARN" "Help function test failed for: $script_file"
                ((test_errors++))
            fi
            
            # Test version function
            if ! "$script_file" --version >/dev/null 2>&1; then
                log_generation "WARN" "Version function test failed for: $script_file"
                ((test_errors++))
            fi
            
            # Test with empty input (should exit gracefully)
            if ! echo "" | "$script_file" >/dev/null 2>&1; then
                log_generation "WARN" "Empty input test failed for: $script_file"
                ((test_errors++))
            fi
            
        else
            log_generation "ERROR" "Script not found or not executable: $script_file"
            ((test_errors++))
        fi
    done
    
    if [ $test_errors -eq 0 ]; then
        log_generation "INFO" "All voice script tests passed"
        return 0
    else
        log_generation "WARN" "Voice script testing completed with $test_errors warnings/errors"
        return 1
    fi
}

# =============================================================================
# MAIN FUNCTIONS
# =============================================================================

# Show generation summary
show_summary() {
    echo ""
    echo "=== Voice Script Generation Summary ==="
    echo "Template Version: $TEMPLATE_VERSION"
    echo "Generation Time: $GENERATION_TIMESTAMP"
    echo "Target Directory: $TARGET_VOICE_DIR"
    echo ""
    
    echo "Generated Scripts:"
    echo "- speakBase.sh (base functionality)"
    
    for persona in "${!PERSONAS[@]}"; do
        local capitalized_persona=$(capitalize_words "${persona//_/ }" | tr -d ' ')
        local script_file="speak${capitalized_persona}.sh"
        local info="${PERSONAS[$persona]}"
        local display_name=$(echo "$info" | cut -d'|' -f1)
        
        if [ -f "$TARGET_VOICE_DIR/$script_file" ]; then
            echo "- $script_file ($display_name) ✓"
        else
            echo "- $script_file ($display_name) ✗"
        fi
    done
    
    echo ""
    echo "Voice Mappings:"
    for persona in "${!PERSONAS[@]}"; do
        local piper_voice="${PIPER_VOICES[$persona]}"
        echo "- $persona: piper=$piper_voice"
    done
}

# Show help information
show_help() {
    cat << EOF
Voice Persona Scripts Generator

This script generates individual voice scripts for all APM agent personas
from the voice script template.

Usage: $0 [command]

Commands:
    generate    Generate all voice scripts (default)
    validate    Validate generated scripts
    test        Test generated scripts
    clean       Clean generated scripts
    summary     Show generation summary
    help        Show this help

Examples:
    $0                    # Generate all scripts
    $0 generate          # Generate all scripts
    $0 validate          # Validate existing scripts
    $0 test             # Test existing scripts
    $0 clean            # Remove generated scripts

Configuration:
    Template Directory: $VOICE_TEMPLATE_DIR
    Target Directory: $TARGET_VOICE_DIR
    Template Version: $TEMPLATE_VERSION

Personas:
EOF

    for persona in "${!PERSONAS[@]}"; do
        local info="${PERSONAS[$persona]}"
        local display_name=$(echo "$info" | cut -d'|' -f1)
        local description=$(echo "$info" | cut -d'|' -f2)
        echo "    $persona - $display_name ($description)"
    done
}

# Clean generated scripts
clean_scripts() {
    log_generation "INFO" "Cleaning generated voice scripts"
    
    if [ ! -d "$TARGET_VOICE_DIR" ]; then
        log_generation "INFO" "Target directory does not exist: $TARGET_VOICE_DIR"
        return 0
    fi
    
    local removed_count=0
    
    # Remove base script
    if [ -f "$TARGET_VOICE_DIR/speakBase.sh" ]; then
        rm -f "$TARGET_VOICE_DIR/speakBase.sh"
        ((removed_count++))
        log_generation "INFO" "Removed: speakBase.sh"
    fi
    
    # Remove persona scripts
    for persona in "${!PERSONAS[@]}"; do
        local capitalized_persona=$(capitalize_words "${persona//_/ }" | tr -d ' ')
        local script_file="$TARGET_VOICE_DIR/speak${capitalized_persona}.sh"
        
        if [ -f "$script_file" ]; then
            rm -f "$script_file"
            ((removed_count++))
            log_generation "INFO" "Removed: speak${capitalized_persona}.sh"
        fi
    done
    
    log_generation "INFO" "Cleaning completed: $removed_count files removed"
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

# Main execution logic
main() {
    local command="${1:-generate}"
    
    case "$command" in
        generate)
            log_generation "INFO" "Starting voice script generation"
            if generate_all_scripts; then
                log_generation "INFO" "Generation completed successfully"
                show_summary
                return 0
            else
                log_generation "ERROR" "Generation failed"
                return 1
            fi
            ;;
        validate)
            validate_generated_scripts
            ;;
        test)
            test_voice_scripts
            ;;
        clean)
            clean_scripts
            ;;
        summary)
            show_summary
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            echo "Unknown command: $command"
            echo "Use '$0 help' for usage information"
            return 1
            ;;
    esac
}

# Execute main function with all arguments
main "$@"