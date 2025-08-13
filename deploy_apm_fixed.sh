#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
APM_REPO="omayhemo/APM"
VERSION="4.0.0"
CURRENT_DIR=$(pwd)

echo -e "${BLUE}Deploying to APM repository...${NC}"

# Check if APM-REPO-FILES directory exists
if [ ! -d "APM-REPO-FILES" ]; then
    echo -e "${RED}Error: APM-REPO-FILES directory not found${NC}"
    exit 1
fi

# Create temporary directory for APM repo
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Clone APM repository
echo "Cloning APM repository..."
cd "$TEMP_DIR"
gh repo clone "$APM_REPO"
cd "APM"

# Copy distribution files to APM repository
echo "Copying distribution files..."
cp -f "$CURRENT_DIR/APM-REPO-FILES/"* .

# Copy distribution package
if [ -f "$CURRENT_DIR/dist/apm-v$VERSION.tar.gz" ]; then
    cp "$CURRENT_DIR/dist/apm-v$VERSION.tar.gz" .
    echo "  - Copied distribution package: apm-v$VERSION.tar.gz"
fi

# Add and commit changes
echo "Committing changes to APM repository..."
git add .
git config user.name "APM Release Bot" 2>/dev/null || true
git config user.email "noreply@apm-framework.com" 2>/dev/null || true
git commit -m "Release v$VERSION

- Version bumped to $VERSION
- Updated installer and documentation
- Added distribution package

🤖 Generated with APM Framework Release Process" || echo "No changes to commit"

# Create tag
git tag -a "v$VERSION" -m "Release version $VERSION

See release notes for details" || echo "Tag already exists"

# Push to APM repository
echo "Pushing to APM repository..."
git push origin main 2>/dev/null || git push origin master 2>/dev/null || echo "Push failed, trying alternative approach"
git push origin "v$VERSION" 2>/dev/null || echo "Tag push failed - tag may already exist"

# Return to original directory
cd "$CURRENT_DIR"

# Clean up temporary directory
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Successfully deployed to APM repository${NC}"
