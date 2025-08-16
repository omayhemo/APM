# 🎭 Coherence - Agentic Persona Mapping

**Unified Context Engineering**

[![Version](https://img.shields.io/badge/version-4.1.3-blue.svg)](https://github.com/omayhemo/APM/releases/latest)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Performance](https://img.shields.io/badge/performance-4--8x_faster-orange.svg)](https://github.com/omayhemo/APM)

**Transform complexity into coherence with orchestrated AI persona intelligence.**

Coherence is the AI context engineering platform that brings order to complexity, transforming multiple AI personas into a unified, harmonious system. Like a conductor leading an orchestra, Coherence ensures every persona plays its part perfectly.

## ⚡ Why Coherence?

- **🎭 Unity from Multiplicity** - Multiple personas, coherent output
- **🎼 Orchestrated Intelligence** - Not just AI, but coordinated AI
- **⚙️ Precision Context Control** - Engineering-grade persona management  
- **🔄 Seamless Integration** - Different voices, smooth transitions
- **🚀 4-8x Faster Development** - Native parallel execution across all agents
- **🎯 Zero Setup Time** - Working unified system in under 5 minutes
- **✨ Automatic Claude Code Integration** - Coherence Orchestrator auto-activates
- **💼 Production Ready** - Used by teams shipping real products

## 🎯 Quick Start

### Install (30 seconds)

```bash
# Quick install with defaults (non-interactive)
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults

# Or interactive installation
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash

# Install specific version
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --version 4.1.3

# With TTS voice notifications
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --with-tts --defaults
```

### Your First Command

```bash
# APM Orchestrator automatically activates after installation!
# Just start Claude Code and the enhanced output style is ready

# Activate the orchestrator manually
/ap

# Or jump straight to a specialist
/analyst        # Research and requirements
/architect      # System design  
/dev           # Code implementation
/qa            # Testing and quality
```

## 🤖 Meet Your AI Team

| Agent | Command | Specialty |
|-------|---------|-----------|
| 🔍 **Analyst** | `/analyst` | Research, requirements, market analysis |
| 📊 **Product Manager** | `/pm` | PRDs, product strategy, roadmaps |
| 🏗️ **Architect** | `/architect` | System design, technical architecture |
| 🎨 **Design Architect** | `/design-architect` | UI/UX, frontend architecture |
| 📋 **Product Owner** | `/po` | Backlog management, story grooming |
| 🏃 **Scrum Master** | `/sm` | Sprint planning, story creation |
| 💻 **Developer** | `/dev` | Code implementation, optimization |
| 🔍 **QA Engineer** | `/qa` | Testing, quality assurance, automation |
| 🎯 **Orchestrator** | `/ap` | Coordination, delegation, workflow |

## ⚡ Power Features

### Automatic Claude Code Integration
APM seamlessly integrates with Claude Code:
```bash
# APM Orchestrator output style automatically activated
# Enhanced structured communication patterns
# Evidence-based decision making protocols
# Parallel agent coordination built-in
```

### Parallel Execution
Run multiple agents simultaneously for maximum speed:
```bash
/parallel-sprint    # 4 developers working in parallel
/parallel-qa        # Complete test suite execution
/parallel-prd       # 70% faster document creation
```

### Smart Handoffs
Seamlessly transition between agents:
```bash
/analyst            # Gather requirements
/handoff architect  # Pass context to architect
/handoff dev        # Move to implementation
```

### Release Automation  
Complete release management in minutes:
```bash
/version 2.0.0      # Update all version references
/release 2.0.0      # Build, tag, and publish
```

## 📚 Documentation

After installation, comprehensive documentation is available at:
- `.apm/README.md` - Complete documentation index
- `.apm/documentation/` - All guides and references

## 🚀 Real Results

- **70% faster** PRD creation
- **4.6x faster** sprint completion  
- **92% accuracy** in test predictions
- **34+ hours/week** saved per team

## 🛠️ Requirements

- Claude Desktop (Claude Code) 
- Linux, macOS, or WSL
- 2GB free space
- Git (optional, for version control)

## 📦 Installation Options

The universal installer v2.0 supports flexible command-line options for various installation scenarios:

### Available Options

| Option | Short | Description |
|--------|-------|-------------|
| `--defaults` | `-y` | Non-interactive installation with default settings |
| `--version VERSION` | `-v` | Install specific version (e.g., `--version 4.1.3`) |
| `--path PATH` | `-p` | Custom installation directory |
| `--with-tts` | `-t` | Enable TTS voice notifications |
| `--quiet` | `-q` | Minimal output (silent mode) |
| `--verbose` | `-V` | Detailed debug output |
| `--help` | `-h` | Show all available options |

### Installation Examples

```bash
# 🚀 Quick install with defaults (recommended for automation)
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults

# 📍 Install to specific directory
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --path /opt/apm --defaults

# 🎯 Install specific version
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --version 3.5.0 --defaults

# 🔊 Install with TTS voice notifications
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --with-tts --defaults

# 🤫 Silent installation (CI/CD friendly)
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults --quiet

# 🔍 Debug installation issues
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults --verbose

# 🎪 Full-featured installation
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --path /opt/apm --with-tts --quiet --version 4.1.3

# ❓ Show help and all options
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --help
```

### Interactive vs Non-Interactive

- **Interactive Mode** (default): Prompts for configuration options
  ```bash
  # ✅ NOW WORKS! Fixed in v2.0 - accepts user input even when piped
  curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash
  ```
  You'll be prompted for:
  - Project name
  - Plopdock MCP Server setup
  - TTS provider selection
  - Notification preferences
  - Python support

- **Non-Interactive Mode**: Perfect for automation and scripts
  ```bash
  curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults
  ```
  Uses defaults for all options - no prompts

## 📦 Latest Release

**v4.1.3** - Enhanced Installer Script Validation
- **🔧 Critical bug fix** - Eliminates "Wait: command not found" installation errors
- **Enhanced validation system** - Automatically detects and corrects bash command typos
- **Auto-correction capability** - Uses sed commands to fix capitalized "Wait" commands
- **Transparent operation** - Clear feedback about validation results and fixes applied
- **Prevention framework** - Blocks future similar bash command case sensitivity issues
- **Zero user impact** - Validation runs seamlessly during installation process
- **Built on proven system** - Extends successful v4.1.1 validation framework

[View all releases](https://github.com/omayhemo/APM/releases)

## 🤝 Contributing

APM is actively developed and welcomes contributions. Check our [contribution guidelines](CONTRIBUTING.md) to get started.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🔗 Links

- [Releases](https://github.com/omayhemo/APM/releases)
- [Issues](https://github.com/omayhemo/APM/issues)
- [Discussions](https://github.com/omayhemo/APM/discussions)

---

**Ready to revolutionize your development workflow?** Install APM and experience the power of parallel AI agents working as your team.

```bash
# Get started in 30 seconds (non-interactive)
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults
```

*Built for developers who ship.*