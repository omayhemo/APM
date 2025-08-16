#!/bin/bash

# Test script to verify Wait command validation
echo "Testing Wait command validation..."

# Create a test script with Wait typo
TEST_SCRIPT="/tmp/test-wait-script.sh"
cat > "$TEST_SCRIPT" << 'EOF'
#!/bin/bash
echo "Starting test"
Wait
echo "Test complete"
EOF

echo "✅ Created test script with 'Wait' typo at $TEST_SCRIPT"

# Test the validation logic (extracted from install.sh)
if grep -q "^Wait$\|^Wait " "$TEST_SCRIPT" 2>/dev/null; then
    echo "✅ Validation correctly detected 'Wait' typo"
    
    # Test auto-fix
    if sed -i 's/^Wait /wait /g; s/^Wait$/wait/' "$TEST_SCRIPT" 2>/dev/null; then
        echo "✅ Auto-fix succeeded"
        
        # Verify fix
        if ! grep -q "^Wait$\|^Wait " "$TEST_SCRIPT" 2>/dev/null; then
            echo "✅ Verification passed - no more 'Wait' commands found"
            echo "✅ Contents after fix:"
            cat "$TEST_SCRIPT"
        else
            echo "❌ Verification failed - 'Wait' still present"
        fi
    else
        echo "❌ Auto-fix failed"
    fi
else
    echo "❌ Validation failed to detect 'Wait' typo"
fi

# Cleanup
rm -f "$TEST_SCRIPT"
echo "✅ Test complete"