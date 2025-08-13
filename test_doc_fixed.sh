#!/bin/bash
set -e

echo "=========================================="
echo "TESTING FIXED DOCUMENTATION INSTALLATION"
echo "=========================================="
echo ""

# Clean up any previous test
rm -rf test_doc_fixed_dir 2>/dev/null || true

# Create test directory
TEST_DIR="test_doc_fixed_dir"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $(pwd)"
echo ""

# Extract distribution
echo "Extracting distribution..."
tar -xzf ../dist/apm-v4.0.0.tar.gz
cd apm-v4.0.0

echo "Testing documentation installation..."
echo ""
echo "Running installer from INSIDE extracted directory (simulating curl install)..."
bash installer/install.sh --defaults 2>&1 | grep -E "(Installing Documentation|documentation|✅)" | head -30

echo ""
echo "=========================================="
echo "VERIFYING DOCUMENTATION INSTALLATION"
echo "=========================================="
echo ""

# Check documentation structure
if [ -d ".apm/documentation" ]; then
    echo "✅ SUCCESS! Documentation directory exists at .apm/documentation!"
    echo ""
    
    # Count total documentation files
    TOTAL_DOCS=$(find .apm/documentation -type f -name "*.md" | wc -l)
    echo "📚 Total documentation files: $TOTAL_DOCS"
    
    echo ""
    echo "Documentation structure:"
    ls -la .apm/documentation/ | head -15
    
    echo ""
    echo "Sample files:"
    find .apm/documentation -type f -name "*.md" | head -10
    
    if [ "$TOTAL_DOCS" -gt 50 ]; then
        echo ""
        echo "✅ DOCUMENTATION FIX SUCCESSFUL!"
        echo "   Documentation is now properly installed outside SKIP_COPY block"
    fi
else
    echo "❌ FAILED: Documentation directory NOT created!"
    echo ""
    echo "Contents of .apm:"
    ls -la .apm/ | head -20
fi

# Also check main README
if [ -f ".apm/README.md" ]; then
    echo ""
    echo "✅ Main APM README exists at .apm/README.md"
fi

# Cleanup message
cd ../..
echo ""
echo "Test complete!"
echo "To explore: cd $TEST_DIR/apm-v4.0.0/.apm/documentation"
echo "To cleanup: rm -rf $TEST_DIR"