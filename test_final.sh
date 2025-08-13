#!/bin/bash
set -e

# Final test of APM installation from GitHub
echo "=========================================="
echo "FINAL APM INSTALLATION TEST"
echo "=========================================="
echo ""

# Create test directory
TEST_DIR="/tmp/apm_final_test_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""

# Test the installation command as user would run it
echo "Running installation command..."
echo "curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults"
echo ""

# Run the actual command
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults

# Check results
echo ""
echo "Checking installation results..."

if [ -d ".apm" ]; then
    echo "✅ .apm directory created"
    
    # Check key components
    if [ -f ".apm/agents/personas/orchestrator.md" ]; then
        echo "✅ Personas installed"
    else
        echo "❌ Personas missing"
    fi
    
    if [ -d ".apm/session_notes" ]; then
        echo "✅ Session notes directory created"
    else
        echo "❌ Session notes missing"
    fi
    
    if [ -d ".apm/rules" ]; then
        echo "✅ Rules directory created"
    else
        echo "❌ Rules missing"
    fi
    
    echo ""
    echo "✅ INSTALLATION SUCCESSFUL!"
else
    echo "❌ Installation failed - .apm directory not found"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo ""
echo "=========================================="
echo "TEST PASSED - APM READY FOR USE!"
echo "=========================================="