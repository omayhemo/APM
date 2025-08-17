/**
 * Bidirectional Context Handler
 * Manages context flow between parent and sub-agents
 * Extracts key findings and formats results for consumption
 */

// Extract key information from sub-agent results
function extractKeyFindings(agentResult) {
  const findings = {
    summary: '',
    decisions: [],
    createdArtifacts: [],
    dependencies: [],
    warnings: [],
    nextSteps: [],
    sharedContext: []
  };
  
  // Parse result based on type
  if (typeof agentResult === 'string') {
    findings.summary = extractSummary(agentResult);
    findings.decisions = extractDecisions(agentResult);
    findings.createdArtifacts = extractArtifacts(agentResult);
    findings.dependencies = extractNewDependencies(agentResult);
    findings.warnings = extractWarnings(agentResult);
    findings.nextSteps = extractNextSteps(agentResult);
    findings.sharedContext = extractSharedContext(agentResult);
  } else if (typeof agentResult === 'object') {
    // Handle structured result
    findings.summary = agentResult.summary || agentResult.description || '';
    findings.decisions = agentResult.decisions || [];
    findings.createdArtifacts = agentResult.artifacts || agentResult.created || [];
    findings.dependencies = agentResult.dependencies || [];
    findings.warnings = agentResult.warnings || agentResult.issues || [];
    findings.nextSteps = agentResult.nextSteps || agentResult.recommendations || [];
    findings.sharedContext = agentResult.sharedContext || [];
  }
  
  return findings;
}

// Extract summary from text result
function extractSummary(text) {
  // Look for summary section
  const summaryMatch = text.match(/(?:summary|overview|completed?)[\s:]*([^\n]+)/i);
  if (summaryMatch) {
    return summaryMatch[1].trim();
  }
  
  // Return first meaningful line
  const lines = text.split('\n').filter(line => line.trim().length > 10);
  return lines[0] || 'Task completed';
}

// Extract decisions from result
function extractDecisions(text) {
  const decisions = [];
  
  // Look for decision markers
  const decisionPatterns = [
    /(?:decided?|chose|selected|opted)\s+(?:to\s+)?(.+)/gi,
    /(?:decision|choice):\s*(.+)/gi,
    /(?:will|going to|plan to)\s+(.+)/gi
  ];
  
  decisionPatterns.forEach(pattern => {
    const matches = text.matchAll(pattern);
    for (const match of matches) {
      const decision = match[1].trim();
      if (decision && !decisions.includes(decision)) {
        decisions.push(decision);
      }
    }
  });
  
  return decisions.slice(0, 5); // Limit to 5 most important
}

// Extract created artifacts
function extractArtifacts(text) {
  const artifacts = [];
  
  // Look for file/artifact creation patterns
  const artifactPatterns = [
    /(?:created?|added|implemented|wrote)\s+(?:file\s+)?([\/\w\-\.]+)/gi,
    /(?:new file|new component|new module):\s*([\/\w\-\.]+)/gi,
    /(?:generated?|produced?)\s+(.+)/gi
  ];
  
  artifactPatterns.forEach(pattern => {
    const matches = text.matchAll(pattern);
    for (const match of matches) {
      const artifact = match[1].trim();
      if (artifact && artifact.includes('/') || artifact.includes('.')) {
        artifacts.push(artifact);
      }
    }
  });
  
  return artifacts.slice(0, 10); // Limit to 10 artifacts
}

// Extract new dependencies
function extractNewDependencies(text) {
  const dependencies = [];
  
  // Look for dependency patterns
  const depPatterns = [
    /(?:added|installed|requires?)\s+(?:dependency|package|library):\s*([a-zA-Z0-9\-_@\/]+)/gi,
    /npm install\s+([a-zA-Z0-9\-_@\/]+)/gi,
    /(?:import|require)\s+(?:from\s+)?['"]([a-zA-Z0-9\-_@\/]+)['"]/gi
  ];
  
  depPatterns.forEach(pattern => {
    const matches = text.matchAll(pattern);
    for (const match of matches) {
      const dep = match[1].trim();
      if (dep && !dependencies.some(d => d.name === dep)) {
        dependencies.push({
          name: dep,
          type: 'runtime' // Default type
        });
      }
    }
  });
  
  return dependencies;
}

// Extract warnings and issues
function extractWarnings(text) {
  const warnings = [];
  
  // Look for warning patterns
  const warningPatterns = [
    /(?:warning|caution|note|issue|problem|concern):\s*(.+)/gi,
    /(?:be aware|watch out|careful|attention):\s*(.+)/gi,
    /(?:TODO|FIXME|HACK):\s*(.+)/gi
  ];
  
  warningPatterns.forEach(pattern => {
    const matches = text.matchAll(pattern);
    for (const match of matches) {
      const warning = match[1].trim();
      if (warning && !warnings.includes(warning)) {
        warnings.push(warning);
      }
    }
  });
  
  return warnings.slice(0, 5); // Limit to 5 warnings
}

// Extract next steps
function extractNextSteps(text) {
  const nextSteps = [];
  
  // Look for next step patterns
  const stepPatterns = [
    /(?:next steps?|todo|remaining|future work):\s*(.+)/gi,
    /(?:need to|should|must)\s+(.+)/gi,
    /(?:follow[- ]?up|action items?):\s*(.+)/gi
  ];
  
  stepPatterns.forEach(pattern => {
    const matches = text.matchAll(pattern);
    for (const match of matches) {
      const step = match[1].trim();
      if (step && step.length > 10 && !nextSteps.includes(step)) {
        nextSteps.push(step);
      }
    }
  });
  
  return nextSteps.slice(0, 5); // Limit to 5 steps
}

// Extract shared context for other agents
function extractSharedContext(text) {
  const sharedContext = [];
  
  // Look for information relevant to other agents
  const sharedPatterns = [
    /(?:other agents?|shared|global|important):\s*(.+)/gi,
    /(?:affects?|impacts?|relevant to)\s+(.+)/gi,
    /(?:integration point|interface|contract):\s*(.+)/gi
  ];
  
  sharedPatterns.forEach(pattern => {
    const matches = text.matchAll(pattern);
    for (const match of matches) {
      const context = match[1].trim();
      if (context && !sharedContext.includes(context)) {
        sharedContext.push(context);
      }
    }
  });
  
  return sharedContext;
}

// Format findings for parent agent consumption
function formatForParent(findings, agentType = 'Sub-agent') {
  const sections = [];
  
  // Header
  sections.push(`${agentType} completed: ${findings.summary}`);
  
  // Key Decisions
  if (findings.decisions.length > 0) {
    sections.push('\nKey Decisions:');
    findings.decisions.forEach(d => sections.push(`- ${d}`));
  }
  
  // Created Artifacts
  if (findings.createdArtifacts.length > 0) {
    sections.push('\nCreated:');
    findings.createdArtifacts.forEach(a => sections.push(`- ${a}`));
  }
  
  // Dependencies
  if (findings.dependencies.length > 0) {
    sections.push('\nDependencies Added:');
    findings.dependencies.forEach(d => 
      sections.push(`- ${d.name}${d.version ? ` (${d.version})` : ''}`)
    );
  }
  
  // Shared Context
  if (findings.sharedContext.length > 0) {
    sections.push('\nImportant for other agents:');
    findings.sharedContext.forEach(c => sections.push(`- ${c}`));
  }
  
  // Warnings
  if (findings.warnings.length > 0) {
    sections.push('\n⚠️ Warnings:');
    findings.warnings.forEach(w => sections.push(`- ${w}`));
  }
  
  // Next Steps
  if (findings.nextSteps.length > 0) {
    sections.push('\nNext Steps:');
    findings.nextSteps.forEach(s => sections.push(`- ${s}`));
  }
  
  return sections.join('\n');
}

// Format findings for peer agent consumption
function formatForPeer(findings, targetAgentType) {
  const relevantInfo = {
    developer: ['createdArtifacts', 'dependencies', 'warnings'],
    qa: ['createdArtifacts', 'warnings', 'testRequirements'],
    architect: ['decisions', 'integrationPoints', 'constraints'],
    analyst: ['decisions', 'metrics', 'recommendations']
  };
  
  const relevant = relevantInfo[targetAgentType] || ['summary', 'sharedContext'];
  const sections = [];
  
  sections.push(`Context from parallel agent: ${findings.summary}`);
  
  relevant.forEach(section => {
    if (findings[section] && findings[section].length > 0) {
      sections.push(`\n${section.charAt(0).toUpperCase() + section.slice(1)}:`);
      findings[section].forEach(item => {
        sections.push(`- ${typeof item === 'object' ? JSON.stringify(item) : item}`);
      });
    }
  });
  
  return sections.join('\n');
}

// Aggregate findings from multiple sub-agents
function aggregateFindings(findingsArray) {
  const aggregated = {
    summaries: [],
    allDecisions: [],
    allArtifacts: [],
    allDependencies: new Map(),
    allWarnings: [],
    allNextSteps: [],
    sharedContext: []
  };
  
  findingsArray.forEach(findings => {
    aggregated.summaries.push(findings.summary);
    aggregated.allDecisions.push(...findings.decisions);
    aggregated.allArtifacts.push(...findings.createdArtifacts);
    
    // Deduplicate dependencies
    findings.dependencies.forEach(dep => {
      if (!aggregated.allDependencies.has(dep.name)) {
        aggregated.allDependencies.set(dep.name, dep);
      }
    });
    
    aggregated.allWarnings.push(...findings.warnings);
    aggregated.allNextSteps.push(...findings.nextSteps);
    aggregated.sharedContext.push(...findings.sharedContext);
  });
  
  // Remove duplicates and format
  return {
    overallSummary: aggregated.summaries.join('; '),
    decisions: [...new Set(aggregated.allDecisions)],
    artifacts: [...new Set(aggregated.allArtifacts)],
    dependencies: Array.from(aggregated.allDependencies.values()),
    warnings: [...new Set(aggregated.allWarnings)],
    nextSteps: [...new Set(aggregated.allNextSteps)],
    sharedContext: [...new Set(aggregated.sharedContext)]
  };
}

// Context coherence validator
function validateContextCoherence(parentContext, subAgentResults) {
  const issues = [];
  
  // Check if sub-agent addressed the task
  const taskKeywords = extractKeywords(parentContext.taskDescription);
  const resultKeywords = extractKeywords(subAgentResults.summary);
  
  const overlap = calculateOverlap(taskKeywords, resultKeywords);
  if (overlap < 0.3) {
    issues.push({
      type: 'relevance',
      message: 'Sub-agent results may not fully address the requested task'
    });
  }
  
  // Check for conflicting decisions
  if (subAgentResults.decisions) {
    const conflicts = findConflicts(
      parentContext.constraints || [],
      subAgentResults.decisions
    );
    if (conflicts.length > 0) {
      issues.push({
        type: 'conflict',
        message: 'Decisions conflict with constraints',
        details: conflicts
      });
    }
  }
  
  return {
    isCoherent: issues.length === 0,
    issues
  };
}

// Helper: Extract keywords for coherence checking
function extractKeywords(text) {
  const stopWords = new Set(['the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for']);
  return text.toLowerCase()
    .split(/\W+/)
    .filter(word => word.length > 2 && !stopWords.has(word));
}

// Helper: Calculate keyword overlap
function calculateOverlap(keywords1, keywords2) {
  const set1 = new Set(keywords1);
  const set2 = new Set(keywords2);
  const intersection = new Set([...set1].filter(x => set2.has(x)));
  
  return intersection.size / Math.max(set1.size, set2.size);
}

// Helper: Find conflicts between constraints and decisions
function findConflicts(constraints, decisions) {
  const conflicts = [];
  
  // Simple conflict detection based on negation patterns
  constraints.forEach(constraint => {
    decisions.forEach(decision => {
      if (
        (constraint.includes('not') && decision.includes(constraint.replace(/not\s+/i, ''))) ||
        (constraint.includes('avoid') && decision.includes(constraint.replace(/avoid\s+/i, '')))
      ) {
        conflicts.push({
          constraint,
          decision,
          type: 'violation'
        });
      }
    });
  });
  
  return conflicts;
}

module.exports = {
  extractKeyFindings,
  formatForParent,
  formatForPeer,
  aggregateFindings,
  validateContextCoherence,
  extractDecisions,
  extractArtifacts,
  extractWarnings,
  extractNextSteps
};