# Agent Workflow Templates
# Version: {{WORKFLOW_TEMPLATE_VERSION}}
# Template Engine: {{TEMPLATE_ENGINE}}
# Custom Templates: {{CUSTOM_TEMPLATE_COUNT}}

## 🎯 Workflow Template Architecture

The Agent Workflow Template System provides pre-defined, battle-tested workflow patterns that can be instantiated for common multi-agent coordination scenarios within the APM framework.

## 🚀 Core Template Principles

### 1. Template-Driven Orchestration
**CRITICAL**: All workflows are instantiated from validated templates with customizable parameters.

```yaml
template_architecture:
  definition: "YAML-based workflow definitions with variable substitution"
  validation: "Schema validation and constraint checking"
  instantiation: "Runtime parameter substitution and agent allocation"
  monitoring: "Built-in metrics and progress tracking"
```

### 2. Composable Workflow Patterns
**Modularity**: Templates can be combined and extended for complex scenarios.

```yaml
composition_patterns:
  sequential: "Linear agent handoffs with quality gates"
  parallel: "Simultaneous agent execution with coordination"
  conditional: "Branching workflows based on runtime conditions"
  iterative: "Repeated workflow cycles with feedback loops"
```

### 3. Template Inheritance
**Reusability**: Templates inherit from base patterns and customize specific behaviors.

## 📋 Pre-Defined Workflow Templates

### Template 1: Feature Development Workflow
**ID**: `feature_development_v{{TEMPLATE_VERSION}}`
**Use Case**: Complete feature development from PRD to production
**Agents**: PO → Architect → Developer → QA → DevOps
**Duration**: {{FEATURE_WORKFLOW_DURATION}}

```yaml
workflow_template:
  name: "feature_development"
  version: "{{TEMPLATE_VERSION}}"
  description: "Complete feature development pipeline"
  
  parameters:
    feature_complexity: "{{FEATURE_COMPLEXITY}}" # simple|medium|complex
    quality_level: "{{QUALITY_LEVEL}}" # basic|standard|premium
    timeline_constraint: "{{TIMELINE_CONSTRAINT}}" # flexible|moderate|tight
    
  stages:
    requirements_analysis:
      agent: "po"
      duration: "{{REQ_ANALYSIS_DURATION}}"
      inputs: ["feature_request", "business_context"]
      outputs: ["prd", "acceptance_criteria", "business_requirements"]
      quality_gates:
        - stakeholder_review
        - requirements_completeness_check
        - business_value_validation
        
    technical_design:
      agent: "architect"
      duration: "{{TECH_DESIGN_DURATION}}"
      inputs: ["prd", "acceptance_criteria", "system_constraints"]
      outputs: ["technical_design", "api_contracts", "data_models"]
      quality_gates:
        - design_review
        - scalability_assessment
        - security_evaluation
        
    implementation:
      agent: "dev"
      duration: "{{IMPLEMENTATION_DURATION}}"
      inputs: ["technical_design", "api_contracts", "coding_standards"]
      outputs: ["implementation", "unit_tests", "integration_tests"]
      quality_gates:
        - code_review
        - test_coverage_check
        - static_analysis
        
    quality_assurance:
      agent: "qa"
      duration: "{{QA_DURATION}}"
      inputs: ["implementation", "acceptance_criteria", "test_strategy"]
      outputs: ["test_results", "quality_report", "deployment_approval"]
      quality_gates:
        - acceptance_testing
        - performance_testing
        - security_testing
```

### Template 2: Bug Resolution Workflow
**ID**: `bug_resolution_v{{TEMPLATE_VERSION}}`
**Use Case**: Critical bug investigation and resolution
**Agents**: Developer → Architect → QA
**Duration**: {{BUG_WORKFLOW_DURATION}}

```yaml
workflow_template:
  name: "bug_resolution"
  version: "{{TEMPLATE_VERSION}}"
  description: "Critical bug investigation and resolution pipeline"
  priority: "high"
  
  parameters:
    bug_severity: "{{BUG_SEVERITY}}" # low|medium|high|critical
    system_impact: "{{SYSTEM_IMPACT}}" # isolated|module|system|enterprise
    time_constraint: "{{TIME_CONSTRAINT}}" # hours|days|weeks
    
  stages:
    investigation:
      agent: "dev"
      duration: "{{INVESTIGATION_DURATION}}"
      inputs: ["bug_report", "system_logs", "reproduction_steps"]
      outputs: ["root_cause_analysis", "impact_assessment", "fix_strategy"]
      quality_gates:
        - root_cause_identified
        - fix_approach_validated
        
    architecture_review:
      agent: "architect"
      duration: "{{ARCH_REVIEW_DURATION}}"
      inputs: ["root_cause_analysis", "fix_strategy", "system_architecture"]
      outputs: ["architecture_impact", "fix_approval", "risk_assessment"]
      quality_gates:
        - architecture_integrity_maintained
        - no_regression_risk
        
    resolution:
      agent: "dev"
      duration: "{{RESOLUTION_DURATION}}"
      inputs: ["fix_approval", "implementation_guidelines"]
      outputs: ["bug_fix", "regression_tests", "deployment_package"]
      quality_gates:
        - bug_resolution_verified
        - regression_tests_passing
        
    validation:
      agent: "qa"
      duration: "{{VALIDATION_DURATION}}"
      inputs: ["bug_fix", "regression_tests", "test_scenarios"]
      outputs: ["validation_results", "deployment_approval"]
      quality_gates:
        - bug_fix_verified
        - no_new_regressions
```

### Template 3: Architecture Review Workflow
**ID**: `architecture_review_v{{TEMPLATE_VERSION}}`
**Use Case**: Comprehensive architecture review and optimization
**Agents**: Architect → Senior Architect → Developer → QA
**Duration**: {{ARCH_REVIEW_WORKFLOW_DURATION}}

```yaml
workflow_template:
  name: "architecture_review"
  version: "{{TEMPLATE_VERSION}}"
  description: "Comprehensive architecture review and enhancement"
  
  parameters:
    review_scope: "{{REVIEW_SCOPE}}" # component|module|system|enterprise
    review_depth: "{{REVIEW_DEPTH}}" # surface|detailed|comprehensive
    modernization_level: "{{MODERNIZATION_LEVEL}}" # maintenance|enhancement|transformation
    
  stages:
    current_state_analysis:
      agent: "architect"
      duration: "{{ANALYSIS_DURATION}}"
      inputs: ["system_documentation", "performance_metrics", "technical_debt"]
      outputs: ["current_state_assessment", "pain_points", "opportunity_analysis"]
      quality_gates:
        - comprehensive_analysis_complete
        - stakeholder_interviews_done
        
    future_state_design:
      agent: "architect"
      duration: "{{DESIGN_DURATION}}"
      inputs: ["current_state_assessment", "business_requirements", "technology_trends"]
      outputs: ["target_architecture", "migration_roadmap", "risk_assessment"]
      quality_gates:
        - architecture_principles_validated
        - migration_feasibility_confirmed
        
    implementation_planning:
      agent: "dev"
      duration: "{{PLANNING_DURATION}}"
      inputs: ["target_architecture", "migration_roadmap", "resource_constraints"]
      outputs: ["implementation_plan", "effort_estimates", "milestone_definitions"]
      quality_gates:
        - implementation_feasibility_validated
        - resource_requirements_realistic
        
    validation_strategy:
      agent: "qa"
      duration: "{{VALIDATION_DURATION}}"
      inputs: ["implementation_plan", "quality_requirements", "risk_assessment"]
      outputs: ["test_strategy", "quality_metrics", "acceptance_criteria"]
      quality_gates:
        - test_coverage_adequate
        - quality_thresholds_defined
```

### Template 4: Sprint Planning Workflow
**ID**: `sprint_planning_v{{TEMPLATE_VERSION}}`
**Use Case**: Comprehensive sprint planning with multiple agents
**Agents**: PO → SM → Architects → Developers
**Duration**: {{SPRINT_PLANNING_DURATION}}

```yaml
workflow_template:
  name: "sprint_planning"
  version: "{{TEMPLATE_VERSION}}"
  description: "Comprehensive sprint planning with capacity allocation"
  
  parameters:
    sprint_duration: "{{SPRINT_DURATION}}" # 1w|2w|3w|4w
    team_capacity: "{{TEAM_CAPACITY}}" # story_points_per_sprint
    story_complexity_mix: "{{COMPLEXITY_MIX}}" # simple|balanced|complex
    
  stages:
    backlog_preparation:
      agent: "po"
      duration: "{{BACKLOG_PREP_DURATION}}"
      inputs: ["product_backlog", "business_priorities", "stakeholder_feedback"]
      outputs: ["sprint_candidates", "priority_ranking", "acceptance_criteria"]
      quality_gates:
        - stories_properly_groomed
        - acceptance_criteria_complete
        
    capacity_planning:
      agent: "sm"
      duration: "{{CAPACITY_PLANNING_DURATION}}"
      inputs: ["team_velocity", "availability_calendar", "complexity_estimates"]
      outputs: ["capacity_allocation", "developer_assignments", "risk_assessment"]
      quality_gates:
        - realistic_capacity_planning
        - balanced_workload_distribution
        
    technical_validation:
      agent: "architect"
      duration: "{{TECH_VALIDATION_DURATION}}"
      inputs: ["sprint_candidates", "system_architecture", "technical_constraints"]
      outputs: ["technical_feasibility", "dependency_analysis", "architecture_impact"]
      quality_gates:
        - technical_dependencies_resolved
        - architecture_integrity_maintained
        
    sprint_commitment:
      agent: "sm"
      duration: "{{COMMITMENT_DURATION}}"
      inputs: ["capacity_allocation", "technical_feasibility", "team_consensus"]
      outputs: ["sprint_backlog", "sprint_goals", "success_criteria"]
      quality_gates:
        - team_commitment_achieved
        - sprint_goals_clear
```

## 🎪 Workflow Template Commands

### Core Template Commands

#### `/template-list [category]`
List available workflow templates
```bash
/template-list development
# Shows all development-related workflow templates
```

#### `/template-instantiate [template_id] [parameters]`
Create workflow instance from template
```bash
/template-instantiate feature_development feature_complexity=medium quality_level=premium
# Creates feature development workflow with specified parameters
```

#### `/template-customize [template_id]`
Customize template parameters interactively
```bash
/template-customize bug_resolution
# Opens interactive parameter customization
```

#### `/template-status [workflow_id]`
Display template-based workflow status
```bash
Workflow: feature_development_001
Template: feature_development_v2.1
Stage: implementation (3/4)
Progress: 75% complete
Agent: dev
Next Stage: quality_assurance (estimated 2 days)
```

#### `/template-create [name]`
Create custom workflow template
```bash
/template-create custom_integration_workflow
# Opens template definition editor
```

## 🔧 Advanced Template Features

### 1. Dynamic Parameter Substitution
**Runtime Configuration**: Templates adapt to runtime parameters and context

```yaml
parameter_types:
  static: "Fixed values defined at instantiation"
  dynamic: "Values computed during workflow execution"
  contextual: "Values derived from current project context"
  conditional: "Values selected based on workflow conditions"
```

### 2. Template Validation Engine
**Quality Assurance**: All templates undergo comprehensive validation

```yaml
validation_checks:
  schema_validation:
    - template_structure_valid
    - required_fields_present
    - parameter_types_correct
    
  workflow_validation:
    - agent_transitions_valid
    - quality_gates_appropriate
    - duration_estimates_realistic
    
  dependency_validation:
    - input_output_compatibility
    - agent_capability_matching
    - resource_requirement_feasibility
```

### 3. Template Performance Analytics
**Optimization**: Track template performance and optimize based on results

```yaml
performance_metrics:
  execution_time: "Actual vs estimated duration"
  success_rate: "Percentage of successful workflow completions"
  quality_score: "Quality outcomes vs quality gates"
  resource_efficiency: "Actual vs planned resource utilization"
```

## 📊 Template Analytics & Monitoring

### Template Usage Metrics
```yaml
usage_analytics:
  most_used_templates: ["feature_development", "bug_resolution", "sprint_planning"]
  template_success_rates:
    feature_development: "{{FEATURE_SUCCESS_RATE}}%"
    bug_resolution: "{{BUG_SUCCESS_RATE}}%"
    architecture_review: "{{ARCH_SUCCESS_RATE}}%"
    
  average_execution_times:
    feature_development: "{{FEATURE_AVG_TIME}}"
    bug_resolution: "{{BUG_AVG_TIME}}"
    sprint_planning: "{{SPRINT_AVG_TIME}}"
```

### Template Performance Dashboard
```yaml
performance_dashboard:
  active_workflows: {{ACTIVE_TEMPLATE_WORKFLOWS}}
  completed_today: {{COMPLETED_TODAY}}
  average_success_rate: "{{OVERALL_SUCCESS_RATE}}%"
  most_efficient_template: "{{MOST_EFFICIENT_TEMPLATE}}"
  optimization_opportunities: ["{{OPTIMIZATION_1}}", "{{OPTIMIZATION_2}}"]
```

## 🛡️ Template Quality Assurance

### Template Testing Framework
```yaml
testing_framework:
  unit_tests: "Individual template component validation"
  integration_tests: "Agent interaction and handoff validation"
  performance_tests: "Duration and resource utilization validation"
  end_to_end_tests: "Complete workflow execution validation"
```

### Quality Gates for Templates
```yaml
template_quality_gates:
  definition_quality:
    - comprehensive_documentation
    - clear_parameter_definitions
    - realistic_duration_estimates
    
  execution_quality:
    - successful_agent_handoffs
    - quality_gate_effectiveness
    - outcome_predictability
    
  maintenance_quality:
    - version_control_compliance
    - change_documentation
    - backward_compatibility
```

## 🔄 Template Lifecycle Management

### Template Development
```yaml
development_process:
  design: "Define workflow pattern and agent interactions"
  implementation: "Create YAML template with validation rules"
  testing: "Execute template in test environment"
  review: "Peer review and stakeholder validation"
  deployment: "Release to production template library"
```

### Template Evolution
```yaml
evolution_process:
  monitoring: "Track template performance and outcomes"
  analysis: "Identify improvement opportunities"
  enhancement: "Update template based on learnings"
  versioning: "Maintain backward compatibility"
  migration: "Assist users in template upgrades"
```

### Template Retirement
```yaml
retirement_process:
  deprecation_notice: "Announce template deprecation timeline"
  migration_support: "Provide migration path to new templates"
  grace_period: "Allow time for existing workflows to complete"
  archival: "Archive template for historical reference"
```

## 📋 Configuration Variables

```yaml
# Core Configuration
WORKFLOW_TEMPLATE_VERSION: "{{WORKFLOW_TEMPLATE_VERSION}}"
TEMPLATE_ENGINE: "{{TEMPLATE_ENGINE}}"
CUSTOM_TEMPLATE_COUNT: {{CUSTOM_TEMPLATE_COUNT}}

# Duration Defaults
FEATURE_WORKFLOW_DURATION: "{{FEATURE_WORKFLOW_DURATION}}"
BUG_WORKFLOW_DURATION: "{{BUG_WORKFLOW_DURATION}}"
ARCH_REVIEW_WORKFLOW_DURATION: "{{ARCH_REVIEW_WORKFLOW_DURATION}}"
SPRINT_PLANNING_DURATION: "{{SPRINT_PLANNING_DURATION}}"

# Stage Duration Defaults
REQ_ANALYSIS_DURATION: "{{REQ_ANALYSIS_DURATION}}"
TECH_DESIGN_DURATION: "{{TECH_DESIGN_DURATION}}"
IMPLEMENTATION_DURATION: "{{IMPLEMENTATION_DURATION}}"
QA_DURATION: "{{QA_DURATION}}"

# Performance Metrics
FEATURE_SUCCESS_RATE: {{FEATURE_SUCCESS_RATE}}
BUG_SUCCESS_RATE: {{BUG_SUCCESS_RATE}}
ARCH_SUCCESS_RATE: {{ARCH_SUCCESS_RATE}}
OVERALL_SUCCESS_RATE: {{OVERALL_SUCCESS_RATE}}

# Usage Analytics
ACTIVE_TEMPLATE_WORKFLOWS: {{ACTIVE_TEMPLATE_WORKFLOWS}}
COMPLETED_TODAY: {{COMPLETED_TODAY}}
MOST_EFFICIENT_TEMPLATE: "{{MOST_EFFICIENT_TEMPLATE}}"

# Parameter Defaults
FEATURE_COMPLEXITY: "{{FEATURE_COMPLEXITY}}" # simple|medium|complex
QUALITY_LEVEL: "{{QUALITY_LEVEL}}" # basic|standard|premium
BUG_SEVERITY: "{{BUG_SEVERITY}}" # low|medium|high|critical
REVIEW_SCOPE: "{{REVIEW_SCOPE}}" # component|module|system|enterprise

# Paths
TEMPLATE_LIBRARY_PATH: "{{TEMPLATE_LIBRARY_PATH}}"
CUSTOM_TEMPLATE_PATH: "{{CUSTOM_TEMPLATE_PATH}}"
TEMPLATE_BACKUP_PATH: "{{TEMPLATE_BACKUP_PATH}}"
```

## 🚀 Template Library Examples

### Custom Template: Code Review Workflow
```yaml
workflow_template:
  name: "code_review"
  version: "1.0"
  description: "Comprehensive code review process"
  
  parameters:
    review_type: "{{REVIEW_TYPE}}" # feature|bugfix|refactoring
    reviewer_count: "{{REVIEWER_COUNT}}" # 1|2|3
    
  stages:
    preparation:
      agent: "dev"
      outputs: ["pull_request", "review_checklist", "test_results"]
      
    technical_review:
      agent: "architect"
      outputs: ["architecture_feedback", "security_assessment"]
      
    code_review:
      agent: "dev" # Senior developer
      outputs: ["code_feedback", "quality_assessment"]
      
    approval:
      agent: "sm"
      outputs: ["merge_approval", "deployment_clearance"]
```

### Custom Template: Security Audit Workflow
```yaml
workflow_template:
  name: "security_audit"
  version: "1.0"
  description: "Comprehensive security audit process"
  
  parameters:
    audit_scope: "{{AUDIT_SCOPE}}" # component|system|full
    compliance_framework: "{{COMPLIANCE_FRAMEWORK}}" # SOC2|ISO27001|GDPR
    
  stages:
    vulnerability_assessment:
      agent: "qa" # Security specialist
      outputs: ["vulnerability_report", "risk_assessment"]
      
    architecture_review:
      agent: "architect"
      outputs: ["security_architecture_analysis", "threat_model"]
      
    remediation_planning:
      agent: "dev"
      outputs: ["remediation_plan", "implementation_timeline"]
      
    validation:
      agent: "qa"
      outputs: ["security_validation", "compliance_certification"]
```

This template system provides a comprehensive foundation for defining, instantiating, and managing complex multi-agent workflows while maintaining consistency, quality, and auditability across all APM operations.