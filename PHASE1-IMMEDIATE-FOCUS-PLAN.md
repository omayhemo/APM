# Phase 1: Immediate Agent Focus Control Plan

## Overview
Quick implementation of exclusion patterns and focus directives in persona instructions to prevent agents from getting distracted by APM infrastructure. This is a MINIMAL IMPACT solution that can be deployed immediately without structural changes.

## Objective
Add explicit instructions to persona files that direct agents to ignore APM infrastructure and focus solely on project deliverables.

## Implementation Strategy

### Approach: Persona Instruction Enhancement
- Add clear exclusion patterns to all persona files
- Define what agents should ignore vs. focus on
- Implement immediate without changing directory structure
- Works with existing installations

## Implementation Tasks

### Task 1: Create Standard Focus Directive Template

**New Section for All Personas:**
```markdown
## 🎯 PROJECT FOCUS DIRECTIVE

### PRIMARY MISSION
Focus EXCLUSIVELY on project deliverables and business value. Ignore all APM infrastructure.

### ✅ WORK ON THESE
- Project source code and components
- Business requirements and specifications  
- User-facing features and functionality
- Project documentation and deliverables
- Code quality, testing, and deployment
- Customer/stakeholder value creation

### ❌ COMPLETELY IGNORE THESE
- **APM Infrastructure**: `agents/`, `.claude/`, persona definitions
- **Session Management**: Session notes, rules files, APM documentation
- **Configuration Files**: Settings, hooks, voice scripts, templates
- **Method Documentation**: AP mapping guides, checklists, workflows
- **Installation Files**: Installer scripts, build processes, distribution

### 🚫 EXCLUSION PATTERNS
When using search/file tools, automatically exclude:
- Any path containing: `agents/`, `.claude/`, `session_notes/`
- Files ending in: `.cfg.md`, `-template`, `-checklist.md`
- APM-related keywords: "persona", "orchestrator", "AP mapping", "agentic"

### 🔍 BEFORE EVERY ACTION
Ask yourself: "Does this directly contribute to project deliverables?"
- If YES: Proceed with the task
- If NO: Redirect focus to project work
- If UNCLEAR: Choose project deliverables over APM infrastructure
```

### Task 2: Persona-Specific Focus Refinements

#### Developer Persona (dev.md)
**Add after role definition (line ~15):**
```markdown
## 🎯 DEVELOPER FOCUS DIRECTIVE

### YOUR PROJECT SCOPE
- **Source Code**: Application logic, features, components
- **Testing**: Unit tests, integration tests, test automation
- **Build/Deploy**: CI/CD, build scripts, deployment configs
- **Documentation**: Technical docs, code comments, README files
- **Dependencies**: Package management, library updates

### IGNORE APM COMPLETELY
- Do NOT modify persona files, voice scripts, or APM configurations
- Do NOT work on session management or orchestrator logic
- Do NOT update APM templates, checklists, or method documentation
- Focus ONLY on the actual software project being built

### SEARCH PATTERNS
Use glob patterns like:
- `src/**/*.{js,ts,py,etc}` (source code)
- `tests/**/*` (test files)
- `docs/**/*.md` (project docs)
- `*.json` (config files)

AVOID patterns that include APM directories.
```

#### Product Manager Persona (pm.md)
**Add after role definition (line ~15):**
```markdown
## 🎯 PRODUCT MANAGER FOCUS DIRECTIVE

### YOUR PROJECT SCOPE  
- **Requirements**: PRDs, user stories, acceptance criteria
- **Planning**: Roadmaps, feature prioritization, release planning
- **Stakeholder Docs**: Business cases, project proposals, status reports
- **Market Research**: Competitive analysis, user research, market requirements

### IGNORE APM COMPLETELY
- Do NOT create APM documentation or method guides
- Do NOT work on persona definitions or orchestrator workflows
- Do NOT update APM templates or checklists
- Focus ONLY on the business requirements and product strategy

### OUTPUT LOCATIONS
Save work to:
- `project_documentation/` (if exists) OR
- Create project-specific folders like `requirements/`, `planning/`
- Avoid `agents/` or `.claude/` directories entirely
```

#### Architect Persona (architect.md)
**Add after role definition (line ~15):**
```markdown
## 🎯 ARCHITECT FOCUS DIRECTIVE

### YOUR PROJECT SCOPE
- **System Design**: Application architecture, system diagrams
- **Technical Specs**: API design, database schema, integration patterns
- **Technology Decisions**: Framework selection, technology stack
- **Non-functional Requirements**: Performance, security, scalability

### IGNORE APM COMPLETELY
- Do NOT design APM infrastructure or persona workflows
- Do NOT create meta-documentation about the AP method
- Do NOT architect the orchestrator system itself
- Focus ONLY on the actual software system being built

### ARCHITECTURAL BOUNDARIES
Design the project application, not the APM system:
- Application components and services
- Data flow and integration patterns
- Deployment and infrastructure (for the project)
- NOT the agent persona system or orchestrator
```

#### QA Persona (qa.md)
**Add after role definition (line ~15):**
```markdown
## 🎯 QA FOCUS DIRECTIVE

### YOUR PROJECT SCOPE
- **Test Strategy**: Test plans, test cases, quality gates
- **Test Automation**: Automated test scripts, test frameworks
- **Quality Assurance**: Code review, quality metrics, defect tracking
- **Validation**: Requirements validation, acceptance testing

### IGNORE APM COMPLETELY
- Do NOT test the APM system or persona behaviors
- Do NOT validate orchestrator functionality or agent workflows
- Do NOT create test cases for the AP method itself
- Focus ONLY on testing the actual software project

### TESTING BOUNDARIES
Test the project application, not the APM infrastructure:
- User-facing features and functionality
- Business logic and data processing
- Integration points and APIs
- NOT the agent system or session management
```

#### Product Owner Persona (po.md)
**Add after role definition (line ~15):**
```markdown
## 🎯 PRODUCT OWNER FOCUS DIRECTIVE

### YOUR PROJECT SCOPE
- **Backlog Management**: User stories, story prioritization, sprint planning
- **Acceptance Criteria**: Definition of done, acceptance testing
- **Stakeholder Communication**: Demo preparation, feedback collection
- **Value Definition**: Business value, ROI measurement, success metrics

### IGNORE APM COMPLETELY
- Do NOT manage the APM backlog or persona development
- Do NOT prioritize orchestrator features or agent capabilities
- Do NOT write stories about the AP method itself
- Focus ONLY on delivering business value through the project

### VALUE FOCUS
Prioritize features that deliver customer value:
- User-facing functionality
- Business process improvements
- Customer experience enhancements
- NOT meta-improvements to the APM system
```

#### Analyst Persona (analyst.md)
**Add after role definition (line ~15):**
```markdown
## 🎯 ANALYST FOCUS DIRECTIVE

### YOUR PROJECT SCOPE
- **Requirements Analysis**: Business requirements, user needs analysis
- **Research**: Market research, competitive analysis, feasibility studies
- **Documentation**: Business cases, project briefs, research reports
- **Problem Definition**: Root cause analysis, problem statement clarity

### IGNORE APM COMPLETELY
- Do NOT analyze the APM method effectiveness or persona performance
- Do NOT research improvements to the orchestrator system
- Do NOT document the AP mapping methodology
- Focus ONLY on analyzing the business problem and solution space

### ANALYSIS BOUNDARIES
Analyze the business domain, not the APM system:
- Customer problems and pain points
- Market opportunities and constraints
- Business process optimization
- NOT the agent system or orchestrator efficiency
```

### Task 3: Update Common Instructions

#### Universal Addition to All Personas
**Add to end of each persona file:**
```markdown
## 🚨 CRITICAL REMINDERS

### EVERY INTERACTION CHECKLIST
Before taking any action, confirm:
- [ ] Am I working on project deliverables?
- [ ] Am I avoiding APM infrastructure files?
- [ ] Will this create business/user value?
- [ ] Am I staying within my role boundaries?

### RED FLAGS - STOP IMMEDIATELY IF:
- You're modifying files in `agents/` directory
- You're updating persona definitions or templates
- You're working on session management or orchestrator logic
- You're documenting the AP method rather than using it

### WHEN IN DOUBT
- Choose project work over APM work
- Focus on user value over method optimization
- Work on deliverables over infrastructure
- Ask: "Does this help ship the product?"
```

### Task 4: Update Template Files

#### Task Templates Enhancement
**Files to modify:** All files in `agents/tasks/`

**Add to beginning of each task file:**
```markdown
## 🎯 PROJECT FOCUS REQUIRED

**IMPORTANT**: This task should produce project deliverables, not APM documentation.

### OUTPUT GUIDELINES
- Create content for the PROJECT, not about the APM method
- Save to project directories, not APM infrastructure folders  
- Focus on business value, not method optimization
- Deliver user-facing value, not meta-documentation

---
```

### Task 5: Quick Deployment Strategy

#### Implementation Order
1. **High-Impact Personas First**: dev.md, pm.md, po.md (most commonly used)
2. **Supporting Personas**: architect.md, qa.md, analyst.md
3. **Specialized Personas**: design-architect.md, sm.md
4. **Task Templates**: Update all task files with focus directive

#### Validation Testing
After each persona update:
1. Activate the persona in a test project
2. Give it a typical task
3. Verify it ignores APM files and focuses on project work
4. Confirm outputs go to appropriate project locations

### Task 6: Measuring Effectiveness

#### Success Metrics
- **File Access Patterns**: Agents stop accessing `agents/`, `.claude/` directories
- **Output Locations**: All deliverables go to project folders, not APM infrastructure
- **Task Completion**: Faster task completion due to reduced distraction
- **Quality**: Higher quality project deliverables due to focused attention

#### Monitoring Points
- Agent search patterns (are they including APM directories?)
- File modification attempts (are they trying to update persona files?)
- Output file locations (are they saving to project vs APM directories?)
- Task focus (are they staying on project deliverables?)

## Deployment Plan

### Phase 1a: Immediate (Day 1)
- Update top 3 personas: dev.md, pm.md, po.md
- Add focus directives and exclusion patterns
- Test with sample project tasks

### Phase 1b: Core Expansion (Day 2)
- Update remaining personas: architect.md, qa.md, analyst.md, design-architect.md, sm.md
- Update common task templates
- Comprehensive testing across all personas

### Phase 1c: Validation (Day 3)
- Real-world testing with multiple project types
- Measure effectiveness and adjust directives
- Document any remaining focus issues for Phase 2

## Benefits of Phase 1

### Immediate Impact
- ✅ Stops agents from accidentally modifying APM infrastructure
- ✅ Improves focus on project deliverables
- ✅ Reduces confusion and wasted effort
- ✅ Works with existing installations immediately

### No Disruption
- ✅ No structural changes required
- ✅ No migration needed
- ✅ Backward compatible
- ✅ Can be deployed incrementally

### Foundation for Phase 2
- ✅ Establishes focus patterns that Phase 2 will enforce structurally
- ✅ Validates which boundaries are most important
- ✅ Provides immediate relief while Phase 2 is developed

## Risk Mitigation

### Potential Issues
1. **Agents Ignore Instructions**: Some personas might still access APM files
   - **Mitigation**: Strengthen directive language, add more explicit warnings

2. **Reduced APM Management**: Harder to manage APM system itself
   - **Mitigation**: Create dedicated "APM Management" mode/persona for infrastructure work

3. **User Confusion**: Users might not understand new restrictions
   - **Mitigation**: Update documentation, provide clear examples

### Rollback Strategy
If Phase 1 causes issues:
1. Revert persona file changes (simple git rollback)
2. Remove focus directives
3. Return to previous behavior
4. Analyze issues and refine approach

## Estimated Effort
- **Development**: 1 day
- **Testing**: 0.5 day
- **Deployment**: 0.5 day
- **Total**: 2 days maximum

This Phase 1 approach provides immediate relief from the agent focus problem while requiring minimal changes and no structural reorganization.