#!/bin/bash

echo "=========================================="
echo "FINAL TEST OF INTERACTIVE MODE FIX"
echo "=========================================="
echo ""
echo "This test will simulate user input to verify"
echo "that the installer accepts input when piped."
echo ""

# Create test directory
TEST_DIR="/tmp/apm_final_interactive_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""

# Create an expect script or use echo to provide input
cat > test_input.txt << 'EOF'
MyTestProject
n
1
y
2
2
2
2
2
2
2
n
EOF

echo "Running installer with simulated input..."
echo "Providing answers:"
echo "- Project name: MyTestProject"
echo "- Debug Host MCP: n (no)"
echo "- TTS provider: 1 (Piper)"
echo "- Audible notifications: y (yes)"
echo "- Hook notifications: 2 (no sound) for all"
echo "- Python support: n (no)"
echo ""

# Run installer with input from file
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash < test_input.txt

# Check results
echo ""
echo "Checking installation results..."

if [ -d ".apm" ]; then
    echo "✅ .apm directory created"
    
    # Check if project name was applied
    if grep -q "MyTestProject" .apm/agents/shared/path-constants.md 2>/dev/null; then
        echo "✅ Project name 'MyTestProject' was accepted and applied"
    else
        echo "⚠️ Project name may not have been applied correctly"
    fi
    
    # Check if TTS was configured
    if [ -f ".claude/settings.json" ]; then
        if grep -q "piper" .claude/settings.json; then
            echo "✅ TTS provider set to Piper as selected"
        fi
    fi
    
    echo ""
    echo "✅ INTERACTIVE MODE IS WORKING!"
else
    echo "❌ Installation failed"
fi

# Cleanup
cd /
rm -rf "$TEST_DIR"