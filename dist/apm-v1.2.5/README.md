#  Agentic Persona Mapping Framework

Version: 1.2.3

## What is Agentic Persona Mapping?

The Agentic Persona Mapping is a project-agnostic approach to orchestrating AI agents for software development. It provides specialized agent personas, each with specific expertise and responsibilities for planning and executing software projects.

## Quick Installation

### Download and Install (One Command)

**For Linux/WSL:**
```bash
wget https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh
```

**For macOS:**
```bash
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz -o apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh
```

### Installation Options

**Option 1: Interactive Installation (Recommended)**
Add nothing - the installer will prompt for all configuration options

**Option 2: Install with Defaults (Skip prompts)**
```bash
# Linux/WSL
wget https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh --defaults

# macOS
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz -o apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh --defaults
```

**Option 3: Install to Specific Directory**
```bash
# Linux/WSL
wget https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh /path/to/your/project

# macOS
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz -o apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh /path/to/your/project
```

**Option 4: Install with Piper TTS Voice Support**
```bash
# Linux/WSL
wget https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh --with-tts

# macOS
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz -o apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh --with-tts
```

## Key Features

- **9 Specialized Agents**: Each agent has specific expertise (PM, Architect, Developer, QA, etc.)
- **Structured Workflow**: From project briefs to implementation
- **Session Management**: Automatic session notes with archival
- **Voice Notifications**: Multiple TTS providers for audio feedback
- **Project Agnostic**: Works with any project type or technology stack
- **Parallel Execution**: 
  - Developer: `/parallel-review` for simultaneous code analysis
  - QA: `/parallel-test` for concurrent test execution
  - PO: `/groom` for parallel backlog analysis
  - 80%+ time reduction on complex tasks

## What Gets Installed

The installation creates the following structure in your project:

```
your-project/
├── .apm/                        # Hidden APM framework (v1.2.3)
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
│       ├── voice/               # 9 persona voice scripts
│       ├── sounds/              # Audio notification files
│       ├── data/                # Knowledge base and preferences
│       └── python/              # Modern Python task manager
├── .claude/                     # Claude AI configuration
│   ├── settings.json            # Project settings with TTS/audio config
│   ├── commands/                # 12+ custom commands (/ap, /handoff, etc.)
│   └── hooks/                   # 5 notification hooks (audio system)
└── project_docs/                # Your project documentation
    ├── session_notes/           # Auto-generated session logs
    ├── requirements/            # Requirements documentation  
    ├── architecture/            # Architecture documents
    ├── specifications/          # Technical specifications
    ├── artifacts/               # Project artifacts
    ├── releases/                # Release documentation
    └── reports/                 # Analysis and status reports
```

## Agent Personas

- **AP Orchestrator**: Central coordinator and method expert
- **Analyst**: Research, requirements gathering, project briefs
- **PM**: Product Requirements Documents, epics, planning
- **Architect**: System design, technical architecture
- **Design Architect**: UI/UX, frontend architecture
- **PO**: Backlog management, story validation
- **SM**: Story generation, sprint planning
- **Developer**: Code implementation
- **QA**: Quality assurance, testing strategies

## Installation Process

The installer will:

1. **Check for existing installations** - Offers to backup if found
2. **Copy AP Mapping files** - Installs the complete framework
3. **Configure your project** - Interactive prompts for:
   - Project name
   - Documentation paths
   - Session notes configuration (Obsidian MCP or local markdown)
   - Voice notification preferences
4. **Create Claude commands** - Sets up `/ap`, `/handoff`, `/switch`, `/wrap`
5. **Update .gitignore** - Excludes session notes from version control
6. **Generate CLAUDE.md** - Project instructions for Claude AI

## Commands

### Core Claude Commands
- `/ap` - Launch AP Orchestrator (central coordinator)
- `/analyst` - Activate Business Analyst for requirements gathering
- `/pm` - Activate Product Manager for PRDs and feature planning  
- `/architect` - Activate System Architect for technical design
- `/design-architect` - Activate Design Architect for UI/UX and frontend
- `/po` - Activate Product Owner for backlog management
- `/sm` - Activate Scrum Master for story creation and sprint planning
- `/dev` or `/developer` - Activate Developer for code implementation
- `/qa` - Activate QA Engineer for testing strategies

### Session Management Commands  
- `/handoff <agent>` - Direct transition to another agent persona
- `/switch <agent>` - Compact current session and switch to new agent
- `/wrap` - Archive session notes and create summary
- `/session-note-setup` - Initialize session notes structure

### Parallel Execution Commands (v1.2.3)
- `/groom` - **PO Only**: 18 parallel backlog analysis tasks (80% time reduction)
- `/parallel-review` - **Developer Only**: 9 simultaneous code analysis tasks
- `/parallel-test` - **QA Only**: 6 concurrent testing workflows

### Management Commands  
- `.apm/agents/scripts/ap-manager.sh update` - Check for updates
- `.apm/agents/scripts/ap-manager.sh verify` - Verify installation integrity  
- `.apm/agents/scripts/ap-manager.sh version` - Show current version
- `.apm/agents/scripts/configure-tts.sh` - Configure text-to-speech system
- `.apm/agents/scripts/tts-manager.sh test` - Test audio notifications

## First Steps After Installation

1. Open your project in Claude Code
2. Run `/ap` to activate the AP Orchestrator
3. Let the Orchestrator guide you through setting up your project

## Installation Notes

- **Clean Installation**: The installer automatically cleans up distribution files after installation
- **Preserved Installer**: The installer is preserved in `.apm/.installer/` for future updates
- **Session Notes**: Choose between Obsidian MCP integration or local markdown files
- **TTS Configuration**: Voice support is optional and can be configured post-installation
- **Python Support**: Optional Python virtual environment for hooks (recommended)

## Version Management

The installer includes comprehensive version and update management:

- **Version Tracking**: Automatically creates `.apm/agents/version.txt` during installation
- **Update Checking**: Uses GitHub Releases API to check for new versions  
- **In-Place Updates**: Updates can be applied without losing your work
- **Automatic Backups**: Creates backups before updates and uninstalls
- **Installer Preservation**: Installer saved to `.apm/.installer/` for future use

See the [AP Manager Documentation](../agents/docs/ap-manager.md) for detailed information.

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

#### Performance Benefits
- **Sequential Execution**: 25-35 minutes for comprehensive review
- **Parallel Execution**: 5-7 minutes (80% time reduction)
- **Automatic Synthesis**: Results aggregated with priority rankings

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

### Obsidian MCP Integration

For cross-session memory using Obsidian:
1. Install Obsidian MCP server
2. Configure during setup with your vault path
3. Session notes will sync automatically

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
- `CLAUDE.md` - Main instructions for Claude Code
- `project_documentation/` - Your project-specific documentation
- `agents/README.md` - Detailed agent information
- `agents/docs/` - AP Mapping guides and references

## Troubleshooting

- **Permission Issues**: Run `chmod +x installer/install.sh` if needed
- **Missing Dependencies**: The installer will notify you of any missing tools
- **Voice Not Working**: Check TTS configuration with `$AP_ROOT/scripts/configure-tts.sh`
- **Session Notes**: Verify Obsidian MCP is installed if using Obsidian integration

# AP Mapping System - Complete Command & Task Reference

## Core Persona Activation Commands

### Primary Commands
| Command | Persona | Description |
|---------|---------|-------------|
| `/ap` or `ap` | AP Orchestrator | Master coordination agent - delegates and manages all other personas |
| `/analyst` or `analyst` | Analyst | Brainstorming, research planning, and project brief creation |
| `/pm` or `pm` | Product Manager | PRD creation and strategic product planning |
| `/architect` or `architect` | System Architect | Technical architecture and system design |
| `/design-architect` or `design architect` | Design Architect | UI/UX design and frontend architecture |
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
- **`/parallel-requirements`** - Comprehensive Requirements Analysis (70% faster)
- **`/parallel-research-prompt`** - Advanced Research Planning (75% faster)
- **`/parallel-brainstorming`** - Structured Ideation Process (80% faster)
- **`/parallel-stakeholder-review`** - Comprehensive Stakeholder Analysis (65% faster)

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
- **`/parallel-architecture`** - Comprehensive Architecture Creation (75% faster)
  - Database, API, security, performance, infrastructure, technology stack analysis

### Workflow Commands
- `/handoff Dev` - Transfer architecture to Developer for implementation
- `/handoff PO` - Share technical constraints with Product Owner
- `/wrap` - Complete session with architecture summary

---

## Design Architect Agent Commands & Tasks

### Core Activation
- **Command**: `/design-architect` or `design architect`
- **Voice Script**: `bash $SPEAK_DESIGN_ARCHITECT "MESSAGE"`

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
- **`/parallel-epic`** - Comprehensive Epic Creation (70% faster)
- **`/parallel-stories`** - User Story Generation (75% faster)
- **`/parallel-acceptance-criteria`** - Acceptance Criteria Definition (80% faster)
- **`/parallel-prioritization`** - Backlog Prioritization (65% faster)
- **`/parallel-validation`** - Requirements Validation (85% faster)

### Advanced PO Commands (Grooming System)
- `/groom` - Execute comprehensive parallel grooming analysis
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
- **`/parallel-stories`** - Batch Story Generation (80% faster)
- **`/parallel-checklist`** - Comprehensive Story Validation (70% faster)
- **`/parallel-course-correction`** - Sprint Adjustment Analysis (65% faster)

### Story Management Commands
- `/create` - Create next development-ready story
- `/pivot` - Run course correction task
- `/checklist` - List and run validation checklists
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
- **`/parallel-automation-plan`** - Automated Testing Framework Design (70% faster)
- **`/parallel-test-plan`** - Detailed Test Case Planning (80% faster)
- **`/parallel-quality-review`** - Comprehensive Quality Assessment (85% faster)

### Quality Commands
- `/test-strategy` - Create test strategy
- `/test-plan` - Develop test plan
- `/quality-review` - Execute review
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
- **`/parallel-brainstorming`**: 80% faster ideation
- **`/parallel-research-prompt`**: 75% faster research planning
- **`/parallel-requirements`**: 70% faster requirements analysis
- **`/parallel-prd`**: 70% faster PRD development
- **`/parallel-architecture`**: 75% faster architecture creation
- **`/parallel-frontend-architecture`**: 80% faster frontend design
- **`/parallel-epic`**: 70% faster epic development
- **`/parallel-stories`**: 75-80% faster story creation
- **`/parallel-test-strategy`**: 75% faster test planning
- **`/parallel-automation-plan`**: 70% faster automation planning
- **`/parallel-quality-review`**: 85% faster quality assessment
- **`/parallel-validation`**: 85% faster requirements validation

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
1. `analyst` → `/parallel-brainstorming` & `/parallel-requirements`
2. `pm` → `/parallel-prd`
3. `architect` → `/parallel-architecture`
4. `po` → `/parallel-epic` & `/parallel-stories`
5. `dev` → `/parallel-review` (for code analysis)
6. `qa` → `/parallel-test-strategy` & `/parallel-quality-review`

### 🔄 Mid-Sprint Adjustments
- `po` → `/parallel-course-correction`
- `sm` → `/parallel-course-correction`
- Any persona → `Correct course`

---

## Support

For issues or questions:
- GitHub: https://github.com/omayhemo/APM
- Documentation: See .apm/agents/README.md
- Version: v1.2.3 - Production ready!

## License

This project is licensed under the MIT License.