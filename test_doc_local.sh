#!/bin/bash
set -e

echo "=========================================="
echo "TESTING DOCUMENTATION INSTALLATION LOCALLY"
echo "=========================================="
echo ""

# Create test directory in current location
TEST_DIR="test_doc_install_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $(pwd)"
echo ""

# Extract and run installer
echo "Extracting distribution..."
tar -xzf ../dist/apm-v4.0.0.tar.gz
cd apm-v4.0.0

echo "Running installer with defaults (will fail at TTS but that's OK)..."
bash installer/install.sh --defaults 2>&1 | head -200 | tail -50

echo ""
echo "=========================================="
echo "CHECKING DOCUMENTATION INSTALLATION"
echo "=========================================="
echo ""

# Check if documentation was installed
if [ -d ".apm/documentation" ]; then
    echo "✅ Documentation directory created!"
    echo ""
    echo "Documentation structure:"
    ls -la .apm/documentation/ | head -15
    
    echo ""
    echo "Number of documentation files:"
    find .apm/documentation -type f -name "*.md" | wc -l
else
    echo "❌ Documentation directory NOT created"
    echo ""
    echo "What was created in .apm:"
    ls -la .apm/ 2>/dev/null | head -20
fi

# Go back and cleanup
cd ../..
echo ""
echo "To explore: cd $TEST_DIR/apm-v4.0.0"
echo "To cleanup: rm -rf $TEST_DIR"