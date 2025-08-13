#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=========================================="
echo "FULL APM INSTALLATION TEST"
echo "=========================================="
echo ""

# Create a test directory
TEST_DIR="/tmp/apm_test_$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "Test directory: $TEST_DIR"
echo ""

# Test 1: Download installer
echo "1. Downloading installer..."
if ! curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh -o install.sh; then
    echo -e "${RED}❌ Failed to download installer${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Installer downloaded${NC}"

# Test 2: Make installer executable
chmod +x install.sh

# Test 3: Run installer with defaults in test directory
echo ""
echo "2. Running installer with --defaults..."
export AP_ROOT="$TEST_DIR/.apm"
export AP_DOCS="$TEST_DIR/project_docs"

# Create a fake project to test in
mkdir -p "$TEST_DIR/project_docs"

# Run the installer and capture output
if ! bash install.sh --defaults 2>&1 | tee install_output.log; then
    echo -e "${RED}❌ Installation failed${NC}"
    echo ""
    echo "Last 50 lines of output:"
    tail -50 install_output.log
    echo ""
    echo "Checking what was created:"
    find "$TEST_DIR/.apm" -type d | head -20
    exit 1
fi

echo ""
echo "3. Verifying installation..."

# Check if .apm directory was created
if [ ! -d "$TEST_DIR/.apm" ]; then
    echo -e "${RED}❌ .apm directory not created${NC}"
    exit 1
fi
echo -e "${GREEN}✅ .apm directory created${NC}"

# Check for key directories
REQUIRED_DIRS=(
    ".apm/agents"
    ".apm/session_notes"
    ".apm/rules"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$TEST_DIR/$dir" ]; then
        echo -e "${RED}❌ Missing directory: $dir${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Found: $dir${NC}"
done

# Check for key files
KEY_FILES=(
    ".apm/agents/personas/orchestrator.md"
    ".apm/agents/personas/dev.md"
    ".apm/agents/personas/qa.md"
)

for file in "${KEY_FILES[@]}"; do
    if [ ! -f "$TEST_DIR/$file" ]; then
        echo -e "${RED}❌ Missing file: $file${NC}"
        # List what's actually there
        echo "Contents of $(dirname "$TEST_DIR/$file"):"
        ls -la "$(dirname "$TEST_DIR/$file")" 2>/dev/null || echo "Directory doesn't exist"
    else
        echo -e "${GREEN}✅ Found: $file${NC}"
    fi
done

# Cleanup
cd /
rm -rf "$TEST_DIR"

echo ""
echo -e "${GREEN}=========================================="
echo "TEST COMPLETE"
echo "==========================================${NC}"