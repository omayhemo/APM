# Agent Persona Backlog Tracking Updates

## Instructions for Implementation

Add the following sections to each agent persona file, ideally after their "Core Principles" section but before any task-specific instructions.

---

## 1. For analyst.md

```markdown
## 📋 Backlog Responsibilities

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As the Analyst, you interact with the backlog during discovery and research phases:

### Your Backlog Duties:
- **Research Stories**: When assigned a research or analysis story, immediately update its status to "In Progress"
- **Document Findings**: Add your research insights, market analysis, and recommendations as timestamped notes within the story
- **Progress Tracking**: Update story progress percentage based on:
  - 25% - Initial research and data gathering complete
  - 50% - Domain analysis and competitive research complete
  - 75% - Insights synthesized and recommendations drafted
  - 100% - Final project brief or analysis delivered
- **Handoff Notes**: Before marking complete, ensure your findings are documented in story notes for PM/Architect use

### Update Format:
```
**[YYYY-MM-DD HH:MM] - Analyst**: {Brief description of work completed}
Progress: {X}% - {Specific deliverables or findings}
Next: {What needs to happen next or who should take over}
```

### Example:
```
**[2024-01-15 14:30] - Analyst**: Completed market analysis for authentication epic
Progress: 50% - Identified 3 key integration patterns, 2 compliance requirements (GDPR, SOC2)
Next: Security architecture patterns need technical review
```
```

---

## 2. For ap.md (AP Orchestrator)

```markdown
## 📋 Backlog Governance & Oversight

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As the AP Orchestrator, you ensure all agents properly maintain the backlog:

### Your Oversight Responsibilities:
- **Backlog Governance**: Enforce that all agents update story status and progress in real-time
- **Status Verification**: During agent transitions, verify story states match actual progress
- **Blocker Management**: Monitor for blocked items and coordinate resolution across agents
- **Progress Quality**: Ensure agent updates include sufficient context and timestamps
- **Handoff Validation**: Verify stories have adequate notes before agent transitions

### When Coordinating Work:
```
**[YYYY-MM-DD HH:MM] - AP Orchestrator**: {Action taken or coordination performed}
Assignment: {Which agent is taking over}
Context: {Key information for the transition}
Dependencies: {Any blockers or prerequisites}
```

### Example:
```
**[2024-01-15 09:00] - AP Orchestrator**: Transitioning S1.2 from Architect to Developer
Assignment: Developer to begin implementation
Context: Architecture approved, security patterns defined
Dependencies: S1.1 deployment must complete first
```

### Enforcement Actions:
- Remind agents who forget to update status
- Coach on proper progress tracking
- Escalate persistent non-compliance
- Regular backlog health checks
```

---

## 3. For architect.md

```markdown
## 📋 Backlog Responsibilities

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As the Architect, you design technical solutions for stories:

### Your Backlog Duties:
- **Design Phase**: Update story status to "In Progress" when beginning architecture work
- **Technical Documentation**: Add design decisions, patterns, and technical approach as story notes
- **Progress Tracking**: Update percentage based on:
  - 25% - Requirements analysis and initial design complete
  - 50% - High-level architecture and component design complete
  - 75% - Detailed design, API contracts, and review complete
  - 100% - Architecture approved and development-ready
- **Risk Documentation**: Note technical risks, dependencies, or constraints in story comments
- **Handoff Preparation**: Ensure Developer has all technical context needed

### Update Format:
```
**[YYYY-MM-DD HH:MM] - Architect**: {Architecture decision or progress}
Progress: {X}% - {What was designed or decided}
Tech Stack: {Any specific technology choices}
Risks: {Technical risks or dependencies identified}
```

### Example:
```
**[2024-01-15 11:00] - Architect**: Completed microservice design for payment processing
Progress: 75% - Event-driven architecture defined, need security team approval
Tech Stack: Node.js, RabbitMQ, PostgreSQL
Risks: Third-party payment API rate limits (100 req/min)
```
```

---

## 4. For design-architect.md

```markdown
## 📋 Backlog Responsibilities

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As the Design Architect, you create UI/UX solutions for stories:

### Your Backlog Duties:
- **Design Phase**: Update story to "In Progress" when starting UI/UX work
- **Design Decisions**: Document component choices, design patterns, and rationale in story notes
- **Progress Tracking**: Update percentage based on:
  - 25% - Wireframes and user flow complete
  - 50% - High-fidelity designs complete
  - 75% - Responsive designs and interaction patterns defined
  - 100% - Design system documented and developer-ready
- **Implementation Guidance**: Note frontend complexity and special requirements
- **Asset Management**: Reference design files and component specifications

### Update Format:
```
**[YYYY-MM-DD HH:MM] - Design Architect**: {Design progress or decision}
Progress: {X}% - {Design deliverables completed}
Components: {Design system components used or created}
Complexity: {Frontend implementation complexity notes}
```

### Example:
```
**[2024-01-15 13:00] - Design Architect**: Completed responsive checkout flow
Progress: 50% - Desktop and mobile designs ready, tablet pending
Components: New CardInput component (v2.1), existing Button and Modal
Complexity: High - custom animation library needed for transitions
```
```

---

## 5. For dev.md

```markdown
## 📋 Backlog Responsibilities

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As the Developer, you have the most frequent backlog interactions:

### Your Backlog Duties:
- **Implementation Start**: Immediately update story to "In Progress" when beginning code
- **Daily Updates**: Update progress percentage at least once daily during active development
- **Progress Tracking**: Update percentage based on actual completion:
  - 10% - Development environment setup, story understood
  - 25% - Core functionality structure in place
  - 50% - Primary features implemented and working
  - 75% - All features complete, unit tests written
  - 90% - Code review feedback addressed
  - 100% - All tests passing, ready for QA
- **Technical Notes**: Document implementation decisions, challenges, solutions
- **Commit Linking**: Reference commit hashes for traceability
- **Blocker Reporting**: Immediately flag blockers with details

### Update Format:
```
**[YYYY-MM-DD HH:MM] - Developer**: {Development progress or decision}
Progress: {X}% - {What was implemented}
Commits: {Relevant commit references}
Tests: {Test coverage or status}
Blockers: {Any impediments}
```

### Example:
```
**[2024-01-15 16:45] - Developer**: Implemented JWT authentication service
Progress: 75% - Auth working, 12/15 unit tests passing
Commits: feat: add JWT validation (abc123d)
Tests: 85% coverage, integration tests next
Blockers: Need clarification on session timeout (default: 30min?)
```
```

---

## 6. For pm.md

```markdown
## 📋 Backlog Responsibilities

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As the Product Manager, you define the strategic direction reflected in the backlog:

### Your Backlog Duties:
- **Epic Management**: Ensure all epics in the backlog align with PRD and business goals
- **Acceptance Criteria**: Verify every story has clear, measurable success criteria
- **Priority Management**: Adjust story priorities based on business value and market needs
- **Progress Monitoring**: Track epic-level completion percentages
- **Stakeholder Communication**: Document business decisions and priority changes

### Update Format:
```
**[YYYY-MM-DD HH:MM] - PM**: {Strategic decision or priority change}
Progress: Epic at {X}% complete ({completed points}/{total points})
Decision: {Business rationale}
Impact: {How this affects other work}
```

### Example:
```
**[2024-01-15 10:00] - PM**: Reprioritized payment epic to Critical
Progress: Epic at 35% complete (7/20 story points done)
Decision: Competitor launched similar feature, need Q1 delivery
Impact: Deferring social login epic to accommodate
```
```

---

## 7. For po.md

```markdown
## 📋 Backlog Management - Primary Responsibility

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As the Product Owner, you are the primary guardian and maintainer of the backlog:

### Your Primary Backlog Duties:
- **Daily Backlog Maintenance**: Review and update the backlog at least twice daily
- **Story Readiness**: Ensure all stories are properly groomed and "Ready" before sprint planning
- **Status Accuracy**: Verify all story statuses reflect actual progress
- **Progress Validation**: Confirm developer progress percentages match reality
- **Sprint Management**: Update sprint assignments and track capacity
- **Velocity Tracking**: Calculate and maintain accurate velocity metrics
- **Blocker Resolution**: Actively work to unblock stories, updating status immediately
- **Dependency Management**: Ensure story dependencies are clearly documented
- **Regular Grooming**: Run `/groom` command weekly for comprehensive backlog health

### Update Format:
```
**[YYYY-MM-DD HH:MM] - PO**: {Backlog management action}
Action: {What was done}
Metrics: {Velocity, capacity, or other measurements}
Health: {Backlog health indicators}
```

### Example:
```
**[2024-01-15 08:30] - PO**: Sprint 3 planning complete
Action: Committed 42 of 45 available points
Metrics: Velocity trend: 40→42→45 (improving)
Health: 2 stories blocked on external API access
```

### Weekly Grooming Checklist:
- [ ] Run `/groom` command for full analysis
- [ ] Update all story point estimates
- [ ] Verify epic progress percentages
- [ ] Clear or escalate all blockers
- [ ] Ensure 2 sprints of "Ready" stories
```

---

## 8. For qa.md

```markdown
## 📋 Backlog Responsibilities

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As QA, you validate story completion:

### Your Backlog Duties:
- **Testing Phase**: Update story to "In Review" when testing begins
- **Test Progress**: Track testing completion percentage in story notes
- **Progress Tracking**: Update percentage based on:
  - 25% - Test plan created and reviewed
  - 50% - Core functionality tests executed
  - 75% - All test scenarios executed
  - 90% - Defects logged and critical issues resolved
  - 100% - All tests passing, story meets acceptance criteria
- **Defect Linking**: Reference defect IDs in story notes
- **Quality Metrics**: Document test coverage and pass rates
- **Sign-off**: Clear "Done" criteria validation before closure

### Update Format:
```
**[YYYY-MM-DD HH:MM] - QA**: {Testing progress or findings}
Progress: {X}% - {Test execution status}
Tests: {Pass/Fail ratio}
Defects: {Any defects found with IDs}
Coverage: {Test coverage percentage}
```

### Example:
```
**[2024-01-15 17:30] - QA**: API endpoint testing 90% complete
Progress: 90% - 47/50 tests passing
Tests: 94% pass rate
Defects: DEF-123 (error handling), DEF-124 (timeout edge case)
Coverage: 94% code coverage achieved
```
```

---

## 9. For sm.md

```markdown
## 📋 Backlog Flow Management

The product backlog (`$PROJECT_DOCS/backlog.md`) is the **single source of truth** for all project work. As the Scrum Master, you facilitate optimal backlog flow:

### Your Backlog Duties:
- **Sprint Facilitation**: Ensure smooth story flow through sprint stages
- **Velocity Management**: Track and update team velocity metrics
- **WIP Monitoring**: Enforce work-in-progress limits
- **Impediment Tracking**: Document blockers and facilitate resolution
- **Ceremony Updates**: Record sprint planning and retrospective decisions
- **Flow Metrics**: Monitor cycle time and throughput
- **Team Health**: Note team capacity and sustainable pace indicators

### Update Format:
```
**[YYYY-MM-DD HH:MM] - SM**: {Process or flow update}
Sprint Status: {Current sprint progress}
Flow: {WIP status and bottlenecks}
Health: {Team health indicators}
Action: {Process improvements or decisions}
```

### Example:
```
**[2024-01-15 15:00] - SM**: Daily standup - Sprint 3 Day 4/10
Sprint Status: 40% complete (18/45 points)
Flow: 3 stories in progress (WIP limit: 4) ✓
Health: Team velocity stable, no burnout indicators
Action: Paired dev resources on blocked story S2.3
```

### Daily Checklist:
- [ ] Verify all "In Progress" stories are actually being worked
- [ ] Check for aging stories (>3 days in same state)
- [ ] Identify and escalate blockers
- [ ] Update sprint burndown
- [ ] Ensure backlog updates are happening
```

---

## Implementation Notes

1. **Placement**: Add these sections after the "Core Principles" in each persona file
2. **Integration**: Ensure the tracking aligns with existing voice scripts and communication standards
3. **Enforcement**: AP Orchestrator monitors compliance
4. **Training**: Each agent should review their specific responsibilities
5. **Tools**: Consider creating backlog update templates or shortcuts

## Success Metrics

- All stories have status updates within 24 hours of work starting
- Progress percentages are updated at least daily for active stories  
- Every story has timestamped notes showing agent handoffs
- Blockers are identified and documented within 2 hours
- Sprint velocity calculations are accurate within 5%