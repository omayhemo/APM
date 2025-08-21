# APM Sub-Agent Operational Procedures

## Overview

Comprehensive operational guidance for day-to-day usage of the Agentic Persona Mapping (APM) Sub-Agent system in {{INSTALLATION_ENVIRONMENT}} environment with {{OPERATIONAL_COMPLEXITY}} complexity level.

## Daily Operations Workflow

### Morning Startup Routine

#### System Health Check
```bash
# Daily system validation
./scripts/daily-health-check.sh --environment={{INSTALLATION_ENVIRONMENT}}

# Verify agent availability
echo "ap" | claude --health-check

# Check parallel execution capacity
./scripts/check-parallel-capacity.sh --max-agents=4
```

#### Team Coordination Setup
```bash
# Initialize team workspace
apm workspace init --team-size=6 --complexity={{OPERATIONAL_COMPLEXITY}}

# Load current sprint context
apm sprint load --metrics={{BUSINESS_METRICS}}

# Verify integration points
apm integration verify --all
```

### Standard Agent Activation Procedures

#### Single Agent Activation
```bash
# Basic agent activation pattern
User Input: "dev"
System Response: 
  1. List session notes directory (LS tool)
  2. List rules directory (LS tool)  
  3. Create new session note with timestamp
  4. Execute voice notification
  5. Present agent capabilities

# Verification checklist
□ Session note created: /session_notes/YYYY-MM-DD-HH-mm-ss-Agent-Type.md
□ Voice notification executed successfully
□ Agent context loaded completely
□ Previous session context available
```

#### Parallel Agent Coordination
```bash
# Revolutionary parallel development
User Input: "/parallel-implementation-sprint"
System Execution:
  Phase 1: Sprint Analysis (3 parallel tasks)
    - Load sprint plan and dependencies
    - Analyze resource allocation needs
    - Plan developer stream coordination
    
  Phase 2: Launch Development (4 concurrent streams)
    - Primary Developer: Core feature development
    - Secondary Developer: Integration features  
    - Integration Developer: System integration
    - QA Coordinator: Quality assurance oversight
    
  Phase 3: Coordinate & Synthesize (4 parallel tasks)
    - Real-time dependency resolution
    - Integration point monitoring
    - Progress aggregation and reporting
    - Sprint health assessment

# Success criteria
□ All 4 developer streams launched successfully
□ Dependency conflicts identified and resolved
□ Integration points coordinated properly
□ Real-time progress synthesis functioning
```

## Agent-Specific Operational Procedures

### Developer Agent Operations

#### Standard Development Workflow
```bash
# Activate developer agent
User: "dev"

# Core development tasks
1. Story analysis and technical planning
2. Architecture compliance verification
3. Code implementation with best practices
4. Automated testing integration
5. Security scan execution
6. Performance optimization
7. Code review preparation
8. Integration point validation

# Quality gates
□ All acceptance criteria addressed
□ Test coverage ≥90% for new code
□ Security vulnerabilities: 0 high, 0 critical
□ Performance benchmarks met
□ Code review checklist completed
```

#### Parallel Development Coordination
```bash
# When multiple developers are active
- Automatic conflict detection and prevention
- Real-time code integration monitoring  
- Shared dependency management
- Coordinated testing strategies
- Integrated deployment preparation

# Coordination checkpoints
□ Hourly integration sync completed
□ Dependency conflicts resolved
□ Test suite compatibility maintained
□ Integration points validated
□ Deployment readiness confirmed
```

### QA Agent Operations

#### Comprehensive Testing Framework
```bash
# Activate QA agent with full framework
User: "/qa-framework"

# AI/ML-Powered Testing Capabilities
1. Test Failure Prediction (92% accuracy)
   - Historical pattern analysis
   - Code change impact assessment
   - Risk-based test prioritization

2. Test Execution Optimization (63% time reduction)
   - Intelligent test ordering
   - Parallel execution strategies
   - Resource utilization optimization

3. Quality Anomaly Detection (94% precision)
   - Performance degradation identification
   - Quality trend analysis
   - Unusual pattern detection

4. Security Testing Integration
   - SAST (Static Application Security Testing)
   - DAST (Dynamic Application Security Testing)
   - Vulnerability assessment and reporting

# Quality assurance checklist
□ All test types executed successfully
□ Security scan completed with zero critical issues
□ Performance benchmarks validated
□ Accessibility compliance verified (WCAG 2.1 AA)
□ Cross-browser compatibility confirmed
□ Mobile responsiveness validated
```

#### Parallel QA Execution
```bash
# Parallel testing framework (4x speedup)
User: "/parallel-qa-framework"

Concurrent Execution:
  Stream 1: Unit and Integration Tests
  Stream 2: Security and Vulnerability Scanning
  Stream 3: Performance and Load Testing
  Stream 4: User Experience and Accessibility Testing

# Parallel QA success criteria
□ All test streams execute without conflicts
□ Results consolidated into unified report
□ Cross-stream dependencies properly managed
□ Performance impact minimized during execution
```

### Architect Agent Operations

#### System Architecture Procedures
```bash
# Activate system architect
User: "architect"

# Core architecture responsibilities
1. System design and documentation
2. Technology stack evaluation and selection
3. Integration pattern specification
4. Performance architecture optimization
5. Security architecture implementation
6. Scalability planning and design
7. Technical debt assessment and planning

# Architecture quality gates
□ System design documents updated and reviewed
□ Technology decisions documented with rationale
□ Integration patterns specified and validated
□ Performance requirements addressed
□ Security architecture reviewed and approved
□ Scalability plan documented and resourced
```

#### Design System Architecture
```bash
# Activate design system architect
User: "designer"

# Design system responsibilities
1. Component library management and evolution
2. Design token system maintenance
3. Accessibility compliance implementation
4. Cross-platform design consistency
5. Design system governance and standards
6. User experience optimization

# Design quality gates
□ Component library updated and documented
□ Design tokens synchronized across platforms
□ Accessibility standards compliance verified
□ Design consistency validated across touchpoints
□ User experience metrics measured and optimized
```

### Product Management Operations

#### Product Owner Procedures
```bash
# Activate product owner
User: "po"

# Core product management tasks
1. Backlog grooming and prioritization
   - Business value assessment
   - User story refinement
   - Acceptance criteria definition
   - Dependency analysis and resolution

2. Stakeholder alignment and communication
   - Requirement validation with stakeholders
   - Progress reporting and metrics sharing
   - Risk assessment and mitigation planning

3. Release planning and coordination
   - Feature roadmap development
   - Release scope definition and management
   - Go-to-market strategy alignment

# Product owner quality gates
□ Backlog items properly groomed and prioritized
□ All user stories have clear acceptance criteria
□ Stakeholder requirements validated and documented
□ Business value clearly articulated for all features
□ Release scope agreed upon by all stakeholders
```

#### Advanced Backlog Management
```bash
# Comprehensive backlog grooming
User: "/planning-groom"

# AI-powered grooming capabilities
1. Automated story breakdown and sizing
2. Dependency graph analysis and optimization
3. Business value calculation and ranking
4. Capacity optimization and sprint allocation
5. Risk assessment and mitigation planning

# Grooming success criteria
□ All epics broken down into implementable stories
□ Story points estimated with team consensus
□ Dependencies identified and documented
□ Business value clearly quantified
□ Sprint capacity optimized for maximum value delivery
```

#### Project Manager Procedures
```bash
# Activate project manager
User: "pm"

# Project coordination responsibilities
1. Sprint planning and execution oversight
2. Resource allocation and optimization
3. Risk identification and mitigation
4. Stakeholder communication and reporting
5. Delivery timeline management
6. Team performance monitoring and optimization

# Project management quality gates
□ Sprint plans created with team input and commitment
□ Resource allocation optimized for maximum efficiency
□ Risks identified, assessed, and mitigation plans in place
□ Stakeholder communication plan executed regularly
□ Delivery milestones tracked and reported accurately
```

### Scrum Master Operations

#### Agile Process Facilitation
```bash
# Activate scrum master
User: "sm"

# Core scrum master responsibilities
1. Sprint ceremony facilitation
   - Sprint planning meetings
   - Daily standup coordination
   - Sprint review and retrospective facilitation
   - Backlog refinement sessions

2. Team performance optimization
   - Impediment removal and escalation
   - Team velocity tracking and improvement
   - Process improvement identification and implementation
   - Team dynamics observation and coaching

3. Agile compliance and improvement
   - Process adherence monitoring
   - Metrics collection and analysis
   - Continuous improvement initiatives
   - Team coaching and mentoring

# Scrum master quality gates
□ All sprint ceremonies completed on schedule
□ Team impediments identified and resolved promptly
□ Sprint velocity tracked and trending positively
□ Process improvements identified and implemented
□ Team satisfaction and engagement maintained at high levels
```

#### Revolutionary Parallel Sprint Coordination
```bash
# Launch parallel development coordination
User: "/parallel-implementation-sprint"

# Breakthrough capability: Multiple developers working simultaneously
Benefits:
- 60-80% sprint acceleration through true parallel development
- Real-time dependency management and conflict prevention
- Intelligent integration point coordination
- Comprehensive progress synthesis from all parallel streams

# Parallel sprint success criteria
□ 2-4 Developer agents launched and coordinating effectively
□ Dependencies mapped and conflicts prevented proactively
□ Integration points monitored and managed continuously
□ Progress synthesized in real-time across all streams
□ Sprint goals achieved with maintained code quality
□ Team collaboration enhanced through parallel coordination
```

## Session Management Procedures

### Session Lifecycle Management

#### Session Initialization
```bash
# Automatic session setup for all agents
1. Check existing session notes (LS tool on directory)
2. Check behavioral rules (LS tool on directory)
3. Create timestamped session note file
4. Initialize agent context and capabilities
5. Execute welcome voice notification

# Session file naming convention
Format: YYYY-MM-DD-HH-mm-ss-Agent-Type-Description.md
Example: 2025-01-15-14-30-00-Developer-Feature-Implementation.md
```

#### Session Handoff Procedures
```bash
# Seamless agent transitions
User: "/handoff qa"

# Handoff process
1. Current agent documents session progress
2. Context preservation and optimization
3. Target agent initialization with inherited context
4. Verification of successful context transfer
5. Confirmation of operational continuity

# Handoff quality gates
□ All session context successfully transferred
□ No information loss during transition
□ Target agent fully operational with inherited context
□ Session continuity maintained for user experience
```

#### Session Archival
```bash
# Complete session archival
User: "/wrap"

# Archival process
1. Session summary generation with AI insights
2. Key decisions and outcomes documentation
3. Performance metrics capture and analysis
4. Lessons learned identification and documentation
5. Archive file creation with metadata

# Archive location
Path: /session_notes/archive/YYYY-MM-DD-HH-mm-ss-Session-Title.md
```

## Error Handling and Recovery Procedures

### Common Operational Issues

#### Agent Activation Failures
```bash
# Symptoms
- Agent fails to respond to activation command
- Voice notification system not functioning
- Session note creation errors
- Context loading failures

# Recovery procedures
1. Verify system health: ./scripts/health-check.sh
2. Check resource availability: ./scripts/resource-check.sh
3. Restart APM services: ./scripts/restart-apm.sh
4. Validate configuration: ./scripts/validate-config.sh
5. Emergency rollback if needed: ./scripts/emergency-rollback.sh

# Prevention measures
□ Regular system health monitoring
□ Proactive resource management
□ Configuration validation automation
□ Backup and recovery testing
```

#### Parallel Execution Issues
```bash
# Common parallel execution problems
- Agent conflicts and resource contention
- Integration point failures
- Dependency resolution errors
- Performance degradation under load

# Resolution procedures
1. Identify conflicting agents: ./scripts/identify-conflicts.sh
2. Resolve resource contention: ./scripts/resolve-contention.sh
3. Validate integration points: ./scripts/validate-integration.sh
4. Optimize resource allocation: ./scripts/optimize-resources.sh

# Performance optimization
□ Monitor system resource utilization
□ Implement intelligent load balancing
□ Optimize agent coordination algorithms
□ Maintain performance baselines and alerts
```

### Emergency Procedures

#### System Recovery
```bash
# Emergency system recovery
1. Immediate assessment: ./scripts/emergency-assessment.sh
2. Critical services restoration: ./scripts/restore-critical.sh
3. Data integrity verification: ./scripts/verify-data-integrity.sh
4. Gradual service restoration: ./scripts/gradual-restore.sh
5. Post-incident analysis: ./scripts/post-incident-analysis.sh

# Recovery success criteria
□ All critical services restored and operational
□ Data integrity verified and maintained
□ System performance restored to baseline levels
□ Incident root cause identified and documented
□ Prevention measures implemented and tested
```

## Performance Monitoring and Optimization

### Key Performance Indicators

#### System Performance Metrics
```yaml
Agent Activation Time: <2 seconds average
Parallel Execution Speedup: 4x baseline performance
Session Handoff Time: <1 second average
Voice Notification Latency: <500ms average
System Availability: >99.9% uptime target
Resource Utilization: <80% peak usage
```

#### Business Performance Metrics
```yaml
Sprint Acceleration: 60-80% improvement with parallel development
QA Efficiency: 63% test execution time reduction
Prediction Accuracy: 92% for test failure prediction
Anomaly Detection: 94% precision rate
Code Quality: Maintained despite accelerated development
Team Satisfaction: >4.5/5.0 rating for APM system usage
```

### Optimization Procedures

#### Performance Tuning
```bash
# Regular performance optimization
1. Baseline measurement: ./scripts/measure-baseline.sh
2. Performance profiling: ./scripts/profile-performance.sh
3. Bottleneck identification: ./scripts/identify-bottlenecks.sh
4. Optimization implementation: ./scripts/implement-optimizations.sh
5. Performance validation: ./scripts/validate-optimizations.sh

# Optimization targets
□ Agent activation time reduced by 20%
□ Parallel execution efficiency improved by 15%
□ Memory utilization optimized by 25%
□ Network latency reduced by 30%
```

## Maintenance and Housekeeping

### Daily Maintenance Tasks
```bash
# Automated daily maintenance
0 2 * * * /scripts/daily-maintenance.sh --level={{MAINTENANCE_LEVEL}}

# Daily tasks include
- Session note cleanup and archival
- Performance metrics collection and analysis
- System health monitoring and alerting
- Resource utilization optimization
- Security scan execution and reporting
```

### Weekly Maintenance Tasks
```bash
# Weekly system maintenance
0 3 * * 0 /scripts/weekly-maintenance.sh --comprehensive

# Weekly tasks include
- Full system backup and verification
- Performance trend analysis and reporting
- Configuration drift detection and correction
- Security vulnerability assessment
- Capacity planning and resource forecasting
```

### Monthly Maintenance Tasks
```bash
# Monthly system review and optimization
0 4 1 * * /scripts/monthly-maintenance.sh --full-review

# Monthly tasks include
- Comprehensive system performance review
- Business metrics analysis and reporting
- Process improvement identification and planning
- Technology stack review and updates
- Training needs assessment and planning
```

## Compliance and Governance

### Operational Compliance
```yaml
Security Standards: SOC 2 Type II, ISO 27001
Data Protection: GDPR, CCPA compliance
Audit Trail: Complete session and operation logging
Access Control: Role-based permissions and authentication
Change Management: Controlled deployment procedures
```

### Quality Governance
```yaml
Code Quality: Automated quality gates and reviews
Testing Standards: Comprehensive test coverage requirements
Performance Standards: SLA compliance monitoring
Documentation Standards: Complete operational documentation
Training Standards: Regular team training and certification
```

---

**Operational Procedures Version**: {{DOCUMENTATION_VERSION}}  
**Environment**: {{INSTALLATION_ENVIRONMENT}}  
**Complexity Level**: {{OPERATIONAL_COMPLEXITY}}  
**Business Metrics**: {{BUSINESS_METRICS}}  
**Maintenance Level**: {{MAINTENANCE_LEVEL}}