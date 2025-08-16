# Sub-Agents Troubleshooting Guide

## 🛠️ Comprehensive Issue Resolution for APM Migration

This troubleshooting guide addresses common issues, edge cases, and resolution strategies for migrating from Legacy APM to Sub-Agents framework.

---

## 🚨 Emergency Quick Reference

### Critical Issues - Immediate Actions

| Issue | Symptoms | Quick Fix | Contact |
|-------|----------|-----------|---------|
| **Installation Failure** | Sub-Agents won't start | Run `./repair-installation.sh` | {{EMERGENCY_INSTALL_SUPPORT}} |
| **Agent Not Responding** | Commands timeout/hang | `killall sub-agents && restart` | {{EMERGENCY_AGENT_SUPPORT}} |
| **Data Loss Risk** | Migration warnings | STOP - Contact support immediately | {{EMERGENCY_DATA_SUPPORT}} |
| **Performance Degradation** | System slower than APM | Run `./performance-diagnostic.sh` | {{EMERGENCY_PERFORMANCE_SUPPORT}} |

### Emergency Contacts
- **Critical Support**: {{EMERGENCY_SUPPORT_PHONE}}
- **24/7 Chat**: {{EMERGENCY_CHAT_SUPPORT}}
- **Escalation**: {{ESCALATION_CONTACT}}

---

## 🔍 Common Migration Issues

### Category 1: Installation and Setup Problems

#### Issue 1.1: Installation Fails with Dependencies Error

**Symptoms**:
```bash
ERROR: Missing dependencies for Sub-Agents installation
Failed to install ML models (tensorflow, pytorch)
Installation terminated with code 1
```

**Root Cause**: Missing system dependencies or insufficient permissions

**Resolution Steps**:
```bash
# Step 1: Check system requirements
./check-system-requirements.sh --detailed

# Step 2: Install missing dependencies
sudo apt-get update && sudo apt-get install python3-dev
pip install --upgrade pip setuptools wheel

# Step 3: Install ML dependencies manually
pip install tensorflow==2.13.0 pytorch==2.0.1

# Step 4: Retry Sub-Agents installation
./install-sub-agents.sh --force-dependencies
```

**Prevention**: Always run system check before installation

**Related Issues**: 1.2, 1.3

#### Issue 1.2: Permission Denied During Installation

**Symptoms**:
```bash
Permission denied: cannot write to /opt/sub-agents/
Failed to create configuration directories
Installation aborted due to insufficient privileges
```

**Resolution**:
```bash
# Option A: Install with sudo (recommended)
sudo ./install-sub-agents.sh --system-wide

# Option B: User-space installation
./install-sub-agents.sh --user-space --prefix=$HOME/.sub-agents

# Option C: Fix permissions
sudo chown -R $USER:$USER /opt/sub-agents/
chmod -R 755 /opt/sub-agents/
```

**Best Practice**: Use system-wide installation for team environments

#### Issue 1.3: Configuration Migration Failure

**Symptoms**:
```bash
WARNING: Could not migrate APM configuration
Legacy settings not found or corrupted
Using default configuration instead
```

**Resolution**:
```bash
# Step 1: Locate legacy APM configuration
find ~ -name ".apm" -type d
find ~ -name "apm.config" -o -name "settings.json"

# Step 2: Manual configuration migration
./migrate-config.sh --source=/path/to/apm/config --target=/opt/sub-agents/config

# Step 3: Validate migration
./validate-config.sh --comprehensive
```

**Backup Strategy**: Always backup configurations before migration

### Category 2: Command Migration Issues

#### Issue 2.1: Legacy Commands Not Working

**Symptoms**:
```bash
$ /dev
Command '/dev' not recognized in Sub-Agents
Use '/developer' instead or enable legacy compatibility
```

**Resolution Options**:
```bash
# Option A: Use new command syntax
/developer              # Instead of /dev
/qa-agent              # Instead of /qa
/orchestrator          # Instead of /ap

# Option B: Enable legacy compatibility mode
./configure-legacy-compatibility.sh --enable
source ~/.sub-agents/legacy-aliases

# Option C: Create custom aliases
echo "alias dev='/developer'" >> ~/.sub-agents/aliases
echo "alias qa='/qa-agent'" >> ~/.sub-agents/aliases
```

**Recommendation**: Learn new commands for full feature access

#### Issue 2.2: Commands Execute Slowly

**Symptoms**:
```bash
$ /developer
[Loading AI models... 45 seconds]
[Initializing analysis engine... 30 seconds]
Developer agent ready (total: 75 seconds)
```

**Performance Optimization**:
```bash
# Step 1: Enable model caching
./configure-performance.sh --enable-model-cache --cache-size=2GB

# Step 2: Warm-up agents on startup
./configure-startup.sh --warm-up-agents --parallel-init

# Step 3: Optimize resource allocation
./configure-resources.sh --memory=8GB --cpu-cores=4

# Step 4: Use lightweight mode for development
/developer --mode=lightweight --ai-features=basic
```

**Expected Performance**: Commands should respond within 5-10 seconds after optimization

#### Issue 2.3: Parallel Commands Causing Conflicts

**Symptoms**:
```bash
$ /parallel-sprint
ERROR: Resource conflict detected
Agent streams interfering with each other
Coordination failure - aborting parallel execution
```

**Resolution**:
```bash
# Step 1: Check resource allocation
./check-resources.sh --parallel-capacity

# Step 2: Configure isolation
./configure-isolation.sh --agent-isolation=high --resource-separation

# Step 3: Adjust parallel limits
./configure-parallel.sh --max-streams=2 --coordination-timeout=30

# Step 4: Test parallel execution
./test-parallel.sh --validation-mode
```

**Best Practice**: Start with 2-3 parallel streams, increase gradually

### Category 3: AI/ML Feature Issues

#### Issue 3.1: ML Predictions Inaccurate

**Symptoms**:
```bash
$ /qa-predict
Prediction accuracy: 45% (below 90% threshold)
Model confidence: LOW
Recommendations may be unreliable
```

**Model Improvement Steps**:
```bash
# Step 1: Check training data quality
./analyze-training-data.sh --quality-metrics

# Step 2: Retrain models with local data
./retrain-models.sh --local-data --validation-split=0.2

# Step 3: Fine-tune model parameters
./tune-models.sh --accuracy-target=90% --iterations=100

# Step 4: Validate improvements
./validate-predictions.sh --test-set=recent --accuracy-threshold=90%
```

**Data Requirements**: Minimum 1000 historical records for accurate predictions

#### Issue 3.2: Code Optimization Suggestions Incorrect

**Symptoms**:
```bash
$ /code-optimize sample.js
SUGGESTED: Remove error handling (reduces code complexity)
SUGGESTED: Use global variables (improves performance)
WARNING: Suggestions may reduce code quality
```

**Fix Optimization Engine**:
```bash
# Step 1: Update optimization rules
./update-optimization-rules.sh --quality-first --security-aware

# Step 2: Configure code standards
./configure-standards.sh --eslint-config --security-rules

# Step 3: Train on quality code samples
./train-optimizer.sh --quality-samples --best-practices

# Step 4: Test optimization
./test-optimization.sh --quality-metrics --security-scan
```

**Quality Control**: Always review AI suggestions before applying

#### Issue 3.3: Analytics Dashboard Shows Incorrect Data

**Symptoms**:
```bash
Analytics showing:
- Productivity: 150% (impossible)
- Quality Score: -20% (invalid)
- Missing data for last 7 days
```

**Data Validation and Repair**:
```bash
# Step 1: Validate data sources
./validate-data-sources.sh --comprehensive --repair-mode

# Step 2: Recalculate metrics
./recalculate-analytics.sh --from-date=2024-01-01 --force-rebuild

# Step 3: Check data pipeline
./check-data-pipeline.sh --trace-issues --fix-broken-connections

# Step 4: Reset analytics if needed
./reset-analytics.sh --backup-first --recalculate-all
```

**Monitoring**: Set up automated data validation checks

### Category 4: Performance and Resource Issues

#### Issue 4.1: High Memory Usage

**Symptoms**:
```bash
System Status:
Memory Usage: 12GB/16GB (75%)
Sub-Agents: 8GB (67% of total)
ML Models: 4GB loaded simultaneously
System Performance: DEGRADED
```

**Memory Optimization**:
```bash
# Step 1: Configure model loading strategy
./configure-memory.sh --lazy-loading --model-unloading=30min

# Step 2: Optimize resource allocation
./optimize-resources.sh --memory-limit=6GB --swap-models

# Step 3: Enable memory monitoring
./monitor-memory.sh --alerts --threshold=80% --action=optimize

# Step 4: Configure garbage collection
./configure-gc.sh --aggressive --interval=5min
```

**Target**: Sub-Agents should use <50% of available memory

#### Issue 4.2: CPU Bottlenecks During Parallel Processing

**Symptoms**:
```bash
$ /parallel-sprint
CPU Usage: 95-100% sustained
Agent response times: 2-5 minutes
Parallel coordination: SLOW
Overall productivity: DECREASED
```

**CPU Optimization**:
```bash
# Step 1: Configure CPU allocation
./configure-cpu.sh --parallel-limit=75% --priority=normal

# Step 2: Enable intelligent scheduling
./configure-scheduler.sh --adaptive --load-balancing

# Step 3: Optimize parallel algorithms
./optimize-parallel.sh --efficiency-mode --cpu-aware

# Step 4: Monitor and adjust
./monitor-cpu.sh --auto-adjust --target-utilization=80%
```

**Best Practice**: Reserve 20-25% CPU for system operations

#### Issue 4.3: Network Connectivity Issues

**Symptoms**:
```bash
ERROR: Cannot connect to ML model servers
Timeout connecting to analytics backend
Some features unavailable in offline mode
Prediction accuracy degraded (no model updates)
```

**Network Troubleshooting**:
```bash
# Step 1: Test connectivity
./test-connectivity.sh --ml-servers --analytics --verbose

# Step 2: Configure offline mode
./configure-offline.sh --local-models --cached-analytics

# Step 3: Set up proxy if needed
./configure-proxy.sh --proxy-server={{PROXY_SERVER}} --auth-required

# Step 4: Enable connection retry
./configure-retry.sh --max-attempts=5 --backoff=exponential
```

**Fallback**: Local models provide 85% of online functionality

### Category 5: Integration and Compatibility Issues

#### Issue 5.1: Legacy APM Files Not Migrating

**Symptoms**:
```bash
Migration Status:
✓ Configuration files (80% success)
✗ Session notes (failed)
✗ Custom templates (not found)
✗ User preferences (corrupted)
```

**Manual Migration Process**:
```bash
# Step 1: Locate all APM data
./find-apm-data.sh --comprehensive --scan-all-drives

# Step 2: Manual file migration
./migrate-files.sh --source=/old/apm/path --target=/sub-agents/data --force

# Step 3: Convert formats if needed
./convert-formats.sh --session-notes --templates --preferences

# Step 4: Validate migration
./validate-migration.sh --data-integrity --completeness-check
```

**Recovery**: Keep APM backups until migration fully validated

#### Issue 5.2: Team Collaboration Problems

**Symptoms**:
```bash
Team Issues:
- Agent handoffs failing between team members
- Shared configurations not synchronizing  
- Parallel coordination across team members unstable
- Session sharing corrupted
```

**Team Setup Repair**:
```bash
# Step 1: Configure shared workspace
./setup-team-workspace.sh --shared-config --synchronized-state

# Step 2: Test team coordination
./test-team-coordination.sh --all-members --handoff-simulation

# Step 3: Fix synchronization
./fix-sync.sh --shared-sessions --real-time-updates

# Step 4: Validate team workflows
./validate-team-workflows.sh --collaboration-patterns
```

**Team Best Practices**: Regular coordination tests and shared configuration validation

#### Issue 5.3: IDE Integration Not Working

**Symptoms**:
```bash
IDE Status:
VS Code Extension: NOT DETECTED
IntelliJ Plugin: INITIALIZATION FAILED  
Sub-Agents commands not available in IDE
Code analysis not running automatically
```

**IDE Integration Fix**:
```bash
# Step 1: Install/reinstall IDE extensions
./install-ide-extensions.sh --vscode --intellij --force-reinstall

# Step 2: Configure IDE integration
./configure-ide.sh --auto-detection --code-analysis --real-time

# Step 3: Test integration
./test-ide-integration.sh --all-features --validation-mode

# Step 4: Set up auto-updates
./setup-auto-updates.sh --ide-extensions --sync-with-sub-agents
```

**Supported IDEs**: VS Code, IntelliJ IDEA, Eclipse, Vim/Neovim

---

## 🎯 Advanced Troubleshooting Techniques

### Diagnostic Tools and Commands

#### System Health Check
```bash
# Comprehensive system diagnostic
./sub-agents-diagnostic.sh --full-report --export-logs

# Quick health check
./health-check.sh --critical-only --fix-issues

# Performance analysis
./performance-analysis.sh --bottlenecks --optimization-suggestions
```

#### Log Analysis
```bash
# View detailed logs
tail -f /var/log/sub-agents/main.log
tail -f /var/log/sub-agents/agents/*.log

# Search for specific issues
grep -r "ERROR\|FAILED\|TIMEOUT" /var/log/sub-agents/

# Analyze performance logs
./analyze-performance-logs.sh --time-range=24h --identify-patterns
```

#### Configuration Validation
```bash
# Validate all configurations
./validate-all-configs.sh --comprehensive --auto-fix

# Check agent configurations
./check-agent-configs.sh --all-agents --compatibility

# Verify resource configurations
./verify-resources.sh --memory --cpu --network --storage
```

### Advanced Recovery Procedures

#### Complete System Reset
```bash
# WARNING: This will reset all configurations
./reset-sub-agents.sh --complete --backup-first --confirm-reset

# Selective reset options
./reset-sub-agents.sh --agents-only --preserve-data
./reset-sub-agents.sh --configs-only --preserve-sessions
./reset-sub-agents.sh --performance-only --preserve-customizations
```

#### Data Recovery
```bash
# Recover from backup
./recover-from-backup.sh --backup-date=2024-01-15 --selective-recovery

# Repair corrupted data
./repair-data.sh --scan-corruption --auto-repair --verify-integrity

# Merge data from multiple sources
./merge-data.sh --source1=/backup/data --source2=/current/data --resolve-conflicts
```

---

## 📋 Issue Resolution Workflows

### Workflow 1: New Installation Issues

```mermaid
graph TD
    A[Installation Fails] --> B{System Requirements Met?}
    B -->|No| C[Install Dependencies]
    B -->|Yes| D{Permissions OK?}
    D -->|No| E[Fix Permissions]
    D -->|Yes| F{Network Access?}
    F -->|No| G[Configure Network]
    F -->|Yes| H[Check Logs]
    C --> I[Retry Installation]
    E --> I
    G --> I
    H --> J{Specific Error?}
    J -->|Yes| K[Apply Specific Fix]
    J -->|No| L[Contact Support]
```

### Workflow 2: Performance Issues

```mermaid
graph TD
    A[Performance Problem] --> B{Resource Usage High?}
    B -->|Memory| C[Optimize Memory]
    B -->|CPU| D[Optimize CPU]
    B -->|Network| E[Fix Network]
    B -->|Storage| F[Clean Storage]
    C --> G[Monitor Improvement]
    D --> G
    E --> G
    F --> G
    G --> H{Performance OK?}
    H -->|Yes| I[Document Solution]
    H -->|No| J[Advanced Optimization]
```

### Workflow 3: Feature Not Working

```mermaid
graph TD
    A[Feature Issue] --> B{Configuration Correct?}
    B -->|No| C[Fix Configuration]
    B -->|Yes| D{Dependencies Met?}
    D -->|No| E[Install Dependencies]
    D -->|Yes| F{Permissions OK?}
    F -->|No| G[Fix Permissions]
    F -->|Yes| H[Check Agent Status]
    C --> I[Test Feature]
    E --> I
    G --> I
    H --> J{Agent Running?}
    J -->|No| K[Start Agent]
    J -->|Yes| L[Check Logs]
    K --> I
    L --> M[Apply Fix]
```

---

## 🔧 Self-Service Repair Tools

### Automated Repair Scripts

#### Quick Fix Script
```bash
#!/bin/bash
# quick-fix.sh - Automated common issue resolution

echo "Sub-Agents Quick Fix Tool"
echo "=========================="

# Check and fix common issues
./check-system-health.sh --auto-fix
./repair-configurations.sh --safe-mode
./restart-agents.sh --graceful
./validate-installation.sh --repair-mode

echo "Quick fix completed. Run health check to validate."
```

#### Performance Optimizer
```bash
#!/bin/bash
# optimize-performance.sh - Automated performance optimization

echo "Optimizing Sub-Agents Performance..."

# Memory optimization
./optimize-memory.sh --adaptive --model-management

# CPU optimization  
./optimize-cpu.sh --parallel-efficiency --load-balancing

# Network optimization
./optimize-network.sh --connection-pooling --timeout-tuning

# Storage optimization
./optimize-storage.sh --cleanup --indexing

echo "Performance optimization completed."
```

#### Configuration Repair Tool
```bash
#!/bin/bash
# repair-configs.sh - Automated configuration repair

echo "Repairing Sub-Agents Configurations..."

# Backup current configs
./backup-configs.sh --timestamp

# Validate and repair
./validate-configs.sh --auto-repair --preserve-customizations

# Test configurations
./test-configs.sh --all-agents --validation-mode

echo "Configuration repair completed."
```

### Manual Repair Procedures

#### Step-by-Step Agent Restart
```bash
# 1. Graceful shutdown
./shutdown-agents.sh --graceful --timeout=30

# 2. Clear temporary files
rm -rf /tmp/sub-agents/*
rm -rf /var/cache/sub-agents/*

# 3. Validate configurations
./validate-configs.sh --quick-check

# 4. Start agents in order
./start-orchestrator.sh --wait-ready
./start-core-agents.sh --parallel --wait-ready
./start-specialized-agents.sh --on-demand

# 5. Verify functionality
./test-agents.sh --basic-functionality
```

#### Manual Data Recovery
```bash
# 1. Stop all agents
./stop-agents.sh --force

# 2. Backup current state
./backup-current-state.sh --comprehensive

# 3. Identify corrupted data
./scan-data-integrity.sh --identify-corruption

# 4. Recover from backup
./restore-from-backup.sh --selective --preserve-recent

# 5. Validate recovery
./validate-data-integrity.sh --comprehensive

# 6. Restart agents
./start-agents.sh --validation-mode
```

---

## 📊 Monitoring and Prevention

### Proactive Monitoring Setup

#### Health Monitoring Dashboard
```bash
# Set up continuous monitoring
./setup-monitoring.sh --health-dashboard --real-time --alerts

# Configure alert thresholds
./configure-alerts.sh --memory=80% --cpu=85% --response-time=10s

# Enable automated responses
./setup-auto-response.sh --memory-cleanup --agent-restart --performance-optimization
```

#### Performance Baselines
```bash
# Establish performance baselines
./establish-baselines.sh --comprehensive --duration=7days

# Monitor performance trends
./monitor-trends.sh --performance --quality --efficiency

# Generate reports
./generate-reports.sh --daily --weekly --monthly --trends
```

### Preventive Maintenance

#### Regular Maintenance Schedule
```bash
# Daily maintenance (automated)
0 2 * * * /opt/sub-agents/maintenance/daily-maintenance.sh

# Weekly maintenance (automated)  
0 3 * * 0 /opt/sub-agents/maintenance/weekly-maintenance.sh

# Monthly maintenance (semi-automated)
0 4 1 * * /opt/sub-agents/maintenance/monthly-maintenance.sh --interactive
```

#### Update Management
```bash
# Configure automatic updates
./configure-updates.sh --auto-security --manual-features --backup-before

# Schedule update checks
./schedule-update-checks.sh --daily-security --weekly-features --monthly-major

# Test updates in staging
./test-updates.sh --staging-environment --rollback-capable
```

---

## 📞 Escalation and Support

### When to Escalate

#### Level 1: Self-Service (0-2 hours)
- **Use**: Documentation, automated tools, quick fixes
- **Issues**: Common problems, configuration issues, basic troubleshooting
- **Resources**: This guide, automated repair tools, community forums

#### Level 2: Community Support (2-8 hours)
- **Use**: Community forums, peer support, advanced troubleshooting
- **Issues**: Complex configuration, integration problems, performance optimization
- **Resources**: {{COMMUNITY_FORUM}}, {{PEER_SUPPORT_CHANNEL}}

#### Level 3: Technical Support (8-24 hours)
- **Use**: Official technical support, expert assistance
- **Issues**: System failures, data corruption, advanced integration
- **Contact**: {{TECHNICAL_SUPPORT_CONTACT}}

#### Level 4: Engineering Escalation (24-48 hours)
- **Use**: Critical system issues, potential bugs, architectural problems
- **Issues**: System-wide failures, data loss, security concerns
- **Contact**: {{ENGINEERING_ESCALATION_CONTACT}}

#### Level 5: Emergency Response (Immediate)
- **Use**: Critical business impact, security breaches, data loss
- **Issues**: Production down, security incidents, critical data corruption
- **Contact**: {{EMERGENCY_RESPONSE_CONTACT}}

### Escalation Information Template

```markdown
## Issue Escalation Report

**Issue Summary**: {{BRIEF_DESCRIPTION}}
**Impact Level**: {{HIGH/MEDIUM/LOW}}
**Business Impact**: {{DESCRIPTION}}
**Environment**: {{PRODUCTION/STAGING/DEVELOPMENT}}

**System Information**:
- Sub-Agents Version: {{VERSION}}
- Operating System: {{OS_INFO}}
- Hardware Specs: {{HARDWARE}}
- Network Environment: {{NETWORK}}

**Troubleshooting Attempted**:
- [ ] Self-service documentation reviewed
- [ ] Automated repair tools executed
- [ ] Configuration validation performed
- [ ] Log analysis completed
- [ ] Community support consulted

**Logs and Diagnostics**:
- System logs: {{LOG_LOCATION}}
- Error messages: {{ERROR_DETAILS}}
- Diagnostic reports: {{DIAGNOSTIC_FILES}}
- Screenshots: {{SCREENSHOT_LINKS}}

**Contact Information**:
- Name: {{USER_NAME}}
- Role: {{USER_ROLE}}
- Email: {{USER_EMAIL}}
- Phone: {{USER_PHONE}}
- Preferred Contact Method: {{CONTACT_PREFERENCE}}
- Timezone: {{USER_TIMEZONE}}
- Urgency: {{URGENCY_LEVEL}}
```

### Support Resources

#### Documentation Links
- **User Guide**: {{USER_GUIDE_URL}}
- **API Documentation**: {{API_DOCS_URL}}
- **Configuration Reference**: {{CONFIG_REFERENCE_URL}}
- **Best Practices**: {{BEST_PRACTICES_URL}}

#### Community Resources
- **Community Forum**: {{COMMUNITY_FORUM_URL}}
- **Discord Channel**: {{DISCORD_CHANNEL}}
- **Stack Overflow Tag**: {{STACKOVERFLOW_TAG}}
- **GitHub Issues**: {{GITHUB_ISSUES_URL}}

#### Official Support Channels
- **Email Support**: {{SUPPORT_EMAIL}}
- **Phone Support**: {{SUPPORT_PHONE}}
- **Chat Support**: {{CHAT_SUPPORT_URL}}
- **Support Portal**: {{SUPPORT_PORTAL_URL}}

---

*Remember: Most issues can be resolved quickly with the right troubleshooting approach. When in doubt, start with the automated diagnostic tools and escalate appropriately based on business impact and complexity.*