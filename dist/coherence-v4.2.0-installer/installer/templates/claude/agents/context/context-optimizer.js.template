/**
 * Context Size Optimization
 * Ensures context stays under 10% of available window (20k tokens max)
 * Implements priority-based trimming and intelligent summarization
 */

// Token estimation (rough approximation: 1 token ≈ 4 characters)
function estimateTokens(obj) {
  const jsonString = JSON.stringify(obj);
  return Math.ceil(jsonString.length / 4);
}

// Ensure context stays under 10% (20k tokens)
function optimizeContextSize(context) {
  const MAX_CONTEXT_TOKENS = 20000;
  
  // Priority-based trimming
  const priorities = {
    critical: ['workingDirectory', 'dependencies', 'taskDescription', 'targetAgent'],
    important: ['relatedFiles', 'patterns', 'constraints', 'testRequirements', 'apiContracts'],
    helpful: ['examples', 'documentation', 'history', 'previousResults', 'suggestions']
  };
  
  let currentSize = estimateTokens(context);
  
  // If already within limits, return as-is
  if (currentSize <= MAX_CONTEXT_TOKENS) {
    return {
      context,
      optimized: false,
      originalSize: currentSize,
      finalSize: currentSize
    };
  }
  
  // Clone context for modification
  const optimizedContext = JSON.parse(JSON.stringify(context));
  
  // Track optimization steps
  const optimizationLog = [];
  
  // Trim from lowest priority
  for (const priority of ['helpful', 'important']) {
    for (const field of priorities[priority]) {
      if (optimizedContext[field] && currentSize > MAX_CONTEXT_TOKENS) {
        const originalFieldSize = estimateTokens(optimizedContext[field]);
        
        // Apply field-specific optimization
        optimizedContext[field] = optimizeField(field, optimizedContext[field]);
        
        const newFieldSize = estimateTokens(optimizedContext[field]);
        const savedTokens = originalFieldSize - newFieldSize;
        
        optimizationLog.push({
          field,
          priority,
          originalSize: originalFieldSize,
          newSize: newFieldSize,
          saved: savedTokens
        });
        
        currentSize = estimateTokens(optimizedContext);
      }
    }
    
    // Check if we're within limits
    if (currentSize <= MAX_CONTEXT_TOKENS) break;
  }
  
  // If still too large, apply aggressive trimming to important fields
  if (currentSize > MAX_CONTEXT_TOKENS) {
    for (const field of priorities.important) {
      if (optimizedContext[field] && currentSize > MAX_CONTEXT_TOKENS) {
        optimizedContext[field] = aggressiveTrim(field, optimizedContext[field]);
        currentSize = estimateTokens(optimizedContext);
      }
    }
  }
  
  return {
    context: optimizedContext,
    optimized: true,
    originalSize: estimateTokens(context),
    finalSize: currentSize,
    optimizationLog,
    withinLimits: currentSize <= MAX_CONTEXT_TOKENS
  };
}

// Field-specific optimization strategies
function optimizeField(fieldName, value) {
  const strategies = {
    relatedFiles: (files) => {
      // Keep only essential files
      if (Array.isArray(files)) {
        return files.slice(0, 3).map(f => 
          typeof f === 'string' ? f : { name: f.name, type: f.type }
        );
      }
      return files;
    },
    
    patterns: (patterns) => {
      // Summarize patterns
      if (Array.isArray(patterns)) {
        return patterns.slice(0, 3).map(p => ({
          name: p.name,
          location: p.location
          // Remove description to save space
        }));
      }
      return patterns;
    },
    
    history: (history) => {
      // Keep only most recent
      if (Array.isArray(history)) {
        return history.slice(-3).map(h => ({
          date: h.date,
          type: h.type,
          // Truncate summary
          summary: h.summary ? h.summary.substring(0, 50) + '...' : ''
        }));
      }
      return history;
    },
    
    documentation: (docs) => {
      // Extract key points only
      if (typeof docs === 'string') {
        return extractKeyPoints(docs, 200); // 200 char limit
      }
      if (Array.isArray(docs)) {
        return docs.slice(0, 2).map(d => 
          typeof d === 'string' ? d.substring(0, 100) : { title: d.title }
        );
      }
      return docs;
    },
    
    constraints: (constraints) => {
      // Prioritize hard constraints
      if (Array.isArray(constraints)) {
        return constraints
          .filter(c => c.priority === 'high' || c.type === 'hard')
          .slice(0, 5)
          .map(c => typeof c === 'string' ? c : { type: c.type, description: c.description });
      }
      return constraints;
    },
    
    testRequirements: (reqs) => {
      // Summarize requirements
      if (typeof reqs === 'object') {
        return {
          coverage: reqs.coverage || '80%',
          types: reqs.types ? reqs.types.slice(0, 3) : ['unit', 'integration'],
          critical: reqs.critical || []
        };
      }
      return reqs;
    }
  };
  
  // Apply field-specific strategy or generic summarization
  const strategy = strategies[fieldName];
  if (strategy) {
    return strategy(value);
  }
  
  // Generic summarization for unknown fields
  return summarize(value);
}

// Aggressive trimming for when gentle optimization isn't enough
function aggressiveTrim(fieldName, value) {
  if (Array.isArray(value)) {
    // Keep only first item
    return value.slice(0, 1);
  }
  
  if (typeof value === 'string') {
    // Truncate to 100 characters
    return value.substring(0, 100) + '...';
  }
  
  if (typeof value === 'object' && value !== null) {
    // Keep only essential keys
    const essentialKeys = ['id', 'name', 'type', 'path', 'value'];
    const trimmed = {};
    
    essentialKeys.forEach(key => {
      if (value[key] !== undefined) {
        trimmed[key] = value[key];
      }
    });
    
    return Object.keys(trimmed).length > 0 ? trimmed : { summary: 'trimmed' };
  }
  
  return value;
}

// Generic summarization function
function summarize(value) {
  if (typeof value === 'string' && value.length > 200) {
    return value.substring(0, 200) + '...';
  }
  
  if (Array.isArray(value) && value.length > 5) {
    return value.slice(0, 5);
  }
  
  if (typeof value === 'object' && value !== null) {
    const keys = Object.keys(value);
    if (keys.length > 10) {
      // Keep only first 10 keys
      const summarized = {};
      keys.slice(0, 10).forEach(key => {
        summarized[key] = value[key];
      });
      summarized._truncated = true;
      return summarized;
    }
  }
  
  return value;
}

// Extract key points from long text
function extractKeyPoints(text, maxLength = 200) {
  if (!text || text.length <= maxLength) return text;
  
  // Try to find natural break points
  const sentences = text.match(/[^.!?]+[.!?]+/g) || [];
  let result = '';
  
  for (const sentence of sentences) {
    if (result.length + sentence.length <= maxLength) {
      result += sentence;
    } else {
      break;
    }
  }
  
  return result || text.substring(0, maxLength) + '...';
}

// Validate optimization result
function validateOptimization(result) {
  const { context, finalSize, withinLimits } = result;
  
  // Ensure critical fields are preserved
  const criticalFields = ['workingDirectory', 'taskDescription', 'targetAgent'];
  const missingCritical = criticalFields.filter(field => !context[field]);
  
  if (missingCritical.length > 0) {
    console.warn('Critical fields missing after optimization:', missingCritical);
    return false;
  }
  
  if (!withinLimits) {
    console.warn(`Context still exceeds limit: ${finalSize} tokens`);
    return false;
  }
  
  return true;
}

module.exports = {
  optimizeContextSize,
  estimateTokens,
  validateOptimization,
  optimizeField,
  summarize
};