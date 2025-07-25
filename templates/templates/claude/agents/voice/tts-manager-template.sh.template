#!/bin/bash
# TTS Manager Template - Central hub for all text-to-speech operations
# Supports multiple providers: piper, elevenlabs, system, discord, none
# Generated from tts-manager-template.sh.template

# =============================================================================
# CONFIGURATION AND INITIALIZATION
# =============================================================================

# Don't use strict mode to allow graceful failures
# set -e

# Get the directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AP_ROOT="$(dirname "$SCRIPT_DIR")"
APM_ROOT="$(dirname "$AP_ROOT")"
PROJECT_ROOT="$(dirname "$APM_ROOT")"

# Load settings
SETTINGS_FILE="{{SETTINGS_FILE}}"

# Cache directory for audio files
CACHE_DIR="{{CACHE_DIR}}"
mkdir -p "$CACHE_DIR" 2>/dev/null || true

# Provider directory
PROVIDER_DIR="$SCRIPT_DIR/tts-providers"

# Version information
TTS_MANAGER_VERSION="{{TTS_MANAGER_VERSION}}"

# =============================================================================
# SETTINGS MANAGEMENT
# =============================================================================

# Get TTS configuration from settings
get_tts_setting() {
    local key="$1"
    local default="$2"
    
    # Map old keys to new env variable names
    case "$key" in
        "enabled") env_key="TTS_ENABLED" ;;
        "provider") env_key="TTS_PROVIDER" ;;
        "fallback_provider") env_key="TTS_FALLBACK_PROVIDER" ;;
        *) env_key="TTS_$(echo "$key" | tr '[:lower:]' '[:upper:]')" ;;
    esac
    
    # First check environment variable directly
    if [ -n "${!env_key:-}" ]; then
        echo "${!env_key}"
        return
    fi
    
    # Then check settings file
    if [ -f "$SETTINGS_FILE" ]; then
        # First try jq, fall back to grep
        if command -v jq >/dev/null 2>&1; then
            local value=$(jq -r ".env.$env_key // \"$default\"" "$SETTINGS_FILE" 2>/dev/null)
            if [ "$value" != "null" ] && [ -n "$value" ]; then
                echo "$value"
            else
                echo "$default"
            fi
        else
            # Fallback grep-based extraction
            local value=$(grep -o "\"$env_key\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" "$SETTINGS_FILE" 2>/dev/null | cut -d'"' -f4)
            echo "${value:-$default}"
        fi
    else
        echo "$default"
    fi
}

# Get provider-specific setting
get_provider_setting() {
    local provider="$1"
    local key="$2"
    local default="$3"
    
    # Map provider and key to env variable name
    local env_key="TTS_$(echo "$provider" | tr '[:lower:]' '[:upper:]')_$(echo "$key" | tr '[:lower:]' '[:upper:]')"
    
    # First check environment variable directly
    if [ -n "${!env_key:-}" ]; then
        echo "${!env_key}"
        return
    fi
    
    # Then check settings file
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

# Get voice mapping for persona and provider
get_voice_mapping() {
    local persona="$1"
    local provider="$2"
    local default="$3"
    
    # Map to env variable name: TTS_VOICE_<PERSONA>_<PROVIDER>
    local env_key="TTS_VOICE_$(echo "$persona" | tr '[:lower:]' '[:upper:]' | tr '-' '_')_$(echo "$provider" | tr '[:lower:]' '[:upper:]')"
    
    # First check environment variable directly
    if [ -n "${!env_key:-}" ]; then
        echo "${!env_key}"
        return
    fi
    
    # Then check settings file
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

# =============================================================================
# PROVIDER DETECTION AND MANAGEMENT
# =============================================================================

# Detect available TTS providers
detect_providers() {
    local providers=()
    
    # Check for provider scripts
    if [ -d "$PROVIDER_DIR" ]; then
        for provider_script in "$PROVIDER_DIR"/*.sh; do
            if [ -f "$provider_script" ] && [ -x "$provider_script" ]; then
                local provider_name=$(basename "$provider_script" .sh)
                
                # Check if provider is available
                if "$provider_script" check >/dev/null 2>&1; then
                    providers+=("$provider_name")
                fi
            fi
        done
    fi
    
    # Always add 'none' as fallback
    if [[ ! " ${providers[@]} " =~ " none " ]]; then
        providers+=("none")
    fi
    
    echo "${providers[@]}"
}

# Get configured provider with auto-detection
get_provider() {
    local configured_provider=$(get_tts_setting "provider" "{{DEFAULT_TTS_PROVIDER}}")
    
    if [ "$configured_provider" = "auto" ]; then
        # Auto-detect best available provider
        local available_providers=($(detect_providers))
        
        # Preference order: {{PROVIDER_PREFERENCE_ORDER}}
        local preferred_order=({{PROVIDER_PREFERENCE_ARRAY}})
        
        for pref in "${preferred_order[@]}"; do
            if [[ " ${available_providers[@]} " =~ " $pref " ]]; then
                echo "$pref"
                return 0
            fi
        done
        
        # Fallback to first available
        echo "${available_providers[0]:-none}"
    else
        echo "$configured_provider"
    fi
}

# Validate provider availability
validate_provider() {
    local provider="$1"
    local provider_script="$PROVIDER_DIR/$provider.sh"
    
    if [ ! -f "$provider_script" ]; then
        return 1
    fi
    
    if [ ! -x "$provider_script" ]; then
        return 2
    fi
    
    if ! "$provider_script" check >/dev/null 2>&1; then
        return 3
    fi
    
    return 0
}

# =============================================================================
# CORE TTS FUNCTIONALITY
# =============================================================================

# Main speak function with enhanced error handling
speak() {
    local persona="$1"
    local message="$2"
    local options="$3"
    
    # Input validation
    if [ -z "$persona" ] || [ -z "$message" ]; then
        log_tts_activity "ERROR" "Missing required parameters: persona='$persona', message='$message'"
        return 1
    fi
    
    log_tts_activity "INFO" "Speech request for persona '$persona': ${#message} characters"
    
    # Check if TTS is enabled
    local tts_enabled=$(get_tts_setting "enabled" "{{DEFAULT_TTS_ENABLED}}")
    if [ "$tts_enabled" != "true" ]; then
        log_tts_activity "INFO" "TTS disabled globally, skipping speech synthesis"
        return 0
    fi
    
    # Check persona-specific TTS setting
    local persona_upper=$(echo "$persona" | tr '[:lower:]' '[:upper:]' | tr '-' '_')
    local persona_enabled=$(get_tts_setting "enabled_$persona_upper" "true")
    if [ "$persona_enabled" != "true" ]; then
        log_tts_activity "INFO" "TTS disabled for persona '$persona', skipping speech synthesis"
        return 0
    fi
    
    # Get provider with fallback chain
    local provider=$(get_provider)
    local provider_script="$PROVIDER_DIR/$provider.sh"
    
    log_tts_activity "DEBUG" "Using provider: $provider"
    
    # Validate primary provider
    if ! validate_provider "$provider"; then
        log_tts_activity "WARN" "Primary provider '$provider' not available, trying fallback"
        
        # Try fallback provider
        local fallback=$(get_tts_setting "fallback_provider" "{{DEFAULT_FALLBACK_PROVIDER}}")
        if [ "$fallback" != "$provider" ] && validate_provider "$fallback"; then
            provider="$fallback"
            provider_script="$PROVIDER_DIR/$fallback.sh"
            log_tts_activity "INFO" "Using fallback provider: $fallback"
        else
            log_tts_activity "WARN" "No available providers, using silent mode"
            return 0
        fi
    fi
    
    # Execute provider speak command with error handling
    local start_time=$(date +%s)
    if "$provider_script" speak "$persona" "$message" "$options" 2>/dev/null; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_tts_activity "INFO" "Speech synthesis completed successfully in ${duration}s"
        return 0
    else
        local exit_code=$?
        log_tts_activity "ERROR" "Speech synthesis failed with exit code $exit_code"
        return $exit_code
    fi
}

# Batch speak function for multiple messages
batch_speak() {
    local persona="$1"
    shift
    local messages=("$@")
    
    log_tts_activity "INFO" "Batch speech request for persona '$persona': ${#messages[@]} messages"
    
    local success_count=0
    local failure_count=0
    
    for message in "${messages[@]}"; do
        if speak "$persona" "$message"; then
            ((success_count++))
        else
            ((failure_count++))
        fi
    done
    
    log_tts_activity "INFO" "Batch speech completed: $success_count successful, $failure_count failed"
    
    # Return success if at least one message was spoken
    [ $success_count -gt 0 ]
}

# =============================================================================
# TESTING AND DIAGNOSTICS
# =============================================================================

# Comprehensive TTS testing
test_tts() {
    local provider="${1:-$(get_provider)}"
    
    echo "=== TTS Manager Test Suite ==="
    echo "Version: $TTS_MANAGER_VERSION"
    echo "Testing provider: $provider"
    echo "Timestamp: $(date)"
    echo ""
    
    # Configuration information
    echo "Configuration:"
    echo "- Settings file: $SETTINGS_FILE"
    echo "- Provider directory: $PROVIDER_DIR"
    echo "- Cache directory: $CACHE_DIR"
    echo "- TTS enabled: $(get_tts_setting "enabled" "true")"
    echo "- Configured provider: $(get_tts_setting "provider" "auto")"
    echo "- Fallback provider: $(get_tts_setting "fallback_provider" "none")"
    echo ""
    
    # Provider validation
    echo "Provider Validation:"
    local provider_script="$PROVIDER_DIR/$provider.sh"
    echo "- Provider script: $provider_script"
    
    if [ -f "$provider_script" ]; then
        echo "- Script exists: ✓"
        
        if [ -x "$provider_script" ]; then
            echo "- Script executable: ✓"
            
            if "$provider_script" check >/dev/null 2>&1; then
                echo "- Provider available: ✓"
                
                # Test speech synthesis
                echo ""
                echo "Speech Synthesis Test:"
                local test_message="Testing {{TTS_MANAGER_NAME}} version $TTS_MANAGER_VERSION with $provider provider."
                echo "- Test message: $test_message"
                echo "- Speaking..."
                
                if speak "orchestrator" "$test_message"; then
                    echo "- Speech synthesis: ✓"
                else
                    echo "- Speech synthesis: ✗"
                    return 1
                fi
                
            else
                echo "- Provider available: ✗"
                echo "- Error: Provider check failed"
                return 1
            fi
        else
            echo "- Script executable: ✗"
            echo "- Fix with: chmod +x $provider_script"
            return 1
        fi
    else
        echo "- Script exists: ✗"
        echo "- Error: Provider script not found"
        return 1
    fi
    
    echo ""
    echo "Test completed successfully ✓"
    return 0
}

# Test all available providers
test_all_providers() {
    echo "=== Testing All Available Providers ==="
    echo ""
    
    local providers=($(detect_providers))
    local success_count=0
    local total_count=${#providers[@]}
    
    for provider in "${providers[@]}"; do
        echo "Testing provider: $provider"
        echo "----------------------------------------"
        
        if test_tts "$provider"; then
            echo "Result: ✓ PASS"
            ((success_count++))
        else
            echo "Result: ✗ FAIL"
        fi
        
        echo ""
    done
    
    echo "=== Test Summary ==="
    echo "Total providers: $total_count"
    echo "Successful: $success_count"
    echo "Failed: $((total_count - success_count))"
    
    if [ $success_count -eq $total_count ]; then
        echo "Overall result: ✓ ALL TESTS PASSED"
        return 0
    else
        echo "Overall result: ✗ SOME TESTS FAILED"
        return 1
    fi
}

# =============================================================================
# PROVIDER MANAGEMENT
# =============================================================================

# Configure TTS provider
configure_provider() {
    local provider="${1:-$(get_provider)}"
    local provider_script="$PROVIDER_DIR/$provider.sh"
    
    echo "=== Configure TTS Provider: $provider ==="
    echo ""
    
    if [ -f "$provider_script" ] && [ -x "$provider_script" ]; then
        log_tts_activity "INFO" "Configuring provider: $provider"
        "$provider_script" configure
        local exit_code=$?
        
        if [ $exit_code -eq 0 ]; then
            log_tts_activity "INFO" "Provider configuration completed successfully"
            echo ""
            echo "Configuration completed successfully ✓"
        else
            log_tts_activity "ERROR" "Provider configuration failed with exit code $exit_code"
            echo ""
            echo "Configuration failed ✗"
        fi
        
        return $exit_code
    else
        echo "Error: Provider '$provider' not found or not executable"
        log_tts_activity "ERROR" "Provider script not found: $provider_script"
        return 1
    fi
}

# List all available providers with details
list_providers() {
    echo "=== Available TTS Providers ==="
    echo ""
    
    local current_provider=$(get_provider)
    local providers=($(detect_providers))
    
    if [ ${#providers[@]} -eq 0 ]; then
        echo "No TTS providers available."
        return 1
    fi
    
    for provider in "${providers[@]}"; do
        local marker=" "
        if [ "$provider" = "$current_provider" ]; then
            marker="*"
        fi
        
        echo "$marker $provider"
        
        # Get provider information
        local provider_script="$PROVIDER_DIR/$provider.sh"
        if [ -f "$provider_script" ]; then
            local info=$("$provider_script" info 2>/dev/null || echo "No description available")
            echo "    $info"
            
            # Show provider status
            if "$provider_script" check >/dev/null 2>&1; then
                echo "    Status: ✓ Available"
            else
                echo "    Status: ✗ Not available"
            fi
        else
            echo "    Status: ✗ Script not found"
        fi
        
        echo ""
    done
    
    echo "* = Current provider"
}

# =============================================================================
# CACHE MANAGEMENT
# =============================================================================

# Clear TTS cache with options
clear_cache() {
    local option="${1:-all}"
    
    echo "Clearing TTS cache..."
    log_tts_activity "INFO" "Cache cleanup requested: $option"
    
    case "$option" in
        "all")
            if [ -d "$CACHE_DIR" ]; then
                local cache_size=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo "unknown")
                rm -rf "$CACHE_DIR"/*
                mkdir -p "$CACHE_DIR" 2>/dev/null || true
                echo "All cache files cleared (was $cache_size)"
                log_tts_activity "INFO" "All cache files cleared, size was: $cache_size"
            else
                echo "Cache directory does not exist"
            fi
            ;;
        "old")
            if [ -d "$CACHE_DIR" ]; then
                # Remove files older than 7 days
                find "$CACHE_DIR" -type f -mtime +7 -delete 2>/dev/null || true
                echo "Old cache files (>7 days) cleared"
                log_tts_activity "INFO" "Old cache files cleared"
            fi
            ;;
        "large")
            if [ -d "$CACHE_DIR" ]; then
                # Remove files larger than 10MB
                find "$CACHE_DIR" -type f -size +10M -delete 2>/dev/null || true
                echo "Large cache files (>10MB) cleared"
                log_tts_activity "INFO" "Large cache files cleared"
            fi
            ;;
        *)
            echo "Usage: clear-cache [all|old|large]"
            return 1
            ;;
    esac
}

# Show cache statistics
cache_stats() {
    echo "=== TTS Cache Statistics ==="
    echo ""
    
    if [ ! -d "$CACHE_DIR" ]; then
        echo "Cache directory does not exist: $CACHE_DIR"
        return 1
    fi
    
    local total_files=$(find "$CACHE_DIR" -type f | wc -l)
    local total_size=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1 || echo "unknown")
    local oldest_file=$(find "$CACHE_DIR" -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | head -1 | cut -d' ' -f2- || echo "none")
    local newest_file=$(find "$CACHE_DIR" -type f -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2- || echo "none")
    
    echo "Cache directory: $CACHE_DIR"
    echo "Total files: $total_files"
    echo "Total size: $total_size"
    echo "Oldest file: $(basename "$oldest_file" 2>/dev/null || echo "none")"
    echo "Newest file: $(basename "$newest_file" 2>/dev/null || echo "none")"
    
    # Show file type breakdown
    echo ""
    echo "File types:"
    find "$CACHE_DIR" -type f -name "*.wav" | wc -l | xargs -I {} echo "  WAV files: {}"
    find "$CACHE_DIR" -type f -name "*.mp3" | wc -l | xargs -I {} echo "  MP3 files: {}"
    find "$CACHE_DIR" -type f -name "*.raw" | wc -l | xargs -I {} echo "  RAW files: {}"
}

# =============================================================================
# AUDIO SYSTEM DIAGNOSTICS
# =============================================================================

# Comprehensive audio system diagnosis
diagnose_audio() {
    echo "=== Audio System Diagnostics ==="
    echo "Timestamp: $(date)"
    echo ""
    
    # System information
    echo "System Information:"
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "- Platform: WSL2"
        echo "- WSLg PulseServer: ${PULSE_SERVER:-not set}"
        echo "- Display: ${DISPLAY:-not set}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "- Platform: macOS"
    else
        echo "- Platform: Linux"
    fi
    echo ""
    
    # Audio system detection
    echo "Audio Systems:"
    if command -v pactl >/dev/null 2>&1; then
        echo "- PulseAudio: ✓ available"
        if pactl info >/dev/null 2>&1; then
            echo "  Status: ✓ running"
            pactl info 2>/dev/null | grep -E "Server Name|Default Sink" | sed 's/^/  /'
        else
            echo "  Status: ✗ not running"
        fi
    else
        echo "- PulseAudio: ✗ not available"
    fi
    
    if command -v aplay >/dev/null 2>&1; then
        echo "- ALSA: ✓ available"
        aplay -l 2>/dev/null | head -3 | sed 's/^/  /' || echo "  No ALSA devices found"
    else
        echo "- ALSA: ✗ not available"
    fi
    
    echo ""
    
    # Audio players
    echo "Audio Players:"
    local players=("paplay" "aplay" "play" "afplay" "mpg123" "ffplay")
    for player in "${players[@]}"; do
        if command -v "$player" >/dev/null 2>&1; then
            echo "- $player: ✓ installed"
        else
            echo "- $player: ✗ not found"
        fi
    done
    echo ""
    
    # TTS system status
    echo "TTS System Status:"
    echo "- TTS Manager: $0"
    echo "- Version: $TTS_MANAGER_VERSION"
    echo "- TTS enabled: $(get_tts_setting "enabled" "true")"
    echo "- Current provider: $(get_provider)"
    echo "- Fallback provider: $(get_tts_setting "fallback_provider" "none")"
    echo "- Cache directory: $CACHE_DIR"
    
    if [ -d "$CACHE_DIR" ]; then
        local cache_files=$(find "$CACHE_DIR" -type f | wc -l)
        echo "- Cache files: $cache_files"
    else
        echo "- Cache files: directory not found"
    fi
    echo ""
    
    # Provider status  
    echo "TTS Providers:"
    local providers=($(detect_providers))
    for provider in "${providers[@]}"; do
        local provider_script="$PROVIDER_DIR/$provider.sh"
        if [ -f "$provider_script" ] && [ -x "$provider_script" ]; then
            if "$provider_script" check >/dev/null 2>&1; then
                echo "- $provider: ✓ available"
            else
                echo "- $provider: ✗ not available"
            fi
        else
            echo "- $provider: ✗ script not found"
        fi
    done
    echo ""
    
    # Audio test
    echo "Audio Playback Test:"
    if [ -f /usr/share/sounds/alsa/Front_Center.wav ]; then
        echo "- System test sound available: ✓"
        
        # Test different players
        local test_file="/usr/share/sounds/alsa/Front_Center.wav"
        
        if command -v paplay >/dev/null 2>&1; then
            if paplay "$test_file" >/dev/null 2>&1; then
                echo "- paplay test: ✓ works"
            else
                echo "- paplay test: ✗ failed"
            fi
        fi
        
        if command -v aplay >/dev/null 2>&1; then
            if aplay "$test_file" >/dev/null 2>&1; then
                echo "- aplay test: ✓ works"
            else
                echo "- aplay test: ✗ failed"
            fi
        fi
    else
        echo "- System test sound: ✗ not available"
    fi
    echo ""
    
    # Platform-specific recommendations
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "WSL2 Troubleshooting Tips:"
        echo "- Ensure Windows audio is not muted"
        echo "- Try: pulseaudio --start --log-target=syslog"
        echo "- Check: ps aux | grep -E 'wslg|pulse'"
        echo "- Test: speaker-test -t wav -c 2"
        echo "- Verify: echo \$PULSE_SERVER"
    fi
}

# =============================================================================
# LOGGING AND MONITORING
# =============================================================================

# TTS activity logging
log_tts_activity() {
    local level="$1"
    local message="$2"
    
    # Check if logging is enabled
    if [ "${TTS_DEBUG:-false}" = "true" ]; then
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        local log_file="$CACHE_DIR/tts-manager.log"
        
        # Create log directory if it doesn't exist
        mkdir -p "$(dirname "$log_file")" 2>/dev/null || true
        
        # Write log entry
        echo "[$timestamp] [$level] [TTS-Manager] $message" >> "$log_file" 2>/dev/null || true
        
        # Also output to stderr if in debug mode
        if [ "${TTS_VERBOSE:-false}" = "true" ]; then
            echo "[$timestamp] [$level] $message" >&2
        fi
    fi
}

# Monitor TTS usage statistics
usage_stats() {
    local log_file="$CACHE_DIR/tts-manager.log"
    
    echo "=== TTS Usage Statistics ==="
    echo ""
    
    if [ ! -f "$log_file" ]; then
        echo "No usage data available (logging not enabled or no activity)"
        echo "Enable with: export TTS_DEBUG=true"
        return 1
    fi
    
    local total_requests=$(grep -c "Speech request" "$log_file" 2>/dev/null || echo "0")
    local successful_requests=$(grep -c "Speech synthesis completed successfully" "$log_file" 2>/dev/null || echo "0")
    local failed_requests=$(grep -c "Speech synthesis failed" "$log_file" 2>/dev/null || echo "0")
    
    echo "Request Statistics:"
    echo "- Total requests: $total_requests"
    echo "- Successful: $successful_requests"
    echo "- Failed: $failed_requests"
    
    if [ $total_requests -gt 0 ]; then
        local success_rate=$((successful_requests * 100 / total_requests))
        echo "- Success rate: ${success_rate}%"
    fi
    
    echo ""
    echo "Provider Usage:"
    grep "Using provider:" "$log_file" 2>/dev/null | cut -d' ' -f6 | sort | uniq -c | sed 's/^/- /' || echo "No provider usage data"
    
    echo ""
    echo "Most Active Personas:"
    grep "Speech request for persona" "$log_file" 2>/dev/null | sed "s/.*persona '\\([^']*\\)'.*/\\1/" | sort | uniq -c | sort -nr | head -5 | sed 's/^/- /' || echo "No persona usage data"
}

# =============================================================================
# HELP AND INFORMATION
# =============================================================================

# Show comprehensive help
show_help() {
    cat << EOF
{{TTS_MANAGER_NAME}} - Text-to-Speech Management Tool
Version: $TTS_MANAGER_VERSION

USAGE:
    $0 <command> [options]

COMMANDS:
    speak <persona> <message>     Speak a message as a persona
    batch-speak <persona> <msg1> <msg2> ...  Speak multiple messages
    test [provider]               Test TTS functionality
    test-all                      Test all available providers
    configure [provider]          Configure a TTS provider
    list                          List available providers
    
    clear-cache [all|old|large]   Clear audio cache
    cache-stats                   Show cache statistics
    diagnose                      Diagnose audio system issues
    usage-stats                   Show TTS usage statistics
    
    version                       Show version information
    help                          Show this help

EXAMPLES:
    # Basic usage
    $0 speak orchestrator "Hello world"
    $0 speak developer "Implementation complete"
    
    # Testing
    $0 test                       # Test current provider
    $0 test elevenlabs           # Test specific provider
    $0 test-all                  # Test all providers
    
    # Configuration
    $0 configure                 # Configure current provider
    $0 configure piper          # Configure specific provider
    $0 list                     # Show available providers
    
    # Maintenance
    $0 clear-cache              # Clear all cache files
    $0 clear-cache old          # Clear old cache files
    $0 cache-stats              # Show cache information
    $0 diagnose                 # Audio system diagnosis

ENVIRONMENT VARIABLES:
    TTS_ENABLED                 Enable/disable TTS (default: {{DEFAULT_TTS_ENABLED}})
    TTS_PROVIDER                TTS provider to use (default: {{DEFAULT_TTS_PROVIDER}})
    TTS_FALLBACK_PROVIDER       Fallback provider (default: {{DEFAULT_FALLBACK_PROVIDER}})
    TTS_DEBUG                   Enable debug logging (default: false)
    TTS_VERBOSE                 Enable verbose output (default: false)
    
    Provider-specific settings:
    TTS_PIPER_INSTALL_PATH      Piper installation directory
    TTS_ELEVENLABS_API_KEY      ElevenLabs API key
    TTS_SYSTEM_VOICE            System TTS voice name
    TTS_DISCORD_WEBHOOK_URL     Discord webhook URL
    
    Voice mappings:
    TTS_VOICE_<PERSONA>_<PROVIDER>  Voice for persona and provider

CONFIGURATION:
    Settings file: $SETTINGS_FILE
    Provider directory: $PROVIDER_DIR
    Cache directory: $CACHE_DIR
    
    Current settings:
    - TTS enabled: $(get_tts_setting "enabled" "true")
    - Provider: $(get_provider)
    - Fallback: $(get_tts_setting "fallback_provider" "none")

SUPPORTED PROVIDERS:
    auto        Auto-detect best available provider
    piper       Offline neural TTS (recommended)
    elevenlabs  Cloud-based premium TTS
    system      OS default TTS (espeak/say)
    discord     Discord webhook notifications
    none        Silent mode (no audio)

For more information, see the voice integration documentation.
EOF
}

# Show version information
show_version() {
    echo "{{TTS_MANAGER_NAME}} v$TTS_MANAGER_VERSION"
    echo "Template version: {{TEMPLATE_VERSION}}"
    echo "Generated: {{GENERATION_TIMESTAMP}}"
    echo ""
    echo "Configuration:"
    echo "- APM Root: $APM_ROOT"
    echo "- Project Root: $PROJECT_ROOT"
    echo "- Settings: $SETTINGS_FILE"
    echo "- Providers: $PROVIDER_DIR"
    echo "- Cache: $CACHE_DIR"
    echo ""
    echo "Runtime:"
    echo "- Shell: $SHELL"
    echo "- Platform: $(uname -s) $(uname -r)"
    echo "- TTS Status: $(get_tts_setting "enabled" "true")"
    echo "- Current Provider: $(get_provider)"
}

# =============================================================================
# MAIN COMMAND HANDLER
# =============================================================================

# Initialize logging
log_tts_activity "INFO" "TTS Manager started with command: $*"

# Main command handler with comprehensive error handling
case "${1:-help}" in
    speak)
        if [ $# -lt 3 ]; then
            echo "Error: speak command requires persona and message"
            echo "Usage: $0 speak <persona> <message>"
            exit 1
        fi
        speak "$2" "$3" "$4"
        ;;
    batch-speak)
        if [ $# -lt 3 ]; then
            echo "Error: batch-speak command requires persona and at least one message"
            echo "Usage: $0 batch-speak <persona> <message1> [message2] ..."
            exit 1
        fi
        batch_speak "$2" "${@:3}"
        ;;
    test)
        test_tts "$2"
        ;;
    test-all)
        test_all_providers
        ;;
    configure)
        configure_provider "$2"
        ;;
    list)
        list_providers
        ;;
    clear-cache)
        clear_cache "$2"
        ;;
    cache-stats)
        cache_stats
        ;;
    diagnose)
        diagnose_audio
        ;;
    usage-stats)
        usage_stats
        ;;
    version|--version|-v)
        show_version
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Error: Unknown command '$1'"
        echo ""
        show_help
        exit 1
        ;;
esac

# Log command completion
log_tts_activity "INFO" "TTS Manager command completed: $1"