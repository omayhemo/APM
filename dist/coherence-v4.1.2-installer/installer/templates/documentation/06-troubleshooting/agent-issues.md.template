# Coherence Agent-Specific Issues and Solutions

This guide addresses problems specific to Coherence agent personas, their activation, behavior, and interactions.

## 🤖 Agent System Overview

### Coherence v4.1.0 Native Sub-Agent Architecture
- **Native Integration**: All agents use Claude Code's native sub-agent system
- **True Parallelism**: Multiple agents can execute concurrently
- **4-8x Performance**: Massive improvement over Task-based system
- **Zero CLI Crashes**: Rock-solid integration with native architecture

### Available Agents
- **Coherence Orchestrator** (`/coherence`): Central coordination and delegation
- **Developer** (`/dev`): Code implementation and technical tasks
- **Architect** (`/architect`): System architecture and design
- **Design Architect** (`/design-architect`): UI/UX architecture
- **Analyst** (`/analyst`): Research and data analysis
- **Project Manager** (`/pm`): Project coordination and planning
- **Product Owner** (`/po`): Product requirements and priorities
- **QA Engineer** (`/qa`): Quality assurance and testing
- **Scrum Master** (`/sm`): Agile process facilitation

---

## 🚨 Agent Activation Issues

### 1. Persona Not Activating

**Symptoms:**
```
Agent command executes but persona doesn't activate
Response comes from generic Claude instead of specific agent
No voice notification plays
Agent doesn't follow persona-specific behavior patterns
```

**Root Causes:**
- Session management not initialized
- Missing persona configuration files
- Voice system not configured
- Session state corruption

**Solution:**

**Immediate Diagnosis:**
```bash
# Check if Coherence is properly initialized
ls -la {{Coherence_ROOT}}/session_notes/

# Verify persona configuration exists
ls -la {{Coherence_ROOT}}/agents/personas/

# Test voice system
bash {{Coherence_ROOT}}/agents/voice/speakDeveloper.sh "Test message"

# Check session state
ls -la {{Coherence_ROOT}}/state/
```

**Resolution Steps:**
```bash
# 1. Initialize Coherence properly
/coherence  # This MUST be run first

# 2. Verify session creation
ls -lt {{Coherence_ROOT}}/session_notes/ | head -3

# 3. Then activate specific agent
/dev  # or other agent command

# 4. Verify persona activation with voice
# Should hear: "Developer Agent activated..."
```

**Prevention:**
- Always use `/coherence` first in new sessions
- Don't skip the initialization sequence
- Verify voice system during Coherence setup

---

### 2. Multiple Agents Responding

**Symptoms:**
```
More than one agent responds to commands
Conflicting advice from different personas
Session state confusion between agents
```

**Root Causes:**
- Improper session handoff
- Parallel operations not properly coordinated
- Session state not properly cleared

**Solution:**

**Immediate Action:**
```bash
# Clear session state
rm -f {{Coherence_ROOT}}/state/*.lock
rm -f {{Coherence_ROOT}}/session_notes/current_session.md

# Force session cleanup
/wrap --force

# Start fresh with single agent
/coherence
/handoff dev  # Single agent activation
```

**Proper Handoff Procedure:**
```bash
# Current agent should wrap up
/wrap

# Explicit handoff to new agent
/handoff architect

# Or use switch for complex transitions
/switch qa --compact-session
```

---

### 3. Agent Behavior Inconsistencies

**Symptoms:**
```
Agent doesn't follow expected behavior patterns
Responses don't match persona characteristics
Agent switches behavior mid-conversation
```

**Root Causes:**
- Corrupted persona configuration
- Session context interference
- Mixed agent state

**Solution:**

**Verify Persona Configuration:**
```bash
# Check persona definition files
cat {{Coherence_ROOT}}/agents/personas/developer.json
cat {{Coherence_ROOT}}/agents/personas/architect.json

# Validate JSON configuration
python3 -m json.tool {{Coherence_ROOT}}/agents/personas/developer.json

# Check for configuration corruption
find {{Coherence_ROOT}}/agents/personas/ -name "*.json" -exec python3 -m json.tool {} \; > /dev/null
```

**Reset Agent Configuration:**
```bash
# Backup current configuration
cp -r {{Coherence_ROOT}}/agents/personas {{Coherence_ROOT}}/agents/personas.backup

# Restore default configuration
cp -r {{Coherence_ROOT}}/config/default/personas/* {{Coherence_ROOT}}/agents/personas/

# Test agent activation
/coherence
/dev --test-mode
```

---

### 4. Voice Notification Issues

**Symptoms:**
```
Agent activates but no voice notification
Voice notifications are garbled or incomplete
Wrong agent voice plays for different personas
```

**Root Causes:**
- Text-to-speech system not configured
- Voice script permissions
- Audio system issues

**Solution:**

**Voice System Diagnosis:**
```bash
# Test text-to-speech system
espeak "Testing voice system" 2>/dev/null || say "Testing voice system" 2>/dev/null

# Check voice script permissions
ls -la {{Coherence_ROOT}}/agents/voice/*.sh

# Test specific agent voice
bash {{Coherence_ROOT}}/agents/voice/speakDeveloper.sh "Developer test"
bash {{Coherence_ROOT}}/agents/voice/speakArchitect.sh "Architect test"
```

**Voice System Repair:**
```bash
# Fix voice script permissions
chmod +x {{Coherence_ROOT}}/agents/voice/*.sh

# Install/update TTS system
# Linux:
sudo apt-get install espeak espeak-data
# macOS: Built-in say command should work

# Test voice configuration
{{Coherence_ROOT}}/scripts/test-voice-system.sh
```

**Alternative Solutions:**
```bash
# Disable voice if problematic
export VOICE_ENABLED=false

# Use visual notifications instead
echo "NOTIFICATION_MODE=visual" >> {{Coherence_ROOT}}/config/voice.conf

# Enable debug mode for voice issues
export VOICE_DEBUG=true
```

---

## 🔄 Session Management Issues

### 5. Session Handoff Failures

**Symptoms:**
```
/handoff command doesn't switch agents
Context lost during agent transitions
New agent doesn't have previous conversation context
```

**Root Causes:**
- Session serialization issues
- Context size too large
- File permission problems

**Solution:**

**Handoff Diagnosis:**
```bash
# Check session notes directory
ls -la {{Coherence_ROOT}}/session_notes/

# Check session file sizes
find {{Coherence_ROOT}}/session_notes/ -name "*.md" -exec ls -lh {} \;

# Verify write permissions
touch {{Coherence_ROOT}}/session_notes/test-write.md && rm {{Coherence_ROOT}}/session_notes/test-write.md
```

**Handoff Repair:**
```bash
# Use proper handoff sequence
/coherence  # Start with orchestrator
/handoff dev  # Explicit handoff

# For problematic handoffs, use switch with compaction
/switch architect --compact-session

# If handoffs consistently fail, archive large sessions
mv {{Coherence_ROOT}}/session_notes/*.md {{Coherence_ROOT}}/session_notes/archive/
```

---

### 6. Context Preservation Issues

**Symptoms:**
```
New agent doesn't remember previous conversation
Agent asks for information already provided
Context appears incomplete or corrupted
```

**Root Causes:**
- Session note corruption
- Context size limits exceeded
- File system issues

**Solution:**

**Context Analysis:**
```bash
# Check session note integrity
tail -20 {{Coherence_ROOT}}/session_notes/*.md

# Check for session file corruption
find {{Coherence_ROOT}}/session_notes/ -name "*.md" -exec head -1 {} \; | grep -v "^#"

# Verify context size
wc -c {{Coherence_ROOT}}/session_notes/*.md
```

**Context Repair:**
```bash
# Compact existing session
/switch dev --compact-session

# Or create fresh context summary
/wrap --create-summary
/coherence
```

---

## ⚡ Parallel Agent Issues

### 7. Parallel Operation Failures

**Symptoms:**
```
/parallel commands don't show expected performance improvement
Some parallel agents fail to execute
Coordination between parallel agents breaks down
```

**Root Causes:**
- Resource constraints
- Native sub-agent coordination issues
- System limitations

**Solution:**

**Parallel System Diagnosis:**
```bash
# Check system resources
nproc  # Available CPU cores
free -h  # Available memory

# Test parallel capability
/parallel-test --benchmark --verbose

# Monitor parallel execution
top -p $(pgrep -f claude)
```

**Parallel Optimization:**
```bash
# Adjust parallel worker count
export Coherence_PARALLEL_WORKERS=$(nproc)

# Reduce parallel load for resource-constrained systems
export Coherence_PARALLEL_WORKERS=2
export Coherence_WORKER_MEMORY=50M

# Test optimized parallel operation
/parallel-architecture --workers=2
```

---

### 8. Native Sub-Agent Coordination Issues

**Symptoms:**
```
Parallel agents work independently without coordination
Results from parallel agents conflict
Sub-agents don't properly merge results
```

**Root Causes:**
- Coordination protocol issues
- Communication between sub-agents failing
- Result merging problems

**Solution:**

**Coordination Analysis:**
```bash
# Check coordination logs
tail -f {{Coherence_ROOT}}/logs/coordination.log

# Test sub-agent communication
{{Coherence_ROOT}}/scripts/test-subagent-coordination.sh

# Verify result merging capability
{{Coherence_ROOT}}/scripts/test-result-merging.sh
```

**Coordination Repair:**
```bash
# Reset coordination state
rm -f {{Coherence_ROOT}}/state/coordination/*.lock

# Use explicit coordination
/parallel-development --explicit-coordination

# Fall back to sequential mode if needed
export Coherence_FORCE_SEQUENTIAL=true
```

---

## 🎯 Persona-Specific Issues

### 9. Developer Agent Issues

**Common Developer Problems:**
```
Agent doesn't follow coding standards
Code suggestions are not contextual
Agent doesn't integrate with project structure
```

**Solutions:**
```bash
# Update developer persona configuration
cat > {{Coherence_ROOT}}/agents/personas/developer-custom.json << 'EOF'
{
  "persona": "developer",
  "coding_standards": "project-specific",
  "context_awareness": "high",
  "integration_mode": "seamless"
}
EOF

# Use custom developer configuration
/dev --config developer-custom.json
```

### 10. Architect Agent Issues

**Common Architect Problems:**
```
Agent focuses on low-level details instead of high-level architecture
Architectural decisions don't consider project constraints
Agent doesn't maintain architectural consistency
```

**Solutions:**
```bash
# Configure architect for high-level focus
echo "ARCHITECT_FOCUS=high-level" >> {{Coherence_ROOT}}/config/personas.conf
echo "ARCHITECT_CONSISTENCY=strict" >> {{Coherence_ROOT}}/config/personas.conf

# Load project constraints
/architect --load-constraints project-constraints.json
```

### 11. QA Agent Issues

**Common QA Problems:**
```
Agent doesn't understand project testing standards
Test strategies don't match project requirements
QA framework integration fails
```

**Solutions:**
```bash
# Configure QA for project-specific requirements
/qa --load-test-standards project-test-standards.json

# Update QA framework configuration
cat > {{Coherence_ROOT}}/config/qa-framework.json << 'EOF'
{
  "test_types": ["unit", "integration", "e2e"],
  "frameworks": ["jest", "pytest", "selenium"],
  "coverage_threshold": 80
}
EOF
```

---

## 🔍 Agent Diagnostic Tools

### Comprehensive Agent Health Check

**Built-in Diagnostics:**
```bash
# Run complete agent health check
{{Coherence_ROOT}}/scripts/agent-health-check.sh

# Test individual agent activation
{{Coherence_ROOT}}/scripts/test-agent-activation.sh developer
{{Coherence_ROOT}}/scripts/test-agent-activation.sh architect
{{Coherence_ROOT}}/scripts/test-agent-activation.sh qa
```

**Custom Diagnostic Commands:**
```bash
# Test agent persona consistency
/dev --test-persona --verbose
/architect --test-persona --verbose
/qa --test-persona --verbose

# Test agent handoff capabilities
/coherence --test-handoffs --verbose

# Test parallel agent coordination
/parallel-test --test-coordination --verbose
```

### Agent Performance Analysis

**Performance Monitoring:**
```bash
# Monitor agent activation time
time /dev --benchmark
time /architect --benchmark

# Monitor handoff performance
time /handoff architect --benchmark

# Monitor parallel agent performance
time /parallel-development --benchmark
```

**Resource Usage Analysis:**
```bash
# Monitor agent resource consumption
{{Coherence_ROOT}}/scripts/monitor-agent-resources.sh

# Analyze agent memory usage
{{Coherence_ROOT}}/scripts/analyze-agent-memory.sh

# Check agent CPU usage patterns
{{Coherence_ROOT}}/scripts/analyze-agent-cpu.sh
```

---

## 🛠️ Agent Recovery Procedures

### Emergency Agent Reset

**Complete Agent System Reset:**
```bash
# Stop all agent processes
pkill -f apm
pkill -f claude

# Clear agent state
rm -rf {{Coherence_ROOT}}/state/agents/
rm -f {{Coherence_ROOT}}/state/*.lock

# Reset session management
rm -f {{Coherence_ROOT}}/session_notes/current_session.md

# Restart Coherence system
/coherence --recovery-mode
```

### Individual Agent Reset

**Reset Specific Agent:**
```bash
# Reset developer agent
rm -f {{Coherence_ROOT}}/state/agents/developer.state
cp {{Coherence_ROOT}}/config/default/personas/developer.json {{Coherence_ROOT}}/agents/personas/

# Test agent reset
/dev --test-mode --verbose
```

### Rollback to Previous Configuration

**Configuration Rollback:**
```bash
# Backup current configuration
cp -r {{Coherence_ROOT}}/agents/personas {{Coherence_ROOT}}/agents/personas.backup.$(date +%Y%m%d)

# Restore from backup
cp -r {{Coherence_ROOT}}/agents/personas.backup.YYYYMMDD/* {{Coherence_ROOT}}/agents/personas/

# Test restored configuration
{{Coherence_ROOT}}/scripts/test-all-agents.sh
```

---

## 📊 Agent Quality Assurance

### Agent Behavior Validation

**Behavioral Tests:**
```bash
# Test agent persona adherence
{{Coherence_ROOT}}/scripts/test-persona-adherence.sh

# Validate agent response patterns
{{Coherence_ROOT}}/scripts/validate-agent-responses.sh

# Check agent knowledge consistency
{{Coherence_ROOT}}/scripts/test-agent-knowledge.sh
```

**Integration Tests:**
```bash
# Test agent integration with project
{{Coherence_ROOT}}/scripts/test-project-integration.sh

# Test agent collaboration
{{Coherence_ROOT}}/scripts/test-agent-collaboration.sh

# Test agent workflow compatibility
{{Coherence_ROOT}}/scripts/test-workflow-compatibility.sh
```

---

## 📚 Related Resources

- [Common Issues](common-issues.md) - General Coherence troubleshooting
- [Performance Issues](performance-issues.md) - Agent performance optimization
- [Diagnostic Tools](diagnostic-tools.md) - Advanced debugging utilities
- [Persona Guide](../02-personas/README.md) - Understanding agent personas

---

*Last Updated: {{TIMESTAMP}}*
*Coherence - Agentic Persona Mapping v{{VERSION}}*