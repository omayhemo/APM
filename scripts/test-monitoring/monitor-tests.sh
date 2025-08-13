#!/bin/bash
# Simple test monitoring script for APM

echo "=== APM Test Monitor ==="
echo "Press Ctrl+C to stop"

while true; do
    clear
    echo "=== Test Status $(date) ==="
    
    # Check for test processes
    echo "Active test processes:"
    ps aux | grep -E "(jest|npm.*test|pytest)" | grep -v grep || echo "No active tests"
    
    echo -e "\nRecent test files:"
    find . -name "*test*" -type f -mtime -1 2>/dev/null | head -5 || echo "No recent test files"
    
    echo -e "\nQA Reports:"
    ls -la project_docs/reports/ 2>/dev/null | head -5 || echo "No QA reports found"
    
    echo -e "\nTest logs:"
    find . -name "*.log" -type f -mtime -1 2>/dev/null | head -3 || echo "No recent logs"
    
    sleep 5
done