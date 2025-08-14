#!/usr/bin/env node

/**
 * Test Plan Updater
 * Updates test plan markdown files with execution results
 */

const fs = require('fs').promises;
const path = require('path');

class TestPlanUpdater {
  /**
   * Update test plan with execution results
   * @param {string} planPath - Path to the test plan markdown file
   * @param {Object} results - Execution results object
   */
  static async update(planPath, results) {
    try {
      // Read current content
      let content = await fs.readFile(planPath, 'utf-8');
      
      // Update last run timestamp
      content = this.updateLastRun(content);
      
      // Update status
      content = this.updateStatus(content, 'completed');
      
      // Update agent results
      content = this.updateAgentResults(content, results.agents);
      
      // Add to execution history
      content = this.addHistoryEntry(content, results);
      
      // Update performance metrics
      content = this.updateMetrics(content, results);
      
      // Write updated content
      await fs.writeFile(planPath, content);
      
      console.log(`✅ Test plan updated: ${planPath}`);
    } catch (error) {
      console.error('Error updating test plan:', error);
      throw error;
    }
  }
  
  /**
   * Update last run timestamp
   */
  static updateLastRun(content) {
    const timestamp = new Date().toISOString();
    return content.replace(
      /Last Run: .*/,
      `Last Run: ${timestamp}`
    );
  }
  
  /**
   * Update plan status
   */
  static updateStatus(content, status) {
    return content.replace(
      /Status: .*/,
      `Status: ${status}`
    );
  }
  
  /**
   * Update individual agent results
   */
  static updateAgentResults(content, agents) {
    agents.forEach(agent => {
      // Update status
      const statusRegex = new RegExp(
        `(- \\*\\*id\\*\\*: ${agent.id}[\\s\\S]*?- \\*\\*status\\*\\*:) [^\\n]+`,
        'g'
      );
      content = content.replace(statusRegex, `$1 ${agent.status}`);
      
      // Update last result
      const resultRegex = new RegExp(
        `(- \\*\\*id\\*\\*: ${agent.id}[\\s\\S]*?- \\*\\*last_result\\*\\*:) [^\\n]+`,
        'g'
      );
      content = content.replace(resultRegex, `$1 ${agent.status}`);
      
      // Update last duration
      const durationRegex = new RegExp(
        `(- \\*\\*id\\*\\*: ${agent.id}[\\s\\S]*?- \\*\\*last_duration\\*\\*:) [^\\n]+`,
        'g'
      );
      const duration = agent.duration ? `${agent.duration}s` : '-';
      content = content.replace(durationRegex, `$1 ${duration}`);
    });
    
    return content;
  }
  
  /**
   * Add entry to execution history table
   */
  static addHistoryEntry(content, results) {
    const historyEntry = this.formatHistoryEntry(results);
    
    // Find the history table
    const historyTableRegex = /(## Execution History[\s\S]*?\|[^\n]+\|[^\n]+\|[^\n]+\|[^\n]+\|[^\n]+\|[^\n]+\|[^\n]+\|\n)(\|[\s\S]*?)(?=\n##|\n\*|$)/;
    
    const match = content.match(historyTableRegex);
    if (match) {
      const tableHeader = match[1];
      const existingRows = match[2];
      
      // Add new entry after header
      const updatedTable = tableHeader + historyEntry + '\n' + existingRows;
      content = content.replace(match[0], updatedTable);
    }
    
    return content;
  }
  
  /**
   * Format history entry as markdown table row
   */
  static formatHistoryEntry(results) {
    const duration = this.formatDuration(results.duration);
    const notes = this.generateNotes(results);
    
    return `| ${results.runId} | ${results.startTime} | ${results.endTime} | ${duration} | ${results.pass} | ${results.fail} | ${results.skip} | ${notes} |`;
  }
  
  /**
   * Format duration in human-readable format
   */
  static formatDuration(seconds) {
    if (seconds < 60) {
      return `${seconds}s`;
    }
    
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    
    if (minutes < 60) {
      return `${minutes}m ${remainingSeconds}s`;
    }
    
    const hours = Math.floor(minutes / 60);
    const remainingMinutes = minutes % 60;
    
    return `${hours}h ${remainingMinutes}m`;
  }
  
  /**
   * Generate notes based on results
   */
  static generateNotes(results) {
    const notes = [];
    
    if (results.fail > 0) {
      notes.push(`${results.fail} failures`);
    }
    
    if (results.skip > 0) {
      notes.push(`${results.skip} skipped`);
    }
    
    const successRate = Math.round((results.pass / (results.pass + results.fail)) * 100);
    if (successRate < 95) {
      notes.push(`Success rate: ${successRate}%`);
    }
    
    return notes.join(', ') || 'All tests passed';
  }
  
  /**
   * Update performance metrics section
   */
  static updateMetrics(content, results) {
    // Calculate metrics from history
    const historyRegex = /\| (run-[^\|]+) \| [^\|]+ \| [^\|]+ \| ([^\|]+) \| (\d+) \| (\d+) \| (\d+) \|/g;
    const runs = [];
    let match;
    
    while ((match = historyRegex.exec(content)) !== null) {
      runs.push({
        runId: match[1],
        duration: match[2],
        pass: parseInt(match[3]),
        fail: parseInt(match[4]),
        skip: parseInt(match[5])
      });
    }
    
    // Add current run
    runs.push({
      runId: results.runId,
      duration: this.formatDuration(results.duration),
      pass: results.pass,
      fail: results.fail,
      skip: results.skip
    });
    
    // Calculate average execution time
    const avgDuration = this.calculateAverageDuration(runs);
    content = content.replace(
      /- \*\*Average Execution Time\*\*: .*/,
      `- **Average Execution Time**: ${avgDuration}`
    );
    
    // Calculate success rate
    const successRate = this.calculateSuccessRate(runs);
    content = content.replace(
      /- \*\*Success Rate\*\*: .*/,
      `- **Success Rate**: ${successRate}%`
    );
    
    // Identify flaky tests
    const flakyTests = this.identifyFlakyTests(results.agents, content);
    content = content.replace(
      /- \*\*Flaky Tests\*\*: .*/,
      `- **Flaky Tests**: [${flakyTests.join(', ')}]`
    );
    
    return content;
  }
  
  /**
   * Calculate average duration from runs
   */
  static calculateAverageDuration(runs) {
    if (runs.length === 0) return '-';
    
    const totalSeconds = runs.reduce((sum, run) => {
      const seconds = this.parseDuration(run.duration);
      return sum + seconds;
    }, 0);
    
    const avgSeconds = Math.round(totalSeconds / runs.length);
    return this.formatDuration(avgSeconds);
  }
  
  /**
   * Parse duration string to seconds
   */
  static parseDuration(durationStr) {
    const patterns = [
      { regex: /(\d+)s/, multiplier: 1 },
      { regex: /(\d+)m\s*(\d+)?s?/, multiplier: 60 },
      { regex: /(\d+)h\s*(\d+)?m?/, multiplier: 3600 }
    ];
    
    for (const pattern of patterns) {
      const match = durationStr.match(pattern.regex);
      if (match) {
        const primary = parseInt(match[1]) * pattern.multiplier;
        const secondary = match[2] ? parseInt(match[2]) : 0;
        return primary + secondary;
      }
    }
    
    return 0;
  }
  
  /**
   * Calculate overall success rate
   */
  static calculateSuccessRate(runs) {
    const totals = runs.reduce((acc, run) => {
      acc.pass += run.pass;
      acc.fail += run.fail;
      return acc;
    }, { pass: 0, fail: 0 });
    
    if (totals.pass + totals.fail === 0) return 100;
    
    return Math.round((totals.pass / (totals.pass + totals.fail)) * 100);
  }
  
  /**
   * Identify flaky tests based on inconsistent results
   */
  static identifyFlakyTests(agents, content) {
    // This would need more sophisticated logic with historical data
    // For now, just identify tests that failed in this run
    return agents
      .filter(agent => agent.status === 'fail')
      .map(agent => agent.id);
  }
}

// CLI interface
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.length < 2) {
    console.log('Usage: test-plan-updater.js <test-plan.md> <results.json>');
    process.exit(1);
  }
  
  const planPath = args[0];
  const resultsPath = args[1];
  
  fs.readFile(resultsPath, 'utf-8')
    .then(data => JSON.parse(data))
    .then(results => TestPlanUpdater.update(planPath, results))
    .then(() => {
      console.log('Test plan updated successfully');
      process.exit(0);
    })
    .catch(error => {
      console.error('Error:', error.message);
      process.exit(1);
    });
}

module.exports = TestPlanUpdater;