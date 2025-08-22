# Troubleshooting Guide

## v4.3.2 Installation Issues (Now Resolved!)

### Critical Installation Bugs Fixed in v4.3.2

**Issue: Installation Stuck in Temporary Directory (FIXED)**
- **Previous Symptom**: Installation files appeared in `/tmp` or similar temporary locations
- **v4.3.2 Solution**: Complete resolution with enhanced path validation
- **Action**: Upgrade to v4.3.2 for automatic fix

**Issue: Version Number Inconsistency (FIXED)**
- **Previous Symptom**: Different version numbers shown across framework files
- **v4.3.2 Solution**: Automatic version synchronization throughout framework
- **Action**: v4.3.2 ensures consistent version display everywhere

**Issue: Installation Failures and Incomplete Setups (FIXED)**
- **Previous Symptom**: Installations would fail partway through or appear incomplete
- **v4.3.2 Solution**: Enhanced validation, automatic recovery, and better error handling
- **Action**: v4.3.2 provides 99%+ installation success rate

### How to Upgrade to v4.3.2 for Fixes

```bash
# Clean installation with all fixes
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --version 4.3.2 --defaults

# Verify fixes applied
cat .apm/VERSION  # Should show 4.3.2
/coherence --version  # Should also show 4.3.2 (consistency!)
pwd  # Should be your project directory (not temp)
```

## Common Issues and Solutions

This guide helps resolve common issues when migrating from Task-based to native sub-agent architecture.

### TypeError: Cannot read properties of undefined

**Symptom**: Error message mentioning undefined 'message' property when using Task tool.

**Cause**: Incompatibility between Task tool and Claude Code CLI.

**Solution**: 
- Update commands to use native sub-agent patterns
- Replace Task tool usage with direct tool calls
- See [Migration Guide](migration-guide.md) for conversion examples

### Commands Not Recognized

**Symptom**: "Unknown command" error despite command being listed.

**Cause**: Template variables not properly substituted or old Task-based implementation.

**Solution**:
1. Check that `{{PROJECT_ROOT}}` variables are replaced with actual paths
2. Ensure command uses native activation patterns
3. Verify `.claude/commands/` directory contains the command file

### Performance Issues

**Symptom**: Slow agent activation or execution.

**Cause**: Still using Task-based delegation instead of native sub-agents.

**Solution**:
- Migrate to native sub-agent patterns
- Enable parallel execution where applicable
- Check [Performance Benchmarks](../performance/benchmarks.md)

### Voice Notifications Not Working

**Symptom**: No audio feedback from agents.

**Cause**: TTS provider not configured or hooks disabled.

**Solution**:
1. Run installer with `-d` flag for defaults
2. Ensure Piper TTS is installed
3. Check hook configurations in settings.json
4. Verify speaker scripts are executable

### Parallel Execution Failures

**Symptom**: Agents not running in parallel as expected.

**Cause**: Using sequential Task calls instead of parallel patterns.

**Solution**:
- Use natural language coordination for parallel agents
- Implement proper dependency management
- See parallel command examples in documentation

## Debug Commands

### v4.3.2 Installation Verification
```bash
# Check version consistency (v4.3.2 improvement)
cat .apm/VERSION  # Should show 4.3.2
/coherence --version  # Should also show 4.3.2

# Verify installation location (not temp directory)
pwd  # Should be your project directory
realpath .apm/  # Should be under your project, not /tmp

# Check installation completeness
ls -la .apm/  # Should show complete framework structure
ls -la .claude/commands/ | wc -l  # Should show 70+ commands
```

### General System Debug Commands
```bash
# Check APM version
cat .apm/VERSION

# Verify command structure
ls -la .claude/commands/

# Test voice system
bash .apm/agents/scripts/tts-manager.sh test

# Check session notes
ls -la .apm/session_notes/

# Test framework activation
/coherence  # Should activate without errors mentioning v4.3.2
```

## Getting Help

1. Check the [Migration Guide](migration-guide.md)
2. Review [API Reference](../api/parallel-commands.md)
3. Examine working examples in `.claude/commands/`
4. Create detailed session notes for debugging

---
*Last updated: 2025-01-26*  
*Related: [Migration Guide](migration-guide.md) | [Native Architecture](../architecture/native-agent-architecture.md)*