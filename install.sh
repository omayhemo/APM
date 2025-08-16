#!/bin/bash
# Coherence Universal Installer - Unified Context Engineering
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

# Capture the user's current directory (where they ran the curl command)
USER_PROJECT_DIR="$(pwd)"

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}     Coherence Installer v2.0 - Unified Context Engineering${NC}"
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
DOWNLOAD_URL="https://github.com/$REPO/releases/download/$LATEST_VERSION/apm-${LATEST_VERSION}.tar.gz"

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
# Extract directly to temp directory (no version subfolder)
tar -xzf "$TEMP_DIR/apm.tar.gz" -C "$TEMP_DIR"

# The files are now directly in TEMP_DIR
EXTRACTED_DIR="$TEMP_DIR"

# Run the actual installer
echo -e "${BLUE}Running APM installer...${NC}"
echo ""

if [ -f "$EXTRACTED_DIR/payload/install.sh" ]; then
    cd "$EXTRACTED_DIR"
    # Pass the user's project directory as the first argument, followed by any other arguments
    # Only use /dev/tty if stdin is actually a terminal, not when piped through curl
    if [ -t 0 ]; then
        # stdin is a terminal, safe to use /dev/tty
        bash payload/install.sh "$USER_PROJECT_DIR" "$@" < /dev/tty 2>/dev/null || \
        bash payload/install.sh "$USER_PROJECT_DIR" "$@"
    else
        # stdin is piped (like curl | bash), don't try /dev/tty as it will hang
        bash payload/install.sh "$USER_PROJECT_DIR" "$@"
        INSTALLER_EXIT_CODE=$?
    fi
else
    echo -e "${RED}Error: Payload not found in package${NC}"
    exit 1
fi

# Wait for payload to fully complete and clear any buffered input
wait
sleep 0.1

# Check for any script validation issues
if [ -n "$INSTALLER_EXIT_CODE" ] && [ "$INSTALLER_EXIT_CODE" -ne 0 ]; then
    echo ""
    echo -e "${YELLOW}⚠️ Installation completed with warnings (exit code: $INSTALLER_EXIT_CODE)${NC}"
    echo "This may indicate script validation issues or minor errors."
    echo "The installation should still be functional."
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
