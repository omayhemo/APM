#!/bin/bash

# Recovery script for ap-manager.sh that got overwritten with 404 error
# This restores the working ap-manager.sh from the APM repository

set -e

echo "=========================================="
echo "AP Manager Recovery Script"
echo "=========================================="
echo ""
echo "This script fixes ap-manager.sh that was corrupted by the previous fix attempt."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Find the corrupted ap-manager.sh
AP_MANAGER=""
if [ -f ".apm/agents/scripts/ap-manager.sh" ]; then
    AP_MANAGER=".apm/agents/scripts/ap-manager.sh"
elif [ -f "agents/scripts/ap-manager.sh" ]; then
    AP_MANAGER="agents/scripts/ap-manager.sh"
else
    echo -e "${RED}Error: Cannot find ap-manager.sh${NC}"
    exit 1
fi

echo -e "${BLUE}Found corrupted ap-manager.sh at: $AP_MANAGER${NC}"

# Check if it's actually corrupted
if head -n 1 "$AP_MANAGER" | grep -q "404"; then
    echo -e "${RED}Confirmed: ap-manager.sh contains 404 error${NC}"
else
    echo -e "${GREEN}ap-manager.sh appears to be working already${NC}"
    echo "Testing..."
    if bash "$AP_MANAGER" version >/dev/null 2>&1; then
        echo -e "${GREEN}ap-manager.sh is working fine!${NC}"
        exit 0
    fi
fi

# Download the correct version
echo -e "${BLUE}Downloading working ap-manager.sh from APM repository...${NC}"
TEMP_FILE=$(mktemp)

if command -v curl >/dev/null 2>&1; then
    if curl -L -o "$TEMP_FILE" "https://raw.githubusercontent.com/omayhemo/APM/master/agents/scripts/ap-manager.sh"; then
        echo -e "${GREEN}Download successful${NC}"
    else
        echo -e "${RED}Download failed${NC}"
        exit 1
    fi
elif command -v wget >/dev/null 2>&1; then
    if wget -O "$TEMP_FILE" "https://raw.githubusercontent.com/omayhemo/APM/master/agents/scripts/ap-manager.sh"; then
        echo -e "${GREEN}Download successful${NC}"
    else
        echo -e "${RED}Download failed${NC}"
        exit 1
    fi
else
    echo -e "${RED}Error: Neither curl nor wget found${NC}"
    exit 1
fi

# Verify the downloaded file is actually a shell script
if head -n 1 "$TEMP_FILE" | grep -q "#!/bin/bash"; then
    echo -e "${GREEN}Downloaded file verified as shell script${NC}"
else
    echo -e "${RED}Error: Downloaded file is not a valid shell script${NC}"
    cat "$TEMP_FILE" | head -5
    rm "$TEMP_FILE"
    exit 1
fi

# Replace the corrupted file
echo -e "${BLUE}Restoring ap-manager.sh...${NC}"
cp "$TEMP_FILE" "$AP_MANAGER"
chmod +x "$AP_MANAGER"
rm "$TEMP_FILE"

# Test the restored file
echo -e "${BLUE}Testing restored ap-manager.sh...${NC}"
if bash "$AP_MANAGER" version >/dev/null 2>&1; then
    echo -e "${GREEN}✓ ap-manager.sh is working!${NC}"
    
    # Show version
    bash "$AP_MANAGER" version
    
    echo ""
    echo -e "${GREEN}=========================================="
    echo "Recovery completed successfully!"
    echo "==========================================${NC}"
    echo ""
    echo "You can now use: $AP_MANAGER update"
else
    echo -e "${RED}✗ ap-manager.sh still not working${NC}"
    echo "Manual intervention required"
    exit 1
fi