#!/bin/bash
# APM Framework Universal Installer
# Downloads and installs the latest APM release

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
REPO="omayhemo/APM"
INSTALL_DIR="${APM_INSTALL_DIR:-$HOME/.apm-framework}"

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}     APM Framework Installer v2.0${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Check for required tools
for tool in curl tar; do
    if ! command -v $tool &> /dev/null; then
        echo -e "${RED}Error: $tool is required but not installed${NC}"
        exit 1
    fi
done

# Get latest release version
echo -e "${BLUE}Fetching latest version...${NC}"
LATEST_VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo -e "${RED}Error: Could not determine latest version${NC}"
    echo "Please check https://github.com/$REPO/releases"
    exit 1
fi

echo -e "${GREEN}✓ Installing version: $LATEST_VERSION${NC}"

# Download URL
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/apm-${LATEST_VERSION#v}.tar.gz"

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Download release
echo -e "${BLUE}Downloading APM $LATEST_VERSION...${NC}"
if ! curl -L -o "$TEMP_DIR/apm.tar.gz" "$DOWNLOAD_URL"; then
    echo -e "${RED}Error: Failed to download release${NC}"
    exit 1
fi

# Extract
echo -e "${BLUE}Extracting files...${NC}"
tar -xzf "$TEMP_DIR/apm.tar.gz" -C "$TEMP_DIR"

# Find the extracted directory (handles version in directory name)
EXTRACTED_DIR=$(find "$TEMP_DIR" -maxdepth 1 -type d -name "apm-*" | head -1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo -e "${RED}Error: Could not find extracted directory${NC}"
    exit 1
fi

# Run the actual installer
echo -e "${BLUE}Running APM installer...${NC}"
echo ""

if [ -f "$EXTRACTED_DIR/installer/install.sh" ]; then
    cd "$EXTRACTED_DIR"
    # Pass through any arguments (like --defaults)
    bash installer/install.sh "$@"
else
    echo -e "${RED}Error: Installer not found in package${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}     APM Installation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}Get started with:${NC}"
echo -e "  ${GREEN}/ap${NC}         - Launch the orchestrator"
echo -e "  ${GREEN}/analyst${NC}    - Start with research"
echo -e "  ${GREEN}/dev${NC}        - Jump into coding"
echo ""
echo -e "${BLUE}Documentation:${NC} .apm/README.md"
echo -e "${BLUE}Version:${NC} $LATEST_VERSION"