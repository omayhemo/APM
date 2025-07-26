#!/bin/bash

# Version Consistency Fix Script
# Ensures all APM components use v3.1.0

echo "=========================================="
echo "APM Version Consistency Fix v3.1.0"
echo "=========================================="

VERSION="3.1.0"

# Fix root VERSION file
echo "Updating root VERSION file..."
echo "$VERSION" > VERSION

# Fix templates VERSION file  
echo "Updating templates VERSION file..."
echo "$VERSION" > templates/VERSION

# Fix build script version fallback
echo "Checking build script version logic..."
if grep -q 'VERSION="2.0.0"' build-distribution.sh; then
    echo "Updating build script fallback version..."
    sed -i 's/VERSION="2.0.0"/VERSION="3.1.0"/' build-distribution.sh
fi

# Update installer version references
echo "Checking installer version references..."
find templates/ -name "*.template" -type f -exec grep -l "{{VERSION}}" {} \; | while read file; do
    echo "  Found template requiring version substitution: $file"
done

# Update any hardcoded version references in documentation
echo "Checking documentation for version references..."
find project_docs/ -name "*.md" -type f -exec grep -l "v3.0.0\|version.*3.0.0" {} \; | while read file; do
    echo "  Found documentation with old version: $file"
    sed -i 's/v3.0.0/v3.1.0/g' "$file"
    sed -i 's/version.*3.0.0/version 3.1.0/g' "$file"
done

# Check .apm directory for version consistency
if [ -d ".apm" ]; then
    echo "Checking .apm directory version..."
    if [ -f ".apm/VERSION" ]; then
        echo "$VERSION" > .apm/VERSION
        echo "  Updated .apm/VERSION to $VERSION"
    fi
fi

echo ""
echo "Version consistency fixes applied:"
echo "- Root VERSION: $(cat VERSION 2>/dev/null || echo 'Missing')"
echo "- Templates VERSION: $(cat templates/VERSION 2>/dev/null || echo 'Missing')"
echo "- .apm VERSION: $(cat .apm/VERSION 2>/dev/null || echo 'Missing')"

echo ""
echo "✅ Version consistency fix completed!"
echo "All components should now reference v$VERSION"