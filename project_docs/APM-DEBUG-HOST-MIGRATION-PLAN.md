# APM Plopdock Migration Plan

## Executive Summary
Plan to migrate the APM Plopdock MCP server from its current location (`/home/dougw/.apm-plopdock/`) to a standalone project repository. This will enable better version control, easier distribution, and independent development.

## Current Architecture Catalog

### 1. Core Installation Location
**Primary Directory**: `/home/dougw/.apm-plopdock/`

#### Root Level Files
- `package.json` - Node.js package configuration
- `package-lock.json` - Dependency lock file
- `config.json` - Main configuration file
- `.env` - Environment variables
- `GLOBAL_SETUP.md` - Global setup documentation
- `cli.js` - CLI interface
- `start-dashboard-standalone.sh` - Standalone dashboard launcher
- `start-global.sh` - Global service launcher
- `run-global-service.sh` - Service runner script
- `server.log` - Server log file
- `dashboard-standalone.log` - Dashboard log file
- `npm-install.log` - Installation log

#### Source Code Structure (`/src`)
**Core Components**:
- `index.js` - Main entry point for MCP server
- `config-manager.js` - Configuration management
- `mcp-tools.js` - MCP protocol tools
- `process-manager.js` - Process lifecycle management
- `log-store.js` - Log storage and retrieval
- `api-key-manager.js` - API key management
- `health-checker.js` - Health monitoring
- `rollback-manager.js` - Rollback functionality
- `error-handler.js` - Error handling
- `tech-stack-detector.js` - Technology stack detection
- `mcp-config-generator.js` - MCP configuration generation

**Adapters** (`/src/adapters`):
- `base-adapter.js` - Base adapter class
- `node-adapter.js` - Node.js server adapter
- `python-adapter.js` - Python server adapter
- `php-adapter.js` - PHP server adapter

**Dashboard** (`/src/dashboard`):
- `server.js` - Express server for dashboard
- `websocket-manager.js` - WebSocket management

**Dashboard Public Files** (`/src/dashboard/public`):
- `index.html` - Main dashboard HTML
- `app.js` - Main dashboard application
- `app-original.js` - Original app backup
- `websocket-manager.js` - Client-side WebSocket
- `style.css` - Main styles
- `additional-styles.css` - Additional styling
- `real-time-styles.css` - Real-time features styling
- `server-control-styles.css` - Server control styling
- `loading-enhancements.css` - Loading indicators
- `accessibility-enhancements.css` - Accessibility features
- `loading-enhancements.js` - Loading functionality
- `real-time-manager.js` - Real-time data management
- `server-control-features.js` - Server control features
- `real-time-enhancements.js` - Real-time enhancements
- `theme-enhancement.js` - Theme management
- Story documentation files (`.md`)

### 2. External References

#### Global Claude Configuration
**File**: `/home/dougw/.claude.json`
```json
"apm-plopdock": {
  "type": "stdio",
  "command": "node",
  "args": ["/home/dougw/.apm-plopdock/src/index.js"],
  "env": {
    "CONFIG_PATH": "/home/dougw/.apm-plopdock/config.json",
    "PORT": "8080"
  }
}
```

#### APM Installer References
**Files in** `/mnt/c/Code/agentic-persona-mapping/installer/`:
- `install.sh` - Main installer script
- `install-mcp-enhanced.sh` - Enhanced MCP installer
- `merge-mcp-config.sh` - MCP configuration merger
- `validate-mcp-setup.sh` - Setup validation
- `test-mcp-merge.sh` - Merge testing

**MCP Host Installer** (`/installer/mcp-host/`):
- `install-mcp-host.sh` - MCP host installation script
- `hooks/pre-install.sh` - Pre-installation hook
- `hooks/post-install.sh` - Post-installation hook
- Source files copied during installation

#### Project Integration Files
**Templates** (`/installer/templates/`):
- `.claude/hooks/pre_tool_use_mcp.py` - MCP interception hook
- Various command templates that reference MCP debug host

### 3. Dependencies (from package.json)
```json
{
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "express": "^4.18.0",
    "winston": "^3.11.0",
    "ws": "^8.14.0",
    "dotenv": "^16.3.0",
    "axios": "^1.6.0",
    "cors": "^2.8.5",
    "uuid": "^9.0.0"
  }
}
```

## Migration Plan

### Phase 1: Project Setup (Week 1)

#### 1.1 Create New Repository
- [ ] Create GitHub repository: `apm-plopdock`
- [ ] Initialize with proper `.gitignore`
- [ ] Set up CI/CD pipeline
- [ ] Create comprehensive README.md

#### 1.2 Project Structure
```
apm-plopdock/
├── src/
│   ├── core/           # Core MCP functionality
│   ├── adapters/       # Framework adapters
│   ├── dashboard/      # Web dashboard
│   └── utils/          # Utilities
├── dist/               # Compiled output
├── config/             # Configuration templates
├── scripts/            # Installation/management scripts
├── docs/               # Documentation
├── tests/              # Test suite
└── examples/           # Example configurations
```

### Phase 2: Code Migration (Week 1-2)

#### 2.1 Core Components
- [ ] Migrate all source files from `/home/dougw/.apm-plopdock/src/`
- [ ] Refactor code for better modularity
- [ ] Add TypeScript support (optional but recommended)
- [ ] Implement proper error boundaries

#### 2.2 Dashboard Enhancement
- [ ] Consolidate dashboard JavaScript files
- [ ] Minimize CSS duplication
- [ ] Add build process (webpack/rollup)
- [ ] Implement proper state management

#### 2.3 Configuration System
- [ ] Create default configuration templates
- [ ] Support multiple configuration sources
- [ ] Add environment variable support
- [ ] Create configuration migration tool

### Phase 3: Installation System (Week 2)

#### 3.1 Standalone Installer
- [ ] Create npm package for easy installation
- [ ] Develop standalone installer script
- [ ] Support multiple installation methods:
  - NPM global install
  - Docker container
  - Direct binary download
  - Source installation

#### 3.2 Integration Points
- [ ] Create Claude Code MCP plugin
- [ ] Support for multiple IDEs
- [ ] WebSocket API for external tools
- [ ] REST API documentation

### Phase 4: Documentation (Week 2-3)

#### 4.1 User Documentation
- [ ] Installation guide
- [ ] Configuration reference
- [ ] Dashboard user guide
- [ ] Troubleshooting guide

#### 4.2 Developer Documentation
- [ ] API reference
- [ ] Adapter development guide
- [ ] Contributing guidelines
- [ ] Architecture documentation

### Phase 5: Testing & QA (Week 3)

#### 5.1 Test Suite
- [ ] Unit tests for core components
- [ ] Integration tests for adapters
- [ ] E2E tests for dashboard
- [ ] Performance benchmarks

#### 5.2 Compatibility Testing
- [ ] Test with various Node.js versions
- [ ] Test on different platforms (WSL, Linux, macOS)
- [ ] Test with different frameworks
- [ ] Load testing for multiple sessions

### Phase 6: Migration & Rollout (Week 3-4)

#### 6.1 Migration Tools
- [ ] Create migration script from current installation
- [ ] Backup existing configurations
- [ ] Data migration for logs/sessions
- [ ] Rollback capability

#### 6.2 APM Installer Updates
- [ ] Update installer to use new repository
- [ ] Maintain backward compatibility
- [ ] Create version detection
- [ ] Update documentation

## Technical Considerations

### 1. Breaking Changes
- **Path Changes**: All hardcoded paths to `/home/dougw/.apm-plopdock/` must be updated
- **Configuration**: New configuration format may require migration
- **API Changes**: Ensure backward compatibility or provide migration path

### 2. Compatibility Requirements
- Node.js 18+ (current: v22.16.0)
- WebSocket protocol version compatibility
- MCP SDK version alignment
- Claude Code integration requirements

### 3. Security Considerations
- API key generation and storage
- CORS configuration for dashboard
- WebSocket authentication
- File system access controls

### 4. Performance Optimizations
- Implement connection pooling
- Add caching layer for logs
- Optimize WebSocket message handling
- Dashboard lazy loading

## Rollback Strategy

### Immediate Rollback
1. Keep current installation intact during migration
2. Maintain symlinks for compatibility
3. Provide switch mechanism between versions

### Data Preservation
1. Export all logs before migration
2. Backup configuration files
3. Document all customizations
4. Maintain session state

## Success Metrics

### Technical Metrics
- [ ] Zero downtime during migration
- [ ] < 100ms dashboard response time
- [ ] Support for 50+ concurrent sessions
- [ ] 99.9% uptime target

### User Experience Metrics
- [ ] Simplified installation (< 2 minutes)
- [ ] Improved dashboard performance
- [ ] Better error messages
- [ ] Enhanced documentation

## Timeline

| Phase | Duration | Start Date | End Date | Status |
|-------|----------|------------|----------|--------|
| Phase 1: Setup | 1 week | TBD | TBD | Pending |
| Phase 2: Migration | 1-2 weeks | TBD | TBD | Pending |
| Phase 3: Installation | 1 week | TBD | TBD | Pending |
| Phase 4: Documentation | 1-2 weeks | TBD | TBD | Pending |
| Phase 5: Testing | 1 week | TBD | TBD | Pending |
| Phase 6: Rollout | 1-2 weeks | TBD | TBD | Pending |

## Risk Assessment

### High Risk
- Breaking existing installations
- Loss of configuration/data
- Incompatibility with Claude Code

### Medium Risk
- Performance degradation
- Installation complexity
- Documentation gaps

### Low Risk
- UI/UX issues
- Minor bugs
- Feature parity

## Next Steps

1. **Immediate Actions**:
   - Create GitHub repository
   - Set up basic project structure
   - Begin code migration

2. **Planning**:
   - Review with stakeholders
   - Finalize timeline
   - Assign resources

3. **Communication**:
   - Notify users of upcoming changes
   - Create migration guide
   - Set up support channels

## Appendix: File Inventory

### Files to Migrate
Total files: ~40 core files + dependencies
Size estimate: ~5MB (excluding node_modules)
Dependencies: 9 direct, ~100 transitive

### Configuration Files to Update
- APM installer scripts (8 files)
- Claude configuration templates
- Hook scripts
- Documentation references

### External Dependencies
- Node.js runtime
- npm/yarn package manager
- System services (systemd/init)
- WebSocket-capable browser

---

*Document Version: 1.0*
*Created: 2025-01-03*
*Status: Draft*