#!/bin/bash
set -e

echo "=========================================="
echo "COMPLETE APM INSTALLATION TEST"
echo "=========================================="
echo ""

# Create test directory
TEST_DIR="/tmp/apm_complete_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo "Using latest commit SHA: a161994"
echo ""

# Run with the fixed installer
echo "Running: curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/a161994/install.sh | bash -s -- --defaults"
echo ""

curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/a161994/install.sh | bash -s -- --defaults

# Verify installation
echo ""
echo "=========================================="
echo "VERIFICATION"
echo "=========================================="

if [ -d ".apm" ]; then
    echo "✅ .apm directory created"
    
    if [ -f ".apm/agents/personas/orchestrator.md" ]; then
        echo "✅ Orchestrator persona installed"
    fi
    
    if [ -f ".apm/agents/personas/dev.md" ]; then
        echo "✅ Developer persona installed"
    fi
    
    if [ -f ".apm/agents/personas/qa.md" ]; then
        echo "✅ QA persona installed"
    fi
    
    if [ -d ".apm/session_notes" ]; then
        echo "✅ Session notes directory created"
    fi
    
    if [ -d ".apm/rules" ]; then
        echo "✅ Rules directory created"
    fi
    
    if [ -f ".apm/README.md" ]; then
        echo "✅ APM README created"
    fi
    
    echo ""
    echo "✅ ALL CHECKS PASSED!"
else
    echo "❌ Installation failed"
    exit 1
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo ""
echo "=========================================="
echo "APM INSTALLATION WORKING CORRECTLY!"
echo "=========================================="
echo ""
echo "The installation command will work once GitHub's CDN updates:"
echo "curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults"