# Agentic Persona Mapping

A project-agnostic framework for orchestrating AI agents in software development workflows.

## Quick Start

**Latest Release:** v1.2.3

### One-Command Installation

**Linux/WSL:**
```bash
wget https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh
```

**macOS:**
```bash
curl -L https://github.com/omayhemo/APM/releases/download/v1.2.3/apm-v1.2.3.tar.gz -o apm-v1.2.3.tar.gz && tar -xzf apm-v1.2.3.tar.gz && cd apm-v1.2.3 && ./installer/install.sh
```

## What is Agentic Persona Mapping?

Agentic Persona Mapping provides specialized AI agent personas for software development:

- **9 Expert Personas**: Analyst, PM, Architect, Design Architect, PO, SM, Developer, QA
- **Structured Workflows**: From project briefs to implementation
- **Audio Notifications**: TTS system with persona-specific voices  
- **Parallel Execution**: 70-80% time reduction on complex tasks
- **Session Management**: Automatic documentation and archival

## Key Features

### ✅ **What's New in v1.2.3**
- **🍎 macOS Compatibility**: Fixed critical installer crash on macOS caused by BSD sed syntax differences
- **🔧 Cross-Platform Support**: Added automatic OS detection for proper sed command usage
- **✅ Installation Success**: Resolves "invalid command code f" error that prevented macOS installation

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
- **Project Instructions**: `CLAUDE.md` created during installation

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
├── installer/               # Installation system
├── dist/                   # Built distributions
└── build-distribution.sh  # Build script
```

## Support

- **Documentation**: Comprehensive guides included with installation
- **Issues**: GitHub Issues for bug reports and feature requests
- **Version**: v1.2.0 (Stable Release)

## License

MIT License - See LICENSE file for details.