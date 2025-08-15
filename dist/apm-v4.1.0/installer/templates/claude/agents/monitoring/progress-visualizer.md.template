# Progress Visualizer - Real-Time Display Engine

> **Display Component**: Beautiful, real-time progress visualization for parallel sub-agent execution

## Overview

The Progress Visualizer transforms raw progress data into clear, informative displays that show real-time status of multiple sub-agents executing in parallel. It provides both terminal-based and markdown-formatted output.

## Core Visualization Engine

### Base Visualizer Class

```javascript
class ProgressVisualizer {
  constructor(options = {}) {
    this.options = {
      width: options.width || 50,
      showMetrics: options.showMetrics !== false,
      showEstimates: options.showEstimates !== false,
      updateInterval: options.updateInterval || 500,
      theme: options.theme || 'default'
    };
    
    this.themes = this._loadThemes();
    this.lastRender = '';
  }
  
  // Generate complete progress display
  renderProgress(progressManager) {
    const agents = Array.from(progressManager.agents.values());
    const activeCount = agents.filter(a => a.status !== 'completed').length;
    const completedCount = agents.filter(a => a.status === 'completed').length;
    
    let output = this._renderHeader(activeCount, completedCount, agents.length);
    output += this._renderSeparator();
    output += '\n';
    
    // Individual agent progress
    agents.forEach(agent => {
      output += this._renderAgentProgress(agent);
      output += '\n';
    });
    
    // Overall statistics
    output += this._renderOverallStats(progressManager);
    
    // Performance comparison
    if (this.options.showMetrics) {
      output += this._renderPerformanceMetrics(progressManager);
    }
    
    this.lastRender = output;
    return output;
  }
}
```

## Progress Bar Components

### Visual Progress Bar Creation

```javascript
class ProgressBarRenderer {
  // Create beautiful progress bars
  createProgressBar(percentage, width = 20, style = 'default') {
    const styles = {
      default: { filled: '█', empty: '░', cap: '' },
      detailed: { filled: '▓', empty: '░', cap: '▏' },
      smooth: { filled: '━', empty: '─', cap: '╸' },
      blocks: { filled: '■', empty: '□', cap: '' },
      dots: { filled: '●', empty: '○', cap: '' }
    };
    
    const chars = styles[style] || styles.default;
    const filled = Math.floor(width * percentage / 100);
    const empty = width - filled;
    
    let bar = chars.filled.repeat(filled);
    
    // Add partial fill for smooth appearance
    if (percentage % (100/width) !== 0 && empty > 0 && chars.cap) {
      bar += chars.cap;
      empty--;
    }
    
    bar += chars.empty.repeat(Math.max(0, empty));
    
    return bar;
  }
  
  // Create gradient progress bar (for color terminals)
  createGradientBar(percentage, width = 20) {
    const colors = {
      0: '\x1b[31m',    // Red
      25: '\x1b[33m',   // Yellow
      50: '\x1b[93m',   // Bright Yellow
      75: '\x1b[32m',   // Green
      90: '\x1b[92m'    // Bright Green
    };
    
    let color = '\x1b[31m'; // Default red
    for (const [threshold, col] of Object.entries(colors)) {
      if (percentage >= parseInt(threshold)) {
        color = col;
      }
    }
    
    const bar = this.createProgressBar(percentage, width);
    return `${color}${bar}\x1b[0m`; // Reset color at end
  }
}
```

## Display Formatting

### Header and Layout

```javascript
class DisplayFormatter {
  _renderHeader(active, completed, total) {
    const icon = active > 0 ? '🚀' : '✅';
    const status = active > 0 ? 
      `${active} agents active, ${completed} completed` : 
      'All agents completed';
    
    return `${icon} Parallel Execution (${total} agents total) - ${status}\n`;
  }
  
  _renderSeparator(char = '━', width = 60) {
    return char.repeat(width) + '\n';
  }
  
  _renderAgentProgress(agent) {
    const statusIcon = this._getStatusIcon(agent.status);
    const bar = this.createProgressBar(agent.progress, 20);
    const elapsed = this._formatElapsed(agent.startTime);
    const percentage = `${agent.progress}%`;
    
    // Main progress line
    let output = `${statusIcon} [${agent.id}] ${agent.task}\n`;
    output += `  ${bar} ${percentage.padStart(4)} (${elapsed} elapsed)`;
    
    // Add completion checkmark
    if (agent.status === 'completed') {
      output += ' ✓';
    }
    
    output += '\n';
    
    // Current activity
    if (agent.currentActivity && agent.status !== 'completed') {
      output += `  ↳ ${agent.currentActivity}...\n`;
    }
    
    // Estimated completion
    if (agent.estimatedRemainingTime && this.options.showEstimates) {
      output += `  ⏱️  Est. ${agent.estimatedRemainingTime} remaining\n`;
    }
    
    // Metrics summary
    if (this.options.showMetrics && Object.values(agent.metrics).some(v => v > 0)) {
      output += this._renderAgentMetrics(agent.metrics);
    }
    
    return output;
  }
  
  _getStatusIcon(status) {
    const icons = {
      'initializing': '🔄',
      'in_progress': '⚡',
      'completed': '✅',
      'failed': '❌',
      'paused': '⏸️',
      'blocked': '🚧'
    };
    
    return icons[status] || '●';
  }
}
```

## Real-Time Updates

### Streaming Display Manager

```javascript
class StreamingDisplayManager {
  constructor(visualizer, progressManager) {
    this.visualizer = visualizer;
    this.progressManager = progressManager;
    this.updateInterval = null;
    this.displayBuffer = [];
  }
  
  // Start real-time display updates
  startStreaming(outputCallback) {
    this.updateInterval = setInterval(() => {
      const display = this.visualizer.renderProgress(this.progressManager);
      
      // Only update if changed (reduce flicker)
      if (display !== this.visualizer.lastRender) {
        outputCallback(display);
      }
    }, this.visualizer.options.updateInterval);
  }
  
  // Buffer updates for smooth rendering
  bufferUpdate(agentId, update) {
    this.displayBuffer.push({
      timestamp: Date.now(),
      agentId: agentId,
      update: update
    });
    
    // Process buffer if getting full
    if (this.displayBuffer.length > 10) {
      this.flushBuffer();
    }
  }
  
  flushBuffer() {
    // Group updates by agent
    const groupedUpdates = this.displayBuffer.reduce((acc, update) => {
      if (!acc[update.agentId]) {
        acc[update.agentId] = [];
      }
      acc[update.agentId].push(update);
      return acc;
    }, {});
    
    // Apply updates
    Object.entries(groupedUpdates).forEach(([agentId, updates]) => {
      const latestUpdate = updates[updates.length - 1];
      this.progressManager.parseProgress(agentId, latestUpdate.update);
    });
    
    this.displayBuffer = [];
  }
}
```

## Advanced Visualizations

### Overall Statistics Display

```javascript
class StatsVisualizer {
  _renderOverallStats(progressManager) {
    const overall = progressManager.calculateOverallProgress();
    const estimate = progressManager.calculateOverallEstimate();
    const bottlenecks = progressManager.identifyBottlenecks();
    
    let output = '\n' + this._renderSeparator('─', 60) + '\n';
    
    // Overall progress
    const overallBar = this.createProgressBar(overall, 30, 'detailed');
    output += `Overall Progress: ${overallBar} ${overall}%\n`;
    
    // Time estimate
    if (estimate) {
      output += `Estimated Completion: ${estimate.remainingTime} remaining`;
      output += ` (${this._formatConfidence(estimate.confidence)} confidence)\n`;
    }
    
    // Bottlenecks
    if (bottlenecks.length > 0) {
      output += '\n⚠️  Bottlenecks Detected:\n';
      bottlenecks.forEach(b => {
        output += `   - ${b.agentId}: ${b.progress}% (${b.behindBy}% behind average)\n`;
      });
    }
    
    return output;
  }
  
  _renderPerformanceMetrics(progressManager) {
    const metrics = progressManager.getMetricsCollector().generateMetricsReport();
    
    let output = '\n' + this._renderSeparator('─', 60) + '\n';
    output += '📊 Performance Metrics:\n';
    
    // Summary metrics
    output += `   Execution Time: ${metrics.summary.totalExecutionTime}\n`;
    output += `   Performance Gain: ${metrics.summary.performanceGain} faster than sequential\n`;
    output += `   Success Rate: ${metrics.summary.successRate}\n`;
    output += `   Parallelism Efficiency: ${metrics.summary.parallelismEfficiency}\n`;
    
    return output;
  }
}
```

## Specialized Display Formats

### Compact Display Mode

```javascript
class CompactVisualizer extends ProgressVisualizer {
  renderCompact(progressManager) {
    const agents = Array.from(progressManager.agents.values());
    const overall = progressManager.calculateOverallProgress();
    
    // Single line per agent
    let output = agents.map(agent => {
      const bar = this.createProgressBar(agent.progress, 10);
      const status = agent.status === 'completed' ? '✓' : '●';
      return `${status} ${agent.id}: ${bar} ${agent.progress}%`;
    }).join(' | ');
    
    output += ` | Overall: ${overall}%`;
    
    return output;
  }
}
```

### Sprint Overview Display

```javascript
class SprintProgressVisualizer extends ProgressVisualizer {
  renderSprintOverview(progressManager) {
    const agents = Array.from(progressManager.agents.values());
    
    // Group by story
    const storiesMap = new Map();
    agents.forEach(agent => {
      const storyId = agent.storyId || 'Other Tasks';
      if (!storiesMap.has(storyId)) {
        storiesMap.set(storyId, []);
      }
      storiesMap.get(storyId).push(agent);
    });
    
    let output = '📋 Sprint Progress Overview\n';
    output += this._renderSeparator('═', 60) + '\n\n';
    
    // Render by story
    storiesMap.forEach((storyAgents, storyId) => {
      const storyProgress = this._calculateStoryProgress(storyAgents);
      const storyBar = this.createProgressBar(storyProgress, 25);
      
      output += `📌 ${storyId}: ${storyBar} ${storyProgress}%\n`;
      
      storyAgents.forEach(agent => {
        const agentBar = this.createProgressBar(agent.progress, 15);
        output += `   └─ ${agent.type}: ${agentBar} ${agent.progress}%\n`;
      });
      
      output += '\n';
    });
    
    return output;
  }
}
```

## Terminal Animation Effects

### Animated Progress Indicators

```javascript
class AnimatedIndicators {
  constructor() {
    this.spinners = {
      dots: ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'],
      line: ['|', '/', '-', '\\'],
      circle: ['◐', '◓', '◑', '◒'],
      arrows: ['←', '↖', '↑', '↗', '→', '↘', '↓', '↙']
    };
    
    this.frameIndex = 0;
  }
  
  getSpinner(style = 'dots') {
    const frames = this.spinners[style] || this.spinners.dots;
    const frame = frames[this.frameIndex % frames.length];
    this.frameIndex++;
    return frame;
  }
  
  renderAnimatedProgress(agent) {
    if (agent.status === 'completed') {
      return '✓';
    }
    
    const spinner = this.getSpinner();
    const bar = this.createProgressBar(agent.progress, 15);
    
    return `${spinner} ${bar} ${agent.progress}%`;
  }
}
```

## Markdown Export

### Generate Markdown Report

```javascript
class MarkdownExporter {
  exportToMarkdown(progressManager, includeHistory = false) {
    const timestamp = new Date().toISOString();
    const agents = Array.from(progressManager.agents.values());
    const metrics = progressManager.getMetricsCollector().generateMetricsReport();
    
    let markdown = `# Parallel Execution Progress Report\n\n`;
    markdown += `**Generated**: ${timestamp}\n\n`;
    
    // Executive Summary
    markdown += `## Executive Summary\n\n`;
    markdown += `- **Total Agents**: ${agents.length}\n`;
    markdown += `- **Completed**: ${agents.filter(a => a.status === 'completed').length}\n`;
    markdown += `- **Success Rate**: ${metrics.summary.successRate}\n`;
    markdown += `- **Performance Gain**: ${metrics.summary.performanceGain}\n\n`;
    
    // Agent Details
    markdown += `## Agent Progress Details\n\n`;
    agents.forEach(agent => {
      markdown += `### ${agent.id}\n\n`;
      markdown += `- **Task**: ${agent.task}\n`;
      markdown += `- **Progress**: ${agent.progress}%\n`;
      markdown += `- **Status**: ${agent.status}\n`;
      markdown += `- **Duration**: ${this._formatElapsed(agent.startTime)}\n`;
      
      if (agent.metrics && Object.values(agent.metrics).some(v => v > 0)) {
        markdown += `- **Metrics**:\n`;
        Object.entries(agent.metrics).forEach(([key, value]) => {
          if (value > 0) {
            markdown += `  - ${key}: ${value}\n`;
          }
        });
      }
      
      markdown += '\n';
    });
    
    // Include message history if requested
    if (includeHistory) {
      markdown += `## Execution History\n\n`;
      agents.forEach(agent => {
        if (agent.messages.length > 0) {
          markdown += `### ${agent.id} Messages\n\n`;
          agent.messages.forEach(msg => {
            const time = new Date(msg.timestamp).toLocaleTimeString();
            markdown += `- **[${time}]** ${msg.content}\n`;
          });
          markdown += '\n';
        }
      });
    }
    
    return markdown;
  }
}
```

## Theme Support

### Customizable Themes

```javascript
class ThemeManager {
  getTheme(themeName) {
    const themes = {
      default: {
        colors: {
          header: '\x1b[1m',      // Bold
          success: '\x1b[32m',    // Green
          warning: '\x1b[33m',    // Yellow
          error: '\x1b[31m',      // Red
          info: '\x1b[36m',       // Cyan
          reset: '\x1b[0m'
        },
        icons: {
          active: '🚀',
          complete: '✅',
          failed: '❌',
          warning: '⚠️'
        }
      },
      
      minimal: {
        colors: {
          header: '',
          success: '',
          warning: '',
          error: '',
          info: '',
          reset: ''
        },
        icons: {
          active: '[ACTIVE]',
          complete: '[DONE]',
          failed: '[FAIL]',
          warning: '[WARN]'
        }
      },
      
      professional: {
        colors: {
          header: '\x1b[1;34m',   // Bold Blue
          success: '\x1b[32m',    // Green
          warning: '\x1b[33m',    // Yellow
          error: '\x1b[31m',      // Red
          info: '\x1b[90m',       // Gray
          reset: '\x1b[0m'
        },
        icons: {
          active: '►',
          complete: '✓',
          failed: '✗',
          warning: '!'
        }
      }
    };
    
    return themes[themeName] || themes.default;
  }
}
```

## Usage Examples

```javascript
// Initialize visualizer with options
const visualizer = new ProgressVisualizer({
  width: 60,
  showMetrics: true,
  showEstimates: true,
  theme: 'professional'
});

// Render progress display
const display = visualizer.renderProgress(progressManager);
console.log(display);

// Start streaming updates
const streamManager = new StreamingDisplayManager(visualizer, progressManager);
streamManager.startStreaming(display => {
  console.clear();
  console.log(display);
});

// Export to markdown
const exporter = new MarkdownExporter();
const report = exporter.exportToMarkdown(progressManager, true);
fs.writeFileSync('progress-report.md', report);
```

---

The Progress Visualizer provides beautiful, informative displays of parallel sub-agent execution with support for real-time updates, multiple display formats, and customizable themes.