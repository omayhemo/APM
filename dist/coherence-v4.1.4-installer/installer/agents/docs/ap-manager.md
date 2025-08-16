# AP Manager Documentation

## Overview

The AP Manager (`ap-manager.sh`) is the central management utility for the Agentic Persona Mapping (APM) framework. It provides essential functionality for installation, updates, verification, and maintenance of the APM system.

## Commands

### Version Check
```bash
.apm/agents/scripts/ap-manager.sh version
```
Displays the current version of the installed APM framework.

### Update Check
```bash
.apm/agents/scripts/ap-manager.sh update
```
Checks for available updates and provides instructions for upgrading to the latest version.

### Verify Installation
```bash
.apm/agents/scripts/ap-manager.sh verify
```
Performs a comprehensive verification of the APM installation, checking:
- All required files are present
- Permissions are correctly set
- Dependencies are installed
- Configuration is valid

### Uninstall APM
```bash
.apm/agents/scripts/ap-manager.sh uninstall
```
Safely removes the APM framework while preserving:
- Project documentation
- Session notes
- User customizations

Creates backups of modified files before removal.

## Features

### Installation Management
- Tracks installation state and version
- Manages component dependencies
- Handles platform-specific configurations

### Update System
- Compares installed version with latest release
- Provides safe update procedures
- Preserves user customizations during updates

### Verification System
- Validates directory structure
- Checks file integrity
- Verifies executable permissions
- Tests audio system if TTS is installed

### Uninstallation
- Clean removal of APM components
- Backup creation before removal
- Restoration of original files
- Cleanup of environment variables

## Configuration

The AP Manager uses the following configuration locations:
- Version info: `.apm/VERSION`
- Settings: `.claude/settings.json`
- Claude.md: Project root

## Error Handling

The AP Manager includes comprehensive error handling:
- Missing file detection
- Permission issues
- Dependency problems
- Network connectivity (for updates)

## Integration

The AP Manager integrates with:
- TTS Manager for audio notifications
- Installer system for updates
- Claude Code settings management
- Git for version control awareness

---
*Last updated: 2025-01-26*