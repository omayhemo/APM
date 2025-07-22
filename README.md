# Agentic Persona Mapping

A revolutionary AI-powered framework for orchestrating parallel agent execution in software development workflows.

## Quick Start

**Latest Release:** v2.1.4 🚀

### One-Command Installation

**Linux/WSL:**
```bash
wget https://github.com/omayhemo/APM/releases/download/v2.1.4/apm-v2.1.4.tar.gz && tar -xzf apm-v2.1.4.tar.gz && cd apm-v2.1.4 && ./installer/install.sh
```

**macOS:**
```bash
curl -L https://github.com/omayhemo/APM/releases/download/v2.2.0/apm-v2.2.0.tar.gz | tar -xz && cd apm-v2.2.0 && ./installer/install.sh
```

## What is Agentic Persona Mapping?

Agentic Persona Mapping provides specialized AI agent personas for software development with groundbreaking parallel execution capabilities:

- **9 Expert Personas**: Analyst, PM, Architect, Design Architect, PO, SM, Developer, QA
- **🎯 NEW: Parallel Agent Coordination**: Multiple agents working simultaneously on different stories
- **Structured Workflows**: From project briefs to implementation
- **Audio Notifications**: TTS system with persona-specific voices  
- **Parallel Execution**: Now 85%+ time reduction through true concurrent agent work
- **Session Management**: Automatic documentation and archival

## Key Features

### 🚀 **What's New in v2.2.0 - Claude.md Merge System**
- **🧠 Intelligent Merge System**: Revolutionary framework for seamless template updates while preserving customizations
- **⚡ Lightning Performance**: < 500ms template analysis, < 100ms section parsing  
- **🛡️ Zero Data Loss**: Comprehensive backup system with automatic recovery
- **🔧 Foundation Complete**: Sprint 1 delivered with 100% test coverage
- **📁 Better Organization**: LICENSE and VERSION files now in `.apm` folder

### 🔧 **v2.1.4 - Critical AP Command Fixes**
- **🛠️ Fixed AP Activation**: Resolved remaining "File does not exist" errors when running `/ap` commands
- **📁 LICENSE/VERSION Relocation**: Moved LICENSE and VERSION files to `.apm` folder for better organization
- **🔍 Claude Code Compatibility**: Created required files that Claude Code expects during AP command activation
- **📦 Installer Improvements**: Enhanced installer to prevent file read errors on fresh installations

### 🎯 **v2.1.0 - Enhanced Claude Code Hooks**
- **🆕 UserPromptSubmit Hook**: Captures when users submit prompts with automatic logging and AP command detection
- **🗂️ PreCompact Hook**: Archives session state before context compaction to preserve work history
- **🔊 Expanded Audio Notifications**: Now supporting 7 hooks (up from 5) with new prompt and compact sounds
- **📋 Improved Configuration**: New hooks enabled by default with centralized logging to `~/.claude/logs/`

### 🔧 **v2.0.1 - Documentation Path Fixes**
- Fixed handoff notes location to use `.apm/session_notes/handoffs/`
- Updated all persona templates with proper handoff guidance
- Better separation between session artifacts and project deliverables

### 🚀 **v2.0.0 - REVOLUTIONARY PARALLEL AGENTS**
- **🔥 Parallel Agent Orchestration**: Product Owner can coordinate multiple developers and QA agents working on different stories simultaneously
- **⚡ Unprecedented Velocity**: Multiple agents implementing features concurrently with intelligent conflict resolution
- **🎪 Advanced Coordination**: Real-time collaboration between agents with automatic dependency management
- **📈 85%+ Performance Gains**: Dramatic acceleration through true parallel processing
- **🛡️ Protected Infrastructure**: APM directory now gitignored for secure local configuration

### 🔄 **Previous Release (v1.2.0)**
- **🔧 Fixed Audio Notifications**: Resolved critical path calculation bugs in all installer hooks
- **🎨 Updated Branding**: Complete rebrand to "Agentic Persona Mapping" throughout system
- **📦 New Distribution Format**: Simplified `apm-v*.tar.gz` package naming
- **⚙️ Improved Installer Defaults**: Fixed `-d` flag to properly enable stop/subagent_stop audio hooks
- **🔇 Streamlined Installation**: Removed test voice messages for cleaner setup experience
- **📚 Enhanced Documentation**: Updated guides and improved user experience

### 🎯 **Core Capabilities**
- **Voice Integration**: Each persona has unique voice characteristics
- **Parallel Processing**: Execute multiple tasks simultaneously
- **Project Structure**: Creates organized documentation hierarchy
- **Claude Integration**: Custom commands for seamless workflow

## Installation Structure

After installation, your project will have:

```
your-project/
├── .apm/                      # Hidden APM framework
│   └── agents/               # All agent personas and scripts
│       ├── personas/         # 9 agent definitions  
│       ├── tasks/           # Reusable task templates
│       ├── scripts/         # Management and TTS scripts
│       └── sounds/          # Audio notification files
├── .claude/                  # Claude Code configuration
│   ├── settings.json        # Project settings
│   └── commands/            # Custom commands (/ap, /handoff, etc.)
└── project_documentation/   # Your project docs
    ├── session_notes/       # Auto-generated session logs
    ├── base/               # Core project documents
    └── stories/            # User stories and epics
```

## Available Personas

- **🎯 AP Orchestrator**: Central coordinator and method expert
- **🔍 Analyst**: Research, requirements gathering, project briefs  
- **📊 PM**: Product Requirements Documents, feature planning
- **🏗️ Architect**: System design, technical architecture
- **🎨 Design Architect**: UI/UX design, frontend architecture
- **📋 PO**: Backlog management, story grooming
- **🏃 SM**: Story creation, sprint planning
- **💻 Developer**: Code implementation, technical solutions
- **🔍 QA**: Quality assurance, testing strategies

## Usage

After installation:

1. **Start**: Open your project in Claude Code
2. **Activate**: Run `/ap` to launch the AP Orchestrator
3. **Begin**: Start with Analyst for project brief creation
4. **Follow**: Use the guided workflow through each phase

## Management Commands

```bash
# Check for updates
.apm/agents/scripts/ap-manager.sh update

# Verify installation
.apm/agents/scripts/ap-manager.sh verify

# Configure TTS
.apm/agents/scripts/configure-tts.sh

# Test audio system
.apm/agents/scripts/tts-manager.sh test
```

## Documentation

- **Installation Guide**: See README in distribution package
- **Framework Details**: `.apm/agents/README.md` after installation
- **API Documentation**: `.apm/agents/docs/` directory
- **Project Instructions**: `.apm/CLAUDE.md` created during installation

## Development

This repository contains the source code and build system for Agentic Persona Mapping.

### Building Distribution

```bash
# Build release package
./build-distribution.sh

# Creates: dist/apm-v*.tar.gz
```

### Repository Structure

```
agentic-persona-mapping/
├── agents/                   # Source agent framework
├── templates/               # Installation system
├── dist/                   # Built distributions
└── build-distribution.sh  # Build script
```

## Support

- **Documentation**: Comprehensive guides included with installation
- **Issues**: GitHub Issues for bug reports and feature requests
- **Version**: v1.2.0 (Stable Release)

## License

MIT License - See LICENSE file for details.