#!/usr/bin/env node

/**
 * Parallel Test Command Handler
 * Implements the /parallel-test command functionality
 */

const { exec } = require('child_process');
const { promisify } = require('util');
const fs = require('fs').promises;
const path = require('path');

const execAsync = promisify(exec);

class ParallelTestHandler {
  constructor(options = {}) {
    this.options = {
      plan: options.plan || 'tests/parallel-test-plan.md',
      dryRun: options.dryRun || false,
      filter: options.filter || '',
      updatePlan: options.updatePlan !== false,
      maxParallel: options.maxParallel || null,
      timeout: options.timeout || null
    };
  }

  /**
   * Execute the parallel test command
   */
  async execute() {
    try {
      console.log('🚀 Parallel Test Execution Starting...\n');
      
      // Validate test plan exists
      await this.validateTestPlan();
      
      // Build command arguments
      const args = this.buildArguments();
      
      // Execute wrapper script
      const wrapperPath = path.join(__dirname, 'parallel-test-wrapper.sh');
      const command = `bash ${wrapperPath} ${args.join(' ')}`;
      
      if (this.options.dryRun) {
        console.log('Dry run - would execute:');
        console.log(command);
        return;
      }
      
      // Execute and stream output
      const { stdout, stderr } = await execAsync(command, {
        maxBuffer: 10 * 1024 * 1024 // 10MB buffer
      });
      
      if (stdout) console.log(stdout);
      if (stderr) console.error(stderr);
      
      console.log('\n✅ Parallel Test Execution Complete');
      
    } catch (error) {
      console.error('\n❌ Parallel Test Execution Failed');
      console.error(error.message);
      process.exit(1);
    }
  }
  
  /**
   * Validate that the test plan exists
   */
  async validateTestPlan() {
    try {
      await fs.access(this.options.plan);
    } catch (error) {
      throw new Error(`Test plan not found: ${this.options.plan}`);
    }
  }
  
  /**
   * Build command line arguments
   */
  buildArguments() {
    const args = [];
    
    if (this.options.plan !== 'tests/parallel-test-plan.md') {
      args.push('--plan', this.options.plan);
    }
    
    if (this.options.dryRun) {
      args.push('--dry-run');
    }
    
    if (this.options.filter) {
      args.push('--filter', this.options.filter);
    }
    
    if (!this.options.updatePlan) {
      args.push('--update-plan', 'false');
    }
    
    if (this.options.maxParallel) {
      args.push('--max-parallel', this.options.maxParallel);
    }
    
    if (this.options.timeout) {
      args.push('--timeout', this.options.timeout);
    }
    
    return args;
  }
  
  /**
   * Parse command line arguments for CLI usage
   */
  static parseArguments(args) {
    const options = {};
    
    for (let i = 0; i < args.length; i++) {
      switch (args[i]) {
        case '--plan':
          options.plan = args[++i];
          break;
        case '--dry-run':
          options.dryRun = true;
          break;
        case '--filter':
          options.filter = args[++i];
          break;
        case '--update-plan':
          options.updatePlan = args[++i] === 'true';
          break;
        case '--max-parallel':
          options.maxParallel = parseInt(args[++i]);
          break;
        case '--timeout':
          options.timeout = parseInt(args[++i]);
          break;
        case '--help':
        case '-h':
          this.showHelp();
          process.exit(0);
      }
    }
    
    return options;
  }
  
  /**
   * Show help message
   */
  static showHelp() {
    console.log(`
Parallel Test Command Handler

Usage: parallel-test-handler.js [options]

Options:
  --plan <path>         Alternative test plan file (default: tests/parallel-test-plan.md)
  --dry-run            Show what would be executed without running tests
  --filter <regex>     Run only agents matching the pattern
  --update-plan        Update the test plan after execution (default: true)
  --max-parallel <n>   Override max parallel agents from plan
  --timeout <minutes>  Override global timeout from plan
  --help, -h          Show this help message

Examples:
  # Run all tests from default plan
  parallel-test-handler.js

  # Use custom test plan
  parallel-test-handler.js --plan tests/integration-test-plan.md

  # Run only unit tests
  parallel-test-handler.js --filter "unit-.*"

  # Dry run to see what would execute
  parallel-test-handler.js --dry-run
    `);
  }
}

// CLI interface
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.includes('--help') || args.includes('-h')) {
    ParallelTestHandler.showHelp();
    process.exit(0);
  }
  
  const options = ParallelTestHandler.parseArguments(args);
  const handler = new ParallelTestHandler(options);
  
  handler.execute().catch(error => {
    console.error('Error:', error.message);
    process.exit(1);
  });
}

module.exports = ParallelTestHandler;