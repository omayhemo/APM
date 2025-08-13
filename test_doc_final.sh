#!/bin/bash
set -e

echo "=========================================="
echo "FINAL DOCUMENTATION INSTALLATION TEST"
echo "=========================================="
echo ""

# Clean up any previous test
rm -rf test_doc_final_dir 2>/dev/null || true

# Create test directory
TEST_DIR="test_doc_final_dir"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $(pwd)"
echo ""

# Extract distribution
echo "Extracting distribution..."
tar -xzf ../dist/apm-v4.0.0.tar.gz
cd apm-v4.0.0

echo "Running installer with defaults..."
bash installer/install.sh --defaults 2>&1 | grep -E "(documentation|✅|❌)" | head -30

echo ""
echo "=========================================="
echo "DOCUMENTATION VERIFICATION"
echo "=========================================="
echo ""

# Check documentation structure
if [ -d ".apm/documentation" ]; then
    echo "✅ Documentation directory exists!"
    echo ""
    
    # Count total documentation files
    TOTAL_DOCS=$(find .apm/documentation -type f -name "*.md" | wc -l)
    echo "📚 Total documentation files: $TOTAL_DOCS"
    
    # Check for .template files (should be none)
    TEMPLATE_COUNT=$(find .apm/documentation -type f -name "*.template" | wc -l)
    if [ "$TEMPLATE_COUNT" -eq 0 ]; then
        echo "✅ All templates processed (no .template files remaining)"
    else
        echo "⚠️  Found $TEMPLATE_COUNT unprocessed .template files"
    fi
    
    echo ""
    echo "Documentation categories:"
    for dir in .apm/documentation/*/; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            filecount=$(find "$dir" -type f -name "*.md" | wc -l)
            printf "  %-25s %3d files\n" "$dirname:" "$filecount"
        fi
    done
    
    echo ""
    echo "Sample documentation files:"
    echo "  - Getting Started:"
    ls .apm/documentation/01-getting-started/*.md 2>/dev/null | head -3 | sed 's/.*\//    /'
    
    echo "  - Command Reference:"
    ls .apm/documentation/command-reference/*.md 2>/dev/null | head -3 | sed 's/.*\//    /'
    
    echo "  - Parallel Docs:"
    ls .apm/documentation/PARALLEL*.md 2>/dev/null | head -3 | sed 's/.*\//    /'
    
    echo ""
    if [ "$TOTAL_DOCS" -gt 50 ]; then
        echo "✅ DOCUMENTATION INSTALLATION COMPLETE AND WORKING!"
        echo "   All documentation properly installed in .apm/documentation/"
    else
        echo "⚠️  Documentation may be incomplete (expected 50+ files, found $TOTAL_DOCS)"
    fi
else
    echo "❌ Documentation directory NOT created!"
    echo ""
    echo "Contents of .apm:"
    ls -la .apm/ | head -20
fi

# Cleanup message
cd ../..
echo ""
echo "Test directory: $TEST_DIR"
echo "To explore: cd $TEST_DIR/apm-v4.0.0/.apm/documentation"
echo "To cleanup: rm -rf $TEST_DIR"