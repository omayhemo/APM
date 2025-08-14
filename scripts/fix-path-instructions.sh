#!/bin/bash
# Script to fix path instructions throughout all APM templates
# Addresses: Relative path issues, working directory problems, inconsistent template variables

echo "Fixing path instructions in APM templates..."
echo "============================================="

# Function to backup and update template
fix_template() {
    local template="$1"
    local description="$2"
    
    if [[ ! -f "$template" ]]; then
        echo "  ⚠ File not found: $template"
        return 1
    fi
    
    echo "  Fixing $description..."
    
    # Create backup
    cp "$template" "$template.backup"
    
    # 1. Replace relative project_docs/ with {{PROJECT_ROOT}}/project_docs/
    sed -i 's|project_docs/|{{PROJECT_ROOT}}/project_docs/|g' "$template"
    
    # 2. Replace {{PROJECT_DOCS}} with {{PROJECT_ROOT}}/project_docs
    sed -i 's|{{PROJECT_DOCS}}|{{PROJECT_ROOT}}/project_docs|g' "$template"
    
    # 3. Fix mixed patterns like {{AP_ROOT}}/../project_docs/
    sed -i 's|{{AP_ROOT}}/../project_docs/|{{PROJECT_ROOT}}/project_docs/|g' "$template"
    
    # 4. Add working directory verification section after WORKSPACE BOUNDARIES
    if grep -q "### PRIMARY WORKING DIRECTORIES" "$template" && ! grep -q "### WORKING DIRECTORY VERIFICATION" "$template"; then
        sed -i '/### FORBIDDEN PATHS/a\\n### WORKING DIRECTORY VERIFICATION\n**CRITICAL**: Before ANY file operation, verify working directory:\n```bash\n# ALWAYS execute from project root\ncd {{PROJECT_ROOT}}\npwd  # Should show: /path/to/your/project\n```\n\n**PATH VALIDATION**: All file operations MUST use absolute paths starting with {{PROJECT_ROOT}}\n- ✅ CORRECT: `{{PROJECT_ROOT}}/project_docs/requirements/analysis.md`\n- ❌ WRONG: `project_docs/requirements/analysis.md`\n- ❌ WRONG: `./project_docs/requirements/analysis.md`' "$template"
    fi
    
    # 5. Add explicit working directory command to initialization sequence
    if grep -q "CRITICAL INITIALIZATION SEQUENCE" "$template" && ! grep -q "Change to project root" "$template"; then
        sed -i '/## 🔴 CRITICAL INITIALIZATION SEQUENCE/a\\n**STEP 0: WORKING DIRECTORY VERIFICATION**\n0. **Change to project root**: `cd {{PROJECT_ROOT}}` and verify with `pwd`' "$template"
    fi
    
    # 6. Fix any remaining workspace/ references to use absolute paths
    sed -i 's|workspace/|{{PROJECT_ROOT}}/workspace/|g' "$template"
    
    # 7. Fix deliverables/ references
    sed -i 's|deliverables/|{{PROJECT_ROOT}}/deliverables/|g' "$template"
    
    # 8. Add path validation to document creation examples
    if grep -q "### Example" "$template" && grep -q "Write(" "$template"; then
        sed -i '/# Wrong/,/# Correct/c\
# Wrong - Relative path\
Write("my-report.md", content)\
Write("project_docs/my-report.md", content)\
\
# Correct - Absolute path with verification\
cd {{PROJECT_ROOT}}  # Ensure correct working directory\
Write("{{PROJECT_ROOT}}/project_docs/requirements/my-report.md", content)' "$template"
    fi
    
    echo "  ✓ Fixed $description"
}

# Function to fix command templates
fix_command_template() {
    local template="$1"
    local description="$2"
    
    if [[ ! -f "$template" ]]; then
        echo "  ⚠ File not found: $template"
        return 1
    fi
    
    echo "  Fixing command $description..."
    
    # Create backup
    cp "$template" "$template.backup"
    
    # Fix path references in command templates
    sed -i 's|project_docs/|{{PROJECT_ROOT}}/project_docs/|g' "$template"
    sed -i 's|{{PROJECT_DOCS}}|{{PROJECT_ROOT}}/project_docs|g' "$template"
    sed -i 's|workspace/|{{PROJECT_ROOT}}/workspace/|g' "$template"
    sed -i 's|deliverables/|{{PROJECT_ROOT}}/deliverables/|g' "$template"
    
    # Add working directory verification to task prompts
    if grep -q "Task [0-9]:" "$template"; then
        sed -i '/Task [0-9]:/a\
Working Directory: Ensure execution from {{PROJECT_ROOT}} with `cd {{PROJECT_ROOT}}`' "$template"
    fi
    
    echo "  ✓ Fixed command $description"
}

# Fix persona templates in templates/templates/personas/
echo ""
echo "Fixing persona templates in templates/templates/personas/..."
for template in templates/templates/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        fix_template "$template" "persona $agent"
    fi
done

# Fix agent persona templates in templates/templates/agents/personas/
echo ""
echo "Fixing agent persona templates in templates/templates/agents/personas/..."
for template in templates/templates/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        fix_template "$template" "agent persona $agent"
    fi
done

# Fix Claude agent persona templates in templates/templates/claude/agents/personas/
echo ""
echo "Fixing Claude agent persona templates in templates/templates/claude/agents/personas/..."
for template in templates/templates/claude/agents/personas/*.md.template; do
    if [[ -f "$template" ]]; then
        agent=$(basename "$template" .md.template)
        fix_template "$template" "Claude agent persona $agent"
    fi
done

# Fix command templates
echo ""
echo "Fixing command templates..."
for template in templates/templates/claude/commands/*.md.template; do
    if [[ -f "$template" ]]; then
        command=$(basename "$template" .md.template)
        fix_command_template "$template" "command $command"
    fi
done

# Fix task templates
echo ""
echo "Fixing task templates..."
for template in templates/templates/agents/tasks/*.md.template; do
    if [[ -f "$template" ]]; then
        task=$(basename "$template" .md.template)
        fix_command_template "$template" "task $task"
    fi
done

# Fix QA command templates
echo ""
echo "Fixing QA command templates..."
for template in templates/templates/agents/personas/qa/commands/*.md.template; do
    if [[ -f "$template" ]]; then
        qa_command=$(basename "$template" .md.template)
        fix_command_template "$template" "QA command $qa_command"
    fi
done

# Fix sprint coordination templates
echo ""
echo "Fixing sprint coordination templates..."
for template in templates/templates/claude/agents/sprint-coordination/*.md.template; do
    if [[ -f "$template" ]]; then
        sprint_template=$(basename "$template" .md.template)
        fix_command_template "$template" "sprint coordination $sprint_template"
    fi
done

# Fix miscellaneous templates
echo ""
echo "Fixing miscellaneous templates..."

# Fix project documentation templates
if [[ -f "templates/templates/project_documentation/backlog.md.template" ]]; then
    fix_template "templates/templates/project_documentation/backlog.md.template" "backlog template"
fi

# Fix CLAUDE.md templates
for claude_template in templates/templates/CLAUDE.md*.template; do
    if [[ -f "$claude_template" ]]; then
        fix_template "$claude_template" "CLAUDE.md template"
    fi
done

# Fix settings template
if [[ -f "templates/templates/claude/settings.json.template" ]]; then
    fix_template "templates/templates/claude/settings.json.template" "settings template"
fi

# Fix install script template variable references
echo ""
echo "Fixing install script..."
if [[ -f "templates/install.sh" ]]; then
    echo "  Fixing install.sh path references..."
    cp "templates/install.sh" "templates/install.sh.backup"
    
    # Fix any relative project_docs references in install script
    sed -i 's|project_docs/|${PROJECT_ROOT}/project_docs/|g' "templates/install.sh"
    
    echo "  ✓ Fixed install.sh"
fi

# Create summary report
echo ""
echo "📋 SUMMARY OF PATH FIXES"
echo "========================"
echo ""
echo "✅ FIXED ISSUES:"
echo "1. Replaced relative 'project_docs/' with '{{PROJECT_ROOT}}/project_docs/'"
echo "2. Standardized '{{PROJECT_DOCS}}' to '{{PROJECT_ROOT}}/project_docs'"
echo "3. Fixed mixed patterns like '{{AP_ROOT}}/../project_docs/'"
echo "4. Added working directory verification sections"
echo "5. Added explicit 'cd {{PROJECT_ROOT}}' commands to initialization"
echo "6. Updated file operation examples with absolute paths"
echo "7. Fixed workspace/ and deliverables/ references"
echo ""
echo "🔧 TEMPLATE CATEGORIES UPDATED:"
echo "- Persona templates (all directories)"
echo "- Command templates"
echo "- Task templates"
echo "- QA command templates" 
echo "- Sprint coordination templates"
echo "- Project documentation templates"
echo "- CLAUDE.md templates"
echo "- Settings templates"
echo "- Install script"
echo ""
echo "💡 KEY IMPROVEMENTS:"
echo "- All paths now use {{PROJECT_ROOT}} for absolute path resolution"
echo "- Working directory verification added to prevent relative path issues"
echo "- Consistent template variable usage across all files"
echo "- Explicit working directory commands in initialization sequences"
echo ""
echo "✅ Path instruction fixes complete!"
echo ""
echo "Next steps:"
echo "1. Test template installation: /buildit"
echo "2. Verify subagents create files in correct locations"
echo "3. Check that working directory verification prevents issues"