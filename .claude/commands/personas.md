---
name: personas
description: List available AP Mapping personas and their capabilities
---

# APM FRAMEWORK v4.3.2 PERSONAS

## Available Agent Personas (9 Total)

### 1. **AP Orchestrator** (/ap)
- Central coordinator and method expert
- Can embody any specialist persona
- Manages agent transitions
- Provides APM method guidance

### 2. **Analyst** (/analyst)
- Research and requirements gathering
- Market analysis and competitive research
- User research synthesis
- Creates comprehensive project briefs

### 3. **Product Manager (PM)** (/pm)
- Product Requirements Documents (PRDs)
- Epic and high-level story creation
- Strategic product planning
- Stakeholder alignment

### 4. **Architect** (/architect)
- System design and technical architecture
- Technology stack selection
- Scalability and security planning
- Technical decision documentation

### 5. **Designer** (/designer)
- UI/UX architecture and design systems
- Frontend design patterns and components
- User experience optimization
- Visual design and interaction flows
- *Note: Previously called design-architect in v4.2.0*

### 6. **Product Owner (PO)** (/po)
- Backlog management and grooming
- Story refinement and prioritization
- Acceptance criteria definition
- Sprint planning support

### 7. **Developer** (/dev or /developer)
- Code implementation
- Technical problem solving
- Test development
- Code review and refactoring

### 8. **QA** (/qa)
- Test strategy and planning
- Quality assurance processes
- Test automation design
- Defect management

### 9. **Business Case Analyst** (/planning-business-case)
- Comprehensive backlog grooming
- 18 parallel sub-agents for business analysis
- ROI and cost-benefit analysis
- Stakeholder alignment and buy-in

## Activation Methods

### Direct Activation
- Use `/[persona]` to activate any agent directly
- Example: `/architect` activates the Architect agent

### Orchestrated Activation
- Use `/ap` to start with the orchestrator
- Orchestrator can transition to any specialist

### Agent Transitions
- `/handoff [persona]` - Direct transfer with context
- `/switch [persona]` - Session break with compaction
- Note: `/sm` command removed in v4.3.2

## Parallel Capabilities
All 9 agents support parallel task execution for:
- Document loading during initialization
- Multi-faceted analysis
- Context transfer during handoffs
- New in v4.3.2: `/planning-business-case` with 18 parallel sub-agents

## Best Practices
1. Start with `/ap` for guidance on which agent to use
2. Use direct activation when you know the specific agent needed
3. Handoff between agents for complex workflows
4. Switch agents to reduce context and start fresh phases