#!/bin/bash

# Fix for broken ap-manager.sh after emergency fix
# Downloads the working v1.2.8 ap-manager.sh directly

set -e

echo "=========================================="
echo "FIXING BROKEN AP-MANAGER.SH"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Find ap-manager.sh
AP_MANAGER=""
if [ -f ".apm/agents/scripts/ap-manager.sh" ]; then
    AP_MANAGER=".apm/agents/scripts/ap-manager.sh"
elif [ -f "agents/scripts/ap-manager.sh" ]; then
    AP_MANAGER="agents/scripts/ap-manager.sh"
else
    echo -e "${RED}Error: Cannot find ap-manager.sh${NC}"
    exit 1
fi

echo -e "${BLUE}Found broken ap-manager.sh at: $AP_MANAGER${NC}"

# Check if there's a backup to restore
BACKUP_FILE=$(ls "$AP_MANAGER".emergency-backup-* 2>/dev/null | head -1 || echo "")
if [ -n "$BACKUP_FILE" ]; then
    echo -e "${BLUE}Found emergency backup: $BACKUP_FILE${NC}"
    echo -e "${BLUE}Restoring from backup...${NC}"
    cp "$BACKUP_FILE" "$AP_MANAGER"
fi

# Download the working v1.2.8 version directly
echo -e "${BLUE}Downloading working ap-manager.sh from v1.2.8...${NC}"
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

# Verify the downloaded file
if head -n 1 "$TEMP_FILE" | grep -q "#!/bin/bash"; then
    echo -e "${GREEN}Downloaded file verified as shell script${NC}"
else
    echo -e "${RED}Error: Downloaded file is not a valid shell script${NC}"
    cat "$TEMP_FILE" | head -5
    rm "$TEMP_FILE"
    exit 1
fi

# Test syntax before replacing
if bash -n "$TEMP_FILE"; then
    echo -e "${GREEN}Downloaded script has valid syntax${NC}"
else
    echo -e "${RED}Downloaded script has syntax errors${NC}"
    rm "$TEMP_FILE"
    exit 1
fi

# Replace the broken file
echo -e "${BLUE}Installing working ap-manager.sh...${NC}"
cp "$TEMP_FILE" "$AP_MANAGER"
chmod +x "$AP_MANAGER"
rm "$TEMP_FILE"

# Test the fixed file
echo -e "${BLUE}Testing fixed ap-manager.sh...${NC}"
if bash "$AP_MANAGER" version >/dev/null 2>&1; then
    echo -e "${GREEN}✓ ap-manager.sh is working!${NC}"
    
    echo ""
    echo -e "${GREEN}=========================================="
    echo "SCRIPT FIXED SUCCESSFULLY!"
    echo "==========================================${NC}"
    echo ""
    echo "You can now try updating again:"
    echo "  $AP_MANAGER update"
else
    echo -e "${RED}✗ ap-manager.sh still not working${NC}"
    exit 1
fi