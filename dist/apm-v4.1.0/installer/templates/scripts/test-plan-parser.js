#!/usr/bin/env node

/**
 * Test Plan Parser
 * Parses markdown test plan files and converts them to orchestrator format
 */

const fs = require('fs').promises;
const path = require('path');

class TestPlanParser {
  /**
   * Parse a markdown test plan file
   * @param {string} content - The markdown content
   * @returns {Object} Parsed test plan object
   */
  static parse(content) {
    const lines = content.split('\n');
    
    // Extract metadata
    const metadata = this.extractMetadata(lines);
    
    // Extract configuration
    const config = this.extractConfig(lines);
    
    // Extract agent definitions
    const agents = this.extractAgents(content);
    
    // Extract execution history
    const history = this.extractHistory(lines);
    
    return {
      lastUpdated: metadata.lastUpdated,
      lastRun: metadata.lastRun,
      status: metadata.status,
      totalAgents: config.totalAgents,
      parallelLimit: config.parallelLimit,
      timeout: config.timeout,
      agents: agents,
      history: history
    };
  }
  
  /**
   * Extract metadata from the header
   */
  static extractMetadata(lines) {
    const metadata = {};
    
    for (const line of lines) {
      if (line.startsWith('Last Updated:')) {
        metadata.lastUpdated = line.split(':', 2)[1].trim();
      } else if (line.startsWith('Last Run:')) {
        metadata.lastRun = line.split(':', 2)[1].trim();
      } else if (line.startsWith('Status:')) {
        metadata.status = line.split(':', 2)[1].trim();
      }
    }
    
    return metadata;
  }
  
  /**
   * Extract test configuration
   */
  static extractConfig(lines) {
    const config = {};
    
    for (const line of lines) {
      if (line.startsWith('Total Agents:')) {
        config.totalAgents = parseInt(line.split(':', 2)[1].trim());
      } else if (line.startsWith('Parallel Limit:')) {
        config.parallelLimit = parseInt(line.split(':', 2)[1].trim());
      } else if (line.startsWith('Timeout:')) {
        const timeout = line.split(':', 2)[1].trim();
        config.timeout = this.parseTimeout(timeout);
      }
    }
    
    return config;
  }
  
  /**
   * Extract agent definitions
   */
  static extractAgents(content) {
    const agents = [];
    const agentRegex = /### Agent \d+: (.+)\n([\s\S]*?)(?=###|## Execution History)/g;
    
    let match;
    while ((match = agentRegex.exec(content)) !== null) {
      const title = match[1];
      const body = match[2];
      
      const agent = this.parseAgent(title, body);
      if (agent) {
        agents.push(agent);
      }
    }
    
    return agents;
  }
  
  /**
   * Parse individual agent definition
   */
  static parseAgent(title, body) {
    const agent = { title };
    const lines = body.split('\n').map(l => l.trim()).filter(l => l);
    
    let currentEnv = [];
    let inEnvironment = false;
    
    for (const line of lines) {
      if (line.startsWith('- **id**:')) {
        agent.id = this.extractValue(line);
      } else if (line.startsWith('- **type**:')) {
        agent.type = this.extractValue(line);
      } else if (line.startsWith('- **command**:')) {
        agent.command = this.extractValue(line);
      } else if (line.startsWith('- **timeout**:')) {
        agent.timeout = this.extractValue(line);
      } else if (line.startsWith('- **dependencies**:')) {
        agent.dependencies = this.extractArray(line);
      } else if (line.startsWith('- **environment**:')) {
        inEnvironment = true;
      } else if (line.startsWith('- **status**:')) {
        inEnvironment = false;
        agent.status = this.extractValue(line);
      } else if (line.startsWith('- **last_result**:')) {
        agent.lastResult = this.extractValue(line);
      } else if (line.startsWith('- **last_duration**:')) {
        agent.lastDuration = this.extractValue(line);
      } else if (inEnvironment && line.startsWith('-')) {
        // Parse environment variable
        const envMatch = line.match(/- ([^:]+):\s*(.+)/);
        if (envMatch) {
          currentEnv.push({
            key: envMatch[1],
            value: envMatch[2]
          });
        }
      }
    }
    
    if (currentEnv.length > 0) {
      agent.environment = currentEnv;
    }
    
    return agent;
  }
  
  /**
   * Extract value from a markdown property line
   */
  static extractValue(line) {
    const match = line.match(/\*\*[^*]+\*\*:\s*(.+)/);
    return match ? match[1].trim() : '';
  }
  
  /**
   * Extract array from a markdown property line
   */
  static extractArray(line) {
    const match = line.match(/\*\*[^*]+\*\*:\s*\[(.*)\]/);
    if (!match) return [];
    
    const content = match[1];
    if (!content) return [];
    
    return content.split(',').map(item => {
      return item.trim().replace(/^["']|["']$/g, '');
    });
  }
  
  /**
   * Parse timeout string to seconds
   */
  static parseTimeout(timeoutStr) {
    const match = timeoutStr.match(/(\d+)\s*(m|min|minutes?|s|sec|seconds?)/i);
    if (!match) return 300; // Default 5 minutes
    
    const value = parseInt(match[1]);
    const unit = match[2].toLowerCase();
    
    if (unit.startsWith('m')) {
      return value * 60;
    } else if (unit.startsWith('s')) {
      return value;
    }
    
    return value * 60; // Default to minutes
  }
  
  /**
   * Extract execution history
   */
  static extractHistory(lines) {
    const history = [];
    let inHistoryTable = false;
    let skipHeader = true;
    
    for (const line of lines) {
      if (line.includes('| Run ID | Start Time |')) {
        inHistoryTable = true;
        continue;
      } else if (inHistoryTable && line.startsWith('|---')) {
        skipHeader = false;
        continue;
      } else if (inHistoryTable && line.startsWith('|') && !skipHeader) {
        const cells = line.split('|').map(c => c.trim()).filter(c => c);
        if (cells.length >= 7) {
          history.push({
            runId: cells[0],
            startTime: cells[1],
            endTime: cells[2],
            duration: cells[3],
            pass: parseInt(cells[4]) || 0,
            fail: parseInt(cells[5]) || 0,
            skip: parseInt(cells[6]) || 0,
            notes: cells[7] || ''
          });
        }
      } else if (inHistoryTable && !line.startsWith('|')) {
        break;
      }
    }
    
    return history;
  }
  
  /**
   * Convert parsed plan to orchestrator format
   */
  static toOrchestratorFormat(testPlan) {
    return testPlan.agents.map(agent => ({
      id: agent.id,
      command: agent.command,
      timeout: agent.timeout,
      env: agent.environment ? agent.environment.reduce((acc, env) => {
        acc[env.key] = env.value;
        return acc;
      }, {}) : {},
      dependencies: agent.dependencies || []
    }));
  }
  
  /**
   * Generate orchestrator JSON from test plan
   */
  static async generateOrchestratorInput(planPath) {
    try {
      const content = await fs.readFile(planPath, 'utf-8');
      const testPlan = this.parse(content);
      const orchestratorFormat = this.toOrchestratorFormat(testPlan);
      
      return {
        agents: orchestratorFormat,
        config: {
          maxParallel: testPlan.parallelLimit,
          timeout: testPlan.timeout,
          totalAgents: testPlan.totalAgents
        }
      };
    } catch (error) {
      console.error('Error parsing test plan:', error);
      throw error;
    }
  }
}

// CLI interface
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.length === 0) {
    console.log('Usage: test-plan-parser.js <test-plan.md> [--json]');
    process.exit(1);
  }
  
  const planPath = args[0];
  const outputJson = args.includes('--json');
  
  TestPlanParser.generateOrchestratorInput(planPath)
    .then(result => {
      if (outputJson) {
        console.log(JSON.stringify(result, null, 2));
      } else {
        console.log('Parsed Test Plan:');
        console.log(`Total Agents: ${result.config.totalAgents}`);
        console.log(`Max Parallel: ${result.config.maxParallel}`);
        console.log(`Timeout: ${result.config.timeout}s`);
        console.log('\nAgents:');
        result.agents.forEach(agent => {
          console.log(`  - ${agent.id}: ${agent.command}`);
        });
      }
    })
    .catch(error => {
      console.error('Error:', error.message);
      process.exit(1);
    });
}

module.exports = TestPlanParser;