#!/bin/bash
set -e

echo "=========================================="
echo "TEST WITH CORRECT INSTALLER"
echo "=========================================="
echo ""

# Create test directory
TEST_DIR="/tmp/apm_sha_final_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo "Using commit SHA: 04b0706"
echo ""

# Run with the commit SHA that has the correct installer
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/04b0706/install.sh | bash -s -- --defaults

# Check results
if [ -d ".apm" ]; then
    echo ""
    echo "✅ INSTALLATION SUCCESSFUL!"
    echo ""
    echo "Contents of .apm:"
    ls -la .apm/ | head -10
else
    echo "❌ Installation failed"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"