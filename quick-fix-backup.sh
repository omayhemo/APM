#!/bin/bash

# Quick Fix for AP Mapping Backup Creation
# Patches the current ap-manager.sh with the backup fix

set -e

echo "=========================================="
echo "Quick Fix: AP Mapping Backup Creation"
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
    echo "Expected to find it at .apm/agents/scripts/ap-manager.sh or agents/scripts/ap-manager.sh"
    exit 1
fi

echo -e "${BLUE}Found ap-manager.sh at: $AP_MANAGER${NC}"

# Create backup of current ap-manager.sh
cp "$AP_MANAGER" "$AP_MANAGER.backup-$(date +%Y%m%d-%H%M%S)"
echo -e "${GREEN}Backed up current ap-manager.sh${NC}"

# Download the fixed version
echo -e "${BLUE}Downloading fixed ap-manager.sh...${NC}"
TEMP_FILE=$(mktemp)

if command -v curl >/dev/null 2>&1; then
    curl -L -o "$TEMP_FILE" "https://raw.githubusercontent.com/omayhemo/agentic-persona-mapping/master/agents/scripts/ap-manager.sh"
elif command -v wget >/dev/null 2>&1; then
    wget -O "$TEMP_FILE" "https://raw.githubusercontent.com/omayhemo/agentic-persona-mapping/master/agents/scripts/ap-manager.sh"
else
    echo -e "${RED}Error: Neither curl nor wget found${NC}"
    exit 1
fi

# Replace the current file
cp "$TEMP_FILE" "$AP_MANAGER"
rm "$TEMP_FILE"

echo -e "${GREEN}Fixed ap-manager.sh installed!${NC}"

# Test the fix
echo -e "${BLUE}Testing backup creation...${NC}"
cd "$(dirname "$(dirname "$AP_MANAGER")")"

# Create test backup
export AP_ROOT="$(pwd)"
export BACKUP_DIR="$AP_ROOT/.backups"

# Source the fixed script and test the backup function
if bash -c "
source '$AP_MANAGER'
create_backup 'test-fix-$(date +%H%M%S)'
" 2>/dev/null; then
    echo -e "${GREEN}✓ Backup creation is now working!${NC}"
    
    # Clean up test backup
    find "$BACKUP_DIR" -name "test-fix-*" -delete 2>/dev/null || true
else
    echo -e "${RED}✗ Backup creation still failing${NC}"
    echo "You may need to run the full manual update script"
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Quick fix completed!"
echo "==========================================${NC}"
echo ""
echo "The backup creation issue should now be resolved."
echo "You can test with: $AP_MANAGER update"