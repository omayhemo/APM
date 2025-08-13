# Document Location Enforcer Bug Fix Report
**Date**: 2025-08-10  
**Severity**: Critical  
**Impact**: All APM installations using Document Location Enforcement

---

## Problem

### Error Message
```
2025-08-10 18:11:44,193 - pre_tool_use - ERROR - Error in Document Location Enforcement: 'DocumentLocationEnforcer' object has no attribute 'project_root'
```

### Root Cause
The `DocumentLocationEnforcer` class in the hook template had an initialization order bug:

1. The `__init__` method called `self.load_registry()` on line 31
2. `load_registry()` called `self.substitute_variables()` on line 43
3. `substitute_variables()` tried to access `self.project_root` on line 56
4. BUT `self.project_root` wasn't set until line 33 (AFTER `load_registry()` was called)

This caused an AttributeError whenever the hook tried to enforce document locations in deployed installations.

---

## Solution

### Fix Applied
Reordered the initialization in `installer/templates/hooks/pre_tool_use_location_enforcer.py`:

**Before (Buggy Order):**
```python
def __init__(self, config_path: str = None):
    """Initialize the enforcer with configuration"""
    if config_path is None:
        config_path = os.path.join(
            os.environ.get('APM_ROOT', '.apm'),
            'config',
            'document-registry.json'
        )
    
    self.config_path = config_path
    self.registry = self.load_registry()  # ❌ Called BEFORE project_root exists!
    self.sequence_counters = {}
    self.project_root = os.environ.get('PROJECT_ROOT', os.getcwd())  # Set too late!
    self.project_docs = os.path.join(self.project_root, 'project_docs')
    self.session_notes = os.path.join(self.project_root, '.apm', 'session_notes')
```

**After (Fixed Order):**
```python
def __init__(self, config_path: str = None):
    """Initialize the enforcer with configuration"""
    # Set project paths FIRST, before loading registry
    self.project_root = os.environ.get('PROJECT_ROOT', os.getcwd())  # ✅ Set FIRST!
    self.project_docs = os.path.join(self.project_root, 'project_docs')
    self.session_notes = os.path.join(self.project_root, '.apm', 'session_notes')
    self.sequence_counters = {}
    
    # Now we can safely load the registry (which uses self.project_root)
    if config_path is None:
        config_path = os.path.join(
            os.environ.get('APM_ROOT', '.apm'),
            'config',
            'document-registry.json'
        )
    
    self.config_path = config_path
    self.registry = self.load_registry()  # ✅ Now safe to call!
```

---

## Impact

### Affected Files
- `installer/templates/hooks/pre_tool_use_location_enforcer.py` (Fixed)
- `installer/templates/hooks/pre_tool_use.py` (Uses the fixed class)
- `installer/templates/hooks/pre_tool_use_integrated.py` (Uses the fixed class)

### Affected Installations
- Any APM installation that has Document Location Enforcement enabled
- The bug would trigger whenever Write, Edit, or MultiEdit tools were used

### Resolution
- The fix is applied to the template file
- New installations will get the corrected version
- Existing installations need to update their hook files or reinstall

---

## Testing Recommendation

After installation, test the fix by:

1. Enable Document Location Enforcement
2. Try to create a document with Write tool:
   ```python
   # This should work without AttributeError
   Write(file_path="test.md", content="# Test")
   ```
3. Verify no errors in logs about 'project_root' attribute

---

## Prevention

### Lessons Learned
1. Always initialize dependencies before using them
2. Instance attributes used by methods should be set before calling those methods
3. Consider using properties or lazy initialization for complex dependencies

### Code Review Checklist
- [ ] Check initialization order in `__init__` methods
- [ ] Verify all attributes exist before methods that use them are called
- [ ] Test hook templates in isolation before deployment
- [ ] Include error handling that doesn't block tool execution

---

*Bug fixed in APM v4.0.0 templates*
*Fix prevents hook failures in all deployed installations*