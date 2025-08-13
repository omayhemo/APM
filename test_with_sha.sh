#!/bin/bash
set -e

# Test installation with specific commit SHA to bypass CDN cache
TEST_DIR="/tmp/apm_sha_test_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Testing with commit SHA: ded6d90"
echo "Test directory: $TEST_DIR"
echo ""

# Download and run installer using commit SHA
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/ded6d90aeeb5b8204e3301b4d1c1579348e69722/install.sh | bash -s -- --defaults

# Check results
if [ -d ".apm" ]; then
    echo ""
    echo "✅ Installation completed successfully!"
    echo "Checking for documentation directory:"
    ls -la .apm/ | grep -E "(documentation|agents)"
else
    echo "❌ Installation failed"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"