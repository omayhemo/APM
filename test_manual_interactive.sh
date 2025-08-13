#!/bin/bash

echo "=========================================="
echo "MANUAL INTERACTIVE MODE TEST"
echo "=========================================="
echo ""
echo "This will test if the installer accepts your input."
echo ""
echo "When prompted, try entering:"
echo "1. A custom project name (e.g., 'TestProject')"
echo "2. 'n' for Debug Host MCP"
echo "3. '2' for ElevenLabs TTS (to test non-default)"
echo "4. Various choices for notifications"
echo ""
echo "If you can make these selections and they're accepted,"
echo "then the interactive mode is working!"
echo ""
echo "Press Enter to start the test..."
read

# Create test directory
TEST_DIR="/tmp/apm_manual_test_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""
echo "Starting installer..."
echo ""

# Run the installer - you'll need to manually enter responses
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash

# After installation, check if it worked
echo ""
echo "=========================================="
echo "POST-INSTALLATION CHECK"
echo "=========================================="

if [ -d ".apm" ]; then
    echo "✅ APM installed successfully"
    
    # Try to detect what was configured
    if [ -f ".claude/settings.json" ]; then
        echo ""
        echo "Settings detected:"
        grep -E "(project_name|tts_provider)" .claude/settings.json 2>/dev/null || true
    fi
    
    echo ""
    echo "If you were able to make selections during installation,"
    echo "then INTERACTIVE MODE IS WORKING!"
else
    echo "❌ Installation did not complete"
fi

echo ""
echo "Test directory: $TEST_DIR"
echo "You can explore the installation or remove with: rm -rf $TEST_DIR"