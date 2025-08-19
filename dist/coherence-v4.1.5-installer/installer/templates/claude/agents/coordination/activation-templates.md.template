# Native Sub-Agent Activation Templates

## Quick Reference for Natural Language Activation

### Basic Activation Pattern
```
I need a [Agent Type] agent to [specific task]
```

### Multiple Agent Activation
```
I need multiple agents working in parallel:
1. I need a [Agent] to [task 1]
2. I need another [Agent] to [task 2]
3. I need a [Agent] to [task 3]
Please work independently and report back when complete.
```

## Agent-Specific Templates

### Developer Agent Activation

#### Single Story Implementation
```
I need a Developer agent to implement Story [ID]: [Title]
- Focus on: [specific features/components]
- Use technologies: [languages/frameworks]
- Create: [expected files/modules]
- Integration points: [what to connect with]
- Complete within: [time estimate]
```

#### Parallel Feature Development
```
I need three Developer agents working simultaneously:
1. Developer 1: Implement the frontend components for [feature]
2. Developer 2: Create the backend API for [feature]
3. Developer 3: Build the database schema and queries for [feature]
Coordinate on shared interfaces but work independently.
```

### QA Agent Activation

#### Test Strategy Creation
```
I need a QA agent to create a comprehensive test strategy for [feature/story]
- Test types: [unit, integration, e2e, performance, security]
- Focus areas: [critical paths, risk areas]
- Deliverables: [test plans, test cases, automation approach]
- Time needed: [estimate]
```

#### Parallel Test Development
```
I need multiple QA agents for comprehensive testing:
1. QA Agent 1: Design unit tests for [module]
2. QA Agent 2: Create integration tests between [module A] and [module B]
3. QA Agent 3: Develop performance benchmarks for [feature]
4. QA Agent 4: Plan security testing scenarios
All agents work in parallel, share test data requirements.
```

### Architect Agent Activation

#### Design Review
```
I need an Architect agent to review the design for [feature/system]
- Evaluate: [scalability, patterns, dependencies]
- Consider: [performance, security, maintainability]
- Provide: [recommendations, concerns, approval]
- Timeline: [when needed by]
```

#### Parallel Architecture Tasks
```
I need architecture guidance from multiple perspectives:
1. Architect 1: Review system scalability and performance patterns
2. Architect 2: Evaluate security architecture and compliance
3. Architect 3: Assess integration patterns and API design
Work in parallel, compile comprehensive recommendations.
```

### Analyst Agent Activation

#### Requirements Analysis
```
I need an Analyst agent to analyze requirements for [feature/planning-epic]
- Review: [business requirements, user stories]
- Identify: [gaps, ambiguities, dependencies]
- Clarify: [acceptance criteria, edge cases]
- Output: [refined requirements, questions for stakeholders]
```

### PM Agent Activation

#### Sprint Planning
```
I need a PM agent to coordinate sprint planning
- Review: [backlog items, team capacity]
- Prioritize: [stories by value and dependencies]
- Create: [sprint plan, resource allocation]
- Consider: [risks, blockers, dependencies]
```

### Product Owner Agent Activation

#### Backlog Grooming
```
I need a Product Owner agent to groom the backlog
- Review: [current stories, new requirements]
- Prioritize: [by business value, dependencies]
- Refine: [acceptance criteria, story points]
- Identify: [gaps, needed stories]
```

## Coordination Patterns

### Sequential with Handoff
```
First: I need an Analyst agent to clarify requirements for [feature]
Then: Pass the refined requirements to a Developer agent for implementation
Finally: Have a QA agent create tests based on the implementation
```

### Parallel with Synchronization
```
I need parallel execution with a sync point:
1. Developer 1: Implement authentication module
2. Developer 2: Create user management API
3. QA: Prepare integration tests for both
All agents work until 70% complete, then sync on integration approach.
```

### Fan-Out Pattern
```
I need one agent to coordinate multiple others:
1. Architect: Define the overall system design
2. Then spawn:
   - Developer 1: Implement component A based on design
   - Developer 2: Implement component B based on design
   - Developer 3: Implement component C based on design
   - QA: Create test framework based on design
```

## Time Management Templates

### Quick Tasks (2-5 minutes)
```
I need a quick review from an Architect agent:
- Task: Review this API endpoint design
- Focus: REST compliance and security
- Time: This should take 2-3 minutes
```

### Medium Tasks (5-15 minutes)
```
I need a Developer agent for a moderate task:
- Implement: User profile update functionality
- Include: Validation, error handling, tests
- Estimate: 10-12 minutes should be sufficient
```

### Complex Tasks (15-30 minutes)
```
I need comprehensive work from multiple agents (25-minute window):
1. Analyst: Deep dive into requirements (10 min)
2. Architect: Design the solution (10 min)
3. Developer: Create initial implementation (15 min)
4. QA: Test strategy and initial tests (10 min)
Agents 1-2 work first, then hand off to agents 3-4.
```

## Result Collection Templates

### Summary Format
```
Please provide results in this format:
- Agent name and task
- What was completed
- Key decisions or findings
- Any blockers or issues
- Next steps needed
- Time taken
```

### Detailed Format
```
For each agent, provide:
1. Executive Summary (2-3 sentences)
2. Detailed Work Completed
   - Files created/modified
   - Features implemented
   - Tests written
3. Technical Decisions Made
4. Integration Points Identified
5. Recommendations for Next Steps
6. Metrics (time, coverage, performance)
```

## Error Handling Templates

### Partial Failure
```
If any agent fails:
1. Continue with remaining agents
2. Report which agent failed and why
3. Provide results from successful agents
4. Suggest recovery approach for failed task
```

### Timeout Handling
```
For long-running tasks:
- Set maximum time: 20 minutes
- Check progress at: 5, 10, 15 minutes
- If approaching timeout: Save partial work
- Report: What's complete vs remaining
```

## Performance Tracking

### Baseline Comparison
```
Track performance metrics:
- Sequential time (if done one by one): [estimate]
- Parallel execution time: [actual]
- Time saved: [difference]
- Efficiency gain: [percentage]
- Agents active simultaneously: [count]
```

### Optimization Feedback
```
After completion, analyze:
- Which agents finished first/last
- Any idle time between tasks
- Integration bottlenecks
- Suggestions for better parallelization
```