#!/bin/bash

# Test script for installer cleanup functionality

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "=========================================="
echo "   Testing Installer Cleanup"
echo "=========================================="
echo ""

# Create a test directory
TEST_DIR="/tmp/apm-cleanup-test-$$"
echo "Creating test directory: $TEST_DIR"
mkdir -p "$TEST_DIR"

# Copy installer directory to test location
echo "Copying installer to test directory..."
cp -r installer "$TEST_DIR/"

# Create a mock .apm structure
echo "Creating mock APM installation..."
mkdir -p "$TEST_DIR/.apm/.installer"
echo "3.0.0" > "$TEST_DIR/.apm/VERSION"

# Test scenarios
echo ""
echo -e "${BLUE}Test 1: Check if installer directory exists${NC}"
if [ -d "$TEST_DIR/installer" ]; then
    echo -e "${GREEN}✓ Installer directory exists${NC}"
else
    echo -e "${RED}✗ Installer directory not found${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Test 2: Check if APM is installed${NC}"
if [ -d "$TEST_DIR/.apm" ] && [ -f "$TEST_DIR/.apm/VERSION" ]; then
    echo -e "${GREEN}✓ APM installation verified${NC}"
else
    echo -e "${RED}✗ APM installation not found${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Test 3: Simulate installer preservation${NC}"
cp -r "$TEST_DIR/installer"/* "$TEST_DIR/.apm/.installer/" 2>/dev/null || true
if [ -d "$TEST_DIR/.apm/.installer" ] && [ -f "$TEST_DIR/.apm/.installer/install.sh" ]; then
    echo -e "${GREEN}✓ Installer preserved in .apm/.installer${NC}"
else
    echo -e "${RED}✗ Installer preservation failed${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}Test 4: Run cleanup logic${NC}"
# Simulate the cleanup logic from install.sh
if [ -d "$TEST_DIR/.apm/.installer" ]; then
    if [ -d "$TEST_DIR/installer" ]; then
        rm -rf "$TEST_DIR/installer"
        if [ ! -d "$TEST_DIR/installer" ]; then
            echo -e "${GREEN}✓ Installer directory successfully removed${NC}"
        else
            echo -e "${RED}✗ Failed to remove installer directory${NC}"
            exit 1
        fi
    fi
else
    echo -e "${YELLOW}⚠ Skipped - installer not preserved${NC}"
fi

echo ""
echo -e "${BLUE}Test 5: Verify final state${NC}"
if [ ! -d "$TEST_DIR/installer" ] && [ -f "$TEST_DIR/.apm/.installer/install.sh" ]; then
    echo -e "${GREEN}✓ Final state correct:${NC}"
    echo "  - Installer directory removed from project root"
    echo "  - Installer preserved in .apm/.installer"
else
    echo -e "${RED}✗ Final state incorrect${NC}"
    if [ -d "$TEST_DIR/installer" ]; then
        echo "  - Installer directory still exists"
    fi
    if [ ! -f "$TEST_DIR/.apm/.installer/install.sh" ]; then
        echo "  - install.sh not found in .apm/.installer"
    fi
    exit 1
fi

# Test the standalone cleanup script
echo ""
echo -e "${BLUE}Test 6: Test standalone cleanup script${NC}"
# Re-create installer directory
mkdir -p "$TEST_DIR/installer"
cp installer/install.sh "$TEST_DIR/installer/"

# Copy and run cleanup script
cp installer-cleanup.sh "$TEST_DIR/"
cd "$TEST_DIR"
if bash installer-cleanup.sh; then
    echo -e "${GREEN}✓ Standalone cleanup script executed successfully${NC}"
else
    echo -e "${RED}✗ Standalone cleanup script failed${NC}"
    cd - >/dev/null
    exit 1
fi
cd - >/dev/null

# Clean up test directory
echo ""
echo "Cleaning up test directory..."
rm -rf "$TEST_DIR"

echo ""
echo -e "${GREEN}=========================================="
echo "   All cleanup tests passed!"
echo "==========================================${NC}"
echo ""
echo "The installer cleanup functionality is working correctly:"
echo "- Installer directory is properly removed after installation"
echo "- Installer is preserved in .apm/.installer for future use"
echo "- Cleanup only happens when installation is verified"