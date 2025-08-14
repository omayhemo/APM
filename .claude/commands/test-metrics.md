# Test Metrics Command

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


**Command**: `test metrics`  
**Description**: Collect comprehensive test execution metrics and analytics  
**Version**: {{VERSION}}

## Overview

The `test metrics` command provides comprehensive collection and analysis of test execution data, enabling data-driven quality insights and strategic decision making.

## Usage

```bash
# Collect all metrics
test metrics

# Export in specific format
test metrics --export csv
test metrics --export json
test metrics --export yaml

# Collect specific metric types
test metrics --metrics process
test metrics --metrics coverage
test metrics --metrics qa-framework

# Generate summary report only
test metrics --summary

# Clean old metrics
test metrics --clean
```

## Metric Types

### Process Metrics
- Active test processes (PID, CPU, memory usage)
- Test framework identification
- Process start times and duration
- Resource consumption analysis

### File Metrics
- Test file counts by type (JS, TS, Python)
- Recent file modifications
- File size and change analysis
- Test file organization patterns

### Coverage Metrics
- Coverage report locations
- Coverage directory analysis
- Coverage file timestamps and sizes
- Coverage trend analysis

### QA Framework Metrics
- APM QA agent availability
- AI/ML analytics status
- Framework performance metrics
- Report generation statistics

## Export Formats

### CSV Format
- Spreadsheet-compatible format
- Time-series data for analysis
- Metric comparisons across runs
- Executive reporting ready

### JSON Format
- API-compatible format
- Nested data structures
- Integration with external tools
- Real-time data consumption

### YAML Format
- Human-readable configuration format
- Documentation generation
- Configuration management
- Template processing

### Jenkins Format
- CI/CD pipeline integration
- Automated build reporting
- Quality gate integration
- DevOps workflow compatibility

## Features

- **Comprehensive Data Collection**: All test-related metrics
- **Historical Tracking**: Metrics stored with timestamps
- **Trend Analysis**: Performance and quality trends over time
- **Export Flexibility**: Multiple formats for different use cases
- **Automated Cleanup**: Configurable retention policies

## Integration

- **QA Agent**: Use within QA persona sessions
- **AI/ML Analytics**: Feeds prediction and optimization systems
- **Dashboard**: Powers web dashboard visualizations
- **CI/CD**: Jenkins and GitHub Actions integration

## Output Locations

- **Metrics Storage**: `/mnt/c/Code/agentic-persona-mapping/project_docs/qa/metrics/`
- **Export Files**: `/mnt/c/Code/agentic-persona-mapping/project_docs/qa/metrics/exported_metrics_*.{format}`
- **Summary Reports**: `/mnt/c/Code/agentic-persona-mapping/project_docs/qa/reports/`

## Technical Details

- **Script Location**: `/mnt/c/Code/agentic-persona-mapping/.apm/scripts/test-monitoring/test-metrics-collector.sh`
- **Configuration**: `/mnt/c/Code/agentic-persona-mapping/.apm/config/test-monitoring.yaml`
- **Retention**: 30 days default (configurable)
- **Collection ID**: Timestamp-based unique identifiers

## Examples

```bash
# Daily metrics collection
test metrics --summary

# Weekly comprehensive analysis
test metrics --export csv --output weekly-report.csv

# Real-time monitoring integration
test metrics --metrics process --export json
```

Execute this command by typing `test metrics` in your Claude Code session.