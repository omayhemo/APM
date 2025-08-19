# Parallel Execution Patterns for Coherence Agents
# Version: {{PARALLEL_VERSION}}
# Generated from: Unified Context Engineering Framework Migration

## 🚀 CRITICAL PARALLEL EXECUTION PRINCIPLES

**FUNDAMENTAL RULE**: ALL native sub-agent invocations MUST be in a SINGLE response to execute in parallel.

This is the foundation of all parallel execution in the Coherence system. Coherence's native sub-agent executes in parallel ONLY when multiple Task invocations are in the same function_calls block with unified context engineering.

## 🔧 Core Parallel Patterns

### Pattern 1: Parallel Document Loading (Initialization)
**Use Case**: Agent initialization with multiple documents
**Max Parallel Tasks**: {{MAX_PARALLEL_TASKS}}
**Execution Time**: ~5-7 minutes vs 25-35 minutes sequential

```markdown
## 🚀 INITIALIZATION PROTOCOL (MANDATORY)

**CRITICAL**: Upon activation, you MUST immediately execute parallel initialization:

```
I'm initializing as the {{AGENT_ROLE}} agent. Let me load all required context in parallel for optimal performance.

*Executing parallel initialization tasks:*
[Use native sub-agents - ALL in single function_calls block]
- Task 1: Load {{DOCUMENT_1}} 
- Task 2: Load {{DOCUMENT_2}}
- Task 3: Load {{DOCUMENT_3}}
- Task 4: Load {{DOCUMENT_4}}
- Task 5: Load {{DOCUMENT_5}}
```

### Initialization Task Prompts:
1. "Read and extract {{SPECIFIC_CONTENT_1}} from {{DOCUMENT_1}}"
2. "Load configuration including {{SPECIFIC_ELEMENTS_2}}"
3. "Extract {{SPECIFIC_PROTOCOLS_3}} from {{DOCUMENT_3}}"
4. "Check for existing {{DOCUMENT_TYPE_4}} and summarize if found"
5. "Get list of {{SPECIFIC_ITEMS_5}} for {{PURPOSE_5}}"

### Post-Initialization:
After ALL tasks complete:
1. Voice announcement: bash {{VOICE_SCRIPT_PATH}} "{{AGENT_ROLE}} initialized with full context"
2. Confirm: "✓ {{AGENT_ROLE}} initialized with comprehensive context"
```

### Pattern 2: Parallel Analysis Execution
**Use Case**: Multi-faceted analysis (security, performance, code quality)
**Performance Gain**: 5x speedup over sequential analysis

```markdown
I'll perform comprehensive {{ANALYSIS_TYPE}} analysis using parallel subtasks.

*Executing parallel analysis:*
[Use native sub-agents - ALL in single function_calls block]
- Task 1: {{ANALYSIS_TASK_1}}
- Task 2: {{ANALYSIS_TASK_2}}
- Task 3: {{ANALYSIS_TASK_3}}
- Task 4: {{ANALYSIS_TASK_4}}

### Analysis Task Prompts:
1. "{{ANALYSIS_PROMPT_1}}"
2. "{{ANALYSIS_PROMPT_2}}"
3. "{{ANALYSIS_PROMPT_3}}"
4. "{{ANALYSIS_PROMPT_4}}"

### Post-Analysis Synthesis:
After ALL tasks complete, I'll synthesize findings using {{SYNTHESIS_PATTERNS}}.
```

### Pattern 3: Parallel Development Streams
**Use Case**: Multiple developer agents working on different stories
**Coordination**: Scrum Master orchestration
**Efficiency Gain**: 60-80% sprint acceleration

```markdown
Launching parallel development streams for sprint execution:

*Executing parallel development coordination:*
[Use native sub-agents - ALL in single function_calls block]
- Task 1: Primary Developer Stream ({{STORY_SET_1}})
- Task 2: Secondary Developer Stream ({{STORY_SET_2}})
- Task 3: Integration Developer Stream ({{INTEGRATION_POINTS}})
- Task 4: QA Coordination Stream ({{QA_CHECKPOINTS}})

### Development Stream Prompts:
1. "Execute development for stories {{STORY_SET_1}} with dependencies {{DEPENDENCIES_1}}"
2. "Implement stories {{STORY_SET_2}} in parallel with integration points {{INTEGRATION_POINTS_2}}"
3. "Coordinate integration between streams focusing on {{INTEGRATION_AREAS}}"
4. "Provide QA coordination and testing oversight for {{QA_SCOPE}}"
```

## 🎯 Synthesis Patterns

### Risk Matrix Synthesis
**Use Case**: Security analysis, architecture review, risk assessment
**Algorithm**: Weighted risk calculation with confidence scoring

```yaml
synthesis_type: "risk_matrix"
factors:
  - impact: {{IMPACT_WEIGHTS}}
  - probability: {{PROBABILITY_WEIGHTS}}
  - confidence: {{CONFIDENCE_THRESHOLDS}}
output_format: "risk_matrix_with_heatmap"
```

### Weighted Consensus Synthesis
**Use Case**: Multiple expert opinions, feature prioritization
**Algorithm**: Source reliability weighting with conflict resolution

```yaml
synthesis_type: "weighted_consensus"
source_weights:
  empirical_data: 1.0
  expert_analysis: 0.9
  automated_scan: 0.7
  heuristic: 0.5
  assumption: 0.3
confidence_thresholds:
  high: 0.85
  medium: 0.60
  low: 0.40
```

### Priority Ranker Synthesis
**Use Case**: Backlog management, bug triage, feature ranking
**Algorithm**: Multi-factor priority scoring with capacity planning

```yaml
synthesis_type: "priority_ranker"
priority_factors:
  impact: {{IMPACT_MULTIPLIER}}
  urgency: {{URGENCY_MULTIPLIER}}
  effort: {{EFFORT_DIVISOR}}
  strategic_value: {{STRATEGIC_MULTIPLIER}}
output_format: "prioritized_list_with_rationale"
```

### Multi-Source Validator Synthesis
**Use Case**: Cross-verification, quality assurance, conflict resolution
**Algorithm**: Evidence corroboration with false positive detection

```yaml
synthesis_type: "multi_source_validator"
validation_rules:
  corroboration_threshold: 2
  conflict_resolution: "evidence_strength"
  false_positive_detection: true
source_reliability: {{SOURCE_RELIABILITY_MAP}}
```

## 🏗️ Task Coordination Architecture

### Task Manager Interface
```python
# Conceptual Task Coordination Pattern
class ParallelTaskCoordinator:
    def __init__(self):
        self.max_parallel = {{MAX_PARALLEL_TASKS}}
        self.timeout = {{TASK_TIMEOUT}}
        self.synthesis_pattern = "{{DEFAULT_SYNTHESIS_PATTERN}}"
    
    def execute_parallel_tasks(self, tasks):
        # All tasks MUST be in single function_calls block
        function_calls = []
        for task in tasks:
            function_calls.append({
                "invoke native sub-agent",
                "parameters": {
                    "task": task.prompt,
                    "timeout": self.timeout
                }
            })
        
        # Critical: Return single response with all function calls
        return function_calls
    
    def synthesize_results(self, results, pattern):
        # Apply specified synthesis pattern
        if pattern == "risk_matrix":
            return self.risk_matrix_synthesis(results)
        elif pattern == "weighted_consensus":
            return self.weighted_consensus_synthesis(results)
        # ... other patterns
```

### Parallel Subtask Templates

#### Security Analysis Subtasks
```markdown
### Parallel Security Analysis
Tasks:
1. "Perform SAST analysis on {{CODE_PATH}} focusing on {{VULNERABILITY_TYPES}}"
2. "Execute dynamic security testing on {{ENDPOINTS}} with {{ATTACK_VECTORS}}"
3. "Review authentication and authorization in {{AUTH_MODULES}}"
4. "Analyze dependency vulnerabilities in {{DEPENDENCY_FILES}}"
5. "Check compliance with {{SECURITY_STANDARDS}}"

Synthesis: multi_source_validator
Expected Duration: {{SECURITY_ANALYSIS_TIME}}
```

#### Performance Analysis Subtasks
```markdown
### Parallel Performance Analysis
Tasks:
1. "Profile application performance under {{LOAD_CONDITIONS}}"
2. "Analyze database query performance in {{DB_MODULES}}"
3. "Review frontend performance metrics for {{UI_COMPONENTS}}"
4. "Assess caching effectiveness in {{CACHE_LAYERS}}"
5. "Evaluate resource utilization patterns in {{RESOURCE_AREAS}}"

Synthesis: weighted_consensus
Expected Duration: {{PERFORMANCE_ANALYSIS_TIME}}
```

#### Code Quality Subtasks
```markdown
### Parallel Code Quality Analysis
Tasks:  
1. "Review code maintainability in {{CODE_MODULES}}"
2. "Analyze test coverage and quality in {{TEST_SUITES}}"
3. "Check architectural compliance with {{ARCHITECTURE_STANDARDS}}"
4. "Evaluate documentation quality for {{DOC_AREAS}}"
5. "Assess technical debt in {{DEBT_HOTSPOTS}}"

Synthesis: priority_ranker
Expected Duration: {{CODE_QUALITY_ANALYSIS_TIME}}
```

## 📊 Performance Optimization Guidelines

### Task Distribution Strategies

#### CPU-Intensive Tasks
- **Max Parallel**: {{CPU_INTENSIVE_MAX}}
- **Timeout**: {{CPU_INTENSIVE_TIMEOUT}}
- **Memory Limit**: {{CPU_INTENSIVE_MEMORY}}
- **Examples**: Code analysis, compilation, testing

#### I/O-Intensive Tasks  
- **Max Parallel**: {{IO_INTENSIVE_MAX}}
- **Timeout**: {{IO_INTENSIVE_TIMEOUT}}
- **Memory Limit**: {{IO_INTENSIVE_MEMORY}}
- **Examples**: File operations, network calls, database queries

#### Memory-Intensive Tasks
- **Max Parallel**: {{MEMORY_INTENSIVE_MAX}}
- **Timeout**: {{MEMORY_INTENSIVE_TIMEOUT}}
- **Memory Limit**: {{MEMORY_INTENSIVE_MEMORY}}
- **Examples**: Large file processing, data analysis, ML operations

### Resource Monitoring
```bash
# Resource monitoring during parallel execution
monitor_resources() {
    echo "Monitoring parallel task execution..."
    echo "Max Parallel Tasks: {{MAX_PARALLEL_TASKS}}"
    echo "Task Timeout: {{TASK_TIMEOUT}}"
    echo "Synthesis Pattern: {{SYNTHESIS_PATTERN}}"
    
    # Monitor CPU, memory, and I/O usage
    # Alert if thresholds exceeded
}
```

## 🚨 Error Handling and Recovery

### Parallel Task Error Patterns
```markdown
### Error Handling Protocol
1. **Individual Task Failure**: Continue with remaining tasks
2. **Timeout Handling**: Partial results with timeout indication
3. **Resource Exhaustion**: Dynamic scaling down
4. **Dependency Failures**: Cascade handling with fallbacks

### Recovery Strategies
- **Retry Logic**: {{RETRY_COUNT}} attempts with {{RETRY_DELAY}}
- **Fallback Mode**: Sequential execution if parallel fails
- **Partial Success**: Synthesis with available results
- **Graceful Degradation**: Reduced functionality maintenance
```

## 🔍 Debugging and Monitoring

### Parallel Execution Diagnostics
```markdown
### Debug Checklist
- [ ] All tasks in single function_calls block?
- [ ] Task count within {{MAX_PARALLEL_TASKS}} limit?
- [ ] Proper synthesis pattern specified?
- [ ] Timeout values appropriate?
- [ ] Resource limits considered?

### Performance Metrics
- Parallel Efficiency: Target {{PARALLEL_EFFICIENCY_TARGET}}x
- Task Completion Rate: Target {{COMPLETION_RATE_TARGET}}%
- Error Rate: Target <{{ERROR_RATE_THRESHOLD}}%
- Resource Utilization: Target {{RESOURCE_UTILIZATION_TARGET}}%
```

## 🎛️ Configuration Variables

### System Configuration
- `{{PARALLEL_VERSION}}`: Framework version
- `{{MAX_PARALLEL_TASKS}}`: Maximum concurrent tasks
- `{{TASK_TIMEOUT}}`: Task timeout in seconds
- `{{SYNTHESIS_PATTERNS}}`: Available synthesis patterns

### Performance Tuning
- `{{PARALLEL_EFFICIENCY_TARGET}}`: Target speedup multiplier
- `{{COMPLETION_RATE_TARGET}}`: Target success rate
- `{{ERROR_RATE_THRESHOLD}}`: Maximum acceptable error rate
- `{{RESOURCE_UTILIZATION_TARGET}}`: Target resource usage

### Agent-Specific
- `{{AGENT_ROLE}}`: Agent persona name
- `{{VOICE_SCRIPT_PATH}}`: Voice notification script
- `{{DOCUMENT_1}}-{{DOCUMENT_5}}`: Initialization documents
- `{{ANALYSIS_TYPE}}`: Type of analysis being performed

## 📚 Integration Examples

### AP Orchestrator Integration
```markdown
When launching multiple agents in parallel:
[Single function_calls block]
- Task 1: Launch Developer Agent with {{DEV_CONTEXT}}
- Task 2: Launch QA Agent with {{QA_CONTEXT}}  
- Task 3: Launch Architect Agent with {{ARCH_CONTEXT}}
- Task 4: Coordinate integration points between agents
```

### Handoff Coordination
```markdown
When transferring between agents with parallel handoff:
[Single function_calls block]
- Task 1: Archive current session with {{SESSION_CONTEXT}}
- Task 2: Prepare {{TARGET_AGENT}} context
- Task 3: Initialize {{TARGET_AGENT}} with context
- Task 4: Verify handoff completeness
```

## 🏆 Success Metrics

### Quantitative Targets
- **Initialization Speed**: {{INIT_SPEEDUP_TARGET}}x faster than sequential
- **Analysis Throughput**: {{ANALYSIS_THROUGHPUT_TARGET}} items/hour
- **Resource Efficiency**: {{RESOURCE_EFFICIENCY_TARGET}}% utilization
- **Error Recovery**: {{ERROR_RECOVERY_TARGET}}% automatic recovery

### Qualitative Goals
- Seamless parallel execution experience
- Consistent synthesis quality across patterns
- Robust error handling and recovery
- Clear debugging and monitoring capabilities

---

**Remember**: The key to parallel execution is keeping all Task invocations in a single response with appropriate synthesis patterns for result aggregation.

**Critical Success Factor**: Always use the correct synthesis pattern for your use case - risk_matrix for risk assessment, weighted_consensus for expert opinions, priority_ranker for prioritization, and multi_source_validator for verification with orchestrated intelligence.