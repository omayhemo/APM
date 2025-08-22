# APM Simplified Persona Generation System

This directory contains the simplified persona generation system for the APM (Agentic Persona Mapping) framework.

## 🚀 System Overview

The simplified system uses a **single source of truth** approach:
- Master persona templates in `_master/` directory
- Install-time generation for both Claude subagents and APM personas
- Automatic cleanup of obsolete files

## 📁 Directory Structure

```
personas/
├── README.md                          # This file
├── _master/                           # Single source of truth - persona templates
│   ├── analyst.md.template            # Analyst agent template
│   ├── architect.md.template          # Architect agent template  
│   ├── designer.md.template           # Designer agent template
│   ├── dev.md.template                # Developer agent template
│   ├── orchestrator.md.template       # AP Orchestrator template
│   ├── pm.md.template                 # Project Manager template
│   ├── po.md.template                 # Product Owner template
│   ├── qa.md.template                 # QA Engineer template
│   └── ap_orchestrator.md.template    # Reference file (legacy)
├── _templates/                        # Transformation templates
│   └── claude.persona.template        # Claude subagent YAML wrapper
└── _build/                           # Generation scripts
    └── generate_persona.sh            # Install-time generation script
```

## 🎯 How It Works

### 1. Single Source Templates
All persona definitions are maintained in `_master/` as standard markdown templates. These serve as the single source of truth for both:
- APM personas (installed to `.apm/agents/personas/`)
- Claude subagents (installed to `.claude/agents/`)

### 2. Install-Time Generation
During installation, the `generate_persona.sh` script:
- Reads master templates from `_master/`
- Generates Claude subagents with YAML frontmatter
- Generates APM personas as direct copies
- Automatically cleans up obsolete files

### 3. YAML Frontmatter Addition
For Claude subagents, the system automatically adds:
```yaml
---
name: [Extracted from Role line]
description: [Extracted from Role line]
---
```

## 🔧 Installation Integration

The system is automatically called during APM installation:
```bash
./install.sh --defaults [target-directory]
```

The installer calls `personas/_build/generate_persona.sh` which:
1. Creates `.claude/agents/[persona].md` (with YAML header)
2. Creates `.apm/agents/personas/[persona].md` (direct copy)
3. Cleans up obsolete directories and files

## 🧹 Automatic Cleanup

The system automatically removes obsolete files during installation:

### Obsolete Directories Removed
- `chaining`, `context`, `coordination`, `documentation`
- `dual-mode`, `implementation-sprint-coordination`, `migration`
- `monitoring`, `qa-framework`, `sprint-coordination`
- `user-guide`, `voice`

### Obsolete Files Removed
- `parallel-execution-patterns.md`
- `synthesis-patterns.md` 
- `task-coordination.md`

## 📝 Persona Definitions

All 8 APM personas are defined as master templates:

### Core Personas
1. **Analyst** - Research & Requirements Expert
2. **Architect** - System Design Authority  
3. **Designer** - UI/UX Design Authority
4. **Developer** - Implementation Specialist
5. **PM** - Product Management Strategist
6. **PO** - Product Ownership Authority
7. **QA** - Quality Assurance Guardian

### Central Coordinator
8. **Orchestrator** - Central Coordination Hub

## ✅ Benefits

### Simplified Maintenance
- **Single source of truth**: Only edit files in `_master/`
- **No duplicate templates**: No more sync issues between APM/Claude templates
- **Automatic generation**: No manual template management

### Clean Installation
- **Install-time generation**: Templates created when needed
- **Automatic cleanup**: Obsolete files removed automatically
- **Consistent output**: Both systems generated from same source

### Developer Experience
- **Easy updates**: Edit one file in `_master/`, affects both outputs
- **Clear structure**: Simple directory organization
- **Reliable process**: Tested and validated generation

## 🔄 Usage

### To Update a Persona
1. Edit the template file in `_master/[persona].md.template`
2. Run installation - personas are automatically generated

### To Add a New Persona
1. Create new template in `_master/new-persona.md.template`
2. Follow existing template format with `# Role: Name - Description` header
3. Run installation - new persona automatically generated for both systems

## 🎉 Migration Complete

This simplified system replaces the previous complex JSON-based generation system. The old system had:
- ❌ 131-line JSON definitions
- ❌ Complex Jinja2-style templating
- ❌ Multiple generation scripts
- ❌ Build-time template processing

The new system provides:
- ✅ Simple markdown templates
- ✅ Install-time generation
- ✅ Single script for all generation
- ✅ Automatic cleanup

---

*The simplified persona generation system provides the same functionality as the previous complex system with significantly reduced complexity and improved maintainability.*