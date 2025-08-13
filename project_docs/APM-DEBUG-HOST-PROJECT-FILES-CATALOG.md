# APM Plopdock - Related Files in This Project

## Overview
This document catalogs all files within the `agentic-persona-mapping` project that are related to the APM Plopdock MCP server. Total: **37 files directly reference apm-plopdock**, plus the entire `/installer/mcp-host/` directory structure.

## File Categories

### 1. Core MCP Host Installation Directory
**Location**: `/mnt/c/Code/agentic-persona-mapping/installer/mcp-host/`

This is the **SOURCE directory** that gets copied to `/home/dougw/.apm-plopdock/` during installation.

#### Main Installation Files
- `install-mcp-host.sh` - Primary installation script
- `README.md` - MCP host documentation
- `cli.js` - CLI interface
- `package.json` - Node.js package configuration
- `package-lock.json` - Dependency lock file
- `.env.template` - Environment variables template
- `config.json.template` - Configuration template

#### Source Code (`/src`)
Complete mirror of what's installed:
- `index.js` - Main MCP server entry point
- `api-key-manager.js` - API key management
- `config-manager.js` - Configuration management
- `error-handler.js` - Error handling
- `health-checker.js` - Health monitoring
- `log-store.js` - Log storage
- `mcp-config-generator.js` - MCP config generation
- `mcp-tools.js` - MCP protocol tools
- `process-manager.js` - Process lifecycle
- `rollback-manager.js` - Rollback functionality
- `tech-stack-detector.js` - Tech stack detection

#### Adapters (`/src/adapters`)
- `base-adapter.js` - Base adapter class
- `node-adapter.js` - Node.js adapter
- `python-adapter.js` - Python adapter
- `php-adapter.js` - PHP adapter

#### Dashboard (`/src/dashboard`)
- `server.js` - Express server
- `websocket-manager.js` - WebSocket management
- **Public files** (`/public`):
  - `index.html` - Dashboard HTML
  - `app.js` - Main application
  - `app-original.js` - Original backup
  - `style.css` - Main styles
  - `additional-styles.css`
  - `real-time-styles.css`
  - `server-control-styles.css`
  - `loading-enhancements.css`
  - `accessibility-enhancements.css`
  - `loading-enhancements.js`
  - `real-time-manager.js`
  - `server-control-features.js`
  - `real-time-enhancements.js`
  - `theme-enhancement.js`
  - Story documentation (`.md` files)

#### Hooks (`/hooks`)
- `pre-install.sh` - Pre-installation hook
- `post-install.sh` - Post-installation hook

#### Configuration (`/configs`)
- `development.env`
- `production.env`
- `staging.env`

#### Scripts (`/scripts`)
- `config-setup.js` - Configuration setup
- `performance-benchmark.js` - Performance testing
- `production-validation.js` - Production validation

#### Templates
- `systemd.service.template` - Linux service template
- `launchd.plist.template` - macOS service template

#### Documentation (`/docs`)
- `CONFIGURATION.md` - Configuration guide
- `README.md` - Main documentation
- **API docs** (`/api`)
- **Developer guides** (`/developer`)
- **Getting started** (`/getting-started`)
  - `installation.md`
  - `dashboard-tour.md`
- **Training** (`/training`)
  - `best-practices.md`

#### Tests (`/tests`)
Comprehensive test suite with 20+ test files:
- Unit tests
- Integration tests
- E2E tests
- Performance tests
- Security tests
- Load tests
- Platform compatibility tests

### 2. Installer Scripts
**Location**: `/mnt/c/Code/agentic-persona-mapping/installer/`

Files that handle MCP host integration:

- `install.sh` - Main APM installer that calls MCP host installation
- `install-mcp-enhanced.sh` - Enhanced installation with MCP support
- `merge-mcp-config.sh` - Merges MCP configuration into project
- `validate-mcp-setup.sh` - Validates MCP setup
- `test-mcp-merge.sh` - Tests configuration merging
- `test-mcp-multi-persona.sh` - Multi-persona testing
- `configure-mcp-interception.sh` - Configures MCP interception

### 3. Template Files
**Location**: `/mnt/c/Code/agentic-persona-mapping/installer/templates/`

#### Claude Integration Templates
- `claude/settings.json.mcp.template` - MCP settings template
- `claude/commands/mcp-install.md.template` - MCP install command template

#### Hook Templates
- `hooks/pre_tool_use_mcp.py` - Python hook for MCP interception
  - Intercepts development server commands
  - Redirects to MCP debug host
  - Provides voice notifications

### 4. Documentation Files
**Location**: `/mnt/c/Code/agentic-persona-mapping/project_docs/`

Project-level documentation about MCP Plopdock:

- `APM-DEBUG-HOST-MIGRATION-PLAN.md` - Migration plan (just created)
- `MCP-DEBUG-HOST-IMPLEMENTATION-GUIDE.md` - Implementation guide
- `MCP-DEBUG-HOST-INTEGRATION-GUIDE.md` - Integration guide
- `MCP-DEBUG-HOST-CONFIGURABLE-IMPLEMENTATION-PLAN.md` - Configurable implementation
- `MCP-DEBUG-HOST-ROLLOUT-STRATEGY.md` - Rollout strategy
- `MCP-SAFE-CONFIG-MERGE-IMPLEMENTATION.md` - Safe config merging
- `MCP-DEBUG-HOST-TECHNICAL-DESIGN.md` - Technical design
- `MCP-SYSTEM-ARCHITECTURE-DIAGRAMS.md` - Architecture diagrams
- `MCP-ARCHITECTURAL-DOCUMENTATION-GUIDELINES.md` - Documentation guidelines

### 5. Project Configuration
**Location**: `/mnt/c/Code/agentic-persona-mapping/`

- `.mcp.json` - Project's MCP configuration (includes apm-plopdock reference)

## File Count Summary

| Category | File Count | Description |
|----------|------------|-------------|
| MCP Host Source | ~150+ | Complete source in `/installer/mcp-host/` |
| Installer Scripts | 8 | Installation and configuration scripts |
| Templates | 3 | Integration templates |
| Documentation | 9 | Project documentation files |
| Configuration | 1 | Project MCP config |
| **Total Direct References** | **37** | Files containing "apm-plopdock" |
| **Total Including Source** | **~200+** | All related files |

## Key Integration Points

### 1. Installation Flow
```
install.sh → install-mcp-enhanced.sh → mcp-host/install-mcp-host.sh
                ↓
        Copies /installer/mcp-host/* → /home/dougw/.apm-plopdock/
                ↓
        merge-mcp-config.sh → Updates project .mcp.json
```

### 2. Hook Integration
```
pre_tool_use_mcp.py → Intercepts dev server commands
                    → Redirects to MCP debug host
                    → Provides voice notifications
```

### 3. Configuration Chain
```
installer/templates/claude/settings.json.mcp.template
    → .claude/settings.json (in target project)
    → References apm-plopdock MCP server
```

## Migration Impact

When migrating to a standalone project, these files will need updates:

### High Priority (Must Update)
1. `installer/install.sh` - Change source location
2. `installer/install-mcp-enhanced.sh` - Update paths
3. `installer/mcp-host/install-mcp-host.sh` - Update to pull from new repo
4. `installer/merge-mcp-config.sh` - Update configuration paths

### Medium Priority (Should Update)
1. Templates - Update references
2. Documentation - Update guides
3. Hooks - Verify compatibility

### Low Priority (Nice to Have)
1. Test files - Update for new structure
2. Examples - Create new examples

## Notes

- The `/installer/mcp-host/` directory is a **complete, self-contained** copy of the MCP Plopdock
- During installation, this entire directory is copied to `/home/dougw/.apm-plopdock/`
- The migration plan should consider whether to:
  1. Keep a copy in APM for bundled installation, OR
  2. Download from the new repository during installation
- Current size: ~5MB (excluding node_modules)

---

*Document Version: 1.0*
*Created: 2025-01-03*
*Purpose: Catalog all APM project files related to apm-plopdock for migration planning*