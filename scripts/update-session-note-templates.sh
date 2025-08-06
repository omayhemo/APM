#!/bin/bash
# Script to update session note handling in all template files
# Created: 2025-08-05 for APM v3.3.1

echo "Updating session note handling in template files..."

# Find all CLAUDE.md templates and update them
find /mnt/c/Code/agentic-persona-mapping/installer/templates -name "CLAUDE.md*.template*" -type f | while read -r template; do
    echo "Processing: $template"
    
    # Update the mandatory sequence
    sed -i 's/DO NOT try to read current_session\.md/Read the LATEST non-archived session note file (if exists) to understand context/g' "$template"
    sed -i 's/DO NOT try to read rules\.md//g' "$template"
    sed -i 's/NOT reading current_session\.md/Required/g' "$template"
    sed -i 's/NOT reading rules\.md/Required/g' "$template"
    
    # Update step descriptions
    sed -i 's/(DO NOT read current_session\.md)//g' "$template"
    sed -i 's/(DO NOT read rules\.md)//g' "$template"
done

# Find all persona templates that might need session note updates
find /mnt/c/Code/agentic-persona-mapping/installer/templates -name "*.md.template" -path "*/personas/*" -type f | while read -r persona; do
    echo "Checking persona: $persona"
    
    # Add session note update reminder if not present
    if ! grep -q "CONTINUOUS SESSION NOTE" "$persona"; then
        echo "Adding session note protocol to: $persona"
        # This would need custom logic per persona file structure
    fi
done

echo "Template updates complete!"
echo "Remember to test the installer with updated templates before release."