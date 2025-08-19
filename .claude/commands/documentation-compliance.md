# Enhanced Documentation Compliance Agent Command
name: documentation-compliance

## 🎭 PERSONA CONTEXT ACTIVATION

**This command requires the Analyst persona.**

```markdown
*Loading Analyst context for documentation management...*

Quick Context Load (1-2 seconds):
- Loading Analyst configuration and expertise
- Loading relevant frameworks and methodologies
- Voice notification: bash $/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakAnalyst.sh "Analyst context loaded for documentation management"
- Workspace validation: Ensuring execution from /mnt/c/Code/agentic-persona-mapping

*Analyst context ready. Proceeding with command...*
```

**Version 2.0 with Document Registry Integration**

**All Personas**: Enforces documentation structure standards using sophisticated multi-signal detection and pattern-based placement from document-registry.json.

## Metadata
- **Name**: doc-compliance
- **Version**: 2.0 (Enhanced with Document Registry)
- **Description**: Advanced documentation compliance with intelligent type detection
- **Agent**: Documentation Compliance Agent (DCA)
- **Performance**: Multi-signal detection with 90%+ accuracy
- **Integration**: Uses document-registry.json for intelligent placement

## 🆕 Enhanced Features (v2.0)

### Multi-Signal Document Type Detection
- **40% Filename Analysis**: Pattern matching against known conventions
- **40% Content Analysis**: Searches for type-specific markers in content
- **20% Agent Context**: Uses current persona hints for ambiguous cases
- **Confidence Scoring**: Only auto-moves documents with >70% confidence

### Pattern-Based Naming Enforcement
- **Dynamic Patterns**: `PREFIX-{date}-{seq}.md`, `{title}-{version}.md`, etc.
- **Smart Sequencing**: Auto-generates sequence numbers (daily reset)
- **Title Extraction**: Intelligently extracts titles from content
- **Format Preservation**: Maintains project-specific naming conventions

### Document Registry Integration
- **Central Configuration**: All rules in `document-registry.json`
- **15+ Document Types**: Each with specific location and naming rules
- **Flexible Patterns**: Supports singleton, collection, and category types
- **Subfolder Intelligence**: Preserves valid subfolder structures

## Usage

```bash
/doc-compliance [mode] [options]
```

## Enhanced Modes

### `organize` - Intelligent Document Organization (Enhanced)
- Uses multi-signal detection to identify document types
- Applies pattern-based naming from registry
- Moves documents to registry-defined locations
- Generates detailed migration report

### `detect` - Document Type Detection (New)
- Analyzes documents and reports detected types
- Shows confidence scores for each detection
- Useful for debugging and registry tuning

### `registry` - Registry Management (New)
- View current document registry
- Test detection patterns
- Update registry rules
- Generate registry statistics

## Enhanced Examples

```bash
# Intelligent organization with registry rules
/doc-compliance organize --use-registry

# Detect document types with confidence scores
/doc-compliance detect --path project_docs/

# Preview organization changes
/doc-compliance organize --dry-run --verbose

# Update registry and reorganize
/doc-compliance registry update
/doc-compliance organize --auto-approve

# Generate compliance report with registry stats
/doc-compliance report --include-registry
```

## 🚀 ENHANCED INITIALIZATION PROTOCOL

**CRITICAL**: Upon activation with registry mode, execute parallel initialization:

```
I'm initializing the Enhanced Documentation Compliance Agent with Document Registry integration.

*Executing parallel initialization tasks:*
[Execute all 7 tasks in single function_calls block]
- Task 1: Load document-registry.json from /mnt/c/Code/agentic-persona-mapping/.apm/config/
- Task 2: Initialize DocumentLocationEnforcer with registry
- Task 3: Load backlog management rules from /mnt/c/Code/agentic-persona-mapping/.apm/rules/
- Task 4: Scan all project documentation
- Task 5: Build document type detection cache
- Task 6: Load sequence counters and naming history
- Task 7: Prepare migration safety backup
```

## Registry-Based Organization Workflow

### Phase 1: Intelligent Detection
```python
For each document:
1. Apply multi-signal detection algorithm
2. Calculate confidence score (0-100%)
3. Identify correct location from registry
4. Generate proper filename with pattern
5. Check for conflicts and duplicates
```

### Phase 2: Smart Migration Planning
```
INTELLIGENT MIGRATION PLAN
==========================
Detected 47 documents needing organization

HIGH CONFIDENCE (>90%) - Auto-approve:
✓ test.md → project_docs/qa/test-plans/TEST-PLAN-2025-01-06-001.md
  Type: test_plan (95% confidence)
  Signals: filename="test" + content="Test Cases" + agent="QA"

MEDIUM CONFIDENCE (70-90%) - Review suggested:
? architecture.md → project_docs/planning-architecture/decisions/ADR-2025-01-06-001.md
  Type: architecture_decision (78% confidence)
  Signals: content="Architecture" + structure matches ADR

LOW CONFIDENCE (<70%) - Manual classification:
! random-notes.md → [Requires manual classification]
  Possible types: meeting_notes (45%), general (40%)

DUPLICATES DETECTED:
⚠ test.md + testing.md + qa-test.md
  All detected as: test_plan
  Suggestion: Merge into single TEST-PLAN-2025-01-06-001.md
```

### Phase 3: Safe Execution with Rollback
```python
# Create timestamped backup
backup_dir = ".apm/backups/compliance-{timestamp}/"

# Execute migrations by confidence level
1. Process HIGH confidence auto-moves
2. Prompt for MEDIUM confidence moves
3. Request manual input for LOW confidence
4. Handle duplicates with merge wizard
5. Update all cross-references
6. Verify integrity and rollback if needed
```

## Enhanced Output Format

```markdown
# Enhanced Documentation Compliance Report

## Registry-Based Analysis
- **Registry Version**: 1.0
- **Document Types Defined**: 15
- **Detection Accuracy**: 92% (based on manual verification)

## Document Type Distribution
| Type | Expected | Found | Properly Located | Confidence |
|------|----------|-------|------------------|------------|
| backlog | 1 | 1 | ✅ 100% | 100% |
| user_story | Many | 23 | ⚠️ 65% (8 misplaced) | 89% avg |
| test_plan | Many | 12 | ❌ 25% (9 misplaced) | 92% avg |
| architecture | Many | 8 | ✅ 88% (1 misplaced) | 85% avg |

## Multi-Signal Detection Results

### Successfully Detected (38 documents)
- **Filename Match**: 22 documents (58%)
- **Content Match**: 12 documents (32%)
- **Combined Signals**: 4 documents (10%)

### Ambiguous Documents (9 documents)
1. `notes.md` - Could be: meeting_notes (45%), general (40%)
2. `plan.md` - Could be: test_plan (55%), project_plan (35%)
[Manual review required]

## Pattern Enforcement Analysis

### Naming Patterns Applied
- TEST-PLAN-{date}-{seq}: 12 documents
- STORY-{id}-{title}: 23 documents
- ADR-{seq}-{title}: 5 documents
- REPORT-{date}-{title}: 15 documents

### Sequence Number Allocation
- Highest story ID: 156
- Today's test plans: 3 (sequences 001-003)
- Monthly reports: 8 (proper date ordering maintained)

## Migration Safety Report

### Pre-Migration Backup
- Location: .apm/backups/compliance-2025-01-06-14-30/
- Files backed up: 47
- Backup size: 2.3 MB
- Rollback available: ✅

### Reference Updates Required
- Internal links to update: 89
- External references: 12
- Broken links found: 3
- Auto-fixable: 95%

## Registry Recommendations

### Tune Detection Patterns
Based on false positives/negatives:
1. Add "Acceptance Criteria" to user_story content markers
2. Strengthen test_plan filename patterns
3. Add "Decision Record" to architecture markers

### New Document Types Detected
Documents that don't match any type:
1. Security assessments (3 documents)
2. Performance benchmarks (2 documents)
3. Deployment guides (4 documents)
[Consider adding to registry]
```

## Integration with Document Location Enforcer

```python
# Enhanced doc-compliance uses the enforcer
from pre_tool_use_location_enforcer import DocumentLocationEnforcer

class EnhancedDocCompliance:
    def __init__(self):
        # Initialize with our sophisticated enforcer
        self.enforcer = DocumentLocationEnforcer()
        self.registry = self.enforcer.registry
        
    def organize_documents(self):
        """Use enforcer's detection logic"""
        for doc_path in self.scan_all_documents():
            # Use multi-signal detection
            doc_type, confidence = self.enforcer.detect_document_type(
                doc_path,
                {'content': self.read_file(doc_path)},
                {'agent_persona': 'compliance'}
            )
            
            # Get correct path with pattern enforcement
            correct_path = self.enforcer.get_correct_path(
                doc_type, 
                doc_path,
                {'content': self.read_file(doc_path)}
            )
            
            # Plan migration with confidence thresholds
            if confidence > 90:
                self.auto_migrate(doc_path, correct_path)
            elif confidence > 70:
                self.suggest_migration(doc_path, correct_path, confidence)
            else:
                self.request_manual_classification(doc_path)
```

## Registry Configuration

### document-registry.json Integration
```json
{
  "version": "1.0",
  "enforcement": {
    "confidence_thresholds": {
      "auto_move": 90,
      "suggest": 70,
      "manual": 0
    }
  },
  "document_types": {
    "backlog": {
      "location": "project_docs/backlog.md",
      "type": "singleton",
      "detection": {
        "filename_patterns": ["backlog"],
        "content_markers": ["## Epic", "## Stories", "Product Backlog"],
        "agent_hints": ["Product Owner", "PO"]
      }
    },
    "test_plan": {
      "location": "project_docs/qa/test-plans/",
      "type": "collection",
      "naming": {
        "pattern": "TEST-PLAN-{date}-{seq}.md"
      },
      "detection": {
        "filename_patterns": ["test", "test-plan", "testing"],
        "content_markers": ["Test Cases", "Test Scenarios", "## Testing"],
        "agent_hints": ["QA", "Developer"]
      }
    }
  }
}
```

## Backward Compatibility

The enhanced doc-compliance maintains full compatibility with existing features:
- ✅ All original modes still work (`validate`, `fix`, `report`)
- ✅ document-registry.json rules still applied
- ✅ Existing workflows unchanged
- ✅ Registry integration is optional (`--use-registry` flag)

## Migration from v1.0 to v2.0

```bash
# Step 1: Document registry already deployed during installation
# Located at: /mnt/c/Code/agentic-persona-mapping/.apm/config/document-registry.json
# No need to copy from installer - file already exists

# Step 2: Test detection without changes
/doc-compliance detect --dry-run

# Step 3: Review detection accuracy
/doc-compliance report --include-registry

# Step 4: Tune registry if needed
/doc-compliance registry tune

# Step 5: Execute organization
/doc-compliance organize --use-registry
```

## Performance Optimizations

### Parallel Processing
- Scan documents in 4 parallel streams
- Cache detection results for 1 hour
- Batch file operations for efficiency

### Smart Caching
```python
# Detection cache to avoid re-analysis
detection_cache = {
    "file_hash": {
        "doc_type": "test_plan",
        "confidence": 95,
        "timestamp": "2025-01-06T14:30:00"
    }
}
```

## Success Metrics

### Enhanced Metrics
- **Detection Accuracy**: >90% correct type identification
- **Auto-Organization Rate**: >75% documents auto-placed
- **Pattern Compliance**: >95% proper naming after organization
- **Migration Safety**: 100% rollback success rate
- **Reference Integrity**: >98% links remain valid

## Voice Notifications

```bash
bash /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh "Enhanced Documentation Compliance Agent activated with Document Registry integration. Initiating multi-signal detection and intelligent organization..."
```

---

*Enhanced with Document Registry Integration - Part of APM Documentation Excellence Infrastructure v2.0*