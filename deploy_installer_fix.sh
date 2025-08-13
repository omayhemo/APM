#!/bin/bash
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Deploying installer fix to APM repository...${NC}"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Clone APM repository
gh repo clone omayhemo/APM
cd APM

# Copy fixed installer
cp "$OLDPWD/APM-REPO-FILES/install.sh" .

# Commit and push
git add install.sh
git config user.name "APM Release Bot"
git config user.email "noreply@apm-framework.com"
git commit -m "fix: Update installer to use APM repository for releases

- Changed REPO variable from omayhemo/agentic-persona-mapping to omayhemo/APM
- Installer now correctly fetches releases from APM distribution repository" || echo "No changes"

git push origin master

# Cleanup
cd "$OLDPWD"
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Installer fix deployed${NC}"
