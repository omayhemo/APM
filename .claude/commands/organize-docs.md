# Organize Documentation System

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the Analyst persona.**

```markdown
*Loading Analyst context for documentation management...*

Quick Context Load (1-2 seconds):
- Loading Analyst configuration and expertise
- Loading relevant frameworks and methodologies
- Voice notification: bash $/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakAnalyst.sh "Analyst context loaded for documentation management"
- Workspace validation: Ensuring execution from /mnt/c/Code/agentic-persona-mapping

*Analyst context ready. Proceeding with command...*
```


**Command**: `/organize-docs`

## Description

A comprehensive documentation organization system that analyzes, validates, and reorganizes project documentation to ensure proper structure and connectivity.

## Overview

The organize-docs system helps maintain clean, well-structured documentation by:
- Finding orphaned documents not linked from any index
- Detecting and fixing broken links
- Creating comprehensive index files
- Generating documentation dependency graphs
- Safely reorganizing documentation with rollback capability

## Usage

```bash
/organize-docs [subcommand] [options]
```

## Core Functionality

The system is implemented as:
- Main script: `${AP_ROOT}/scripts/organize-docs/organize-docs.sh`
- Python parser: `${AP_ROOT}/scripts/organize-docs/doc-parser.py`
- Configuration: `${AP_ROOT}/config/organize-docs.yaml`

## Quick Start

1. **Scan documentation**:
   ```bash
   /organize-docs scan --verbose
   ```

2. **Check and fix issues**:
   ```bash
   /organize-docs scan --check-links --fix
   ```

3. **Generate health report**:
   ```bash
   /organize-docs health
   ```

## Implementation

When this command is invoked:

1. Execute the organize-docs script with provided arguments
2. The script will analyze the project_docs directory
3. Results will be displayed with actionable recommendations

```bash
bash ${AP_ROOT}/scripts/organize-docs/organize-docs.sh "$@"
```

---
*Part of the APM Documentation Organization System*