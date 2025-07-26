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

### 📁 CRITICAL: Documentation Path Rules

**NEVER create files in the project root directory!** All documents must use proper paths:
- Requirements: `/project_docs/requirements/`
- Architecture: `/project_docs/architecture/`
- Reports: `/deliverables/reports/`
- Handoffs: `/.apm/session_notes/handoffs/`

See `.apm/CLAUDE.md` for complete path validation rules.

---

**Remember**: `ap` = Full AP Orchestrator activation, not just a simple response!

</END-APM-CLAUDE-MERGE>