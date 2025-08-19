# Coherence Core Orchestrator Commands
## Central Control and Coordination with Unified Context Engineering

The Orchestrator commands form the backbone of the Coherence framework, providing central control, session management, and agent coordination capabilities with advanced unified context engineering.

---

## 🎯 `/coherence` or `/coherence_orchestrator`
### Launch Coherence Orchestrator - Central Command Hub with Unified Context Engineering

**Purpose**: Activates the central Coherence Orchestrator persona that coordinates all other agents and provides access to the complete Coherence ecosystem with unified context engineering.

**Legacy Compatibility**: Also responds to `/ap` and `/ap_orchestrator` for backward compatibility.

**What it does**:
1. Initializes Coherence framework with unified context engineering
2. Loads all agent configurations and personas with context preservation
3. Establishes session management with intelligent context flow
4. Provides central coordination for multi-agent workflows with orchestrated intelligence
5. Executes 5 parallel initialization tasks for rapid startup with context synchronization

**Initialization Sequence**:
- Lists and reads session notes for context continuity
- Lists rules directory for behavioral guidelines
- Creates timestamped session note with unified context
- Executes voice announcement
- Runs 5 parallel initialization tasks with context engineering:
  - Load Coherence knowledge base
  - Load orchestrator configuration with unified context
  - Load communication standards and context flow protocols
  - Check project documentation with intelligent indexing
  - Catalog available personas with context mapping

**Options**:
- `--silent` - Skip voice announcements
- `--resume` - Continue from last session state
- `--status` - Show current system status

**Suggested Use Cases**:
- Starting any Coherence work session with unified context
- Coordinating multi-agent workflows with orchestrated intelligence
- Getting overview of project status with intelligent analysis
- Accessing any specialized persona with context preservation
- Managing complex development tasks with seamless context flow

**Example**:
```bash
# Basic activation
/coherence

# Resume previous session with context
/coherence --resume

# Check status without full activation
/coherence --status

# Legacy compatibility
/ap  # Still works for backward compatibility
```

**Output**: 
- Voice notification of activation
- System initialization confirmation
- Available personas and commands menu
- Current project status summary

---

## 🔄 `/handoff`
### Direct Agent Transition

**Purpose**: Seamlessly transfer control from current agent to another without session compaction.

**What it does**:
1. Saves current agent's context
2. Creates handoff note with transition details
3. Activates target agent with full context
4. Preserves working state and progress

**Parameters**:
- `<target_persona>` - Required: The agent to hand off to (analyst, pm, dev, qa, etc.)

**Options**:
- `--notes="text"` - Include specific handoff notes
- `--priority=high|normal|low` - Set priority for next agent
- `--task="description"` - Specify task for target agent

**Suggested Use Cases**:
- Transitioning between development phases
- Moving from planning to implementation
- Shifting from coding to testing
- Escalating specialized tasks

**Example**:
```bash
# Basic handoff
/handoff dev

# With context notes
/handoff qa --notes="Focus on API endpoint testing"

# With specific task
/handoff architect --task="Review microservices design"
```

**Output**:
- Handoff confirmation
- Context transfer summary
- Target agent activation
- Voice notification from new agent

---

## 🔀 `/switch`
### Agent Switching with Context Compaction

**Purpose**: Switch to another agent while compacting current session for efficiency.

**What it does**:
1. Compacts current session notes
2. Archives completed work
3. Summarizes key decisions and progress
4. Activates target agent with clean context
5. Optimizes memory usage

**Parameters**:
- `<target_persona>` - Required: The agent to switch to

**Options**:
- `--compact-level=full|summary|minimal` - Compaction depth
- `--archive=true|false` - Archive current session
- `--carry-forward="items"` - Specific items to preserve

**Suggested Use Cases**:
- Major phase transitions
- Completing one epic and starting another
- End of sprint transitions
- Memory optimization for long sessions

**Example**:
```bash
# Basic switch
/switch pm

# Full compaction and archive
/switch architect --compact-level=full --archive=true

# Preserve specific context
/switch dev --carry-forward="security-requirements,api-design"
```

**Output**:
- Session compaction summary
- Archive location
- Context preserved
- New agent activation confirmation

---

## 📝 `/wrap`
### Wrap Up Current Session

**Purpose**: Properly conclude current work session with comprehensive documentation.

**What it does**:
1. Summarizes all session activities
2. Documents decisions and outcomes
3. Lists incomplete tasks for next session
4. Archives session notes
5. Creates handoff documentation
6. Updates project status

**Options**:
- `--summary-level=detailed|standard|brief` - Summary detail
- `--create-report=true|false` - Generate session report
- `--update-backlog=true|false` - Update backlog status
- `--notify-team=true|false` - Send team notifications

**Suggested Use Cases**:
- End of work day
- Completing major milestone
- Before switching projects
- Team handoffs
- Sprint completion

**Example**:
```bash
# Basic wrap
/wrap

# Detailed wrap with report
/wrap --summary-level=detailed --create-report=true

# Sprint end wrap
/wrap --update-backlog=true --notify-team=true
```

**Output**:
- Session summary
- Archived note location
- Incomplete tasks list
- Next steps recommendations
- Session metrics

---

## 📂 `/session-note-setup`
### Initialize Session Notes Structure

**Purpose**: Set up the session management infrastructure for APM framework.

**What it does**:
1. Creates session notes directory structure
2. Initializes rules directory
3. Sets up archive folders
4. Creates initial templates
5. Configures auto-archival settings

**Options**:
- `--reset=true|false` - Reset existing structure
- `--template=standard|extended|minimal` - Note template type
- `--auto-archive-days=N` - Auto-archive after N days
- `--backup=true|false` - Create backup before setup

**Suggested Use Cases**:
- First time APM installation
- Recovering from corrupted session structure
- Standardizing team session management
- Migrating to new project

**Example**:
```bash
# Initial setup
/session-note-setup

# Reset with extended template
/session-note-setup --reset=true --template=extended

# Configure auto-archival
/session-note-setup --auto-archive-days=30
```

**Output**:
- Directory structure created
- Configuration summary
- Template locations
- Setup confirmation

---

## 👥 `/personas`
### List Available Personas

**Purpose**: Display all available agent personas with their capabilities and specializations.

**What it does**:
1. Lists all installed personas
2. Shows persona descriptions
3. Displays available commands per persona
4. Indicates parallel capabilities
5. Shows activation status

**Options**:
- `--detailed=true|false` - Show detailed descriptions
- `--filter=category` - Filter by category (dev, qa, pm, etc.)
- `--show-commands=true|false` - List commands per persona
- `--active-only=true|false` - Show only active personas

**Suggested Use Cases**:
- Discovering available capabilities
- Learning about agent specializations
- Planning workflow sequences
- Training new team members

**Example**:
```bash
# List all personas
/personas

# Detailed view with commands
/personas --detailed=true --show-commands=true

# Filter development personas
/personas --filter=dev

# Show active personas
/personas --active-only=true
```

**Output**:
- Persona list with icons
- Specialization descriptions
- Command counts
- Parallel execution capabilities
- Current activation status

---

## 🔧 Advanced Orchestrator Features

### Session Context Management
The Orchestrator maintains context across all agent transitions:
- **Session Notes**: Markdown files with timestamps
- **Decision Log**: Important choices and rationale
- **Progress Tracking**: Task completion status
- **Handoff Notes**: Inter-agent communication

### Parallel Coordination
When managing parallel operations:
- Launches native sub-agents
- Monitors execution status
- Aggregates results
- Resolves conflicts
- Manages dependencies

### Workflow Optimization
The Orchestrator optimizes workflows by:
- Suggesting next best agent
- Identifying bottlenecks
- Recommending parallel execution
- Predicting task dependencies

---

## 💡 Best Practices

### Session Management
1. Always start with `/ap` for full context
2. Use `/handoff` for quick transitions
3. Use `/switch` when changing major phases
4. Always `/wrap` at session end

### Context Preservation
1. Document decisions in session notes
2. Include rationale for agent transitions
3. Summarize before handoffs
4. Archive completed work promptly

### Performance Optimization
1. Use parallel commands when possible
2. Compact sessions regularly
3. Archive old sessions
4. Clear completed tasks

---

## 🎯 Common Workflows

### Project Initialization
```bash
/coherence
/session-note-setup
/personas --detailed=true
/handoff analyst
```

### Phase Transition
```bash
/wrap --summary-level=detailed
/switch pm --compact-level=full
```

### Multi-Agent Coordination
```bash
/coherence
/parallel-sprint --agents=4
/wrap --update-backlog=true
```

---

## 📊 Command Performance Metrics

| Command | Initialization Time | Memory Usage | Context Load |
|---------|-------------------|--------------|--------------|
| `/ap` | 2.3s (5 parallel tasks) | 45MB | Full |
| `/handoff` | 0.8s | 12MB | Preserved |
| `/switch` | 1.5s | 8MB | Compacted |
| `/wrap` | 1.2s | 5MB | Archived |
| `/session-note-setup` | 0.5s | 2MB | New |
| `/personas` | 0.3s | 1MB | Minimal |

---

## 🚨 Troubleshooting

### Common Issues

**Session note conflicts**:
- Solution: Use `/session-note-setup --reset=true`

**Agent activation failures**:
- Solution: Check with `/coherence --status` first

**Context loss during handoff**:
- Solution: Use `--notes` parameter explicitly

**Memory issues with long sessions**:
- Solution: Use `/switch` with `--compact-level=full`

---

## 🔗 Related Commands

- **Persona Commands**: `/analyst`, `/dev`, `/qa`, etc.
- **Parallel Commands**: `/parallel-*` commands with orchestrated intelligence
- **Project Commands**: `/planning-project-brief`, `/planning-prd`, `/planning-epic` with unified context
- **Utility Commands**: `/version`, `/distribution-build`

---

*Coherence Core Orchestrator Commands - v4.1.0*
*Native Sub-Agent Architecture with Unified Context Engineering*
*Legacy compatibility maintained for `/ap` commands*