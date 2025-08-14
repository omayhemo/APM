# Show Test Status Command

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the QA persona.**

```markdown
*Loading QA context for quality assurance...*

Quick Context Load (1-2 seconds):
- Loading QA configuration and expertise
- Loading relevant frameworks and methodologies
- Voice notification: bash $/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakQA.sh "QA context loaded for quality assurance"
- Workspace validation: Ensuring execution from /mnt/c/Code/agentic-persona-mapping

*QA context ready. Proceeding with command...*
```


**Command**: `show test status`  
**Description**: Display quick test execution status and health overview  
**Version**: {{VERSION}}

## Overview

The `show test status` command provides an instant snapshot of your testing environment status, showing active processes, recent activity, and overall test health in a concise format.

## Usage

```bash
# Show comprehensive test status
show test status

# Quick status check (alias)
show test status --quick

# Detailed status with metrics
show test status --detailed
```

## Status Information

### Active Processes
- Currently running test suites
- Process identification and resource usage
- Test framework detection (Jest, Pytest, etc.)
- Execution duration and progress

### Recent Activity
- Latest test file modifications
- Recent test executions
- Coverage report updates
- QA report generation

### Test Health Indicators
- Pass/fail ratios from recent runs
- Coverage percentage trends
- Performance degradation alerts
- Quality gate status

### QA Framework Status
- APM QA agent availability
- AI/ML analytics operational status
- Prediction accuracy metrics
- Optimization recommendations available

## Output Format

The command provides color-coded status indicators:

- **🟢 Green**: Healthy status, tests passing, systems operational
- **🟡 Yellow**: Warnings, performance issues, or incomplete coverage  
- **🔴 Red**: Failures, errors, or critical issues requiring attention

## Quick Health Check

```
=== Test Status Overview ===
✓ Active Processes: 2 (Jest, Pytest)
✓ Recent Activity: 5 files modified (last 1 hour)
✓ Coverage: 94% (target: 90%)
⚠ Performance: 15% slower than baseline
✓ QA Framework: Operational (92% prediction accuracy)
```

## Integration

- **QA Agent**: Available within QA persona sessions
- **Monitoring**: Integrates with real-time monitoring system
- **Dashboard**: Quick status shown in web dashboard
- **CI/CD**: Status checks for automated pipelines

## Use Cases

### Development Workflow
- Quick health check before commits
- Status verification after test runs
- Pre-deployment quality validation

### Team Communication
- Stand-up meeting status updates
- Quick status sharing in chat/Slack
- Management reporting summaries

### CI/CD Integration
- Pipeline health checks
- Quality gate validation
- Automated status reporting

## Technical Details

- **Implementation**: Wrapper around monitoring tools
- **Data Sources**: Process monitoring, file system, QA reports
- **Response Time**: Sub-second status generation
- **Caching**: 30-second cache for frequent requests

## Related Commands

- `monitor tests` - Full real-time monitoring
- `test dashboard` - Web-based detailed view
- `test metrics` - Comprehensive data collection

Execute this command by typing `show test status` in your Claude Code session for an instant test environment health check.