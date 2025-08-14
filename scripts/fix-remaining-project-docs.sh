#!/bin/bash
# Script to fix remaining $PROJECT_DOCS references

echo "Fixing remaining \$PROJECT_DOCS references..."
echo "=============================================="

# Find and replace $PROJECT_DOCS with {{PROJECT_ROOT}}/project_docs
find templates/ installer/ -name "*.template" -type f | while read -r file; do
    if grep -q '\$PROJECT_DOCS' "$file"; then
        echo "  Fixing: $file"
        cp "$file" "$file.backup"
        sed -i 's|\$PROJECT_DOCS|{{PROJECT_ROOT}}/project_docs|g' "$file"
        echo "  ✓ Fixed: $file"
    fi
done

echo ""
echo "✅ All \$PROJECT_DOCS references fixed!"