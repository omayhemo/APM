#!/bin/bash
# Test script to verify QA report paths are correctly configured

echo "Testing QA Report Path Configuration"
echo "===================================="

# Test report generation location
TEST_REPORT="/mnt/c/Code/agentic-persona-mapping/project_docs/qa/reports/TEST_REPORT_$(date +%Y%m%d_%H%M%S).md"

# Create test report
cat > "$TEST_REPORT" << EOF
# Test QA Report

Generated on: $(date)

## Purpose
This is a test report to verify QA reports are being generated in the correct location.

## Expected Location
- Path: /project_docs/qa/reports/
- Full path: $TEST_REPORT

## Status
✅ Report successfully generated in correct location
EOF

# Verify report was created
if [ -f "$TEST_REPORT" ]; then
    echo "✅ SUCCESS: Test report created at correct location"
    echo "   Path: $TEST_REPORT"
    echo ""
    echo "Directory contents:"
    ls -la "/mnt/c/Code/agentic-persona-mapping/project_docs/qa/reports/"
    
    # Clean up test report
    rm "$TEST_REPORT"
    echo ""
    echo "✅ Test report cleaned up"
else
    echo "❌ FAILED: Could not create test report at expected location"
    exit 1
fi

echo ""
echo "QA Report Path Test Complete!"