#!/usr/bin/env python3
"""
Test script for user_prompt_submit hook append functionality
"""

import json
import os
import subprocess
import sys
import tempfile
from datetime import datetime

def test_hook(prompt, append_text="", expected_contains=None):
    """Test the user_prompt_submit hook with given inputs"""
    
    # Prepare test input
    test_input = {
        "session_id": "test-session-123",
        "transcript_path": "/tmp/test-transcript.jsonl",
        "prompt": prompt
    }
    
    # Set environment variable for append text
    env = os.environ.copy()
    env['PROMPT_APPEND_TEXT'] = append_text
    
    # Run the hook
    hook_path = os.path.join(os.path.dirname(__file__), 'user_prompt_submit.py')
    process = subprocess.Popen(
        ['python3', hook_path],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=env,
        text=True
    )
    
    stdout, stderr = process.communicate(input=json.dumps(test_input))
    
    print(f"\n{'='*60}")
    print(f"Test Case: '{prompt}' + '{append_text}'")
    print(f"{'='*60}")
    print(f"Exit Code: {process.returncode}")
    
    if stdout:
        print(f"STDOUT:")
        try:
            output_json = json.loads(stdout)
            print(json.dumps(output_json, indent=2))
            
            # Check if expected content is in the output
            if expected_contains and 'hookSpecificOutput' in output_json:
                additional_context = output_json['hookSpecificOutput'].get('additionalContext', '')
                if expected_contains in additional_context:
                    print(f"✅ SUCCESS: Found expected text '{expected_contains}' in output")
                else:
                    print(f"❌ FAILED: Expected text '{expected_contains}' not found in output")
                    print(f"   Actual: '{additional_context}'")
        except json.JSONDecodeError:
            print(stdout)
    
    if stderr:
        print(f"STDERR: {stderr}")
    
    return process.returncode == 0

def main():
    """Run test cases"""
    print("Testing User Prompt Submit Hook - Append Functionality")
    print("=" * 60)
    
    # Test Case 1: No append text
    print("\n### Test 1: No append text configured")
    test_hook(
        prompt="Hello Claude",
        append_text="",
        expected_contains=None
    )
    
    # Test Case 2: Basic append
    print("\n### Test 2: Basic append text")
    test_hook(
        prompt="What is 2+2?",
        append_text="[Remember to be concise]",
        expected_contains="[Remember to be concise]"
    )
    
    # Test Case 3: Multi-line append
    print("\n### Test 3: Multi-line append text")
    test_hook(
        prompt="Write a function",
        append_text="[Follow APM guidelines]\n[Update backlog.md]",
        expected_contains="[Follow APM guidelines]"
    )
    
    # Test Case 4: Special characters
    print("\n### Test 4: Special characters in append text")
    test_hook(
        prompt="Explain this code",
        append_text='[Use "proper" quotes & symbols!]',
        expected_contains='[Use "proper" quotes & symbols!]'
    )
    
    # Test Case 5: Empty prompt with append
    print("\n### Test 5: Empty prompt with append text")
    test_hook(
        prompt="",
        append_text="[Default context]",
        expected_contains="[Default context]"
    )
    
    # Test Case 6: AP command with append
    print("\n### Test 6: AP command with append text")
    test_hook(
        prompt="/ap",
        append_text="[APM Framework Active]",
        expected_contains="[APM Framework Active]"
    )
    
    # Test Case 7: Whitespace handling
    print("\n### Test 7: Whitespace in append text")
    test_hook(
        prompt="Test prompt",
        append_text="   [Trimmed whitespace]   ",
        expected_contains="[Trimmed whitespace]"
    )
    
    print("\n" + "=" * 60)
    print("All tests completed!")

if __name__ == "__main__":
    main()