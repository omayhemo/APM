# Progress Manager - Real-Time Sub-Agent Monitoring

> **Core Component**: Central progress tracking and management for native sub-agent execution

## Overview

The Progress Manager is responsible for tracking, parsing, and managing real-time progress updates from multiple sub-agents executing in parallel. It provides natural language parsing, progress aggregation, and performance metrics collection.

## Architecture

### Core Components

```javascript
class ProgressManager {
  constructor() {
    this.agents = new Map(); // agentId -> AgentProgress
    this.startTime = Date.now();
    this.updateInterval = null;
    this.performanceBaselines = this._loadBaselines();
  }
  
  // Register new agent with task assignment
  registerAgent(agentId, task, storyPoints = null) {
    this.agents.set(agentId, {
      id: agentId,
      type: this._extractAgentType(agentId),
      task: task,
      storyId: this._extractStoryId(task),
      status: 'initializing',
      progress: 0,
      startTime: Date.now(),
      lastUpdate: Date.now(),
      messages: [],
      storyPoints: storyPoints,
      estimatedCompletion: null,
      currentActivity: 'Starting...',
      metrics: {
        linesAnalyzed: 0,
        filesProcessed: 0,
        testsRun: 0,
        issuesFound: 0
      }
    });
    
    this._logAgentRegistration(agentId, task);
  }
  
  // Parse progress from natural language output
  parseProgress(agentId, output) {
    const agent = this.agents.get(agentId);
    if (!agent) return;
    
    // Store raw message
    agent.messages.push({
      timestamp: Date.now(),
      content: output
    });
    
    // Extract progress indicators
    this._parsePercentage(agent, output);
    this._parseStatus(agent, output);
    this._parseActivity(agent, output);
    this._parseMetrics(agent, output);
    this._checkCompletion(agent, output);
    
    agent.lastUpdate = Date.now();
    this._updateEstimates(agent);
  }
}
```

## Natural Language Parsing Patterns

### Progress Extraction Patterns

```javascript
const PROGRESS_PATTERNS = {
  // Percentage patterns
  percentage: {
    explicit: /\[(\d+)%\]/,                    // [75%]
    progress: /Progress:\s*(\d+)%/i,          // Progress: 50%
    complete: /(\d+)%\s*complete/i,           // 80% complete
    done: /(\d+)%\s*done/i,                   // 60% done
    finished: /(\d+)%\s*finished/i            // 90% finished
  },
  
  // Status patterns
  status: {
    explicit: /Status:\s*(.+)/i,              // Status: Running tests
    working: /(?:Working on|Implementing|Testing|Analyzing):\s*(.+)/i,
    current: /Currently\s+(.+ing)/i,          // Currently implementing
    now: /Now\s+(.+ing)/i                     // Now testing
  },
  
  // Activity patterns
  activity: {
    implementation: /implementing\s+(.+)/i,
    testing: /testing\s+(.+)/i,
    analyzing: /analyzing\s+(.+)/i,
    reviewing: /reviewing\s+(.+)/i,
    creating: /creating\s+(.+)/i,
    updating: /updating\s+(.+)/i,
    validating: /validating\s+(.+)/i
  },
  
  // Completion patterns
  completion: {
    done: /(?:✓|Done|Complete|Finished|Completed)(?:\s|$)/i,
    taskComplete: /(?:Story|Task|Implementation)\s+(?:complete|done|finished)/i,
    allDone: /All\s+(?:tests|tasks|items)\s+(?:passed|complete|done)/i
  }
};
```

### Progress Parsing Implementation

```javascript
class ProgressParser {
  _parsePercentage(agent, output) {
    // Try all percentage patterns
    for (const [key, pattern] of Object.entries(PROGRESS_PATTERNS.percentage)) {
      const match = output.match(pattern);
      if (match) {
        const percentage = parseInt(match[1]);
        if (percentage >= 0 && percentage <= 100) {
          agent.progress = percentage;
          return true;
        }
      }
    }
    
    // Estimate progress from activity keywords
    if (!agent.progress || agent.progress === 0) {
      agent.progress = this._estimateProgressFromActivity(output);
    }
    
    return false;
  }
  
  _estimateProgressFromActivity(output) {
    const keywords = {
      'starting': 5,
      'initializing': 10,
      'analyzing requirements': 15,
      'designing': 20,
      'implementing': 40,
      'coding': 45,
      'testing': 70,
      'reviewing': 85,
      'finalizing': 90,
      'completing': 95
    };
    
    const lowerOutput = output.toLowerCase();
    for (const [keyword, progress] of Object.entries(keywords)) {
      if (lowerOutput.includes(keyword)) {
        return progress;
      }
    }
    
    return 0;
  }
  
  _parseMetrics(agent, output) {
    // Extract numeric metrics from output
    const metricPatterns = {
      files: /(\d+)\s*files?\s*(?:processed|analyzed|reviewed)/i,
      lines: /(\d+)\s*lines?\s*(?:of code|analyzed|processed)/i,
      tests: /(\d+)\s*tests?\s*(?:passed|run|executed)/i,
      issues: /(\d+)\s*(?:issues?|problems?|errors?)\s*(?:found|detected)/i
    };
    
    for (const [metric, pattern] of Object.entries(metricPatterns)) {
      const match = output.match(pattern);
      if (match) {
        const value = parseInt(match[1]);
        switch(metric) {
          case 'files': agent.metrics.filesProcessed = value; break;
          case 'lines': agent.metrics.linesAnalyzed = value; break;
          case 'tests': agent.metrics.testsRun = value; break;
          case 'issues': agent.metrics.issuesFound = value; break;
        }
      }
    }
  }
}
```

## Progress Aggregation

### Overall Progress Calculation

```javascript
class ProgressAggregator {
  calculateOverallProgress(agents) {
    const activeAgents = Array.from(agents.values());
    if (activeAgents.length === 0) return 0;
    
    // Weight by story points if available
    const hasStoryPoints = activeAgents.some(a => a.storyPoints > 0);
    
    if (hasStoryPoints) {
      // Weighted average by story points
      let totalWeightedProgress = 0;
      let totalPoints = 0;
      
      activeAgents.forEach(agent => {
        const points = agent.storyPoints || 1;
        totalWeightedProgress += agent.progress * points;
        totalPoints += points;
      });
      
      return Math.round(totalWeightedProgress / totalPoints);
    } else {
      // Simple average
      const totalProgress = activeAgents.reduce((sum, agent) => sum + agent.progress, 0);
      return Math.round(totalProgress / activeAgents.length);
    }
  }
  
  identifyBottlenecks(agents) {
    const activeAgents = Array.from(agents.values())
      .filter(a => a.status !== 'completed');
    
    if (activeAgents.length === 0) return [];
    
    // Calculate average progress
    const avgProgress = this.calculateOverallProgress(agents);
    
    // Find agents significantly behind
    const bottlenecks = activeAgents
      .filter(agent => agent.progress < (avgProgress - 20))
      .map(agent => ({
        agentId: agent.id,
        task: agent.task,
        progress: agent.progress,
        behindBy: avgProgress - agent.progress,
        timeSinceUpdate: Date.now() - agent.lastUpdate,
        recommendation: this._generateRecommendation(agent, avgProgress)
      }));
    
    return bottlenecks.sort((a, b) => b.behindBy - a.behindBy);
  }
}
```

## Performance Metrics Collection

### Metrics Tracking

```javascript
class MetricsCollector {
  constructor() {
    this.executionMetrics = {
      startTime: Date.now(),
      agentMetrics: new Map(),
      overallMetrics: {
        totalAgents: 0,
        completedAgents: 0,
        failedAgents: 0,
        averageCompletionTime: 0,
        parallelismAchieved: 0,
        performanceGain: 0
      }
    };
  }
  
  recordAgentCompletion(agent) {
    const duration = Date.now() - agent.startTime;
    
    this.agentMetrics.set(agent.id, {
      duration: duration,
      task: agent.task,
      progress: agent.progress,
      status: agent.status,
      metrics: agent.metrics,
      efficiency: this._calculateEfficiency(agent)
    });
    
    this._updateOverallMetrics();
    this._calculatePerformanceGain();
  }
  
  _calculatePerformanceGain() {
    const actualTime = Date.now() - this.executionMetrics.startTime;
    const estimatedSequentialTime = this._estimateSequentialTime();
    
    if (estimatedSequentialTime > 0) {
      this.executionMetrics.overallMetrics.performanceGain = 
        (estimatedSequentialTime / actualTime).toFixed(1);
    }
  }
  
  generateMetricsReport() {
    const metrics = this.executionMetrics.overallMetrics;
    const duration = Date.now() - this.executionMetrics.startTime;
    
    return {
      summary: {
        totalExecutionTime: this._formatDuration(duration),
        agentsDeployed: metrics.totalAgents,
        successRate: `${(metrics.completedAgents / metrics.totalAgents * 100).toFixed(1)}%`,
        performanceGain: `${metrics.performanceGain}x`,
        parallelismEfficiency: `${(metrics.parallelismAchieved * 100).toFixed(1)}%`
      },
      agentDetails: Array.from(this.agentMetrics.entries()).map(([id, data]) => ({
        agent: id,
        duration: this._formatDuration(data.duration),
        status: data.status,
        efficiency: `${(data.efficiency * 100).toFixed(1)}%`
      }))
    };
  }
}
```

## Time Estimation

### Completion Time Prediction

```javascript
class TimeEstimator {
  updateEstimates(agent) {
    if (agent.progress === 0 || agent.progress === 100) {
      agent.estimatedCompletion = null;
      return;
    }
    
    const elapsed = Date.now() - agent.startTime;
    const progressRate = agent.progress / elapsed; // % per millisecond
    
    if (progressRate > 0) {
      const remainingProgress = 100 - agent.progress;
      const estimatedRemaining = remainingProgress / progressRate;
      
      agent.estimatedCompletion = Date.now() + estimatedRemaining;
      agent.estimatedRemainingTime = this._formatDuration(estimatedRemaining);
    }
  }
  
  calculateOverallEstimate(agents) {
    const activeAgents = Array.from(agents.values())
      .filter(a => a.status !== 'completed' && a.estimatedCompletion);
    
    if (activeAgents.length === 0) return null;
    
    // Latest completion time among all agents
    const latestCompletion = Math.max(...activeAgents.map(a => a.estimatedCompletion));
    
    return {
      estimatedCompletion: new Date(latestCompletion),
      remainingTime: this._formatDuration(latestCompletion - Date.now()),
      confidence: this._calculateConfidence(activeAgents)
    };
  }
}
```

## Integration Points

### Event Emission

```javascript
class ProgressEventEmitter {
  constructor(progressManager) {
    this.progressManager = progressManager;
    this.listeners = new Map();
  }
  
  // Emit progress update events
  emitProgressUpdate(agentId) {
    const agent = this.progressManager.agents.get(agentId);
    if (!agent) return;
    
    this.emit('agent:progress', {
      agentId: agentId,
      progress: agent.progress,
      status: agent.status,
      activity: agent.currentActivity
    });
    
    // Check for milestones
    if (agent.progress === 25 || agent.progress === 50 || 
        agent.progress === 75 || agent.progress === 100) {
      this.emit('agent:milestone', {
        agentId: agentId,
        milestone: agent.progress,
        task: agent.task
      });
    }
  }
  
  // Emit aggregate events
  emitAggregateUpdate() {
    const overall = this.progressManager.calculateOverallProgress();
    
    this.emit('progress:overall', {
      progress: overall,
      activeAgents: this.progressManager.getActiveCount(),
      completedAgents: this.progressManager.getCompletedCount(),
      bottlenecks: this.progressManager.identifyBottlenecks()
    });
  }
}
```

## Error Handling

### Progress Anomaly Detection

```javascript
class ProgressAnomalyDetector {
  detectAnomalies(agent) {
    const anomalies = [];
    
    // Stalled progress
    if (this._isStalled(agent)) {
      anomalies.push({
        type: 'stalled',
        severity: 'warning',
        message: `Agent ${agent.id} has not updated progress for ${this._getTimeSinceUpdate(agent)}`,
        recommendation: 'Check agent status and logs'
      });
    }
    
    // Rapid completion
    if (this._isTooFast(agent)) {
      anomalies.push({
        type: 'rapid_completion',
        severity: 'info',
        message: `Agent ${agent.id} completed unusually quickly`,
        recommendation: 'Verify output quality'
      });
    }
    
    // Progress regression
    if (this._hasRegressed(agent)) {
      anomalies.push({
        type: 'regression',
        severity: 'error',
        message: `Agent ${agent.id} progress decreased`,
        recommendation: 'Investigate agent state'
      });
    }
    
    return anomalies;
  }
}
```

## Usage Example

```javascript
// Initialize progress manager
const progressManager = new ProgressManager();

// Register agents for parallel sprint
progressManager.registerAgent('Developer-1', 'Story 17.2: Context Passing', 5);
progressManager.registerAgent('Developer-2', 'Story 17.3: Progress Monitoring', 5);
progressManager.registerAgent('QA-Agent', 'Test Strategy Development', 3);
progressManager.registerAgent('Architect', 'Integration Review', 2);

// Parse agent outputs
progressManager.parseProgress('Developer-1', 
  'Developer Agent 1: Starting implementation of Story 17.2\nProgress: Analyzing requirements... [10%]');

progressManager.parseProgress('Developer-1', 
  'Developer Agent 1: Context templates created\nProgress: Implementing extraction logic... [45%]');

// Get overall progress
const overall = progressManager.calculateOverallProgress();
console.log(`Overall Progress: ${overall}%`);

// Check for bottlenecks
const bottlenecks = progressManager.identifyBottlenecks();
bottlenecks.forEach(b => {
  console.log(`Bottleneck: ${b.agentId} - ${b.behindBy}% behind average`);
});
```

---

The Progress Manager provides comprehensive real-time monitoring of sub-agent execution with natural language parsing, intelligent progress estimation, and performance metrics collection.