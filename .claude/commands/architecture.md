---
name: architecture
description: Sequential architecture design with guided methodology
metadata:
  version: 1.0.0
  agent: Architect
  performance: sequential
  approach: guided
---

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the Architect persona.**

```markdown
*Loading Architect context for optimal command execution...*

Quick Context Load (1-2 seconds):
- Loading Architect configuration and expertise
- Loading relevant templates and frameworks  
- Voice notification: bash $/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakArchitect.sh "Architect context loaded for command execution"
- Workspace validation: Ensuring execution from /mnt/c/Code/agentic-persona-mapping

*Architect context ready. Proceeding with command...*
```


## Metadata
- **Name**: architecture
- **Description**: Sequential architecture design with guided methodology
- **Agent**: Architect
- **Performance**: Sequential (focused design vs parallel streams)
- **Approach**: Interactive guidance and systematic design

## Overview

The `/architecture` command enables the Architect to design system architecture through:
- Sequential design with focused attention on each architectural layer
- Interactive exploration of design alternatives and trade-offs
- Systematic methodology ensuring comprehensive coverage
- Thorough validation of architectural decisions
- Clear documentation with architectural rationale

## Usage

```
/architecture
```

## Prerequisites

Before running this command, ensure:
- [ ] System requirements are well understood
- [ ] Business constraints and goals are clear
- [ ] Technology preferences and constraints defined
- [ ] Existing system architecture reviewed
- [ ] Performance and scalability requirements known

## 🚀 INITIALIZATION PROTOCOL (MANDATORY)

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

## Sequential Architecture Design Process

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

## Interactive Guidance Style

This command emphasizes **collaborative design**:
- **Design thinking approach** with iterative refinement
- **Trade-off analysis** for informed decision making
- **Alternative exploration** considering multiple solutions
- **Stakeholder validation** ensuring alignment with needs
- **Best practice integration** leveraging proven patterns

## Expected Outcomes

After architecture design:
- **Comprehensive architecture document** with all views and details
- **Technology stack justification** with selection rationale
- **Component specifications** with interfaces and responsibilities
- **Quality analysis** with performance and scalability assessment
- **Implementation roadmap** with development guidance

## Output Format

```markdown
# System Architecture Design

## Architecture Overview
- **System Name**: [System name]
- **Architect**: [Name]
- **Design Date**: [Date]
- **Version**: [Version]

## Executive Summary
### Business Context
[Business problem and objectives]

### Architecture Vision
[High-level architecture approach and principles]

### Key Decisions
1. [Major architectural decision with rationale]
2. [Technology choice with justification]
3. [Design pattern selection with benefits]

## System Requirements
### Functional Requirements
- [Key functional requirement impacting architecture]
- [Critical user scenarios]

### Non-Functional Requirements
| Quality Attribute | Requirement | Target | Measurement |
|------------------|-------------|---------|-------------|
| Performance | Response time | < 200ms | 95th percentile |
| Scalability | Concurrent users | 10,000 | Load testing |
| Availability | Uptime | 99.9% | Monthly monitoring |

## Architecture Views

### System Context View
```
[High-level system context diagram]
External Systems <-> [System] <-> Users/Stakeholders
```

### Functional View
#### Major Components
1. **[Component Name]**
   - **Purpose**: [What it does]
   - **Responsibilities**: [Key functions]
   - **Interfaces**: [How other components interact]

2. **[Component Name]**
   - **Purpose**: [What it does]
   - **Responsibilities**: [Key functions]
   - **Interfaces**: [How other components interact]

### Information Architecture
#### Data Models
```markdown
Entity: User
- id: UUID
- name: String
- email: String
- created_at: DateTime
```

#### Data Flow
1. [Data enters system] → [Processing step] → [Data storage/output]
2. [User action] → [System response] → [Data persistence]

### Technology Stack
#### Frontend
- **Framework**: [Choice] - [Rationale]
- **Language**: [Choice] - [Why selected]
- **Libraries**: [Key dependencies]

#### Backend
- **Platform**: [Choice] - [Justification]
- **Framework**: [Choice] - [Benefits]
- **Language**: [Choice] - [Reasoning]

#### Data Layer
- **Primary Database**: [Choice] - [Why appropriate]
- **Caching**: [Solution] - [Purpose]
- **Search**: [Technology] - [Use cases]

#### Infrastructure
- **Hosting**: [Platform] - [Rationale]
- **Deployment**: [Strategy] - [Benefits]
- **Monitoring**: [Tools] - [Capabilities]

## Detailed Design

### Component Architecture
#### [Component Name] Component
```
[Component internal structure diagram]
Interface → Service Layer → Business Logic → Data Access
```

**Responsibilities**:
- [Primary responsibility]
- [Secondary responsibility]

**Interfaces**:
- REST API: [Endpoint descriptions]
- Events: [Published/consumed events]
- Database: [Data access patterns]

### Security Architecture
- **Authentication**: [Method and implementation]
- **Authorization**: [Role-based/attribute-based approach]
- **Data Protection**: [Encryption and privacy measures]
- **Communication Security**: [TLS, API security]

### Deployment Architecture
```
[Deployment diagram showing environments]
Load Balancer → Web Servers → Application Servers → Database
```

## Quality Analysis

### Performance Characteristics
- **Expected Load**: [Concurrent users, requests/second]
- **Response Times**: [Target response times by operation]
- **Resource Requirements**: [CPU, memory, storage estimates]

### Scalability Strategy
- **Horizontal Scaling**: [Approach for scaling out]
- **Vertical Scaling**: [Approach for scaling up]
- **Bottleneck Analysis**: [Potential constraints and solutions]

### Risk Assessment
| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| [Risk 1] | [High/Med/Low] | [High/Med/Low] | [Strategy] |
| [Risk 2] | [High/Med/Low] | [High/Med/Low] | [Strategy] |

## Implementation Guidance

### Development Phases
1. **Phase 1**: [Core infrastructure and foundational components]
2. **Phase 2**: [Primary business logic and features]
3. **Phase 3**: [Advanced features and optimization]

### Technical Debt Considerations
- [Known shortcuts or compromises]
- [Areas requiring future refactoring]
- [Technical debt paydown strategy]

## Architecture Decisions

### ADR-001: [Decision Title]
- **Status**: [Accepted/Superseded]
- **Context**: [Situation requiring decision]
- **Decision**: [What was decided]
- **Rationale**: [Why this decision]
- **Consequences**: [Positive and negative outcomes]

## Next Steps
1. [Immediate action required]
2. [Architecture review and validation]
3. [Prototype development recommendations]
4. [Team communication and training needs]
```

## Integration Points

- **Requirements**: Use `/requirements` for detailed requirement analysis
- **Technical Specs**: Use `/frontend-architecture` for UI architecture
- **Implementation**: Use `/parallel-architecture` for rapid development
- **Review**: Use `/parallel-review` for architecture validation

## Voice Notifications

```bash
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakArchitect.sh "Sequential architecture design beginning. Launching systematic architecture development process..."
```

## Success Metrics

- **Design Completeness**: All architectural views and components covered
- **Requirement Traceability**: Architecture addresses all system requirements
- **Quality Achievement**: Design meets non-functional requirements
- **Stakeholder Alignment**: Architecture approved by technical stakeholders
- **Implementation Readiness**: Clear guidance for development team

## When to Use Sequential vs Parallel

**Use `/architecture` when:**
- Complex architectural decisions need deep analysis
- Interactive design exploration and validation desired
- Thorough trade-off analysis critical
- Stakeholder collaboration important
- Quality and thoughtfulness over speed

**Use `/parallel-architecture` when:**
- Comprehensive architecture needed quickly
- Multiple architectural domains simultaneously
- Time constraints exist
- Well-understood architectural patterns
- Speed and broad coverage prioritized

---

This command provides thoughtful, systematic architecture design with emphasis on thorough analysis, stakeholder collaboration, and quality outcomes.
