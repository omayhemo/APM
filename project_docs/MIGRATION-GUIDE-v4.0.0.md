# Migration Guide: APM v3.5.0 to v4.0.0

This comprehensive guide helps you smoothly transition from APM Framework v3.5.0 to v4.0.0, the **"AI-Powered Enterprise Evolution"** release.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Pre-Migration Checklist](#pre-migration-checklist)
3. [Breaking Changes](#breaking-changes)
4. [Step-by-Step Migration](#step-by-step-migration)
5. [Configuration Updates](#configuration-updates)
6. [New Features](#new-features)
7. [Troubleshooting](#troubleshooting)
8. [Backup and Rollback Procedures](#backup-and-rollback-procedures)
9. [Post-Migration Validation](#post-migration-validation)

## Overview

APM v4.0.0 represents a **major architectural evolution** with the following transformative changes:

### 🚀 What's New in v4.0.0
- **AI-Powered Code Analysis**: Intelligent codebase understanding and optimization
- **Enterprise Cloud Integration**: Scalable multi-team coordination
- **Advanced ML Analytics**: Predictive quality metrics and performance insights
- **Dynamic Persona Loading**: Runtime persona customization and marketplace integration
- **Distributed Agent Coordination**: Multi-instance parallel execution across environments
- **Enhanced Security Framework**: Enterprise-grade authentication and audit trails

### Migration Complexity
- **Complexity Level**: High (Major architectural changes)
- **Estimated Migration Time**: 2-4 hours
- **Downtime Required**: Yes (15-30 minutes)
- **Rollback Support**: Full rollback capability included

### Breaking Changes Summary
- Configuration file format changes (`.claude/settings.json` → `.claude/config/`)
- Persona JSON schema v2.0 (incompatible with v1.x)
- Hook system redesign (new API required)
- Database migration for analytics (SQLite → PostgreSQL optional)

## Pre-Migration Checklist

### System Requirements

Verify your system meets v4.0.0 requirements:

- [ ] **Claude Code v2.0+** (required for new sub-agent features)
- [ ] **Node.js 18+** (for enhanced web dashboard)
- [ ] **Python 3.9+** (for ML analytics engine)
- [ ] **2GB RAM minimum** (4GB recommended for enterprise features)
- [ ] **500MB free disk space** (1GB for full analytics database)
- [ ] **Internet connection** (for cloud integration and marketplace)

### Pre-Migration Tasks

- [ ] **Complete Active Work**: Finish or document any in-progress sessions
  ```bash
  # Check for active sessions
  ls ~/.apm/session_notes/*.md | grep -v archive
  
  # Archive incomplete sessions
  /wrap
  ```

- [ ] **Document Customizations**: Record any custom configurations
  ```bash
  # Backup current settings
  cp ~/.claude/settings.json ~/.claude/settings.json.v3.5.0.backup
  
  # List custom personas (if any)
  ls ~/.apm/agents/personas/custom/
  
  # Document TTS configuration
  ~/.apm/scripts/tts-manager.sh status > tts-config-backup.txt
  ```

- [ ] **Version Verification**: Confirm current version
  ```bash
  # Check current APM version
  cat ~/.apm/version.txt
  
  # Verify it's v3.5.0 or higher
  if [ "$(cat ~/.apm/version.txt)" != "3.5.0" ]; then
    echo "WARNING: Must be on v3.5.0 before upgrading to v4.0.0"
  fi
  ```

- [ ] **Disk Space Check**: Ensure adequate space
  ```bash
  # Check available space
  df -h ~/.apm ~/.claude
  
  # Clean old session archives if needed
  find ~/.apm/session_notes/archive -name "*.md" -mtime +90 -exec rm {} \;
  ```

## Breaking Changes

### 🔴 Critical Breaking Changes

#### 1. Configuration Architecture Overhaul

**BREAKING**: Configuration moved from single file to structured directory

**Before (v3.5.0)**:
```
~/.claude/settings.json
```

**After (v4.0.0)**:
```
~/.claude/config/
├── core.yaml           # Core APM settings
├── personas.yaml       # Persona configurations  
├── integrations.yaml   # Cloud and enterprise integrations
├── analytics.yaml      # ML and analytics settings
├── security.yaml       # Authentication and audit settings
└── legacy/
    └── settings.json   # Preserved for migration reference
```

**Migration Required**: Automatic during installation, but custom settings need manual review.

#### 2. Persona Schema v2.0

**BREAKING**: JSON persona format incompatible with v1.x

**Before (v3.5.0)**:
```json
{
  "id": "developer",
  "name": "Developer Agent",
  "capabilities": ["coding", "debugging"]
}
```

**After (v4.0.0)**:
```json
{
  "schema_version": "2.0",
  "metadata": {
    "id": "developer",
    "name": "Developer Agent",
    "version": "4.0.0"
  },
  "capabilities": {
    "core": ["coding", "debugging"],
    "ai_powered": ["code_analysis", "performance_optimization"],
    "enterprise": ["audit_trail", "compliance_check"]
  },
  "ml_config": {
    "prediction_models": ["bug_detection", "code_quality"],
    "training_data": "enabled"
  }
}
```

**Migration**: Automatic conversion with validation warnings for deprecated fields.

#### 3. Hook API v2.0

**BREAKING**: Hook system completely redesigned

**Before (v3.5.0)**:
```python
# pre_tool_use.py
def hook_impl(data):
    return data
```

**After (v4.0.0)**:
```python
# pre_tool_use.py
from apm.hooks import BaseHook

class PreToolUseHook(BaseHook):
    def __init__(self):
        super().__init__(version="2.0")
    
    async def execute(self, context):
        return await self.process(context)
```

**Migration**: Custom hooks must be rewritten. Migration assistant provided.

#### 4. Database Backend Change

**BREAKING**: Analytics database migrated from JSON files to structured database

**Impact**:
- Historical analytics data requires migration
- New query API for accessing metrics
- Optional PostgreSQL for enterprise features

**Migration**: Automatic for most users, manual setup required for PostgreSQL.

### 🟡 Non-Breaking Changes with Deprecation Warnings

#### 1. Legacy Command Syntax

**DEPRECATED** (still works with warnings):
- `/parallel-sprint` → Use `/sprint --parallel` 
- `/qa-framework` → Use `/qa --framework`

#### 2. Direct File Configuration

**DEPRECATED**: Editing `.apm/agents/personas/*.md` files directly
**NEW**: Use persona management CLI or web interface

## Step-by-Step Migration

### Step 1: Download v4.0.0

```bash
# Create migration workspace
mkdir ~/apm-v4-migration && cd ~/apm-v4-migration

# Download latest release
wget https://github.com/omayhemo/APM/releases/download/v4.0.0/apm-v4.0.0.tar.gz

# Verify download integrity
wget https://github.com/omayhemo/APM/releases/download/v4.0.0/apm-v4.0.0.tar.gz.sha256
sha256sum -c apm-v4.0.0.tar.gz.sha256

# Extract
tar -xzf apm-v4.0.0.tar.gz
cd apm-v4.0.0
```

### Step 2: Pre-Migration Validation

```bash
# Run pre-migration checker
./installer/pre-migration-check.sh

# Expected output should show:
# ✅ Current version: v3.5.0 (compatible)
# ✅ System requirements met
# ✅ Backup space available
# ⚠️  Custom configurations detected (will be migrated)
# ⚠️  Custom hooks found (manual update required)
```

### Step 3: Create Complete Backup

```bash
# Run comprehensive backup
./installer/backup-v3.5.0.sh

# This creates:
# ~/.apm.v3.5.0.backup/     - Complete APM backup
# ~/.claude.v3.5.0.backup/  - Complete Claude backup
# ~/apm-migration-data.json - Migration metadata
```

### Step 4: Stop Active Services

```bash
# Stop any running development servers
~/.apm/scripts/server-manager.sh stop-all

# Stop TTS services
~/.apm/scripts/tts-manager.sh stop

# Verify no APM processes running
ps aux | grep -i apm
```

### Step 5: Run Migration Installer

```bash
# Run interactive migration
./installer/install.sh --migrate-from-v3.5.0

# For automated migration with defaults
./installer/install.sh --migrate-from-v3.5.0 --auto-accept

# For enterprise features
./installer/install.sh --migrate-from-v3.5.0 --enable-enterprise
```

#### Migration Process Steps:

1. **Backup Validation** (30 seconds)
   - Verifies backups were created successfully
   - Confirms rollback capability

2. **Configuration Migration** (2-3 minutes)
   - Converts settings.json to new YAML format
   - Migrates persona configurations
   - Updates hook configurations

3. **Database Migration** (1-5 minutes, depending on data)
   - Exports existing analytics data
   - Initializes new database schema
   - Imports historical data

4. **Persona Schema Upgrade** (1-2 minutes)
   - Converts all persona JSON files to v2.0
   - Validates schema compliance
   - Reports deprecated configurations

5. **Hook System Upgrade** (30 seconds)
   - Backs up existing hooks
   - Installs new hook framework
   - Registers compatible hooks

6. **Final Validation** (1 minute)
   - Tests core functionality
   - Validates all personas load correctly
   - Confirms hook system operational

### Step 6: Post-Installation Configuration

```bash
# Initialize new cloud integration (optional)
~/.apm/scripts/cloud-setup.sh

# Configure ML analytics preferences
~/.apm/scripts/ml-config.sh

# Test core functionality
/ap --version  # Should show v4.0.0
```

## Configuration Updates

### New Configuration Structure

#### Core Configuration (`~/.claude/config/core.yaml`)
```yaml
# APM Core Configuration v4.0.0
version: "4.0.0"
mode: "enhanced"  # basic, standard, enhanced, enterprise

# Execution settings
execution:
  parallel_agents: 6  # Increased from 4
  context_isolation: true
  performance_monitoring: true

# New AI features
ai_features:
  code_analysis: true
  predictive_quality: true
  auto_optimization: false  # Enterprise only

# Backward compatibility
legacy_support:
  v3_commands: true
  deprecated_warnings: true
  migration_mode: false  # Set to false after migration complete
```

#### Persona Configuration (`~/.claude/config/personas.yaml`)
```yaml
# Persona Management v4.0.0
schema_version: "2.0"
marketplace:
  enabled: true
  auto_updates: false
  custom_personas: true

# Persona-specific settings
personas:
  developer:
    ai_assistance_level: "advanced"
    code_analysis: true
    performance_hints: true
  
  qa:
    ml_prediction: true
    anomaly_detection: true
    automation_level: "high"
```

### Required Manual Configuration Updates

#### 1. TTS Provider Configuration
```bash
# Reconfigure TTS for v4.0.0
~/.apm/scripts/configure-tts.sh --upgrade-from-v3.5.0

# Test voice notifications
~/.apm/scripts/tts-manager.sh test-all
```

#### 2. Hook Migration (if you have custom hooks)
```bash
# List custom hooks that need updating
find ~/.claude/hooks -name "*.py" -type f

# Use migration assistant
~/.apm/scripts/hook-migration-assistant.sh

# Example: Migrate custom hook
~/.apm/scripts/hook-migration-assistant.sh upgrade ~/.claude/hooks/my_custom_hook.py
```

#### 3. Enterprise Features Setup (optional)
```bash
# Enable cloud integration
~/.apm/scripts/cloud-setup.sh --configure

# Setup team collaboration
~/.apm/scripts/team-setup.sh

# Configure audit logging
~/.apm/scripts/audit-setup.sh
```

## New Features

### 🤖 AI-Powered Code Analysis

**Available immediately after migration**:

```bash
# Analyze codebase intelligence
/analyze-codebase --deep-scan

# Get AI-powered refactoring suggestions
/dev --optimize-code src/

# Predictive bug detection
/qa --predict-issues --confidence=0.8
```

### ☁️ Cloud Integration

**Setup required**:

```bash
# Connect to APM Cloud (optional)
~/.apm/scripts/cloud-setup.sh

# Enable team synchronization
/team --sync-enable

# Access shared persona marketplace
/personas --marketplace
```

### 📊 Enhanced Analytics Dashboard

**Access via web interface**:

```bash
# Start analytics dashboard
~/.apm/scripts/analytics-dashboard.sh start

# Dashboard available at: http://localhost:8081
# Default credentials: admin/apm-v4.0.0
```

### 🔒 Enterprise Security Features

**For enterprise installations**:

```bash
# Enable audit trails
~/.apm/scripts/audit-setup.sh --enable

# Configure RBAC
~/.apm/scripts/rbac-setup.sh

# Setup SSO integration
~/.apm/scripts/sso-setup.sh
```

## Troubleshooting

### Common Migration Issues

#### Issue 1: Migration Fails with "Configuration Parse Error"

**Symptoms**: 
```
ERROR: Failed to parse settings.json
Migration aborted
```

**Solution**:
```bash
# Validate JSON syntax
python3 -m json.tool ~/.claude/settings.json

# Fix JSON syntax errors, then retry migration
./installer/install.sh --migrate-from-v3.5.0 --retry
```

#### Issue 2: Persona Schema Validation Errors

**Symptoms**:
```
WARNING: analyst.persona.json contains deprecated fields
ERROR: Invalid schema version
```

**Solution**:
```bash
# Run persona migration assistant
~/.apm/scripts/persona-migration-assistant.sh

# Manually validate personas
~/.apm/scripts/validate-personas.sh --fix-deprecated
```

#### Issue 3: Hook System Not Working

**Symptoms**:
- Voice notifications not working
- Pre-tool hooks failing
- Custom hooks not executing

**Solution**:
```bash
# Reinstall hook system
~/.apm/scripts/reinstall-hooks.sh

# Test hook system
~/.apm/scripts/test-hooks.sh

# For custom hooks - use migration assistant
~/.apm/scripts/hook-migration-assistant.sh scan
```

#### Issue 4: Database Migration Fails

**Symptoms**:
```
ERROR: Cannot migrate analytics database
Historical data may be lost
```

**Solution**:
```bash
# Export data manually
~/.apm/scripts/export-v3-analytics.sh

# Clean install database
rm -rf ~/.apm/database/
~/.apm/scripts/init-database.sh

# Re-import data
~/.apm/scripts/import-analytics.sh ~/apm-v3-analytics-export.json
```

#### Issue 5: Performance Degradation After Migration

**Symptoms**:
- Slow command execution
- High memory usage
- Delayed responses

**Solution**:
```bash
# Check resource usage
~/.apm/scripts/performance-check.sh

# Optimize configuration for your system
~/.apm/scripts/optimize-config.sh --auto

# Disable resource-intensive features if needed
~/.apm/scripts/config-manager.sh disable ml_analysis
```

### Getting Help

#### Log Files Location
```bash
# Migration logs
tail -f ~/.apm/logs/migration.log

# Runtime logs
tail -f ~/.apm/logs/apm-runtime.log

# Error logs
tail -f ~/.apm/logs/errors.log
```

#### Diagnostic Tools
```bash
# Run comprehensive system check
~/.apm/scripts/system-diagnostic.sh

# Test all core functions
~/.apm/scripts/integration-test.sh

# Generate support bundle
~/.apm/scripts/generate-support-bundle.sh
```

## Backup and Rollback Procedures

### Complete Rollback to v3.5.0

If you need to rollback completely:

```bash
# Stop all v4.0.0 services
~/.apm/scripts/stop-all-services.sh

# Restore v3.5.0 backup
~/.apm/scripts/rollback-to-v3.5.0.sh

# This will:
# 1. Remove v4.0.0 installation
# 2. Restore ~/.apm.v3.5.0.backup to ~/.apm
# 3. Restore ~/.claude.v3.5.0.backup to ~/.claude
# 4. Restart v3.5.0 services
```

### Partial Rollback (Keep v4.0.0 with v3.5.0 Settings)

To keep v4.0.0 but use v3.5.0 configurations:

```bash
# Disable new features
~/.apm/scripts/config-manager.sh set legacy_mode true

# Restore specific configurations
cp ~/.claude.v3.5.0.backup/settings.json ~/.claude/config/legacy/

# Restart with legacy mode
~/.apm/scripts/restart-legacy-mode.sh
```

### Data Recovery

If you lose data during migration:

```bash
# Recover session notes
cp -r ~/.apm.v3.5.0.backup/session_notes/* ~/.apm/session_notes/

# Recover custom personas
cp -r ~/.apm.v3.5.0.backup/agents/personas/custom/* ~/.apm/agents/personas/custom/

# Recover analytics data
~/.apm/scripts/recover-analytics.sh ~/.apm.v3.5.0.backup/
```

## Post-Migration Validation

### Validation Checklist

Run these tests to ensure successful migration:

#### 1. Core Functionality Test
```bash
# Test basic persona activation
/ap
/dev
/qa
/wrap

# Expected: All commands work normally with v4.0.0 enhancements
```

#### 2. New Features Test
```bash
# Test AI-powered features
/analyze-codebase --quick-scan
/dev --ai-assist

# Test enhanced analytics
~/.apm/scripts/analytics-test.sh

# Expected: New features work without errors
```

#### 3. Voice System Test
```bash
# Test TTS system
~/.apm/scripts/tts-manager.sh test

# Test persona voice scripts
/ap
# Expected: Voice notification plays correctly
```

#### 4. Configuration Test
```bash
# Validate new configuration structure
~/.apm/scripts/validate-config.sh

# Check backward compatibility
~/.apm/scripts/test-legacy-commands.sh

# Expected: All configurations valid, legacy commands work
```

#### 5. Performance Test
```bash
# Benchmark performance
~/.apm/scripts/performance-benchmark.sh

# Compare with v3.5.0 baseline
~/.apm/scripts/compare-performance.sh --baseline=v3.5.0

# Expected: Performance equal or better than v3.5.0
```

### Success Indicators

Migration is successful when you see:

- ✅ All personas load correctly
- ✅ Voice notifications working
- ✅ New AI features accessible
- ✅ Analytics dashboard accessible at http://localhost:8081
- ✅ All legacy commands still functional
- ✅ Performance meets or exceeds v3.5.0 baseline
- ✅ No error messages in logs

### Performance Expectations

Post-migration performance should show:

- **Command Execution**: Same or 10-20% faster than v3.5.0
- **Memory Usage**: 20-40% increase (due to AI features) 
- **Disk Usage**: 200-400MB additional space
- **Startup Time**: Similar to v3.5.0 (2-3 seconds)

## Additional Resources

### Documentation
- **New Features Guide**: `~/.apm/docs/v4.0.0-features.md`
- **AI Integration Guide**: `~/.apm/docs/ai-features.md`
- **Enterprise Setup**: `~/.apm/docs/enterprise-setup.md`
- **Troubleshooting**: `~/.apm/docs/troubleshooting-v4.md`

### Support Channels
- **GitHub Issues**: https://github.com/omayhemo/APM/issues
- **Migration Support**: https://github.com/omayhemo/APM/discussions/migration-v4
- **Discord Community**: https://discord.gg/apm-framework
- **Enterprise Support**: enterprise-support@apm-framework.ai

### Training Materials
- **V4.0.0 Feature Walkthrough**: `~/.apm/training/v4-walkthrough.md`
- **AI Features Tutorial**: `~/.apm/training/ai-tutorial.md`
- **Video Guides**: Available at https://docs.apm-framework.ai/v4/videos/

---

## Summary

APM v4.0.0 represents a major evolution in AI-powered development frameworks. While the migration requires careful planning and execution, the new capabilities—including AI-powered code analysis, enterprise cloud integration, and enhanced analytics—deliver transformative value.

**Key Success Factors**:
1. **Complete the pre-migration checklist** thoroughly
2. **Follow the step-by-step migration process** exactly
3. **Test thoroughly** using the post-migration validation checklist
4. **Have rollback ready** in case of unexpected issues
5. **Leverage new features gradually** after confirming migration success

**Migration Timeline**:
- **Planning**: 30 minutes
- **Migration**: 2-4 hours
- **Validation**: 1 hour
- **Feature adoption**: 1-2 weeks

Welcome to **APM v4.0.0** - *The AI-Powered Future of Software Development*! 🚀

---

*For immediate support during migration, join our Discord community or create a GitHub issue tagged with `migration-v4.0.0`.*