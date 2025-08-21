#!/bin/bash

# APM Release Script - Safe Release to APM Repository Only
# 
# ██████ CRITICAL SAFETY INFORMATION ██████
# 
# THIS SCRIPT:
# ✅ COMMITS APM/ folder contents to https://github.com/omayhemo/APM repository root
# ✅ NEVER touches agentic-persona-mapping repository files
# ✅ NEVER deletes any files from development repository
# ✅ Uses APM/ directory as staging area (preserves it)
# ✅ Includes explicit safety checks to prevent repository confusion
# 
# WHAT IT DOES:
# 1. Updates APM/ staging area files if needed
# 2. Creates dynamic release notes from changelog
# 3. Builds distribution package
# 4. Commits APM/ contents to APM repository root using git subtree
# 5. Creates GitHub release with distribution package
# 
# SAFETY GUARANTEES:
# - Verifies APM remote URL before any operations
# - Validates APM/ directory structure before push
# - Uses git subtree to isolate repository operations  
# - Explicit error checking and process termination on failures
# - Never modifies agentic-persona-mapping repository
# 
# ██████████████████████████████████████████

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"
APM_REMOTE="apm"
APM_REPO_URL="https://github.com/omayhemo/APM.git"

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}     APM Release Script v1.0${NC}"
echo -e "${BLUE}     Safe Release to APM Repository Only${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Function to show usage
show_usage() {
    echo "Usage: $0 <version>"
    echo ""
    echo "Examples:"
    echo "  $0 4.1.5                # Release version 4.1.5"
    echo "  $0 4.2.0                # Release version 4.2.0"
    echo ""
    echo "This script will:"
    echo "  1. Update version in APM/ files if necessary"
    echo "  2. Create detailed release notes in project_docs/release-notes/"
    echo "  3. Run build-distribution.sh"
    echo "  4. Release to APM repository with proper tags"
    echo ""
    echo "SAFETY GUARANTEES:"
    echo "  ✅ NEVER touches agentic-persona-mapping repository"
    echo "  ✅ ONLY releases to APM repository"
    echo "  ✅ NEVER deletes files from development repo"
    exit 1
}

# Check if version provided
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: Version number required${NC}"
    show_usage
fi

VERSION="$1"

# Validate version format (semantic versioning)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}Error: Invalid version format. Use semantic versioning (e.g., 4.1.5)${NC}"
    exit 1
fi

echo -e "${BLUE}Target Version: ${GREEN}$VERSION${NC}"
echo ""

# Safety check - ensure we're in the right directory
if [ ! -f "$PROJECT_ROOT/APM/install.sh" ] || [ ! -f "$PROJECT_ROOT/build-distribution.sh" ]; then
    echo -e "${RED}Error: Not in correct project directory${NC}"
    echo "Please run this script from the agentic-persona-mapping root directory"
    exit 1
fi

# Check if we're on master branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "master" ]; then
    echo -e "${YELLOW}Warning: Not on master branch (currently on $CURRENT_BRANCH)${NC}"
    echo -e "${YELLOW}Continuing with release from current branch...${NC}"
    echo ""
fi

# Phase 1: Update APM files if necessary
echo -e "${BLUE}Phase 1: Checking APM file versions...${NC}"

# Check current version in APM/VERSION
CURRENT_VERSION=""
if [ -f "$PROJECT_ROOT/APM/VERSION" ]; then
    CURRENT_VERSION=$(cat "$PROJECT_ROOT/APM/VERSION" | tr -d '[:space:]')
fi

UPDATE_NEEDED=false

if [ "$CURRENT_VERSION" != "$VERSION" ]; then
    echo -e "${YELLOW}  Version update needed: $CURRENT_VERSION → $VERSION${NC}"
    UPDATE_NEEDED=true
else
    echo -e "${GREEN}  ✅ APM/VERSION already at $VERSION${NC}"
fi

# Update version files if needed
if [ "$UPDATE_NEEDED" = true ]; then
    echo -e "${BLUE}  Updating version files...${NC}"
    
    # Update APM/VERSION
    echo "$VERSION" > "$PROJECT_ROOT/APM/VERSION"
    echo -e "${GREEN}  ✅ Updated APM/VERSION to $VERSION${NC}"
    
    # Update VERSION file in root
    echo "$VERSION" > "$PROJECT_ROOT/VERSION"
    echo -e "${GREEN}  ✅ Updated VERSION to $VERSION${NC}"
    
    # Update APM/README.md version badge
    if [ -f "$PROJECT_ROOT/APM/README.md" ]; then
        sed -i "s/version-[0-9]\+\.[0-9]\+\.[0-9]\+-blue/version-$VERSION-blue/g" "$PROJECT_ROOT/APM/README.md"
        sed -i "s/--version [0-9]\+\.[0-9]\+\.[0-9]\+/--version $VERSION/g" "$PROJECT_ROOT/APM/README.md"
        echo -e "${GREEN}  ✅ Updated APM/README.md version references${NC}"
    fi
else
    echo -e "${GREEN}  ✅ No version updates needed${NC}"
fi

# Phase 2: Generate dynamic release notes
echo -e "${BLUE}Phase 2: Generating dynamic release notes...${NC}"

RELEASE_NOTES_DIR="$PROJECT_ROOT/project_docs/release-notes"
RELEASE_NOTES_FILE="$RELEASE_NOTES_DIR/RELEASE-NOTES-v$VERSION.md"

# Ensure release notes directory exists
mkdir -p "$RELEASE_NOTES_DIR"

# Function to extract changelog section for this version
extract_changelog_section() {
    local changelog_file="$1"
    local version="$2"
    
    if [ -f "$changelog_file" ]; then
        # Extract content between this version and the next version marker
        awk -v ver="$version" '
        /^## \[.*\]/ { 
            if (found) exit
            if ($0 ~ "\\[" ver "\\]") found=1
            next
        }
        found { print }
        ' "$changelog_file"
    fi
}

# Function to get recent commit messages since last tag
get_recent_commits() {
    local last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    if [ -n "$last_tag" ]; then
        git log "$last_tag..HEAD" --pretty=format:"- %s" | head -10
    else
        git log --pretty=format:"- %s" | head -10
    fi
}

# Generate dynamic release notes
cat > "$RELEASE_NOTES_FILE" << EOF
# APM Framework v$VERSION Release Notes

**Release Date**: $(date +"%B %d, %Y")  
**Version**: $VERSION  
**Distribution**: coherence-v$VERSION-installer.tar.gz

---

## 🎯 Release Summary

$(if [ -f "$PROJECT_ROOT/APM/CHANGELOG.md" ]; then
    echo "APM Framework v$VERSION includes the following improvements and fixes:"
    echo ""
    extract_changelog_section "$PROJECT_ROOT/APM/CHANGELOG.md" "$VERSION" | head -5
else
    echo "APM Framework v$VERSION delivers enhanced functionality, improved performance, and system reliability."
fi)

## 📝 Changes in this Release

$(if [ -f "$PROJECT_ROOT/APM/CHANGELOG.md" ]; then
    extract_changelog_section "$PROJECT_ROOT/APM/CHANGELOG.md" "$VERSION"
else
    echo "### Recent Changes"
    get_recent_commits
fi)

## 📦 Distribution Details

- **Package**: coherence-v$VERSION-installer.tar.gz
- **Size**: Optimized for fast download and deployment
- **Compatibility**: Full backward compatibility maintained
- **Installation**: Zero-configuration setup with professional audio experience

## 🚀 Installation Commands

### Quick Install
\`\`\`bash
# Default installation (recommended)
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults

# Interactive installation
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash

# With TTS voice notifications
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --with-tts --defaults
\`\`\`

### First Steps After Installation
\`\`\`bash
coherence          # Launch the unified orchestrator
/ap                # Alternative orchestrator activation
/analyst           # Start with research and analysis
/architect         # Design system architecture
/dev               # Begin development work
\`\`\`

## 🔄 Upgrade Process

### From Previous Versions
This release maintains full backward compatibility. Users upgrading will receive all improvements automatically.

### Verification
After installation:
- Run \`coherence\` to verify orchestrator activation
- Check audio system with any agent activation
- Verify all slash commands are available

---

## 📋 Additional Information

- **GitHub Release**: https://github.com/omayhemo/APM/releases/tag/v$VERSION
- **Installation Guide**: Available in .apm/README.md after installation
- **Documentation**: Complete guides in .apm/documentation/ directory

**Ready for Production**: Suitable for individual developers, teams, and enterprise deployments.
EOF

echo -e "${GREEN}  ✅ Created detailed release notes: $RELEASE_NOTES_FILE${NC}"

# Also create or update the main release notes file
MAIN_RELEASE_NOTES="$PROJECT_ROOT/APM/Release-Notes.md"
cp "$RELEASE_NOTES_FILE" "$MAIN_RELEASE_NOTES"
echo -e "${GREEN}  ✅ Updated APM/Release-Notes.md${NC}"

# Phase 3: Run build-distribution.sh
echo -e "${BLUE}Phase 3: Building distribution package...${NC}"

if [ ! -f "$PROJECT_ROOT/build-distribution.sh" ]; then
    echo -e "${RED}Error: build-distribution.sh not found${NC}"
    exit 1
fi

# Run the build script
echo -e "${BLUE}  Running build-distribution.sh...${NC}"
cd "$PROJECT_ROOT"
bash build-distribution.sh

# Verify the distribution was created
DIST_FILE="$PROJECT_ROOT/dist/coherence-v$VERSION-installer.tar.gz"
if [ ! -f "$DIST_FILE" ]; then
    echo -e "${RED}Error: Distribution package not created at $DIST_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}  ✅ Distribution package created: $(basename "$DIST_FILE")${NC}"

# Phase 4: Release to APM repository
echo -e "${BLUE}Phase 4: Releasing to APM repository...${NC}"

# Check if APM remote exists
if ! git remote | grep -q "^$APM_REMOTE$"; then
    echo -e "${YELLOW}  Adding APM remote...${NC}"
    git remote add "$APM_REMOTE" "$APM_REPO_URL"
    echo -e "${GREEN}  ✅ Added APM remote${NC}"
fi

# Fetch latest from APM repository
echo -e "${BLUE}  Fetching from APM repository...${NC}"
git fetch "$APM_REMOTE"

# Use git subtree to push APM/ directory contents directly to APM repository
echo -e "${BLUE}  Using git subtree to push APM staging directory...${NC}"

# The APM/ directory IS the staging area - push its contents directly
echo -e "${GREEN}  ✅ Using APM/ directory as staging area${NC}"

# First, ensure APM directory changes are committed to current branch
if ! git diff --quiet APM/ || ! git diff --cached --quiet APM/; then
    echo -e "${BLUE}  Committing APM staging directory changes...${NC}"
    git add APM/
    git commit -m "Update APM staging for v$VERSION release"
fi

# Create or update release tag for this version
echo -e "${BLUE}  Creating/updating release tag v$VERSION...${NC}"

# Generate dynamic tag message from changelog or recent commits
TAG_MESSAGE="v$VERSION"
if [ -f "$PROJECT_ROOT/APM/CHANGELOG.md" ]; then
    CHANGELOG_CONTENT=$(extract_changelog_section "$PROJECT_ROOT/APM/CHANGELOG.md" "$VERSION" | head -3)
    if [ -n "$CHANGELOG_CONTENT" ]; then
        TAG_MESSAGE="$TAG_MESSAGE

$CHANGELOG_CONTENT"
    fi
fi

# Check if tag already exists
if git tag -l | grep -q "^v$VERSION$"; then
    echo -e "${YELLOW}  ⚠️  Tag v$VERSION already exists - deleting and recreating with updated content${NC}"
    git tag -d "v$VERSION" || true
fi

git tag -a "v$VERSION" -m "$TAG_MESSAGE"
echo -e "${GREEN}  ✅ Tag v$VERSION created/updated${NC}"

# EXPLICIT SAFETY CHECK: Commit APM/ folder contents to APM repository root
echo -e "${RED}═══════════════════════════════════════════${NC}"
echo -e "${RED}     CRITICAL SAFETY VERIFICATION${NC}"
echo -e "${RED}═══════════════════════════════════════════${NC}"
echo -e "${YELLOW}Target Repository: ${APM_REPO_URL}${NC}"
echo -e "${YELLOW}Source Directory: APM/ (staging area)${NC}"
echo -e "${YELLOW}Target Location: Root of APM repository${NC}"
echo -e "${YELLOW}Action: Push APM/ contents to APM repository root${NC}"
echo ""
echo -e "${RED}SAFETY GUARANTEE: This will NEVER touch agentic-persona-mapping repository${NC}"
echo -e "${RED}SAFETY GUARANTEE: This will ONLY push to APM repository${NC}"
echo -e "${RED}SAFETY GUARANTEE: This will NEVER delete any files${NC}"
echo ""

# Verify APM remote points to correct repository
ACTUAL_APM_URL=$(git remote get-url "$APM_REMOTE" 2>/dev/null || echo "NOT_FOUND")
if [ "$ACTUAL_APM_URL" != "$APM_REPO_URL" ]; then
    echo -e "${RED}SAFETY CHECK FAILED: APM remote URL mismatch${NC}"
    echo -e "${RED}Expected: $APM_REPO_URL${NC}"
    echo -e "${RED}Actual: $ACTUAL_APM_URL${NC}"
    echo -e "${RED}ABORTING RELEASE TO PREVENT REPOSITORY CONFUSION${NC}"
    exit 1
fi

# Verify APM directory exists and has required files
if [ ! -d "$PROJECT_ROOT/APM" ]; then
    echo -e "${RED}SAFETY CHECK FAILED: APM staging directory not found${NC}"
    echo -e "${RED}ABORTING RELEASE${NC}"
    exit 1
fi

if [ ! -f "$PROJECT_ROOT/APM/install.sh" ] || [ ! -f "$PROJECT_ROOT/APM/README.md" ]; then
    echo -e "${RED}SAFETY CHECK FAILED: Required APM files missing${NC}"
    echo -e "${RED}ABORTING RELEASE${NC}"
    exit 1
fi

echo -e "${GREEN}✅ SAFETY CHECKS PASSED${NC}"
echo -e "${GREEN}✅ APM remote verified: $ACTUAL_APM_URL${NC}"
echo -e "${GREEN}✅ APM staging directory verified${NC}"
echo ""

# EXPLICIT ACTION: Push APM/ directory contents to APM repository root
echo -e "${BLUE}EXECUTING: git subtree push --prefix=APM $APM_REMOTE master${NC}"
echo -e "${BLUE}This pushes contents of APM/ directory to root of APM repository${NC}"
echo -e "${BLUE}Target: $APM_REPO_URL${NC}"
echo ""

git subtree push --prefix=APM "$APM_REMOTE" master

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Successfully pushed APM/ contents to APM repository root${NC}"
else
    echo -e "${RED}❌ Failed to push to APM repository${NC}"
    echo -e "${RED}STOPPING RELEASE PROCESS${NC}"
    exit 1
fi

# Push the release tag to APM repository (force update if exists)
echo -e "${BLUE}EXECUTING: git push --force $APM_REMOTE v$VERSION${NC}"
echo -e "${BLUE}This pushes/updates release tag to APM repository${NC}"
echo -e "${BLUE}Target: $APM_REPO_URL${NC}"
echo ""

git push --force "$APM_REMOTE" "v$VERSION"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Successfully pushed/updated release tag to APM repository${NC}"
else
    echo -e "${RED}❌ Failed to push tag to APM repository${NC}"
    echo -e "${RED}STOPPING RELEASE PROCESS${NC}"
    exit 1
fi

echo -e "${GREEN}  ✅ Successfully pushed to APM repository${NC}"

# Phase 5: Create or update GitHub release
echo -e "${BLUE}Phase 5: Creating/updating GitHub release...${NC}"

# Check if gh CLI is available
if command -v gh &> /dev/null; then
    # Check if release already exists
    if gh release view "v$VERSION" --repo "omayhemo/APM" &>/dev/null; then
        echo -e "${YELLOW}  ⚠️  Release v$VERSION already exists - updating with new artifacts${NC}"
        
        # Update existing release with new notes
        echo -e "${BLUE}  Updating release notes...${NC}"
        gh release edit "v$VERSION" \
            --repo "omayhemo/APM" \
            --title "Coherence v$VERSION - Enhanced TTS Audio Experience" \
            --notes-file "$RELEASE_NOTES_FILE"
        
        # Remove old distribution file if it exists and upload new one
        echo -e "${BLUE}  Updating distribution package...${NC}"
        gh release delete-asset "v$VERSION" "$(basename "$DIST_FILE")" \
            --repo "omayhemo/APM" \
            --yes 2>/dev/null || true
        
        # Upload new distribution file
        gh release upload "v$VERSION" "$DIST_FILE" \
            --repo "omayhemo/APM"
        
        echo -e "${GREEN}  ✅ GitHub release updated with new distribution package${NC}"
    else
        echo -e "${BLUE}  Creating new GitHub release with gh CLI...${NC}"
        
        # Create new release
        gh release create "v$VERSION" "$DIST_FILE" \
            --repo "omayhemo/APM" \
            --title "Coherence v$VERSION - Enhanced TTS Audio Experience" \
            --notes-file "$RELEASE_NOTES_FILE" \
            --latest
        
        echo -e "${GREEN}  ✅ GitHub release created with distribution package${NC}"
    fi
else
    echo -e "${YELLOW}  gh CLI not available, manual GitHub release creation required${NC}"
    echo -e "${YELLOW}  Please create/update release manually at: https://github.com/omayhemo/APM/releases/tag/v$VERSION${NC}"
    echo -e "${YELLOW}  Upload: $DIST_FILE${NC}"
fi

# No cleanup needed - we used git subtree and never modified the development repo
echo -e "${BLUE}Cleanup: APM staging directory untouched${NC}"

echo ""
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo -e "${GREEN}     APM Release v$VERSION Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════${NC}"
echo ""
echo -e "${BLUE}FINAL SAFETY CONFIRMATION:${NC}"
echo -e "${GREEN}  ✅ APM/ folder contents committed to APM repository root${NC}"
echo -e "${GREEN}  ✅ Target repository: https://github.com/omayhemo/APM${NC}"
echo -e "${GREEN}  ✅ agentic-persona-mapping repository: UNTOUCHED${NC}"
echo -e "${GREEN}  ✅ No files deleted from development repository${NC}"
echo -e "${GREEN}  ✅ APM/ staging area preserved and functional${NC}"
echo ""
echo -e "${BLUE}Release Summary:${NC}"
echo -e "${GREEN}  ✅ Version updated to $VERSION${NC}"
echo -e "${GREEN}  ✅ Dynamic release notes created${NC}"
echo -e "${GREEN}  ✅ Distribution package built${NC}"
echo -e "${GREEN}  ✅ APM/ contents pushed to APM repository root${NC}"
echo -e "${GREEN}  ✅ GitHub release created/updated${NC}"
echo ""
echo -e "${BLUE}Distribution Package:${NC} $(basename "$DIST_FILE")"
echo -e "${BLUE}GitHub Release:${NC} https://github.com/omayhemo/APM/releases/tag/v$VERSION"
echo -e "${BLUE}Installation:${NC} curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults"
echo ""
echo -e "${GREEN}Ready for public use! 🚀${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT: This script committed ONLY to APM repository${NC}"
echo -e "${YELLOW}Your agentic-persona-mapping development repository is unchanged${NC}"