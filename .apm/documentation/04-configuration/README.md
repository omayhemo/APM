# Coherence Configuration Guide

This directory contains comprehensive configuration guides for **Coherence - Agentic Persona Mapping**, the unified context engineering framework for orchestrated intelligence.

## Configuration Overview

**Coherence - Agentic Persona Mapping** provides extensive configuration options for unified context engineering and orchestrated intelligence:

- **Environment Variables**: Control behavior, paths, and integrations
- **Persona Definitions**: Modify agent behaviors and capabilities
- **Voice Notifications**: Configure audio alerts and notifications
- **Path Structures**: Customize directory layouts and file locations
- **Development Integration**: Configure MCP Plopdock and development tools
- **Unified Context Engineering**: Configure seamless integration and context preservation
- **Orchestrated Intelligence**: Set up coordinated multi-agent workflows

## Configuration File Locations

### Core Configuration
- **Settings**: `/mnt/c/Code/agentic-persona-mapping/.apm/settings.json`
- **Environment**: `/mnt/c/Code/agentic-persona-mapping/.apm/.env` (optional)
- **Claude Configuration**: `/mnt/c/Code/agentic-persona-mapping/.apm/CLAUDE.md`
- **Coherence Configuration**: Unified context engineering settings

### Persona Configuration
- **Master Definitions**: `{{INSTALLER_ROOT}}/personas/_master/*.persona.json`
- **Generated Templates**: `/mnt/c/Code/agentic-persona-mapping/.apm/agents/personas/` (auto-generated)

### Voice Configuration
- **Voice Scripts**: `/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/`
- **Audio Settings**: `/mnt/c/Code/agentic-persona-mapping/.apm/config/voice-config.json`

### Session Management
- **Session Notes**: `/mnt/c/Code/agentic-persona-mapping/.apm/session_notes/`
- **Rules**: `/mnt/c/Code/agentic-persona-mapping/.apm/rules/`
- **Archive**: `/mnt/c/Code/agentic-persona-mapping/.apm/session_notes/archive/`

## Configuration Guides

### 📋 [Initial Setup Guide](./initial-setup.md)
Complete first-time configuration walkthrough for new Coherence installations with unified context engineering setup.

### 🔧 [Environment Variables Guide](./environment-variables.md)
Comprehensive reference for all environment variables and their effects.

### 👤 [Persona Customization Guide](./customizing-personas.md)
Learn how to modify existing personas and create new ones.

### 🔊 [Voice Notifications Guide](./voice-notifications.md)
Configure audio alerts and voice feedback systems.

### 📁 [Path Configuration Guide](./path-configuration.md)
Customize directory structures and file locations.

## Quick Configuration Checklist

### Essential Setup
- [ ] Run `./install.sh` to set up basic structure
- [ ] Configure `/mnt/c/Code/agentic-persona-mapping/.apm/settings.json` with your preferences
- [ ] Set up voice notifications (optional but recommended)
- [ ] Verify persona definitions are correctly generated
- [ ] Test configuration with `/coherence` command (also available as `/ap` for backward compatibility)

### Advanced Configuration
- [ ] Set up MCP Plopdock integration
- [ ] Configure custom environment variables
- [ ] Customize persona behaviors for orchestrated intelligence
- [ ] Set up session management preferences with unified context engineering
- [ ] Configure project-specific paths for seamless integration

## Configuration Validation

To validate your configuration:

```bash
# Test basic Coherence functionality
cd /mnt/c/Code/agentic-persona-mapping
# In Claude Code, run: /coherence (or /ap for backward compatibility)

# Verify voice notifications
/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh "Coherence configuration test"

# Check persona generation
{{INSTALLER_ROOT}}/generate-personas.sh
```

## Common Configuration Issues

### Path Issues
- **Symptom**: Commands fail with "file not found"
- **Solution**: Check `APM_ROOT` in settings.json matches actual installation path

### Persona Loading Issues
- **Symptom**: Personas don't activate properly
- **Solution**: Regenerate persona templates with `generate-personas.sh`

### Voice Notification Issues
- **Symptom**: No audio feedback from agents
- **Solution**: Check voice script permissions and audio system configuration

### Session Management Issues
- **Symptom**: Session notes not saving or loading
- **Solution**: Verify session_notes directory exists and has write permissions

## Environment-Specific Configuration

### Development Environment
- Enable debug logging
- Use development voice scripts
- Configure rapid persona switching

### Production Environment
- Disable debug output
- Use production-optimized paths
- Enable comprehensive logging

### Team Environment
- Shared configuration repository
- Standardized persona definitions
- Centralized voice notification settings

## Support and Troubleshooting

For configuration support:

1. **Check Configuration Logs**: Review `/mnt/c/Code/agentic-persona-mapping/.apm/logs/configuration.log`
2. **Validate Settings**: Use built-in validation tools
3. **Review Documentation**: Each configuration area has detailed guides
4. **Test Incrementally**: Validate each configuration section separately

## Version Compatibility

This configuration guide is for **Coherence - Agentic Persona Mapping** v4.1.0+. Key changes:

- **v4.1.0**: Native sub-agent architecture, unified persona system with orchestrated intelligence
- **v4.1.0**: MCP Plopdock integration, enhanced session management with unified context engineering
- **v4.1.0**: Configurable prompt enhancement, voice notification improvements
- **v4.1.0**: Coherence Orchestrator (replaces AP Orchestrator) with seamless integration capabilities

---

**Next Steps**: Start with the [Initial Setup Guide](./initial-setup.md) for first-time configuration.