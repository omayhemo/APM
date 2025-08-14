# APM Claude.md Template

<BEGIN-APM-CLAUDE-MERGE>

## 🚀 AGENTIC PERSONA MAPPING (APM)

---

### 🔴 CRITICAL COMMAND 🔴

**When the user types ANY of these as their first message:**
- `ap`
- `ap_orchestrator`
- `agents`
- `apm`

**→ IMMEDIATELY execute the `/ap_orchestrator` command**

This launches the full AP Orchestrator initialization sequence, including:
- Loading all APM infrastructure from `.apm/` directory
- Initializing all agent personas
- Setting up session management
- Presenting orchestrator capabilities

---

### APM Framework Structure

The Agentic Persona Mapping system provides:
- **AP Orchestrator**: Central coordination and delegation
- **Specialized Agents**: Analyst, PM, Architect, Developer, QA, and more
- **Session Management**: Intelligent context preservation and handoffs
- **Collaborative Workflow**: Seamless transitions between personas

All APM components are located in the `.apm/` directory.

---

**Remember**: `ap` = Full AP Orchestrator activation, not just a simple response!

</END-APM-CLAUDE-MERGE>

# 🚨 CRITICAL FILE PLACEMENT RULES 🚨

## Root Directory File Restrictions

**NEVER save files to the root directory unless EXPLICITLY instructed by the user.**

### What This Means:
- **Root directories** include:
  - Project root (e.g., `/mnt/c/Code/agentic-persona-mapping/`)
  - `/project_docs/` root
  - Any main folder root without subdirectories

### Correct File Placement:

#### ❌ WRONG - Never do this:
```
/mnt/c/Code/agentic-persona-mapping/my-analysis.md
/mnt/c/Code/agentic-persona-mapping/todo-list.md
/project_docs/meeting-notes.md
/project_docs/new-report.md
```

#### ✅ CORRECT - Always use appropriate subdirectories:
```
/project_docs/reports/my-analysis.md
/project_docs/planning/todo-list.md
/project_docs/meetings/meeting-notes.md
/project_docs/reports/new-report.md
```

### Document Type Location Guide:

| Document Type | Correct Location | Example |
|--------------|------------------|---------|
| Reports/Analysis | `/project_docs/reports/` | `analysis-2025-01-14.md` |
| Meeting Notes | `/project_docs/meetings/` | `2025-01-14-standup.md` |
| Plans/Strategies | `/project_docs/planning/` | `implementation-plan.md` |
| Architecture Docs | `/project_docs/architecture/` | `system-design.md` |
| Test Plans | `/project_docs/qa/test-plans/` | `test-plan-2025-01-14.md` |
| Scripts | `/project_docs/scripts/` | `deploy.sh` |
| Changelogs | `/project_docs/changelogs/` | `CHANGELOG-v1.0.0.md` |
| Release Notes | `/project_docs/release-notes/` | `RELEASE-NOTES-v1.0.0.md` |
| Requirements | `/project_docs/requirements/` | `user-requirements.md` |
| Session Notes | `/.apm/session_notes/` | `2025-01-14-session.md` |
| Epics | `/project_docs/planning/epics/` | `EPIC-001-feature.md` |
| Stories | `/project_docs/planning/stories/` | `STORY-001-task.md` |
| Backlog | `/project_docs/planning/` | `backlog.md` |

### Exceptions (ONLY these files allowed in root):
- `README.md` - Main project documentation
- `index.md` - Documentation index
- `LICENSE.md` - License file
- `LICENSE` - License file (no extension)
- `CONTRIBUTING.md` - Contribution guidelines
- `CODE_OF_CONDUCT.md` - Code of conduct
- `CLAUDE.md` - Claude AI instructions
- Configuration files (`.gitignore`, `package.json`, `.env`, etc.)

### When User Says "Save this" or "Create a document":
1. **ASK** where they want it saved if not specified
2. **SUGGEST** an appropriate subdirectory based on content type
3. **NEVER** assume root directory placement

### Examples of User Instructions:

**Ambiguous instruction**: "Create a report about the analysis"
**Your response**: "I'll create this report in `/project_docs/reports/`. What would you like to name it?"

**Clear instruction**: "Save this to the root directory as URGENT.md"
**Your response**: Create `/mnt/c/Code/agentic-persona-mapping/URGENT.md` (only because explicitly requested)

**Ambiguous instruction**: "Document these findings"
**Your response**: "I'll save these findings to `/project_docs/reports/findings-[date].md`. Is that location acceptable?"

### Why This Matters:
- Keeps the root directory clean and organized
- Follows the document registry rules
- Makes files easier to find
- Prevents clutter
- Maintains professional project structure
- Ensures consistency across all agents and users

### Before Creating ANY File:
1. **Check** if an appropriate subdirectory exists
2. **Create** the subdirectory if needed (use mkdir -p)
3. **Place** the file in the correct location
4. **Update** any relevant indexes or registries
5. **Verify** the file placement follows document registry rules

### Script Files Special Rules:
- **ALL script files** (`.sh`, `.py`, `.js`, etc.) MUST go in `/project_docs/scripts/` or subdirectories
- **NO scripts** in root directory (except configuration files like `package.json`)
- **Organize** scripts in subdirectories by purpose (e.g., `/scripts/deploy/`, `/scripts/test/`)

### Emergency Override:
If the user explicitly says phrases like:
- "Put it in the root"
- "Save to the main directory"
- "I want this at the top level"
- "Override the rules and put it in root"

Then and ONLY then, place the file in the root directory with a comment acknowledging the explicit override.

**Remember**: A clean, organized project structure is a sign of professional development practices. Always maintain proper file organization unless explicitly overridden by the user.