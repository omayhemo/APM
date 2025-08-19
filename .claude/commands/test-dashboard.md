# QA Test Dashboard Command

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


**Command**: `qa test dashboard`  
**Description**: Launch web-based test monitoring dashboard with auto-refresh  
**Version**: {{VERSION}}

## Overview

The `qa test dashboard` command launches a modern, web-based monitoring dashboard that provides real-time visibility into test execution status, metrics, and quality analytics through your browser.

## Usage

```bash
# Launch dashboard on default port (2601)
qa test dashboard

# Launch on custom port
qa test dashboard --port 3000

# Launch in specific mode
qa test dashboard --mode executive
qa test dashboard --mode metrics

# Generate HTML file only (no server)
qa test dashboard --generate
```

## Dashboard Modes

### Full Mode (Default)
- Complete test monitoring overview
- Real-time process tracking
- QA framework status
- Recent activity feed
- Available commands reference

### Executive Mode
- High-level quality metrics
- ROI and business impact data
- Executive-friendly summaries
- Strategic quality insights

### Metrics Mode
- Developer-focused technical metrics
- Detailed performance data
- Coverage analysis
- Test execution statistics

## Features

- **Auto-refresh**: Updates every 10 seconds
- **Modern UI**: Gradient design with responsive layout
- **Real-time Data**: Live test process monitoring
- **Multi-Framework Support**: Jest, Pytest, Mocha, Karma, Vitest
- **Export Ready**: Data exportable for analysis

## Dashboard Sections

1. **Active Test Processes**: Running test suites and their status
2. **QA Framework Status**: AI/ML analytics availability and performance
3. **Test Metrics**: Coverage, pass rates, execution times
4. **Recent Activity**: File changes and test updates
5. **Command Reference**: Available monitoring and QA commands

## Integration

- **QA Agent**: Use within QA persona sessions
- **AI/ML Analytics**: Connects with prediction and optimization
- **Monitoring System**: Real-time data from monitoring framework
- **Export Capabilities**: Data available for external analysis

## Technical Details

- **Script Location**: `/mnt/c/Code/agentic-persona-mapping/.apm/scripts/test-monitoring/test-dashboard.sh`
- **Default Port**: 2601 (configurable)
- **Browser Auto-open**: Attempts to open browser automatically
- **Server Options**: Python, Node.js, or system HTTP server

## Access

Once launched, access your dashboard at:
- **Local**: http://localhost:2601 (or custom port)
- **Network**: Dashboard binds to 127.0.0.1 (local only)

Execute this command by typing `qa test dashboard` in your Claude Code session.