# Monitor Tests Command

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


**Command**: `monitor tests`  
**Description**: Launch real-time test monitoring with live console output  
**Version**: {{VERSION}}

## Overview

The `monitor tests` command activates the APM Framework's real-time test monitoring system, providing live visibility into test execution, process tracking, and quality metrics.

## Usage

```bash
# Basic real-time monitoring
monitor tests

# Monitor with custom refresh interval
monitor tests --interval 5

# Show status once and exit
monitor tests --once

# Monitor only running test processes
monitor tests --processes

# Monitor only QA reports
monitor tests --reports
```

## Features

- **Real-time Process Tracking**: Monitor Jest, Pytest, Mocha, Karma, Vitest
- **File Change Detection**: Track test file modifications
- **Coverage Analysis**: Monitor test coverage reports
- **Performance Metrics**: Track execution times and resource usage
- **Color-coded Output**: Green ✓, Red ✗, Yellow ⚠️ status indicators

## Integration

This command integrates seamlessly with:
- QA Agent personas (`/qa` then `monitor tests`)
- AI/ML test prediction and optimization
- TTS notification system
- Web dashboard monitoring

## Technical Details

- **Script Location**: `/mnt/c/Code/agentic-persona-mapping/.apm/scripts/test-monitoring/qa-monitor-tests.sh`
- **Configuration**: `/mnt/c/Code/agentic-persona-mapping/.apm/config/test-monitoring.yaml`
- **Output Directory**: `/mnt/c/Code/agentic-persona-mapping/project_docs/qa/metrics/`

Execute this command by simply typing `monitor tests` in your Claude Code session.