#!/bin/bash

# Documentation Compliance Validator Script
# Part of the APM Documentation Enforcement System

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ROOT="{{PROJECT_ROOT}}"
APM_ROOT="{{APM_ROOT}}"
PROJECT_DOCS="{{PROJECT_DOCS}}"
COMPLIANCE_CACHE="{{APM_ROOT}}/.cache/compliance"

# Counters
TOTAL_FILES=0
COMPLIANT_FILES=0
VIOLATIONS=0
AUTO_FIXABLE=0

# Create cache directory if it doesn't exist
mkdir -p "$COMPLIANCE_CACHE"

# Function to validate file naming
validate_naming() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Skip special files
    if [[ "$filename" =~ ^(README|LICENSE|CHANGELOG|index)\.md$ ]]; then
        return 0
    fi
    
    # Check for UPPERCASE-KEBAB-CASE
    if [[ "$filename" =~ ^[A-Z][A-Z0-9-]*\.md$ ]]; then
        return 0
    else
        echo -e "${YELLOW}  ⚠️  Naming violation: $file${NC}"
        echo "     Expected: UPPERCASE-KEBAB-CASE"
        ((VIOLATIONS++))
        ((AUTO_FIXABLE++))
        return 1
    fi
}

# Function to validate frontmatter
validate_frontmatter() {
    local file="$1"
    
    # Check if file has frontmatter
    if head -n 1 "$file" | grep -q "^---$"; then
        # Extract frontmatter
        local frontmatter=$(sed -n '/^---$/,/^---$/p' "$file")
        
        # Check for required fields
        local has_title=$(echo "$frontmatter" | grep -q "^title:" && echo 1 || echo 0)
        local has_date=$(echo "$frontmatter" | grep -q "^date:" && echo 1 || echo 0)
        local has_author=$(echo "$frontmatter" | grep -q "^author:" && echo 1 || echo 0)
        
        if [[ $has_title -eq 0 ]] || [[ $has_date -eq 0 ]] || [[ $has_author -eq 0 ]]; then
            echo -e "${YELLOW}  ⚠️  Missing frontmatter fields: $file${NC}"
            [[ $has_title -eq 0 ]] && echo "     Missing: title"
            [[ $has_date -eq 0 ]] && echo "     Missing: date"
            [[ $has_author -eq 0 ]] && echo "     Missing: author"
            ((VIOLATIONS++))
            ((AUTO_FIXABLE++))
            return 1
        fi
    else
        echo -e "${YELLOW}  ⚠️  No frontmatter found: $file${NC}"
        ((VIOLATIONS++))
        ((AUTO_FIXABLE++))
        return 1
    fi
    
    return 0
}

# Function to validate heading structure
validate_headings() {
    local file="$1"
    
    # Check if file starts with H1
    local first_heading=$(grep -m 1 "^#" "$file")
    if [[ ! "$first_heading" =~ ^#[[:space:]] ]]; then
        echo -e "${YELLOW}  ⚠️  Document must start with H1: $file${NC}"
        ((VIOLATIONS++))
        return 1
    fi
    
    return 0
}

# Function to check document placement
check_placement() {
    local file="$1"
    local filename=$(basename "$file")
    local dir=$(dirname "$file")
    
    # Check specific document placements
    case "$filename" in
        "backlog.md")
            if [[ "$dir" != "$PROJECT_DOCS" ]]; then
                echo -e "${RED}  ❌ Misplaced backlog.md: $file${NC}"
                echo "     Should be in: $PROJECT_DOCS/"
                ((VIOLATIONS++))
                ((AUTO_FIXABLE++))
                return 1
            fi
            ;;
    esac
    
    return 0
}

# Function to scan and validate a directory
scan_directory() {
    local dir="$1"
    local indent="$2"
    
    echo -e "${indent}📁 Scanning: $dir"
    
    # Find all markdown files
    for file in "$dir"/*.md 2>/dev/null; do
        if [[ -f "$file" ]]; then
            ((TOTAL_FILES++))
            local file_compliant=true
            
            # Run validations
            validate_naming "$file" || file_compliant=false
            validate_frontmatter "$file" || file_compliant=false
            validate_headings "$file" || file_compliant=false
            check_placement "$file" || file_compliant=false
            
            if $file_compliant; then
                ((COMPLIANT_FILES++))
            fi
        fi
    done
    
    # Recurse into subdirectories
    for subdir in "$dir"/*/ 2>/dev/null; do
        if [[ -d "$subdir" ]] && [[ ! "$subdir" =~ (node_modules|\.git|vendor|archive) ]]; then
            scan_directory "$subdir" "$indent  "
        fi
    done
}

# Function to check required directories
check_required_directories() {
    echo -e "\n${BLUE}Checking required directories...${NC}"
    
    local required_dirs=(
        "$PROJECT_DOCS"
        "$PROJECT_DOCS/planning"
        "$PROJECT_DOCS/reports"
        "$PROJECT_DOCS/planning-architecture"
        "$PROJECT_DOCS/archives"
    )
    
    for dir in "${required_dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            echo -e "  ✅ Found: $dir"
        else
            echo -e "  ${RED}❌ Missing: $dir${NC}"
            ((VIOLATIONS++))
            ((AUTO_FIXABLE++))
        fi
    done
}

# Function to generate compliance report
generate_report() {
    local compliance_rate=0
    if [[ $TOTAL_FILES -gt 0 ]]; then
        compliance_rate=$((COMPLIANT_FILES * 100 / TOTAL_FILES))
    fi
    
    local auto_fix_rate=0
    if [[ $VIOLATIONS -gt 0 ]]; then
        auto_fix_rate=$((AUTO_FIXABLE * 100 / VIOLATIONS))
    fi
    
    echo -e "\n${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}           Documentation Compliance Report              ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    
    echo -e "\n📊 ${BLUE}Summary:${NC}"
    echo -e "  • Documents Scanned: $TOTAL_FILES"
    echo -e "  • Compliant Files: $COMPLIANT_FILES"
    echo -e "  • Violations Found: $VIOLATIONS"
    echo -e "  • Auto-Fixable: $AUTO_FIXABLE"
    
    echo -e "\n📈 ${BLUE}Metrics:${NC}"
    echo -e "  • Compliance Rate: ${compliance_rate}%"
    echo -e "  • Auto-Fix Rate: ${auto_fix_rate}%"
    
    if [[ $VIOLATIONS -eq 0 ]]; then
        echo -e "\n${GREEN}✅ All documents are compliant!${NC}"
    else
        echo -e "\n${YELLOW}⚠️  Action Required:${NC}"
        echo -e "  • Run with --fix flag to auto-fix $AUTO_FIXABLE issues"
        echo -e "  • Manual review needed for $((VIOLATIONS - AUTO_FIXABLE)) issues"
    fi
    
    # Save report to cache
    local report_file="$COMPLIANCE_CACHE/report-$(date +%Y%m%d-%H%M%S).txt"
    {
        echo "Documentation Compliance Report"
        echo "Generated: $(date)"
        echo "---"
        echo "Total Files: $TOTAL_FILES"
        echo "Compliant: $COMPLIANT_FILES"
        echo "Violations: $VIOLATIONS"
        echo "Auto-Fixable: $AUTO_FIXABLE"
        echo "Compliance Rate: ${compliance_rate}%"
    } > "$report_file"
    
    echo -e "\n📝 Report saved to: $report_file"
}

# Function to apply auto-fixes
apply_fixes() {
    echo -e "\n${BLUE}Applying auto-fixes...${NC}"
    
    # This is a placeholder for actual fix implementation
    echo -e "  ${YELLOW}Note: Auto-fix implementation pending${NC}"
    echo -e "  Would fix:"
    echo -e "    • File naming violations"
    echo -e "    • Missing frontmatter"
    echo -e "    • Document placement issues"
    echo -e "    • Missing directories"
}

# Main execution
main() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}     APM Documentation Compliance Validator v1.0        ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    
    # Parse arguments
    local mode="validate"
    if [[ "$1" == "--fix" ]] || [[ "$1" == "fix" ]]; then
        mode="fix"
    fi
    
    # Check required directories
    check_required_directories
    
    # Scan documentation
    echo -e "\n${BLUE}Scanning documentation structure...${NC}"
    
    if [[ -d "$PROJECT_DOCS" ]]; then
        scan_directory "$PROJECT_DOCS" ""
    else
        echo -e "${RED}Error: Project docs directory not found: $PROJECT_DOCS${NC}"
        exit 1
    fi
    
    if [[ -d "$APM_ROOT" ]]; then
        scan_directory "$APM_ROOT" ""
    fi
    
    # Apply fixes if requested
    if [[ "$mode" == "fix" ]] && [[ $AUTO_FIXABLE -gt 0 ]]; then
        apply_fixes
    fi
    
    # Generate report
    generate_report
}

# Run main function
main "$@"