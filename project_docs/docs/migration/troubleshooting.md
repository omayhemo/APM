# Troubleshooting Guide

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

```bash
# Check APM version
cat .apm/VERSION

# Verify command structure
ls -la .claude/commands/

# Test voice system
bash .apm/agents/scripts/tts-manager.sh test

# Check session notes
ls -la .apm/session_notes/
```

## Getting Help

1. Check the [Migration Guide](migration-guide.md)
2. Review [API Reference](../api/parallel-commands.md)
3. Examine working examples in `.claude/commands/`
4. Create detailed session notes for debugging

---
*Last updated: 2025-01-26*  
*Related: [Migration Guide](migration-guide.md) | [Native Architecture](../architecture/native-agent-architecture.md)*