# How to Create New Agents in APM Framework

## Overview

This guide explains how to create new agent personas in the APM (Agentic Persona Mapping) Framework v3.5.0 using the unified JSON-based persona system.

## Quick Start

To create a new agent, you need to:
1. Create a JSON definition file
2. Run the generation script
3. Test the new agent
4. Integrate with slash commands

## Step-by-Step Guide

### Step 1: Create JSON Definition

Create a new file in `/installer/personas/_master/` named `[agent-name].persona.json`:

```json
{
  "_comment": "Master persona definition for [Your Agent Name]",
  "metadata": {
    "id": "agent-id",
    "name": "Full Agent Name",
    "title": "Short Title",
    "version": "3.5.0",
    "description": "Role description and expertise",
    "category": "domain-category",
    "apm_compatibility": "3.2+",
    "claude_compatibility": "native"
  },
  "capabilities": {
    "core": [
      "capability_1",
      "capability_2",
      "capability_3"
    ],
    "parallel_commands": [
      "parallel-command-1",
      "parallel-command-2"
    ],
    "slash_commands": [
      "/agent-id",
      "/alt-command"
    ]
  },
  "configuration": {
    "voice_script": "speakAgentName.sh",
    "voice_script_path": "{{AP_ROOT}}/agents/voice/speakAgentName.sh",
    "working_directories": {
      "primary": "{{PROJECT_ROOT}}/workspace/",
      "secondary": "{{PROJECT_ROOT}}/project_docs/",
      "output": "{{PROJECT_ROOT}}/deliverables/"
    },
    "session_notes_path": "{{SESSION_NOTES_PATH}}",
    "rules_path": "{{RULES_PATH}}",
    "forbidden_paths": [".apm/", "agents/", ".claude/"]
  },
  "behavioral_rules": {
    "research_protocols": {
      "enforce": "NEVER_GUESS_ALWAYS_VERIFY",
      "evidence_required": true
    },
    "core_principles": [
      "Principle 1",
      "Principle 2"
    ],
    "escalation_triggers": [
      "Trigger condition 1",
      "Trigger condition 2"
    ]
  },
  "content_sections": {
    "role_definition": "# Role: [Agent Title] - [Expertise Description]",
    "critical_header": "\\n🔴 **CRITICAL**",
    "research_protocols": "\\n## 🔴 CRITICAL: RESEARCH PROTOCOLS",
    "workspace_boundaries": "\\n## 🚧 WORKSPACE BOUNDARIES",
    "initialization_sequence": "\\n## 🔴 CRITICAL INITIALIZATION SEQUENCE"
  },
  "deployment": {
    "apm": {
      "enabled": true,
      "output_path": "templates/agents/personas/[agent-id].md.template"
    },
    "claude": {
      "enabled": true,
      "output_path": "templates/claude/agents/personas/[agent-id].md.template"
    }
  }
}
```

### Step 2: Define Agent Characteristics

#### Metadata Section
- **id**: Unique identifier (lowercase, no spaces)
- **name**: Full display name
- **title**: Short title for UI display
- **version**: APM version (currently 3.5.0)
- **description**: One-line role description
- **category**: Domain (e.g., "engineering", "product", "design", "quality")

#### Capabilities Section
- **core**: List primary capabilities/skills
- **parallel_commands**: Commands that can run in parallel
- **slash_commands**: Activation commands (e.g., `/agent-id`)

#### Configuration Section
- **voice_script**: Filename for voice notifications
- **working_directories**: Agent's workspace paths
- **forbidden_paths**: Directories agent cannot modify

### Step 3: Create Voice Script

Create a voice script in `/installer/templates/voice/`:

```bash
#!/bin/bash
# speak[AgentName].sh - Voice notifications for [Agent Name]

# Source the base TTS manager
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/speakBase.sh" 2>/dev/null || true

# Agent-specific voice configuration
AGENT_NAME="[Agent Name]"
VOICE_PERSONA="[agent-id]"

# Function to speak
speak_message() {
    local message="$1"
    
    # Call base speak function with agent context
    if declare -f base_speak >/dev/null 2>&1; then
        base_speak "$AGENT_NAME" "$message"
    else
        echo "[$AGENT_NAME] $message"
    fi
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 \"message to speak\""
    exit 1
fi

speak_message "$1"
```

### Step 4: Generate Templates

Run the generation script to create templates from your JSON:

```bash
cd /installer
bash generate-personas.sh
```

This will create:
- APM template at: `/installer/templates/agents/personas/[agent-id].md.template`
- Claude template at: `/installer/templates/claude/agents/personas/[agent-id].md.template`

### Step 5: Create Slash Command

Create a command file in `/installer/templates/claude/commands/[agent-id].md.template`:

```markdown
# /[agent-id] - Activate [Agent Name]

Activates the [Agent Name] persona with expertise in [domain].

## Activation Sequence

When activated with `/[agent-id]`, follow this EXACT sequence:

1. **Initialize with parallel tasks** (5 tasks in one function_calls block):
   - Load agent knowledge base
   - Load project context
   - Initialize session management
   - Setup voice notifications
   - Prepare workspace

2. **Voice announcement**: 
   ```bash
   bash {{SPEAK_[AGENT_ID]}} "[Agent Name] activated. Loading configuration..."
   ```

3. **Present capabilities**:
   - List core competencies
   - Show available commands
   - Display current project status

## Core Capabilities
[List the agent's main capabilities]

## Available Commands
- `/[agent-id]` - Primary activation
- `/parallel-[domain]` - Parallel execution mode

## Working Directories
- Primary: {{PROJECT_ROOT}}/workspace/
- Documentation: {{PROJECT_ROOT}}/project_docs/
```

### Step 6: Add to AP Orchestrator

Update `/installer/templates/agents/personas/ap_orchestrator.md.template` to include your new agent:

1. Add to the agent list
2. Include in coordination protocols
3. Add handoff capabilities

### Step 7: Test the New Agent

After installation, test your agent:

```bash
# Install APM with new agent
./installer/install.sh

# Test activation
/[agent-id]

# Test voice notifications
# Test parallel commands
# Test handoff from orchestrator
```

## Example: Creating a "Security" Agent

Here's a complete example of creating a Security Agent:

### 1. Create security.persona.json

```json
{
  "_comment": "Master persona definition for Security Agent",
  "metadata": {
    "id": "security",
    "name": "Security Agent",
    "title": "Security",
    "version": "3.5.0",
    "description": "Application Security Expert & Vulnerability Assessment Specialist",
    "category": "engineering",
    "apm_compatibility": "3.2+",
    "claude_compatibility": "native"
  },
  "capabilities": {
    "core": [
      "vulnerability_assessment",
      "security_code_review",
      "penetration_testing",
      "compliance_verification",
      "threat_modeling",
      "security_architecture"
    ],
    "parallel_commands": [
      "parallel-security-scan",
      "parallel-vulnerability-assessment"
    ],
    "slash_commands": [
      "/security",
      "/sec"
    ]
  },
  "configuration": {
    "voice_script": "speakSecurity.sh",
    "voice_script_path": "{{AP_ROOT}}/agents/voice/speakSecurity.sh",
    "working_directories": {
      "primary": "{{PROJECT_ROOT}}/security/",
      "secondary": "{{PROJECT_ROOT}}/workspace/",
      "output": "{{PROJECT_ROOT}}/security-reports/"
    },
    "session_notes_path": "{{SESSION_NOTES_PATH}}",
    "rules_path": "{{RULES_PATH}}",
    "forbidden_paths": [".apm/", "agents/", ".claude/"]
  },
  "behavioral_rules": {
    "research_protocols": {
      "enforce": "NEVER_GUESS_ALWAYS_VERIFY",
      "evidence_required": true
    },
    "core_principles": [
      "Security first mindset",
      "Zero trust architecture",
      "Defense in depth",
      "Least privilege principle"
    ]
  },
  "deployment": {
    "apm": {
      "enabled": true,
      "output_path": "templates/agents/personas/security.md.template"
    },
    "claude": {
      "enabled": true,
      "output_path": "templates/claude/agents/personas/security.md.template"
    }
  }
}
```

### 2. Generate Templates

```bash
cd installer
bash generate-personas.sh
```

### 3. Create Slash Command

Create `/installer/templates/claude/commands/security.md.template` with activation instructions.

### 4. Test

```bash
/security
# Should activate Security Agent with voice notification
# Should load security-specific context
# Should present security capabilities
```

## Best Practices

### 1. Naming Conventions
- Use lowercase for IDs: `security`, not `Security`
- Use descriptive names: `security-analyst` better than `sa`
- Keep IDs short for commands: `/sec` easier than `/security-specialist`

### 2. Capability Design
- List 5-8 core capabilities
- Make them specific and measurable
- Align with agent's domain expertise

### 3. Directory Structure
- Create agent-specific workspace directories
- Separate input/output paths
- Respect forbidden paths

### 4. Voice Integration
- Every agent needs a voice script
- Use consistent naming: `speak[AgentName].sh`
- Test voice notifications thoroughly

### 5. Parallel Commands
- Design commands for parallel execution
- Use native sub-agents for 4x performance
- Include synthesis patterns for results

## Integration with Existing System

### Adding to Existing Workflows
1. Update `/ap` orchestrator to recognize new agent
2. Add handoff protocols from other agents
3. Include in sprint coordination if applicable
4. Add to backlog management if relevant

### Command Compatibility
- Ensure slash commands don't conflict
- Follow existing command patterns
- Maintain backward compatibility

### Session Management
- New agents must support session notes
- Follow existing session note format
- Support archive and wrap commands

## Troubleshooting

### Common Issues

#### Agent Not Activating
- Check JSON syntax is valid
- Verify slash command file exists
- Ensure templates were generated
- Check voice script permissions

#### Voice Not Working
- Verify voice script exists
- Check script has execute permissions
- Test base voice system works
- Verify TTS configuration

#### Templates Not Generating
- Check JSON file in correct location
- Verify generator script permissions
- Look for errors in generation output
- Check output directories exist

### Validation Checklist

Before deploying a new agent:

- [ ] JSON definition is valid
- [ ] Templates generated successfully
- [ ] Voice script created and tested
- [ ] Slash command file created
- [ ] Added to orchestrator
- [ ] Tested activation
- [ ] Tested parallel commands
- [ ] Tested handoff protocols
- [ ] Documentation updated
- [ ] Backlog integration (if needed)

## Advanced Topics

### Custom Parallel Commands

Create complex parallel execution patterns:

```json
"parallel_commands": [
  {
    "name": "parallel-security-audit",
    "tasks": 5,
    "coordination": "synthesis",
    "timeout": 300
  }
]
```

### Conditional Capabilities

Define capabilities that depend on context:

```json
"conditional_capabilities": {
  "if_framework": "django",
  "add_capabilities": ["django_security_middleware"]
}
```

### Agent Composition

Create agents that coordinate with others:

```json
"coordination": {
  "delegates_to": ["qa", "dev"],
  "receives_from": ["architect", "pm"],
  "synthesis_pattern": "security-focused"
}
```

## Support

For help creating new agents:
- Review existing persona definitions in `/installer/personas/_master/`
- Check examples in this guide
- Test in development environment first
- Document your new agent thoroughly

---

*APM Framework v3.5.0 - Unified Persona System*