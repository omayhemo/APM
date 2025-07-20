# Claude.md Intelligent Merge System - Implementation Plan

**Project**: Agentic Persona Mapping  
**Component**: Installer Enhancement  
**Date**: 2025-01-18  
**Status**: Planning Phase  
**Priority**: High  

## 🎯 Core Objective

Create a straightforward merge routine that compares existing `CLAUDE.md` files with the **single** installer template (`CLAUDE.md.markdown.template`) and merges only the changes, preserving user customizations while adding new functionality.

## 🔄 Major Simplifications from Obsidian Removal

### ✅ What's Now Easier
- **Single template variant** - No template selection logic needed
- **Consistent paths** - Always use `.apm/session_notes/` structure
- **No conditional merging** - Same merge logic for all installations
- **Simplified validation** - One template structure to validate against
- **Reduced complexity** - ~60% less code required

### ❌ What's No Longer Needed
- ~~Template variant detection~~
- ~~Obsidian vs Markdown path handling~~
- ~~MCP-specific configuration merging~~
- ~~Conditional section handling~~
- ~~Multi-template conflict resolution~~

## 🧠 Phase 1: Simplified Analysis

### 1.1 Single Template Analysis
- **Parse** `CLAUDE.md.markdown.template` structure
- **Map standard sections** and their content patterns
- **Identify variable substitution** points (`{{VARIABLE}}`)
- **Document section hierarchies** and dependencies

### 1.2 Target File Analysis
- **Parse existing** `CLAUDE.md` file structure
- **Detect AP method version** from content patterns
- **Identify user customizations** vs standard sections
- **Map any deviations** from template structure

## 🔧 Phase 2: Streamlined Merge Algorithm

### 2.1 Section-Level Merge Strategy
```
SIMPLIFIED MERGE LOGIC:
├── STANDARD SECTIONS: Update with template changes
├── USER SECTIONS: Preserve completely
├── NEW SECTIONS: Add from template
└── DEPRECATED SECTIONS: Flag for user review
```

### 2.2 Merge Process Flow
```
1. Backup existing CLAUDE.md
2. Parse template into sections
3. Parse target file into sections
4. Identify section types (standard vs custom)
5. Merge standard sections with preservation
6. Add new sections from template
7. Preserve user sections
8. Validate merged result
9. Create merged file
```

### 2.3 Section Identification
- **Header patterns**: `## Section Name` detection
- **Content fingerprinting**: Match against template patterns
- **Variable detection**: Identify `{{VARIABLE}}` vs actual values
- **Custom section detection**: Sections not in template

## 🛠 Phase 3: Implementation Architecture - Simplified

### 3.1 Core Components
```
claude-merge-system/
├── claude-merge.sh           # Main merge script
├── section-parser.sh         # Parse Claude.md sections
├── template-analyzer.sh      # Analyze template structure
├── merge-engine.sh          # Core merge logic
├── backup-manager.sh        # Backup and rollback
└── merge-validator.sh       # Validate results
```

### 3.2 Merge Engine Features
- **Section-aware parsing** (header-based)
- **Template variable resolution** 
- **User customization preservation**
- **Incremental updates** (only changed sections)
- **Validation and rollback** capabilities

### 3.3 Integration Points
- **Installer integration**: Run during Step 10 (CLAUDE.md creation)
- **Standalone utility**: `/path/to/claude-merge.sh`
- **Update workflow**: Part of AP manager updates

## 🏗 Phase 4: Detailed Implementation Plan

### 4.1 Merge Algorithm Logic
```bash
# Simplified merge algorithm
merge_claude_md() {
    local template_file="$1"
    local target_file="$2"
    local output_file="$3"
    
    # 1. Backup existing file
    backup_file "$target_file"
    
    # 2. Parse sections
    parse_sections "$template_file" > template_sections.tmp
    parse_sections "$target_file" > target_sections.tmp
    
    # 3. Identify section types
    identify_custom_sections template_sections.tmp target_sections.tmp
    
    # 4. Merge sections
    merge_sections template_sections.tmp target_sections.tmp > "$output_file"
    
    # 5. Validate result
    validate_merged_file "$output_file"
}
```

### 4.2 Section Parser
```bash
parse_sections() {
    local file="$1"
    awk '
    /^## / { 
        if (section_content) print section_name ":::" section_content
        section_name = $0
        section_content = ""
        next
    }
    { section_content = section_content $0 "\n" }
    END { if (section_content) print section_name ":::" section_content }
    ' "$file"
}
```

### 4.3 Merge Strategy Matrix
| Section Type | Action | Preservation |
|-------------|--------|-------------|
| **Standard (unchanged)** | Keep target | User variables |
| **Standard (updated)** | Merge template | User variables |
| **User custom** | Keep target | Complete |
| **New in template** | Add from template | With variables |
| **Deprecated** | Flag for review | Complete |

## 📊 Phase 5: Installer Integration

### 5.1 Installation Workflow Update
```bash
# Replace this in install.sh:
# replace_variables "$INSTALLER_DIR/templates/CLAUDE.md.markdown.template" "$CLAUDE_MD"

# With this:
if [ -f "$CLAUDE_MD" ]; then
    echo "Existing CLAUDE.md found. Merging updates..."
    "$INSTALLER_DIR/claude-merge.sh" \
        "$INSTALLER_DIR/templates/CLAUDE.md.markdown.template" \
        "$CLAUDE_MD" \
        "$CLAUDE_MD.new"
    
    if validate_merge "$CLAUDE_MD.new"; then
        mv "$CLAUDE_MD.new" "$CLAUDE_MD"
        echo "✅ CLAUDE.md updated with new features, customizations preserved"
    else
        echo "❌ Merge failed, keeping existing file"
        rm "$CLAUDE_MD.new"
    fi
else
    echo "Creating new CLAUDE.md..."
    replace_variables "$INSTALLER_DIR/templates/CLAUDE.md.markdown.template" "$CLAUDE_MD"
fi
```

### 5.2 User Experience
```
Step 10: Configuring CLAUDE.md
------------------------------
✓ Found existing CLAUDE.md
✓ Analyzing for customizations...
✓ Merging template updates...
✓ Preserving user sections: Custom Commands, Project Notes
✓ Adding new sections: Enhanced Session Management
✓ CLAUDE.md updated successfully
```

## 🎯 Phase 6: Implementation Priority - Revised

### High Priority (Week 1)
1. **Basic section parser** - Extract sections from files
2. **Template analysis** - Understand current template structure
3. **Simple merge logic** - Combine standard sections
4. **Backup system** - Safety first
5. **Installer integration** - Hook into Step 10

### Medium Priority (Week 2)
1. **Advanced preservation** - Variable substitution in user sections
2. **Validation system** - Ensure merged file integrity
3. **User interaction** - Approval for significant changes
4. **Error handling** - Robust failure recovery

### Low Priority (Future)
1. **Merge history** - Track what was changed
2. **Selective merging** - User choice of sections
3. **Performance optimization** - Handle large files
4. **Advanced validation** - Deep content checking

## 🔍 Success Criteria - Simplified

### Primary Goals
- ✅ **Zero data loss** - Never lose user customizations
- ✅ **Seamless updates** - New template features merge cleanly
- ✅ **Safe operations** - Always recoverable
- ✅ **Simple maintenance** - Single template to manage

### Secondary Goals
- ✅ **Fast execution** - Merge completes in < 2 seconds
- ✅ **Clear feedback** - User knows what changed
- ✅ **Minimal dependencies** - Standard bash tools only
- ✅ **Robust validation** - Catches merge issues

## 🎯 Key Advantages of Simplified Approach

### Development Benefits
- **50% less code** - Single template path
- **Faster development** - No variant testing
- **Easier debugging** - One merge path to trace
- **Simpler testing** - Single template to validate

### User Benefits
- **Consistent behavior** - Same merge logic for everyone
- **Faster execution** - No template detection overhead
- **Fewer edge cases** - Less chance of merge conflicts
- **Predictable results** - Always same merge behavior

### Maintenance Benefits
- **Single template** - Only one file to update
- **Unified path handling** - Standard `.apm/` structure
- **Simplified validation** - One template structure
- **Reduced complexity** - Fewer moving parts

## 🚀 Next Steps

1. **Analyze current template** - Map all sections and variables
2. **Create section parser** - Extract header-based sections
3. **Build merge engine** - Implement basic merge logic
4. **Add safety systems** - Backup and validation
5. **Integrate with installer** - Hook into Step 10
6. **Test thoroughly** - Various Claude.md scenarios

## 📋 Implementation Tasks

### Phase 1: Analysis (Days 1-2)
- [ ] Map CLAUDE.md.markdown.template section structure
- [ ] Identify all variable substitution points
- [ ] Document section dependencies and hierarchies
- [ ] Create test cases for various existing Claude.md files

### Phase 2: Core Components (Days 3-5)
- [ ] Implement section-parser.sh
- [ ] Create template-analyzer.sh
- [ ] Build basic merge-engine.sh
- [ ] Develop backup-manager.sh
- [ ] Create merge-validator.sh

### Phase 3: Integration (Days 6-7)
- [ ] Integrate into installer Step 10
- [ ] Create standalone claude-merge.sh utility
- [ ] Add user experience messaging
- [ ] Test with various scenarios

### Phase 4: Validation (Days 8-10)
- [ ] Comprehensive testing with different Claude.md files
- [ ] Error handling and edge case testing
- [ ] Performance optimization
- [ ] Documentation and user guide creation

## 📝 Notes

This simplified approach is **much more achievable** and maintainable than the original multi-template version. The removal of Obsidian complexity makes this a straightforward implementation that can be completed quickly and reliably.

The key insight is that with only one template variant, we can focus on robust section-level merging rather than complex template selection and variant handling. This reduces the implementation complexity by approximately 60% while providing the same core functionality.

---

**Document Version**: 1.0  
**Last Updated**: 2025-01-18  
**Next Review**: Implementation Phase Start  