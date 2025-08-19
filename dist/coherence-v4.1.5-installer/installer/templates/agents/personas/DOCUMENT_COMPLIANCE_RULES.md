# 🔴 CRITICAL DOCUMENT COMPLIANCE RULES

**ALL AGENTS MUST FOLLOW THESE RULES - NO EXCEPTIONS**

## Document Naming Standards

### Epic Documents
- **REQUIRED Pattern**: `EPIC-{id}-{title}.md`
- **ID Format**: Three digits, zero-padded (001, 002, etc.)
- **Location**: `{{PROJECT_ROOT}}/project_docs/planning/epics/`
- **Example**: `EPIC-006-interactive-engagement.md`
- **VIOLATIONS**: 
  - ❌ `interactive-engagement-platform-business-case.md`
  - ❌ `planning-epic-1-feature.md`
  - ❌ `my-planning-epic.md`

### Story Documents
- **REQUIRED Pattern**: `STORY-{id}-{title}.md`
- **ID Format**: Three digits, zero-padded (001, 002, etc.)
- **Location**: `{{PROJECT_ROOT}}/project_docs/planning/planning-stories/`
- **Example**: `STORY-023-user-authentication.md`

### Test Plans
- **REQUIRED Pattern**: `TEST-PLAN-{date}-{seq}.md`
- **Date Format**: YYYY-MM-DD
- **Location**: `{{PROJECT_ROOT}}/project_docs/qa/test-plans/`
- **Example**: `TEST-PLAN-2025-01-08-001.md`

### Reports
- **REQUIRED Pattern**: `{date}-{title}.md`
- **Location**: `{{PROJECT_ROOT}}/project_docs/reports/`
- **Example**: `2025-01-08-PERFORMANCE-ANALYSIS.md`

### PRDs (Product Requirements Documents)
- **REQUIRED Pattern**: `{title}-PRD.md`
- **Location**: `{{PROJECT_ROOT}}/project_docs/planning-requirements/`
- **Example**: `syncdeck-interactive-PRD.md`

## Enforcement Mechanisms

### 1. Agent Self-Check (BEFORE creating any document)
```bash
# Check existing documents for next ID
ls {{PROJECT_ROOT}}/project_docs/planning/epics/EPIC-*.md | tail -1
# Extract last ID and increment
```

### 2. Document Registry Consultation
```bash
# Always check the registry for correct patterns
cat {{AP_ROOT}}/config/document-registry.json
```

### 3. Validation Before Write
- **NEVER** create a document with an arbitrary name
- **ALWAYS** verify the pattern matches planning-requirements
- **ALWAYS** place in the correct directory

## Consequences of Non-Compliance

1. **Document will be auto-corrected** by the Document Location Enforcer
2. **Agent performance will be logged** as non-compliant
3. **Orchestrator will reject** the work and require correction

## Agent-Specific Responsibilities

### Product Owner (PO)
- **PRIMARY**: Creating and maintaining epics and planning-stories
- **MUST**: Always use correct EPIC-XXX and STORY-XXX patterns
- **OWNS**: backlog.md (singleton document)

### Project Manager (PM)
- **PRIMARY**: Creating project reports and status updates
- **MUST**: Follow date-based naming for reports
- **COLLABORATES**: With PO on planning-epic/story creation

### QA Agent
- **PRIMARY**: Creating test plans and test results
- **MUST**: Use TEST-PLAN and TEST-RESULT patterns
- **LOCATION**: Always in qa/ subdirectories

### Architect
- **PRIMARY**: Architecture decision records (ADRs)
- **PATTERN**: `ADR-{seq}-{title}.md`
- **LOCATION**: `{{PROJECT_ROOT}}/project_docs/planning-architecture/decisions/`

## Validation Checklist

Before creating ANY document, verify:
- [ ] Pattern matches the document type planning-requirements
- [ ] ID number is correctly sequenced
- [ ] Location is in the correct directory
- [ ] Filename uses correct case (UPPERCASE prefixes)
- [ ] No arbitrary naming used

## Examples of Correct Usage

```bash
# Creating an planning-epic (PO agent)
filename="EPIC-006-payment-integration.md"
location="{{PROJECT_ROOT}}/project_docs/planning/epics/"
full_path="${location}${filename}"

# Creating a story (PO agent)
filename="STORY-042-user-login-flow.md"
location="{{PROJECT_ROOT}}/project_docs/planning/planning-stories/"
full_path="${location}${filename}"

# Creating a test plan (QA agent)
filename="TEST-PLAN-2025-01-08-003.md"
location="{{PROJECT_ROOT}}/project_docs/qa/test-plans/"
full_path="${location}${filename}"
```

## Document Location Enforcer Integration

The Document Location Enforcer will:
1. **Detect** document type from content if filename is wrong
2. **Correct** the filename to match required pattern
3. **Move** the document to the correct location
4. **Log** the correction for audit purposes

However, agents should NOT rely on this - they should get it right the first time!

---

**Remember**: Following these standards is NOT optional. It's a critical part of maintaining project organization and enabling effective collaboration across all agents.