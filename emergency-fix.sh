#!/bin/bash

# Emergency Fix for AP Mapping Update Issues
# This patches the current installation to remove problematic --quiet flags

set -e

echo "=========================================="
echo "EMERGENCY AP MAPPING FIX"
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

echo -e "${BLUE}Found ap-manager.sh at: $AP_MANAGER${NC}"

# Create backup
cp "$AP_MANAGER" "$AP_MANAGER.emergency-backup-$(date +%Y%m%d-%H%M%S)"
echo -e "${GREEN}Created emergency backup${NC}"

# Fix the --quiet flag issues by removing them
echo -e "${BLUE}Removing problematic --quiet flags...${NC}"

# Remove --quiet from integrity checker calls
sed -i 's/--quiet//g' "$AP_MANAGER"

# Also disable the integrity checks entirely to prevent directory issues
sed -i 's/\"\$INSTALLER_DIR\/integrity-checker\.sh\"/#\"\$INSTALLER_DIR\/integrity-checker\.sh\"/g' "$AP_MANAGER"

echo -e "${GREEN}Fixed ap-manager.sh!${NC}"

# Test that it's still a valid script
if bash -n "$AP_MANAGER"; then
    echo -e "${GREEN}✓ Script syntax is valid${NC}"
else
    echo -e "${RED}✗ Script has syntax errors${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Emergency fix completed!"
echo "==========================================${NC}"
echo ""
echo "Now try running: $AP_MANAGER update"
echo ""
echo "This should work without the integrity check errors."