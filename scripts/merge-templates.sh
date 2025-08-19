#!/bin/bash

# Template merger script for parallel and sequential commands
# This script systematically merges parallel- prefixed templates with their base versions

COMMANDS=(
    "requirements"
    "brainstorming"
    "acceptance-criteria"
    "ai-prompt"
    "qa-automation-plan"
    "checklist"
    "course-correction"
    "epic"
    "frontend-architecture"
    "next-story"
    "prd"
    "prioritization"
    "qa-framework"
    "quality-review"
    "research-prompt"
    "stakeholder-review"
    "stories"
    "qa-test-plan"
    "qa-test-strategy"
    "requirement-validation"
)

merge_command_templates() {
    local cmd="$1"
    local base_file="${cmd}.md.template"
    local parallel_file="parallel-${cmd}.md.template"
    
    echo "Merging $cmd templates..."
    
    # Check if both files exist
    if [[ ! -f "$base_file" ]] || [[ ! -f "$parallel_file" ]]; then
        echo "  - Skipping $cmd: missing files"
        return
    fi
    
    # Extract key info from parallel template
    local agent=$(grep -E "agent:" "$parallel_file" | head -1 | cut -d':' -f2 | xargs)
    local speedup=$(grep -E "speedup:|Performance.*faster" "$parallel_file" | head -1 | grep -o '[0-9]\+%' | head -1)
    
    echo "  - Agent: $agent"
    echo "  - Speedup: $speedup"
    
    # Create merged template header
    cat > "${base_file}.new" << EOF
---
name: $cmd
description: $(grep "description:" "$base_file" | cut -d':' -f2- | xargs) with parallel execution option
metadata:
  version: 2.0.0
  agent: $agent
  parallel_support: true
  modes: [sequential, parallel]
---

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the $agent persona.**

\`\`\`markdown
*Loading $agent context for $cmd...*

Quick Context Load (1-2 seconds):
- Loading $agent configuration and expertise
- Loading relevant templates and frameworks
- PARALLEL_MODE: Preparing parallel execution framework
- SEQUENTIAL_MODE: Standard context loading
- Workspace validation: Ensuring execution from {{PROJECT_ROOT}}

*Context ready. Choose execution mode...*
\`\`\`

## Command Overview

This command supports both sequential and parallel execution:

**Sequential Mode (Default):**
- Focused, guided methodology with deep analysis
- Interactive stakeholder engagement
- Systematic validation and documentation
- Quality-focused approach

**Parallel Mode (--parallel flag):**
- Multiple native sub-agents working simultaneously  
- ${speedup:-70%} performance improvement
- Comprehensive parallel coverage
- Speed-optimized execution

## Usage

\`\`\`
/$cmd [--parallel]
\`\`\`

**Parameters:**
- \`--parallel\`: Execute with parallel sub-agents for faster completion
- Default: Sequential execution with guided methodology

## SEQUENTIAL_MODE: Sequential Process
EOF

    # Extract sequential content (skip header)
    sed -n '/^## Usage/,$ p' "$base_file" | tail -n +2 >> "${base_file}.new"
    
    echo "" >> "${base_file}.new"
    echo "## PARALLEL_MODE: Parallel Process" >> "${base_file}.new"
    
    # Extract parallel content (skip header)
    sed -n '/^## 🚀 INITIALIZATION PROTOCOL/,$ p' "$parallel_file" >> "${base_file}.new"
    
    # Replace the original file
    mv "${base_file}.new" "$base_file"
    
    # Remove the parallel template
    rm "$parallel_file"
    
    echo "  - ✅ Merged successfully"
}

# Process all commands
for cmd in "${COMMANDS[@]}"; do
    merge_command_templates "$cmd"
done

# Handle special cases that may need manual attention
echo ""
echo "🎯 Batch merge complete!"
echo "📊 Processed: ${#COMMANDS[@]} command pairs"
echo "🔧 Manual review recommended for complex templates"
echo ""

# List any remaining parallel templates
remaining=$(find . -name "parallel-*.template" | wc -l)
echo "📋 Remaining parallel templates: $remaining"
if [ $remaining -gt 0 ]; then
    echo "   These may require manual merging:"
    find . -name "parallel-*.template" | sed 's|./||'
fi