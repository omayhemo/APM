# Coherence Performance Issues and Optimization

This guide addresses performance-related problems in the Coherence - Agentic Persona Mapping and provides optimization strategies.

## ⚡ Performance Overview

### Expected Performance Baselines

**Coherence v4.1.0 Native Sub-Agent Performance:**
- **Command Execution**: < 2 seconds for simple commands
- **Persona Activation**: < 3 seconds with voice notifications
- **Parallel Operations**: 4-8x speedup over sequential execution
- **Session Handoffs**: < 1 second for context transfer
- **Memory Usage**: < 50MB for typical operations

**Performance Indicators:**
- ✅ **Good**: Commands respond within expected baselines
- ⚠️ **Degraded**: 2-5x slower than baseline performance
- 🚨 **Poor**: >5x slower or system becomes unresponsive

---

## 🐌 Common Performance Issues

### 1. Slow Command Execution

**Symptoms:**
```
Commands take >10 seconds to respond
Long delays before persona activation
Timeout errors during command processing
```

**Root Causes:**
- Large session note files
- Excessive log accumulation
- System resource constraints
- Network latency (for remote operations)

**Solutions:**

**Immediate Actions:**
```bash
# Check system resources
top -p $(pgrep -f claude)
df -h {{Coherence_ROOT}}

# Archive large session files
find {{Coherence_ROOT}}/session_notes/ -size +5M -exec mv {} {{Coherence_ROOT}}/session_notes/archive/ \;

# Clear temporary files
rm -f {{Coherence_ROOT}}/temp/*
rm -f {{Coherence_ROOT}}/logs/*.tmp

# Restart with clean session
/wrap
/coherence
```

**Long-term Optimization:**
```bash
# Configure automatic session archiving
echo "MAX_SESSION_SIZE=1000000" >> {{Coherence_ROOT}}/config/performance.conf
echo "AUTO_ARCHIVE=true" >> {{Coherence_ROOT}}/config/performance.conf

# Set up log rotation
echo "LOG_ROTATE_SIZE=10M" >> {{Coherence_ROOT}}/config/logging.conf
echo "LOG_KEEP_DAYS=7" >> {{Coherence_ROOT}}/config/logging.conf
```

---

### 2. Memory Usage Issues

**Symptoms:**
```
Gradually increasing memory usage
System swap usage increasing
"Out of memory" errors
System becomes unresponsive during Coherence operations
```

**Root Causes:**
- Memory leaks in long-running sessions
- Large context preservation between handoffs
- Excessive session history retention

**Solutions:**

**Memory Analysis:**
```bash
# Monitor Coherence memory usage
ps aux | grep -E "(claude|apm)" | awk '{sum+=$6} END {print "Total Coherence Memory: " sum/1024 " MB"}'

# Check for memory leaks
top -p $(pgrep -f claude) -b -n 1 | tail -n +8

# Analyze session file sizes
find {{Coherence_ROOT}}/session_notes/ -name "*.md" -exec ls -lh {} \; | sort -k5 -hr | head -10
```

**Memory Optimization:**
```bash
# Enable memory-efficient mode
export Coherence_MEMORY_MODE=efficient

# Limit session context size
echo "MAX_CONTEXT_SIZE=50000" >> {{Coherence_ROOT}}/config/session.conf

# Configure automatic cleanup
echo "SESSION_CLEANUP_INTERVAL=3600" >> {{Coherence_ROOT}}/config/performance.conf

# Restart with memory constraints
/wrap --compact-memory
/coherence --memory-limit 100M
```

**Advanced Memory Management:**
```bash
# Use session compaction
/switch --compact-session

# Archive old sessions
mv {{Coherence_ROOT}}/session_notes/*.md {{Coherence_ROOT}}/session_notes/archive/

# Clear caches
rm -rf {{Coherence_ROOT}}/cache/*
```

---

### 3. Slow Parallel Operations

**Symptoms:**
```
Parallel commands not showing expected speedup
Individual sub-agents executing slowly
Native sub-agent coordination delays
```

**Root Causes:**
- System CPU constraints
- I/O bottlenecks
- Sub-agent resource contention
- Network latency in distributed operations

**Solutions:**

**Resource Optimization:**
```bash
# Check CPU availability
nproc
top -b -n 1 | grep "Cpu(s)"

# Monitor parallel execution
/parallel-test --benchmark --verbose

# Tune parallel execution
echo "MAX_PARALLEL_AGENTS=4" >> {{Coherence_ROOT}}/config/parallel.conf
echo "PARALLEL_TIMEOUT=30" >> {{Coherence_ROOT}}/config/parallel.conf
```

**I/O Optimization:**
```bash
# Check disk I/O
iostat -x 1 3

# Use faster storage for session notes (if available)
export Coherence_FAST_STORAGE="/tmp/coherencem-session"
mkdir -p $Coherence_FAST_STORAGE
ln -sf $Coherence_FAST_STORAGE {{Coherence_ROOT}}/session_notes/active

# Enable asynchronous I/O
echo "ASYNC_IO=true" >> {{Coherence_ROOT}}/config/performance.conf
```

**Parallel Agent Tuning:**
```bash
# Optimize for your system
export Coherence_PARALLEL_WORKERS=$(nproc)
export Coherence_WORKER_MEMORY="50M"

# Use conservative settings for resource-constrained systems
export Coherence_PARALLEL_WORKERS=2
export Coherence_WORKER_TIMEOUT=60
```

---

### 4. Session Management Performance

**Symptoms:**
```
Slow session creation and switching
Long delays during /handoff operations
Context preservation taking excessive time
```

**Root Causes:**
- Large session context
- Inefficient session serialization
- Excessive session history

**Solutions:**

**Session Optimization:**
```bash
# Enable session streaming
echo "SESSION_STREAM_MODE=true" >> {{Coherence_ROOT}}/config/session.conf

# Limit context preservation
echo "CONTEXT_PRESERVE_LIMIT=1000" >> {{Coherence_ROOT}}/config/session.conf

# Use incremental session updates
echo "SESSION_INCREMENTAL=true" >> {{Coherence_ROOT}}/config/session.conf

# Test session performance
/session-benchmark --verbose
```

**Context Management:**
```bash
# Compress large contexts
echo "CONTEXT_COMPRESSION=gzip" >> {{Coherence_ROOT}}/config/session.conf

# Use smart context filtering
echo "CONTEXT_SMART_FILTER=true" >> {{Coherence_ROOT}}/config/session.conf

# Enable context caching
echo "CONTEXT_CACHE=true" >> {{Coherence_ROOT}}/config/session.conf
```

---

### 5. Voice Notification Delays

**Symptoms:**
```
Long delays before voice notifications play
Audio stuttering or distortion
Voice notifications blocking other operations
```

**Root Causes:**
- Audio system latency
- Text-to-speech processing overhead
- Audio driver issues

**Solutions:**

**Audio System Optimization:**
```bash
# Test TTS performance
time espeak "Performance test" 2>/dev/null || time say "Performance test" 2>/dev/null

# Use faster TTS settings
echo "TTS_SPEED=200" >> {{Coherence_ROOT}}/config/voice.conf
echo "TTS_QUALITY=low" >> {{Coherence_ROOT}}/config/voice.conf

# Enable asynchronous voice notifications
echo "VOICE_ASYNC=true" >> {{Coherence_ROOT}}/config/voice.conf
```

**Alternative Voice Solutions:**
```bash
# Use pre-generated audio files
echo "VOICE_PREGENERATED=true" >> {{Coherence_ROOT}}/config/voice.conf

# Disable voice in performance-critical scenarios
export VOICE_ENABLED=false

# Use visual notifications instead
echo "NOTIFICATION_MODE=visual" >> {{Coherence_ROOT}}/config/voice.conf
```

---

## 🔧 Performance Monitoring

### Built-in Performance Tools

**Coherence Performance Monitor:**
```bash
# Real-time performance monitoring
{{Coherence_ROOT}}/scripts/performance-monitor.sh

# Performance benchmarking
{{Coherence_ROOT}}/scripts/benchmark-apm.sh --full

# Resource usage tracking
{{Coherence_ROOT}}/scripts/resource-tracker.sh --start
```

**Command-specific Benchmarks:**
```bash
# Test persona activation speed
time /dev --benchmark

# Test parallel operation performance
time /parallel-test --benchmark

# Test session management performance
time /switch dev --benchmark
```

### System Performance Monitoring

**Resource Monitoring:**
```bash
# CPU and Memory usage
htop -p $(pgrep -f claude)

# Disk I/O monitoring
iotop -p $(pgrep -f claude)

# Network usage (if applicable)
nethogs -p $(pgrep -f claude)
```

**Performance Logging:**
```bash
# Enable performance logging
echo "PERF_LOGGING=true" >> {{Coherence_ROOT}}/config/logging.conf

# Monitor performance logs
tail -f {{Coherence_ROOT}}/logs/performance.log

# Analyze performance trends
{{Coherence_ROOT}}/scripts/analyze-performance.sh --last-week
```

---

## ⚡ Performance Optimization Strategies

### 1. System-Level Optimizations

**CPU Optimization:**
```bash
# Set CPU governor for performance
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Disable CPU throttling during Coherence operations
echo 0 | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo

# Use all available cores
export OMP_NUM_THREADS=$(nproc)
```

**Memory Optimization:**
```bash
# Increase swappiness for better memory management
echo 10 | sudo tee /proc/sys/vm/swappiness

# Clear system caches before intensive operations
sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
```

**I/O Optimization:**
```bash
# Use SSD-optimized settings
echo deadline | sudo tee /sys/block/*/queue/scheduler

# Increase I/O queue depth
echo 128 | sudo tee /sys/block/*/queue/nr_requests
```

### 2. Coherence-Specific Optimizations

**Configuration Tuning:**
```bash
# Create performance-optimized config
cat > {{Coherence_ROOT}}/config/performance.conf << 'EOF'
# Coherence Performance Configuration
MAX_SESSION_SIZE=500000
SESSION_CLEANUP_INTERVAL=1800
CONTEXT_PRESERVE_LIMIT=2000
PARALLEL_WORKERS=4
MEMORY_LIMIT=200M
CACHE_SIZE=100M
TTS_ASYNC=true
LOG_LEVEL=WARN
EOF

# Apply configuration
source {{Coherence_ROOT}}/config/performance.conf
```

**Resource Allocation:**
```bash
# Allocate dedicated resources for Coherence
nice -n -10 /coherence  # Higher priority
ionice -c 1 -n 4  # Real-time I/O scheduling

# Use memory mapping for large files
echo "MEMORY_MAP_SESSIONS=true" >> {{Coherence_ROOT}}/config/performance.conf
```

### 3. Workflow Optimizations

**Session Management:**
```bash
# Use efficient session patterns
/coherence --quick-start  # Skip verbose initialization
/dev --fast-mode   # Reduce context loading
/handoff architect --minimal-context  # Faster handoffs
```

**Parallel Operations:**
```bash
# Optimize parallel command usage
/parallel-architecture --workers=2  # Match CPU cores
/parallel-test --batch-size=10      # Optimal batch size
/parallel-development --memory-aware # Respect memory limits
```

---

## 📊 Performance Benchmarking

### Baseline Performance Tests

**Command Execution Benchmarks:**
```bash
# Basic command performance
echo "=== Basic Command Performance ===" > performance-report.txt
(time /coherence --test-mode) 2>> performance-report.txt
(time /dev --test-mode) 2>> performance-report.txt
(time /architect --test-mode) 2>> performance-report.txt

# Parallel operation benchmarks
echo "=== Parallel Operation Performance ===" >> performance-report.txt
(time /parallel-test --benchmark) 2>> performance-report.txt
(time /parallel-architecture --benchmark) 2>> performance-report.txt
```

**Session Management Benchmarks:**
```bash
# Session operation performance
echo "=== Session Management Performance ===" >> performance-report.txt
(time /handoff dev) 2>> performance-report.txt
(time /switch architect) 2>> performance-report.txt
(time /wrap) 2>> performance-report.txt
```

### Performance Regression Testing

**Automated Performance Tests:**
```bash
# Run comprehensive performance test suite
{{Coherence_ROOT}}/scripts/performance-test-suite.sh

# Compare with baseline
{{Coherence_ROOT}}/scripts/compare-performance.sh baseline.json current.json

# Generate performance report
{{Coherence_ROOT}}/scripts/generate-perf-report.sh > performance-analysis.html
```

---

## 🚨 Performance Troubleshooting Flowchart

### Step 1: Identify Performance Issue Type
```
Is the issue:
├── Command execution slowness? → Go to "Slow Command Execution"
├── Memory usage problems? → Go to "Memory Usage Issues"  
├── Parallel operation slowness? → Go to "Slow Parallel Operations"
├── Session management delays? → Go to "Session Management Performance"
└── Voice notification delays? → Go to "Voice Notification Delays"
```

### Step 2: Apply Immediate Solutions
```
For each issue type:
1. Apply immediate solutions
2. Monitor for improvement
3. If improved, apply long-term optimizations
4. If not improved, proceed to advanced troubleshooting
```

### Step 3: Advanced Performance Analysis
```bash
# Generate detailed performance profile
{{Coherence_ROOT}}/scripts/profile-apm.sh --detailed

# Analyze system bottlenecks
{{Coherence_ROOT}}/scripts/bottleneck-analysis.sh

# Create performance improvement plan
{{Coherence_ROOT}}/scripts/optimization-planner.sh
```

---

## 🛠️ Performance Recovery Procedures

### Emergency Performance Recovery
```bash
# Stop all Coherence processes
pkill -f apm
pkill -f claude

# Clear all caches and temporary files
rm -rf {{Coherence_ROOT}}/cache/*
rm -rf {{Coherence_ROOT}}/temp/*
rm -f {{Coherence_ROOT}}/logs/*.tmp

# Archive large session files
find {{Coherence_ROOT}}/session_notes/ -size +1M -exec mv {} {{Coherence_ROOT}}/session_notes/archive/ \;

# Restart with minimal configuration
export Coherence_MINIMAL_MODE=true
/coherence --recovery-mode
```

### Performance Reset
```bash
# Reset all performance configurations to defaults
cp {{Coherence_ROOT}}/config/default/* {{Coherence_ROOT}}/config/

# Clear performance logs
truncate -s 0 {{Coherence_ROOT}}/logs/performance.log

# Restart Coherence with fresh session
/wrap --force
/coherence --clean-start
```

---

## 📚 Related Resources

- [Common Issues](common-issues.md) - General troubleshooting
- [Diagnostic Tools](diagnostic-tools.md) - Advanced debugging utilities
- [Configuration Guide](../05-configuration/README.md) - Performance tuning options

---

*Last Updated: {{TIMESTAMP}}*
*Coherence - Agentic Persona Mapping v{{VERSION}}*