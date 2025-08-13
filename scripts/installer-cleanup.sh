#!/bin/bash

# Installer Cleanup Script
# This script removes the installer folder after installation

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "=========================================="
echo "   APM Installer Cleanup"
echo "=========================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if installer folder exists
if [ -d "$SCRIPT_DIR/installer" ]; then
    echo -e "${YELLOW}Found installer folder at: $SCRIPT_DIR/installer${NC}"
    
    # Check if APM is properly installed
    if [ -d "$SCRIPT_DIR/.apm" ] && [ -f "$SCRIPT_DIR/.apm/VERSION" ]; then
        echo -e "${GREEN}✓ APM installation verified${NC}"
        
        # Check if minimal installer files are preserved in .apm/.installer
        if [ -d "$SCRIPT_DIR/.apm/.installer" ]; then
            echo -e "${GREEN}✓ Essential update files preserved in .apm/.installer${NC}"
            
            # Remove the original installer folder
            echo ""
            echo "Removing installer folder..."
            rm -rf "$SCRIPT_DIR/installer"
            
            if [ ! -d "$SCRIPT_DIR/installer" ]; then
                echo -e "${GREEN}✓ Installer folder successfully removed${NC}"
                
                # Remove this cleanup script too
                echo "Removing cleanup script..."
                rm -f "$0"
                echo -e "${GREEN}✓ Cleanup complete!${NC}"
            else
                echo -e "${RED}✗ Failed to remove installer folder${NC}"
                exit 1
            fi
        else
            echo -e "${YELLOW}⚠ Essential update files not preserved in .apm/.installer${NC}"
            echo "The installer folder will not be removed for safety."
            exit 1
        fi
    else
        echo -e "${RED}✗ APM installation not found or incomplete${NC}"
        echo "The installer folder will not be removed."
        exit 1
    fi
else
    echo -e "${YELLOW}No installer folder found at: $SCRIPT_DIR/installer${NC}"
    echo "Nothing to clean up."
    
    # Remove this cleanup script anyway
    if [ -f "$0" ]; then
        rm -f "$0"
        echo -e "${GREEN}✓ Cleanup script removed${NC}"
    fi
fi

echo ""
echo "Done!"