---
name: planning-architecture
description: Architecture design with sequential or parallel execution options
metadata:
  version: 2.0.0
  agent: Architect
  parallel_support: true
  modes: [sequential, parallel]
---

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the Architect persona.**

```markdown
*Loading Architect context for architecture design...*

Quick Context Load (1-2 seconds):
- Loading Architect configuration and expertise
- Loading relevant templates and frameworks
- PARALLEL_MODE: Preparing parallel execution framework and voice notification: bash $/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakArchitect.sh "Architect ready for parallel execution"
- SEQUENTIAL_MODE: Voice notification: bash $/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakArchitect.sh "Architect context loaded for command execution"
- Workspace validation: Ensuring execution from /mnt/c/Code/agentic-persona-mapping

*PARALLEL_MODE: Architect context ready. Launching parallel streams...*
*SEQUENTIAL_MODE: Architect context ready. Proceeding with command...*
```

## Command Overview

This command supports both sequential and parallel architecture design approaches:

**Sequential Mode (Default):**
- Interactive design with deep analysis and stakeholder collaboration
- Systematic methodology ensuring comprehensive coverage
- Thorough validation of architectural decisions
- Time: 45-60 minutes for complete architecture

**Parallel Mode (--parallel flag):**
- 6 concurrent domain specialists working simultaneously
- 75% performance improvement (12-18 minutes)
- Comprehensive coverage across all architectural domains
- Real-time coordination and integration

## Usage

```
/planning-architecture [--parallel]
```

**Parameters:**
- `--parallel`: Execute parallel architecture design with 6 concurrent domains
- Default: Sequential architecture design with guided methodology

## Prerequisites

**For Sequential Mode:**
- [ ] System requirements are well understood
- [ ] Business constraints and goals are clear
- [ ] Technology preferences and constraints defined
- [ ] Existing system architecture reviewed
- [ ] Performance and scalability requirements known

**For Parallel Mode:**
- [ ] Product requirements and business constraints are documented
- [ ] Technical constraints and non-functional requirements are defined
- [ ] Existing system components and integrations are catalogued
- [ ] Stakeholder architecture requirements are captured

## 🚀 INITIALIZATION PROTOCOL (MANDATORY)

### SEQUENTIAL_MODE: Sequential Initialization

**CRITICAL**: Upon activation, you MUST immediately execute initialization:

```
I'm launching sequential architecture design for comprehensive system architecture development.

*Loading architecture frameworks and design methodologies...*
[Execute initialization tasks in sequence]
- Load architecture templates and frameworks
- Review system requirements and constraints
- Prepare design methodologies and patterns
- Set up validation and documentation processes
```

### PARALLEL_MODE: Parallel Initialization

**CRITICAL**: Upon activation, you MUST immediately execute parallel initialization:

```
I'm initializing the Parallel Architecture Design process. Let me load all required context in parallel for optimal performance.

*Executing parallel initialization tasks:*
[Execute all 5 tasks in single function_calls block]
- Task 1: Load architecture standards from /mnt/c/Code/agentic-persona-mapping/.apm/agents/templates/planning-architecture-standards.md
- Task 2: Load current system documentation from /mnt/c/Code/agentic-persona-mapping/project_docs/planning-architecture/
- Task 3: Load technical requirements from /mnt/c/Code/agentic-persona-mapping/project_docs/planning-requirements/
- Task 4: Load integration patterns from /mnt/c/Code/agentic-persona-mapping/.apm/agents/templates/integration-patterns.md
- Task 5: Load architecture decision templates from /mnt/c/Code/agentic-persona-mapping/.apm/agents/templates/planning-architecture-decisions.md
```

## SEQUENTIAL_MODE: Sequential Architecture Design Process

### Phase 1: Requirements Analysis & Context (15-20 minutes)
**Objective**: Understand system needs and establish design foundation
- **Requirements Review**
  - Functional requirements analysis
  - Non-functional requirements (NFRs)
  - Quality attribute requirements
  - Constraint identification

- **Context Definition**
  - Business context and objectives
  - Technical environment and ecosystem
  - Stakeholder needs and concerns
  - Existing system landscape

### Phase 2: High-Level Design (20-25 minutes)
**Objective**: Create overall system architecture and major components
- **System Architecture**
  - Overall system structure
  - Major subsystem identification
  - High-level component relationships
  - Data flow and integration points

- **Technology Stack Selection**
  - Platform and framework decisions
  - Database and storage technologies
  - Communication protocols
  - Third-party service integration

### Phase 3: Detailed Component Design (25-30 minutes)
**Objective**: Design individual components and their interactions
- **Component Architecture**
  - Component responsibilities and interfaces
  - Internal component structure
  - Inter-component communication
  - Component lifecycle management

- **Data Architecture**
  - Data models and schemas
  - Data flow and transformations
  - Storage strategies and patterns
  - Data consistency and integrity

### Phase 4: Quality & Validation (15-20 minutes)
**Objective**: Validate design against requirements and best practices
- **Quality Attribute Analysis**
  - Performance characteristics
  - Scalability and availability
  - Security and compliance
  - Maintainability and extensibility

- **Design Validation**
  - Requirement traceability
  - Architecture review checklist
  - Risk assessment and mitigation
  - Trade-off analysis documentation

## PARALLEL_MODE: Parallel Architecture Domains

### Domain 1: System Design & Components (8-12 minutes)
- **Focus**: Core system components, microservices architecture
- **Deliverables**: System component diagrams, service boundaries
- **Dependencies**: Business requirements, scalability needs
- **Integration**: API contracts, data flows

### Domain 2: Data Architecture & Storage (10-15 minutes)
- **Focus**: Database design, data modeling, storage strategies
- **Deliverables**: Data models, storage architecture, migration plans
- **Dependencies**: Data requirements, performance constraints
- **Integration**: Service data contracts, consistency patterns

### Domain 3: Security & Compliance Architecture (12-18 minutes)
- **Focus**: Authentication, authorization, security patterns
- **Deliverables**: Security architecture, threat model, compliance matrix
- **Dependencies**: Security requirements, regulatory constraints
- **Integration**: Identity management, audit trails

### Domain 4: Integration & API Design (8-14 minutes)
- **Focus**: External integrations, API design, messaging
- **Deliverables**: Integration architecture, API specifications
- **Dependencies**: Third-party systems, communication patterns
- **Integration**: Service contracts, event schemas

### Domain 5: Infrastructure & Deployment (10-16 minutes)
- **Focus**: Cloud architecture, deployment strategies, monitoring
- **Deliverables**: Infrastructure diagrams, deployment pipelines
- **Dependencies**: Performance requirements, operational constraints
- **Integration**: Service deployment, monitoring strategy

### Domain 6: Performance & Scalability (9-13 minutes)
- **Focus**: Performance patterns, scalability strategies, optimization
- **Deliverables**: Performance architecture, scalability plans
- **Dependencies**: Performance requirements, growth projections
- **Integration**: Caching strategies, load balancing

## Architecture Design Framework

### Architectural Views
- **Functional View**: What the system does
- **Information View**: Data structures and flow
- **Concurrency View**: Process and thread management
- **Development View**: Code organization and modules
- **Deployment View**: Physical deployment and infrastructure
- **Operational View**: Runtime monitoring and management

### Design Patterns & Principles
- **SOLID Principles**: Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
- **Architectural Patterns**: Layered, Microservices, Event-driven, CQRS, Hexagonal
- **Design Patterns**: Factory, Observer, Strategy, Command, Repository
- **Integration Patterns**: API Gateway, Message Bus, Event Sourcing

### Quality Attributes
- **Performance**: Response time, throughput, resource utilization
- **Scalability**: Horizontal and vertical scaling strategies
- **Availability**: Uptime requirements and fault tolerance
- **Security**: Authentication, authorization, data protection
- **Maintainability**: Code quality, modularity, documentation

## Expected Outcomes

**Sequential Mode:**
- Comprehensive architecture document with all views and details
- Technology stack justification with selection rationale
- Component specifications with interfaces and responsibilities
- Quality analysis with performance and scalability assessment
- Implementation roadmap with development guidance

**Parallel Mode:**
- 6 Architect domain agents working simultaneously
- Coordinated design with seamless integration of all architectural domains
- 75% reduction in sequential architecture time
- Early identification of integration and design issues
- Real-time progress tracking across all domains

## Performance Metrics

**Sequential Mode:**
- Design Completeness: All architectural views and components covered
- Requirement Traceability: Architecture addresses all system requirements
- Quality Achievement: Design meets non-functional requirements
- Stakeholder Alignment: Architecture approved by technical stakeholders
- Implementation Readiness: Clear guidance for development team

**Parallel Mode:**
- Baseline Architecture Time: 45-60 minutes (sequential)
- Parallel Architecture Time: 12-18 minutes (parallel domains)
- Performance Improvement: 75% faster execution
- Domain Coverage: 100% comprehensive coverage
- Integration Success: >95% successful cross-domain alignment

## When to Use Each Mode

**Use Sequential Mode when:**
- Complex architectural decisions need deep analysis
- Interactive design exploration and validation desired
- Thorough trade-off analysis critical
- Stakeholder collaboration important
- Quality and thoughtfulness over speed

**Use Parallel Mode when:**
- Comprehensive architecture needed quickly
- Multiple architectural domains simultaneously
- Time constraints exist
- Well-understood architectural patterns
- Speed and broad coverage prioritized

## Integration Points

- **Requirements**: Use `/planning-requirements` for detailed requirement analysis
- **Technical Specs**: Use `/planning-frontend-architecture` for UI architecture
- **Implementation**: Use development commands for implementation
- **Review**: Use review commands for architecture validation

## Voice Notifications

```bash
# Sequential Mode
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakArchitect.sh "Sequential architecture design beginning. Launching systematic architecture development process..."

# Parallel Mode
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakArchitect.sh "Parallel architecture design launching. Initiating 6 simultaneous domain specialists for 75% architecture acceleration..."
```

---

**This command provides both thoughtful sequential architecture design and high-speed parallel architecture development, allowing you to choose the approach that best fits your project needs.**