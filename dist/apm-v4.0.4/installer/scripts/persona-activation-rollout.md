# Persona Activation Implementation - Rollout Plan

## 🎯 Implementation Strategy

### Approach: Lightweight Persona Context Loading
- **No state tracking** - Avoids complexity
- **1-2 second overhead** - Minimal performance impact
- **Voice notifications** - Clear user feedback
- **Self-contained commands** - Each command handles its own context

## 📅 Phased Rollout Schedule

### Phase 1: High-Priority Commands (Day 1-2)
**Test with most-used commands first**

```bash
# Run the script with Phase 1 filter
./add-persona-activation.sh --phase 1
```

Commands:
- `next-story` (SM)
- `parallel-next-story` (SM)
- `epic` (PO)
- `parallel-epic` (PO)
- `groom` (PO)
- `qa-framework` (QA)
- `run-tests` (QA)
- `test-plan` (QA)

**Testing Protocol:**
1. Backup original templates
2. Run modification script
3. Test each command individually
4. Verify voice notifications work
5. Check execution time (should be <2 seconds overhead)
6. Validate command still functions correctly

### Phase 2: Core Commands (Day 3-4)
**Expand to frequently-used persona commands**

Commands by Persona:
- **Analyst**: requirements, doc-compliance, organize-docs, doc-sharding
- **Architect**: architecture, ai-prompt
- **Design Architect**: frontend-architecture, ux-spec
- **PM**: prd, project-brief
- **QA**: Additional test commands

### Phase 3: Parallel Commands (Day 5-6)
**All parallel-* versions**

- All 30+ parallel command variants
- These follow the same pattern as their sequential versions
- Bulk testing with automated validation

### Phase 4: Remaining Commands (Day 7)
**Complete coverage**

- Any remaining persona-specific commands
- Final validation and cleanup

## 🧪 Testing Strategy

### Test Script: `test-persona-activation.sh`
```bash
#!/bin/bash

# Test persona activation for modified commands

echo "Testing Persona Activation..."

# Test 1: Command execution time
echo "Test 1: Execution time (<2 seconds overhead)"
time echo "/next-story" | claude

# Test 2: Voice notification
echo "Test 2: Voice notification check"
# Should hear: "Scrum Master context loaded for command execution"

# Test 3: Command functionality
echo "Test 3: Original functionality preserved"
# Run command and verify output matches expected format

# Test 4: Error handling
echo "Test 4: Error recovery"
# Test with missing templates, etc.
```

### Success Criteria:
- ✅ < 2 second activation overhead
- ✅ Voice notifications play correctly
- ✅ Original command logic works unchanged
- ✅ Proper error messages if activation fails
- ✅ No state tracking bugs
- ✅ Commands work in any order

## 🚀 Execution Steps

### Step 1: Backup Templates
```bash
# Create backup of all templates
cp -r installer/templates/claude/commands installer/templates/claude/commands.backup
```

### Step 2: Run Modification Script
```bash
# Execute the persona activation script
cd installer/scripts
./add-persona-activation.sh
```

### Step 3: Review Changes
```bash
# Check a sample of modified templates
diff installer/templates/claude/commands.backup/next-story.md.template \
     installer/templates/claude/commands/next-story.md.template
```

### Step 4: Test Phase 1 Commands
```bash
# Test each Phase 1 command
/next-story     # Should load SM context
/epic           # Should load PO context
/qa-framework   # Should load QA context
```

### Step 5: Validate and Proceed
If Phase 1 successful:
- Proceed to Phase 2
- Monitor for any issues
- Collect user feedback

## 📊 Monitoring & Metrics

### Track These Metrics:
1. **Activation Time**: Average overhead per command
2. **Success Rate**: % of successful activations
3. **User Feedback**: Satisfaction with voice notifications
4. **Error Rate**: Activation failures
5. **Command Usage**: Which personas are most active

### Rollback Plan:
If issues arise:
```bash
# Restore from backup
cp -r installer/templates/claude/commands.backup/* installer/templates/claude/commands/
```

## ✅ Benefits Realized

Once implemented:
- **Consistent Experience**: Every command runs with proper persona context
- **Clear Communication**: Users know which expert is handling their request
- **No Complexity**: No state tracking bugs or synchronization issues
- **Fast Execution**: Minimal overhead maintains good performance
- **Professional Feel**: Voice notifications add polish

## 🎉 Success Indicators

The implementation is successful when:
1. All 75 persona commands have activation
2. Average overhead is <2 seconds
3. No state-related bugs reported
4. Users report improved clarity
5. Commands can be run in any order without issues