# APM Agent Personas - Complete Reference Guide

## Overview
The Agentic Persona Mapping (APM) framework provides specialized AI agents for comprehensive software development lifecycle management. Each agent has distinct expertise, responsibilities, and activation commands.

---

## 🎯 Agent Personas Summary

### 1. **AP Orchestrator** - Central Coordination Hub
- **Specialization**: System-wide coordination, agent delegation, session management
- **Key Responsibilities**:
  - Central command and control for all agents
  - Strategic delegation based on task requirements
  - Session management and context preservation
  - Workflow orchestration between agents
- **Activation**: `/ap` or `/ap_orchestrator`
- **Voice Script**: `speakOrchestrator.sh`

---

### 2. **Analyst** - Discovery & Ideation Expert
- **Specialization**: Brainstorming, research planning, project brief creation
- **Key Responsibilities**:
  - Creative ideation and concept development
  - Deep research prompt generation
  - Market analysis and competitive research
  - Project brief documentation
  - Requirements discovery and analysis
- **Activation**: `/analyst`
- **Voice Script**: `speakAnalyst.sh`
- **Parallel Commands**:
  - `/parallel-requirements` - Comprehensive requirements analysis
  - `/parallel-research-prompt` - Advanced research planning
  - `/parallel-brainstorming` - Structured ideation process
  - `/parallel-stakeholder-review` - Stakeholder analysis

---

### 3. **Product Manager (PM)** - Strategic Product Leader
- **Specialization**: Product strategy, PRD creation, feature prioritization
- **Key Responsibilities**:
  - Transform project briefs into comprehensive PRDs
  - Define product vision and success metrics
  - Break features into epics and user stories
  - Establish MVP scope and roadmap
  - Strategic product decisions
- **Activation**: `/pm`
- **Voice Script**: `speakPm.sh`
- **Parallel Commands**:
  - `/parallel-prd` - Comprehensive PRD development (70% faster)

---

### 4. **Architect** - Technical Design Authority
- **Specialization**: System architecture, technical design, technology selection
- **Key Responsibilities**:
  - Design comprehensive system architecture
  - Define technology stack and patterns
  - Create architectural diagrams and documentation
  - Establish best practices and standards
  - Technical risk assessment
- **Activation**: `/architect`
- **Voice Script**: `speakArchitect.sh`
- **Parallel Commands**:
  - `/parallel-architecture` - Complete architecture creation (75% faster)

---

### 5. **Designer** - UI/UX & Frontend Expert
- **Specialization**: User experience design, frontend architecture, design systems
- **Key Responsibilities**:
  - Create UI/UX specifications and mockups
  - Design frontend component architecture
  - Establish design systems and style guides
  - Ensure accessibility and responsive design
  - Generate AI-optimized frontend prompts
- **Activation**: `/designer`
- **Voice Script**: `speakDesigner.sh`
- **Parallel Commands**:
  - `/parallel-frontend-architecture` - Comprehensive frontend design (80% faster)
  - `/parallel-ai-prompt` - AI development prompt generation (75% faster)

---

### 6. **Product Owner (PO)** - Backlog Guardian
- **Specialization**: Backlog management, story refinement, acceptance criteria
- **Key Responsibilities**:
  - Primary backlog maintenance and grooming
  - Epic and story creation with acceptance criteria
  - Sprint planning and capacity management
  - Dependency tracking and blocker resolution
  - Requirements validation and prioritization
- **Activation**: `/po`
- **Voice Script**: `speakPo.sh`
- **Parallel Commands**:
  - `/parallel-epic` - Comprehensive epic creation (70% faster)
  - `/parallel-stories` - User story generation (75% faster)
  - `/parallel-acceptance-criteria` - Acceptance criteria definition (80% faster)
  - `/parallel-prioritization` - Backlog prioritization (65% faster)
  - `/parallel-validation` - Requirements validation (85% faster)

---

### ~~7. **Scrum Master (SM)** - Sprint Facilitator~~ (REMOVED in v4.3.0)
- **Status**: DEPRECATED - Functionality merged into Product Owner (PO)
- **Migration Path**: Use `/po` or `/pm` for sprint planning and story management
- **Reason for Removal**: Simplified workflow eliminates need for separate SM persona

---

### 7. **Developer** - Code Implementation Specialist
- **Specialization**: Story implementation, code quality, test-driven development
- **Key Responsibilities**:
  - Transform stories into production-ready code
  - Comprehensive testing and quality assurance
  - Security-first implementation
  - Performance optimization
  - Technical documentation
- **Activation**: `/dev` or `/developer`
- **Voice Script**: `speakDeveloper.sh`
- **Parallel Commands**:
  - `/parallel-review` - Comprehensive code analysis (80% faster)

---

### 9. **QA** - Quality Assurance Expert
- **Specialization**: Test strategy, quality validation, automation planning
- **Key Responsibilities**:
  - Create comprehensive test strategies and plans
  - Design test cases and scenarios
  - Execute quality reviews and assessments
  - Establish quality gates and metrics
  - Test automation framework design
- **Activation**: `/qa`
- **Voice Script**: `speakQa.sh`
- **Parallel Commands**:
  - `/parallel-test-strategy` - Test strategy development (75% faster)
  - `/parallel-automation-plan` - Automation framework design (70% faster)
  - `/parallel-test-plan` - Detailed test planning (80% faster)
  - `/parallel-quality-review` - Quality assessment (85% faster)

---

## 🚀 Revolutionary Features

### Parallel Sprint System (`/parallel-sprint`)
The Scrum Master can now coordinate **multiple Developer agents simultaneously**:
- Launches 2-4 Developer agents working concurrently
- Real-time dependency management
- 60-80% sprint acceleration
- Intelligent conflict prevention
- Comprehensive progress synthesis

### Parallel Execution Benefits
Most agents support parallel task execution for dramatic performance improvements:
- 65-85% time reduction on complex tasks
- Multi-dimensional analysis simultaneously
- Comprehensive coverage in single operations
- Intelligent synthesis of parallel results

---

## 📋 Backlog Management

**Critical**: ALL agents must update `project_docs/backlog.md` after any story-related work:
- Immediate status updates when work begins/completes
- Progress percentage tracking
- Acceptance criteria validation
- Dependency documentation
- Blocker reporting

---

## 🔄 Agent Handoff Commands

- `/handoff [agent]` - Direct transition to another persona
- `/switch` - Compact session before switching
- `/wrap` - Archive session and create summary

---

## 🎯 Quick Activation Reference

| Agent | Primary Command | Alternative |
|-------|----------------|-------------|
| Orchestrator | `/ap` | `/ap_orchestrator` |
| Analyst | `/analyst` | - |
| Product Manager | `/pm` | - |
| Architect | `/architect` | - |
| Designer | `/designer` | - |
| Product Owner | `/po` | - |
| ~~Scrum Master~~ | ~~`/sm`~~ | REMOVED v4.3.0 |
| Developer | `/dev` | `/developer` |
| QA | `/qa` | - |

---

## 💡 Best Practices

1. **Start with AP Orchestrator** (`/ap`) for guidance on which agent to use
2. **Use parallel commands** when available for 65-85% time savings
3. **Maintain backlog discipline** - update immediately after work
4. **Follow handoff protocols** for smooth transitions
5. **Leverage voice announcements** for progress awareness

---

*Generated: 2025-01-23*