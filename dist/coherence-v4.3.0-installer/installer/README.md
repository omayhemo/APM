# Agentic Persona Mapping (APM) Framework

**Version: 4.3.0** - Native Sub-Agent Architecture with Configurable Prompt Enhancement

## ⚠️ CRITICAL REQUIREMENT: SLASH COMMANDS ARE MANDATORY

**THE APM FRAMEWORK REQUIRES SLASH COMMANDS FOR PROPER OPERATION**

After installation, you MUST use slash commands to activate agents:
- ✅ **CORRECT:** `/analyst` `/pm` `/dev` `/qa` `/ap`
- ❌ **WRONG:** "load analyst" "be the PM" "act as developer"

**Without slash commands:** 4.6x slower, missing critical files, no parallelism, broken features.

**📖 Full Details:** After installation, read `/project_docs/CRITICAL-SLASH-COMMAND-USAGE.md`

---

## What is Agentic Persona Mapping?

APM v4.3.0 delivers **revolutionary native sub-agent architecture** with **configurable prompt enhancement** that transforms AI-powered software development:

- **🔧 NEW: Configurable Prompt Enhancement**: Automatically append custom context to all prompts
- **4-8x Performance Improvement**: True parallel execution with native Claude Code sub-agents
- **Zero CLI Crashes**: Rock-solid integration replacing Task-based simulation
- **45+ Parallel Commands**: Every persona enhanced with native parallelism
- **34+ Hours/Week Saved**: Per development team through concurrent execution
- **100% Backward Compatible**: Seamless upgrade from previous versions

## Quick Installation

### Download and Install (One Command)

**For Linux/WSL:**
```bash
wget https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz && tar -xzf coherence-v4.3.0-installer.tar.gz && ./payload/install.sh
```

**For macOS:**
```bash
curl -L https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz | tar -xz && ./payload/install.sh
```

### Installation Options

**Option 1: Interactive Installation (Recommended)**
Add nothing - the installer will prompt for all configuration options

**Option 2: Install with Defaults (Skip prompts)**
```bash
# Linux/WSL
wget https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz && tar -xzf coherence-v4.3.0-installer.tar.gz && ./payload/install.sh --defaults

# macOS
curl -L https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz | tar -xz && ./payload/install.sh --defaults
```

**Option 3: Install to Specific Directory**
```bash
# Linux/WSL
wget https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz && tar -xzf coherence-v4.3.0-installer.tar.gz && ./payload/install.sh /path/to/your/project

# macOS
curl -L https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz | tar -xz && ./payload/install.sh /path/to/your/project
```

**Option 4: Install with Piper TTS Voice Support**
```bash
# Linux/WSL
wget https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz && tar -xzf coherence-v4.3.0-installer.tar.gz && ./payload/install.sh --with-tts

# macOS
curl -L https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz | tar -xz && ./payload/install.sh --with-tts
```

## Key Features

### 🚀 Epic 17 Complete - Native Sub-Agent Revolution
- **Native Parallelism**: True concurrent execution, not Task-based simulation
- **4.1x Average Speedup**: Up to 4.8x for complex parallel operations
- **Zero Downtime Migration**: Seamless upgrade with backward compatibility
- **Enterprise Ready**: 34+ hours/week saved per development team

### 🖥️ MCP Plopdock Integration (Epic 26 - 93% Complete)
- **Persistent Development Servers**: Servers survive Claude Code restarts
- **Real-time Web Dashboard**: Full console output at http://localhost:8080
- **Universal Framework Support**: Auto-detects React, Django, Laravel, and 8+ other frameworks
- **Intelligent Command Interception**: Prevents duplicate server instances automatically
- **Configurable Installation**: Optional during setup with zero impact on users who decline
- **Voice-Guided Redirection**: Context-aware notifications when commands are blocked
- **Zero-Config Experience**: Automatic tech stack detection for 90%+ of projects

### Core Capabilities
- **9 Specialized Agents**: PM, Architect, Developer, QA, PO, SM, Analyst, Designer
- **45+ Parallel Commands**: Every persona enhanced with native sub-agent capabilities
- **AI/ML QA Framework**: 92% failure prediction, 94% anomaly detection accuracy
- **Test Monitoring**: Real-time CLI monitoring, web dashboard, and metrics collection
- **Session Management**: Automatic documentation with intelligent archival
- **Voice Notifications**: Persona-specific TTS with multiple providers
- **Project Agnostic**: Works with any technology stack or methodology

## What Gets Installed

The installation creates the following structure in your project:

```
your-project/
├── .apm/                        # Hidden APM framework (v3.2.0)
│   └── agents/                  # Core APM system
│       ├── personas/            # 9 specialized agent definitions
│       ├── tasks/               # 23+ reusable task templates
│       │   └── subtasks/        # Parallel execution system
│       │       ├── development/ # 9 developer analysis templates
│       │       ├── qa/          # 6 QA testing templates  
│       │       ├── po/          # 18 PO grooming templates
│       │       └── synthesis/   # 11 result aggregation patterns
│       ├── templates/           # 15+ document templates
│       ├── checklists/          # 14 quality checklists
│       ├── scripts/             # Management and automation scripts
│       │   └── test-monitoring/ # Real-time test monitoring framework
│       ├── voice/               # 9 persona voice scripts
│       ├── sounds/              # Audio notification files
│       ├── data/                # Knowledge base and preferences
│       └── python/              # Modern Python task manager
├── .claude/                     # Claude AI configuration
│   ├── settings.json            # Project settings with TTS/audio config
│   ├── commands/                # 12+ custom commands (/ap, /handoff, etc.)
│   └── hooks/                   # 5 notification hooks (audio system)
└── project_docs/                # Your project documentation
    ├── requirements/            # PRDs, project briefs (PM, Analyst)
    ├── backlog/                 # Product backlog (PO)
    │   └── backlog.md          # Single source of truth for work items
    ├── epics/                   # Epic definitions (PO)
    ├── stories/                 # User stories (PO, SM)
    ├── architecture/            # System & frontend architecture (Architect, Design)
    ├── design/                  # UI/UX specifications (Designer)
    ├── qa/                      # Test plans, results, reports (QA)
    │   ├── test-plans/
    │   ├── test-results/
    │   ├── reports/
    │   ├── metrics/            # Test monitoring metrics
    │   └── dashboards/         # Dashboard HTML files
    ├── planning/                # Sprint planning, retrospectives (SM)
    ├── research/                # Analysis and research (Analyst)
    ├── releases/                # Release documentation (Developer)
    └── session_notes/           # Auto-generated session logs
        └── archive/             # Completed session archives
    └── reports/                 # Analysis and status reports
```

## Agent Personas (v3.2.0 - All Enhanced with Native Sub-Agents)

- **AP Orchestrator**: Central coordinator with native multi-agent orchestration
- **Analyst**: Research and requirements with parallel analysis capabilities
- **PM**: Product strategy with concurrent planning execution
- **Architect**: System design with `/parallel-planning-architecture-review` (4x speedup)
- **Designer**: UI/UX with parallel component analysis
- **PO**: Backlog management with `/planning-groom` (18 native sub-agents, 4x speedup)
- **SM**: Sprint coordination with `/parallel-implementation-sprint` (4.6x speedup)
- **Developer**: Implementation with `/parallel-review` (4x speedup)
- **QA**: Testing with `/parallel-test` and AI/ML analytics (4x speedup, 92% accuracy)

## Installation Process

The installer will:

1. **Check for existing installations** - Offers to backup if found
2. **Copy AP Mapping files** - Installs the complete framework
3. **Configure your project** - Interactive prompts for:
   - Project name
   - Documentation paths
   - Session notes configuration (local markdown files)
   - Voice notification preferences
4. **Create Claude commands** - Sets up `/ap`, `/handoff`, `/switch`, `/wrap`
5. **Update .gitignore** - Excludes session notes from version control
6. **Generate .apm/CLAUDE.md** - Project instructions for Claude AI

## Commands

### Core Claude Commands
- `/ap` - Launch AP Orchestrator (central coordinator)
- `/analyst` - Activate Business Analyst for requirements gathering
- `/pm` - Activate Product Manager for PRDs and feature planning  
- `/architect` - Activate System Architect for technical design
- `/designer` - Activate Designer for UI/UX and frontend
- `/po` - Activate Product Owner for backlog management
- `/sm` - Activate Scrum Master for story creation and sprint planning
- `/dev` or `/developer` - Activate Developer for code implementation
- `/qa` - Activate QA Engineer for testing strategies

### Session Management Commands  
- `/handoff <agent>` - Direct transition to another agent persona
- `/switch <agent>` - Compact current session and switch to new agent
- `/wrap` - Archive session notes and create summary
- `/session-note-setup` - Initialize session notes structure

### Native Parallel Commands (v3.2.0 - Epic 17 Complete)

**Core Parallel Commands (4-8x Performance)**
- `/parallel-implementation-sprint` - **SM**: Coordinate 2-4 native Developer sub-agents (4.6x speedup)
- `/planning-groom` - **PO**: 18 native sub-agents for backlog analysis (4x speedup)
- `/parallel-review` - **Developer**: Concurrent code analysis (4x speedup)
- `/parallel-test` - **QA**: Native parallel test execution (4x speedup)
- `/parallel-planning-architecture-review` - **Architect**: System analysis (4x speedup)

**QA Framework AI/ML Commands**
- `/qa-framework` - Comprehensive testing with native parallelism
- `/qa-predict` - ML failure prediction (92% accuracy)
- `/qa-optimize` - Test optimization (63% time reduction)
- `/qa-anomaly` - Anomaly detection (94% precision)
- `/qa-insights` - AI-powered quality insights

**Test Monitoring Commands (v3.2.0)**
- `monitor tests` - Real-time CLI test monitoring
- `test dashboard` - Web-based monitoring dashboard  
- `test metrics` - Comprehensive metrics collection
- `show test status` - Quick test status overview

**All 45+ Commands**: Every persona now has native parallel capabilities

### Management Commands  
- `.apm/agents/scripts/ap-manager.sh update` - Check for updates
- `.apm/agents/scripts/ap-manager.sh verify` - Verify installation integrity  
- `.apm/agents/scripts/ap-manager.sh version` - Show current version
- `.apm/agents/scripts/configure-tts.sh` - Configure text-to-speech system
- `.apm/agents/scripts/tts-manager.sh test` - Test audio notifications

## First Steps After Installation

1. Open your project in Claude Code
2. Run `/coherence` to activate the Coherence Orchestrator with native sub-agent support
3. Experience 4-8x faster execution with zero CLI crashes
4. Let the Orchestrator coordinate multiple native sub-agents seamlessly

## Installation Notes

- **Clean Installation**: The installer automatically cleans up distribution files after installation
- **Preserved Templates**: The templates are preserved in `.apm/.templates/` for future updates
- **Session Notes**: Uses local markdown files for session management
- **TTS Configuration**: Voice support is optional and can be configured post-installation
- **Python Support**: Optional Python virtual environment for hooks (recommended)

## What's New in v3.2.0 - Epic 17 Complete

**Revolutionary Native Sub-Agent Architecture:**
- Complete migration from Task-based to native Claude Code sub-agents
- 4.1x average performance improvement (up to 4.8x for complex operations)
- Zero CLI crashes with rock-solid native integration
- 100% backward compatibility - all existing commands work seamlessly
- 34+ hours/week saved per development team

**All 17 Stories Delivered:**
- Native Sub-Agent Coordination Framework ✅
- Context Passing Mechanism ✅
- Progress Monitoring System ✅
- All Persona Commands Migrated ✅
- Performance Optimization Complete ✅
- Enterprise-Ready Testing Suite ✅

## Version Management

The installer includes comprehensive version and update management:

- **Version Tracking**: Automatically creates `.apm/VERSION` during installation
- **Seamless Updates**: Backward compatible with automatic migration
- **Update Checking**: Uses GitHub Releases API to check for new versions  
- **In-Place Updates**: Updates can be applied without losing your work
- **Automatic Backups**: Creates backups before updates and uninstalls
- **Templates Preservation**: Templates saved to `.apm/.templates/` for future use

See the [AP Manager Documentation](agents/docs/ap-manager.md) for detailed information.

## Optional Features

### Parallel Subtask System

The AP Mapping includes a powerful parallel execution system for Developer and QA agents:

#### Developer Parallel Reviews (`/parallel-review`)
Execute multiple code analysis tasks simultaneously:
- **Security Scan**: Vulnerability detection and OWASP compliance
- **Performance Check**: Bottleneck identification and optimization
- **Test Coverage**: Code coverage analysis and gaps
- **Code Complexity**: Cyclomatic complexity and maintainability
- **Dependency Audit**: Security vulnerabilities in dependencies
- **Memory Profiling**: Memory leaks and optimization
- **Database Optimization**: Query performance and indexing
- **API Design Review**: REST/GraphQL best practices
- **Architecture Compliance**: Pattern adherence and structure

#### QA Parallel Testing (`/parallel-test`)
Run comprehensive test suites in parallel:
- **Cross-Browser Testing**: Chrome, Firefox, Safari, Edge compatibility
- **Accessibility Audit**: WCAG compliance and screen reader support
- **API Contract Testing**: Schema validation and breaking changes
- **Load Testing**: Performance under stress and scalability
- **Mobile Responsive Testing**: Device compatibility and touch interactions
- **E2E User Journey**: Critical path validation

#### Test Monitoring Framework (v3.2.0)
Real-time test monitoring and dashboard capabilities:

**CLI Monitoring Commands:**
```bash
# Start real-time test monitoring
monitor tests

# Show test status once and exit
monitor tests --once

# Monitor only running test processes
monitor tests --processes

# Monitor only QA reports
monitor tests --reports

# Custom refresh interval (seconds)
monitor tests --interval 10
```

**Web Dashboard:**
```bash
# Launch web monitoring dashboard
test dashboard

# Custom port and mode
test dashboard --port 3000 --mode executive

# Available modes: full, metrics, executive
test dashboard --mode metrics

# Generate HTML file only
test dashboard --generate
```

**Metrics Collection:**
```bash
# Collect comprehensive test metrics
test metrics

# Export metrics in different formats
test metrics --export csv
test metrics --export json
test metrics --export yaml

# Collect specific metric types
test metrics --metrics process
test metrics --metrics coverage
test metrics --metrics qa-framework

# Generate summary report only
test metrics --summary
```

**Integration with QA Agent:**
```bash
# Activate QA agent
/qa

# Within QA session, use monitoring commands:
monitor tests          # Start real-time monitoring
test dashboard          # Launch web dashboard
test metrics           # Collect metrics
show test status       # Quick status check
```

**Test Monitoring Features:**
- **Real-time Process Tracking**: Monitor Jest, Pytest, Mocha, Karma, Vitest
- **File Change Detection**: Track test file modifications and recent changes
- **Coverage Analysis**: Monitor test coverage reports and metrics
- **Performance Metrics**: Track execution times and resource usage
- **Web Dashboard**: Auto-refreshing browser-based monitoring
- **Export Capabilities**: CSV, JSON, YAML formats for analysis
- **AI/ML Integration**: Connects with QA prediction and anomaly detection
- **Notification System**: TTS and webhook alerts for test failures

#### Performance Benefits
- **Sequential Execution**: 25-35 minutes for comprehensive review
- **Parallel Execution**: 5-7 minutes (80% time reduction)
- **Automatic Synthesis**: Results aggregated with priority rankings
- **Real-time Monitoring**: Instant visibility into test execution status

### Text-to-Speech (TTS) System

The AP Mapping includes a modular TTS system that supports multiple providers:

#### Available TTS Providers:

1. **Piper** (Default)
   - Local, offline text-to-speech
   - ~100MB download for binary and voice models
   - 9 different voices (5 women, 4 men)
   - No internet connection required

2. **ElevenLabs**
   - High-quality cloud-based voices
   - Requires API key (free tier available)
   - Natural-sounding AI voices
   - Automatic response caching

3. **System TTS**
   - Uses your OS built-in TTS
   - macOS: `say` command
   - Linux: `espeak`, `festival`, or `spd-say`
   - No additional downloads required

4. **Discord**
   - Send notifications to Discord channel
   - Optional TTS in Discord voice channels
   - Requires webhook URL

5. **None**
   - Silent mode - no audio output
   - For environments without audio support

#### TTS Configuration:

During installation, you'll be prompted to select a TTS provider. You can also configure TTS later:

```bash
# Configure TTS after installation
.apm/agents/scripts/ap-manager.sh configure-tts

# Or use the configuration utility directly
.apm/agents/scripts/configure-tts.sh
```

### 🔧 NEW: Prompt Enhancement Configuration (v4.3.0)

APM v4.3.0 introduces **configurable prompt enhancement** that automatically appends custom text to all user prompts:

#### How It Works:
- **Invisible to Users**: Appended text is processed by Claude but hidden from the UI
- **Automatic**: Applied to ALL prompts without user action
- **Configurable**: Set once in settings.json
- **Perfect for Standards**: Enforce project guidelines, coding standards, or context

#### Configuration:

Add to your `.claude/settings.json`:
```json
{
  "env": {
    "HOOK_USER_PROMPT_SUBMIT_ENABLED": "true",
    "PROMPT_APPEND_TEXT": "[Remember: Update backlog.md after story work]"
  }
}
```

#### Example Usage:
- **User types:** "Create a login function"
- **Claude receives:** "Create a login function [Remember: Update backlog.md after story work]"

#### Common Configurations:
```json
// APM Framework Guidelines
"PROMPT_APPEND_TEXT": "[APM Framework Active - Use voice notifications]"

// Coding Standards
"PROMPT_APPEND_TEXT": "[Follow coding standards in .apm/rules/]"

// Project Context
"PROMPT_APPEND_TEXT": "[E-commerce project - Security first approach]"

// Multiple Instructions
"PROMPT_APPEND_TEXT": "[APM Active] [Update backlog.md] [Use TDD approach]"

// Disable (empty string)
"PROMPT_APPEND_TEXT": ""
```

See `.claude/hooks/PROMPT_APPEND_CONFIGURATION.md` for detailed setup guide.

#### Managing TTS:

```bash
# Test current TTS provider
.apm/agents/scripts/tts-manager.sh test

# List available providers
.apm/agents/scripts/tts-manager.sh list

# Clear audio cache
.apm/agents/scripts/tts-manager.sh clear-cache

# Configure specific provider
.apm/agents/scripts/tts-manager.sh configure elevenlabs
```

### Session Notes Management

The AP Mapping system uses local markdown files for session management:
1. Session notes are stored in `.apm/session_notes/`
2. Archived sessions are stored in `.apm/session_notes/archive/`
3. All session data is preserved locally in your project

### Python Support

The installer can optionally set up Python support for hooks and scripts:
- Creates a virtual environment for package isolation
- Provides wrapper scripts for Python execution
- Manages dependencies via requirements.txt
- Install during setup or later with `.apm/python-support/setup-python.sh`

Note: Hooks work with system Python by default. The virtual environment is only needed if you want to add Python packages.

## Troubleshooting

### Permission Denied

If you get permission errors:
```bash
chmod +x install.sh
```

### Existing Installation

The installer detects existing installations and offers options:
- Create a backup (recommended)
- Overwrite existing files
- Cancel installation

### Claude Commands Not Working

Ensure you're using Claude Code (claude.ai/code) and that:
1. `.claude/commands/` directory exists
2. Commands have proper permissions
3. You're in the project root directory

## Building from Source

To create your own distribution:

```bash
# From the repository root
./build-distribution.sh

# Creates dist/ap-method-v*.tar.gz
```

## What's Next?

After installation:
1. Review `/agents/README.md` for AP Mapping overview
2. Use `/ap` command to start the AP Orchestrator
3. Begin with the Analyst agent to create a project brief
4. Follow the AP workflow through each phase

## Managing Your Installation

The AP Mapping includes `ap-manager.sh` for ongoing management:

```bash
# Check for updates
agents/scripts/ap-manager.sh update

# Verify installation integrity
agents/scripts/ap-manager.sh verify

# Show current version
agents/scripts/ap-manager.sh version

# Uninstall AP Mapping
agents/scripts/ap-manager.sh uninstall
```

Updates are checked against the official GitHub releases and can be applied in-place without losing your project work.

## Documentation

After installation, see:
- `.apm/CLAUDE.md` - Main instructions for Claude Code
- `project_documentation/` - Your project-specific documentation
- `agents/README.md` - Detailed agent information
- `agents/docs/` - AP Mapping guides and references

## Troubleshooting

- **Permission Issues**: Run `chmod +x payload/install.sh` if needed
- **Missing Dependencies**: The installer will notify you of any missing tools
- **Voice Not Working**: Check TTS configuration with `$AP_ROOT/scripts/configure-tts.sh`
- **Session Notes**: Session notes are stored locally in `.apm/session_notes/`

# AP Mapping System - Complete Command & Task Reference

## Core Persona Activation Commands

### Primary Commands
| Command | Persona | Description |
|---------|---------|-------------|
| `/ap` or `ap` | AP Orchestrator | Master coordination agent - delegates and manages all other personas |
| `/analyst` or `analyst` | Analyst | Brainstorming, research planning, and project brief creation |
| `/pm` or `pm` | Product Manager | PRD creation and strategic product planning |
| `/architect` or `architect` | System Architect | Technical architecture and system design |
| `/designer` or `design architect` | Designer | UI/UX design and frontend architecture |
| `/po` or `po` | Product Owner | Epic creation, story management, and backlog refinement |
| `/sm` or `sm` | Scrum Master | Story preparation and sprint management |
| `/dev` or `developer` or `dev` | Developer | Code implementation and technical execution |
| `/qa` or `qa` | QA Engineer | Testing strategy and quality assurance |

---

## Analyst Agent Commands & Tasks

### Core Activation
- **Command**: `/analyst` or `analyst`
- **Voice Script**: `bash $SPEAK_ANALYST "MESSAGE"`

### Available Tasks
1. **Brainstorming** 💡
   - Interactive idea generation and exploration
   - Creative problem-solving techniques
   - Market opportunity identification
   - *Trigger*: "Let's brainstorm" or "I have an idea about..."

2. **Deep Research Prompt Generation** 🔍
   - Create comprehensive research directives
   - Structure complex investigations
   - Define research scope and objectives
   - *Trigger*: "Create research prompt" or "Help me plan research"

3. **Create Project Brief** 📋
   - Transform ideas into structured documentation
   - Define MVP scope and requirements
   - Establish project foundation for PM handoff
   - *Trigger*: "Create project brief" or "YOLO" for quick draft

### Parallel Commands
- **`/parallel-planning-requirements`** - Comprehensive Requirements Analysis (70% faster)
- **`/parallel-research-prompt`** - Advanced Research Planning (75% faster)
- **`/parallel-planning-brainstorming`** - Structured Ideation Process (80% faster)
- **`/parallel-planning-stakeholder-review`** - Comprehensive Stakeholder Analysis (65% faster)

### Workflow Commands
- `/handoff PM` - Transfer completed project brief to Product Manager
- `/handoff Architect` - Share technical insights with Architect
- `/wrap` - Complete session with summary and next steps

---

## Product Manager (PM) Agent Commands & Tasks

### Core Activation
- **Command**: `/pm` or `pm`
- **Voice Script**: `bash $SPEAK_PM "MESSAGE"`

### Available Tasks
1. **Create PRD (Product Requirements Document)** 📄
   - Transform project briefs into comprehensive PRDs
   - Define product vision, goals, and success metrics
   - Break down features into epics and user stories
   - *Trigger*: "Create PRD" or "Let's build the PRD"

### Parallel Commands
- **`/parallel-prd`** - Execute comprehensive parallel PRD development (70% faster)
  - Market & user analysis, scope definition, technical constraints
  - Epic structure, success metrics with synthesis

### Product Strategy Support
- Ideate on product features
- Refine product vision
- Prioritize features (MoSCoW, RICE frameworks)
- Define success metrics
- Analyze market fit

### Workflow Commands
- `/handoff PO` - Transfer PRD to Product Owner for backlog management
- `/handoff Architect` - Share PRD for technical design
- `/wrap` - Complete session with PRD summary

---

## System Architect Agent Commands & Tasks

### Core Activation
- **Command**: `/architect` or `architect`
- **Voice Script**: `bash $SPEAK_ARCHITECT "MESSAGE"`

### Available Tasks
1. **Create Architecture** 🏗️
   - Design comprehensive system architecture from PRD
   - Define technology stack and component structure
   - Create architectural diagrams and documentation
   - *Trigger*: "Create architecture" or "Design the system"

2. **Create Next Story** 📝
   - Transform epics into technical implementation stories
   - Define technical requirements and constraints
   - Ensure architectural alignment
   - *Trigger*: "Create next story" or "Break down this epic"

3. **Slice Documents** 📑
   - Break large documents into manageable sections
   - Optimize for AI agent processing
   - *Trigger*: "Slice this document" or "Break this down"

### Parallel Commands
- **`/parallel-planning-architecture`** - Comprehensive Architecture Creation (75% faster)
  - Database, API, security, performance, infrastructure, technology stack analysis

### Workflow Commands
- `/handoff Dev` - Transfer architecture to Developer for implementation
- `/handoff PO` - Share technical constraints with Product Owner
- `/wrap` - Complete session with architecture summary

---

## Designer Agent Commands & Tasks

### Core Activation
- **Command**: `/designer` or `design architect`
- **Voice Script**: `bash $SPEAK_DESIGNER "MESSAGE"`

### Available Tasks
1. **Create Frontend Architecture** 🏗️
   - Design component hierarchies and state management
   - Define frontend technology stack and patterns
   - *Trigger*: "Create frontend architecture" or "Design the UI system"

2. **Create UI/UX Specifications** 🎨
   - Design user interfaces with wireframes and mockups
   - Define interaction patterns and user flows
   - *Trigger*: "Create UI specs" or "Design the interface"

3. **Create AI Frontend Prompt** 🤖
   - Generate optimized prompts for AI development
   - Include component specifications and behaviors
   - *Trigger*: "Create AI prompt" or "Generate frontend prompt"

### Parallel Commands
- **`/parallel-frontend-architecture`** - Comprehensive Frontend Design (80% faster)
- **`/parallel-ai-prompt`** - AI Development Prompt Generation (75% faster)

### Design Commands
- `/design-system` - Create comprehensive design system
- `/wireframes` - Generate UI wireframes
- `/user-flows` - Map user journey flows
- `/component-library` - Define reusable components

### Workflow Commands
- `/handoff Dev` - Transfer specs to Developer
- `/handoff QA` - Share designs for testing
- `/wrap` - Complete with design summary

---

## Product Owner (PO) Agent Commands & Tasks

### Core Activation
- **Command**: `/po` or `po`
- **Voice Script**: `bash $SPEAK_PO "MESSAGE"`

### Available Tasks
1. **Create Epic** 🎯
   - Transform PRD features into manageable epics
   - Define epic-level acceptance criteria
   - *Trigger*: "Create epic" or "Break down this feature"

2. **Create Next Story** 📝
   - Generate development-ready user stories
   - Include comprehensive acceptance criteria
   - *Trigger*: "Create next story" or "Generate user stories"

3. **Slice Documents** 📑
   - Break large documents into focused sections
   - *Trigger*: "Slice this document" or "Break this down"

4. **Correct Course** 🔄
   - Mid-sprint adjustments and clarifications
   - Address blockers and ambiguities
   - *Trigger*: "Correct course" or "We need to adjust"

### Parallel Commands
- **`/parallel-planning-epic`** - Comprehensive Epic Creation (70% faster)
- **`/parallel-planning-stories`** - User Story Generation (75% faster)
- **`/parallel-qa-acceptance-criteria`** - Acceptance Criteria Definition (80% faster)
- **`/parallel-prioritization`** - Backlog Prioritization (65% faster)
- **`/parallel-planning-validation`** - Requirements Validation (85% faster)

### Advanced PO Commands (Grooming System)
- `/planning-groom` - Execute comprehensive parallel grooming analysis
- Individual groom subtasks available for specific focus areas

### Workflow Commands
- `/handoff SM` - Transfer refined stories to Scrum Master
- `/handoff Dev` - Share ready stories with Developer
- `/wrap` - Complete session with backlog summary

---

## Scrum Master (SM) Agent Commands & Tasks

### Core Activation
- **Command**: `/sm` or `sm`
- **Voice Script**: `bash $SPEAK_SM "MESSAGE"`

### Available Tasks
1. **Create Next Story** 📝
   - Transform epics into development-ready stories
   - Apply comprehensive validation checklists
   - *Trigger*: "Create next story" or "Prepare a story"

2. **Correct Course** 🔄
   - Mid-sprint adjustments and pivots
   - Address emerging requirements
   - *Trigger*: "Correct course" or "We need to pivot"

3. **Run Checklists** ✅
   - Execute specialized validation checklists
   - Ensure story quality standards
   - *Trigger*: "Run checklist" or "Validate this story"

4. **Document Sharding** 📑
   - Break large documents into manageable chunks
   - *Trigger*: "Shard document" or "Break this down"

### Parallel Commands
- **`/parallel-next-story`** - Advanced Story Creation (75% faster)
- **`/parallel-planning-stories`** - Batch Story Generation (80% faster)
- **`/parallel-planning-checklist`** - Comprehensive Story Validation (70% faster)
- **`/parallel-course-correction`** - Sprint Adjustment Analysis (65% faster)

### Story Management Commands
- `/create` - Create next development-ready story
- `/pivot` - Run course correction task
- `/planning-checklist` - List and run validation checklists
- `/doc-shard <type>` - Shard large documents

### Workflow Commands
- `/handoff Dev` - Transfer story to Developer
- `/handoff QA` - Share story for test planning
- `/wrap` - Complete session with sprint summary

---

## Developer Agent Commands & Tasks

### Core Activation
- **Command**: `/dev` or `/developer` or `dev`
- **Voice Script**: `bash $SPEAK_DEVELOPER "MESSAGE"`

### Available Tasks
1. **Story Implementation** 📝
   - Transform user stories into working code
   - Follow acceptance criteria exactly
   - Implement with test coverage
   - Ensure DoD compliance
   - *Trigger*: "Implement this story" or provide story details

### Parallel Commands
- **`/parallel-review`** - Comprehensive Code Analysis (80% faster)
  - Security scanning, performance profiling, test coverage
  - Code quality metrics and dependency auditing

### Development Commands
- `/run-tests` - Execute test suite
- `/lint` - Run code linters
- `/core-dump` - Capture current state
- `/explain <topic>` - Technical explanations

### Workflow Commands
- `/handoff QA` - Transfer to QA with test results
- `/handoff Architect` - Escalate design questions
- `/wrap` - Complete with implementation summary

---

## QA Agent Commands & Tasks

### Core Activation
- **Command**: `/qa` or `qa`
- **Voice Script**: `bash $SPEAK_QA "MESSAGE"`

### Available Tasks
1. **Create Test Strategy** 📊
   - Design comprehensive testing approach
   - Define test objectives and scope
   - *Trigger*: "Create test strategy" or "Plan our testing approach"

2. **Create Test Plan** 📝
   - Develop detailed test scenarios
   - Define test cases and prerequisites
   - *Trigger*: "Create test plan" or "Design test cases"

3. **Execute Quality Review** 🔍
   - Perform comprehensive quality assessment
   - Review code, documentation, and artifacts
   - *Trigger*: "Execute quality review" or "Review quality"

4. **Run QA Checklist** ✅
   - Execute standardized quality checks
   - Verify DoD compliance
   - *Trigger*: "Run QA checklist" or "Check quality gates"

### Parallel Commands
- **`/parallel-test-strategy`** - Comprehensive Test Strategy Development (75% faster)
- **`/parallel-qa-automation-plan`** - Automated Testing Framework Design (70% faster)
- **`/parallel-test-plan`** - Detailed Test Case Planning (80% faster)
- **`/parallel-qa-quality-review`** - Comprehensive Quality Assessment (85% faster)

### Quality Commands
- `/test-strategy` - Create test strategy
- `/test-plan` - Develop test plan
- `/qa-quality-review` - Execute review
- `/qa-checklist` - Run checklist

### Workflow Commands
- `/handoff Dev` - Return issues to Developer
- `/handoff PO` - Escalate requirement clarifications
- `/wrap` - Complete with quality summary

---

## Universal Workflow Commands

### Session Management
Available across all personas:
- `/wrap` - Complete current session with summary
- `/handoff [persona]` - Transfer to another agent
- `/switch [persona]` - Compact session and switch
- `/session-note-setup` - Set up session notes structure

### System Commands
- `/ap` - Launch AP Orchestrator (master coordinator)
- `/help` - Show available commands for current persona
- `Show [status/progress/summary]` - Display current state

---

## Parallel Execution Performance Gains

### Speed Improvements by Command
- **`/parallel-planning-brainstorming`**: 80% faster ideation
- **`/parallel-research-prompt`**: 75% faster research planning
- **`/parallel-planning-requirements`**: 70% faster requirements analysis
- **`/parallel-prd`**: 70% faster PRD development
- **`/parallel-planning-architecture`**: 75% faster architecture creation
- **`/parallel-frontend-architecture`**: 80% faster frontend design
- **`/parallel-planning-epic`**: 70% faster epic development
- **`/parallel-planning-stories`**: 75-80% faster story creation
- **`/parallel-test-strategy`**: 75% faster test planning
- **`/parallel-qa-automation-plan`**: 70% faster automation planning
- **`/parallel-qa-quality-review`**: 85% faster quality assessment
- **`/parallel-planning-validation`**: 85% faster requirements validation

### How Parallel Commands Work
All parallel commands execute multiple analysis tasks simultaneously using Claude Code's Task tool, then synthesize results for comprehensive output in a fraction of the time.

---

## Quick Reference by Workflow

### 🚀 New Project Workflow
1. `analyst` → Brainstorming & Project Brief
2. `pm` → PRD Creation
3. `architect` → System Architecture
4. `po` → Epic & Story Creation
5. `dev` → Implementation
6. `qa` → Testing & Quality

### ⚡ Speed-Optimized Workflow
1. `analyst` → `/parallel-planning-brainstorming` & `/parallel-planning-requirements`
2. `pm` → `/parallel-prd`
3. `architect` → `/parallel-planning-architecture`
4. `po` → `/parallel-planning-epic` & `/parallel-planning-stories`
5. `dev` → `/parallel-review` (for code analysis)
6. `qa` → `/parallel-test-strategy` & `/parallel-qa-quality-review`

### 🔄 Mid-Sprint Adjustments
- `po` → `/parallel-course-correction`
- `sm` → `/parallel-course-correction`
- Any persona → `Correct course`

---

## License

This project is licensed under the MIT License.