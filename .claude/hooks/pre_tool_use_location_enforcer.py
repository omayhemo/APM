#!/usr/bin/env python3
"""
Document Location Enforcer - Pre-Tool Hook
Ensures all documents are created in their designated locations
Part of the APM Document Structure Enforcement System
"""

import json
import re
import os
from pathlib import Path
from datetime import datetime
from typing import Dict, Tuple, Optional, List

class DocumentLocationEnforcer:
    """
    Enforces strict document location standards by intercepting
    Write/Edit operations and correcting paths automatically.
    """
    
    def __init__(self, config_path: str = None):
        """Initialize the enforcer with configuration"""
        # Set project paths FIRST, before loading registry
        self.project_root = os.environ.get('PROJECT_ROOT', os.getcwd())
        self.project_docs = os.path.join(self.project_root, 'project_docs')
        self.session_notes = os.path.join(self.project_root, '.apm', 'session_notes')
        self.sequence_counters = {}
        
        # Now we can safely load the registry (which uses self.project_root)
        if config_path is None:
            config_path = os.path.join(
                os.environ.get('APM_ROOT', '.apm'),
                'config',
                'document-registry.json'
            )
        
        self.config_path = config_path
        self.registry = self.load_registry()
        
    def load_registry(self) -> dict:
        """Load document registry from JSON"""
        try:
            with open(self.config_path, 'r') as f:
                registry = json.load(f)
                # Perform variable substitution for paths
                registry = self.substitute_variables(registry)
                return registry
        except FileNotFoundError:
            print(f"⚠️ Document registry not found at {self.config_path}")
            return self.get_default_registry()
        except json.JSONDecodeError as e:
            print(f"⚠️ Invalid JSON in document registry: {e}")
            return self.get_default_registry()
    
    def substitute_variables(self, obj):
        """Recursively substitute template variables in the registry"""
        if isinstance(obj, str):
            # Substitute known variables
            obj = obj.replace('{{PROJECT_ROOT}}', self.project_root)
            obj = obj.replace('{{PROJECT_DOCS}}', self.project_docs)
            obj = obj.replace('{{APM_ROOT}}', os.path.join(self.project_root, '.apm'))
            obj = obj.replace('{{SESSION_NOTES_PATH}}', self.session_notes)
            return obj
        elif isinstance(obj, dict):
            return {k: self.substitute_variables(v) for k, v in obj.items()}
        elif isinstance(obj, list):
            return [self.substitute_variables(item) for item in obj]
        return obj
    
    def get_default_registry(self) -> dict:
        """Return minimal default registry if config is missing"""
        return {
            "enforcement": {
                "level": "strict",
                "allow_override": True,
                "override_flag": "--force-location"
            },
            "document_types": {
                "general": {
                    "location": f"{self.project_docs}/general/",
                    "type": "collection",
                    "allow_subfolders": True
                }
            },
            "uncertain_handling": {
                "action": "default",
                "default_location": f"{self.project_docs}/general/"
            }
        }
    
    def process_hook(self, tool_name: str, params: dict, context: dict = None) -> dict:
        """
        Main hook entry point - processes tool calls and enforces location standards
        
        Args:
            tool_name: Name of the tool being called (Write, Edit, Bash, etc.)
            params: Parameters passed to the tool
            context: Additional context (agent persona, etc.)
        
        Returns:
            Modified params with corrected file path or command
        """
        
        # Process Bash commands for directory creation
        if tool_name == 'Bash':
            return self.process_bash_command(params, context)
        
        # Only process document creation/editing tools
        if tool_name not in ['Write', 'Edit', 'MultiEdit']:
            return params
        
        file_path = params.get('file_path', '')
        
        # Skip non-markdown files
        if not file_path.endswith('.md'):
            return params
        
        # First, check for direct violations of epic/story placement
        # This catches when agents try to create files in wrong locations
        direct_corrections = {
            # Epic files in wrong location
            r'(.*/)?project_docs/planning-epics/': r'\1project_docs/planning/planning-epics/',
            # Story files in wrong location
            r'(.*/)?project_docs/planning-stories/': r'\1project_docs/planning/planning-stories/',
        }
        
        for pattern, replacement in direct_corrections.items():
            if re.search(pattern, file_path):
                corrected_path = re.sub(pattern, replacement, file_path)
                # Create a copy to avoid modifying original
                import copy
                modified_params = copy.deepcopy(params)
                modified_params['file_path'] = corrected_path
                modified_params['_location_corrected'] = True
                modified_params['_original_path'] = file_path
                modified_params['_correction_reason'] = 'direct_path_violation'
                
                agent = context.get('agent_persona', 'Unknown') if context else 'Unknown'
                print(f"📁 Path correction for {agent} agent:")
                print(f"   ❌ Blocked: {file_path}")
                print(f"   ✅ Corrected: {corrected_path}")
                return modified_params
        
        # Check for emergency override
        if self.check_override(params):
            self.log_override(file_path, params, context or {})
            print(f"⚠️ Location override used for: {file_path}")
            return params
        
        # Detect document type using multi-signal analysis
        doc_type, confidence = self.detect_document_type(file_path, params, context or {})
        
        # Handle uncertain detection
        if doc_type == 'uncertain' or confidence < 50:
            doc_type = self.handle_uncertain_type(file_path, params)
            if not doc_type:
                # User cancelled or default to general
                doc_type = 'general'
        
        # Get the correct path for this document type
        correct_path = self.get_correct_path(doc_type, file_path, params)
        
        # Only modify if path needs correction
        if correct_path != file_path:
            # Create a copy of params to avoid modifying the original
            import copy
            modified_params = copy.deepcopy(params)
            modified_params['file_path'] = correct_path
            modified_params['_location_corrected'] = True
            modified_params['_original_path'] = file_path
            modified_params['_doc_type'] = doc_type
            
            # Provide transparent feedback
            print(f"✅ Created at correct location: {correct_path}")
            
            return modified_params
        
        return params
    
    def detect_document_type(self, file_path: str, params: dict, context: dict) -> Tuple[str, float]:
        """
        Multi-signal document type detection with content-first approach
        
        Returns:
            Tuple of (document_type, confidence_score)
        """
        
        content = params.get('content', '')
        
        # PRIORITY 1: Check for explicit type markers in content
        if content:
            # Check for EPIC markers
            if any(marker in content for marker in [
                '# Epic:', '## Epic:', '### Epic:',
                'Epic Owner:', 'Epic Status:', 'Epic ID:',
                'Business Value:', 'Success Criteria:',
                'Child Stories:', 'Epic Progress:'
            ]):
                return 'epic', 95.0
            
            # Check for STORY markers
            if any(marker in content for marker in [
                '# Story:', '## Story:', '### Story:',
                'User Story:', 'Story Points:',
                'As a ', 'I want to', 'So that',
                'Acceptance Criteria:', 'Definition of Done:'
            ]):
                return 'story', 95.0
            
            # Check for TEST PLAN markers
            if any(marker in content for marker in [
                'Test Plan:', 'Test Cases:', 'Test Scenarios:',
                'Test Coverage:', 'Test Strategy:',
                'Expected Results:', 'Test Environment:'
            ]):
                return 'test_plan', 90.0
            
            # Check for PRD markers
            if any(marker in content for marker in [
                'Product Requirements', 'PRD:', 
                'Requirements Document', 'Functional Requirements:',
                'Non-Functional Requirements:', 'Success Metrics:'
            ]):
                return 'prd', 90.0
        
        # PRIORITY 2: Multi-signal scoring (original approach)
        scores = {}
        
        for doc_type, config in self.registry.get('document_types', {}).items():
            score = 0.0
            detection = config.get('detection', {})
            
            # Weight: 30% - Filename pattern matching (reduced from 40%)
            filename_score = self.score_filename_patterns(
                file_path, 
                detection.get('filename_patterns', [])
            )
            score += filename_score * 0.3
            
            # Weight: 50% - Content marker matching (increased from 40%)
            content_score = self.score_content_markers(
                params.get('content', ''),
                detection.get('content_markers', [])
            )
            score += content_score * 0.5
            
            # Weight: 20% - Agent persona hints
            agent_score = self.score_agent_hints(
                context.get('agent_persona', ''),
                detection.get('agent_hints', [])
            )
            score += agent_score * 0.2
            
            scores[doc_type] = score * 100  # Convert to percentage
        
        # Get best match
        if scores:
            best_match = max(scores.items(), key=lambda x: x[1])
            # If content strongly suggests a type, override filename-based detection
            if best_match[1] < 50 and content:
                # Do one more aggressive content check
                if 'epic' in content.lower() and 'epic' not in file_path.lower():
                    return 'epic', 75.0  # Force epic detection
                elif 'story' in content.lower() and 'story' not in file_path.lower():
                    return 'story', 75.0  # Force story detection
            return best_match[0], best_match[1]
        
        return 'uncertain', 0.0
    
    def score_filename_patterns(self, file_path: str, patterns: List[str]) -> float:
        """Score filename against patterns (0.0 to 1.0)"""
        if not patterns:
            return 0.0
        
        filename = os.path.basename(file_path)
        for pattern in patterns:
            try:
                if re.search(pattern, filename, re.IGNORECASE):
                    return 1.0
            except re.error:
                continue
        
        return 0.0
    
    def score_content_markers(self, content: str, markers: List[str]) -> float:
        """Score content against markers (0.0 to 1.0)"""
        if not markers or not content:
            return 0.0
        
        matches = 0
        content_lower = content.lower()
        
        for marker in markers:
            if marker.lower() in content_lower:
                matches += 1
        
        return matches / len(markers) if markers else 0.0
    
    def score_agent_hints(self, agent: str, hints: List[str]) -> float:
        """Score agent persona against hints (0.0 to 1.0)"""
        if not hints or not agent:
            return 0.0
        
        # Check for wildcard
        if '*' in hints:
            return 1.0
        
        # Check for exact or partial match
        agent_lower = agent.lower()
        for hint in hints:
            if hint.lower() in agent_lower or agent_lower in hint.lower():
                return 1.0
        
        return 0.0
    
    def get_correct_path(self, doc_type: str, original_path: str, params: dict) -> str:
        """
        Generate the correct path with full pattern enforcement
        
        Args:
            doc_type: Detected document type
            original_path: Original file path provided
            params: Tool parameters
        
        Returns:
            Corrected file path with proper location and naming
        """
        
        config = self.registry.get('document_types', {}).get(doc_type, {})
        
        if not config:
            # Fallback to general location
            return os.path.join(self.project_docs, 'general', os.path.basename(original_path))
        
        # Handle singleton documents (single file, not collection)
        if config.get('type') == 'singleton':
            return config['location']
        
        # Get base location for collections
        base_location = config['location']
        
        # Handle subfolder preservation if allowed
        subfolder = ''
        if config.get('allow_subfolders', False):
            subfolder = self.extract_valid_subfolder(original_path, config)
        
        # Generate filename with pattern enforcement
        filename = self.generate_filename(doc_type, config, original_path, params)
        
        # Construct full path
        if subfolder:
            full_path = os.path.join(base_location, subfolder, filename)
        else:
            full_path = os.path.join(base_location, filename)
        
        return full_path
    
    def extract_valid_subfolder(self, original_path: str, config: dict) -> str:
        """Extract valid subfolder from original path if it matches allowed patterns"""
        
        allowed_patterns = self.registry.get('subfolder_patterns', {}).get('allowed', [])
        
        # Extract path components
        path_parts = Path(original_path).parts
        
        for part in path_parts:
            for pattern in allowed_patterns:
                try:
                    if re.match(f"^{pattern}$", part):
                        return part
                except re.error:
                    continue
        
        return ''
    
    def generate_filename(self, doc_type: str, config: dict, original_path: str, params: dict) -> str:
        """
        Generate filename according to naming pattern rules
        
        Full pattern enforcement including:
        - Prefixes (STORY-, TEST-PLAN-, etc.)
        - Date stamps
        - Sequence numbers
        - Title formatting
        """
        
        naming = config.get('naming', {})
        
        # Handle fixed naming (no pattern)
        if naming == 'fixed' or isinstance(naming, str):
            return os.path.basename(original_path)
        
        # Get pattern or use default
        pattern = naming.get('pattern', '{title}.md')
        
        # Extract title from original filename or content
        original_name = Path(original_path).stem
        title = self.extract_title(original_name, params.get('content', ''))
        
        # Build replacement dictionary
        replacements = {
            '{date}': datetime.now().strftime('%Y-%m-%d'),
            '{timestamp}': datetime.now().strftime('%Y-%m-%d-%H-%M-%S'),
            '{year}': datetime.now().strftime('%Y'),
            '{quarter}': f"Q{(datetime.now().month - 1) // 3 + 1}",
            '{title}': self.format_title(title, naming.get('title_format', 'kebab-case')),
            '{component}': self.format_title(title, 'UPPERCASE-KEBAB'),
            '{service}': self.format_title(title, 'kebab-case'),
            '{environment}': 'dev',  # Default, could be extracted from content
            '{version}': 'v1.0.0',  # Default, could be extracted from content
            '{description}': self.format_title(title, 'Title-Case'),
            '{id}': self.get_next_id(doc_type, naming.get('id_format', '\\d{3}')),
            '{seq}': self.get_next_sequence(doc_type, naming.get('seq_format', '\\d{3}')),
            '{sprint}': self.extract_sprint_number(params.get('content', ''))
        }
        
        # Replace all placeholders in pattern
        filename = pattern
        for key, value in replacements.items():
            filename = filename.replace(key, value)
        
        return filename
    
    def extract_title(self, filename: str, content: str) -> str:
        """Extract meaningful title from filename or content"""
        
        # Clean up filename
        title = re.sub(r'[-_]', ' ', filename)
        title = re.sub(r'\d+', '', title)
        title = re.sub(r'\s+', ' ', title)
        title = title.strip()
        
        # If title is too short, try to extract from content
        if len(title) < 3 and content:
            # Look for first heading
            match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
            if match:
                heading = match.group(1)
                # Remove any prefixes like "STORY-101:"
                heading = re.sub(r'^[A-Z]+-\d+:\s*', '', heading)
                title = heading
        
        return title or 'untitled'
    
    def format_title(self, title: str, format_type: str) -> str:
        """Format title according to specified format"""
        
        if format_type == 'kebab-case':
            # Lowercase with hyphens
            formatted = re.sub(r'[^a-z0-9]+', '-', title.lower())
            return formatted.strip('-')
        
        elif format_type == 'UPPERCASE-KEBAB':
            # Uppercase with hyphens
            formatted = re.sub(r'[^A-Z0-9]+', '-', title.upper())
            return formatted.strip('-')
        
        elif format_type == 'Title-Case':
            # Title case with hyphens
            words = title.split()
            formatted = '-'.join(word.capitalize() for word in words)
            return formatted
        
        elif format_type == 'uppercase':
            return title.upper().replace(' ', '-')
        
        else:
            return title
    
    def get_next_sequence(self, doc_type: str, format_pattern: str) -> str:
        """Get next sequence number for document type (resets daily)"""
        
        # Create daily key
        date_key = datetime.now().strftime('%Y-%m-%d')
        key = f"{doc_type}:{date_key}"
        
        if key not in self.sequence_counters:
            # Count existing files for today
            count = self.count_existing_files(doc_type, date_key)
            self.sequence_counters[key] = count + 1
        else:
            self.sequence_counters[key] += 1
        
        # Extract digit count from pattern
        match = re.search(r'\\d\{(\d+)\}', format_pattern)
        digits = int(match.group(1)) if match else 3
        
        return str(self.sequence_counters[key]).zfill(digits)
    
    def get_next_id(self, doc_type: str, format_pattern: str) -> str:
        """Get next ID for document type (doesn't reset)"""
        
        key = f"{doc_type}_id"
        
        if key not in self.sequence_counters:
            # Find highest existing ID
            highest = self.find_highest_id(doc_type)
            self.sequence_counters[key] = highest + 1
        else:
            self.sequence_counters[key] += 1
        
        # Extract digit count from pattern
        match = re.search(r'\\d\{(\d+)\}', format_pattern)
        digits = int(match.group(1)) if match else 3
        
        return str(self.sequence_counters[key]).zfill(digits)
    
    def extract_sprint_number(self, content: str) -> str:
        """Extract sprint number from content if present"""
        
        match = re.search(r'Sprint[:\s]+(\d+)', content, re.IGNORECASE)
        if match:
            return match.group(1).zfill(2)
        return '01'
    
    def count_existing_files(self, doc_type: str, date_key: str) -> int:
        """Count existing files of this type for today"""
        
        config = self.registry.get('document_types', {}).get(doc_type, {})
        location = config.get('location', '')
        
        if not os.path.exists(location):
            return 0
        
        count = 0
        try:
            for file in os.listdir(location):
                if date_key in file and file.endswith('.md'):
                    count += 1
        except:
            pass
        
        return count
    
    def find_highest_id(self, doc_type: str) -> int:
        """Find highest ID used for this document type"""
        
        config = self.registry.get('document_types', {}).get(doc_type, {})
        location = config.get('location', '')
        pattern = config.get('naming', {}).get('pattern', '')
        
        if not os.path.exists(location) or not pattern:
            return 0
        
        highest = 0
        
        # Extract ID pattern from naming pattern
        id_match = re.search(r'\{id\}', pattern)
        if not id_match:
            return 0
        
        # Build regex to extract ID from filenames
        # Convert pattern to regex (simplified)
        regex_pattern = pattern.replace('{id}', r'(\d+)')
        regex_pattern = regex_pattern.replace('{title}', r'.*')
        regex_pattern = regex_pattern.replace('{date}', r'\d{4}-\d{2}-\d{2}')
        
        try:
            for file in os.listdir(location):
                match = re.search(regex_pattern, file)
                if match:
                    id_num = int(match.group(1))
                    highest = max(highest, id_num)
        except:
            pass
        
        return highest
    
    def handle_uncertain_type(self, file_path: str, params: dict) -> Optional[str]:
        """
        Handle uncertain document type detection
        
        In a real implementation, this would prompt the user interactively.
        For now, returns None to use default location.
        """
        
        handling = self.registry.get('uncertain_handling', {})
        
        if handling.get('action') == 'prompt':
            # In real implementation, this would be interactive
            print(f"\n{handling.get('prompt_message', 'Cannot determine document type')}")
            
            options = handling.get('options', [])
            for opt in options:
                print(f"  {opt['key']}. {opt['label']}")
            
            # For now, return None (would wait for user input in real implementation)
            return None
        
        return None
    
    def process_bash_command(self, params: dict, context: dict = None) -> dict:
        """
        Process Bash commands to prevent directory creation in wrong locations
        
        Specifically targets:
        - mkdir commands creating epics/planning-stories folders in wrong locations
        - Direct folder creation that violates document structure
        """
        
        command = params.get('command', '')
        
        # Check if this is a mkdir command
        if 'mkdir' not in command:
            return params
        
        # Define incorrect patterns and their corrections
        corrections = {
            # Epics folder in wrong location
            r'mkdir\s+(-p\s+)?(["\']?)(.*/)?project_docs/planning-epics/?(["\']?)': 
                r'mkdir \1\2\3project_docs/planning/planning-epics/\4',
            
            # Stories folder in wrong location  
            r'mkdir\s+(-p\s+)?(["\']?)(.*/)?project_docs/planning-stories/?(["\']?)':
                r'mkdir \1\2\3project_docs/planning/planning-stories/\4',
            
            # Epic file creation in wrong location (when creating parent dirs)
            r'mkdir\s+(-p\s+)?(["\']?)(.*/)?project_docs/planning-epics/':
                r'mkdir \1\2\3project_docs/planning/planning-epics/',
            
            # Story file creation in wrong location (when creating parent dirs)
            r'mkdir\s+(-p\s+)?(["\']?)(.*/)?project_docs/planning-stories/':
                r'mkdir \1\2\3project_docs/planning/planning-stories/',
        }
        
        original_command = command
        corrected = False
        
        # Apply corrections
        for pattern, replacement in corrections.items():
            if re.search(pattern, command, re.IGNORECASE):
                command = re.sub(pattern, replacement, command, flags=re.IGNORECASE)
                corrected = True
                break
        
        # Also check for file operations that might create directories
        file_corrections = {
            # Files being created in wrong epic location
            r'([>]+|touch|echo.*>+)\s*(["\']?)(.*/)?project_docs/planning-epics/':
                r'\1 \2\3project_docs/planning/planning-epics/',
            
            # Files being created in wrong story location
            r'([>]+|touch|echo.*>+)\s*(["\']?)(.*/)?project_docs/planning-stories/':
                r'\1 \2\3project_docs/planning/planning-stories/',
        }
        
        for pattern, replacement in file_corrections.items():
            if re.search(pattern, command, re.IGNORECASE):
                command = re.sub(pattern, replacement, command, flags=re.IGNORECASE)
                corrected = True
        
        if corrected:
            # Create a copy to avoid modifying original
            import copy
            modified_params = copy.deepcopy(params)
            modified_params['command'] = command
            modified_params['_location_corrected'] = True
            modified_params['_original_command'] = original_command
            
            # Log the correction
            agent = context.get('agent_persona', 'Unknown') if context else 'Unknown'
            print(f"📁 Directory structure enforced for {agent} agent")
            print(f"   ❌ Blocked: Creating folders directly under project_docs/")
            print(f"   ✅ Corrected: Folders will be created under project_docs/planning/")
            
            # Log for audit
            self.log_directory_correction(original_command, command, context)
            
            return modified_params
        
        return params
    
    def log_directory_correction(self, original_cmd: str, corrected_cmd: str, context: dict):
        """Log directory structure corrections for audit"""
        
        log_file = os.path.join(
            os.environ.get('APM_ROOT', '.apm'),
            'logs',
            'directory-corrections.json'
        )
        
        log_entry = {
            'timestamp': datetime.now().isoformat(),
            'agent': context.get('agent_persona', 'unknown') if context else 'unknown',
            'original_command': original_cmd,
            'corrected_command': corrected_cmd,
            'correction_type': 'directory_structure'
        }
        
        # Ensure log directory exists
        log_dir = os.path.dirname(log_file)
        os.makedirs(log_dir, exist_ok=True)
        
        # Load existing logs
        logs = []
        if os.path.exists(log_file):
            try:
                with open(log_file, 'r') as f:
                    logs = json.load(f)
            except:
                logs = []
        
        # Append new entry
        logs.append(log_entry)
        
        # Keep only last 1000 entries
        if len(logs) > 1000:
            logs = logs[-1000:]
        
        # Save updated logs
        try:
            with open(log_file, 'w') as f:
                json.dump(logs, f, indent=2)
        except Exception as e:
            print(f"⚠️ Failed to log directory correction: {e}")
    
    def check_override(self, params: dict) -> bool:
        """Check if emergency override flag is present"""
        
        override_flag = self.registry.get('enforcement', {}).get('override_flag', '--force-location')
        
        # Check for override flag in params
        return params.get('force_location', False) or override_flag in params.get('flags', [])
    
    def log_override(self, original_path: str, params: dict, context: dict):
        """Log emergency override usage for audit"""
        
        audit_config = self.registry.get('override_audit', {})
        log_file = audit_config.get('log_file', '.apm/logs/location-overrides.json')
        
        # Create log entry
        log_entry = {
            'timestamp': datetime.now().isoformat(),
            'agent': context.get('agent_persona', 'unknown'),
            'original_path': original_path,
            'override_path': params.get('file_path', original_path),
            'justification': params.get('justification', 'Not provided')
        }
        
        # Ensure log directory exists
        log_dir = os.path.dirname(log_file)
        os.makedirs(log_dir, exist_ok=True)
        
        # Load existing logs
        logs = []
        if os.path.exists(log_file):
            try:
                with open(log_file, 'r') as f:
                    logs = json.load(f)
            except:
                logs = []
        
        # Append new entry
        logs.append(log_entry)
        
        # Save updated logs
        try:
            with open(log_file, 'w') as f:
                json.dump(logs, f, indent=2)
        except Exception as e:
            print(f"⚠️ Failed to log override: {e}")
        
        # Check if alert threshold exceeded
        self.check_override_alerts(logs, audit_config)
    
    def check_override_alerts(self, logs: list, audit_config: dict):
        """Check if override usage exceeds alert threshold"""
        
        threshold = audit_config.get('alert_threshold', 5)
        
        # Count overrides in last 24 hours
        cutoff = datetime.now().timestamp() - 86400
        recent_count = 0
        
        for log in logs:
            try:
                log_time = datetime.fromisoformat(log['timestamp']).timestamp()
                if log_time > cutoff:
                    recent_count += 1
            except:
                continue
        
        if recent_count >= threshold:
            alert_msg = audit_config.get('alert_message', 'High override usage detected')
            alert_msg = alert_msg.replace('{count}', str(recent_count))
            print(f"⚠️ {alert_msg}")


# Hook entry point for the APM system
def pre_tool_use_hook(tool_name: str, params: dict, context: dict = None) -> dict:
    """
    Entry point for pre-tool-use hook
    
    This function is called by the APM system before any tool is executed.
    """
    
    try:
        enforcer = DocumentLocationEnforcer()
        return enforcer.process_hook(tool_name, params, context)
    except Exception as e:
        print(f"⚠️ Document location enforcement error: {e}")
        # Return params unchanged on error to avoid blocking operations
        return params


if __name__ == "__main__":
    # Test the enforcer
    print("Document Location Enforcer - Test Mode")
    
    enforcer = DocumentLocationEnforcer()
    
    # Test cases
    test_cases = [
        {
            'tool': 'Write',
            'params': {
                'file_path': 'test.md',
                'content': '# Test Plan\n\nTest cases for authentication...'
            },
            'context': {'agent_persona': 'QA'}
        },
        {
            'tool': 'Write',
            'params': {
                'file_path': 'my-story.md',
                'content': '# User Story\n\nAs a user, I want to...\n\n## Acceptance Criteria'
            },
            'context': {'agent_persona': 'Product Owner'}
        }
    ]
    
    for i, test in enumerate(test_cases, 1):
        print(f"\nTest {i}:")
        print(f"  Original: {test['params']['file_path']}")
        
        result = enforcer.process_hook(
            test['tool'],
            test['params'],
            test['context']
        )
        
        if result.get('_location_corrected'):
            print(f"  Corrected: {result['file_path']}")
            print(f"  Doc Type: {result.get('_doc_type')}")
        else:
            print(f"  No correction needed")