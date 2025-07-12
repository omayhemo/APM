#!/bin/bash
# AP Mapping Release Script
# This script automates the release process

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get version from command line
VERSION="${1:-}"
RELEASE_TYPE="${2:-}"

# Validate version format
validate_version() {
    local version=$1
    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z]+\.[0-9]+)?$ ]]; then
        echo -e "${RED}Error: Invalid version format${NC}"
        echo "Expected: MAJOR.MINOR.PATCH or MAJOR.MINOR.PATCH-PRERELEASE.NUMBER"
        echo "Examples: 1.1.0, 1.2.0-beta.1, 2.0.0-rc.1"
        exit 1
    fi
}

# Check git status
check_git_status() {
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${RED}Error: Working directory is not clean${NC}"
        echo "Please commit or stash your changes before releasing"
        git status --short
        exit 1
    fi
}

# Update version in files
update_version() {
    local version=$1
    echo -e "${BLUE}Updating version to $version...${NC}"
    
    # Update build-distribution.sh
    sed -i.bak "s/VERSION=\".*\"/VERSION=\"$version\"/" build-distribution.sh
    rm build-distribution.sh.bak
    
    # Update README.md URLs
    sed -i.bak "s/ap-mapping-v[0-9.]*\(-[a-zA-Z.0-9]*\)?\\.tar\\.gz/ap-mapping-v$version.tar.gz/g" README.md
    rm README.md.bak 2>/dev/null || true
    
    # Update installer README
    sed -i.bak "s/ap-mapping-v[0-9.]*\(-[a-zA-Z.0-9]*\)?\\.tar\\.gz/ap-mapping-v$version.tar.gz/g" installer/README.md
    rm installer/README.md.bak 2>/dev/null || true
    
    echo -e "${GREEN}✓ Version updated in all files${NC}"
}

# Generate release notes template
generate_release_notes() {
    local version=$1
    local date=$(date +%Y-%m-%d)
    
    cat > RELEASE_NOTES.md << EOF
# AP Mapping v$version

Released: $date

## 🎉 Highlights

<!-- Brief summary of major changes in this release -->

## ✨ New Features

<!-- List new features with descriptions -->
- **Feature Name**: Description

## 🐛 Bug Fixes

<!-- List bug fixes -->
- Fixed issue where...

## 🔧 Improvements

<!-- List improvements -->
- Enhanced performance of...

## 📚 Documentation

<!-- Documentation updates -->
- Updated guide for...

## 💔 Breaking Changes

_None in this release_

<!-- OR list breaking changes with migration paths -->

## 📦 Installation

### New Installation

\`\`\`bash
curl -L https://github.com/omayhemo/APM/releases/download/v$version/ap-mapping-v$version.tar.gz | tar -xz
./installer/install.sh
\`\`\`

### Updating from Previous Version

\`\`\`bash
agents/scripts/ap-manager.sh update
\`\`\`

## 🔄 Migration Guide

<!-- If applicable, provide migration steps -->

## 📋 Full Changelog

See [CHANGELOG.md](https://github.com/omayhemo/APM/blob/main/CHANGELOG.md) for complete history.
EOF

    echo -e "${GREEN}✓ Release notes template created: RELEASE_NOTES.md${NC}"
}

# Build distribution
build_distribution() {
    echo -e "${BLUE}Building distribution...${NC}"
    ./build-distribution.sh
    
    # Verify build
    if [ -f "dist/ap-mapping-v$VERSION.tar.gz" ]; then
        echo -e "${GREEN}✓ Distribution built successfully${NC}"
        ls -la dist/ap-mapping-v$VERSION.tar.gz
    else
        echo -e "${RED}Error: Distribution build failed${NC}"
        exit 1
    fi
}

# Create git tag
create_git_tag() {
    local version=$1
    echo -e "${BLUE}Creating git tag v$version...${NC}"
    
    # Commit changes
    git add .
    git commit -m "Release v$version

- Version bumped to $version
- Updated download URLs
- Built distribution package"
    
    # Create annotated tag
    git tag -a "v$version" -m "Release version $version"
    
    echo -e "${GREEN}✓ Git tag created: v$version${NC}"
}

# Push to APM repository
push_to_apm_repo() {
    local version=$1
    local release_type=$2
    
    echo -e "${BLUE}Pushing to APM repository...${NC}"
    
    # Check if APM remote exists
    if ! git remote get-url apm > /dev/null 2>&1; then
        echo -e "${YELLOW}Adding APM remote...${NC}"
        git remote add apm https://github.com/omayhemo/APM.git
    fi
    
    # Push commits and tags to APM repo
    echo "Pushing commits to APM repo..."
    git push apm main
    
    echo "Pushing tag to APM repo..."
    git push apm v$version
    
    echo -e "${GREEN}✓ Pushed to APM repository${NC}"
}

# Create GitHub release on APM repo
create_github_release() {
    local version=$1
    local release_type=$2
    
    echo -e "${BLUE}Creating GitHub release on APM repo...${NC}"
    
    # Check if gh CLI is available
    if ! command -v gh &> /dev/null; then
        echo -e "${YELLOW}GitHub CLI not found. Manual release creation required.${NC}"
        show_manual_release_steps "$version" "$release_type"
        return
    fi
    
    # Determine if this is a pre-release
    local prerelease_flag=""
    if [[ "$version" =~ -[a-zA-Z] ]]; then
        prerelease_flag="--prerelease"
    fi
    
    # Create release with distribution package
    echo "Creating GitHub release..."
    gh release create "v$version" \
        --repo omayhemo/APM \
        --title "AP Mapping v$version" \
        --notes-file RELEASE_NOTES.md \
        $prerelease_flag \
        "dist/ap-mapping-v$version.tar.gz"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ GitHub release created successfully${NC}"
        echo "Release URL: https://github.com/omayhemo/APM/releases/tag/v$version"
    else
        echo -e "${RED}Error creating GitHub release${NC}"
        show_manual_release_steps "$version" "$release_type"
    fi
}

# Show manual release steps if automated release fails
show_manual_release_steps() {
    local version=$1
    local release_type=$2
    
    echo ""
    echo -e "${YELLOW}Manual release creation required:${NC}"
    echo ""
    echo "1. Go to: https://github.com/omayhemo/APM/releases"
    echo "2. Click 'Draft a new release'"
    echo "3. Select tag: v$version"
    echo "4. Upload: dist/ap-mapping-v$version.tar.gz"
    echo "5. Copy contents from RELEASE_NOTES.md"
    if [[ "$version" =~ -[a-zA-Z] ]]; then
        echo "6. ✓ Mark as pre-release"
    fi
    echo ""
}

# Show completion message
show_completion() {
    local version=$1
    
    echo ""
    echo -e "${GREEN}🎉 Release v$version completed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}Post-release verification:${NC}"
    echo "- Test download: https://github.com/omayhemo/APM/releases/tag/v$version"
    echo "- Test installation: tar -xzf ap-mapping-v$version.tar.gz && ./installer/install.sh"
    echo "- Test update: agents/scripts/ap-manager.sh update"
    echo ""
    echo "Don't forget to:"
    echo "- Update any documentation that references the version"
    echo "- Announce the release to users"
    echo "- Monitor for any issues"
}

# Main execution
main() {
    echo -e "${BLUE}AP Mapping Release Process${NC}"
    echo "=========================="
    
    # Validate inputs
    if [ -z "$VERSION" ]; then
        echo -e "${RED}Error: Version not specified${NC}"
        echo "Usage: $0 <version> [--beta|--rc|--alpha]"
        exit 1
    fi
    
    validate_version "$VERSION"
    check_git_status
    
    # Confirm with user
    echo ""
    echo "Release version: $VERSION"
    if [ -n "$RELEASE_TYPE" ]; then
        echo "Release type: ${RELEASE_TYPE#--}"
    fi
    echo ""
    read -p "Continue with release? (y/N) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Release cancelled"
        exit 0
    fi
    
    # Execute release steps
    update_version "$VERSION"
    generate_release_notes "$VERSION"
    build_distribution
    create_git_tag "$VERSION"
    push_to_apm_repo "$VERSION" "$RELEASE_TYPE"
    create_github_release "$VERSION" "$RELEASE_TYPE"
    show_completion "$VERSION"
}

# Run main function
main