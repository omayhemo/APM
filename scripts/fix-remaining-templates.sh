#!/bin/bash
# Script to update remaining persona templates in /personas/ directories

echo "Updating remaining persona templates..."
echo "======================================"

# Function to update template
update_template() {
    local template="$1"
    local agent="$2"
    local voice_var="$3"
    
    if [[ ! -f "$template" ]]; then
        echo "  ⚠ File not found: $template"
        return 1
    fi
    
    # Check if already updated
    if grep -q "List session notes directory" "$template"; then
        echo "  ✓ $agent already has session notes, skipping..."
        return 0
    fi
    
    echo "  Updating $agent template..."
    
    # Create backup
    cp "$template" "$template.backup"
    
    # Find the Post-Initialization section and add session note management
    sed -i '/### Post-Initialization:/,/^$/{
        /### Post-Initialization:/a\
After ALL tasks complete:\
1. Voice announcement: bash {{SPEAK_'${agent^^}'}} "'${agent}' agent initialized with context"\
2. Update session note with initialization status\
3. Confirm: "✓ '${agent}' agent initialized"\
\
### Session Note Management\
\
Throughout your session:\
- **Update session note** with progress and key decisions\
- **Document important findings** and solutions\
- **Track completed work** and remaining tasks\
- **Note recommendations** for future sessions
        /^$/d
    }' "$template"
    
    echo "  ✓ Updated $agent template"
}

# Update templates in templates/templates/personas/
for template in templates/templates/personas/*.md.template; do
    if [[ -f "$template" && "$template" != *orchestrator* ]]; then
        agent=$(basename "$template" .md.template)
        update_template "$template" "$agent" "{{SPEAK_${agent^^}}}"
    fi
done

# Update templates in installer/templates/personas/
for template in installer/templates/personas/*.md.template; do
    if [[ -f "$template" && "$template" != *orchestrator* ]]; then
        agent=$(basename "$template" .md.template)
        update_template "$template" "$agent" "{{SPEAK_${agent^^}}}"
    fi
done

echo ""
echo "✅ Remaining persona templates updated!"