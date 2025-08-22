#!/bin/bash

# Script to update all references from designer to designer
# This is a systematic migration script

echo "🔄 Starting designer to designer migration..."

# Array of files to update (excluding backups)
FILES=(
    "./.apm/agents/CLAUDE.md"
    "./.apm/documentation/02-personas/designer-guide.md"
    "./.apm/documentation/04-configuration/initial-setup.md"
    "./.apm/documentation/04-configuration/voice-notifications.md"
    "./.apm/documentation/07-reference/api-reference.md"
    "./.apm/documentation/07-reference/file-structure.md"
    "./.apm/documentation/07-reference/template-variables.md"
    "./.claude/agents/voice/voice-installation-guide.md"
    "./.claude/agents/voice/voice-integration.md"
    "./.claude/commands/ai-prompt.md"
    "./.claude/commands/frontend-architecture.md"
    "./.claude/commands/planning-ux-spec.md"
    "./.claude/commands/research-prompt.md"
    "./.claude/settings.json"
    "./dist/coherence-v4.2.0-installer/installer/install.sh"
    "./dist/coherence-v4.2.0-installer/installer/personas/_master/designer.persona.json"
    "./dist/coherence-v4.2.0-installer/installer/populate-all-personas.sh"
    "./dist/coherence-v4.2.0-installer/installer/templates/claude/agents/voice/voice-installation-guide.md.template"
    "./dist/coherence-v4.2.0-installer/installer/templates/claude/agents/voice/voice-integration.md.template"
    "./dist/coherence-v4.2.0-installer/installer/templates/claude/commands/ai-prompt.md.template"
    "./dist/coherence-v4.2.0-installer/installer/templates/claude/commands/planning-frontend-architecture.md.template"
    "./dist/coherence-v4.2.0-installer/installer/templates/claude/settings.json.template"
    "./dist/coherence-v4.2.0-installer/installer/templates/CLAUDE.md.markdown.template"
    "./payload/install.sh"
    "./payload/populate-all-personas.sh"
    "./payload/templates/claude/agents/voice/voice-installation-guide.md.template"
    "./payload/templates/claude/agents/voice/voice-integration.md.template"
    "./payload/templates/claude/commands/ai-prompt.md.template"
    "./payload/templates/claude/commands/planning-frontend-architecture.md.template"
    "./payload/templates/claude/settings.json.template"
    "./payload/templates/CLAUDE.md.markdown.template"
    "./project_docs/reports/ACTUAL-DAMAGE-ASSESSMENT.md"
    "./project_docs/reports/APM-AGENT-INITIALIZATION-ANALYSIS.md"
    "./project_docs/reports/APM-AGENT-PERSONAS-SUMMARY.md"
    "./project_docs/reports/APM-COMPREHENSIVE-PATH-CATALOG-UPDATED.md"
    "./project_docs/reports/comprehensive_path_catalog.md"
    "./project_docs/reports/SYSTEM-INTEGRITY-VALIDATION-REPORT.md"
    "./project_docs/reports/voice-notification-verification.md"
    "./project_docs/specifications/apm-feature-specifications.md"
)

# Replacement patterns
declare -A REPLACEMENTS=(
    ["speakDesigner"]="speakDesigner"
    ["SPEAK_DESIGNER"]="SPEAK_DESIGNER"
    ["designer"]="designer"
    ["Designer"]="Designer"
    ["designer"]="designer"
    ["/designer"]="/designer"
)

# Counter for updated files
updated_count=0

# Process each file
for file in "${FILES[@]}"; do
    if [[ -f "$file" ]]; then
        echo "📝 Processing: $file"
        
        # Create a temporary file
        temp_file=$(mktemp)
        
        # Apply all replacements
        cp "$file" "$temp_file"
        
        for search in "${!REPLACEMENTS[@]}"; do
            replacement="${REPLACEMENTS[$search]}"
            sed -i "s|$search|$replacement|g" "$temp_file"
        done
        
        # Check if the file actually changed
        if ! cmp -s "$file" "$temp_file"; then
            cp "$temp_file" "$file"
            echo "✅ Updated: $file"
            ((updated_count++))
        else
            echo "⏭️  No changes needed: $file"
        fi
        
        # Cleanup
        rm "$temp_file"
        
    else
        echo "⚠️  File not found: $file"
    fi
done

echo ""
echo "🎯 Migration Summary:"
echo "   📊 Files processed: ${#FILES[@]}"
echo "   ✅ Files updated: $updated_count"
echo "   📂 Files unchanged: $((${#FILES[@]} - updated_count))"
echo ""
echo "✨ designer to designer migration completed!"