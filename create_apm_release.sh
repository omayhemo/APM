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

echo -e "${BLUE}Creating GitHub release on APM repository...${NC}"

# Create release notes for APM repository if RELEASE_NOTES.md doesn't exist
if [ ! -f "RELEASE_NOTES.md" ]; then
    echo -e "${YELLOW}RELEASE_NOTES.md not found, skipping release creation${NC}"
    exit 1
fi

# Check if release already exists
if gh release view "v$VERSION" --repo "$APM_REPO" >/dev/null 2>&1; then
    echo -e "${YELLOW}Release v$VERSION already exists. Deleting and recreating...${NC}"
    gh release delete "v$VERSION" --repo "$APM_REPO" --yes || echo "Could not delete existing release"
fi

# Create release on APM repository with distribution package
gh release create "v$VERSION" \
    dist/apm-v$VERSION.tar.gz \
    --repo "$APM_REPO" \
    --title "APM Framework v$VERSION" \
    --notes-file RELEASE_NOTES.md \
    --target master

echo -e "${GREEN}✓ GitHub release created: https://github.com/$APM_REPO/releases/tag/v$VERSION${NC}"
