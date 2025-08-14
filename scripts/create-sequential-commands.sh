#!/bin/bash

# Sequential Command Generator Script
# Purpose: Create native slash commands for remaining original task templates
# Date: 2025-01-21

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}=== Sequential Command Generator ===${NC}"
echo "Creating native slash commands for original task templates..."
echo ""

# Commands directory
COMMANDS_DIR=".claude/commands"

# Define remaining commands to create
# Format: "template_file:command_name:agent:description"
COMMANDS=(
    "checklist-run-task.md.template:checklist:Scrum Master:Sequential checklist validation with guided methodology"
    "conduct-stakeholder-review-task.md.template:stakeholder-review:Analyst:Sequential stakeholder analysis and review process"
    "correct-course.md.template:course-correction:Scrum Master:Sequential course correction analysis and planning"
    "create-ai-frontend-prompt.md.template:ai-prompt:Design Architect:Sequential AI prompt creation with guided methodology"
    "create-automation-plan.md.template:automation-plan:QA:Sequential test automation planning and framework design"
    "create-deep-research-prompt.md.template:research-prompt:Analyst:Sequential research planning with guided methodology"
    "create-frontend-architecture.md.template:frontend-architecture:Design Architect:Sequential frontend architecture design process"
    "create-next-story-task.md.template:next-story:Scrum Master:Sequential story creation with guided development"
    "create-prd.md.template:prd:Product Manager:Sequential PRD creation with comprehensive methodology"
    "create-project-brief.md.template:project-brief:Product Manager:Sequential project brief creation and planning"
    "create-test-plan.md.template:test-plan:QA:Sequential test planning with comprehensive coverage"
    "create-test-strategy.md.template:test-strategy:QA:Sequential test strategy development and planning"
    "create-user-stories-task.md.template:stories:Product Owner:Sequential user story creation with guided methodology"
    "create-uxui-spec.md.template:ux-spec:Design Architect:Sequential UX/UI specification development"
    "define-acceptance-criteria-task.md.template:acceptance-criteria:Product Owner:Sequential acceptance criteria definition process"
    "doc-sharding-task.md.template:doc-sharding:Developer:Sequential documentation organization and sharding"
    "execute-quality-review.md.template:quality-review:QA:Sequential quality assessment and review process"
    "library-indexing-task.md.template:library-indexing:Developer:Sequential library indexing and documentation"
    "prioritize-backlog-task.md.template:prioritization:Product Owner:Sequential backlog prioritization methodology"
    "validate-requirements.md.template:validation:Analyst:Sequential requirements validation and verification"
)

# Function to create a command file
create_command() {
    local template_file="$1"
    local command_name="$2" 
    local agent="$3"
    local description="$4"
    
    local command_file="$COMMANDS_DIR/${command_name}.md"
    
    echo -e "${YELLOW}Creating ${command_name}.md${NC}"
    
    cat > "$command_file" << EOF
---
name: ${command_name}
description: ${description}
metadata:
  version: 1.0.0
  agent: ${agent}
  performance: sequential
  approach: guided
---

# Sequential ${command_name^} Command

**${agent} Agent Only**: Executes structured ${command_name} through guided sequential methodology.

## Metadata
- **Name**: ${command_name}
- **Description**: ${description}
- **Agent**: ${agent}
- **Performance**: Sequential (focused approach vs parallel streams)
- **Approach**: Interactive guidance and systematic methodology

## Overview

The \`/${command_name}\` command enables the ${agent} to execute ${command_name} through:
- Sequential development with focused attention on each aspect
- Interactive guidance through ${command_name} components  
- Systematic methodology ensuring comprehensive coverage
- Thorough validation and refinement process
- Clear documentation with detailed rationale

## Usage

\`\`\`
/${command_name}
\`\`\`

## Prerequisites

Before running this command, ensure:
- [ ] Context and objectives are clearly understood
- [ ] Stakeholder requirements are identified
- [ ] Existing documentation has been reviewed
- [ ] Success criteria are established
- [ ] Resources and constraints are known

## 🚀 INITIALIZATION PROTOCOL (MANDATORY)

**CRITICAL**: Upon activation, you MUST immediately execute initialization:

\`\`\`
I'm launching sequential ${command_name} for comprehensive development and analysis.

*Loading ${command_name} templates and methodologies...*
[Execute initialization tasks in sequence]
- Load ${command_name} templates and frameworks
- Review context and requirements
- Prepare systematic methodology
- Set up validation and documentation processes
\`\`\`

## Sequential ${command_name^} Process

### Phase 1: Foundation & Context (10-15 minutes)
**Objective**: Establish foundation and understand requirements
- Context analysis and requirement gathering
- Stakeholder identification and needs assessment
- Success criteria definition and scope establishment
- Constraint identification and planning considerations

### Phase 2: Development & Analysis (20-30 minutes) 
**Objective**: Execute core ${command_name} activities
- Systematic development following proven methodologies
- Interactive refinement and stakeholder engagement
- Quality validation and completeness checking
- Iterative improvement based on feedback

### Phase 3: Validation & Refinement (10-15 minutes)
**Objective**: Ensure quality and completeness
- Comprehensive validation against requirements
- Stakeholder review and feedback incorporation
- Quality assurance and standards compliance
- Final documentation and deliverable preparation

## Expected Outcomes

After ${command_name} completion:
- **Comprehensive deliverables** meeting all requirements
- **Quality assurance** with validation completed
- **Stakeholder alignment** with approval obtained
- **Clear documentation** with rationale and decisions
- **Implementation readiness** with next steps defined

## Output Format

\`\`\`markdown
# ${command_name^} Results

## Overview
- **${command_name^} Type**: [Type/Category]
- **Agent**: ${agent}
- **Completion Date**: [Date]
- **Status**: [Complete/In Progress]

## Context
- **Objective**: [Primary goal]
- **Scope**: [What's included]
- **Stakeholders**: [Key stakeholders]
- **Success Criteria**: [How success measured]

## Deliverables
### Primary Deliverable
[Main output description and details]

### Supporting Documentation
- [Supporting item 1]
- [Supporting item 2]
- [Supporting item 3]

## Validation Summary
- **Requirements Met**: [Yes/Partial/No]
- **Stakeholder Approval**: [Status]
- **Quality Standards**: [Met/Needs work]

## Next Steps
1. [Immediate next action]
2. [Follow-up activities]
3. [Implementation planning]
\`\`\`

## Integration Points

- **Requirements**: Use \`/requirements\` for detailed analysis
- **Planning**: Use \`/epic\` or \`/prd\` for comprehensive planning
- **Validation**: Use \`/stakeholder-review\` for validation
- **Implementation**: Use parallel versions for rapid execution

## Voice Notifications

\`\`\`bash
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speak$(echo ${agent} | tr '[:upper:]' '[:lower:]' | tr ' ' '').sh "Sequential ${command_name} beginning. Launching guided development process..."
\`\`\`

## Success Metrics

- **Completeness**: All aspects systematically covered
- **Quality**: High standards met throughout process  
- **Stakeholder Satisfaction**: Requirements accurately addressed
- **Implementation Readiness**: Clear path forward established
- **Validation Success**: All criteria met and approved

## When to Use Sequential vs Parallel

**Use \`/${command_name}\` when:**
- Focused development with single deliverable
- Interactive refinement and collaboration desired
- Quality and thoroughness over speed
- Complex requirements need careful analysis
- Stakeholder engagement throughout process important

**Use \`/parallel-${command_name}\` when:**
- Multiple deliverables needed simultaneously
- Time constraints require rapid execution
- Comprehensive coverage across domains
- Well-understood process and templates
- Speed and efficiency prioritized

---

This command provides thoughtful, systematic ${command_name} with emphasis on quality, stakeholder collaboration, and comprehensive coverage.
EOF

    echo -e "${GREEN}Created: ${command_file}${NC}"
}

# Create commands directory if it doesn't exist
mkdir -p "$COMMANDS_DIR"

# Track created commands
CREATED_COUNT=0

# Create each command
for cmd_def in "${COMMANDS[@]}"; do
    IFS=':' read -r template_file command_name agent description <<< "$cmd_def"
    
    # Check if command already exists
    if [ -f "$COMMANDS_DIR/${command_name}.md" ]; then
        echo -e "${YELLOW}Skipping ${command_name}.md (already exists)${NC}"
        continue
    fi
    
    # Create the command
    create_command "$template_file" "$command_name" "$agent" "$description"
    CREATED_COUNT=$((CREATED_COUNT + 1))
done

echo ""
echo -e "${GREEN}=== Creation Summary ===${NC}"
echo "Created $CREATED_COUNT new sequential commands"
echo "All commands available in: $COMMANDS_DIR"
echo ""

# List all newly created commands
if [ $CREATED_COUNT -gt 0 ]; then
    echo -e "${YELLOW}New Commands Created:${NC}"
    for cmd_def in "${COMMANDS[@]}"; do
        IFS=':' read -r template_file command_name agent description <<< "$cmd_def"
        if [ -f "$COMMANDS_DIR/${command_name}.md" ]; then
            echo "  /${command_name} - ${agent} - ${description}"
        fi
    done
    echo ""
fi

echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Copy new commands to installer templates: cp .claude/commands/*.md installer/templates/claude/commands/"
echo "2. Add .template extensions: cd installer/templates/claude/commands && for f in *.md; do mv \"\$f\" \"\${f}.template\"; done"
echo "3. Archive remaining original task templates"
echo "4. Update agent persona files with new command references"
echo ""
echo -e "${GREEN}Sequential command creation complete!${NC}"