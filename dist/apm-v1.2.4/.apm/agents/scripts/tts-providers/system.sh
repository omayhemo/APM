#!/bin/bash
# System TTS Provider - Uses native OS text-to-speech

set -e

# Provider info
info() {
    echo "System TTS - Native operating system text-to-speech"
}

# Detect available system TTS
detect_system_tts() {
    if command -v say >/dev/null 2>&1; then
        echo "say"  # macOS
    elif command -v espeak >/dev/null 2>&1; then
        echo "espeak"  # Linux
    elif command -v espeak-ng >/dev/null 2>&1; then
        echo "espeak-ng"  # Linux (newer)
    elif command -v festival >/dev/null 2>&1; then
        echo "festival"  # Linux
    elif command -v spd-say >/dev/null 2>&1; then
        echo "spd-say"  # Linux speech-dispatcher
    else
        echo ""
    fi
}

# Check if provider is available
check() {
    local tts_cmd=$(detect_system_tts)
    if [ -n "$tts_cmd" ]; then
        return 0
    else
        return 1
    fi
}

# Voice mappings for different systems
get_system_voice() {
    local persona="$1"
    local tts_cmd="$2"
    
    case "$tts_cmd" in
        say)
            # macOS voices
            case "$persona" in
                orchestrator) echo "Alex" ;;
                developer) echo "Daniel" ;;
                architect) echo "Tom" ;;
                analyst) echo "Samantha" ;;
                qa) echo "Victoria" ;;
                pm) echo "Daniel" ;;
                po) echo "Alex" ;;
                sm) echo "Daniel" ;;
                design_architect) echo "Karen" ;;
                *) echo "Alex" ;;
            esac
            ;;
        espeak|espeak-ng)
            # espeak voices (variants)
            case "$persona" in
                orchestrator) echo "en+m1" ;;
                developer) echo "en+m2" ;;
                architect) echo "en+m3" ;;
                analyst) echo "en+f1" ;;
                qa) echo "en+f2" ;;
                pm) echo "en+m4" ;;
                po) echo "en+m1" ;;
                sm) echo "en+m2" ;;
                design_architect) echo "en+f3" ;;
                *) echo "en" ;;
            esac
            ;;
        *)
            echo ""
            ;;
    esac
}

# Speak function
speak() {
    local persona="$1"
    local message="$2"
    local options="$3"
    
    local tts_cmd=$(detect_system_tts)
    
    # If no working TTS, fall back to notification sound + text display
    if [ -z "$tts_cmd" ]; then
        echo "🔊 $persona: $message"
        # Try to play notification sound as audio feedback
        local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        local sound_file="$(dirname "$(dirname "$script_dir")")/sounds/notification.mp3"
        if [ -f "$sound_file" ] && command -v mpg123 >/dev/null 2>&1; then
            mpg123 -q "$sound_file" 2>/dev/null || true
        fi
        return 0
    fi
    
    local voice=$(get_system_voice "$persona" "$tts_cmd")
    
    case "$tts_cmd" in
        say)
            # macOS say command
            if [ -n "$voice" ]; then
                say -v "$voice" "$message" 2>/dev/null
            else
                say "$message" 2>/dev/null
            fi
            ;;
        espeak)
            # espeak command - try but fall back to notification on error
            if [ -n "$voice" ]; then
                espeak -v "$voice" "$message" 2>/dev/null || {
                    echo "🔊 $persona: $message"
                    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
                    local sound_file="$(dirname "$(dirname "$script_dir")")/sounds/notification.mp3"
                    if [ -f "$sound_file" ] && command -v mpg123 >/dev/null 2>&1; then
                        mpg123 -q "$sound_file" 2>/dev/null || true
                    fi
                }
            else
                espeak "$message" 2>/dev/null || {
                    echo "🔊 $persona: $message"
                    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
                    local sound_file="$(dirname "$(dirname "$script_dir")")/sounds/notification.mp3"
                    if [ -f "$sound_file" ] && command -v mpg123 >/dev/null 2>&1; then
                        mpg123 -q "$sound_file" 2>/dev/null || true
                    fi
                }
            fi
            ;;
        espeak-ng)
            # espeak-ng command - try but fall back to notification on error
            if [ -n "$voice" ]; then
                espeak-ng -v "$voice" "$message" 2>/dev/null || {
                    echo "🔊 $persona: $message"
                    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
                    local sound_file="$(dirname "$(dirname "$script_dir")")/sounds/notification.mp3"
                    if [ -f "$sound_file" ] && command -v mpg123 >/dev/null 2>&1; then
                        mpg123 -q "$sound_file" 2>/dev/null || true
                    fi
                }
            else
                espeak-ng "$message" 2>/dev/null || {
                    echo "🔊 $persona: $message"
                    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
                    local sound_file="$(dirname "$(dirname "$script_dir")")/sounds/notification.mp3"
                    if [ -f "$sound_file" ] && command -v mpg123 >/dev/null 2>&1; then
                        mpg123 -q "$sound_file" 2>/dev/null || true
                    fi
                }
            fi
            ;;
        festival)
            # festival command
            echo "$message" | festival --tts 2>/dev/null || {
                echo "🔊 $persona: $message"
                local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
                local sound_file="$(dirname "$(dirname "$script_dir")")/sounds/notification.mp3"
                if [ -f "$sound_file" ] && command -v mpg123 >/dev/null 2>&1; then
                    mpg123 -q "$sound_file" 2>/dev/null || true
                fi
            }
            ;;
        spd-say)
            # speech-dispatcher
            spd-say "$message" 2>/dev/null || {
                echo "🔊 $persona: $message"
                local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
                local sound_file="$(dirname "$(dirname "$script_dir")")/sounds/notification.mp3"
                if [ -f "$sound_file" ] && command -v mpg123 >/dev/null 2>&1; then
                    mpg123 -q "$sound_file" 2>/dev/null || true
                fi
            }
            ;;
        *)
            echo "🔊 $persona: $message"
            local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            local sound_file="$(dirname "$(dirname "$script_dir")")/sounds/notification.mp3"
            if [ -f "$sound_file" ] && command -v mpg123 >/dev/null 2>&1; then
                mpg123 -q "$sound_file" 2>/dev/null || true
            fi
            ;;
    esac
}

# Configure system TTS
configure() {
    echo "=== System TTS Configuration ==="
    echo ""
    
    local tts_cmd=$(detect_system_tts)
    if [ -n "$tts_cmd" ]; then
        echo "Detected system TTS: $tts_cmd"
        
        case "$tts_cmd" in
            say)
                echo "Available macOS voices:"
                say -v ? | head -10
                echo "... and more"
                ;;
            espeak|espeak-ng)
                echo "Available espeak voices:"
                $tts_cmd --voices=en | head -10
                ;;
            *)
                echo "Using default configuration for $tts_cmd"
                ;;
        esac
        
        echo ""
        echo "System TTS is ready to use!"
    else
        echo "No system TTS found. Install one of the following:"
        echo ""
        echo "macOS: Built-in 'say' command (already installed)"
        echo "Linux: sudo apt-get install espeak-ng"
        echo "       sudo apt-get install festival"
        echo "       sudo apt-get install speech-dispatcher"
        return 1
    fi
}

# Main command handler
case "${1:-info}" in
    info)
        info
        ;;
    check)
        check
        ;;
    speak)
        speak "$2" "$3" "$4"
        ;;
    configure)
        configure
        ;;
    *)
        echo "Usage: $0 {info|check|speak|configure}"
        exit 1
        ;;
esac