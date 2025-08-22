#!/bin/bash

# Build script for creating AP Mapping distribution package
# This creates a versioned tar.gz file with all necessary components

set -e

# Configuration
# Read version from VERSION file if it exists
if [ -f "templates/VERSION" ]; then
    VERSION=$(cat templates/VERSION)
elif [ -f "VERSION" ]; then
    VERSION=$(cat VERSION)
else
    VERSION="4.3.2"
fi
DIST_NAME="coherence-v$VERSION-installer"
DIST_DIR="dist/$DIST_NAME"

echo "=========================================="
echo "Building AP Mapping Distribution v$VERSION"
echo "=========================================="
echo ""

# Clean previous builds
echo "Cleaning previous builds..."
if [ -d "dist" ]; then
    # Remove contents of dist directory but keep the directory itself
    rm -rf dist/*
    # Also clean any hidden directories like .apm (but not . and ..)
    find dist -name ".*" -not -name "." -not -name ".." -exec rm -rf {} + 2>/dev/null || true
else
    # Create dist directory if it doesn't exist
    mkdir -p dist
fi

# Create distribution directory
echo "Creating distribution structure..."
mkdir -p "$DIST_DIR"

# Note: Persona generation is now done at install time using simplified generation system
echo "Persona templates will be generated at install time using simplified generation system..."
echo "✅ Simplified persona generation system ready for install-time execution"

# Validate template system integrity
echo "Validating template system integrity..."
# Check if payload/templates directory exists in distribution
if [ -d "payload/templates" ]; then
    TEMPLATE_COUNT=$(find payload/templates -name "*.template" -type f | wc -l)
else
    echo "❌ ERROR: payload/templates directory not found"
    exit 1
fi

if [ "$TEMPLATE_COUNT" -eq 0 ]; then
    echo "❌ ERROR: No template files found"
    exit 1
else
    echo "✅ Template system validation passed: $TEMPLATE_COUNT templates ready for distribution"
fi

# No cleanup needed - only templates and installer files in distribution
echo "No cleanup needed for template-only distribution"

# Note: Hook scripts are now in templates/templates/hooks as Python files
# The old agents/hooks directory has been removed

# No git files to remove - only templates and installer in distribution

# Copy payload directory (rename to installer in distribution)
echo "Copying payload directory as installer..."
# Use rsync to exclude node_modules and MCP Debug Host files
rsync -av --exclude='node_modules' --exclude='*.log' --exclude='.git' --exclude='coverage' --exclude='test-reports' --exclude='templates/docs/debug-host-mcp-integration.md.template' payload/ "$DIST_DIR/installer/"

# Create VERSION file at root level
echo "$VERSION" > "$DIST_DIR/VERSION"

# Create LICENSE file at root level  
echo "Creating LICENSE file..."
cat > "$DIST_DIR/LICENSE" << 'EOF'
MIT License

Copyright (c) 2024 AP Mapping Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF

# Create the tar.gz archive
echo ""
echo "Creating distribution archive..."
cd dist
# Create tar with LICENSE, VERSION, and installer directory
tar -czf "$DIST_NAME.tar.gz" -C "$DIST_NAME" LICENSE VERSION installer
cd ..

# No README copied to dist root - users get installer only

# Validate distribution package
echo ""
echo "Validating distribution package..."

# Check critical directories exist
VALIDATION_FAILED=false

if [ ! -d "$DIST_DIR/installer" ]; then
    echo "❌ ERROR: installer directory missing from distribution"
    VALIDATION_FAILED=true
fi

if [ ! -f "$DIST_DIR/installer/templates/hooks/subagent_stop.py" ]; then
    echo "❌ ERROR: Enhanced hook files missing from distribution"
    VALIDATION_FAILED=true
fi

# Validate template system in distribution
if [ ! -d "$DIST_DIR/installer/templates/agents" ]; then
    echo "❌ ERROR: Template system missing from distribution"
    VALIDATION_FAILED=true
fi

# Check template count
TEMPLATE_COUNT=$(find "$DIST_DIR/installer/templates" -name "*.template" -type f | wc -l)

if [ "$TEMPLATE_COUNT" -eq 0 ]; then
    echo "❌ ERROR: No template files found in distribution"
    VALIDATION_FAILED=true
else
    echo "✅ Template system integrity: $TEMPLATE_COUNT templates ready for distribution"
fi

# Validate critical template files exist (updated for simplified persona generation)
CRITICAL_TEMPLATES=(
    "installer/templates/claude/commands/planning-groom.md.template"
    "installer/templates/claude/commands/planning-epic.md.template"
    "installer/templates/claude/commands/ap_orchestrator.md.template"
    "installer/templates/claude/settings.json.template"
    "installer/personas/_build/generate_persona.sh"
)

for template in "${CRITICAL_TEMPLATES[@]}"; do
    if [ ! -f "$DIST_DIR/$template" ]; then
        echo "❌ ERROR: Critical template missing: $template"
        VALIDATION_FAILED=true
    fi
done

if [ "$VALIDATION_FAILED" = true ]; then
    echo ""
    echo "❌ DISTRIBUTION VALIDATION FAILED"
    echo "Critical components are missing from the distribution package."
    echo "Build cannot continue until these issues are resolved."
    exit 1
fi

echo "✅ Distribution validation passed"

# Calculate file size
FILE_SIZE=$(ls -lh "dist/$DIST_NAME.tar.gz" | awk '{print $5}')

# Count files in distribution
FILE_COUNT=$(find "$DIST_DIR" -type f | wc -l)

echo ""
echo "=========================================="
echo "Build completed successfully!"
echo "=========================================="
echo ""
echo "Distribution Details:"
echo "- Package: dist/$DIST_NAME.tar.gz"
echo "- Size: $FILE_SIZE"
echo "- Total Files: $FILE_COUNT"
echo "- Template Files: $TEMPLATE_COUNT"
echo "- Distribution: ✅ Template-only build process"
echo ""
echo "Installation Instructions:"
echo "1. Extract: tar -xzf $DIST_NAME.tar.gz"
echo "2. Install: cd installer && ./install.sh"
echo ""
echo "Distribution ready for release!"