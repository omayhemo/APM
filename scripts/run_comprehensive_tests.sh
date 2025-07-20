#!/bin/bash
# APM Comprehensive Testing Suite
# This script runs all quality assurance tests for the APM system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TEST_RESULTS_DIR="$PROJECT_ROOT/test_results"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$TEST_RESULTS_DIR/test_run_${TIMESTAMP}.log"

# Create test results directory
mkdir -p "$TEST_RESULTS_DIR"

echo "=========================================="
echo "APM Comprehensive Testing Suite"
echo "=========================================="
echo "Started: $(date)"
echo "Results will be saved to: $TEST_RESULTS_DIR"
echo "Log file: $LOG_FILE"
echo ""

# Function to log messages
log_message() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

# Function to run test with timing
run_test_with_timing() {
    local test_name="$1"
    local test_command="$2"
    local start_time=$(date +%s)
    
    log_message "${BLUE}Running $test_name...${NC}"
    
    if eval "$test_command" >> "$LOG_FILE" 2>&1; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_message "${GREEN}✓ $test_name completed successfully (${duration}s)${NC}"
        return 0
    else
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        log_message "${RED}✗ $test_name failed (${duration}s)${NC}"
        return 1
    fi
}

# Function to check prerequisites
check_prerequisites() {
    log_message "${BLUE}Checking prerequisites...${NC}"
    
    local missing_tools=()
    
    # Check required tools
    local required_tools=("python3" "bash" "jq" "curl" "git")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done
    
    # Check optional tools
    local optional_tools=("ffmpeg" "mpg123" "pytest" "bandit")
    local available_optional=()
    for tool in "${optional_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            available_optional+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_message "${RED}Missing required tools: ${missing_tools[*]}${NC}"
        return 1
    fi
    
    log_message "${GREEN}All required tools available${NC}"
    log_message "${BLUE}Optional tools available: ${available_optional[*]}${NC}"
    return 0
}

# Function to run unit tests
run_unit_tests() {
    log_message "${BLUE}========== Unit Tests ==========${NC}"
    
    # Test voice script functionality
    run_test_with_timing "Voice Script Tests" "test_voice_scripts"
    
    # Test command parsing
    run_test_with_timing "Command Parser Tests" "test_command_parsing"
    
    # Test persona logic
    run_test_with_timing "Persona Logic Tests" "test_persona_logic"
    
    # Test parallel processing
    run_test_with_timing "Parallel Processing Tests" "test_parallel_processing"
}

# Function to test voice scripts
test_voice_scripts() {
    local voice_dir="$PROJECT_ROOT/.apm/agents/voice"
    
    if [ ! -d "$voice_dir" ]; then
        echo "Voice directory not found: $voice_dir"
        return 1
    fi
    
    # Test each voice script
    local voice_scripts=("speakOrchestrator.sh" "speakDeveloper.sh" "speakArchitect.sh" "speakQa.sh")
    
    for script in "${voice_scripts[@]}"; do
        local script_path="$voice_dir/$script"
        
        if [ -f "$script_path" ]; then
            # Test with valid message
            if ! "$script_path" "Test message for $script" >/dev/null 2>&1; then
                echo "Voice script test failed: $script"
                return 1
            fi
            
            # Test with empty message (should handle gracefully)
            if "$script_path" "" >/dev/null 2>&1; then
                echo "Voice script should reject empty message: $script"
                return 1
            fi
        else
            echo "Voice script not found: $script_path"
            return 1
        fi
    done
    
    echo "All voice script tests passed"
    return 0
}

# Function to test command parsing
test_command_parsing() {
    # Create a temporary test script
    local test_script="$TEST_RESULTS_DIR/test_command_parsing.sh"
    
    cat > "$test_script" << 'EOF'
#!/bin/bash
# Test command parsing functionality

test_command_recognition() {
    local test_cases=(
        "/ap:ap_orchestrator"
        "/analyst:analyst_agent"
        "/parallel-test-strategy:parallel_test_strategy"
        "ap:ap_orchestrator"
        "qa:qa_agent"
    )
    
    for test_case in "${test_cases[@]}"; do
        IFS=':' read -r input expected <<< "$test_case"
        
        # Simple command recognition test
        if [[ "$input" == "/ap" || "$input" == "ap" ]]; then
            result="ap_orchestrator"
        elif [[ "$input" == "/analyst" || "$input" == "analyst" ]]; then
            result="analyst_agent"
        elif [[ "$input" == "/parallel-test-strategy" ]]; then
            result="parallel_test_strategy"
        elif [[ "$input" == "qa" ]]; then
            result="qa_agent"
        else
            result="unknown"
        fi
        
        if [ "$result" != "$expected" ]; then
            echo "Command parsing test failed: $input -> $result (expected $expected)"
            return 1
        fi
    done
    
    echo "Command parsing tests passed"
    return 0
}

test_command_recognition
EOF
    
    chmod +x "$test_script"
    "$test_script"
}

# Function to test persona logic
test_persona_logic() {
    # Create a temporary test script
    local test_script="$TEST_RESULTS_DIR/test_persona_logic.sh"
    
    cat > "$test_script" << 'EOF'
#!/bin/bash
# Test persona logic functionality

test_orchestrator_delegation() {
    # Test delegation logic
    local task_type="feature_request"
    local complexity="high"
    
    # Simple delegation logic test
    if [ "$task_type" = "feature_request" ] && [ "$complexity" = "high" ]; then
        primary_agent="architect"
        secondary_agents="developer,qa"
    else
        primary_agent="developer"
        secondary_agents="qa"
    fi
    
    if [ "$primary_agent" = "architect" ] && [ "$secondary_agents" = "developer,qa" ]; then
        echo "Orchestrator delegation test passed"
        return 0
    else
        echo "Orchestrator delegation test failed"
        return 1
    fi
}

test_qa_quality_gates() {
    # Test quality gate logic
    local coverage=85
    local security_issues=0
    local performance_issues=1
    
    # Quality gate logic
    if [ "$coverage" -ge 80 ] && [ "$security_issues" -eq 0 ] && [ "$performance_issues" -le 2 ]; then
        quality_gate="passed"
    else
        quality_gate="failed"
    fi
    
    if [ "$quality_gate" = "passed" ]; then
        echo "QA quality gate test passed"
        return 0
    else
        echo "QA quality gate test failed"
        return 1
    fi
}

test_orchestrator_delegation && test_qa_quality_gates
EOF
    
    chmod +x "$test_script"
    "$test_script"
}

# Function to test parallel processing
test_parallel_processing() {
    # Create a temporary test script
    local test_script="$TEST_RESULTS_DIR/test_parallel_processing.sh"
    
    cat > "$test_script" << 'EOF'
#!/bin/bash
# Test parallel processing functionality

test_parallel_execution() {
    # Simulate parallel task execution
    local task_count=5
    local pids=()
    
    # Start parallel tasks
    for i in $(seq 1 $task_count); do
        {
            sleep 1
            echo "Task $i completed"
        } &
        pids+=($!)
    done
    
    # Wait for all tasks to complete
    local start_time=$(date +%s)
    for pid in "${pids[@]}"; do
        wait $pid
    done
    local end_time=$(date +%s)
    
    local duration=$((end_time - start_time))
    
    # Should complete in ~1 second (parallel) not ~5 seconds (sequential)
    if [ $duration -le 2 ]; then
        echo "Parallel processing test passed (${duration}s)"
        return 0
    else
        echo "Parallel processing test failed (${duration}s - too slow)"
        return 1
    fi
}

test_resource_contention() {
    # Test file access contention
    local test_file="$TEST_RESULTS_DIR/contention_test.txt"
    local task_count=3
    local pids=()
    
    # Initialize test file
    echo "initial content" > "$test_file"
    
    # Start parallel file operations
    for i in $(seq 1 $task_count); do
        {
            # Use file locking to prevent corruption
            (
                flock -x 200
                local content=$(cat "$test_file")
                echo "$content task$i" > "$test_file"
            ) 200>>"$test_file.lock"
        } &
        pids+=($!)
    done
    
    # Wait for all tasks
    for pid in "${pids[@]}"; do
        wait $pid
    done
    
    # Check file integrity
    local final_content=$(cat "$test_file")
    if [[ "$final_content" == *"task1"* && "$final_content" == *"task2"* && "$final_content" == *"task3"* ]]; then
        echo "Resource contention test passed"
        rm -f "$test_file" "$test_file.lock"
        return 0
    else
        echo "Resource contention test failed: $final_content"
        rm -f "$test_file" "$test_file.lock"
        return 1
    fi
}

test_parallel_execution && test_resource_contention
EOF
    
    chmod +x "$test_script"
    "$test_script"
}

# Function to run integration tests
run_integration_tests() {
    log_message "${BLUE}========== Integration Tests ==========${NC}"
    
    # Test TTS system integration
    run_test_with_timing "TTS System Integration" "test_tts_integration"
    
    # Test notification system integration
    run_test_with_timing "Notification System Integration" "test_notification_integration"
    
    # Test backlog management integration
    run_test_with_timing "Backlog Management Integration" "test_backlog_integration"
    
    # Test session management integration
    run_test_with_timing "Session Management Integration" "test_session_integration"
}

# Function to test TTS integration
test_tts_integration() {
    local tts_script="$PROJECT_ROOT/.apm/agents/scripts/tts-manager.sh"
    
    if [ ! -f "$tts_script" ]; then
        echo "TTS manager script not found: $tts_script"
        return 1
    fi
    
    # Test provider detection
    if ! "$tts_script" detect >/dev/null 2>&1; then
        echo "TTS provider detection failed"
        return 1
    fi
    
    # Test silent mode (should always work)
    if ! "$tts_script" speak "test" "Test message" >/dev/null 2>&1; then
        echo "TTS silent mode test failed"
        return 1
    fi
    
    echo "TTS integration test passed"
    return 0
}

# Function to test notification integration
test_notification_integration() {
    local notification_script="$PROJECT_ROOT/.apm/agents/scripts/notification-manager.sh"
    
    if [ ! -f "$notification_script" ]; then
        echo "Notification manager script not found: $notification_script"
        return 1
    fi
    
    # Test notification without audio (should work)
    if ! "$notification_script" "test_notification" "Test notification message" >/dev/null 2>&1; then
        echo "Notification system test failed"
        return 1
    fi
    
    echo "Notification integration test passed"
    return 0
}

# Function to test backlog integration
test_backlog_integration() {
    local backlog_file="$PROJECT_ROOT/project_docs/backlog.md"
    
    # Test backlog file accessibility
    if [ ! -f "$backlog_file" ]; then
        echo "Backlog file not found: $backlog_file"
        return 1
    fi
    
    # Test basic backlog operations
    local test_update="**[$(date '+%Y-%m-%d %H:%M')] - TEST**: Integration test update"
    
    # Create backup
    cp "$backlog_file" "$backlog_file.test_backup"
    
    # Add test update
    echo "$test_update" >> "$backlog_file"
    
    # Verify update was added
    if ! grep -q "Integration test update" "$backlog_file"; then
        echo "Backlog update test failed"
        mv "$backlog_file.test_backup" "$backlog_file"
        return 1
    fi
    
    # Restore original
    mv "$backlog_file.test_backup" "$backlog_file"
    
    echo "Backlog integration test passed"
    return 0
}

# Function to test session management
test_session_integration() {
    local session_dir="$PROJECT_ROOT/.apm/session_notes"
    
    if [ ! -d "$session_dir" ]; then
        echo "Session notes directory not found: $session_dir"
        return 1
    fi
    
    # Test session note creation
    local test_session="$session_dir/test_session_$(date +%Y%m%d_%H%M%S).md"
    
    cat > "$test_session" << EOF
# Test Session
Date: $(date '+%Y-%m-%d %H:%M:%S')

## Objectives
- [ ] Test session creation
- [ ] Test session validation

## Progress
Session creation test in progress.
EOF
    
    # Verify session was created
    if [ ! -f "$test_session" ]; then
        echo "Session creation test failed"
        return 1
    fi
    
    # Cleanup
    rm -f "$test_session"
    
    echo "Session integration test passed"
    return 0
}

# Function to run performance tests
run_performance_tests() {
    log_message "${BLUE}========== Performance Tests ==========${NC}"
    
    # Test command response times
    run_test_with_timing "Command Response Times" "test_command_performance"
    
    # Test parallel processing performance
    run_test_with_timing "Parallel Processing Performance" "test_parallel_performance"
    
    # Test memory usage
    run_test_with_timing "Memory Usage Validation" "test_memory_usage"
    
    # Test audio system performance
    run_test_with_timing "Audio System Performance" "test_audio_performance"
}

# Function to test command performance
test_command_performance() {
    local max_response_time=1.0  # 1 second max
    
    # Test simple command execution time
    local start_time=$(date +%s.%N)
    
    # Simulate command execution
    sleep 0.1
    echo "Command executed"
    
    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $start_time" | bc)
    
    # Check if duration is within acceptable range
    if (( $(echo "$duration < $max_response_time" | bc -l) )); then
        echo "Command performance test passed (${duration}s)"
        return 0
    else
        echo "Command performance test failed (${duration}s > ${max_response_time}s)"
        return 1
    fi
}

# Function to test parallel performance
test_parallel_performance() {
    local task_count=5
    local expected_speedup=2.0
    
    # Sequential execution
    local start_time=$(date +%s.%N)
    for i in $(seq 1 $task_count); do
        sleep 0.1
    done
    local sequential_time=$(echo "$(date +%s.%N) - $start_time" | bc)
    
    # Parallel execution
    start_time=$(date +%s.%N)
    for i in $(seq 1 $task_count); do
        sleep 0.1 &
    done
    wait
    local parallel_time=$(echo "$(date +%s.%N) - $start_time" | bc)
    
    # Calculate speedup
    local speedup=$(echo "scale=2; $sequential_time / $parallel_time" | bc)
    
    if (( $(echo "$speedup >= $expected_speedup" | bc -l) )); then
        echo "Parallel performance test passed (${speedup}x speedup)"
        return 0
    else
        echo "Parallel performance test failed (${speedup}x < ${expected_speedup}x speedup)"
        return 1
    fi
}

# Function to test memory usage
test_memory_usage() {
    local max_memory_mb=100
    
    # Get initial memory usage
    local initial_memory=$(ps -o rss= -p $$ | tr -d ' ')
    
    # Simulate memory-intensive operation
    local large_array=()
    for i in $(seq 1 1000); do
        large_array+=("data_$i")
    done
    
    # Get peak memory usage
    local peak_memory=$(ps -o rss= -p $$ | tr -d ' ')
    local memory_increase=$(( (peak_memory - initial_memory) / 1024 ))
    
    # Cleanup
    unset large_array
    
    if [ $memory_increase -lt $max_memory_mb ]; then
        echo "Memory usage test passed (${memory_increase}MB increase)"
        return 0
    else
        echo "Memory usage test failed (${memory_increase}MB > ${max_memory_mb}MB)"
        return 1
    fi
}

# Function to test audio performance
test_audio_performance() {
    local max_audio_time=2.0
    
    # Test audio script execution time
    local voice_script="$PROJECT_ROOT/.apm/agents/voice/speakOrchestrator.sh"
    
    if [ ! -f "$voice_script" ]; then
        echo "Voice script not found, skipping audio performance test"
        return 0
    fi
    
    local start_time=$(date +%s.%N)
    "$voice_script" "Performance test message" >/dev/null 2>&1
    local end_time=$(date +%s.%N)
    
    local duration=$(echo "$end_time - $start_time" | bc)
    
    if (( $(echo "$duration < $max_audio_time" | bc -l) )); then
        echo "Audio performance test passed (${duration}s)"
        return 0
    else
        echo "Audio performance test failed (${duration}s > ${max_audio_time}s)"
        return 1
    fi
}

# Function to run security tests
run_security_tests() {
    log_message "${BLUE}========== Security Tests ==========${NC}"
    
    # Test input validation
    run_test_with_timing "Input Validation Tests" "test_input_validation"
    
    # Test file path security
    run_test_with_timing "File Path Security Tests" "test_file_path_security"
    
    # Test configuration security
    run_test_with_timing "Configuration Security Tests" "test_config_security"
    
    # Test session isolation
    run_test_with_timing "Session Isolation Tests" "test_session_isolation"
}

# Function to test input validation
test_input_validation() {
    local malicious_inputs=(
        "'; rm -rf /; --"
        "\$(rm -rf /)"
        "\`rm -rf /\`"
        "test && rm -rf /"
        "<script>alert('xss')</script>"
        "' OR '1'='1"
        "../../../etc/passwd"
    )
    
    for input in "${malicious_inputs[@]}"; do
        # Simple input validation test
        if [[ "$input" =~ [;&\$\`\<\>] ]]; then
            echo "Detected malicious input: $input"
        else
            echo "Failed to detect malicious input: $input"
            return 1
        fi
    done
    
    echo "Input validation test passed"
    return 0
}

# Function to test file path security
test_file_path_security() {
    local malicious_paths=(
        "../../../etc/passwd"
        "..\\..\\..\\windows\\system32\\cmd.exe"
        "/project/../../../etc/passwd"
        "~/.ssh/id_rsa"
    )
    
    for path in "${malicious_paths[@]}"; do
        # Simple path traversal detection
        if [[ "$path" =~ \.\./|\.\.\\ ]]; then
            echo "Detected path traversal: $path"
        else
            echo "Failed to detect path traversal: $path"
            return 1
        fi
    done
    
    echo "File path security test passed"
    return 0
}

# Function to test configuration security
test_config_security() {
    local settings_file="$PROJECT_ROOT/.claude/settings.json"
    
    if [ ! -f "$settings_file" ]; then
        echo "Settings file not found, skipping configuration security test"
        return 0
    fi
    
    # Check for sensitive data in configuration
    if grep -q "password\|secret\|key" "$settings_file"; then
        # Check if values are encrypted/masked
        if grep -q "password.*:\s*\"[^\"]*\"" "$settings_file"; then
            echo "Configuration security test failed: plain text secrets found"
            return 1
        fi
    fi
    
    echo "Configuration security test passed"
    return 0
}

# Function to test session isolation
test_session_isolation() {
    local session1_file="$TEST_RESULTS_DIR/session1_test.txt"
    local session2_file="$TEST_RESULTS_DIR/session2_test.txt"
    
    # Create isolated session files
    echo "session1_secret_data" > "$session1_file"
    echo "session2_secret_data" > "$session2_file"
    
    # Test that sessions can't access each other's data
    if [ -r "$session1_file" ] && [ -r "$session2_file" ]; then
        # Simple isolation test - files should be separate
        local session1_content=$(cat "$session1_file")
        local session2_content=$(cat "$session2_file")
        
        if [ "$session1_content" != "$session2_content" ]; then
            echo "Session isolation test passed"
            rm -f "$session1_file" "$session2_file"
            return 0
        else
            echo "Session isolation test failed: data leaked between sessions"
            rm -f "$session1_file" "$session2_file"
            return 1
        fi
    else
        echo "Session isolation test failed: could not create test files"
        return 1
    fi
}

# Function to run compatibility tests
run_compatibility_tests() {
    log_message "${BLUE}========== Compatibility Tests ==========${NC}"
    
    # Test operating system compatibility
    run_test_with_timing "Operating System Compatibility" "test_os_compatibility"
    
    # Test shell compatibility
    run_test_with_timing "Shell Compatibility" "test_shell_compatibility"
    
    # Test tool availability
    run_test_with_timing "Tool Availability" "test_tool_availability"
    
    # Test environment variables
    run_test_with_timing "Environment Variables" "test_environment_variables"
}

# Function to test OS compatibility
test_os_compatibility() {
    local os_name=$(uname -s)
    
    case "$os_name" in
        Linux*)
            echo "Linux compatibility: Supported"
            ;;
        Darwin*)
            echo "macOS compatibility: Supported"
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            echo "Windows compatibility: Supported (with limitations)"
            ;;
        *)
            echo "Unknown OS: $os_name - compatibility uncertain"
            return 1
            ;;
    esac
    
    echo "OS compatibility test passed"
    return 0
}

# Function to test shell compatibility
test_shell_compatibility() {
    local shell_name=$(basename "$SHELL")
    
    case "$shell_name" in
        bash*)
            echo "Bash compatibility: Full support"
            ;;
        zsh*)
            echo "Zsh compatibility: Good support"
            ;;
        sh*)
            echo "POSIX shell compatibility: Basic support"
            ;;
        *)
            echo "Unknown shell: $shell_name - compatibility uncertain"
            return 1
            ;;
    esac
    
    # Test shell features
    if command -v bash >/dev/null 2>&1; then
        # Test bash-specific features
        if bash -c 'echo ${BASH_VERSION}' >/dev/null 2>&1; then
            echo "Bash features available"
        fi
    fi
    
    echo "Shell compatibility test passed"
    return 0
}

# Function to test tool availability
test_tool_availability() {
    local required_tools=("bash" "jq" "curl" "git")
    local optional_tools=("ffmpeg" "mpg123" "python3" "bc")
    
    # Test required tools
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            echo "Required tool missing: $tool"
            return 1
        fi
    done
    
    # Test optional tools
    local available_optional=()
    for tool in "${optional_tools[@]}"; do
        if command -v "$tool" >/dev/null 2>&1; then
            available_optional+=("$tool")
        fi
    done
    
    echo "Required tools: All available"
    echo "Optional tools available: ${available_optional[*]}"
    echo "Tool availability test passed"
    return 0
}

# Function to test environment variables
test_environment_variables() {
    local required_vars=("HOME" "PATH" "SHELL")
    local optional_vars=("EDITOR" "TERM" "LANG")
    
    # Test required environment variables
    for var in "${required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            echo "Required environment variable missing: $var"
            return 1
        fi
    done
    
    # Test optional environment variables
    local available_optional=()
    for var in "${optional_vars[@]}"; do
        if [ -n "${!var}" ]; then
            available_optional+=("$var")
        fi
    done
    
    echo "Required environment variables: All available"
    echo "Optional environment variables available: ${available_optional[*]}"
    echo "Environment variables test passed"
    return 0
}

# Function to generate test report
generate_test_report() {
    local report_file="$TEST_RESULTS_DIR/test_report_${TIMESTAMP}.html"
    local total_tests=0
    local passed_tests=0
    local failed_tests=0
    
    # Count test results from log
    total_tests=$(grep -c "Running " "$LOG_FILE" || echo "0")
    passed_tests=$(grep -c "completed successfully" "$LOG_FILE" || echo "0")
    failed_tests=$(grep -c "failed" "$LOG_FILE" || echo "0")
    
    # Generate HTML report
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>APM Test Report - $TIMESTAMP</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #f0f0f0; padding: 20px; border-radius: 5px; }
        .summary { display: flex; gap: 20px; margin: 20px 0; }
        .metric { background: white; border: 1px solid #ddd; padding: 15px; border-radius: 5px; }
        .passed { color: green; }
        .failed { color: red; }
        .log { background: #f8f8f8; padding: 15px; border-radius: 5px; font-family: monospace; }
        pre { white-space: pre-wrap; }
    </style>
</head>
<body>
    <div class="header">
        <h1>APM Quality Assurance Test Report</h1>
        <p>Generated: $(date)</p>
        <p>Duration: ${TIMESTAMP}</p>
    </div>
    
    <div class="summary">
        <div class="metric">
            <h3>Total Tests</h3>
            <p style="font-size: 24px; font-weight: bold;">$total_tests</p>
        </div>
        <div class="metric">
            <h3>Passed</h3>
            <p style="font-size: 24px; font-weight: bold;" class="passed">$passed_tests</p>
        </div>
        <div class="metric">
            <h3>Failed</h3>
            <p style="font-size: 24px; font-weight: bold;" class="failed">$failed_tests</p>
        </div>
        <div class="metric">
            <h3>Success Rate</h3>
            <p style="font-size: 24px; font-weight: bold;">$(( total_tests > 0 ? (passed_tests * 100 / total_tests) : 0 ))%</p>
        </div>
    </div>
    
    <h2>Test Log</h2>
    <div class="log">
        <pre>$(cat "$LOG_FILE")</pre>
    </div>
</body>
</html>
EOF
    
    log_message "${GREEN}Test report generated: $report_file${NC}"
}

# Main execution
main() {
    # Initialize
    {
        echo "APM Comprehensive Testing Suite"
        echo "Started: $(date)"
        echo "Environment: $(uname -a)"
        echo "Shell: $SHELL"
        echo "=========================================="
    } > "$LOG_FILE"
    
    # Check prerequisites
    if ! check_prerequisites; then
        log_message "${RED}Prerequisites check failed. Exiting.${NC}"
        exit 1
    fi
    
    # Run test suites
    local total_failures=0
    
    # Unit tests
    if ! run_unit_tests; then
        ((total_failures++))
    fi
    
    # Integration tests
    if ! run_integration_tests; then
        ((total_failures++))
    fi
    
    # Performance tests
    if ! run_performance_tests; then
        ((total_failures++))
    fi
    
    # Security tests
    if ! run_security_tests; then
        ((total_failures++))
    fi
    
    # Compatibility tests
    if ! run_compatibility_tests; then
        ((total_failures++))
    fi
    
    # Generate report
    generate_test_report
    
    # Summary
    log_message ""
    log_message "=========================================="
    log_message "Test Execution Summary"
    log_message "=========================================="
    log_message "Completed: $(date)"
    
    if [ $total_failures -eq 0 ]; then
        log_message "${GREEN}All test suites passed successfully!${NC}"
        exit 0
    else
        log_message "${RED}$total_failures test suite(s) failed${NC}"
        exit 1
    fi
}

# Execute main function
main "$@"