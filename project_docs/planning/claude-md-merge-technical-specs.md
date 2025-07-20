# Claude.md Merge System - Technical Specifications

**Project**: Agentic Persona Mapping  
**Component**: Claude.md Intelligent Merge System  
**Date**: 2025-01-18  
**Status**: Technical Planning  
**Priority**: High  

## 🏗 Architecture Overview

### System Components
```
.apm/.installer/claude-merge-system/
├── claude-merge.sh              # Main merge orchestrator
├── lib/
│   ├── section-parser.sh        # Parse Claude.md sections
│   ├── template-analyzer.sh     # Analyze template structure
│   ├── merge-engine.sh         # Core merge logic
│   ├── backup-manager.sh       # Backup and rollback
│   ├── merge-validator.sh      # Validate results
│   └── utils.sh                # Common utilities
├── config/
│   └── merge-config.sh         # Configuration settings
└── tests/
    ├── test-cases/             # Test Claude.md files
    └── run-tests.sh           # Test suite
```

## 🔍 Technical Requirements

### Input Requirements
- **Template File**: `CLAUDE.md.markdown.template`
- **Target File**: Existing `CLAUDE.md` (optional)
- **Variables**: Project-specific substitution variables
- **Configuration**: Merge behavior settings

### Output Requirements
- **Merged File**: Updated `CLAUDE.md` with preserved customizations
- **Backup File**: `.claude/backups/CLAUDE.md.backup.TIMESTAMP`
- **Merge Log**: Record of changes made
- **Validation Report**: Success/failure status

## 📊 Data Structures

### Section Structure
```bash
# Section representation
SECTION_NAME="## Environment Configuration"
SECTION_CONTENT="Content between headers..."
SECTION_TYPE="standard|custom|new|deprecated"
SECTION_HASH="md5hash_of_content"
```

### Template Mapping
```bash
# Template section mapping
declare -A TEMPLATE_SECTIONS
TEMPLATE_SECTIONS["## Environment Configuration"]="standard"
TEMPLATE_SECTIONS["## Session Management"]="standard"
TEMPLATE_SECTIONS["## Audio Notifications"]="standard"
```

### User Customizations
```bash
# User customization tracking
declare -A USER_SECTIONS
USER_SECTIONS["## My Custom Commands"]="custom"
USER_SECTIONS["## Project Notes"]="custom"
```

## 🔧 Core Algorithms

### Section Parser Algorithm
```bash
parse_sections() {
    local file="$1"
    local output_prefix="$2"
    
    awk -v prefix="$output_prefix" '
    BEGIN { 
        section_num = 0
        section_name = ""
        section_content = ""
    }
    
    /^## / { 
        if (section_name != "") {
            print_section(section_name, section_content, section_num, prefix)
            section_num++
        }
        section_name = $0
        section_content = ""
        next
    }
    
    { 
        section_content = section_content $0 "\n" 
    }
    
    END { 
        if (section_name != "") {
            print_section(section_name, section_content, section_num, prefix)
        }
    }
    
    function print_section(name, content, num, prefix) {
        gsub(/\n$/, "", content)  # Remove trailing newline
        printf "%s_SECTION_%d_NAME=%s\n", prefix, num, name
        printf "%s_SECTION_%d_CONTENT=%s\n", prefix, num, content
        printf "%s_SECTION_%d_HASH=%s\n", prefix, num, hash(content)
    }
    
    function hash(str) {
        # Simple hash function for content comparison
        cmd = "echo \"" str "\" | md5sum | cut -d' ' -f1"
        cmd | getline result
        close(cmd)
        return result
    }
    ' "$file"
}
```

### Merge Engine Algorithm
```bash
merge_sections() {
    local template_sections="$1"
    local target_sections="$2"
    local output_file="$3"
    
    # Load section data
    source "$template_sections"
    source "$target_sections"
    
    # Initialize output
    > "$output_file"
    
    # Process template sections
    for template_section in "${!TEMPLATE_SECTIONS[@]}"; do
        merge_single_section "$template_section" "$output_file"
    done
    
    # Add user custom sections
    for user_section in "${!USER_SECTIONS[@]}"; do
        if [[ "${USER_SECTIONS[$user_section]}" == "custom" ]]; then
            append_user_section "$user_section" "$output_file"
        fi
    done
}

merge_single_section() {
    local section_name="$1"
    local output_file="$2"
    
    # Check if section exists in target
    if section_exists_in_target "$section_name"; then
        # Merge with user customizations preserved
        merge_with_preservation "$section_name" "$output_file"
    else
        # Add new section from template
        add_template_section "$section_name" "$output_file"
    fi
}
```

### Variable Substitution Algorithm
```bash
substitute_variables() {
    local content="$1"
    local variables_file="$2"
    
    # Load variables
    source "$variables_file"
    
    # Perform substitutions
    echo "$content" | sed \
        -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
        -e "s/{{AP_ROOT}}/$AP_ROOT/g" \
        -e "s/{{SESSION_NOTES_PATH}}/$SESSION_NOTES_PATH/g" \
        -e "s/{{RULES_PATH}}/$RULES_PATH/g" \
        -e "s/{{ARCHIVE_PATH}}/$ARCHIVE_PATH/g"
}
```

## 🛡 Safety and Validation

### Backup Strategy
```bash
create_backup() {
    local file="$1"
    local backup_dir="$2"
    
    if [[ -f "$file" ]]; then
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_file="$backup_dir/$(basename "$file").backup.$timestamp"
        
        cp "$file" "$backup_file"
        echo "Backup created: $backup_file"
        return 0
    fi
    
    return 1
}

restore_backup() {
    local backup_file="$1"
    local target_file="$2"
    
    if [[ -f "$backup_file" ]]; then
        cp "$backup_file" "$target_file"
        echo "Restored from backup: $backup_file"
        return 0
    fi
    
    return 1
}
```

### Validation System
```bash
validate_merged_file() {
    local file="$1"
    
    # Check file exists and is readable
    [[ -f "$file" && -r "$file" ]] || return 1
    
    # Check basic structure
    validate_structure "$file" || return 1
    
    # Check for required sections
    validate_required_sections "$file" || return 1
    
    # Check for syntax errors
    validate_syntax "$file" || return 1
    
    return 0
}

validate_structure() {
    local file="$1"
    
    # Must have at least one ## header
    grep -q "^## " "$file" || return 1
    
    # Must not have malformed sections
    validate_section_integrity "$file" || return 1
    
    return 0
}

validate_required_sections() {
    local file="$1"
    local required_sections=(
        "## Environment Configuration"
        "## Session Management"
        "## Audio Notifications"
        "## AP Commands"
    )
    
    for section in "${required_sections[@]}"; do
        grep -q "^$section" "$file" || {
            echo "Missing required section: $section"
            return 1
        }
    done
    
    return 0
}
```

## 📋 Configuration Options

### Merge Behavior Configuration
```bash
# merge-config.sh
MERGE_STRATEGY="preserve_user"  # preserve_user|template_priority|interactive
BACKUP_RETENTION_DAYS=30
MAX_BACKUP_FILES=10
VALIDATION_LEVEL="strict"       # strict|moderate|lenient
AUTO_APPROVE_MINOR_CHANGES=true
LOG_LEVEL="info"               # debug|info|warn|error
```

### Section Classification Rules
```bash
# Standard sections (managed by template)
STANDARD_SECTIONS=(
    "## Environment Configuration"
    "## Session Management"
    "## Audio Notifications"
    "## AP Commands"
    "## Task Management"
    "## Backlog Management"
)

# Protected sections (never overwrite)
PROTECTED_SECTIONS=(
    "## Custom Commands"
    "## Project Notes"
    "## Team Guidelines"
    "## Local Configuration"
)
```

## 🔬 Testing Strategy

### Test Cases
```bash
# Test scenario matrix
TEST_CASES=(
    "new_installation"           # No existing CLAUDE.md
    "standard_update"           # Standard sections only
    "custom_sections"           # User added sections
    "modified_standard"         # User modified standard sections
    "deprecated_sections"       # Old sections to remove
    "variable_changes"          # Variable substitution changes
    "malformed_input"          # Corrupted CLAUDE.md
    "large_file"               # Performance testing
)
```

### Validation Tests
```bash
run_validation_tests() {
    local test_dir="$1"
    
    for test_case in "${TEST_CASES[@]}"; do
        echo "Running test: $test_case"
        
        # Setup test environment
        setup_test_case "$test_case" "$test_dir"
        
        # Run merge
        if run_merge_test "$test_case" "$test_dir"; then
            echo "✅ $test_case: PASSED"
        else
            echo "❌ $test_case: FAILED"
        fi
        
        # Cleanup
        cleanup_test_case "$test_case" "$test_dir"
    done
}
```

## ⚡ Performance Specifications

### Performance Targets
- **Merge Time**: < 2 seconds for typical files
- **Memory Usage**: < 10MB during merge
- **File Size**: Support files up to 1MB
- **Concurrent Operations**: Safe for multiple instances

### Optimization Strategies
- **Lazy Loading**: Only load sections as needed
- **Streaming Processing**: Process large files in chunks
- **Caching**: Cache template analysis results
- **Parallel Processing**: Process independent sections concurrently

## 🔌 Integration Points

### Installer Integration
```bash
# In install.sh around line 1207
if [[ -f "$CLAUDE_MD" ]]; then
    echo "Merging CLAUDE.md updates..."
    
    # Run merge system
    if "$INSTALLER_DIR/claude-merge-system/claude-merge.sh" \
       --template "$INSTALLER_DIR/templates/CLAUDE.md.markdown.template" \
       --target "$CLAUDE_MD" \
       --output "$CLAUDE_MD" \
       --variables "$INSTALLER_DIR/variables.tmp" \
       --config "$INSTALLER_DIR/claude-merge-system/config/merge-config.sh"; then
        
        echo "✅ CLAUDE.md merged successfully"
    else
        echo "❌ Merge failed, using template"
        replace_variables "$INSTALLER_DIR/templates/CLAUDE.md.markdown.template" "$CLAUDE_MD"
    fi
else
    echo "Creating new CLAUDE.md..."
    replace_variables "$INSTALLER_DIR/templates/CLAUDE.md.markdown.template" "$CLAUDE_MD"
fi
```

### AP Manager Integration
```bash
# Add to ap-manager.sh
update_claude_md() {
    local project_root="$1"
    
    if [[ -f "$project_root/.apm/.installer/claude-merge-system/claude-merge.sh" ]]; then
        "$project_root/.apm/.installer/claude-merge-system/claude-merge.sh" \
            --update-from-template
    fi
}
```

## 📝 Error Handling

### Error Categories
- **File System Errors**: Permissions, disk space, file locks
- **Parse Errors**: Malformed sections, invalid syntax
- **Merge Conflicts**: Irreconcilable differences
- **Validation Errors**: Invalid merged result
- **System Errors**: Memory, process limits

### Recovery Strategies
```bash
handle_merge_error() {
    local error_type="$1"
    local error_message="$2"
    
    case "$error_type" in
        "parse_error")
            echo "Parse error: $error_message"
            offer_manual_resolution
            ;;
        "merge_conflict")
            echo "Merge conflict: $error_message"
            offer_conflict_resolution
            ;;
        "validation_error")
            echo "Validation failed: $error_message"
            restore_from_backup
            ;;
        *)
            echo "Unknown error: $error_message"
            safe_exit_with_backup
            ;;
    esac
}
```

## 🚀 Future Enhancements

### Phase 2 Features
- **Interactive merge resolution** - User choice for conflicts
- **Merge preview** - Show changes before applying
- **Selective section merging** - Choose which sections to update
- **Merge history** - Track all changes over time

### Phase 3 Features
- **Semantic merging** - Understand content meaning
- **Auto-documentation** - Generate merge summaries
- **Integration with git** - Version control integration
- **Web interface** - GUI for complex merges

---

**Document Version**: 1.0  
**Last Updated**: 2025-01-18  
**Next Review**: Implementation Start  