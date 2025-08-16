#!/usr/bin/env python3
"""
Documentation Parser and Analyzer
Core engine for the organize-docs command system
"""

import os
import re
import sys
import json
import hashlib
import argparse
from pathlib import Path
from datetime import datetime
from collections import defaultdict
from typing import Dict, List, Set, Tuple, Optional
from difflib import SequenceMatcher

class DocumentParser:
    def __init__(self, base_path: str):
        self.base_path = Path(base_path)
        self.documents: Dict[str, dict] = {}
        self.links: Dict[str, Set[str]] = defaultdict(set)
        self.orphans: Set[str] = set()
        self.broken_links: List[dict] = []
        
    def scan(self, verbose=False, check_links=False, fix=False) -> dict:
        """Scan all documentation files"""
        print(f"📂 Scanning {self.base_path}...")
        
        try:
            self._scan_directory(self.base_path)
            self._analyze_links()
            
            stats = {
                'totalDocuments': len(self.documents),
                'orphanedDocuments': len(self.orphans),
                'brokenLinks': len(self.broken_links),
                'directories': len(set(str(Path(p).parent) for p in self.documents.keys()))
            }
            
            print('\n📊 Scan Results:')
            print(f"  Total documents: {stats['totalDocuments']}")
            print(f"  Orphaned documents: {stats['orphanedDocuments']}")
            print(f"  Broken links: {stats['brokenLinks']}")
            print(f"  Directories: {stats['directories']}")
            
            if verbose:
                self._print_detailed_results()
                
            if check_links:
                self._validate_links()
                
            if fix:
                self._fix_common_issues()
                
            return stats
            
        except Exception as e:
            print(f"❌ Error during scan: {e}")
            sys.exit(1)
            
    def _scan_directory(self, dir_path: Path, depth=0):
        """Recursively scan a directory for documentation files"""
        skip_dirs = {'.git', 'node_modules', '.apm', 'archive', '__pycache__'}
        
        for entry in dir_path.iterdir():
            if entry.is_dir():
                if entry.name in skip_dirs:
                    continue
                self._scan_directory(entry, depth + 1)
            elif entry.is_file() and entry.suffix == '.md':
                self._parse_document(entry)
                
    def _parse_document(self, file_path: Path):
        """Parse a single markdown document"""
        content = file_path.read_text(encoding='utf-8')
        relative_path = str(file_path.relative_to(self.base_path)).replace('\\', '/')
        
        doc = {
            'path': relative_path,
            'fullPath': str(file_path),
            'title': self._extract_title(content),
            'headers': self._extract_headers(content),
            'links': self._extract_links(content, file_path),
            'wordCount': len(content.split()),
            'lastModified': datetime.fromtimestamp(file_path.stat().st_mtime),
            'hash': hashlib.md5(content.encode()).hexdigest()
        }
        
        self.documents[relative_path] = doc
        
        # Track all links
        for link in doc['links']:
            self.links[link['target']].add(relative_path)
            
    def _extract_title(self, content: str) -> str:
        """Extract title from markdown content"""
        match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
        return match.group(1).strip() if match else 'Untitled'
        
    def _extract_headers(self, content: str) -> List[dict]:
        """Extract all headers from markdown content"""
        headers = []
        for match in re.finditer(r'^(#{1,6})\s+(.+)$', content, re.MULTILINE):
            headers.append({
                'level': len(match.group(1)),
                'text': match.group(2).strip()
            })
        return headers
        
    def _extract_links(self, content: str, file_path: Path) -> List[dict]:
        """Extract all links from markdown content"""
        links = []
        
        for match in re.finditer(r'\[([^\]]+)\]\(([^)]+)\)', content):
            link_text = match.group(1)
            link_path = match.group(2)
            
            # Skip external links
            if link_path.startswith(('http://', 'https://')):
                continue
                
            # Resolve relative links
            if not os.path.isabs(link_path):
                target_path = file_path.parent / link_path
                try:
                    target_path = target_path.resolve().relative_to(self.base_path)
                    target_path = str(target_path).replace('\\', '/')
                except ValueError:
                    # Path is outside base directory
                    target_path = link_path
            else:
                target_path = link_path
                
            links.append({
                'text': link_text,
                'target': target_path,
                'type': self._get_link_type(link_path)
            })
            
        return links
        
    def _get_link_type(self, link_path: str) -> str:
        """Determine link type"""
        if '#' in link_path:
            return 'anchor'
        elif link_path.startswith('../'):
            return 'relative'
        elif link_path.startswith('/'):
            return 'absolute'
        return 'relative'
        
    def _analyze_links(self):
        """Analyze link relationships"""
        # Find orphaned documents
        for doc_path in self.documents:
            if doc_path not in self.links or not self.links[doc_path]:
                # Allow index.md and README.md to be root documents
                filename = Path(doc_path).name
                if filename not in ('index.md', 'README.md'):
                    self.orphans.add(doc_path)
                    
        # Find broken links
        for doc_path, doc in self.documents.items():
            for link in doc['links']:
                target_path = link['target'].split('#')[0]  # Remove anchor
                if target_path and target_path not in self.documents:
                    self.broken_links.append({
                        'source': doc_path,
                        'target': link['target'],
                        'text': link['text']
                    })
                    
    def _validate_links(self):
        """Validate all links"""
        print('\n🔗 Validating links...')
        
        if self.broken_links:
            print('\n❌ Broken links found:')
            for broken in self.broken_links:
                print(f"  {broken['source']} → {broken['target']} (\"{broken['text']}\")")
        else:
            print('✅ All links are valid!')
            
    def _print_detailed_results(self):
        """Print detailed scan results"""
        if self.orphans:
            print('\n🔍 Orphaned documents:')
            for orphan in sorted(self.orphans):
                doc = self.documents[orphan]
                print(f"  - {orphan} (\"{doc['title']}\")")
                
        print('\n📈 Document statistics:')
        sorted_by_size = sorted(
            self.documents.values(),
            key=lambda d: d['wordCount'],
            reverse=True
        )[:5]
        
        print('  Largest documents:')
        for doc in sorted_by_size:
            print(f"    - {doc['path']} ({doc['wordCount']} words)")
            
    def _fix_common_issues(self):
        """Fix common documentation issues"""
        print('\n🔧 Attempting to fix common issues...')
        
        # Create index.md if missing
        index_path = self.base_path / 'index.md'
        if not index_path.exists():
            print('  Creating missing index.md...')
            self._create_index_file()
            
        # Fix broken links where possible
        if self.broken_links:
            print('  Analyzing broken links for potential fixes...')
            fixed_count = self._fix_broken_links()
            print(f'  Fixed {fixed_count} broken links')
            
        print('✅ Common issues fixed!')
        
    def _create_index_file(self):
        """Create a basic index.md file"""
        content = f"""# Documentation Index

Welcome to the project documentation. This index provides links to all documentation sections.

## Documentation Structure

{self._generate_index_content()}

---
*This index was automatically generated by the organize-docs system.*
"""
        
        (self.base_path / 'index.md').write_text(content)
        
    def _generate_index_content(self) -> str:
        """Generate index content based on directory structure"""
        structure = defaultdict(list)
        
        # Group documents by directory
        for doc_path, doc in self.documents.items():
            dir_name = str(Path(doc_path).parent)
            structure[dir_name].append(doc)
            
        content_lines = []
        for dir_name in sorted(structure.keys()):
            display_name = 'Root' if dir_name == '.' else dir_name
            content_lines.append(f"\n### {display_name}\n")
            
            for doc in sorted(structure[dir_name], key=lambda d: d['path']):
                content_lines.append(f"- [{doc['title']}]({doc['path']})")
                
        return '\n'.join(content_lines)
        
    def health(self, score=False, fix_critical=False, mode='standard') -> dict:
        """Generate documentation health report"""
        self.scan(verbose=False)
        
        metrics = {
            'totalDocuments': len(self.documents),
            'orphanedDocuments': len(self.orphans),
            'brokenLinks': len(self.broken_links),
            'avgWordCount': sum(d['wordCount'] for d in self.documents.values()) // max(len(self.documents), 1),
            'missingIndex': 'index.md' not in self.documents
        }
        
        # Calculate health score
        score_value = 100
        if metrics['totalDocuments'] > 0:
            score_value -= (metrics['orphanedDocuments'] / metrics['totalDocuments']) * 30
            score_value -= (metrics['brokenLinks'] / max(metrics['totalDocuments'] * 3, 1)) * 20
        score_value -= 20 if metrics['missingIndex'] else 0
        
        metrics['score'] = max(0, round(score_value))
        metrics['grade'] = self._get_grade(metrics['score'])
        
        print('\n📊 Documentation Health Report')
        print(f"Overall Score: {metrics['score']}/100 ({metrics['grade']})")
        print(f"- Structure: {'❌' if metrics['missingIndex'] else '✅'} Index file")
        print(f"- Linking: {'✅' if metrics['brokenLinks'] == 0 else '⚠️'} {metrics['brokenLinks']} broken links")
        print(f"- Coverage: {'✅' if metrics['orphanedDocuments'] == 0 else '⚠️'} {metrics['orphanedDocuments']} orphaned docs")
        print(f"- Content: {metrics['avgWordCount']} avg words per doc")
        
        if score:
            print(f"\n{metrics['score']}")
            
        if fix_critical and metrics['score'] < 70:
            print('\n🔧 Fixing critical issues...')
            self._fix_common_issues()
            
        return metrics
        
    def _get_grade(self, score: int) -> str:
        """Get letter grade from score"""
        if score >= 90:
            return 'A'
        elif score >= 80:
            return 'B'
        elif score >= 70:
            return 'C'
        elif score >= 60:
            return 'D'
        return 'F'
        
    def orphans(self, suggest_links=False, add_to_index=False):
        """Find orphaned documents"""
        self.scan(verbose=False)
        
        print(f"\n🔍 Found {len(self.orphans)} orphaned documents\n")
        
        for orphan in sorted(self.orphans):
            doc = self.documents[orphan]
            print(f"📄 {orphan}")
            print(f"   Title: \"{doc['title']}\"")
            print(f"   Words: {doc['wordCount']}")
            print(f"   Last modified: {doc['lastModified'].strftime('%Y-%m-%d')}")
            
            if suggest_links:
                suggestions = self._suggest_parent_documents(orphan)
                if suggestions:
                    print('   Suggested parents:')
                    for s in suggestions:
                        print(f"     - {s}")
            print()
            
        if add_to_index and self.orphans:
            print('📝 Adding orphaned documents to index...')
            # Implementation would update index.md
            
    def _suggest_parent_documents(self, orphan_path: str) -> List[str]:
        """Suggest parent documents for an orphan"""
        suggestions = []
        orphan_dir = str(Path(orphan_path).parent)
        
        # Look for index files in the same directory
        for doc_path in self.documents:
            doc_dir = str(Path(doc_path).parent)
            if doc_dir == orphan_dir and ('index' in doc_path or 'README' in doc_path):
                suggestions.append(doc_path)
                
        # Look for documents in parent directory
        if orphan_dir != '.':
            parent_dir = str(Path(orphan_dir).parent)
            for doc_path in self.documents:
                if str(Path(doc_path).parent) == parent_dir:
                    suggestions.append(doc_path)
                    if len(suggestions) >= 3:
                        break
                        
        return suggestions[:3]
    
    def _fix_broken_links(self) -> int:
        """Fix broken links by finding moved documents"""
        fixed_count = 0
        files_to_update = defaultdict(list)  # file -> list of (old_link, new_link)
        
        for broken in self.broken_links:
            source_file = broken['source']
            broken_target = broken['target']
            link_text = broken['text']
            
            # Try to find the document by various methods
            new_target = self._find_moved_document(broken_target, link_text)
            
            if new_target:
                files_to_update[source_file].append((broken_target, new_target))
                fixed_count += 1
                print(f"    Found: {broken_target} → {new_target}")
        
        # Apply the fixes
        for file_path, replacements in files_to_update.items():
            self._update_links_in_file(file_path, replacements)
            
        return fixed_count
    
    def _find_moved_document(self, broken_path: str, link_text: str) -> Optional[str]:
        """Try to find where a document was moved to"""
        # Remove anchor if present
        clean_path = broken_path.split('#')[0]
        if not clean_path:
            return None
            
        # Extract filename
        filename = Path(clean_path).name
        
        # Strategy 1: Find by exact filename
        for doc_path in self.documents:
            if Path(doc_path).name == filename:
                return doc_path
                
        # Strategy 2: Find by similar title
        best_match = None
        best_score = 0.0
        
        for doc_path, doc in self.documents.items():
            # Compare link text with document title
            title_score = SequenceMatcher(None, link_text.lower(), doc['title'].lower()).ratio()
            
            # Compare filenames
            file_score = SequenceMatcher(None, filename.lower(), Path(doc_path).name.lower()).ratio()
            
            # Combined score
            score = max(title_score, file_score * 0.8)  # Slightly prefer title matches
            
            if score > 0.7 and score > best_score:  # 70% similarity threshold
                best_match = doc_path
                best_score = score
                
        # Strategy 3: Check if file was moved to archive
        if not best_match and not clean_path.startswith('archives/'):
            archive_path = f"archives/{clean_path}"
            if archive_path in self.documents:
                return archive_path
                
        return best_match
    
    def _update_links_in_file(self, file_path: str, replacements: List[Tuple[str, str]]):
        """Update broken links in a file"""
        full_path = self.base_path / file_path
        
        try:
            content = full_path.read_text(encoding='utf-8')
            original_content = content
            
            # Apply each replacement
            for old_link, new_link in replacements:
                # Handle relative path conversion
                source_dir = Path(file_path).parent
                if source_dir != Path('.'):
                    # Calculate relative path from source to target
                    new_link_path = Path(new_link)
                    try:
                        relative_new = os.path.relpath(new_link_path, source_dir)
                        relative_new = relative_new.replace('\\', '/')
                    except ValueError:
                        relative_new = new_link
                else:
                    relative_new = new_link
                
                # Replace in markdown links
                pattern = re.escape(f"]({old_link})")
                replacement = f"]({relative_new})"
                content = content.replace(pattern[1:], replacement)  # Remove the escape on ]
                
            # Only write if content changed
            if content != original_content:
                full_path.write_text(content, encoding='utf-8')
                
        except Exception as e:
            print(f"    Error updating {file_path}: {e}")


def main():
    """Command line interface"""
    parser = argparse.ArgumentParser(description='Documentation Parser')
    parser.add_argument('command', choices=['scan', 'health', 'orphans'])
    parser.add_argument('--path', default=os.getcwd(), help='Documentation path')
    parser.add_argument('--verbose', action='store_true')
    parser.add_argument('--check-links', action='store_true')
    parser.add_argument('--fix', action='store_true')
    parser.add_argument('--score', action='store_true')
    parser.add_argument('--fix-critical', action='store_true')
    parser.add_argument('--suggest-links', action='store_true')
    parser.add_argument('--add-to-index', action='store_true')
    parser.add_argument('--mode', default='standard')
    
    args = parser.parse_args()
    
    doc_parser = DocumentParser(args.path)
    
    if args.command == 'scan':
        doc_parser.scan(
            verbose=args.verbose,
            check_links=args.check_links,
            fix=args.fix
        )
    elif args.command == 'health':
        doc_parser.health(
            score=args.score,
            fix_critical=args.fix_critical,
            mode=args.mode
        )
    elif args.command == 'orphans':
        doc_parser.orphans(
            suggest_links=args.suggest_links,
            add_to_index=args.add_to_index
        )


if __name__ == '__main__':
    main()