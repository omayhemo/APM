#!/bin/bash
set -e

echo "=========================================="
echo "TESTING DOCUMENTATION INSTALLATION FIX"
echo "=========================================="
echo ""

# Create test directory
TEST_DIR="/tmp/apm_doc_test_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""

# Extract and run installer locally
echo "Extracting distribution..."
tar -xzf /mnt/c/Code/agentic-persona-mapping/dist/apm-v4.0.0.tar.gz
cd apm-v4.0.0

echo "Running installer with defaults..."
bash installer/install.sh --defaults

echo ""
echo "=========================================="
echo "CHECKING DOCUMENTATION INSTALLATION"
echo "=========================================="
echo ""

# Check if documentation was installed
if [ -d ".apm/documentation" ]; then
    echo "✅ Documentation directory created at .apm/documentation"
    
    # Count documentation files
    DOC_COUNT=$(find .apm/documentation -type f | wc -l)
    echo "📚 Found $DOC_COUNT documentation files"
    
    # Check for key documentation directories
    echo ""
    echo "Documentation structure:"
    for dir in .apm/documentation/*/; do
        if [ -d "$dir" ]; then
            dirname=$(basename "$dir")
            filecount=$(find "$dir" -type f | wc -l)
            echo "  ✅ $dirname/ ($filecount files)"
        fi
    done
    
    # Check for specific important files
    echo ""
    echo "Key documentation files:"
    if [ -f ".apm/documentation/01-getting-started/README.md" ]; then
        echo "  ✅ Getting Started README found"
    else
        echo "  ❌ Getting Started README missing"
    fi
    
    if [ -f ".apm/documentation/command-reference/APM-COMMANDS-QUICK-REFERENCE.md" ]; then
        echo "  ✅ Command Quick Reference found"
    else
        echo "  ❌ Command Quick Reference missing"
    fi
    
    if [ -f ".apm/documentation/02-personas/orchestrator-guide.md" ]; then
        echo "  ✅ Orchestrator Guide found (processed from template)"
    else
        echo "  ❌ Orchestrator Guide missing"
    fi
    
    # Check main README
    if [ -f ".apm/README.md" ]; then
        echo "  ✅ Main APM README found"
    else
        echo "  ❌ Main APM README missing"
    fi
    
    echo ""
    echo "✅ DOCUMENTATION INSTALLATION WORKING!"
else
    echo "❌ Documentation directory NOT created"
    echo ""
    echo "Checking what was created in .apm:"
    ls -la .apm/ | head -20
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo ""
echo "Test complete!"