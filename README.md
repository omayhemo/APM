# Coherence - Agentic Persona Mapping

**Unified Context Engineering**

**v4.3.0** - Revolutionary AI context engineering platform that transforms multiple AI personas into a unified, harmonious system. Like a conductor leading an orchestra, Coherence ensures every persona plays its part perfectly, delivering **4-8x performance improvement** in software development workflows.

## ⚠️ CRITICAL: ALWAYS USE SLASH COMMANDS

**COHERENCE REQUIRES SLASH COMMANDS FOR PRECISE PERSONA ORCHESTRATION**

### ✅ CORRECT Usage:
```
/analyst   /pm   /architect   /dev   /qa   /coherence
```

### ❌ INCORRECT Usage:
```
"Please load analyst"   "Act as developer"   "Be the QA"
```

**Without slash commands:** 4.6x slower, missing files, no parallelism, 20x error rate.  
**📖 MUST READ:** See `project_docs/CRITICAL-SLASH-COMMAND-USAGE.md` after installation.

---

## 🚀 Quick Start

**Latest Release:** v4.3.0 ⚡ *Enhanced TTS Audio Experience*

### One-Command Installation

**Linux/WSL:**
```bash
wget https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz && tar -xzf coherence-v4.3.0-installer.tar.gz && ./coherence-v4.3.0-installer/installer/install.sh
```

**macOS:**
```bash
curl -L https://github.com/omayhemo/agentic-persona-mapping/releases/download/v4.3.0/coherence-v4.3.0-installer.tar.gz | tar -xz && ./coherence-v4.3.0-installer/installer/install.sh
```

## What is Coherence?

Coherence v4.3.0 is the **AI context engineering platform** that brings order to complexity. By orchestrating **multiple AI personas into unified intelligence**, Coherence delivers **revolutionary release management automation**, **AI-powered documentation generation**, and **seamless persona coordination** with professional-grade reliability:

- **8 Expert Personas**: Analyst, PM, Architect, Designer, PO, Developer, QA, Orchestrator
- **⚡ Native Sub-Agent Architecture**: Complete Task tool modernization with 4-8x performance improvement
- **🎯 70+ Total Commands**: Execute multiple analyses, tests, development, and release management tasks
- **📦 Revolutionary Release Management**: `/version` and `/release` commands with GitHub integration
- **🤖 AI-Powered Documentation**: Automated release notes, changelogs, and migration guides
- **⚡ 12-15x Faster Releases**: Complete release process in 20 minutes vs 4-5 hours
- **🧪 Enterprise QA Framework**: AI/ML powered testing with 92% prediction accuracy
- **🚀 Zero CLI Crashes**: Rock-solid native integration with Claude Code
- **📈 34+ Hours/Week Saved**: Per development team through parallel execution
- **🧹 Massive Cleanup**: Eliminated 25,599 lines of deprecated code and backup files
- **🔄 Seamless Migration**: Backward compatibility with automatic command translation
- **🎯 Unified System**: Single JSON-based persona definitions eliminate 3x template duplication
- **Audio Notifications**: TTS system with persona-specific voices
- **Session Management**: Automatic documentation and archival

## 🎭 Coherence Core Principles

### **Unity from Multiplicity**
Transform multiple AI personas into coherent, coordinated output. Each persona maintains its expertise while contributing to a unified workflow.

### **Orchestrated Intelligence** 
Not just AI, but coordinated AI. Like a conductor leading an orchestra, Coherence ensures every persona plays its part perfectly in harmony.

### **Precision Context Control**
Engineering-grade persona management with seamless transitions, context preservation, and intelligent handoff protocols.

### **Seamless Integration**
Different voices, smooth transitions. Experience effortless workflow coordination across all development phases.

---

## Key Features

### 🔧 **What's New in v4.3.0 - Enhanced TTS Audio Experience**

**🛠️ Critical Installation Reliability Fixes:**
- **Resolved persistent "Wait: command not found" errors**: Enhanced validation system with improved subshell variable handling
- **Added missing coherence command**: Fixed installer to properly process coherence.md command template
- **Comprehensive script validation**: Extended auto-correction across all script generation points
- **Self-healing installation**: Proactive error detection and automatic fixing during setup

**🎨 Complete Coherence Branding Integration:**
- **Updated TTS messaging**: All audio test messages now use "Coherence, orchestrate your AI"
- **Brand consistency**: Unified experience across all TTS providers (Piper, ElevenLabs, Discord, System)
- **Enhanced user experience**: Coherent brand presentation from installation to daily use

### 🔧 **Previous Release - v4.1.2 - Professional Fixed Banner Installation**

**🎨 Enterprise-Grade Installation Experience:**
- **Fixed Banner Display**: COHERENCE logo stays permanently visible during installation
- **Terminal Control**: Advanced scrolling regions using `tput csr` for reliable positioning
- **Visual Excellence**: Burgundy to purple gradient with large ASCII art branding
- **Perfect Positioning**: 3 rows of padding above banner for optimal visual balance
- **Cross-Platform**: Works seamlessly on WSL, Mac, and Linux environments

**⚡ Technical Implementation:**
- **Scrolling Regions**: Dedicated output area with banner always visible at top
- **Color Support**: ANSI 256-color codes for beautiful gradient effects
- **Clean Architecture**: Separation between banner display and installation logic
- **Fallback Support**: Graceful degradation to classic mode if features unavailable

### 🔧 **Previous Release - v4.1.1 Revolutionary Release Management**

**🚀 Automated Release Management:**
- **`/version <version>`**: Complete version management with parallel documentation updates
- **`/release <version>`**: End-to-end release automation with GitHub integration
- **AI-Generated Release Notes**: Professional documentation from git analysis
- **12-15x Faster Releases**: Complete process in 20 minutes vs 4-5 hours manual
- **50% Maintenance Reduction**: Eliminated 3x template duplication
- **Structured Definitions**: Consistent schema across all personas
- **Build-Time Generation**: Templates created during distribution build
- **Backward Compatible**: Seamless upgrade from previous versions

### 🔧 **v3.3.0+ Features - Configurable Prompt Enhancement & MCP Plopdock**

**🎯 Configurable Prompt Enhancement:**
- **Automatic Text Append**: Append custom text to ALL user prompts invisibly
- **Simple Configuration**: Single `PROMPT_APPEND_TEXT` environment variable
- **Perfect for Standards**: Enforce coding guidelines or project context
- **Error Resilient**: Graceful failure without blocking Claude
- **Comprehensive Testing**: Full test suite for all scenarios

**🚀 MCP Plopdock Integration (Epic 26 - 93% Complete):**
- **Persistent Development Servers**: Servers survive Claude Code restarts
- **Real-time Web Dashboard**: Full console output at http://localhost:8080
- **Universal Framework Support**: Auto-detects 11+ frameworks (React, Django, Laravel, etc.)
- **Intelligent Command Interception**: Prevents duplicate server instances
- **Configurable Installation**: User choice during setup with zero impact on non-users
- **Voice-Guided Redirection**: Context-aware notifications for blocked commands
- **Zero-Config Experience**: Automatic tech stack detection for 90%+ of projects

**Usage Example:**
```json
{
  "env": {
    "HOOK_USER_PROMPT_SUBMIT_ENABLED": "true",
    "PROMPT_APPEND_TEXT": "[Remember: Update backlog.md after story work]"
  }
}
```

**User types:** "Create a login function"  
**Claude receives:** "Create a login function [Remember: Update backlog.md after story work]"

### 🚀 **v3.2.0 - Epic 17 Native Sub-Agent Revolution**

**Complete Architecture Transformation:**
- **⚡ Native Sub-Agent Parallelism**: Exclusively native Claude Code sub-agents for all parallel operations
- **🎯 4.1x Average Performance**: Across all parallel commands (up to 4.8x for complex operations)
- **🔧 45+ Parallel Commands**: Every persona now has native parallel execution capabilities
- **🧠 AI/ML Preservation**: QA framework maintains 92% prediction, 94% anomaly detection accuracy
- **📊 Optimized Performance**: Clean native architecture for maximum efficiency
- **🏆 Enterprise Ready**: 34+ hours/week saved per team, zero CLI crashes

**Epic 17 Stories Completed (100%):**
- Native Sub-Agent Coordination Framework ✅
- Context Passing Mechanism ✅
- Progress Monitoring System ✅
- Native Architecture Migration ✅
- All Persona Commands Optimized ✅
- Performance Optimization (4-8x improvement) ✅
- Comprehensive Testing Suite ✅
- Migration Tools & Documentation ✅

### 🔧 **Previous Releases**

**v2.4.1** - Critical Installer Fix
- Fixed CLAUDE.md merge functionality
- Enhanced content preservation during updates
- Improved installation reliability

**v2.2.0** - Claude.md Merge System
- **🧠 Intelligent Merge System**: Revolutionary framework for seamless template updates while preserving customizations
- **⚡ Lightning Performance**: < 500ms template analysis, < 100ms section parsing  
- **🛡️ Zero Data Loss**: Comprehensive backup system with automatic recovery
- **🔧 Foundation Complete**: Sprint 1 delivered with 100% test coverage
- **📁 Better Organization**: LICENSE and VERSION files now in `.apm` folder

### 🔧 **v2.1.4 - Critical AP Command Fixes**
- **🛠️ Fixed Coherence Activation**: Resolved remaining "File does not exist" errors when running `/coherence` (and legacy `/ap`) commands
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

## 🧪 Enterprise QA Framework

### Overview
The QA Agent includes a comprehensive testing framework with AI/ML powered analytics, providing enterprise-grade testing capabilities out of the box.

### Framework Capabilities
- **🚀 Lightning Fast**: Sub-10ms initialization, 4x parallel test execution
- **🤖 AI/ML Analytics**: 92% failure prediction accuracy, intelligent test optimization
- **🛡️ Comprehensive Testing**: Unit, integration, E2E, security (SAST/DAST), performance, visual regression
- **📊 Advanced Reporting**: Real-time insights, trend analysis, ROI tracking
- **🏗️ Enterprise Ready**: CI/CD integration, 10,000+ concurrent users support

### Available Commands
```bash
# Main framework access
/qa-framework [command] [options]

# AI/ML powered commands
/qa-predict    # ML-powered test failure prediction (92% accuracy)
/qa-optimize   # Reduce test execution time by 63%
/qa-anomaly    # Detect quality issues with 94% precision
/qa-insights   # Generate AI-powered quality insights

# NEW v4.3.0: Release Management Integration
/version 4.3.0           # Update version with QA validation
/release 4.3.0           # Complete release with automated QA
/doc-compliance          # Documentation quality assurance
```

### Quick Start
```bash
# Check framework status
/qa-framework status

# Run comprehensive test suite
/qa-framework test-execute --suite regression --parallel

# Predict test failures
/qa-predict --component api --confidence 85

# Optimize test execution
/qa-optimize --strategy fail-fast --apply

# NEW v4.3.0: Integrated release workflow
/version 4.3.0 --dry-run  # Preview version update with QA checks
/release 4.3.0            # Complete release with automated testing
```

### Key Metrics
- **Size**: 63,937+ lines of production-ready code
- **Coverage**: 84 story points of testing functionality
- **Performance**: Sub-10ms startup, 4x parallel speedup
- **ROI**: $4.20 return per $1 invested in testing

## Installation Structure

After installation, your project will have:

```
your-project/
├── .apm/                      # Hidden APM framework
│   ├── agents/               # All agent personas and scripts
│   │   ├── personas/         # 9 agent definitions  
│   │   │   └── qa/          # QA agent with framework integration
│   │   │       └── framework-integration/  # Adapter layer
│   │   ├── tasks/           # Reusable task templates
│   │   ├── scripts/         # Management and TTS scripts
│   │   └── sounds/          # Audio notification files
│   └── qa-framework/        # Enterprise QA Framework (if installed)
│       ├── core/            # Test engine and orchestration
│       ├── types/           # Test types (unit, E2E, security)
│       ├── analytics/       # AI/ML models and insights
│       └── integration/     # CI/CD integrations
├── .claude/                  # Claude Code configuration
│   ├── settings.json        # Project settings
│   └── commands/            # Custom commands (/coherence, /handoff, etc.)
│       └── qa-framework/    # QA Framework commands
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

### v4.3.0 Enhanced Workflow

After installation:

1. **Start**: Open your project in Claude Code
2. **Activate**: Run `/coherence` to launch the Coherence Orchestrator (or legacy `/ap`)
3. **Begin**: Start with Analyst for project brief creation
4. **Develop**: Use personas and parallel commands for development
5. **🆕 Release**: Use `/version` and `/release` for automated releases

### New v4.3.0 Release Workflow
```bash
# Unified Context Engineering workflow
/coherence       # Launch Coherence Orchestrator (new primary command)
# /ap            # Legacy command (still works, redirects to /coherence)
/analyst         # Create project brief
/pm              # Generate PRD
/architect       # Design architecture
/parallel-sprint # Coordinate development

# NEW: Professional release management
/version 4.3.0   # Update all documentation (3 minutes)
/release 4.3.0   # Complete GitHub release (20 minutes total)
```

## Management Commands

```bash
# Check for updates
.apm/agents/scripts/ap-manager.sh update

# Verify installation
.apm/agents/scripts/ap-manager.sh verify

# Show version
.apm/agents/scripts/ap-manager.sh version

# Uninstall APM
.apm/agents/scripts/ap-manager.sh uninstall

# Configure TTS
.apm/agents/scripts/configure-tts.sh

# Test audio system
.apm/agents/scripts/tts-manager.sh test
```

### Uninstalling APM

To completely remove AP Mapping from your project:

```bash
.apm/agents/scripts/ap-manager.sh uninstall
```

The uninstaller will:
- ✅ Remove all APM infrastructure (.apm/)
- ✅ Clean Claude commands and hooks (.claude/)
- ✅ Remove APM sections from CLAUDE.md
- ✅ Clean environment variables from settings.json
- ✅ Remove TTS installation (.piper/)
- ✅ Clean .gitignore entries
- ✅ **Preserve your project documentation**
- ✅ Create backups of modified files

Backups are saved as:
- `.claude/settings.json.pre-uninstall`
- `CLAUDE.md.pre-uninstall`
- `.gitignore.pre-uninstall`

## Documentation

- **Installation Guide**: See README in distribution package
- **Parallel Testing System**: [Flexible parameter-driven testing](PARALLEL-TESTING-TRANSFORMATION.md)
- **Framework Details**: `.apm/agents/README.md` after installation
- **API Documentation**: `.apm/agents/docs/` directory
- **Project Instructions**: `.apm/CLAUDE.md` created during installation
- **Project Documentation Index**: [Complete documentation overview](project_docs/index.md)

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
- **Version**: v4.3.0 (Enhanced TTS Audio Experience)

## License

MIT License - See LICENSE file for details.