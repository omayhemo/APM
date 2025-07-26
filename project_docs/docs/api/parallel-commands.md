# Parallel Commands API Reference

## Overview

APM v3.1.0 introduces native Claude Code sub-agent integration for all 45+ parallel commands, delivering 4-8x performance improvements with true parallel execution.

## Core Commands

### 🚀 /parallel-sprint

Coordinates multiple Developer agents for parallel story implementation.

**Syntax**: `/parallel-sprint [options]`

**Native Agent Activation**:
Spawns 2-4 Developer agents based on sprint capacity:
- "I need a Developer agent to work on Story X..."
- "I need another Developer agent for Story Y..."
- "I need a QA agent to coordinate testing..."
- "I need an Architect agent to review integration..."

**Options**:
- `--max-agents=N`: Limit concurrent agents (default: 4)
- `--timeout=S`: Set timeout in seconds (default: 300)
- `--mode=native|task`: Force execution mode (default: native)

**Performance**:
- Execution time: 2-3 minutes (vs 10-12 minutes sequential)
- Performance gain: 4-6x
- Resource usage: Moderate (4 agents × 200k tokens)

**Example**:
```bash
$ /parallel-sprint
🚀 Launching 4 Developer agents for Sprint 18...
[Real-time progress visualization]
✓ Sprint execution complete in 2:18 (4.5x speedup)
```

### 🧪 /parallel-qa-framework

Executes comprehensive testing with parallel QA agents.

**Syntax**: `/parallel-qa-framework [test-type]`

**Native Agent Activation**:
```
I need a QA agent to execute unit test suite
Context: Module: auth, Coverage target: 80%

I need a QA agent to run integration tests  
Context: API endpoints, Database transactions

I need a QA agent to perform security testing
Context: OWASP top 10, Authentication flows

I need a QA agent to conduct performance testing
Context: Load targets, Response time SLAs
```

**Performance**:
- Execution time: 12 minutes (vs 48 minutes sequential)
- Performance gain: 4x
- AI/ML Features: 92% failure prediction, 63% optimization, 94% anomaly detection

### 🏗️ /parallel-architecture

Analyzes system architecture across multiple domains simultaneously.

**Syntax**: `/parallel-architecture [domain]`

**Native Agent Activation**:
```
I need an Architect agent to design the data architecture
Context: Microservices pattern, PostgreSQL, event sourcing

I need another Architect agent to design API architecture  
Context: RESTful APIs, GraphQL gateway, versioning strategy

I need an Architect agent to design security architecture
Context: OAuth2, JWT tokens, zero-trust principles
```

**Performance**:
- Execution time: 25 minutes (vs 100 minutes sequential)  
- Performance gain: 4x
- Domains: Data, API, Security, Infrastructure, Performance, Monitoring

## Scrum Master Commands

### 📝 /parallel-stories

Creates multiple stories in parallel using specialized agents.

**Performance**: 60 minutes (vs 240 minutes) - 75% improvement
**Agents**: 7 specialized story creation agents

### ✅ /parallel-checklist  

Validates stories across quality dimensions with parallel assessment.

**Performance**: 18 minutes (vs 60 minutes) - 70% improvement
**Agents**: 6 validation agents (completeness, business value, technical feasibility)

### 📊 /parallel-next-story

Advanced story creation with comprehensive context analysis.

**Performance**: 25 minutes (vs 100 minutes) - 75% improvement  
**Agents**: 5 specialized agents (structure, criteria, requirements, testing, validation)

### 🔄 /parallel-course-correction

Sprint adjustment and recovery planning with specialist coordination.

**Performance**: 30 minutes (vs 85 minutes) - 65% improvement
**Agents**: 4 recovery specialists (scope, blockers, priorities, resources)

## Product Owner Commands

### 🎯 /parallel-epic

Epic decomposition and analysis with parallel PO expertise.

**Performance**: 70% improvement
**Agents**: 8 specialized PO agents

### 📋 /parallel-prioritization

Smart backlog prioritization with multi-dimensional analysis.

**Performance**: 70% improvement
**Agents**: 8 analysis agents (business value, complexity, impact, dependencies)

## QA Commands (AI/ML Enhanced)

### 🤖 /qa-predict

ML-powered test failure prediction (92% accuracy).

### ⚡ /qa-optimize  

Test execution optimization (63% time reduction).

### 🔍 /qa-anomaly

Quality anomaly detection (94% precision).

## Context Passing

All native sub-agents receive optimized context:
- **Size limit**: <20,000 tokens (10% of available window)
- **Processing overhead**: <5 seconds  
- **Cache efficiency**: 60-80% hit rate
- **Format**: Natural language with structured data

## Result Aggregation

Native agents return results in unified formats:
- **Hierarchical synthesis**: Organized by domain/priority
- **Workflow-based**: Sequential presentation of related outputs
- **Risk-based**: Critical items first, supporting details follow

## Performance Characteristics

| Command Category | Improvement | Agents | Context per Agent |
|------------------|-------------|--------|-------------------|
| Sprint Coordination | 4-6x | 2-4 | 200k tokens |
| QA Framework | 4-7x | 4-6 | 200k tokens |
| Architecture | 3-5x | 5-6 | 200k tokens |
| Story Management | 3-4x | 5-7 | 200k tokens |

## Natural Language Patterns

### Basic Agent Spawning
```
I need a [PERSONA] agent to [TASK]
Context: [SPECIFIC_CONTEXT]
Focus: [KEY_REQUIREMENTS]
```

### Parallel Coordination
```
I need multiple agents working simultaneously:
1. [PERSONA] agent: [TASK_1]
2. [PERSONA] agent: [TASK_2]  
3. [PERSONA] agent: [TASK_3]
All agents should coordinate on [INTEGRATION_POINTS]
```

### Specialized Expertise
```
I need a [PERSONA] agent specialized in [DOMAIN] to [SPECIFIC_TASK]
Requirements: [DETAILED_SPECS]
Success criteria: [MEASURABLE_OUTCOMES]
Dependencies: [RELATED_WORK]
```

## Error Handling

Native sub-agents provide graceful error handling:
- Individual agent failures don't stop other agents
- Partial results are preserved and presented
- Automatic retry for transient failures
- Clear error messages with resolution suggestions

## Migration from Task-Based

### Quick Migration
1. Remove `--mode=task` from commands
2. Commands automatically use native agents
3. Expect 4-8x performance improvement

### Command Mapping
| Old (Task-based) | New (Native) | Performance Gain |
|------------------|--------------|------------------|
| All parallel commands | Same commands | 4-8x faster |
| Manual Task coordination | Automatic agent spawning | Simplified usage |
| Sequential bottlenecks | True parallel execution | No waiting |

## Version Compatibility

- **v3.1.0+**: Native sub-agents default
- **v3.0.x**: Task-based system (deprecated)
- **Migration tools**: Available for validation and testing

## Support

- **Migration Guide**: [Migration Guide](../migration/migration-guide.md)
- **Architecture Overview**: [Native Agent Architecture](../architecture/native-agent-architecture.md)  
- **Performance Benchmarks**: [Performance Benchmarks](../performance/benchmarks.md)
- **Troubleshooting**: [Troubleshooting Guide](../migration/troubleshooting.md)