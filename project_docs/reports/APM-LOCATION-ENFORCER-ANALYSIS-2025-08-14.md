# APM Document Location Enforcer Hook Analysis

**Date**: August 14, 2025  
**Document Type**: Technical Analysis  
**Subject**: `pre_tool_use_location_enforcer.py` Hook Implementation  
**Status**: Complete Analysis

---

## Executive Summary

The APM Document Location Enforcer is a sophisticated pre-tool hook that automatically intercepts and corrects file placement operations to maintain strict document organization standards. It operates as a transparent middleware layer that enforces document placement rules without disrupting user workflows.

## Hook Architecture

### Core Components

1. **DocumentLocationEnforcer Class** - Main enforcement engine
2. **Registry-Based Configuration** - JSON-driven rule definitions
3. **Multi-Signal Detection** - Content, filename, and agent-based classification
4. **Path Correction Engine** - Automatic file relocation logic
5. **Audit System** - Comprehensive logging and override tracking

### Entry Point Integration

```python
def pre_tool_use_hook(tool_name: str, params: dict, context: dict = None) -> dict:
    """Entry point called by APM system before any tool execution"""
```

The hook integrates at the system level, intercepting all tool calls before execution.

## Enforcement Patterns

### 1. Tool Interception Strategy

**Intercepted Tools:**
- `Write` - New file creation
- `Edit` - File modification
- `MultiEdit` - Batch file operations  
- `Bash` - Command execution (for directory creation)

**Processing Flow:**
```
Tool Call → Hook Intercept → Document Detection → Path Correction → Modified Parameters → Tool Execution
```

### 2. Document Type Detection

**Multi-Signal Analysis with Weighted Scoring:**

| Signal Type | Weight | Detection Method |
|-------------|--------|------------------|
| Content Markers | 50% | Regex patterns in file content |
| Filename Patterns | 30% | Regex matching on filename |
| Agent Persona Hints | 20% | Agent context matching |

**Priority Detection Logic:**
```python
# PRIORITY 1: Explicit content markers (95% confidence)
if any(marker in content for marker in epic_markers):
    return 'epic', 95.0

# PRIORITY 2: Multi-signal scoring
score = (content_score * 0.5) + (filename_score * 0.3) + (agent_score * 0.2)
```

### 3. Path Correction Mechanisms

**Direct Path Violations:**
```python
direct_corrections = {
    r'(.*/)?project_docs/epics/': r'\1project_docs/planning/epics/',
    r'(.*/)?project_docs/stories/': r'\1project_docs/planning/stories/',
}
```

**Registry-Driven Corrections:**
- Document type classification → Location lookup → Path generation

### 4. Bash Command Interception

**Directory Creation Prevention:**
```python
corrections = {
    # Epics folder in wrong location
    r'mkdir\s+(-p\s+)?(["\']?)(.*/)?project_docs/epics/?(["\']?)': 
        r'mkdir \1\2\3project_docs/planning/epics/\4',
    
    # Stories folder in wrong location  
    r'mkdir\s+(-p\s+)?(["\']?)(.*/)?project_docs/stories/?(["\']?)':
        r'mkdir \1\2\3project_docs/planning/stories/\4',
}
```

## Registry Configuration System

### Document Type Definitions

**Structure:**
```json
{
  "document_types": {
    "story": {
      "location": "{{PROJECT_DOCS}}/planning/stories/",
      "type": "collection",
      "naming": {
        "pattern": "STORY-{id}-{title}.md",
        "id_format": "\\d{3}",
        "title_format": "kebab-case"
      },
      "detection": {
        "filename_patterns": ["story", "user-story", "STORY-\\d+"],
        "content_markers": ["Acceptance Criteria", "Story Points", "As a"],
        "agent_hints": ["Product Owner", "PO", "Scrum Master"]
      }
    }
  }
}
```

### Variable Substitution

**Template Variables:**
```python
obj = obj.replace('{{PROJECT_ROOT}}', self.project_root)
obj = obj.replace('{{PROJECT_DOCS}}', self.project_docs)
obj = obj.replace('{{APM_ROOT}}', os.path.join(self.project_root, '.apm'))
obj = obj.replace('{{SESSION_NOTES_PATH}}', self.session_notes)
```

## Filename Generation Engine

### Pattern-Based Naming

**Supported Placeholders:**
- `{date}` - Current date (YYYY-MM-DD)
- `{timestamp}` - Full timestamp (YYYY-MM-DD-HH-MM-SS)
- `{title}` - Extracted/formatted title
- `{id}` - Sequential ID (non-resetting)
- `{seq}` - Daily sequence number (resets daily)
- `{sprint}` - Extracted sprint number
- `{version}` - Version identifier

**Title Formatting Options:**
- `kebab-case` - lowercase-with-hyphens
- `UPPERCASE-KEBAB` - UPPERCASE-WITH-HYPHENS
- `Title-Case` - Title-Case-With-Hyphens
- `uppercase` - UPPERCASE-WITH-DASHES

### Sequence Management

**Daily Reset Counters:**
```python
def get_next_sequence(self, doc_type: str, format_pattern: str) -> str:
    date_key = datetime.now().strftime('%Y-%m-%d')
    key = f"{doc_type}:{date_key}"
    # Count existing files + increment
```

**Persistent ID Counters:**
```python
def get_next_id(self, doc_type: str, format_pattern: str) -> str:
    # Find highest existing ID + increment
```

## Audit and Override System

### Override Mechanism

**Emergency Override:**
```python
def check_override(self, params: dict) -> bool:
    override_flag = self.registry.get('enforcement', {}).get('override_flag', '--force-location')
    return params.get('force_location', False) or override_flag in params.get('flags', [])
```

### Audit Logging

**Override Tracking:**
```json
{
  "timestamp": "2025-08-14T10:30:00",
  "agent": "Product Owner",
  "original_path": "/project_docs/my-epic.md",
  "override_path": "/root/urgent-epic.md",
  "justification": "Emergency documentation needed"
}
```

**Alert System:**
- Tracks override usage frequency
- Configurable alert thresholds
- 24-hour sliding window monitoring

## Error Handling and Fallbacks

### Graceful Degradation

```python
try:
    enforcer = DocumentLocationEnforcer()
    return enforcer.process_hook(tool_name, params, context)
except Exception as e:
    print(f"⚠️ Document location enforcement error: {e}")
    # Return params unchanged to avoid blocking operations
    return params
```

### Registry Loading Fallbacks

1. **Primary**: Load from configured path
2. **Fallback**: Use minimal default registry
3. **Error Recovery**: Continue with basic enforcement

## Document Type Coverage

### Comprehensive Type Support

| Document Type | Location | Naming Pattern | Detection Strategy |
|---------------|----------|----------------|-------------------|
| Story | `/planning/stories/` | `STORY-{id}-{title}.md` | Content markers + agent |
| Epic | `/planning/epics/` | `EPIC-{id}-{title}.md` | Content markers + agent |
| Test Plan | `/qa/test-plans/` | `TEST-PLAN-{date}-{seq}.md` | Content + filename |
| Test Results | `/qa/test-results/` | `TEST-RESULT-{date}-{seq}.md` | Content markers |
| Architecture Decision | `/architecture/decisions/` | `ADR-{seq}-{title}.md` | Content structure |
| Technical Specification | `/architecture/specifications/` | `{component}-SPEC.md` | Content + filename |
| Reports | `/reports/` | `{date}-{title}.md` | Agent + content |
| Session Notes | `/.apm/session_notes/` | `{timestamp}-{description}.md` | Universal agent |
| Meeting Notes | `/meetings/` | `{date}-{title}.md` | Content markers |
| API Documentation | `/api/` | `{service}-API.md` | Content + agent |
| Scripts | `/scripts/` | `{name}.{ext}` | File extension |

### Special Enforcement Rules

**Script Files (Strict Enforcement):**
```json
{
  "enforcement": {
    "level": "strict",
    "message": "Scripts must be placed in {{PROJECT_DOCS}}/scripts/ or subdirectories",
    "block_placement_outside": true
  }
}
```

## User Experience Features

### Transparent Operation

**User Feedback:**
```python
print(f"✅ Created at correct location: {correct_path}")
print(f"📁 Path correction for {agent} agent:")
print(f"   ❌ Blocked: {file_path}")
print(f"   ✅ Corrected: {corrected_path}")
```

**Modified Parameters Tracking:**
```python
modified_params['_location_corrected'] = True
modified_params['_original_path'] = file_path
modified_params['_doc_type'] = doc_type
modified_params['_correction_reason'] = 'direct_path_violation'
```

## Performance Considerations

### Optimization Strategies

1. **Lazy Registry Loading** - Load config only when needed
2. **Sequence Counter Caching** - In-memory counter management
3. **Pattern Pre-compilation** - Regex compilation caching
4. **Early Exit Conditions** - Skip processing for non-markdown files

### Scalability Features

1. **Log Rotation** - Automatic cleanup of old audit logs
2. **Counter Persistence** - Daily sequence reset mechanism
3. **Error Recovery** - Graceful fallback to default behavior

## Integration Points

### APM System Integration

**Context Awareness:**
```python
agent = context.get('agent_persona', 'Unknown') if context else 'Unknown'
```

**Hook Registration:**
- Registered as `pre_tool_use_hook` in APM system
- Called before all tool executions
- Receives full context including agent persona

### Claude Code Integration

**Tool Parameter Modification:**
- Intercepts `Write`, `Edit`, `MultiEdit`, `Bash` operations
- Modifies `file_path` and `command` parameters
- Preserves original parameters for audit trail

## Security Considerations

### Path Traversal Prevention

**Directory Validation:**
- All paths normalized to absolute paths
- Project root boundary enforcement
- Subfolder pattern validation

**Override Security:**
- Audit logging of all overrides
- Alert thresholds for suspicious activity
- Required justification fields

## Testing and Validation

### Test Mode Support

```python
if __name__ == "__main__":
    # Test cases for validation
    test_cases = [
        {
            'tool': 'Write',
            'params': {'file_path': 'test.md', 'content': '# Test Plan...'},
            'context': {'agent_persona': 'QA'}
        }
    ]
```

## Conclusion

The APM Document Location Enforcer represents a sophisticated approach to maintaining document organization through automated enforcement rather than user training. Its multi-layered detection system, comprehensive registry configuration, and transparent operation make it an effective solution for preventing document placement violations while preserving user workflow efficiency.

### Key Strengths

1. **Proactive Enforcement** - Prevents violations before they occur
2. **Intelligent Detection** - Multi-signal document type classification
3. **Transparent Operation** - Minimal user workflow disruption
4. **Comprehensive Coverage** - Handles all major document types
5. **Audit Capabilities** - Full tracking and override monitoring
6. **Flexible Configuration** - JSON-driven rule definitions
7. **Graceful Degradation** - Continues operation despite errors

### Future Enhancement Opportunities

1. **Interactive Prompting** - Real-time user consultation for uncertain types
2. **Machine Learning** - Pattern learning from user corrections
3. **Integration APIs** - External system integration capabilities
4. **Advanced Analytics** - Document placement trend analysis
5. **Custom Rule Engine** - User-defined enforcement patterns

---

*This analysis provides a comprehensive technical overview of the APM Document Location Enforcer hook implementation as of August 14, 2025.*