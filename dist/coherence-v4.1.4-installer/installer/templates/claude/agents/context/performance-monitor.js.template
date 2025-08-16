/**
 * Context Performance Monitor
 * Tracks context efficiency and optimization metrics
 * Provides insights for improving context passing
 */

class ContextPerformanceMonitor {
  constructor() {
    this.metrics = {
      // Size metrics
      averageSize: 0,
      maxSize: 0,
      minSize: Infinity,
      totalRequests: 0,
      
      // Success metrics
      successRate: 0,
      totalSuccess: 0,
      totalFailures: 0,
      
      // Cache metrics
      cacheHitRate: 0,
      totalCacheHits: 0,
      totalCacheMisses: 0,
      
      // Optimization metrics
      optimizationRate: 0,
      totalOptimized: 0,
      averageOptimizationSavings: 0,
      
      // Timing metrics
      averageProcessingTime: 0,
      maxProcessingTime: 0,
      
      // Agent type breakdown
      agentTypeMetrics: new Map()
    };
    
    this.recentMeasurements = [];
    this.maxRecentMeasurements = 1000;
    
    // Performance thresholds
    this.thresholds = {
      maxContextSize: 20000, // 20K tokens
      targetSuccessRate: 0.95, // 95%
      targetCacheHitRate: 0.6, // 60%
      maxProcessingTime: 5000 // 5 seconds
    };
  }
  
  // Record context passing attempt
  trackContextPassing(data) {
    const {
      contextSize,
      success,
      cacheHit,
      processingTime,
      agentType,
      optimized = false,
      originalSize = null
    } = data;
    
    const measurement = {
      timestamp: Date.now(),
      contextSize,
      success,
      cacheHit,
      processingTime,
      agentType,
      optimized,
      originalSize
    };
    
    // Add to recent measurements
    this.recentMeasurements.push(measurement);
    if (this.recentMeasurements.length > this.maxRecentMeasurements) {
      this.recentMeasurements.shift();
    }
    
    // Update global metrics
    this.updateGlobalMetrics(measurement);
    
    // Update agent-specific metrics
    this.updateAgentMetrics(measurement);
    
    // Check for performance issues
    this.checkPerformanceThresholds(measurement);
  }
  
  // Update global performance metrics
  updateGlobalMetrics(measurement) {
    const {
      contextSize,
      success,
      cacheHit,
      processingTime,
      optimized,
      originalSize
    } = measurement;
    
    // Update size metrics
    this.metrics.totalRequests++;
    this.metrics.averageSize = this.calculateRollingAverage(
      this.metrics.averageSize,
      contextSize,
      this.metrics.totalRequests
    );
    this.metrics.maxSize = Math.max(this.metrics.maxSize, contextSize);
    this.metrics.minSize = Math.min(this.metrics.minSize, contextSize);
    
    // Update success metrics
    if (success) {
      this.metrics.totalSuccess++;
    } else {
      this.metrics.totalFailures++;
    }
    this.metrics.successRate = this.metrics.totalSuccess / this.metrics.totalRequests;
    
    // Update cache metrics
    if (cacheHit) {
      this.metrics.totalCacheHits++;
    } else {
      this.metrics.totalCacheMisses++;
    }
    const totalCacheRequests = this.metrics.totalCacheHits + this.metrics.totalCacheMisses;
    this.metrics.cacheHitRate = totalCacheRequests > 0 
      ? this.metrics.totalCacheHits / totalCacheRequests 
      : 0;
    
    // Update optimization metrics
    if (optimized) {
      this.metrics.totalOptimized++;
      if (originalSize) {
        const savings = originalSize - contextSize;
        this.metrics.averageOptimizationSavings = this.calculateRollingAverage(
          this.metrics.averageOptimizationSavings,
          savings,
          this.metrics.totalOptimized
        );
      }
    }
    this.metrics.optimizationRate = this.metrics.totalOptimized / this.metrics.totalRequests;
    
    // Update timing metrics
    this.metrics.averageProcessingTime = this.calculateRollingAverage(
      this.metrics.averageProcessingTime,
      processingTime,
      this.metrics.totalRequests
    );
    this.metrics.maxProcessingTime = Math.max(
      this.metrics.maxProcessingTime,
      processingTime
    );
  }
  
  // Update agent-specific metrics
  updateAgentMetrics(measurement) {
    const { agentType } = measurement;
    
    if (!this.metrics.agentTypeMetrics.has(agentType)) {
      this.metrics.agentTypeMetrics.set(agentType, {
        requests: 0,
        successRate: 0,
        averageSize: 0,
        averageProcessingTime: 0,
        optimizationRate: 0
      });
    }
    
    const agentMetrics = this.metrics.agentTypeMetrics.get(agentType);
    agentMetrics.requests++;
    
    // Update agent-specific averages
    agentMetrics.averageSize = this.calculateRollingAverage(
      agentMetrics.averageSize,
      measurement.contextSize,
      agentMetrics.requests
    );
    
    agentMetrics.averageProcessingTime = this.calculateRollingAverage(
      agentMetrics.averageProcessingTime,
      measurement.processingTime,
      agentMetrics.requests
    );
    
    // Update success rate
    if (measurement.success) {
      agentMetrics.successRate = ((agentMetrics.successRate * (agentMetrics.requests - 1)) + 1) / agentMetrics.requests;
    } else {
      agentMetrics.successRate = (agentMetrics.successRate * (agentMetrics.requests - 1)) / agentMetrics.requests;
    }
    
    // Update optimization rate
    if (measurement.optimized) {
      agentMetrics.optimizationRate = ((agentMetrics.optimizationRate * (agentMetrics.requests - 1)) + 1) / agentMetrics.requests;
    } else {
      agentMetrics.optimizationRate = (agentMetrics.optimizationRate * (agentMetrics.requests - 1)) / agentMetrics.requests;
    }
  }
  
  // Calculate rolling average
  calculateRollingAverage(currentAverage, newValue, totalCount) {
    if (totalCount === 1) return newValue;
    return ((currentAverage * (totalCount - 1)) + newValue) / totalCount;
  }
  
  // Check performance thresholds and generate alerts
  checkPerformanceThresholds(measurement) {
    const alerts = [];
    
    // Check context size
    if (measurement.contextSize > this.thresholds.maxContextSize) {
      alerts.push({
        type: 'size_exceeded',
        message: `Context size ${measurement.contextSize} exceeds threshold ${this.thresholds.maxContextSize}`,
        severity: 'high'
      });
    }
    
    // Check processing time
    if (measurement.processingTime > this.thresholds.maxProcessingTime) {
      alerts.push({
        type: 'slow_processing',
        message: `Processing time ${measurement.processingTime}ms exceeds threshold ${this.thresholds.maxProcessingTime}ms`,
        severity: 'medium'
      });
    }
    
    // Check success rate (based on recent measurements)
    const recentSuccesses = this.recentMeasurements
      .slice(-100) // Last 100 measurements
      .filter(m => m.success).length;
    const recentRate = recentSuccesses / Math.min(100, this.recentMeasurements.length);
    
    if (recentRate < this.thresholds.targetSuccessRate) {
      alerts.push({
        type: 'low_success_rate',
        message: `Recent success rate ${(recentRate * 100).toFixed(1)}% below threshold ${(this.thresholds.targetSuccessRate * 100)}%`,
        severity: 'high'
      });
    }
    
    // Emit alerts if any
    if (alerts.length > 0) {
      this.emitAlerts(alerts);
    }
  }
  
  // Emit performance alerts
  emitAlerts(alerts) {
    // In a real implementation, this would send to monitoring system
    console.warn('Context Performance Alerts:', alerts);
  }
  
  // Generate performance report
  generateReport() {
    const report = {
      timestamp: new Date().toISOString(),
      overview: this.getOverviewMetrics(),
      agentBreakdown: this.getAgentBreakdown(),
      trends: this.getTrends(),
      recommendations: this.getRecommendations()
    };
    
    return report;
  }
  
  // Get overview metrics
  getOverviewMetrics() {
    return {
      totalRequests: this.metrics.totalRequests,
      successRate: `${(this.metrics.successRate * 100).toFixed(1)}%`,
      averageContextSize: `${Math.round(this.metrics.averageSize)} tokens`,
      maxContextSize: `${this.metrics.maxSize} tokens`,
      cacheHitRate: `${(this.metrics.cacheHitRate * 100).toFixed(1)}%`,
      optimizationRate: `${(this.metrics.optimizationRate * 100).toFixed(1)}%`,
      averageOptimizationSavings: `${Math.round(this.metrics.averageOptimizationSavings)} tokens`,
      averageProcessingTime: `${Math.round(this.metrics.averageProcessingTime)}ms`,
      maxProcessingTime: `${this.metrics.maxProcessingTime}ms`
    };
  }
  
  // Get agent-specific breakdown
  getAgentBreakdown() {
    const breakdown = {};
    
    for (const [agentType, metrics] of this.metrics.agentTypeMetrics.entries()) {
      breakdown[agentType] = {
        requests: metrics.requests,
        successRate: `${(metrics.successRate * 100).toFixed(1)}%`,
        averageContextSize: `${Math.round(metrics.averageSize)} tokens`,
        averageProcessingTime: `${Math.round(metrics.averageProcessingTime)}ms`,
        optimizationRate: `${(metrics.optimizationRate * 100).toFixed(1)}%`
      };
    }
    
    return breakdown;
  }
  
  // Get performance trends
  getTrends() {
    if (this.recentMeasurements.length < 10) {
      return { insufficient_data: true };
    }
    
    const recent = this.recentMeasurements.slice(-100);
    const older = this.recentMeasurements.slice(-200, -100);
    
    if (older.length === 0) {
      return { insufficient_historical_data: true };
    }
    
    const recentAvgSize = recent.reduce((sum, m) => sum + m.contextSize, 0) / recent.length;
    const olderAvgSize = older.reduce((sum, m) => sum + m.contextSize, 0) / older.length;
    
    const recentSuccessRate = recent.filter(m => m.success).length / recent.length;
    const olderSuccessRate = older.filter(m => m.success).length / older.length;
    
    const recentAvgTime = recent.reduce((sum, m) => sum + m.processingTime, 0) / recent.length;
    const olderAvgTime = older.reduce((sum, m) => sum + m.processingTime, 0) / older.length;
    
    return {
      contextSize: {
        trend: recentAvgSize > olderAvgSize ? 'increasing' : 'decreasing',
        change: `${Math.round(Math.abs(recentAvgSize - olderAvgSize))} tokens`
      },
      successRate: {
        trend: recentSuccessRate > olderSuccessRate ? 'improving' : 'declining',
        change: `${Math.abs((recentSuccessRate - olderSuccessRate) * 100).toFixed(1)}%`
      },
      processingTime: {
        trend: recentAvgTime > olderAvgTime ? 'slower' : 'faster',
        change: `${Math.round(Math.abs(recentAvgTime - olderAvgTime))}ms`
      }
    };
  }
  
  // Get performance recommendations
  getRecommendations() {
    const recommendations = [];
    
    // Size recommendations
    if (this.metrics.averageSize > 15000) {
      recommendations.push({
        type: 'optimization',
        priority: 'high',
        message: 'Context size is approaching limits. Consider more aggressive optimization.',
        action: 'Review context templates and trim non-essential information'
      });
    }
    
    // Success rate recommendations
    if (this.metrics.successRate < 0.9) {
      recommendations.push({
        type: 'quality',
        priority: 'high',
        message: 'Success rate is below 90%. Context may be insufficient or unclear.',
        action: 'Review failed context passes and improve templates'
      });
    }
    
    // Cache recommendations
    if (this.metrics.cacheHitRate < 0.4) {
      recommendations.push({
        type: 'performance',
        priority: 'medium',
        message: 'Cache hit rate is low. Consider improving cache key strategy.',
        action: 'Review cache key generation and TTL settings'
      });
    }
    
    // Optimization recommendations
    if (this.metrics.optimizationRate < 0.3) {
      recommendations.push({
        type: 'efficiency',
        priority: 'medium',
        message: 'Context optimization rate is low. More contexts could benefit from optimization.',
        action: 'Lower optimization thresholds or improve detection'
      });
    }
    
    return recommendations;
  }
  
  // Reset metrics
  reset() {
    this.metrics = {
      averageSize: 0,
      maxSize: 0,
      minSize: Infinity,
      totalRequests: 0,
      successRate: 0,
      totalSuccess: 0,
      totalFailures: 0,
      cacheHitRate: 0,
      totalCacheHits: 0,
      totalCacheMisses: 0,
      optimizationRate: 0,
      totalOptimized: 0,
      averageOptimizationSavings: 0,
      averageProcessingTime: 0,
      maxProcessingTime: 0,
      agentTypeMetrics: new Map()
    };
    this.recentMeasurements = [];
  }
}

// Singleton instance
let performanceMonitor = null;

// Get or create performance monitor instance
function getPerformanceMonitor() {
  if (!performanceMonitor) {
    performanceMonitor = new ContextPerformanceMonitor();
  }
  return performanceMonitor;
}

// Convenience functions
const contextMetrics = {
  // Track context passing
  track(contextSize, success, cacheHit, processingTime, agentType, optimized = false, originalSize = null) {
    getPerformanceMonitor().trackContextPassing({
      contextSize,
      success,
      cacheHit,
      processingTime,
      agentType,
      optimized,
      originalSize
    });
  },
  
  // Get current metrics
  getMetrics() {
    return getPerformanceMonitor().getOverviewMetrics();
  },
  
  // Generate full report
  generateReport() {
    return getPerformanceMonitor().generateReport();
  },
  
  // Reset all metrics
  reset() {
    getPerformanceMonitor().reset();
  }
};

module.exports = {
  ContextPerformanceMonitor,
  contextMetrics,
  getPerformanceMonitor
};