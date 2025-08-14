# /parallel-test

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the QA persona.**

```markdown
*Loading QA context for parallel execution...*

Quick Context Load (1-2 seconds):
- Loading QA configuration and expertise
- Preparing parallel execution framework
- Voice notification: bash $/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakQA.sh "QA ready for parallel execution"
- Workspace validation: Ensuring execution from /mnt/c/Code/agentic-persona-mapping

*QA context ready. Launching parallel streams...*
```


Executes parallel tests based on the test plan defined in tests/parallel-test-plan.md

## Overview

The `/parallel-test` command provides a flexible, parameter-driven approach to parallel test execution. Instead of hardcoded test configurations, it reads from a QA-maintained test plan file that defines all test agents, their commands, dependencies, and execution parameters.

## Usage

```
/parallel-test [options]
```

## Options

- `--plan <path>` - Alternative test plan file (default: tests/parallel-test-plan.md)
- `--dry-run` - Show what would be executed without running tests
- `--filter <regex>` - Run only agents matching the pattern
- `--update-plan` - Update the test plan after execution (default: true)
- `--max-parallel <n>` - Override max parallel agents from plan
- `--timeout <minutes>` - Override global timeout from plan

## Examples

```bash
# Run all tests from default plan
/parallel-test

# Use custom test plan
/parallel-test --plan tests/integration-test-plan.md

# Run only unit tests
/parallel-test --filter "unit-.*"

# Dry run to see what would execute
/parallel-test --dry-run

# Run without updating the plan
/parallel-test --update-plan=false

# Override parallelism
/parallel-test --max-parallel 5
```

## Test Plan Format

The test plan (parallel-test-plan.md) defines:
- Test configuration (parallel limit, timeout)
- Agent definitions (id, command, dependencies, environment)
- Execution history
- Test results and metrics

## Execution Flow

1. **Read Test Plan**: Parse the markdown test plan file
2. **Apply Filters**: Filter agents based on --filter option
3. **Resolve Dependencies**: Determine execution order
4. **Execute Tests**: Run tests in parallel respecting limits
5. **Update Results**: Update test plan with results (if enabled)
6. **Generate Report**: Display execution summary

## Integration with QA Agent

The QA agent can:
- Generate initial test plans: `/generate-test-plan`
- Analyze test results: `/analyze-test-results`
- Optimize test configurations: `/optimize-test-plan`
- Maintain test history and metrics

## Benefits

- **Flexibility**: Change test configurations without code modifications
- **Visibility**: Test plans are self-documenting
- **Automation**: QA agents can manage plans programmatically
- **History**: Track test execution patterns over time
- **Optimization**: Adjust based on historical performance

## Implementation

When executed, this command will:

1. Parse the test plan markdown file
2. Convert agent definitions to orchestrator format
3. Execute the parallel test orchestrator with parameters
4. Update the test plan with results
5. Display execution summary

The system maintains backward compatibility while enabling dynamic test configuration management.
