#!/bin/bash
set -e

echo "Simulating installation process..."
echo ""

# Test 1: Fetch installer
echo "1. Testing installer URL..."
if curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | head -1 | grep -q "#!/bin/bash"; then
    echo "   ✅ Installer accessible"
else
    echo "   ❌ Installer not accessible"
    exit 1
fi

# Test 2: Check version API
echo "2. Testing version detection..."
VERSION=$(curl -s "https://api.github.com/repos/omayhemo/APM/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
if [ "$VERSION" = "v4.0.0" ]; then
    echo "   ✅ Version detected: $VERSION"
else
    echo "   ❌ Version detection failed"
    exit 1
fi

# Test 3: Download and extract
echo "3. Testing download and extraction..."
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"
curl -L -s -o apm.tar.gz "https://github.com/omayhemo/APM/releases/download/v4.0.0/apm-v4.0.0.tar.gz"
tar -xzf apm.tar.gz
EXTRACTED_DIR=$(find . -maxdepth 1 -type d -name "apm-*" | head -1)
if [ -n "$EXTRACTED_DIR" ] && [ -f "$EXTRACTED_DIR/installer/install.sh" ]; then
    echo "   ✅ Package extracts correctly: $EXTRACTED_DIR"
    echo "   ✅ Installer found: $EXTRACTED_DIR/installer/install.sh"
else
    echo "   ❌ Extraction failed"
    ls -la
    exit 1
fi

# Cleanup
cd - > /dev/null
rm -rf "$TEMP_DIR"

echo ""
echo "✅ ALL TESTS PASSED!"
echo ""
echo "The installation command should now work:"
echo "curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults"
