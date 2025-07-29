#!/bin/bash
# Script to add critical research protocols to all agent templates

echo "Adding critical research protocols to all agent templates..."
echo "=========================================================="

# Function to add research protocols section
add_research_protocols() {
    local template="$1"
    local description="$2"
    
    if [[ ! -f "$template" ]]; then
        echo "  ⚠ File not found: $template"
        return 1
    fi
    
    # Check if research protocols already added
    if grep -q "CRITICAL: RESEARCH PROTOCOLS" "$template"; then
        echo "  ✓ $description already has research protocols, skipping..."
        return 0
    fi
    
    echo "  Adding research protocols to $description..."
    
    # Create backup
    cp "$template" "$template.backup"
    
    # Add research protocols section after the CRITICAL section
    sed -i '/🔴 \*\*CRITICAL\*\*/a\\n## 🔴 CRITICAL: RESEARCH PROTOCOLS\n\n**NEVER GUESS, ALWAYS VERIFY** - Follow these protocols before any decision:\n\n### 📋 MANDATORY RESEARCH SEQUENCE:\n1. **Search Project Docs**: Check {{PROJECT_ROOT}}/project_docs/ and {{SESSION_NOTES_PATH}}/\n2. **Search Codebase**: Use Grep/Glob tools to find existing implementations\n3. **Read Configurations**: Examine actual files, logs, and configurations\n4. **Research Externally**: Use WebSearch for authoritative sources when needed\n5. **Ask for Clarification**: Stop and ask specific questions when uncertain\n\n### ❌ FORBIDDEN BEHAVIORS:\n- **Never say**: "I assume...", "Probably...", "It should be...", "Typically..."\n- **Never guess** at: API endpoints, file paths, configuration values, requirements\n- **Never invent**: Technical specifications, user requirements, system constraints\n\n### ✅ REQUIRED EVIDENCE STATEMENTS:\n- "According to [specific file/source]..."\n- "The existing code in [path] shows..."\n- "Based on my search of [location], I found..."\n- "I need clarification on [specific aspect] because [context]"\n\n### 🚨 ESCALATION TRIGGERS - Stop and ask when:\n- Conflicting information found in different sources\n- Missing critical documentation or requirements\n- Ambiguous user requirements despite research\n- Security or data integrity implications discovered\n\n**Remember**: Better to ask one clarifying question than make ten wrong assumptions.\n\n**Full protocols**: See {{AP_ROOT}}/docs/CRITICAL-RESEARCH-PROTOCOLS.md\n' "$template"
    
    echo "  ✓ Added research protocols to $description"
}

# Add to persona templates in templates/templates/personas/
echo ""
echo "Adding to persona templates in templates/templates/personas/..."
for template in templates/templates/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        add_research_protocols "$template" "persona $agent"
    fi
done

# Add to agent persona templates in templates/templates/agents/personas/
echo ""
echo "Adding to agent persona templates in templates/templates/agents/personas/..."
for template in templates/templates/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        add_research_protocols "$template" "agent persona $agent"
    fi
done

# Add to Claude agent persona templates in templates/templates/claude/agents/personas/
echo ""
echo "Adding to Claude agent persona templates in templates/templates/claude/agents/personas/..."
for template in templates/templates/claude/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        add_research_protocols "$template" "Claude agent persona $agent"
    fi
done

# Add to installer templates as well
echo ""
echo "Adding to installer templates..."
for template in installer/templates/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        add_research_protocols "$template" "installer agent persona $agent"
    fi
done

for template in installer/templates/claude/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        add_research_protocols "$template" "installer Claude agent persona $agent"
    fi
done

echo ""
echo "📋 SUMMARY"
echo "========="
echo ""
echo "✅ RESEARCH PROTOCOLS ADDED TO ALL AGENT TEMPLATES"
echo ""
echo "Key improvements:"
echo "- Mandatory research sequence before any decision"
echo "- Explicit prohibition of guessing and assumptions"
echo "- Required evidence-based statements"
echo "- Clear escalation triggers for asking questions"
echo "- Tool usage guidance (Grep, Glob, WebSearch, etc.)"
echo ""
echo "This ensures all agents will:"
echo "1. Search project documentation first"
echo "2. Use proper research tools"
echo "3. Ask questions instead of guessing"
echo "4. Provide evidence for their decisions"
echo "5. Escalate appropriately when uncertain"
echo ""
echo "✅ Research protocols successfully added to all agent templates!"