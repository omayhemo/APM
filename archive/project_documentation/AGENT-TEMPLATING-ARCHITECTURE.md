# Agent Templating Architecture - Self-Hosting Model

## Executive Summary

The AP Mapping project will adopt a **self-hosting template system** where templates become the single source of truth for all agent files. This eliminates dual maintenance, ensures consistency, and creates a dogfooding validation model.

## Core Architecture Principles

### **1. Single Source of Truth**
- **Templates**: `/installer/templates/agents/` → Primary source files
- **Generated**: `/agents/` → Build artifacts created from templates
- **Distribution**: Templates travel with distribution for user installations

### **2. Self-Hosting Model**
- **Development**: Project uses its own template system
- **Validation**: Template system is validated through daily development use
- **Consistency**: Same process for development and deployment

### **3. Template-First Development**
```bash
# New Development Workflow
1. Edit template: installer/templates/agents/tasks/create-prd.md.template
2. Test changes: ./installer/install.sh . --defaults
3. Validate output: agents/tasks/create-prd.md
4. Commit template: git add installer/templates/agents/tasks/create-prd.md.template
```

## Implementation Strategy

### **Phase 1: Bootstrap Self-Hosting (Week 1)**

#### Generate Initial Templates
```bash
# Convert existing source files to templates
generate_initial_templates() {
    for source_file in $(find agents -name "*.md"); do
        template_file="installer/templates/agents/${source_file#agents/}.template"
        
        # Create template directory
        mkdir -p "$(dirname "$template_file")"
        
        # Convert paths to variables
        sed -E 's|/[^/]*/agents/|{{AP_ROOT}}/|g' "$source_file" | \
        sed -E 's|agents/tasks/|{{AP_TASKS}}/|g' | \
        sed -E 's|agents/checklists/|{{AP_CHECKLISTS}}/|g' | \
        sed -E 's|agents/data/|{{AP_DATA}}/|g' | \
        sed -E 's|agents/docs/|{{AP_DOCS}}/|g' | \
        sed -E 's|agents/personas/|{{AP_PERSONAS}}/|g' | \
        sed -E 's|agents/templates/|{{AP_TEMPLATES}}/|g' \
        > "$template_file"
    done
}
```

#### Bootstrap Process
```bash
# Bootstrap self-hosting
bootstrap_self_hosting() {
    echo "Bootstrapping self-hosting model..."
    
    # Step 1: Generate initial templates from current source
    generate_initial_templates
    
    # Step 2: Test template generation
    ./installer/install.sh . --defaults
    
    # Step 3: Validate generated content matches source
    validate_generated_content
    
    # Step 4: Switch to template-driven development
    echo "✅ Self-hosting bootstrap complete"
    echo "From now on, edit templates instead of source files"
}
```

### **Phase 2: Template Development Tooling (Week 2)**

#### Template Development Helper
```bash
# Template development utility
template_dev() {
    local action="$1"
    
    case "$action" in
        "test")
            echo "Testing template changes..."
            ./installer/install.sh . --defaults
            echo "✅ Template installation complete"
            ;;
        "validate")
            echo "Validating template syntax..."
            validate_all_templates
            echo "✅ Template validation complete"
            ;;
        "diff")
            echo "Showing changes from templates..."
            show_template_diff
            ;;
        "bootstrap")
            bootstrap_self_hosting
            ;;
    esac
}
```

#### Template Validation Framework
```bash
# Comprehensive template validation
validate_template_system() {
    local validation_failed=false
    
    # Check variable completeness
    for template in $(find installer/templates/agents -name "*.template"); do
        if has_undefined_variables "$template"; then
            echo "❌ Undefined variables in: $template"
            validation_failed=true
        fi
    done
    
    # Check path resolution
    if ! validate_path_resolution; then
        echo "❌ Path resolution validation failed"
        validation_failed=true
    fi
    
    # Check template syntax
    if ! validate_template_syntax; then
        echo "❌ Template syntax validation failed"
        validation_failed=true
    fi
    
    return $validation_failed
}
```

### **Phase 3: Build Process Integration (Week 3)**

#### Enhanced Build Distribution
```bash
# Self-hosting build process
build_distribution() {
    echo "Building with self-hosting model..."
    
    # Step 1: Generate agents/ from templates
    ./installer/install.sh . --defaults
    
    # Step 2: Validate generated content
    validate_generated_agents
    
    # Step 3: Package with templates
    cp -r agents "$DIST_DIR/.apm/"
    cp -r installer "$DIST_DIR/"
    
    echo "✅ Self-hosting distribution complete"
}
```

#### Template Variables
```bash
# Enhanced template variables (installer/install.sh)
AP_ROOT="$TARGET_DIR"
AP_CONFIG_FILE="$AP_ROOT/ide-ap-orchestrator.cfg.md"
AP_KB_FILE="$AP_ROOT/data/ap-kb.md"
AP_CHECKLISTS="$AP_ROOT/checklists"
AP_DATA="$AP_ROOT/data"
AP_PERSONAS="$AP_ROOT/personas"
AP_TASKS="$AP_ROOT/tasks"
AP_TEMPLATES="$AP_ROOT/templates"
AP_DOCS="$AP_ROOT/docs"
AP_DOCUMENTATION="$AP_ROOT/documentation"
AP_SCRIPTS="$AP_ROOT/scripts"
AP_VOICE="$AP_ROOT/voice"
AP_MONITORING="$AP_ROOT/monitoring"
AP_PYTHON="$AP_ROOT/python"
AP_SUBTASKS="$AP_ROOT/tasks/subtasks"
```

### **Phase 4: Self-Hosting Validation (Week 4)**

#### Complete Migration Process
```bash
# Migration to template-driven development
migrate_to_templates() {
    echo "Migrating to template-driven development..."
    
    # Step 1: Bootstrap templates
    bootstrap_self_hosting
    
    # Step 2: Validate all templates
    validate_template_system
    
    # Step 3: Test build process
    ./build-distribution.sh
    
    # Step 4: Archive old source files
    mkdir -p archive/pre-template-migration
    cp -r agents archive/pre-template-migration/
    
    echo "✅ Migration complete - templates are now source of truth"
}
```

## File Structure

### **Template Organization**
```
installer/templates/agents/
├── README.md.template
├── checklists/
│   ├── architect-checklist.md.template
│   ├── change-checklist.md.template
│   └── ... (16 more)
├── data/
│   └── ap-kb.md.template
├── docs/
│   ├── PARALLEL-HANDOFF-IMPLEMENTATION-REPORT.md.template
│   └── ... (8 more)
├── personas/
│   ├── analyst.md.template
│   └── ... (8 more)
└── tasks/
    ├── brainstorming.md.template
    ├── create-prd.md.template
    └── ... (80+ more)
```

### **Generated Structure**
```
agents/
├── README.md (generated)
├── checklists/ (generated)
├── data/ (generated)
├── docs/ (generated)
├── personas/ (generated)
├── tasks/ (generated)
├── voice/ (copied from installer/templates/voice/)
└── sounds/ (copied from installer/templates/sounds/)
```

## Development Workflow

### **Daily Development**
```bash
# Edit templates
vim installer/templates/agents/tasks/create-prd.md.template

# Test changes
template_dev test

# Validate
template_dev validate

# Commit templates (not generated files)
git add installer/templates/agents/tasks/create-prd.md.template
git commit -m "Update PRD creation task template"
```

### **Distribution Process**
```bash
# Build distribution
./build-distribution.sh

# Test distribution
cd dist/apm-v*.tar.gz
tar -xzf apm-v*.tar.gz
./installer/install.sh test-install

# Release
./.claude/scripts/release.sh 1.3.0
```

## Architectural Benefits

### **1. Single Source of Truth**
- **Templates**: Only source requiring maintenance
- **Generated**: Consistent across all installations
- **Distribution**: Same process for development and deployment

### **2. Self-Validation**
- **Dogfooding**: Development team validates template system daily
- **Quality**: Template issues caught during development
- **Reliability**: Production-tested template processing

### **3. Consistency**
- **Development**: Same template processing as users
- **Deployment**: Identical output across environments
- **Maintenance**: No dual maintenance burden

### **4. Scalability**
- **Performance**: Template cost amortized across development
- **Maintenance**: Template-only updates
- **Evolution**: Easy to add new templates and variables

## Risk Mitigation

### **Template Development Risks**
- **Mitigation**: Robust validation framework
- **Prevention**: Template development tooling
- **Recovery**: Bootstrap process for template regeneration

### **Build Process Risks**
- **Mitigation**: Comprehensive build validation
- **Prevention**: Template system testing
- **Recovery**: Rollback to previous template versions

### **Distribution Risks**
- **Mitigation**: Self-hosting validates template system
- **Prevention**: Dogfooding catches issues early
- **Recovery**: Template system is battle-tested

## Success Metrics

### **Completion Criteria**
- [ ] All 177 markdown files have template versions
- [ ] Template system generates consistent output
- [ ] Build process uses template-generated content
- [ ] Development team uses template-driven workflow
- [ ] Distribution process includes templates

### **Quality Metrics**
- [ ] Zero hardcoded paths in templates
- [ ] All template variables resolve correctly
- [ ] Template validation passes
- [ ] Self-hosting installation succeeds
- [ ] Distribution installation succeeds

## Implementation Commands

### **Bootstrap Self-Hosting**
```bash
# Start self-hosting transformation
./project_documentation/scripts/bootstrap-self-hosting.sh

# Or manual bootstrap
template_dev bootstrap
```

### **Template Development**
```bash
# Test template changes
template_dev test

# Validate all templates
template_dev validate

# Show template differences
template_dev diff
```

### **Build Process**
```bash
# Build distribution with self-hosting
./build-distribution.sh

# Test installation
cd dist/apm-v*.tar.gz && tar -xzf apm-v*.tar.gz
./installer/install.sh test-install
```

## Next Steps

### **Immediate Actions**
1. **Begin Phase 1**: Bootstrap self-hosting process
2. **Generate templates**: Convert all 177 source files
3. **Test template system**: Validate generated content
4. **Switch workflow**: Begin template-driven development

### **Implementation Priority**
1. **Critical**: Bootstrap self-hosting model
2. **High**: Template development tooling
3. **Medium**: Build process integration
4. **Low**: Performance optimization

## Conclusion

The self-hosting template system creates a **sustainable, scalable, and maintainable** architecture that:

1. **Eliminates dual maintenance** through single source of truth
2. **Ensures reliability** through dogfooding validation
3. **Provides consistency** across development and deployment
4. **Scales effectively** with contained complexity

This architecture provides a solid foundation for the AP Mapping project's continued evolution while maintaining the flexibility needed for diverse deployment scenarios.

**The template system becomes both the development environment and the deployment solution.**