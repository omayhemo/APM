#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
APM_REPO="omayhemo/APM"
VERSION="4.0.0"

echo -e "${BLUE}Updating GitHub release with corrected distribution package...${NC}"

# Delete the old release
echo "Deleting existing release..."
gh release delete "v$VERSION" --repo "$APM_REPO" --yes || echo "No existing release to delete"

# Create new release with corrected package
echo "Creating new release with fixed distribution..."
gh release create "v$VERSION" \
    dist/apm-v$VERSION.tar.gz \
    --repo "$APM_REPO" \
    --title "APM Framework v$VERSION" \
    --notes "APM Framework v4.0.0 - Complete Native Sub-Agent Architecture

## Installation

\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults
\`\`\`

## Features
- 4-8x performance improvements
- Complete modernization with zero CLI crashes
- 25,000+ lines of code cleanup
- Enhanced documentation system" \
    --target master

echo -e "${GREEN}✓ Release updated successfully${NC}"
