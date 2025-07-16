#!/bin/bash

# Manual Update Script for AP Mapping v1.2.7
# This script fixes clients with broken ap-manager.sh update mechanism

set -e

echo "=========================================="
echo "Manual AP Mapping Update to v1.2.7"
echo "=========================================="
echo ""
echo "This script fixes the broken update mechanism by manually downloading"
echo "and installing v1.2.7 which contains the backup creation fix."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
VERSION="1.2.7"
REPO_OWNER="omayhemo"
REPO_NAME="agentic-persona-mapping"
DOWNLOAD_URL="https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/v$VERSION/apm-v$VERSION.tar.gz"

# Detect current installation
if [ -d ".apm/agents" ]; then
    AP_ROOT=".apm/agents"
    INSTALLER_DIR=".apm/installer"
elif [ -d "agents" ]; then
    AP_ROOT="agents"
    INSTALLER_DIR="installer"
else
    echo -e "${RED}Error: Cannot find AP Mapping installation${NC}"
    echo "This script must be run from your project root directory"
    echo "Expected to find either '.apm/agents' or 'agents' directory"
    exit 1
fi

echo -e "${BLUE}Found AP installation at: $AP_ROOT${NC}"

# Create backup manually (with our own error handling)
echo -e "${BLUE}Creating backup...${NC}"
BACKUP_DIR="$AP_ROOT/.backups"
mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/manual-pre-update-$VERSION-$(date +%Y%m%d-%H%M%S).tar.gz"

echo "Creating backup: $BACKUP_FILE"
if tar -czf "$BACKUP_FILE" -C "$(dirname "$AP_ROOT")" "$(basename "$AP_ROOT")" 2>/dev/null; then
    echo -e "${GREEN}Backup created successfully${NC}"
else
    echo -e "${YELLOW}Warning: tar backup failed, creating directory backup...${NC}"
    BACKUP_DIR_FALLBACK="$BACKUP_DIR/manual-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR_FALLBACK"
    if cp -r "$AP_ROOT" "$BACKUP_DIR_FALLBACK/"; then
        echo -e "${GREEN}Directory backup created at: $BACKUP_DIR_FALLBACK${NC}"
    else
        echo -e "${RED}Error: Could not create backup. Aborting update.${NC}"
        exit 1
    fi
fi

# Download new version
echo -e "${BLUE}Downloading AP Mapping v$VERSION...${NC}"
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

if command -v curl >/dev/null 2>&1; then
    curl -L -o "apm-v$VERSION.tar.gz" "$DOWNLOAD_URL"
elif command -v wget >/dev/null 2>&1; then
    wget -O "apm-v$VERSION.tar.gz" "$DOWNLOAD_URL"
else
    echo -e "${RED}Error: Neither curl nor wget found${NC}"
    echo "Please install curl or wget to download the update"
    exit 1
fi

# Extract new version
echo -e "${BLUE}Extracting update...${NC}"
if ! tar -xzf "apm-v$VERSION.tar.gz"; then
    echo -e "${RED}Error: Failed to extract update package${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Go back to project directory
cd - > /dev/null

# Update installer files
echo -e "${BLUE}Updating installer files...${NC}"
if [ -d "$INSTALLER_DIR" ]; then
    rm -rf "$INSTALLER_DIR.old"
    mv "$INSTALLER_DIR" "$INSTALLER_DIR.old"
fi
mkdir -p "$INSTALLER_DIR"

if [ -d "$TEMP_DIR/apm-v$VERSION/installer" ]; then
    cp -r "$TEMP_DIR/apm-v$VERSION/installer/"* "$INSTALLER_DIR/"
elif [ -d "$TEMP_DIR/installer" ]; then
    cp -r "$TEMP_DIR/installer/"* "$INSTALLER_DIR/"
fi

# Update agents directory
echo -e "${BLUE}Updating agents directory...${NC}"
if [ -d "$TEMP_DIR/apm-v$VERSION/.apm/agents" ]; then
    cp -r "$TEMP_DIR/apm-v$VERSION/.apm/agents/"* "$AP_ROOT/"
elif [ -d "$TEMP_DIR/.apm/agents" ]; then
    cp -r "$TEMP_DIR/.apm/agents/"* "$AP_ROOT/"
fi

# Update version file
echo "$VERSION" > "$AP_ROOT/version.txt"

# Clean up
rm -rf "$TEMP_DIR"

echo -e "${GREEN}Update completed successfully!${NC}"
echo "New version: $VERSION"
echo ""
echo -e "${BLUE}Verifying update...${NC}"

# Test the fixed ap-manager.sh
if [ -f "$AP_ROOT/scripts/ap-manager.sh" ]; then
    echo "Testing ap-manager.sh functionality..."
    if bash "$AP_ROOT/scripts/ap-manager.sh" version 2>/dev/null | grep -q "AP Mapping Manager"; then
        echo -e "${GREEN}✓ ap-manager.sh is working${NC}"
    else
        echo -e "${YELLOW}⚠ ap-manager.sh may need additional setup${NC}"
    fi
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Manual update to v1.2.7 completed!"
echo "==========================================${NC}"
echo ""
echo "The backup creation fix is now installed."
echo "Future updates should work with: bash $AP_ROOT/scripts/ap-manager.sh update"
echo ""
echo "Backup location: $BACKUP_FILE"