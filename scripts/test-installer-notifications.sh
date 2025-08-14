#!/bin/bash

# Test script for verifying installer notification fixes
# This simulates an installation with -d flag and checks the resulting configuration

echo "=========================================="
echo "Installer Notification Fix Test"
echo "=========================================="

PASS_COLOR='\033[0;32m'
FAIL_COLOR='\033[0;31m'
INFO_COLOR='\033[0;34m'
NC='\033[0m' # No Color

# Create a test directory
TEST_DIR="/tmp/apm-notification-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo -e "${INFO_COLOR}Test directory: $TEST_DIR${NC}"
echo

# Extract installer for testing (simulate installation)
echo "Extracting APM v3.1.0 for testing..."
tar -xzf /mnt/c/Code/agentic-persona-mapping/dist/apm-v3.1.0.tar.gz

# Run installer with defaults
echo "Running installer with -d flag..."
echo ""
./installer/install.sh -d > install.log 2>&1

# Check installation results
echo ""
echo "Checking installation results..."
echo "==============================="

# Function to check setting
check_setting() {
    local setting_name="$1"
    local expected_value="$2"
    local actual_value=$(jq -r ".env.$setting_name // \"not_set\"" .claude/settings.json 2>/dev/null)
    
    if [ "$actual_value" = "$expected_value" ]; then
        echo -e "${PASS_COLOR}✓${NC} $setting_name: $actual_value"
        return 0
    else
        echo -e "${FAIL_COLOR}✗${NC} $setting_name: Expected '$expected_value', got '$actual_value'"
        return 1
    fi
}

# Check TTS settings
echo ""
echo -e "${INFO_COLOR}TTS Configuration:${NC}"
check_setting "TTS_PROVIDER" "piper"
check_setting "TTS_ENABLED" "true"

# Check notification hooks
echo ""
echo -e "${INFO_COLOR}Notification Hooks:${NC}"
check_setting "HOOK_NOTIFICATION_ENABLED" "false"
check_setting "HOOK_PRE_TOOL_ENABLED" "false"
check_setting "HOOK_POST_TOOL_ENABLED" "false"
check_setting "HOOK_STOP_ENABLED" "true"
check_setting "HOOK_SUBAGENT_STOP_ENABLED" "true"
check_setting "HOOK_USER_PROMPT_SUBMIT_ENABLED" "true"
check_setting "HOOK_PRE_COMPACT_ENABLED" "true"

# Check audio players
echo ""
echo -e "${INFO_COLOR}Audio Players:${NC}"
AUDIO_PLAYER=$(jq -r '.env.AUDIO_PLAYER // "not_set"' .claude/settings.json 2>/dev/null)
WAV_PLAYER=$(jq -r '.env.WAV_PLAYER // "not_set"' .claude/settings.json 2>/dev/null)

if [ "$AUDIO_PLAYER" != "not_set" ] && [ "$AUDIO_PLAYER" != "none" ]; then
    echo -e "${PASS_COLOR}✓${NC} AUDIO_PLAYER: $AUDIO_PLAYER"
else
    echo -e "${FAIL_COLOR}✗${NC} AUDIO_PLAYER: No audio player configured"
fi

if [ "$WAV_PLAYER" != "not_set" ] && [ "$WAV_PLAYER" != "none" ]; then
    echo -e "${PASS_COLOR}✓${NC} WAV_PLAYER: $WAV_PLAYER"
else
    echo -e "${FAIL_COLOR}✗${NC} WAV_PLAYER: No WAV player configured"
fi

# Check if Piper was installed
echo ""
echo -e "${INFO_COLOR}Piper Installation:${NC}"
if [ -f ".piper/piper" ]; then
    echo -e "${PASS_COLOR}✓${NC} Piper binary installed"
else
    echo -e "${FAIL_COLOR}✗${NC} Piper binary not found"
fi

# Check notification sounds
echo ""
echo -e "${INFO_COLOR}Notification Sounds:${NC}"
if [ -f ".apm/agents/sounds/stop.mp3" ]; then
    echo -e "${PASS_COLOR}✓${NC} Notification sounds installed"
else
    echo -e "${FAIL_COLOR}✗${NC} Notification sounds not found"
fi

# Show summary
echo ""
echo "=========================================="
echo "Installation Log Excerpt:"
echo "=========================================="
grep -E "(TTS|notification|hook|piper|default)" install.log | tail -20

# Cleanup option
echo ""
echo -e "${INFO_COLOR}Test complete. Test directory: $TEST_DIR${NC}"
echo "To clean up: rm -rf $TEST_DIR"