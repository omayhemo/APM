#!/bin/bash
set -e

echo "==========================================="
echo "Building AP Mapping Distribution v1.2.3"
echo "==========================================="
echo ""

# Read version from VERSION file
VERSION=$(cat VERSION)
DIST_NAME="apm-v$VERSION"
DIST_DIR="dist/$DIST_NAME"

echo "Building version: $VERSION"

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf dist/*

# Create distribution directory
echo "Creating distribution structure..."
mkdir -p "$DIST_DIR"

# Copy agents directory to .apm
echo "Copying agents directory..."
mkdir -p "$DIST_DIR/.apm"
cp -r agents "$DIST_DIR/.apm/"

# Clean up unwanted files
echo "Cleaning up distribution..."
find "$DIST_DIR/.apm/agents" -name "*.log" -type f -delete
find "$DIST_DIR/.apm/agents" -name ".DS_Store" -type f -delete
find "$DIST_DIR/.apm/agents" -name "*~" -type f -delete
find "$DIST_DIR/.apm/agents" -name "*.tmp" -type f -delete
find "$DIST_DIR/.apm/agents" -name ".gitignore" -type f -delete

# Create VERSION file
echo "$VERSION" > "$DIST_DIR/VERSION"

# Copy installer
echo "Copying installer directory..."
cp -r installer "$DIST_DIR/"

# Copy README
cp installer/README.md "$DIST_DIR/README.md"

# Create LICENSE
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

# Create archive
echo "Creating distribution archive..."
cd "$DIST_DIR"
tar -czf "../$DIST_NAME.tar.gz" .
cd ../..

# Validate distribution
echo ""
echo "Validating distribution package..."

VALIDATION_FAILED=false

if [ ! -d "$DIST_DIR/.apm/agents" ]; then
    echo "❌ ERROR: .apm/agents directory missing"
    VALIDATION_FAILED=true
fi

if [ ! -f "$DIST_DIR/.apm/agents/personas/ap_orchestrator.md" ]; then
    echo "❌ ERROR: Core persona files missing"
    VALIDATION_FAILED=true
fi

if [ ! -f "$DIST_DIR/installer/templates/hooks/subagent_stop.py" ]; then
    echo "❌ ERROR: Enhanced hook files missing"
    VALIDATION_FAILED=true
fi

if [ "$VALIDATION_FAILED" = true ]; then
    echo "❌ VALIDATION FAILED"
    exit 1
fi

echo "✅ Distribution validation passed"

# Statistics
FILE_SIZE=$(ls -lh "dist/$DIST_NAME.tar.gz" | awk '{print $5}')
FILE_COUNT=$(find "$DIST_DIR" -type f | wc -l)
AGENT_FILE_COUNT=$(find "$DIST_DIR/.apm/agents" -type f | wc -l)

echo ""
echo "==========================================="
echo "Build completed successfully!"
echo "==========================================="
echo "Distribution Details:"
echo "- Package: dist/$DIST_NAME.tar.gz"
echo "- Size: $FILE_SIZE"
echo "- Total Files: $FILE_COUNT"
echo "- Agent Files: $AGENT_FILE_COUNT"
echo ""
echo "✅ Ready for release!"