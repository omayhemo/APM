# Natural Language Progress Parsing Patterns

> **Parser Engine**: Intelligent extraction of progress information from natural language agent outputs

## Overview

The Natural Language Parsing Patterns system enables the Progress Monitoring System to intelligently extract progress information, status updates, and metrics from the natural language outputs of sub-agents without requiring special formatting or APIs.

## Core Pattern Library

### Progress Percentage Patterns

```javascript
const PERCENTAGE_PATTERNS = {
  // Explicit percentage indicators
  explicit: {
    pattern: /\[(\d+)%\]/g,
    description: "Matches [75%] format",
    examples: ["[25%]", "[100%]", "[0%]"],
    confidence: 1.0
  },
  
  // Progress: X% format
  progress_colon: {
    pattern: /Progress:\s*(\d+)%/gi,
    description: "Matches 'Progress: 50%' format",
    examples: ["Progress: 75%", "progress: 25%"],
    confidence: 0.9
  },
  
  // X% complete/done/finished
  completion_suffix: {
    pattern: /(\d+)%\s*(?:complete|done|finished|completed)/gi,
    description: "Matches '80% complete' format",
    examples: ["90% complete", "75% done", "100% finished"],
    confidence: 0.8
  },
  
  // Completed X of Y (calculate percentage)
  fraction_format: {
    pattern: /(?:completed|finished|done)\s+(\d+)\s+(?:of|\/)\s+(\d+)/gi,
    description: "Matches 'Completed 3 of 4' format",
    examples: ["Completed 3 of 4", "Done 7/10", "Finished 2 of 5"],
    confidence: 0.7,
    calculate: (matches) => Math.round((parseInt(matches[1]) / parseInt(matches[2])) * 100)
  },
  
  // Step X of Y format
  step_format: {
    pattern: /(?:step|phase|stage)\s+(\d+)\s+(?:of|\/)\s+(\d+)/gi,
    description: "Matches 'Step 2 of 5' format",
    examples: ["Step 2 of 5", "Phase 3/4", "Stage 1 of 3"],
    confidence: 0.6,
    calculate: (matches) => Math.round((parseInt(matches[1]) / parseInt(matches[2])) * 100)
  }
};
```

### Status and Activity Patterns

```javascript
const STATUS_PATTERNS = {
  // Explicit status declarations
  explicit_status: {
    pattern: /Status:\s*(.+?)(?:\n|$)/gi,
    description: "Matches 'Status: Working on...' format",
    examples: ["Status: Implementing authentication", "Status: Running tests"],
    confidence: 1.0
  },
  
  // Current activity patterns
  currently_doing: {
    pattern: /Currently\s+(.+ing(?:\s+\w+)*)/gi,
    description: "Matches 'Currently implementing...' format",
    examples: ["Currently implementing user auth", "Currently testing API"],
    confidence: 0.8
  },
  
  // Working on patterns
  working_on: {
    pattern: /(?:Working on|Implementing|Testing|Analyzing|Reviewing|Creating|Building)\s*:?\s*(.+?)(?:\n|\.|$)/gi,
    description: "Matches activity declarations",
    examples: ["Working on: database schema", "Implementing user registration"],
    confidence: 0.7
  },
  
  // Now/Next activity patterns
  now_next: {
    pattern: /(?:Now|Next)\s+(.+ing(?:\s+\w+)*)/gi,
    description: "Matches 'Now testing...' format",
    examples: ["Now testing user flows", "Next implementing validation"],
    confidence: 0.6
  }
};
```

### Completion Indicators

```javascript
const COMPLETION_PATTERNS = {
  // Strong completion indicators
  explicit_completion: {
    pattern: /(?:✓|Done|Complete|Finished|Completed|SUCCESS)(?:\s|!|$)/gi,
    description: "Strong completion indicators",
    examples: ["✓", "Done!", "Complete", "Finished successfully"],
    confidence: 1.0,
    progress: 100
  },
  
  // Task/Story completion
  task_completion: {
    pattern: /(?:Story|Task|Implementation|Feature)\s+(?:complete|done|finished|implemented)/gi,
    description: "Task-level completion indicators",
    examples: ["Story complete", "Task done", "Implementation finished"],
    confidence: 0.9,
    progress: 100
  },
  
  // All items completed
  all_completion: {
    pattern: /All\s+(?:tests|tasks|items|requirements)\s+(?:passed|complete|done|finished)/gi,
    description: "Bulk completion indicators",
    examples: ["All tests passed", "All tasks complete"],
    confidence: 0.8,
    progress: 100
  },
  
  // Ready/Delivered indicators
  delivery_completion: {
    pattern: /(?:Ready for|Delivered|Deployed|Released)/gi,
    description: "Delivery completion indicators",
    examples: ["Ready for review", "Delivered to staging"],
    confidence: 0.7,
    progress: 100
  }
};
```

## Advanced Pattern Recognition

### Context-Aware Progress Estimation

```javascript
class ContextAwareProgressEstimator {
  constructor() {
    this.activityProgressMap = {
      // Planning and analysis phase (0-20%)
      'starting': 5,
      'initializing': 8,
      'planning': 10,
      'analyzing requirements': 15,
      'reviewing specs': 12,
      'understanding': 10,
      
      // Design phase (20-40%)
      'designing': 25,
      'architecting': 30,
      'sketching': 22,
      'modeling': 28,
      'defining interfaces': 35,
      
      // Implementation phase (40-80%)
      'implementing': 50,
      'coding': 55,
      'developing': 52,
      'building': 48,
      'constructing': 50,
      'writing code': 60,
      'adding features': 65,
      
      // Testing phase (70-90%)
      'testing': 75,
      'validating': 78,
      'verifying': 72,
      'debugging': 68,
      'fixing issues': 70,
      'running tests': 80,
      
      // Completion phase (85-100%)
      'finalizing': 90,
      'completing': 95,
      'wrapping up': 92,
      'documenting': 88,
      'deploying': 95,
      'delivering': 98
    };
    
    this.sequenceProgressMap = {
      'first': 20,
      'second': 40,
      'third': 60,
      'fourth': 80,
      'final': 95,
      'last': 95
    };
  }
  
  estimateProgress(text, currentProgress = 0) {
    const lowerText = text.toLowerCase();
    
    // Try to find explicit progress first
    const explicitProgress = this._extractExplicitProgress(text);
    if (explicitProgress !== null) {
      return explicitProgress;
    }
    
    // Estimate from activity keywords
    let estimatedProgress = 0;
    let confidence = 0;
    
    // Check activity keywords
    for (const [activity, progress] of Object.entries(this.activityProgressMap)) {
      if (lowerText.includes(activity)) {
        // Weight by keyword specificity
        const specificity = activity.split(' ').length;
        const activityConfidence = specificity * 0.1;
        
        if (activityConfidence > confidence) {
          estimatedProgress = progress;
          confidence = activityConfidence;
        }
      }
    }
    
    // Check sequence indicators
    for (const [sequence, progress] of Object.entries(this.sequenceProgressMap)) {
      if (lowerText.includes(sequence)) {
        // Sequence indicators override activity if more specific
        if (confidence < 0.8) {
          estimatedProgress = progress;
          confidence = 0.8;
        }
      }
    }
    
    // Use context to refine estimate
    if (estimatedProgress > 0) {
      estimatedProgress = this._refineWithContext(estimatedProgress, text, currentProgress);
    }
    
    return {
      progress: estimatedProgress,
      confidence: confidence,
      method: 'activity_estimation'
    };
  }
}
```

### Multi-Pattern Parser Engine

```javascript
class MultiPatternParser {
  constructor() {
    this.patternLibrary = {
      percentage: PERCENTAGE_PATTERNS,
      status: STATUS_PATTERNS,
      completion: COMPLETION_PATTERNS
    };
    
    this.parsingHistory = [];
  }
  
  parseProgressUpdate(agentId, text) {
    const parseResult = {
      agentId: agentId,
      timestamp: Date.now(),
      rawText: text,
      extractedData: {
        progress: null,
        status: null,
        activity: null,
        metrics: {},
        completion: false
      },
      confidence: 0,
      patterns_matched: []
    };
    
    // Parse percentage indicators
    const progressResult = this._parsePercentage(text);
    if (progressResult) {
      parseResult.extractedData.progress = progressResult.value;
      parseResult.confidence = Math.max(parseResult.confidence, progressResult.confidence);
      parseResult.patterns_matched.push(progressResult.pattern);
    }
    
    // Parse status and activity
    const statusResult = this._parseStatus(text);
    if (statusResult) {
      parseResult.extractedData.status = statusResult.status;
      parseResult.extractedData.activity = statusResult.activity;
      parseResult.confidence = Math.max(parseResult.confidence, statusResult.confidence);
      parseResult.patterns_matched.push(...statusResult.patterns);
    }
    
    // Parse completion indicators
    const completionResult = this._parseCompletion(text);
    if (completionResult) {
      parseResult.extractedData.completion = true;
      parseResult.extractedData.progress = 100;
      parseResult.confidence = Math.max(parseResult.confidence, completionResult.confidence);
      parseResult.patterns_matched.push(completionResult.pattern);
    }
    
    // Parse metrics
    const metricsResult = this._parseMetrics(text);
    if (metricsResult) {
      parseResult.extractedData.metrics = metricsResult;
    }
    
    // Store parsing history for learning
    this.parsingHistory.push(parseResult);
    
    return parseResult;
  }
  
  _parsePercentage(text) {
    let bestMatch = null;
    let highestConfidence = 0;
    
    for (const [name, pattern] of Object.entries(this.patternLibrary.percentage)) {
      const matches = [...text.matchAll(pattern.pattern)];
      
      if (matches.length > 0) {
        const match = matches[matches.length - 1]; // Use last match
        let value;
        
        if (pattern.calculate) {
          value = pattern.calculate(match);
        } else {
          value = parseInt(match[1]);
        }
        
        if (value >= 0 && value <= 100 && pattern.confidence > highestConfidence) {
          bestMatch = {
            value: value,
            confidence: pattern.confidence,
            pattern: name,
            match: match[0]
          };
          highestConfidence = pattern.confidence;
        }
      }
    }
    
    return bestMatch;
  }
}
```

## Specialized Parsers

### Development Phase Parser

```javascript
class DevelopmentPhaseParser {
  constructor() {
    this.phasePatterns = {
      planning: {
        keywords: ['planning', 'analyzing', 'researching', 'investigating'],
        progressRange: [0, 20],
        confidence: 0.7
      },
      design: {
        keywords: ['designing', 'architecting', 'modeling', 'wireframing'],
        progressRange: [20, 40],
        confidence: 0.8
      },
      implementation: {
        keywords: ['implementing', 'coding', 'developing', 'building'],
        progressRange: [40, 80],
        confidence: 0.9
      },
      testing: {
        keywords: ['testing', 'debugging', 'validating', 'verifying'],
        progressRange: [70, 90],
        confidence: 0.8
      },
      deployment: {
        keywords: ['deploying', 'releasing', 'delivering', 'publishing'],
        progressRange: [90, 100],
        confidence: 0.9
      }
    };
  }
  
  detectPhase(text) {
    const lowerText = text.toLowerCase();
    let bestPhase = null;
    let highestScore = 0;
    
    for (const [phaseName, phase] of Object.entries(this.phasePatterns)) {
      let score = 0;
      
      phase.keywords.forEach(keyword => {
        if (lowerText.includes(keyword)) {
          score += phase.confidence;
        }
      });
      
      if (score > highestScore) {
        bestPhase = {
          phase: phaseName,
          score: score,
          progressRange: phase.progressRange
        };
        highestScore = score;
      }
    }
    
    return bestPhase;
  }
  
  estimatePhaseProgress(text, phase) {
    const subProgressPatterns = {
      started: 0.1,
      begun: 0.15,
      'in progress': 0.5,
      'halfway': 0.5,
      'almost done': 0.9,
      'nearly complete': 0.85,
      finishing: 0.9
    };
    
    const lowerText = text.toLowerCase();
    let subProgress = 0.5; // Default to middle of phase
    
    for (const [pattern, progress] of Object.entries(subProgressPatterns)) {
      if (lowerText.includes(pattern)) {
        subProgress = progress;
        break;
      }
    }
    
    // Calculate final progress within phase range
    const [min, max] = phase.progressRange;
    return Math.round(min + (max - min) * subProgress);
  }
}
```

### Story-Specific Parser

```javascript
class StorySpecificParser {
  constructor() {
    this.storyProgressPatterns = {
      // User story development patterns
      'user_story': {
        phases: {
          'requirements_analysis': { range: [0, 15], keywords: ['analyzing requirements', 'understanding needs'] },
          'acceptance_criteria': { range: [15, 25], keywords: ['defining criteria', 'acceptance criteria'] },
          'design': { range: [25, 40], keywords: ['designing solution', 'creating mockups'] },
          'implementation': { range: [40, 80], keywords: ['implementing feature', 'coding solution'] },
          'testing': { range: [80, 95], keywords: ['testing feature', 'validating acceptance'] },
          'review': { range: [95, 100], keywords: ['code review', 'stakeholder review'] }
        }
      },
      
      // Technical story patterns
      'technical_story': {
        phases: {
          'investigation': { range: [0, 20], keywords: ['investigating', 'researching'] },
          'architecture': { range: [20, 35], keywords: ['architecting', 'designing system'] },
          'implementation': { range: [35, 75], keywords: ['implementing', 'building'] },
          'integration': { range: [75, 90], keywords: ['integrating', 'connecting'] },
          'validation': { range: [90, 100], keywords: ['validating', 'performance testing'] }
        }
      }
    };
  }
  
  parseStoryProgress(storyType, text) {
    const patterns = this.storyProgressPatterns[storyType];
    if (!patterns) return null;
    
    const lowerText = text.toLowerCase();
    let matchedPhase = null;
    let highestMatch = 0;
    
    // Find best matching phase
    for (const [phaseName, phase] of Object.entries(patterns.phases)) {
      let matchScore = 0;
      
      phase.keywords.forEach(keyword => {
        if (lowerText.includes(keyword)) {
          matchScore += keyword.split(' ').length; // Longer phrases = higher weight
        }
      });
      
      if (matchScore > highestMatch) {
        matchedPhase = {
          name: phaseName,
          range: phase.range,
          confidence: matchScore * 0.1
        };
        highestMatch = matchScore;
      }
    }
    
    if (matchedPhase) {
      // Estimate progress within phase
      const [min, max] = matchedPhase.range;
      const progress = min + Math.round((max - min) * 0.5); // Default to middle
      
      return {
        phase: matchedPhase.name,
        progress: progress,
        confidence: matchedPhase.confidence
      };
    }
    
    return null;
  }
}
```

## Metrics Extraction

### Numeric Metrics Parser

```javascript
class MetricsParser {
  constructor() {
    this.metricPatterns = {
      files: {
        patterns: [
          /(\d+)\s*files?\s*(?:processed|analyzed|reviewed|created|modified)/gi,
          /(?:processed|analyzed|reviewed|created|modified)\s*(\d+)\s*files?/gi
        ],
        unit: 'files'
      },
      
      lines: {
        patterns: [
          /(\d+)\s*lines?\s*(?:of code|analyzed|processed|written|added)/gi,
          /(?:wrote|added|processed)\s*(\d+)\s*lines?/gi
        ],
        unit: 'lines'
      },
      
      tests: {
        patterns: [
          /(\d+)\s*tests?\s*(?:passed|run|executed|created|written)/gi,
          /(?:executed|ran|created)\s*(\d+)\s*tests?/gi
        ],
        unit: 'tests'
      },
      
      issues: {
        patterns: [
          /(\d+)\s*(?:issues?|problems?|errors?|bugs?)\s*(?:found|detected|fixed|resolved)/gi,
          /(?:found|detected|fixed|resolved)\s*(\d+)\s*(?:issues?|problems?|errors?|bugs?)/gi
        ],
        unit: 'issues'
      },
      
      functions: {
        patterns: [
          /(\d+)\s*(?:functions?|methods?)\s*(?:implemented|created|tested)/gi,
          /(?:implemented|created|tested)\s*(\d+)\s*(?:functions?|methods?)/gi
        ],
        unit: 'functions'
      }
    };
  }
  
  extractMetrics(text) {
    const metrics = {};
    
    for (const [metricName, config] of Object.entries(this.metricPatterns)) {
      let maxValue = 0;
      
      config.patterns.forEach(pattern => {
        const matches = [...text.matchAll(pattern)];
        matches.forEach(match => {
          const value = parseInt(match[1]);
          if (!isNaN(value) && value > maxValue) {
            maxValue = value;
          }
        });
      });
      
      if (maxValue > 0) {
        metrics[metricName] = {
          value: maxValue,
          unit: config.unit
        };
      }
    }
    
    return metrics;
  }
}
```

## Machine Learning Enhancement

### Pattern Learning Engine

```javascript
class PatternLearningEngine {
  constructor() {
    this.trainingData = [];
    this.learnedPatterns = new Map();
    this.minTrainingExamples = 10;
  }
  
  // Add training example
  addTrainingExample(text, actualProgress, metadata = {}) {
    this.trainingData.push({
      text: text.toLowerCase(),
      progress: actualProgress,
      metadata: metadata,
      timestamp: Date.now()
    });
    
    // Trigger learning if we have enough data
    if (this.trainingData.length % this.minTrainingExamples === 0) {
      this._updateLearnedPatterns();
    }
  }
  
  // Find patterns in training data
  _updateLearnedPatterns() {
    const progressBuckets = this._bucketByProgress();
    
    progressBuckets.forEach((examples, progressRange) => {
      const commonPhrases = this._extractCommonPhrases(examples);
      
      commonPhrases.forEach(phrase => {
        if (phrase.frequency >= 3) { // Minimum frequency threshold
          this.learnedPatterns.set(phrase.text, {
            progressRange: progressRange,
            confidence: phrase.frequency / examples.length,
            examples: phrase.examples.slice(0, 3) // Keep sample examples
          });
        }
      });
    });
  }
  
  // Use learned patterns to estimate progress
  estimateWithLearning(text) {
    const lowerText = text.toLowerCase();
    let bestMatch = null;
    let highestConfidence = 0;
    
    this.learnedPatterns.forEach((pattern, phrase) => {
      if (lowerText.includes(phrase) && pattern.confidence > highestConfidence) {
        bestMatch = {
          progress: pattern.progressRange.middle,
          confidence: pattern.confidence,
          phrase: phrase,
          learned: true
        };
        highestConfidence = pattern.confidence;
      }
    });
    
    return bestMatch;
  }
}
```

## Integration and Usage

### Complete Parser Integration

```javascript
class UnifiedProgressParser {
  constructor() {
    this.multiPatternParser = new MultiPatternParser();
    this.contextEstimator = new ContextAwareProgressEstimator();
    this.phaseParser = new DevelopmentPhaseParser();
    this.storyParser = new StorySpecificParser();
    this.metricsParser = new MetricsParser();
    this.learningEngine = new PatternLearningEngine();
  }
  
  // Main parsing method
  parseProgress(agentId, text, context = {}) {
    const result = {
      agentId: agentId,
      timestamp: Date.now(),
      progress: null,
      status: null,
      activity: null,
      metrics: {},
      confidence: 0,
      method: 'unknown',
      patterns: []
    };
    
    // Try multi-pattern parsing first (highest confidence)
    const multiResult = this.multiPatternParser.parseProgressUpdate(agentId, text);
    if (multiResult.extractedData.progress !== null) {
      result.progress = multiResult.extractedData.progress;
      result.status = multiResult.extractedData.status;
      result.activity = multiResult.extractedData.activity;
      result.confidence = multiResult.confidence;
      result.method = 'multi_pattern';
      result.patterns = multiResult.patterns_matched;
    }
    
    // Try learned patterns
    if (result.progress === null) {
      const learnedResult = this.learningEngine.estimateWithLearning(text);
      if (learnedResult && learnedResult.confidence > 0.5) {
        result.progress = learnedResult.progress;
        result.confidence = learnedResult.confidence;
        result.method = 'machine_learned';
      }
    }
    
    // Try phase-based estimation
    if (result.progress === null) {
      const phase = this.phaseParser.detectPhase(text);
      if (phase) {
        result.progress = this.phaseParser.estimatePhaseProgress(text, phase);
        result.confidence = phase.score;
        result.method = 'phase_estimation';
      }
    }
    
    // Try story-specific parsing
    if (context.storyType && result.progress === null) {
      const storyResult = this.storyParser.parseStoryProgress(context.storyType, text);
      if (storyResult) {
        result.progress = storyResult.progress;
        result.confidence = storyResult.confidence;
        result.method = 'story_specific';
      }
    }
    
    // Context-aware estimation as fallback
    if (result.progress === null) {
      const contextResult = this.contextEstimator.estimateProgress(text, context.currentProgress);
      if (contextResult.progress > 0) {
        result.progress = contextResult.progress;
        result.confidence = contextResult.confidence;
        result.method = contextResult.method;
      }
    }
    
    // Always extract metrics
    result.metrics = this.metricsParser.extractMetrics(text);
    
    // Learn from this example if we have validation later
    if (context.actualProgress) {
      this.learningEngine.addTrainingExample(text, context.actualProgress, context);
    }
    
    return result;
  }
}
```

---

The Natural Language Parsing Patterns system provides comprehensive, intelligent extraction of progress information from agent outputs, supporting both rule-based patterns and machine learning enhancement for improved accuracy over time.