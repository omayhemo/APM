#!/bin/bash
# {{PROVIDER_NAME}} TTS Provider Template
# {{PROVIDER_DESCRIPTION}}
# Generated from tts-provider-template.sh.template

# =============================================================================
# PROVIDER CONFIGURATION
# =============================================================================

# Don't use set -e as audio players often return non-zero even when working
# This allows us to try multiple fallback options

# Get script directory and establish paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TTS_MANAGER_DIR="$(dirname "$SCRIPT_DIR")"
AP_ROOT="$(dirname "$TTS_MANAGER_DIR")"
APM_ROOT="$(dirname "$AP_ROOT")"
PROJECT_ROOT="$(dirname "$APM_ROOT")"

# Load settings
SETTINGS_FILE="{{SETTINGS_FILE}}"

# Provider metadata
PROVIDER_NAME="{{PROVIDER_NAME}}"
PROVIDER_VERSION="{{PROVIDER_VERSION}}"
PROVIDER_DESCRIPTION="{{PROVIDER_DESCRIPTION}}"

# =============================================================================
# PROVIDER-SPECIFIC CONFIGURATION
# =============================================================================

# {{PROVIDER_NAME}} specific settings
{{PROVIDER_CONFIG_SECTION}}

# Voice mappings for this provider
declare -A VOICE_MAP=(
{{VOICE_MAPPINGS}}
)

# Provider-specific environment variables
{{PROVIDER_ENV_VARS}}

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Get provider-specific setting from configuration
get_provider_setting() {
    local key="$1"
    local default="$2"
    
    # Convert to environment variable format
    local env_key="TTS_$(echo "$PROVIDER_NAME" | tr '[:lower:]' '[:upper:]')_$(echo "$key" | tr '[:lower:]' '[:upper:]')"
    
    # First check environment variable directly
    if [ -n "${!env_key:-}" ]; then
        echo "${!env_key}"
        return
    fi
    
    # Then check settings file if available
    if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
        local value=$(jq -r ".env.$env_key // \"$default\"" "$SETTINGS_FILE" 2>/dev/null)
        if [ "$value" != "null" ] && [ -n "$value" ]; then
            echo "$value"
        else
            echo "$default"
        fi
    else
        echo "$default"
    fi
}

# Get voice mapping for persona
get_voice_for_persona() {
    local persona="$1"
    local default_voice="{{DEFAULT_VOICE}}"
    
    # First check for custom voice mapping in settings
    if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
        local persona_upper=$(echo "$persona" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
        local provider_upper=$(echo "$PROVIDER_NAME" | tr '[:lower:]' '[:upper:]')
        local env_key="TTS_VOICE_${persona_upper}_${provider_upper}"
        
        local custom_voice=$(jq -r ".env.$env_key // \"\"" "$SETTINGS_FILE" 2>/dev/null)
        if [ -n "$custom_voice" ] && [ "$custom_voice" != "null" ]; then
            echo "$custom_voice"
            return
        fi
    fi
    
    # Use default mapping from VOICE_MAP
    local mapped_voice="${VOICE_MAP[$persona]:-$default_voice}"
    echo "$mapped_voice"
}

# Log provider activity (if debugging enabled)
log_provider_activity() {
    local level="$1"
    local message="$2"
    
    if [ "${TTS_DEBUG:-false}" = "true" ]; then
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        local log_file="$PROJECT_ROOT/.cache/tts/{{PROVIDER_NAME}}.log"
        
        # Create log directory if needed
        mkdir -p "$(dirname "$log_file")" 2>/dev/null || true
        
        # Write log entry
        echo "[$timestamp] [$level] [{{PROVIDER_NAME}}] $message" >> "$log_file" 2>/dev/null || true
    fi
}

# =============================================================================
# CORE PROVIDER FUNCTIONS
# =============================================================================

# Provider information
info() {
    echo "$PROVIDER_DESCRIPTION"
}

# Check if provider is available and properly configured
check() {
    log_provider_activity "DEBUG" "Checking provider availability"
    
    {{PROVIDER_CHECK_LOGIC}}
    
    return $?
}

# Configure the provider (interactive setup)
configure() {
    echo "=== Configure {{PROVIDER_NAME}} TTS Provider ==="
    echo ""
    echo "Description: $PROVIDER_DESCRIPTION"
    echo "Version: $PROVIDER_VERSION"
    echo ""
    
    {{PROVIDER_CONFIGURE_LOGIC}}
    
    return $?
}

# Main speak function
speak() {
    local persona="$1"
    local message="$2"
    local options="$3"
    
    log_provider_activity "INFO" "Speech request for persona '$persona': ${#message} characters"
    
    # Validate inputs
    if [ -z "$persona" ] || [ -z "$message" ]; then
        log_provider_activity "ERROR" "Missing required parameters"
        return 1
    fi
    
    # Check provider availability
    if ! check; then
        log_provider_activity "ERROR" "Provider not available"
        return 1
    fi
    
    # Get voice for persona
    local voice=$(get_voice_for_persona "$persona")
    log_provider_activity "DEBUG" "Using voice '$voice' for persona '$persona'"
    
    {{PROVIDER_SPEAK_LOGIC}}
    
    return $?
}

# =============================================================================
# PROVIDER-SPECIFIC IMPLEMENTATION
# =============================================================================

{{PROVIDER_SPECIFIC_FUNCTIONS}}

# =============================================================================
# AUDIO PLAYBACK FUNCTIONS
# =============================================================================

# Detect platform for audio playback optimization
detect_platform() {
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl2"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "linux"
    fi
}

# Play audio file with multiple fallback options
play_audio_file() {
    local audio_file="$1"
    local audio_format="$2"
    
    if [ ! -f "$audio_file" ] || [ ! -s "$audio_file" ]; then
        log_provider_activity "ERROR" "Audio file not found or empty: $audio_file"
        return 1
    fi
    
    log_provider_activity "DEBUG" "Playing audio file: $audio_file (format: $audio_format)"
    
    local platform=$(detect_platform)
    local played=false
    
    # Platform-specific player preferences
    case "$platform" in
        "wsl2")
            # WSL2: PulseAudio preferred
            if [ "$audio_format" = "raw" ]; then
                {{WSL2_RAW_PLAYBACK}}
            else
                {{WSL2_FILE_PLAYBACK}}
            fi
            ;;
        "macos")
            # macOS: afplay preferred
            {{MACOS_PLAYBACK}}
            ;;
        *)
            # Linux: ALSA preferred
            if [ "$audio_format" = "raw" ]; then
                {{LINUX_RAW_PLAYBACK}}
            else
                {{LINUX_FILE_PLAYBACK}}
            fi
            ;;
    esac
    
    # Clean up temporary file if created
    if [[ "$audio_file" == /tmp/* ]] || [[ "$audio_file" == *".tmp" ]]; then
        rm -f "$audio_file" 2>/dev/null || true
    fi
    
    if [ "$played" = false ]; then
        log_provider_activity "WARN" "All audio playback attempts failed"
        return 1
    else
        log_provider_activity "DEBUG" "Audio playback successful"
        return 0
    fi
}

# Stream audio with real-time playback
stream_audio() {
    local command="$1"
    local audio_format="$2"
    
    log_provider_activity "DEBUG" "Streaming audio with command: $command"
    
    local platform=$(detect_platform)
    
    case "$platform" in
        "wsl2")
            {{WSL2_STREAMING}}
            ;;
        "macos")
            {{MACOS_STREAMING}}
            ;;
        *)
            {{LINUX_STREAMING}}
            ;;
    esac
}

# =============================================================================
# CACHING FUNCTIONS
# =============================================================================

# Generate cache key for message
generate_cache_key() {
    local persona="$1"
    local message="$2"
    local voice="$3"
    
    # Create hash of persona + voice + message
    local hash_input="${PROVIDER_NAME}_${persona}_${voice}_${message}"
    local cache_key=$(echo -n "$hash_input" | md5sum 2>/dev/null | cut -d' ' -f1 || echo "nocache")
    
    echo "$cache_key"
}

# Get cached audio file path
get_cached_audio() {
    local cache_key="$1"
    local cache_dir="$PROJECT_ROOT/.cache/tts"
    local cache_file="$cache_dir/${PROVIDER_NAME}_${cache_key}.{{CACHE_AUDIO_FORMAT}}"
    
    if [ -f "$cache_file" ] && [ -s "$cache_file" ]; then
        # Check if cache file is not too old (default: 7 days)
        local max_age=$((7 * 24 * 60 * 60))  # 7 days in seconds
        local file_age=$(( $(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || echo 0) ))
        
        if [ $file_age -lt $max_age ]; then
            echo "$cache_file"
            return 0
        else
            # Remove old cache file
            rm -f "$cache_file" 2>/dev/null || true
        fi
    fi
    
    return 1
}

# Store audio in cache
cache_audio() {
    local cache_key="$1"
    local audio_file="$2"
    local cache_dir="$PROJECT_ROOT/.cache/tts"
    local cache_file="$cache_dir/${PROVIDER_NAME}_${cache_key}.{{CACHE_AUDIO_FORMAT}}"
    
    # Create cache directory
    mkdir -p "$cache_dir" 2>/dev/null || true
    
    # Copy audio file to cache
    if cp "$audio_file" "$cache_file" 2>/dev/null; then
        log_provider_activity "DEBUG" "Audio cached: $cache_file"
        return 0
    else
        log_provider_activity "WARN" "Failed to cache audio"
        return 1
    fi
}

# =============================================================================
# ERROR HANDLING AND RECOVERY
# =============================================================================

# Handle provider-specific errors
handle_provider_error() {
    local exit_code="$1"
    local context="$2"
    
    log_provider_activity "ERROR" "Provider error in $context (exit code: $exit_code)"
    
    case $exit_code in
        1)
            echo "Error: General provider failure" >&2
            ;;
        2)
            echo "Error: Configuration issue" >&2
            ;;
        3)
            echo "Error: Authentication failure" >&2
            ;;
        4)
            echo "Error: Network/connectivity issue" >&2
            ;;
        5)
            echo "Error: Audio generation failed" >&2
            ;;
        6)
            echo "Error: Audio playback failed" >&2
            ;;
        *)
            echo "Error: Unknown provider error ($exit_code)" >&2
            ;;
    esac
    
    return $exit_code
}

# Attempt recovery from common errors
attempt_recovery() {
    local error_type="$1"
    
    log_provider_activity "INFO" "Attempting recovery from error: $error_type"
    
    case "$error_type" in
        "auth")
            {{AUTH_RECOVERY}}
            ;;
        "network")
            {{NETWORK_RECOVERY}}
            ;;
        "audio")
            {{AUDIO_RECOVERY}}
            ;;
        "config")
            {{CONFIG_RECOVERY}}
            ;;
        *)
            log_provider_activity "WARN" "No recovery strategy for error type: $error_type"
            return 1
            ;;
    esac
}

# =============================================================================
# TESTING AND VALIDATION
# =============================================================================

# Test provider functionality
test_provider() {
    echo "=== Testing {{PROVIDER_NAME}} TTS Provider ==="
    echo "Version: $PROVIDER_VERSION"
    echo "Description: $PROVIDER_DESCRIPTION"
    echo ""
    
    # Check availability
    echo "Availability Check:"
    if check; then
        echo "- Provider available: ✓"
    else
        echo "- Provider available: ✗"
        return 1
    fi
    
    # Configuration check
    echo ""
    echo "Configuration Check:"
    {{PROVIDER_TEST_CONFIG}}
    
    # Voice mapping test
    echo ""
    echo "Voice Mappings:"
    for persona in orchestrator developer architect analyst qa pm po sm design_architect; do
        local voice=$(get_voice_for_persona "$persona")
        echo "- $persona: $voice"
    done
    
    # Speech synthesis test
    echo ""
    echo "Speech Synthesis Test:"
    local test_message="Testing {{PROVIDER_NAME}} text-to-speech provider version $PROVIDER_VERSION."
    echo "- Test message: $test_message"
    echo "- Synthesizing and playing..."
    
    if speak "orchestrator" "$test_message"; then
        echo "- Result: ✓ Success"
        return 0
    else
        echo "- Result: ✗ Failed"
        return 1
    fi
}

# Validate provider configuration
validate_config() {
    local errors=0
    
    echo "=== {{PROVIDER_NAME}} Configuration Validation ==="
    echo ""
    
    {{PROVIDER_VALIDATE_CONFIG}}
    
    if [ $errors -eq 0 ]; then
        echo "Configuration validation: ✓ All checks passed"
        return 0
    else
        echo "Configuration validation: ✗ $errors error(s) found"
        return 1
    fi
}

# =============================================================================
# MAIN COMMAND HANDLER
# =============================================================================

# Main command handler
case "${1:-info}" in
    info)
        info
        ;;
    check)
        check
        ;;
    speak)
        if [ $# -lt 3 ]; then
            echo "Usage: $0 speak <persona> <message> [options]"
            exit 1
        fi
        speak "$2" "$3" "$4"
        ;;
    configure)
        configure
        ;;
    test)
        test_provider
        ;;
    validate)
        validate_config
        ;;
    version)
        echo "{{PROVIDER_NAME}} TTS Provider v$PROVIDER_VERSION"
        echo "Template version: {{TEMPLATE_VERSION}}"
        ;;
    help|--help|-h)
        cat << EOF
{{PROVIDER_NAME}} TTS Provider - $PROVIDER_DESCRIPTION

Usage: $0 <command> [options]

Commands:
    info                          Show provider information
    check                         Check if provider is available
    speak <persona> <message>     Synthesize and speak message
    configure                     Configure provider settings
    test                          Test provider functionality
    validate                      Validate configuration
    version                       Show version information
    help                          Show this help

Examples:
    $0 info
    $0 check
    $0 speak orchestrator "Hello world"
    $0 configure
    $0 test

Environment Variables:
{{PROVIDER_ENV_HELP}}

Configuration:
    Settings file: $SETTINGS_FILE
    Log file: $PROJECT_ROOT/.cache/tts/{{PROVIDER_NAME}}.log (if TTS_DEBUG=true)

EOF
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac

# =============================================================================
# TEMPLATE METADATA
# =============================================================================

# Template Information (for maintenance and tracking)
# Template: tts-provider-template.sh.template
# Version: {{TEMPLATE_VERSION}}
# Generated: {{GENERATION_TIMESTAMP}}
# Provider: {{PROVIDER_NAME}}
# Description: {{PROVIDER_DESCRIPTION}}
#
# Customization Points:
# - Provider-specific configuration section
# - Voice mappings for personas
# - Check logic for provider availability
# - Configure logic for interactive setup
# - Speak logic for TTS synthesis
# - Audio playback implementation
# - Error handling and recovery
# - Testing and validation
#
# Integration Requirements:
# - Must be executable and placed in tts-providers/ directory
# - Must respond to: info, check, speak, configure commands
# - Must use consistent logging format
# - Must handle graceful failures
# - Must support voice mapping for all personas
#
# Testing:
# - Run 'check' command to verify availability
# - Run 'test' command for comprehensive testing
# - Set TTS_DEBUG=true for detailed logging