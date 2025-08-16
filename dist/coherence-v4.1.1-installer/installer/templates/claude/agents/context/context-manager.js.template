/**
 * Context Manager - Main orchestrator for context passing mechanism
 * Integrates extraction, optimization, caching, and monitoring
 * Provides unified interface for sub-agent context management
 */

const { extractRelevantContext } = require('./context-extractor.js.template');
const { optimizeContextSize } = require('./context-optimizer.js.template');
const { contextCache } = require('./context-cache.js.template');
const { extractKeyFindings, formatForParent } = require('./bidirectional-context.js.template');
const { contextMetrics } = require('./performance-monitor.js.template');

class ContextManager {
  constructor(options = {}) {
    this.options = {
      maxContextSize: options.maxContextSize || 20000,
      enableCaching: options.enableCaching !== false,
      enableOptimization: options.enableOptimization !== false,
      enableMonitoring: options.enableMonitoring !== false,
      cacheTimeout: options.cacheTimeout || 900000, // 15 minutes
      ...options
    };
    
    this.activeContexts = new Map(); // Track active contexts
  }
  
  /**
   * Prepare context for sub-agent activation
   * @param {Object} fullContext - Complete parent context
   * @param {string} taskType - Type of task (development, qa, architecture, etc.)
   * @param {string} targetAgent - Target agent type
   * @param {string} specificInstructions - Task-specific instructions
   * @returns {Object} Prepared context with metadata
   */
  async prepareContext(fullContext, taskType, targetAgent, specificInstructions) {
    const startTime = Date.now();
    let contextResult = null;
    let cacheHit = false;
    
    try {
      // Generate cache key
      const cacheKey = this.options.enableCaching
        ? contextCache.generateKey(taskType, targetAgent, specificInstructions)
        : null;
      
      // Try to get from cache first
      if (this.options.enableCaching && cacheKey) {
        const cached = contextCache.getCachedContext(cacheKey);
        if (cached) {
          cacheHit = true;
          contextResult = {
            context: cached,
            optimized: false,
            fromCache: true,
            originalSize: null,
            finalSize: this.estimateSize(cached)
          };
        }
      }
      
      // If not cached, extract and process context
      if (!contextResult) {
        // Extract relevant context
        const extractedContext = extractRelevantContext(
          fullContext,
          taskType,
          targetAgent
        );
        
        // Add specific instructions
        extractedContext.specificInstructions = specificInstructions;
        extractedContext.contextMetadata = {
          extractedAt: new Date().toISOString(),
          parentAgent: fullContext.parentAgent || 'unknown',
          taskType,
          targetAgent
        };
        
        let finalContext = extractedContext;
        let optimized = false;
        let originalSize = null;
        
        // Optimize if enabled and necessary
        if (this.options.enableOptimization) {
          const optimizationResult = optimizeContextSize(extractedContext);
          if (optimizationResult.optimized) {
            finalContext = optimizationResult.context;
            optimized = true;
            originalSize = optimizationResult.originalSize;
          }
        }
        
        contextResult = {
          context: finalContext,
          optimized,
          fromCache: false,
          originalSize,
          finalSize: this.estimateSize(finalContext)
        };
        
        // Cache the result
        if (this.options.enableCaching && cacheKey) {
          contextCache.cacheContext(cacheKey, finalContext, this.options.cacheTimeout);
        }
      }
      
      // Track active context
      const contextId = this.generateContextId();
      this.activeContexts.set(contextId, {
        ...contextResult,
        startTime,
        taskType,
        targetAgent,
        status: 'active'
      });
      
      // Add context ID to result
      contextResult.context.contextId = contextId;
      
      // Record metrics
      if (this.options.enableMonitoring) {
        const processingTime = Date.now() - startTime;
        contextMetrics.track(
          contextResult.finalSize,
          true, // Success
          cacheHit,
          processingTime,
          targetAgent,
          contextResult.optimized,
          contextResult.originalSize
        );
      }
      
      return {
        success: true,
        contextId,
        context: contextResult.context,
        metadata: {
          size: contextResult.finalSize,
          optimized: contextResult.optimized,
          fromCache: cacheHit,
          processingTime: Date.now() - startTime
        }
      };
      
    } catch (error) {
      // Record failure metrics
      if (this.options.enableMonitoring) {
        const processingTime = Date.now() - startTime;
        contextMetrics.track(
          0, // No size on failure
          false, // Failed
          cacheHit,
          processingTime,
          targetAgent
        );
      }
      
      return {
        success: false,
        error: error.message,
        metadata: {
          processingTime: Date.now() - startTime
        }
      };
    }
  }
  
  /**
   * Process sub-agent results and extract key findings
   * @param {string} contextId - Context ID from preparation
   * @param {string|Object} agentResult - Sub-agent's result
   * @returns {Object} Processed results with findings
   */
  processSubAgentResult(contextId, agentResult) {
    const activeContext = this.activeContexts.get(contextId);
    if (!activeContext) {
      throw new Error(`Unknown context ID: ${contextId}`);
    }
    
    try {
      // Extract key findings
      const findings = extractKeyFindings(agentResult);
      
      // Format for parent consumption
      const formattedResult = formatForParent(findings, activeContext.targetAgent);
      
      // Update active context
      activeContext.status = 'completed';
      activeContext.result = findings;
      activeContext.completedAt = Date.now();
      
      // Calculate session duration
      const sessionDuration = activeContext.completedAt - activeContext.startTime;
      
      return {
        success: true,
        findings,
        formattedResult,
        metadata: {
          sessionDuration,
          taskType: activeContext.taskType,
          targetAgent: activeContext.targetAgent
        }
      };
      
    } catch (error) {
      // Mark context as failed
      activeContext.status = 'failed';
      activeContext.error = error.message;
      
      return {
        success: false,
        error: error.message
      };
    }
  }
  
  /**
   * Format context for natural language presentation
   * @param {Object} context - Context object to format
   * @param {string} template - Template type (development, qa, architecture, etc.)
   * @returns {string} Natural language context
   */
  formatContextForAgent(context, template = 'development') {
    const templates = {
      development: this.formatDevelopmentContext,
      qa: this.formatQAContext,
      architecture: this.formatArchitectureContext,
      analysis: this.formatAnalysisContext,
      integration: this.formatIntegrationContext
    };
    
    const formatter = templates[template] || templates.development;
    return formatter.call(this, context);
  }
  
  // Format development context
  formatDevelopmentContext(context) {
    const sections = [];
    
    sections.push(`I need a Developer agent to ${context.taskDescription || 'complete a development task'}.`);
    sections.push('');
    sections.push('Context:');
    
    if (context.workingDirectory) {
      sections.push(`- Working directory: ${context.workingDirectory}`);
    }
    
    if (context.dependencies && context.dependencies.length > 0) {
      const deps = Array.isArray(context.dependencies) 
        ? context.dependencies.join(', ')
        : context.dependencies;
      sections.push(`- Dependencies: ${deps}`);
    }
    
    if (context.relatedFiles && context.relatedFiles.length > 0) {
      sections.push('- Related files:');
      context.relatedFiles.slice(0, 5).forEach(file => {
        sections.push(`  - ${file}`);
      });
    }
    
    if (context.patterns && context.patterns.length > 0) {
      const patterns = context.patterns.map(p => 
        typeof p === 'string' ? p : `${p.name} (${p.location})`
      ).join(', ');
      sections.push(`- Patterns to follow: ${patterns}`);
    }
    
    if (context.testRequirements) {
      sections.push(`- Test requirements: ${context.testRequirements}`);
    }
    
    if (context.constraints && context.constraints.length > 0) {
      const constraints = Array.isArray(context.constraints)
        ? context.constraints.join(', ')
        : context.constraints;
      sections.push(`- Constraints: ${constraints}`);
    }
    
    if (context.specificInstructions) {
      sections.push('');
      sections.push(context.specificInstructions);
    }
    
    return sections.join('\n');
  }
  
  // Format QA context
  formatQAContext(context) {
    const sections = [];
    
    sections.push(`I need a QA agent to ${context.taskDescription || 'perform quality assurance'}.`);
    sections.push('');
    sections.push('Context:');
    
    if (context.componentUnderTest) {
      sections.push(`- Component under test: ${context.componentUnderTest}`);
    }
    
    if (context.testRequirements) {
      sections.push(`- Test requirements: ${context.testRequirements}`);
    }
    
    if (context.coverageGoals) {
      sections.push(`- Coverage goals: ${context.coverageGoals}`);
    }
    
    if (context.testData) {
      sections.push(`- Test data location: ${context.testData}`);
    }
    
    if (context.qualityStandards && context.qualityStandards.length > 0) {
      const standards = Array.isArray(context.qualityStandards)
        ? context.qualityStandards.join(', ')
        : context.qualityStandards;
      sections.push(`- Quality standards: ${standards}`);
    }
    
    if (context.specificInstructions) {
      sections.push('');
      sections.push(context.specificInstructions);
    }
    
    return sections.join('\n');
  }
  
  // Format architecture context
  formatArchitectureContext(context) {
    const sections = [];
    
    sections.push(`I need an Architect agent to ${context.taskDescription || 'work on architectural design'}.`);
    sections.push('');
    sections.push('Context:');
    
    if (context.systemBoundaries && context.systemBoundaries.length > 0) {
      const boundaries = Array.isArray(context.systemBoundaries)
        ? context.systemBoundaries.join(', ')
        : context.systemBoundaries;
      sections.push(`- System boundaries: ${boundaries}`);
    }
    
    if (context.constraints && context.constraints.length > 0) {
      const constraints = Array.isArray(context.constraints)
        ? context.constraints.join(', ')
        : context.constraints;
      sections.push(`- Architectural constraints: ${constraints}`);
    }
    
    if (context.designPatterns && context.designPatterns.length > 0) {
      const patterns = Array.isArray(context.designPatterns)
        ? context.designPatterns.join(', ')
        : context.designPatterns;
      sections.push(`- Design patterns: ${patterns}`);
    }
    
    if (context.integrationPoints && context.integrationPoints.length > 0) {
      sections.push('- Integration points:');
      context.integrationPoints.slice(0, 5).forEach(point => {
        sections.push(`  - ${typeof point === 'string' ? point : `${point.type}: ${point.name || point.endpoint}`}`);
      });
    }
    
    if (context.standards && context.standards.length > 0) {
      const standards = Array.isArray(context.standards)
        ? context.standards.join(', ')
        : context.standards;
      sections.push(`- Standards to follow: ${standards}`);
    }
    
    if (context.specificInstructions) {
      sections.push('');
      sections.push(context.specificInstructions);
    }
    
    return sections.join('\n');
  }
  
  // Format analysis context
  formatAnalysisContext(context) {
    const sections = [];
    
    sections.push(`I need an Analyst agent to ${context.taskDescription || 'perform analysis'}.`);
    sections.push('');
    sections.push('Context:');
    
    if (context.dataSources && context.dataSources.length > 0) {
      const sources = Array.isArray(context.dataSources)
        ? context.dataSources.join(', ')
        : context.dataSources;
      sections.push(`- Data sources: ${sources}`);
    }
    
    if (context.analysisCriteria) {
      sections.push(`- Analysis criteria: ${context.analysisCriteria}`);
    }
    
    if (context.reportingRequirements) {
      sections.push(`- Reporting requirements: ${context.reportingRequirements}`);
    }
    
    if (context.historicalContext) {
      sections.push(`- Historical context: ${context.historicalContext}`);
    }
    
    if (context.stakeholders && context.stakeholders.length > 0) {
      const stakeholders = Array.isArray(context.stakeholders)
        ? context.stakeholders.join(', ')
        : context.stakeholders;
      sections.push(`- Stakeholders: ${stakeholders}`);
    }
    
    if (context.specificInstructions) {
      sections.push('');
      sections.push(context.specificInstructions);
    }
    
    return sections.join('\n');
  }
  
  // Format integration context
  formatIntegrationContext(context) {
    const sections = [];
    
    sections.push(`I need an Integration specialist to ${context.taskDescription || 'handle integration work'}.`);
    sections.push('');
    sections.push('Context:');
    
    if (context.apiContracts && context.apiContracts.length > 0) {
      sections.push('- API contracts:');
      context.apiContracts.slice(0, 5).forEach(contract => {
        sections.push(`  - ${contract}`);
      });
    }
    
    if (context.interfaces && context.interfaces.length > 0) {
      const interfaces = Array.isArray(context.interfaces)
        ? context.interfaces.join(', ')
        : context.interfaces;
      sections.push(`- Interface definitions: ${interfaces}`);
    }
    
    if (context.dependencies) {
      if (context.dependencies.internal && context.dependencies.internal.length > 0) {
        sections.push(`- Internal dependencies: ${context.dependencies.internal.join(', ')}`);
      }
      if (context.dependencies.external && context.dependencies.external.length > 0) {
        sections.push(`- External dependencies: ${context.dependencies.external.join(', ')}`);
      }
    }
    
    if (context.protocols && context.protocols.length > 0) {
      const protocols = Array.isArray(context.protocols)
        ? context.protocols.join(', ')
        : context.protocols;
      sections.push(`- Communication protocols: ${protocols}`);
    }
    
    if (context.errorHandling && context.errorHandling.length > 0) {
      const errorHandling = Array.isArray(context.errorHandling)
        ? context.errorHandling.join(', ')
        : context.errorHandling;
      sections.push(`- Error handling patterns: ${errorHandling}`);
    }
    
    if (context.specificInstructions) {
      sections.push('');
      sections.push(context.specificInstructions);
    }
    
    return sections.join('\n');
  }
  
  // Generate unique context ID
  generateContextId() {
    return `ctx_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
  
  // Estimate context size in tokens
  estimateSize(context) {
    const jsonString = JSON.stringify(context);
    return Math.ceil(jsonString.length / 4); // Rough approximation
  }
  
  // Get active contexts
  getActiveContexts() {
    const active = {};
    for (const [id, context] of this.activeContexts.entries()) {
      if (context.status === 'active') {
        active[id] = {
          taskType: context.taskType,
          targetAgent: context.targetAgent,
          startTime: context.startTime,
          size: context.finalSize
        };
      }
    }
    return active;
  }
  
  // Clean up completed contexts
  cleanupContexts(maxAge = 3600000) { // 1 hour default
    const now = Date.now();
    const keysToDelete = [];
    
    for (const [id, context] of this.activeContexts.entries()) {
      const age = now - context.startTime;
      if (age > maxAge && context.status !== 'active') {
        keysToDelete.push(id);
      }
    }
    
    keysToDelete.forEach(key => {
      this.activeContexts.delete(key);
    });
    
    return keysToDelete.length;
  }
  
  // Get performance metrics
  getMetrics() {
    return contextMetrics.getMetrics();
  }
  
  // Generate full performance report
  generatePerformanceReport() {
    return contextMetrics.generateReport();
  }
}

// Export singleton instance
let contextManager = null;

function getContextManager(options = {}) {
  if (!contextManager) {
    contextManager = new ContextManager(options);
  }
  return contextManager;
}

module.exports = {
  ContextManager,
  getContextManager
};