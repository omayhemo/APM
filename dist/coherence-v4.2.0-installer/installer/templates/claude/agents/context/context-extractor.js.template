/**
 * Context Extraction Utility
 * Extracts relevant context for sub-agents based on task type and target agent
 * Ensures context stays under 10% of available window (20k tokens max)
 */

// Context extraction utility
function extractRelevantContext(fullContext, taskType, targetAgent) {
  const contextBuilder = {
    // Always include core paths
    workingDirectory: fullContext.projectPath,
    
    // Task-specific extraction
    development: () => ({
      dependencies: extractDirectDependencies(fullContext.task),
      relatedFiles: findRelatedFiles(fullContext.task, 3), // Max 3 files
      patterns: extractRelevantPatterns(fullContext.codebase),
      constraints: fullContext.developmentConstraints || [],
      testRequirements: fullContext.testCoverage || '80%'
    }),
    
    qa: () => ({
      testRequirements: fullContext.testStrategy,
      coverageGoals: fullContext.qualityMetrics,
      testData: fullContext.testDataPath,
      componentUnderTest: fullContext.targetComponent,
      qualityStandards: fullContext.qualityStandards || []
    }),
    
    architecture: () => ({
      constraints: fullContext.architecturalDecisions,
      standards: fullContext.codingStandards,
      integrationPoints: extractIntegrationPoints(fullContext.task),
      designPatterns: fullContext.establishedPatterns || [],
      systemBoundaries: fullContext.systemBoundaries || []
    }),
    
    analysis: () => ({
      dataSources: fullContext.dataLocations,
      analysissCriteria: fullContext.analysisCriteria,
      reportingRequirements: fullContext.reportingFormat,
      historicalContext: summarizeHistory(fullContext.history),
      stakeholders: fullContext.stakeholders || []
    }),
    
    integration: () => ({
      apiContracts: fullContext.apiSpecifications,
      interfaces: fullContext.interfaceDefinitions,
      dependencies: extractIntegrationDependencies(fullContext),
      protocols: fullContext.communicationProtocols,
      errorHandling: fullContext.errorHandlingPatterns
    })
  };
  
  // Get base context for task type
  const baseContext = contextBuilder[taskType] ? 
    contextBuilder[taskType]() : 
    contextBuilder.development(); // Default to development
  
  // Add common context elements
  return {
    ...baseContext,
    taskDescription: fullContext.task,
    targetAgent: targetAgent,
    sessionId: fullContext.sessionId,
    parentAgent: fullContext.parentAgent,
    timestamp: new Date().toISOString()
  };
}

// Extract direct dependencies from task description
function extractDirectDependencies(task) {
  const dependencies = [];
  
  // Extract from package references
  const packageMatches = task.match(/(?:using|import|require|dependency:?)\s+([a-zA-Z0-9-_@/]+)/gi) || [];
  packageMatches.forEach(match => {
    const dep = match.replace(/^(using|import|require|dependency:?)\s+/i, '');
    if (dep && !dependencies.includes(dep)) {
      dependencies.push(dep);
    }
  });
  
  // Extract from story references
  const storyMatches = task.match(/story\s+\d+\.\d+/gi) || [];
  storyMatches.forEach(story => {
    dependencies.push({ type: 'story', reference: story });
  });
  
  return dependencies.slice(0, 10); // Limit to 10 most relevant
}

// Find related files based on task
function findRelatedFiles(task, maxFiles = 3) {
  const relatedFiles = [];
  
  // Extract file paths mentioned in task
  const fileMatches = task.match(/(?:\/[\w-]+)+(?:\/[\w-]+)*(?:\.[\w]+)?/g) || [];
  fileMatches.forEach(file => {
    if (!relatedFiles.includes(file)) {
      relatedFiles.push(file);
    }
  });
  
  // Extract component/module names
  const componentMatches = task.match(/(?:component|module|class|interface)\s+([A-Z][a-zA-Z0-9]+)/g) || [];
  componentMatches.forEach(match => {
    const component = match.replace(/^(component|module|class|interface)\s+/i, '');
    relatedFiles.push({ type: 'component', name: component });
  });
  
  return relatedFiles.slice(0, maxFiles);
}

// Extract relevant patterns from codebase
function extractRelevantPatterns(codebase) {
  if (!codebase || !codebase.patterns) return [];
  
  // Prioritize patterns by relevance
  const patterns = codebase.patterns.filter(pattern => 
    pattern.usage > 5 || // Frequently used
    pattern.critical === true || // Marked as critical
    pattern.recent === true // Recently established
  );
  
  return patterns.slice(0, 5).map(p => ({
    name: p.name,
    location: p.location,
    description: p.description
  }));
}

// Extract integration points from task
function extractIntegrationPoints(task) {
  const integrationPoints = [];
  
  // API endpoints
  const apiMatches = task.match(/(?:GET|POST|PUT|DELETE|PATCH)\s+\/[\w-/]+/gi) || [];
  apiMatches.forEach(api => {
    integrationPoints.push({ type: 'api', endpoint: api });
  });
  
  // Service references
  const serviceMatches = task.match(/(?:service|microservice|api)\s+([a-zA-Z0-9-_]+)/gi) || [];
  serviceMatches.forEach(match => {
    const service = match.replace(/^(service|microservice|api)\s+/i, '');
    integrationPoints.push({ type: 'service', name: service });
  });
  
  return integrationPoints;
}

// Extract integration-specific dependencies
function extractIntegrationDependencies(context) {
  const deps = {
    internal: [],
    external: []
  };
  
  if (context.systemArchitecture) {
    // Internal dependencies
    deps.internal = context.systemArchitecture.internalServices || [];
    
    // External dependencies
    deps.external = context.systemArchitecture.externalAPIs || [];
  }
  
  return deps;
}

// Summarize historical context to save space
function summarizeHistory(history) {
  if (!history || history.length === 0) return null;
  
  // Get most recent and relevant entries
  const relevantHistory = history
    .filter(entry => 
      entry.impact === 'high' || 
      entry.recent === true ||
      entry.type === 'decision'
    )
    .slice(-5); // Last 5 relevant entries
  
  return relevantHistory.map(entry => ({
    date: entry.date,
    type: entry.type,
    summary: entry.summary.substring(0, 100) + '...'
  }));
}

module.exports = {
  extractRelevantContext,
  extractDirectDependencies,
  findRelatedFiles,
  extractRelevantPatterns,
  extractIntegrationPoints
};