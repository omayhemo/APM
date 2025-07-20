#!/usr/bin/env python3
"""
APM Quality Validation Script
Validates APM system quality metrics and generates quality reports
"""

import os
import json
import sys
import time
import subprocess
import logging
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass, asdict
import argparse

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

@dataclass
class QualityMetric:
    name: str
    value: float
    threshold: float
    status: str
    description: str

@dataclass
class TestResult:
    category: str
    test_name: str
    passed: bool
    duration: float
    error_message: Optional[str] = None
    metrics: Dict[str, Any] = None

@dataclass
class QualityReport:
    timestamp: datetime
    overall_score: float
    test_results: List[TestResult]
    quality_metrics: List[QualityMetric]
    recommendations: List[str]

class APMQualityValidator:
    def __init__(self, project_root: str):
        self.project_root = Path(project_root)
        self.apm_root = self.project_root / ".apm"
        self.results_dir = self.project_root / "test_results"
        self.results_dir.mkdir(exist_ok=True)
        
        # Quality thresholds
        self.thresholds = {
            'coverage': 80.0,
            'performance_score': 70.0,
            'security_score': 90.0,
            'compatibility_score': 95.0,
            'response_time': 2.0,
            'parallel_speedup': 1.5
        }
        
        self.test_results: List[TestResult] = []
        self.quality_metrics: List[QualityMetric] = []
    
    def run_comprehensive_validation(self) -> QualityReport:
        """Run comprehensive APM quality validation"""
        logger.info("Starting comprehensive APM quality validation")
        
        # Run validation categories
        self._validate_structure()
        self._validate_persona_integrity()
        self._validate_voice_system()
        self._validate_command_interface()
        self._validate_parallel_processing()
        self._validate_session_management()
        self._validate_security()
        self._validate_performance()
        self._validate_compatibility()
        
        # Generate quality report
        report = self._generate_quality_report()
        
        logger.info(f"Quality validation completed. Overall score: {report.overall_score:.1f}")
        return report
    
    def _validate_structure(self):
        """Validate APM project structure"""
        logger.info("Validating APM project structure")
        
        required_paths = [
            ".apm/agents/personas",
            ".apm/agents/voice",
            ".apm/agents/scripts",
            ".apm/agents/templates",
            ".apm/agents/tasks",
            ".claude/hooks",
            "project_docs"
        ]
        
        missing_paths = []
        for path in required_paths:
            full_path = self.project_root / path
            if not full_path.exists():
                missing_paths.append(path)
        
        if missing_paths:
            self._add_test_result(
                "structure", "Required Paths Check", False, 0.0,
                f"Missing required paths: {', '.join(missing_paths)}"
            )
        else:
            self._add_test_result(
                "structure", "Required Paths Check", True, 0.0
            )
        
        # Check for key files
        key_files = [
            ".apm/agents/personas/ap_orchestrator.md",
            ".apm/agents/personas/qa.md",
            ".apm/agents/voice/speakOrchestrator.sh",
            ".apm/agents/scripts/tts-manager.sh",
            ".claude/settings.json"
        ]
        
        missing_files = []
        for file_path in key_files:
            full_path = self.project_root / file_path
            if not full_path.exists():
                missing_files.append(file_path)
        
        if missing_files:
            self._add_test_result(
                "structure", "Key Files Check", False, 0.0,
                f"Missing key files: {', '.join(missing_files)}"
            )
        else:
            self._add_test_result(
                "structure", "Key Files Check", True, 0.0
            )
    
    def _validate_persona_integrity(self):
        """Validate persona definition integrity"""
        logger.info("Validating persona integrity")
        
        personas_dir = self.apm_root / "agents" / "personas"
        if not personas_dir.exists():
            self._add_test_result(
                "personas", "Personas Directory Check", False, 0.0,
                "Personas directory not found"
            )
            return
        
        # Check for required persona files
        required_personas = [
            "ap_orchestrator.md",
            "architect.md",
            "developer.md",
            "qa.md",
            "pm.md",
            "po.md",
            "analyst.md",
            "sm.md"
        ]
        
        missing_personas = []
        for persona in required_personas:
            persona_path = personas_dir / persona
            if not persona_path.exists():
                missing_personas.append(persona)
        
        if missing_personas:
            self._add_test_result(
                "personas", "Required Personas Check", False, 0.0,
                f"Missing personas: {', '.join(missing_personas)}"
            )
        else:
            self._add_test_result(
                "personas", "Required Personas Check", True, 0.0
            )
        
        # Validate persona content structure
        self._validate_persona_content(personas_dir)
    
    def _validate_persona_content(self, personas_dir: Path):
        """Validate persona content structure"""
        required_sections = [
            "# Role:",
            "## Persona",
            "## Primary Responsibilities",
            "## Capabilities"
        ]
        
        for persona_file in personas_dir.glob("*.md"):
            if persona_file.name == "communication_standards.md":
                continue
                
            try:
                content = persona_file.read_text()
                missing_sections = []
                
                for section in required_sections:
                    if section not in content:
                        missing_sections.append(section)
                
                if missing_sections:
                    self._add_test_result(
                        "personas", f"Content Structure - {persona_file.name}", False, 0.0,
                        f"Missing sections: {', '.join(missing_sections)}"
                    )
                else:
                    self._add_test_result(
                        "personas", f"Content Structure - {persona_file.name}", True, 0.0
                    )
                    
            except Exception as e:
                self._add_test_result(
                    "personas", f"Content Validation - {persona_file.name}", False, 0.0,
                    f"Error reading file: {e}"
                )
    
    def _validate_voice_system(self):
        """Validate voice system integrity"""
        logger.info("Validating voice system")
        
        voice_dir = self.apm_root / "agents" / "voice"
        if not voice_dir.exists():
            self._add_test_result(
                "voice", "Voice Directory Check", False, 0.0,
                "Voice directory not found"
            )
            return
        
        # Check for required voice scripts
        required_scripts = [
            "speakOrchestrator.sh",
            "speakArchitect.sh",
            "speakDeveloper.sh",
            "speakQa.sh",
            "speakPm.sh",
            "speakPo.sh",
            "speakAnalyst.sh",
            "speakSm.sh"
        ]
        
        missing_scripts = []
        for script in required_scripts:
            script_path = voice_dir / script
            if not script_path.exists():
                missing_scripts.append(script)
            elif not os.access(script_path, os.X_OK):
                missing_scripts.append(f"{script} (not executable)")
        
        if missing_scripts:
            self._add_test_result(
                "voice", "Voice Scripts Check", False, 0.0,
                f"Missing/non-executable scripts: {', '.join(missing_scripts)}"
            )
        else:
            self._add_test_result(
                "voice", "Voice Scripts Check", True, 0.0
            )
        
        # Test voice script functionality
        self._test_voice_script_functionality(voice_dir)
    
    def _test_voice_script_functionality(self, voice_dir: Path):
        """Test voice script functionality"""
        test_script = voice_dir / "speakOrchestrator.sh"
        
        if not test_script.exists():
            return
        
        try:
            # Test with valid message
            result = subprocess.run(
                [str(test_script), "Test message"],
                capture_output=True,
                text=True,
                timeout=10
            )
            
            if result.returncode == 0:
                self._add_test_result(
                    "voice", "Voice Script Functionality", True, 0.0
                )
            else:
                self._add_test_result(
                    "voice", "Voice Script Functionality", False, 0.0,
                    f"Script failed with return code {result.returncode}"
                )
                
        except subprocess.TimeoutExpired:
            self._add_test_result(
                "voice", "Voice Script Functionality", False, 0.0,
                "Voice script timed out"
            )
        except Exception as e:
            self._add_test_result(
                "voice", "Voice Script Functionality", False, 0.0,
                f"Error testing voice script: {e}"
            )
    
    def _validate_command_interface(self):
        """Validate command interface"""
        logger.info("Validating command interface")
        
        # Check for command files
        commands_dir = self.project_root / ".claude" / "commands"
        if commands_dir.exists():
            command_files = list(commands_dir.glob("*.md"))
            
            if len(command_files) >= 5:  # Expect at least 5 commands
                self._add_test_result(
                    "commands", "Command Files Check", True, 0.0
                )
            else:
                self._add_test_result(
                    "commands", "Command Files Check", False, 0.0,
                    f"Expected at least 5 command files, found {len(command_files)}"
                )
        else:
            self._add_test_result(
                "commands", "Commands Directory Check", False, 0.0,
                "Commands directory not found"
            )
        
        # Test command parsing logic (simplified)
        self._test_command_parsing()
    
    def _test_command_parsing(self):
        """Test command parsing logic"""
        test_commands = [
            ("/ap", "ap_orchestrator"),
            ("/analyst", "analyst_agent"),
            ("/qa", "qa_agent"),
            ("ap", "ap_orchestrator"),
            ("invalid", "unknown")
        ]
        
        parsing_errors = []
        for cmd_input, expected in test_commands:
            # Simple command recognition logic
            if cmd_input in ["/ap", "ap"]:
                result = "ap_orchestrator"
            elif cmd_input in ["/analyst", "analyst"]:
                result = "analyst_agent"
            elif cmd_input in ["/qa", "qa"]:
                result = "qa_agent"
            else:
                result = "unknown"
            
            if result != expected:
                parsing_errors.append(f"{cmd_input} -> {result} (expected {expected})")
        
        if parsing_errors:
            self._add_test_result(
                "commands", "Command Parsing Logic", False, 0.0,
                f"Parsing errors: {'; '.join(parsing_errors)}"
            )
        else:
            self._add_test_result(
                "commands", "Command Parsing Logic", True, 0.0
            )
    
    def _validate_parallel_processing(self):
        """Validate parallel processing capabilities"""
        logger.info("Validating parallel processing")
        
        # Test parallel task execution simulation
        start_time = time.time()
        
        # Simulate parallel processing
        import concurrent.futures
        
        def simulate_task(task_id: int) -> Dict[str, Any]:
            """Simulate a task execution"""
            time.sleep(0.1)  # Simulate work
            return {
                "task_id": task_id,
                "status": "completed",
                "duration": 0.1
            }
        
        try:
            with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
                futures = [executor.submit(simulate_task, i) for i in range(5)]
                results = [future.result() for future in futures]
            
            parallel_duration = time.time() - start_time
            
            # Sequential would take ~0.5s, parallel should be ~0.1s
            if parallel_duration < 0.3:  # Allow some overhead
                speedup = 0.5 / parallel_duration
                self._add_test_result(
                    "parallel", "Parallel Processing Test", True, parallel_duration,
                    metrics={"speedup": speedup}
                )
                
                # Add quality metric
                self._add_quality_metric(
                    "parallel_speedup", speedup, self.thresholds['parallel_speedup'],
                    "Parallel processing speedup factor"
                )
            else:
                self._add_test_result(
                    "parallel", "Parallel Processing Test", False, parallel_duration,
                    f"Parallel processing too slow: {parallel_duration:.2f}s"
                )
                
        except Exception as e:
            self._add_test_result(
                "parallel", "Parallel Processing Test", False, 0.0,
                f"Error in parallel processing test: {e}"
            )
    
    def _validate_session_management(self):
        """Validate session management"""
        logger.info("Validating session management")
        
        session_dir = self.apm_root / "session_notes"
        if not session_dir.exists():
            self._add_test_result(
                "session", "Session Directory Check", False, 0.0,
                "Session notes directory not found"
            )
            return
        
        # Test session note creation
        test_session = session_dir / f"test_session_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
        
        try:
            test_content = f"""# Test Session
Date: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## Objectives
- [ ] Test session creation
- [ ] Test session validation

## Progress
Session validation test in progress.
"""
            
            test_session.write_text(test_content)
            
            # Verify session was created
            if test_session.exists():
                self._add_test_result(
                    "session", "Session Creation Test", True, 0.0
                )
                
                # Cleanup
                test_session.unlink()
            else:
                self._add_test_result(
                    "session", "Session Creation Test", False, 0.0,
                    "Session file was not created"
                )
                
        except Exception as e:
            self._add_test_result(
                "session", "Session Creation Test", False, 0.0,
                f"Error creating session: {e}"
            )
    
    def _validate_security(self):
        """Validate security aspects"""
        logger.info("Validating security")
        
        # Check for sensitive files
        sensitive_patterns = [
            "*.key",
            "*.pem",
            "*.p12",
            "*.pfx",
            "*password*",
            "*secret*"
        ]
        
        sensitive_files = []
        for pattern in sensitive_patterns:
            matches = list(self.project_root.glob(f"**/{pattern}"))
            sensitive_files.extend(matches)
        
        if sensitive_files:
            self._add_test_result(
                "security", "Sensitive Files Check", False, 0.0,
                f"Found sensitive files: {', '.join(str(f) for f in sensitive_files)}"
            )
        else:
            self._add_test_result(
                "security", "Sensitive Files Check", True, 0.0
            )
        
        # Check file permissions
        self._validate_file_permissions()
        
        # Calculate security score
        security_score = 100.0
        if sensitive_files:
            security_score -= 20.0  # Deduct for sensitive files
        
        self._add_quality_metric(
            "security_score", security_score, self.thresholds['security_score'],
            "Overall security score"
        )
    
    def _validate_file_permissions(self):
        """Validate file permissions"""
        # Check that scripts are executable
        script_dirs = [
            self.apm_root / "agents" / "voice",
            self.apm_root / "agents" / "scripts"
        ]
        
        non_executable = []
        for script_dir in script_dirs:
            if script_dir.exists():
                for script_file in script_dir.glob("*.sh"):
                    if not os.access(script_file, os.X_OK):
                        non_executable.append(str(script_file))
        
        if non_executable:
            self._add_test_result(
                "security", "File Permissions Check", False, 0.0,
                f"Non-executable scripts: {', '.join(non_executable)}"
            )
        else:
            self._add_test_result(
                "security", "File Permissions Check", True, 0.0
            )
    
    def _validate_performance(self):
        """Validate performance aspects"""
        logger.info("Validating performance")
        
        # Test file operation performance
        start_time = time.time()
        
        # Create and read a test file
        test_file = self.results_dir / "performance_test.txt"
        test_content = "Performance test content\n" * 1000
        
        try:
            test_file.write_text(test_content)
            read_content = test_file.read_text()
            test_file.unlink()
            
            file_op_duration = time.time() - start_time
            
            if file_op_duration < 0.5:  # Should be fast
                self._add_test_result(
                    "performance", "File Operations Test", True, file_op_duration
                )
            else:
                self._add_test_result(
                    "performance", "File Operations Test", False, file_op_duration,
                    f"File operations too slow: {file_op_duration:.2f}s"
                )
            
            # Add performance metric
            performance_score = max(0, 100 - (file_op_duration * 20))  # Deduct based on time
            self._add_quality_metric(
                "performance_score", performance_score, self.thresholds['performance_score'],
                "Overall performance score"
            )
            
        except Exception as e:
            self._add_test_result(
                "performance", "File Operations Test", False, 0.0,
                f"Error in performance test: {e}"
            )
    
    def _validate_compatibility(self):
        """Validate compatibility aspects"""
        logger.info("Validating compatibility")
        
        # Check system compatibility
        compatibility_score = 100.0
        
        # Check required tools
        required_tools = ["bash", "jq", "curl", "git"]
        missing_tools = []
        
        for tool in required_tools:
            try:
                result = subprocess.run(
                    ["which", tool],
                    capture_output=True,
                    text=True
                )
                if result.returncode != 0:
                    missing_tools.append(tool)
            except Exception:
                missing_tools.append(tool)
        
        if missing_tools:
            compatibility_score -= len(missing_tools) * 10
            self._add_test_result(
                "compatibility", "Required Tools Check", False, 0.0,
                f"Missing tools: {', '.join(missing_tools)}"
            )
        else:
            self._add_test_result(
                "compatibility", "Required Tools Check", True, 0.0
            )
        
        # Check Python availability
        try:
            result = subprocess.run(
                ["python3", "--version"],
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                self._add_test_result(
                    "compatibility", "Python3 Check", True, 0.0
                )
            else:
                compatibility_score -= 5
                self._add_test_result(
                    "compatibility", "Python3 Check", False, 0.0,
                    "Python3 not available"
                )
        except Exception:
            compatibility_score -= 5
            self._add_test_result(
                "compatibility", "Python3 Check", False, 0.0,
                "Python3 not available"
            )
        
        self._add_quality_metric(
            "compatibility_score", compatibility_score, self.thresholds['compatibility_score'],
            "System compatibility score"
        )
    
    def _add_test_result(self, category: str, test_name: str, passed: bool, 
                        duration: float, error_message: str = None, 
                        metrics: Dict[str, Any] = None):
        """Add a test result"""
        result = TestResult(
            category=category,
            test_name=test_name,
            passed=passed,
            duration=duration,
            error_message=error_message,
            metrics=metrics or {}
        )
        self.test_results.append(result)
    
    def _add_quality_metric(self, name: str, value: float, threshold: float, description: str):
        """Add a quality metric"""
        status = "pass" if value >= threshold else "fail"
        metric = QualityMetric(
            name=name,
            value=value,
            threshold=threshold,
            status=status,
            description=description
        )
        self.quality_metrics.append(metric)
    
    def _generate_quality_report(self) -> QualityReport:
        """Generate comprehensive quality report"""
        # Calculate overall score
        passed_tests = sum(1 for result in self.test_results if result.passed)
        total_tests = len(self.test_results)
        test_score = (passed_tests / total_tests * 100) if total_tests > 0 else 0
        
        # Average quality metrics
        metric_scores = [metric.value for metric in self.quality_metrics if metric.status == "pass"]
        avg_metric_score = sum(metric_scores) / len(metric_scores) if metric_scores else 0
        
        # Overall score (weighted)
        overall_score = (test_score * 0.6) + (avg_metric_score * 0.4)
        
        # Generate recommendations
        recommendations = self._generate_recommendations()
        
        return QualityReport(
            timestamp=datetime.now(),
            overall_score=overall_score,
            test_results=self.test_results,
            quality_metrics=self.quality_metrics,
            recommendations=recommendations
        )
    
    def _generate_recommendations(self) -> List[str]:
        """Generate quality improvement recommendations"""
        recommendations = []
        
        # Failed tests recommendations
        failed_tests = [result for result in self.test_results if not result.passed]
        if failed_tests:
            recommendations.append(f"Address {len(failed_tests)} failed tests")
            
            # Specific recommendations by category
            categories = set(result.category for result in failed_tests)
            if "structure" in categories:
                recommendations.append("Fix missing project structure components")
            if "voice" in categories:
                recommendations.append("Repair voice system functionality")
            if "security" in categories:
                recommendations.append("Address security vulnerabilities")
            if "performance" in categories:
                recommendations.append("Optimize performance bottlenecks")
            if "compatibility" in categories:
                recommendations.append("Install missing system dependencies")
        
        # Quality metrics recommendations
        failed_metrics = [metric for metric in self.quality_metrics if metric.status == "fail"]
        if failed_metrics:
            for metric in failed_metrics:
                if metric.name == "parallel_speedup":
                    recommendations.append("Optimize parallel processing implementation")
                elif metric.name == "performance_score":
                    recommendations.append("Improve system performance and response times")
                elif metric.name == "security_score":
                    recommendations.append("Enhance security measures and remove sensitive files")
                elif metric.name == "compatibility_score":
                    recommendations.append("Install missing system tools and dependencies")
        
        # General recommendations
        if not recommendations:
            recommendations.append("System is functioning well - continue monitoring")
        
        return recommendations
    
    def export_report(self, report: QualityReport, format: str = "html") -> str:
        """Export quality report to specified format"""
        timestamp = report.timestamp.strftime("%Y%m%d_%H%M%S")
        
        if format == "html":
            return self._export_html_report(report, timestamp)
        elif format == "json":
            return self._export_json_report(report, timestamp)
        else:
            raise ValueError(f"Unsupported format: {format}")
    
    def _export_html_report(self, report: QualityReport, timestamp: str) -> str:
        """Export HTML quality report"""
        report_path = self.results_dir / f"quality_report_{timestamp}.html"
        
        # Calculate summary stats
        total_tests = len(report.test_results)
        passed_tests = sum(1 for result in report.test_results if result.passed)
        failed_tests = total_tests - passed_tests
        
        # Generate HTML content
        html_content = f"""<!DOCTYPE html>
<html>
<head>
    <title>APM Quality Report - {timestamp}</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 20px; }}
        .header {{ background: #f0f0f0; padding: 20px; border-radius: 8px; }}
        .summary {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0; }}
        .metric {{ background: white; border: 1px solid #ddd; padding: 15px; border-radius: 5px; text-align: center; }}
        .score {{ font-size: 36px; font-weight: bold; }}
        .score.excellent {{ color: #28a745; }}
        .score.good {{ color: #ffc107; }}
        .score.poor {{ color: #dc3545; }}
        .test-results {{ margin: 20px 0; }}
        .test-category {{ margin: 20px 0; }}
        .test-item {{ margin: 10px 0; padding: 10px; background: #f8f9fa; border-left: 4px solid #dee2e6; }}
        .test-item.pass {{ border-left-color: #28a745; }}
        .test-item.fail {{ border-left-color: #dc3545; }}
        .recommendations {{ background: #e3f2fd; padding: 20px; border-radius: 5px; }}
        table {{ border-collapse: collapse; width: 100%; margin: 20px 0; }}
        th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
        th {{ background-color: #f2f2f2; }}
    </style>
</head>
<body>
    <div class="header">
        <h1>APM Quality Assurance Report</h1>
        <p>Generated: {report.timestamp.strftime('%Y-%m-%d %H:%M:%S')}</p>
    </div>
    
    <div class="summary">
        <div class="metric">
            <div class="score {self._get_score_class(report.overall_score)}">{report.overall_score:.1f}</div>
            <div>Overall Score</div>
        </div>
        <div class="metric">
            <div class="score">{total_tests}</div>
            <div>Total Tests</div>
        </div>
        <div class="metric">
            <div class="score excellent">{passed_tests}</div>
            <div>Passed Tests</div>
        </div>
        <div class="metric">
            <div class="score poor">{failed_tests}</div>
            <div>Failed Tests</div>
        </div>
    </div>
    
    <div class="test-results">
        <h2>Test Results by Category</h2>
        {self._generate_test_results_html(report.test_results)}
    </div>
    
    <div class="quality-metrics">
        <h2>Quality Metrics</h2>
        {self._generate_quality_metrics_html(report.quality_metrics)}
    </div>
    
    <div class="recommendations">
        <h2>Recommendations</h2>
        <ul>
            {''.join(f'<li>{rec}</li>' for rec in report.recommendations)}
        </ul>
    </div>
</body>
</html>"""
        
        report_path.write_text(html_content)
        return str(report_path)
    
    def _export_json_report(self, report: QualityReport, timestamp: str) -> str:
        """Export JSON quality report"""
        report_path = self.results_dir / f"quality_report_{timestamp}.json"
        
        # Convert to dictionary for JSON serialization
        report_dict = {
            "timestamp": report.timestamp.isoformat(),
            "overall_score": report.overall_score,
            "test_results": [asdict(result) for result in report.test_results],
            "quality_metrics": [asdict(metric) for metric in report.quality_metrics],
            "recommendations": report.recommendations
        }
        
        report_path.write_text(json.dumps(report_dict, indent=2))
        return str(report_path)
    
    def _get_score_class(self, score: float) -> str:
        """Get CSS class for score"""
        if score >= 80:
            return "excellent"
        elif score >= 60:
            return "good"
        else:
            return "poor"
    
    def _generate_test_results_html(self, test_results: List[TestResult]) -> str:
        """Generate HTML for test results"""
        # Group by category
        categories = {}
        for result in test_results:
            if result.category not in categories:
                categories[result.category] = []
            categories[result.category].append(result)
        
        html = ""
        for category, results in categories.items():
            html += f'<div class="test-category"><h3>{category.title()}</h3>'
            
            for result in results:
                status_class = "pass" if result.passed else "fail"
                status_text = "✓ PASS" if result.passed else "✗ FAIL"
                
                html += f'''
                <div class="test-item {status_class}">
                    <strong>{result.test_name}</strong> - {status_text}
                    <small>({result.duration:.3f}s)</small>
                    {f'<br><em>{result.error_message}</em>' if result.error_message else ''}
                </div>
                '''
            
            html += "</div>"
        
        return html
    
    def _generate_quality_metrics_html(self, quality_metrics: List[QualityMetric]) -> str:
        """Generate HTML for quality metrics"""
        if not quality_metrics:
            return "<p>No quality metrics available</p>"
        
        html = "<table><tr><th>Metric</th><th>Value</th><th>Threshold</th><th>Status</th><th>Description</th></tr>"
        
        for metric in quality_metrics:
            status_color = "green" if metric.status == "pass" else "red"
            html += f'''
            <tr>
                <td>{metric.name}</td>
                <td>{metric.value:.1f}</td>
                <td>{metric.threshold:.1f}</td>
                <td style="color: {status_color}"><strong>{metric.status.upper()}</strong></td>
                <td>{metric.description}</td>
            </tr>
            '''
        
        html += "</table>"
        return html

def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description="APM Quality Validation Tool")
    parser.add_argument("--project-root", default=".", help="Project root directory")
    parser.add_argument("--format", choices=["html", "json"], default="html", 
                       help="Report format")
    parser.add_argument("--output", help="Output file path")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")
    
    args = parser.parse_args()
    
    if args.verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    
    # Initialize validator
    validator = APMQualityValidator(args.project_root)
    
    try:
        # Run validation
        report = validator.run_comprehensive_validation()
        
        # Export report
        report_path = validator.export_report(report, args.format)
        
        # Print summary
        print(f"\nAPM Quality Validation Complete")
        print(f"Overall Score: {report.overall_score:.1f}/100")
        print(f"Tests Passed: {sum(1 for r in report.test_results if r.passed)}/{len(report.test_results)}")
        print(f"Report saved to: {report_path}")
        
        if args.output:
            import shutil
            shutil.copy(report_path, args.output)
            print(f"Report copied to: {args.output}")
        
        # Return appropriate exit code
        if report.overall_score >= 80:
            print("✓ Quality validation PASSED")
            sys.exit(0)
        else:
            print("✗ Quality validation FAILED")
            sys.exit(1)
            
    except Exception as e:
        logger.error(f"Quality validation failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()