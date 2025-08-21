# Story 17.5: Migrate /parallel-sprint Command

**Story ID**: 17.5  
**Epic**: Epic 17 - Parallel Commands to Native Sub-Agents Migration  
**Sprint**: 19 - Core Migration Phase  
**Points**: 8  
**Priority**: High  
**Status**: Ready for Development  
**Dependencies**: Sprint 18 completion

## Story Description

As a Scrum Master, I want the /parallel-sprint command to use native sub-agents so that I can coordinate multiple developers with true parallelism and eliminate CLI crashes.

## Business Value

This is the highest-impact parallel command, currently promising 60-80% sprint acceleration. Migrating to native sub-agents will deliver true parallelism and serve as the flagship demonstration of the new system.

## Acceptance Criteria

### 1. Native Agent Spawning ✓
**Given** the /parallel-sprint command is executed  
**When** launching developer agents  
**Then** the system should:
- [ ] Spawn 2-4 native Developer sub-agents based on sprint capacity
- [ ] Assign each agent to specific stories with clear context
- [ ] Launch QA and Architect agents for coordination
- [ ] Use natural language activation for each agent
- [ ] Track all spawned agents for coordination

### 2. Story Assignment Logic ✓
**Given** multiple stories in the sprint backlog  
**When** distributing work to agents  
**Then** the system should:
- [ ] Read current sprint from backlog.md
- [ ] Identify ready stories with no blockers
- [ ] Assign stories based on dependencies
- [ ] Balance workload across agents
- [ ] Communicate assignments clearly to each agent

### 3. Real-Time Coordination ✓
**Given** multiple agents working simultaneously  
**When** they need coordination  
**Then** the system should:
- [ ] Monitor integration points between stories
- [ ] Coordinate API contract agreements
- [ ] Manage shared resource access
- [ ] Synthesize progress from all agents
- [ ] Identify and resolve conflicts

### 4. Progress Synthesis ✓
**Given** agents completing work  
**When** aggregating results  
**Then** the system should:
- [ ] Collect completion status from each agent
- [ ] Synthesize overall sprint progress
- [ ] Update backlog.md with progress
- [ ] Generate comprehensive sprint report
- [ ] Calculate velocity metrics

### 5. Performance Validation ✓
**Given** the goal of 60-80% acceleration  
**When** the command completes  
**Then** the system should:
- [ ] Measure actual parallel execution time
- [ ] Compare with sequential baseline
- [ ] Verify 4+ agents working simultaneously
- [ ] Document performance improvement
- [ ] Ensure no CLI crashes occur

## Technical Design

### Migration Pattern
```markdown
# OLD Task-based approach:
Task("Sprint analysis", "Analyze backlog...")
Task("Dependency mapping", "Map dependencies...")
Task("Developer allocation", "Plan allocation...")

# NEW Native sub-agent approach:
"I need a Developer agent to work on Story 16.2: User Authentication
 Context: Sprint 18, dependencies on auth framework, 5 story points"

"I need another Developer agent to work on Story 16.3: API Endpoints
 Context: Sprint 18, depends on 16.2 interfaces, 5 points"

"I need a QA agent to plan testing for Stories 16.2 and 16.3
 Context: Integration testing focus, security requirements"

"I need an Architect agent to review integration between 16.2 and 16.3
 Context: Ensure API contracts align, review security patterns"
```

### Orchestration Flow
```markdown
1. SM Agent reads sprint backlog
2. Identifies 4 ready stories
3. Spawns agents with natural language:
   
   Developer 1: "Work on authentication module..."
   Developer 2: "Implement API endpoints..."
   Developer 3: "Create data models..."
   Developer 4: "Build integration layer..."
   QA Agent: "Design test strategy..."
   Architect: "Review technical approach..."

4. Monitors progress (see Story 17.3)
5. Synthesizes results
6. Updates backlog
```

### Example Execution
```markdown
User: /parallel-sprint

SM: Analyzing Sprint 18 backlog... Found 4 ready stories.

🚀 Launching Parallel Sprint Coordination
════════════════════════════════════════

Spawning Developer agents:
✓ Developer 1 → Story 16.2 (Authentication)
✓ Developer 2 → Story 16.3 (API Endpoints)
✓ Developer 3 → Story 16.4 (Data Models)
✓ Developer 4 → Integration & Shared Components

Supporting agents:
✓ QA Agent → Test Strategy & Planning
✓ Architect → Technical Review & Guidance

[Progress updates stream in real-time]

Sprint Execution Summary:
- 4 stories completed in parallel
- Time: 2.5 hours (vs 10 hours sequential)
- Performance: 4x improvement
- All acceptance criteria met
- Zero conflicts or crashes
```

## Implementation Approach

1. **Extract Task Patterns** - Identify all Task tool calls in current implementation
2. **Convert to Natural Language** - Create activation prompts for each
3. **Add Context** - Include sprint context in each activation
4. **Implement Synthesis** - Aggregate results from all agents
5. **Measure Performance** - Validate 4x+ improvement

## Success Metrics

- Successful parallel execution with 2-4 developers
- 60-80% sprint acceleration achieved
- Zero CLI crashes during execution
- Clear progress visibility throughout
- Accurate backlog updates

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Agent coordination complexity | High | Clear task boundaries |
| Context confusion | Medium | Explicit story assignments |
| Performance variance | Medium | Multiple test runs |

## Definition of Done

- [ ] All acceptance criteria met
- [ ] /parallel-sprint fully migrated to native agents
- [ ] Performance improvement verified (4x minimum)
- [ ] No Task tool usage remaining
- [ ] Integration with monitoring system
- [ ] Documentation updated

---

**Created**: 2025-07-25  
**Product Owner**: PO Agent  
**Target Completion**: Sprint 19 End

## Architect's Implementation Details

### Sprint Command Architecture

#### 1. Sprint Analysis & Story Distribution
```javascript
class ParallelSprintOrchestrator {
  async executeParallelSprint() {
    // Step 1: Analyze sprint backlog
    const sprintData = await this.analyzeSprintBacklog();
    
    // Step 2: Calculate optimal agent allocation
    const allocation = this.calculateAgentAllocation(sprintData);
    
    // Step 3: Spawn agents with natural language
    const agents = await this.spawnAgents(allocation);
    
    // Step 4: Monitor and coordinate
    await this.coordinateExecution(agents);
    
    // Step 5: Synthesize and update
    return this.synthesizeResults(agents);
  }
  
  async analyzeSprintBacklog() {
    // Read backlog.md and extract sprint data
    const backlog = await readFile('/project_docs/backlog.md');
    
    return {
      stories: this.extractReadyStories(backlog),
      dependencies: this.mapDependencies(backlog),
      capacity: this.calculateCapacity(backlog),
      integrationPoints: this.identifyIntegrationPoints(backlog)
    };
  }
  
  calculateAgentAllocation(sprintData) {
    const { stories, dependencies, capacity } = sprintData;
    
    // Group stories by dependency chains
    const storyGroups = this.groupByDependencies(stories, dependencies);
    
    // Determine optimal agent count (2-4)
    const agentCount = Math.min(4, Math.max(2, storyGroups.length));
    
    // Assign stories to agents
    const assignments = [];
    for (let i = 0; i < agentCount; i++) {
      assignments.push({
        agentId: `Developer${i + 1}`,
        stories: this.balanceWorkload(storyGroups, i, agentCount),
        role: 'developer'
      });
    }
    
    // Add support agents
    assignments.push(
      { agentId: 'QA', stories: stories, role: 'qa' },
      { agentId: 'Architect', stories: stories, role: 'architect' }
    );
    
    return assignments;
  }
}
```

#### 2. Natural Language Agent Activation
```javascript
class AgentSpawner {
  async spawnAgents(allocation) {
    const agents = [];
    
    for (const assignment of allocation) {
      const agent = await this.spawnAgent(assignment);
      agents.push(agent);
    }
    
    return agents;
  }
  
  async spawnAgent(assignment) {
    const { agentId, stories, role } = assignment;
    
    // Build natural language activation
    const activation = this.buildActivation(role, stories);
    
    // Spawn native sub-agent
    console.log(activation); // This triggers Claude to spawn the agent
    
    // Register with progress manager
    progressManager.registerAgent(agentId, this.getTaskDescription(stories), 
                                 this.getTotalPoints(stories));
    
    return { agentId, role, stories, startTime: Date.now() };
  }
  
  buildActivation(role, stories) {
    const templates = {
      developer: (stories) => `I need a Developer agent to work on ${this.formatStories(stories)}.

Sprint Context:
- Current Sprint: ${this.getCurrentSprint()}
- Working Directory: ${process.cwd()}
- Key Dependencies: ${this.formatDependencies(stories)}
- Integration Points: ${this.formatIntegrationPoints(stories)}
- Definition of Done: All tests pass, documentation updated, PR ready

Please implement these stories following our coding standards and patterns.`,

      qa: (stories) => `I need a QA agent to create test strategies for ${this.formatStories(stories)}.

Testing Context:
- Focus Areas: Integration testing, API contracts, security
- Coverage Target: 80% minimum
- Test Types: Unit, Integration, E2E where applicable
- Special Concerns: ${this.getQAConcerns(stories)}

Please design comprehensive test plans and identify risk areas.`,

      architect: (stories) => `I need an Architect agent to review the technical approach for ${this.formatStories(stories)}.

Review Context:
- Architecture Patterns: Ensure consistency with existing patterns
- Integration Points: Validate API contracts and data flows
- Performance: Consider scalability implications
- Security: Review authentication and authorization patterns

Please provide architectural guidance and identify any concerns.`
    };
    
    return templates[role](stories);
  }
}
```

#### 3. Real-Time Coordination Engine
```javascript
class CoordinationEngine {
  async coordinateExecution(agents) {
    const coordinationTasks = [];
    
    // Set up progress monitoring
    progressStreamHandler.startMonitoring();
    
    // Monitor for integration points
    coordinationTasks.push(this.monitorIntegrationPoints(agents));
    
    // Handle dependency resolution
    coordinationTasks.push(this.handleDependencies(agents));
    
    // Manage shared resources
    coordinationTasks.push(this.manageSharedResources(agents));
    
    // Wait for all agents to complete or timeout
    const timeout = 5 * 60 * 60 * 1000; // 5 hours
    await Promise.race([
      this.waitForCompletion(agents),
      this.timeout(timeout)
    ]);
    
    // Stop monitoring
    progressStreamHandler.stopMonitoring();
  }
  
  async monitorIntegrationPoints(agents) {
    // Watch for API contract definitions
    const contractWatcher = setInterval(() => {
      const contracts = this.extractAPIContracts(agents);
      if (contracts.length > 0) {
        this.broadcastContracts(agents, contracts);
      }
    }, 30000); // Check every 30 seconds
    
    return () => clearInterval(contractWatcher);
  }
  
  extractAPIContracts(agents) {
    // Parse agent outputs for API definitions
    const contracts = [];
    
    for (const agent of agents) {
      const output = progressManager.getAgentOutput(agent.agentId);
      const apiPattern = /API:\s*(\w+)\s*(.+)/g;
      let match;
      
      while ((match = apiPattern.exec(output)) !== null) {
        contracts.push({
          endpoint: match[1],
          contract: match[2],
          agent: agent.agentId
        });
      }
    }
    
    return contracts;
  }
}
```

#### 4. Result Synthesis & Backlog Update
```javascript
class ResultSynthesizer {
  async synthesizeResults(agents) {
    const synthesis = {
      completedStories: [],
      partialProgress: [],
      blockers: [],
      decisions: [],
      metrics: {}
    };
    
    // Collect results from each agent
    for (const agent of agents) {
      const result = await this.collectAgentResult(agent);
      this.mergeResults(synthesis, result);
    }
    
    // Update backlog with progress
    await this.updateBacklog(synthesis);
    
    // Generate sprint report
    const report = this.generateSprintReport(synthesis);
    
    return report;
  }
  
  async updateBacklog(synthesis) {
    const backlogPath = '/project_docs/backlog.md';
    let backlog = await readFile(backlogPath);
    
    // Update story statuses
    for (const story of synthesis.completedStories) {
      backlog = backlog.replace(
        new RegExp(`${story.id}.*Status:.*?\\|`, 's'),
        `${story.id} | Title | Priority | ✅ Done |`
      );
    }
    
    // Add progress notes
    const progressNote = `
**[${new Date().toISOString()}] - Parallel Sprint Execution**
- Completed: ${synthesis.completedStories.map(s => s.id).join(', ')}
- In Progress: ${synthesis.partialProgress.map(s => s.id).join(', ')}
- Performance: ${synthesis.metrics.speedup}x improvement
- Time: ${synthesis.metrics.totalTime}
`;
    
    backlog += progressNote;
    
    await writeFile(backlogPath, backlog);
  }
  
  generateSprintReport(synthesis) {
    return `
🚀 Parallel Sprint Execution Complete
═══════════════════════════════════

📊 Results Summary:
- Stories Completed: ${synthesis.completedStories.length}
- Partial Progress: ${synthesis.partialProgress.length}
- Total Story Points: ${synthesis.metrics.completedPoints}

⚡ Performance Metrics:
- Execution Time: ${synthesis.metrics.totalTime}
- Sequential Estimate: ${synthesis.metrics.sequentialEstimate}
- Speedup: ${synthesis.metrics.speedup}x
- Parallel Efficiency: ${synthesis.metrics.efficiency}%

✅ Completed Stories:
${synthesis.completedStories.map(s => `- ${s.id}: ${s.title}`).join('\n')}

🔧 Technical Decisions:
${synthesis.decisions.map(d => `- ${d}`).join('\n')}

⚠️ Blockers Identified:
${synthesis.blockers.map(b => `- ${b}`).join('\n')}

Next Steps:
- Review completed implementations
- Address identified blockers
- Plan next sprint based on velocity
`;
  }
}
```

### Migration Implementation Steps

1. **Locate Current Implementation**
   ```bash
   grep -r "parallel-sprint" .apm/agents/
   # Find Task-based implementation
   ```

2. **Extract Task Patterns**
   ```javascript
   // Current Task-based pattern
   const tasks = [
     new Task("Analyze sprint", sprintAnalysisPrompt),
     new Task("Map dependencies", dependencyPrompt),
     new Task("Allocate developers", allocationPrompt)
   ];
   ```

3. **Convert to Natural Language**
   - Replace each Task with natural language activation
   - Preserve all context and requirements
   - Add sprint-specific information

4. **Integration Points**
   - Progress monitoring (Story 17.3)
   - Context passing (Story 17.2)
   - Backward compatibility (Story 17.4)

### Performance Optimization

1. **Parallel Efficiency**
   - Minimize sequential bottlenecks
   - Optimize story distribution
   - Enable true concurrent execution

2. **Context Efficiency**
   - Only pass relevant context to each agent
   - Share common context once
   - Minimize token usage

3. **Monitoring Overhead**
   - Lightweight progress parsing
   - Batched updates
   - Non-blocking operations

### Technical Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Story dependency ordering | Intelligent grouping algorithm |
| API contract coordination | Real-time contract broadcasting |
| Progress aggregation | Natural language parsing |
| Backlog update conflicts | Atomic update operations |