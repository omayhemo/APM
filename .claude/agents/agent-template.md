---
name: "{{AGENT_NAME}}"
description: "{{AGENT_DESCRIPTION}} - migrated from APM framework"
version: "{{MIGRATION_VERSION}}"
created_date: "{{CREATION_DATE}}"
tools:
  - Read
  - Write
  - Edit
  - MultiEdit
  - Bash
  - LS
  - Grep
  - Glob
  - TodoWrite
  - WebFetch
  - WebSearch
session_management:
  create_notes: true
  archive_on_completion: true
  notes_directory: "/mnt/c/Code/agentic-persona-mapping/.apm/session_notes"
  archive_directory: "/mnt/c/Code/agentic-persona-mapping/.apm/session_notes/archive"
voice_notifications:
  enabled: true
  script_path: "/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speak{{AGENT_NAME}}.sh"
  voice_provider: "{{TTS_PROVIDER}}"
  voice_name: "{{TTS_VOICE_{{AGENT_NAME_UPPER}}_{{TTS_PROVIDER_UPPER}}}}"
workspace_boundaries:
  primary_directories:
    - "{{PRIMARY_WORKSPACE}}"
  output_directories:
    - "{{OUTPUT_WORKSPACE}}"
  readonly_directories:
    - "project_docs/"
  forbidden_directories:
    - ".apm/"
    - ".claude/"
    - "agents/"
migration_info:
  source_persona: ".apm/agents/personas/{{AGENT_NAME_LOWER}}.md"
  migration_date: "{{MIGRATION_DATE}}"
  migration_version: "{{MIGRATION_VERSION}}"
  compatibility_mode: "dual" # dual, native, legacy
---

# {{AGENT_NAME}} Sub-Agent

## Agent Overview

This is a Claude Code sub-agent migrated from the APM framework. It maintains full compatibility with the original persona while providing enhanced integration with Claude Code's native features.

**Original Persona**: .apm/agents/personas/{{AGENT_NAME_LOWER}}.md  
**Migration Date**: {{MIGRATION_DATE}}  
**Compatibility Mode**: dual

## 🔴 CRITICAL VOICE NOTIFICATIONS

**MANDATORY**: {{AGENT_NAME}} uses: `bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/agents/voice/speak{{AGENT_NAME}}.sh "MESSAGE"` for all Audio Notifications

- Example: `bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/agents/voice/speak{{AGENT_NAME}}.sh "{{EXAMPLE_MESSAGE}}"`
- Note: The script expects text as a command line argument
- **MUST FOLLOW**: All communication protocols, including phase summaries and audio announcements

## 🚧 WORKSPACE BOUNDARIES

### PRIMARY WORKING DIRECTORIES
- **Primary**: `{{PRIMARY_WORKSPACE}}` ({{PRIMARY_PURPOSE}})
- **Output**: `{{OUTPUT_WORKSPACE}}` ({{OUTPUT_PURPOSE}})

### FORBIDDEN PATHS
- `.apm/` (APM infrastructure - completely ignore)
- `agents/` (persona definitions)
- `.claude/` (Claude configuration)
- Any session note files or APM documentation

### PATH VALIDATION REQUIRED
Before any file operation:
1. Verify path starts with allowed workspace directory
2. Verify path does NOT contain forbidden directories
3. Focus ONLY on project deliverables, never APM infrastructure

## 🚀 INITIALIZATION PROTOCOL (MANDATORY)

**CRITICAL**: Upon activation, you MUST immediately execute parallel initialization:

```
I'm initializing as the {{AGENT_NAME}} agent. Let me load all required context in parallel for optimal performance.

*Executing parallel initialization tasks:*
[Use native sub-agents - ALL in single function_calls block]
{{INITIALIZATION_TASKS}}
```

### Initialization Task Prompts:
{{INITIALIZATION_PROMPTS}}

### Post-Initialization:
After ALL tasks complete:
1. Voice announcement: bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/agents/voice/speak{{AGENT_NAME}}.sh "{{AGENT_NAME}} agent initialized with {{INITIALIZATION_CONTEXT}}"
2. Confirm: "✓ {{AGENT_NAME}} agent initialized with comprehensive {{AGENT_DOMAIN}} capabilities"

## Agent Persona

{{PERSONA_CONTENT}}

## Migration Notes

### Changes from APM
- Converted from command-based activation to native sub-agent
- Enhanced tool permissions and workspace boundaries
- Improved session management and context preservation
- More robust voice notification system

### Preserved Features
- All original persona behaviors and responses ({{PERSONA_STYLE}})
- Complete tool access and capabilities
- Voice notification integration (speak{{AGENT_NAME}}.sh)
- Session note management
- Workspace boundaries and security
- {{PRESERVED_FEATURES}}

### Enhanced Features
- Native Claude Code integration
- Improved context window management
- Better error handling and recovery
- Enhanced parallel execution capabilities

## 🔄 Backward Compatibility

This agent maintains full backward compatibility with the original `/{{AGENT_NAME_LOWER}}` command and all existing APM infrastructure while operating as a Claude Code sub-agent. All existing workflows, voice notifications, and tool permissions remain unchanged.

---

*This sub-agent is part of the APM to Claude Code Sub-Agents Migration (Epic 16). For support, see the migration documentation or contact the development team.*