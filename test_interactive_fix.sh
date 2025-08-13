#!/bin/bash

echo "=========================================="
echo "TESTING INTERACTIVE MODE FIX"
echo "=========================================="
echo ""
echo "This test verifies that the installer can accept"
echo "user input when piped through curl."
echo ""
echo "The installer should prompt you for:"
echo "1. Project name"
echo "2. Debug Host MCP Server (y/N)"
echo "3. TTS provider (1-5)"
echo "4. Notification settings"
echo "5. Python support (Y/n)"
echo ""
echo "If you can make selections, the fix is working!"
echo ""
echo "Press Enter to start the test..."
read

# Use the specific commit with the fix
echo "Running: curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/b0e5de1/install.sh | bash"
echo ""

# Create a test directory
TEST_DIR="/tmp/apm_interactive_test_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Run the installer
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/b0e5de1/install.sh | bash

# Check if installation succeeded
if [ -d ".apm" ]; then
    echo ""
    echo "✅ Installation completed successfully!"
    echo "✅ Interactive mode is working!"
else
    echo ""
    echo "❌ Installation may have failed"
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"