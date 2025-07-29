#!/bin/bash
# Script to add session note creation to all agent templates

# Function to add session note instructions to an agent template
add_session_notes() {
    local file="$1"
    local agent_name="$2"
    local speak_var="$3"
    
    echo "Processing $file for $agent_name..."
    
    # Check if file already has session note instructions
    if grep -q "List session notes directory" "$file"; then
        echo "  ✓ Already has session note instructions, skipping..."
        return
    fi
    
    # Create a temporary file
    local temp_file=$(mktemp)
    
    # Process the file
    awk -v agent="$agent_name" -v speak="$speak_var" '
    /## 🚀 INITIALIZATION PROTOCOL \(MANDATORY\)/ || /## Initialization Protocol/ {
        print "## 🔴 CRITICAL INITIALIZATION SEQUENCE"
        print ""
        print "**When activated, follow this EXACT sequence:**"
        print ""
        print "1. **List session notes directory** (use LS tool): `{{SESSION_NOTES_PATH}}/`"
        print "   - DO NOT try to read \"current_session.md\" - it doesn'\''t exist"
        print "   "
        print "2. **List rules directory** (use LS tool): `{{RULES_PATH}}/`  "
        print "   - DO NOT try to read \"rules.md\" - it doesn'\''t exist"
        print "   "
        print "3. **Create new session note** with timestamp: `{{SESSION_NOTES_PATH}}/YYYY-MM-DD-HH-mm-ss-" agent "-Agent-Activation.md`"
        print ""
        print "4. **Voice announcement**: `bash " speak " \"" agent " agent activated. Loading configuration.\"`"
        print ""
        print "5. **Execute parallel initialization**:"
        next
    }
    /### Post-Initialization:/ {
        in_post_init = 1
    }
    in_post_init && /^$/ {
        print "2. Update session note with initialization status"
        print "3. Confirm: \"✓ " agent " agent initialized\""
        print ""
        print "### Session Note Management"
        print ""
        print "Throughout your session:"
        print "- **Update session note** with progress and key decisions"
        print "- **Document important findings** and solutions"
        print "- **Track completed work** and remaining tasks"
        print "- **Note recommendations** for future sessions"
        print ""
        in_post_init = 0
        next
    }
    { print }
    ' "$file" > "$temp_file"
    
    # Replace original file
    mv "$temp_file" "$file"
    echo "  ✓ Updated $agent_name template"
}

# Process all agent templates
echo "Adding session note creation to agent templates..."
echo "==========================================="

# PM Agent
add_session_notes "/mnt/c/Code/agentic-persona-mapping/templates/templates/claude/agents/personas/pm.md.template" "PM" "{{SPEAK_PM}}"

# Architect Agent
add_session_notes "/mnt/c/Code/agentic-persona-mapping/templates/templates/claude/agents/personas/architect.md.template" "Architect" "{{SPEAK_ARCHITECT}}"

# PO Agent
add_session_notes "/mnt/c/Code/agentic-persona-mapping/templates/templates/claude/agents/personas/po.md.template" "PO" "{{SPEAK_PO}}"

# SM Agent
add_session_notes "/mnt/c/Code/agentic-persona-mapping/templates/templates/claude/agents/personas/sm.md.template" "SM" "{{SPEAK_SM}}"

# Analyst Agent
add_session_notes "/mnt/c/Code/agentic-persona-mapping/templates/templates/claude/agents/personas/analyst.md.template" "Analyst" "{{SPEAK_ANALYST}}"

# Design Architect Agent
add_session_notes "/mnt/c/Code/agentic-persona-mapping/templates/templates/claude/agents/personas/design-architect.md.template" "Design-Architect" "{{SPEAK_DESIGN_ARCHITECT}}"

echo ""
echo "Now processing installer templates..."
echo "====================================="

# Process installer directory templates
for template in /mnt/c/Code/agentic-persona-mapping/installer/templates/claude/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        case "$agent" in
            qa) add_session_notes "$template" "QA" "\$SPEAK_QA" ;;
            developer) add_session_notes "$template" "Developer" "\$SPEAK_DEVELOPER" ;;
            pm) add_session_notes "$template" "PM" "\$SPEAK_PM" ;;
            architect) add_session_notes "$template" "Architect" "\$SPEAK_ARCHITECT" ;;
            po) add_session_notes "$template" "PO" "\$SPEAK_PO" ;;
            sm) add_session_notes "$template" "SM" "\$SPEAK_SM" ;;
            analyst) add_session_notes "$template" "Analyst" "\$SPEAK_ANALYST" ;;
            design-architect) add_session_notes "$template" "Design-Architect" "\$SPEAK_DESIGN_ARCHITECT" ;;
            orchestrator) echo "  ✓ Skipping orchestrator (already has session notes)" ;;
        esac
    fi
done

echo ""
echo "Processing other template directories..."
echo "======================================="

# Process templates/templates/agents/personas/
for template in /mnt/c/Code/agentic-persona-mapping/templates/templates/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        case "$agent" in
            qa) add_session_notes "$template" "QA" "\$SPEAK_QA" ;;
            dev) add_session_notes "$template" "Developer" "\$SPEAK_DEVELOPER" ;;
            pm) add_session_notes "$template" "PM" "\$SPEAK_PM" ;;
            architect) add_session_notes "$template" "Architect" "\$SPEAK_ARCHITECT" ;;
            po) add_session_notes "$template" "PO" "\$SPEAK_PO" ;;
            sm) add_session_notes "$template" "SM" "\$SPEAK_SM" ;;
            analyst) add_session_notes "$template" "Analyst" "\$SPEAK_ANALYST" ;;
            design-architect) add_session_notes "$template" "Design-Architect" "\$SPEAK_DESIGN_ARCHITECT" ;;
        esac
    fi
done

# Process installer/templates/agents/personas/
for template in /mnt/c/Code/agentic-persona-mapping/installer/templates/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        case "$agent" in
            qa) add_session_notes "$template" "QA" "\$SPEAK_QA" ;;
            dev) add_session_notes "$template" "Developer" "\$SPEAK_DEVELOPER" ;;
            pm) add_session_notes "$template" "PM" "\$SPEAK_PM" ;;
            architect) add_session_notes "$template" "Architect" "\$SPEAK_ARCHITECT" ;;
            po) add_session_notes "$template" "PO" "\$SPEAK_PO" ;;
            sm) add_session_notes "$template" "SM" "\$SPEAK_SM" ;;
            analyst) add_session_notes "$template" "Analyst" "\$SPEAK_ANALYST" ;;
            design-architect) add_session_notes "$template" "Design-Architect" "\$SPEAK_DESIGN_ARCHITECT" ;;
        esac
    fi
done

echo ""
echo "✅ Session note instructions added to all agent templates!"