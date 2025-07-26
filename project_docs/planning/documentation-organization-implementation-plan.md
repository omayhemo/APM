# Documentation Organization Feature - Detailed Implementation Plan

## Executive Summary

This implementation plan outlines a comprehensive documentation organization system for the APM framework. The system will analyze existing documentation, build a dependency graph, identify broken links and organizational issues, and provide automated reorganization with safe migration capabilities.

## 1. Core Algorithm for Document Analysis and Graph Building

### 1.1 Document Parser Engine

```python
class DocumentParser:
    """
    Core engine for parsing markdown documents and extracting metadata
    """
    
    def __init__(self):
        self.link_pattern = re.compile(r'\[([^\]]+)\]\(([^)]+)\)')
        self.header_pattern = re.compile(r'^(#{1,6})\s+(.+)$', re.MULTILINE)
        self.metadata_pattern = re.compile(r'^---\n(.*?)\n---', re.DOTALL)
        
    def parse_document(self, file_path: str) -> DocumentNode:
        """
        Parse a single document and extract all relevant metadata
        
        Returns:
            DocumentNode containing:
            - file_path: Absolute path
            - title: Document title from H1 or filename
            - headers: List of all headers with levels
            - links: List of all internal and external links
            - metadata: YAML frontmatter if present
            - content_hash: SHA256 of content for change detection
            - last_modified: File modification timestamp
            - word_count: Document word count
            - categories: Extracted from path or metadata
        """
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        node = DocumentNode(file_path=file_path)
        
        # Extract metadata
        node.metadata = self._extract_metadata(content)
        
        # Extract headers for structure
        node.headers = self._extract_headers(content)
        node.title = node.headers[0].text if node.headers else Path(file_path).stem
        
        # Extract all links
        node.links = self._extract_links(content, file_path)
        
        # Calculate content metrics
        node.content_hash = hashlib.sha256(content.encode()).hexdigest()
        node.word_count = len(content.split())
        node.last_modified = os.path.getmtime(file_path)
        
        # Derive categories from path
        node.categories = self._derive_categories(file_path)
        
        return node
```

### 1.2 Dependency Graph Builder

```python
class DependencyGraphBuilder:
    """
    Builds a directed graph of document dependencies based on links
    """
    
    def __init__(self):
        self.graph = nx.DiGraph()
        self.documents = {}  # path -> DocumentNode
        self.link_index = defaultdict(set)  # target -> sources
        
    def build_graph(self, doc_root: str) -> nx.DiGraph:
        """
        Recursively scan directory and build dependency graph
        
        Algorithm:
        1. Scan all .md files in directory tree
        2. Parse each document to extract links
        3. Build directed edges from source to target
        4. Identify cycles, orphans, and broken links
        5. Calculate centrality metrics for importance
        """
        
        # Phase 1: Document discovery and parsing
        for md_file in Path(doc_root).rglob("*.md"):
            if self._should_skip(md_file):
                continue
                
            doc_node = self.parser.parse_document(str(md_file))
            self.documents[str(md_file)] = doc_node
            self.graph.add_node(str(md_file), **doc_node.to_dict())
        
        # Phase 2: Link resolution and edge creation
        for source_path, doc_node in self.documents.items():
            for link in doc_node.links:
                target_path = self._resolve_link(link, source_path)
                
                if target_path and target_path in self.documents:
                    self.graph.add_edge(source_path, target_path, 
                                      link_text=link.text,
                                      link_type=link.type)
                    self.link_index[target_path].add(source_path)
                else:
                    doc_node.broken_links.append(link)
        
        # Phase 3: Graph analysis
        self._analyze_graph_metrics()
        
        return self.graph
        
    def _analyze_graph_metrics(self):
        """
        Calculate importance metrics for reorganization
        """
        # PageRank for document importance
        pagerank = nx.pagerank(self.graph)
        
        # Betweenness centrality for hub documents
        betweenness = nx.betweenness_centrality(self.graph)
        
        # In/out degree for reference patterns
        for node in self.graph.nodes():
            self.graph.nodes[node]['pagerank'] = pagerank.get(node, 0)
            self.graph.nodes[node]['betweenness'] = betweenness.get(node, 0)
            self.graph.nodes[node]['in_degree'] = self.graph.in_degree(node)
            self.graph.nodes[node]['out_degree'] = self.graph.out_degree(node)
```

## 2. Link Extraction and Validation Logic

### 2.1 Link Extractor

```python
class LinkExtractor:
    """
    Sophisticated link extraction with context awareness
    """
    
    def extract_links(self, content: str, source_path: str) -> List[Link]:
        """
        Extract all links with smart categorization
        
        Link Types:
        - internal_relative: ../reports/sprint-1.md
        - internal_absolute: /project_docs/reports/sprint-1.md
        - external_http: https://example.com
        - anchor: #section-name
        - email: mailto:user@example.com
        - file: file:///path/to/file
        """
        
        links = []
        
        # Markdown links: [text](url)
        for match in self.markdown_pattern.finditer(content):
            link = Link(
                text=match.group(1),
                url=match.group(2),
                position=match.start(),
                source_path=source_path
            )
            link.type = self._categorize_link(link.url)
            links.append(link)
        
        # Reference links: [text][ref] ... [ref]: url
        links.extend(self._extract_reference_links(content, source_path))
        
        # Inline URLs: https://example.com
        links.extend(self._extract_inline_urls(content, source_path))
        
        return links
```

### 2.2 Link Validator

```python
class LinkValidator:
    """
    Validates links and suggests fixes
    """
    
    def validate_link(self, link: Link, doc_root: str) -> ValidationResult:
        """
        Comprehensive link validation with fix suggestions
        
        Validation checks:
        1. Target exists
        2. Anchor exists in target
        3. Correct relative path
        4. Case sensitivity issues
        5. File extension presence
        """
        
        result = ValidationResult(link=link)
        
        if link.type == LinkType.EXTERNAL_HTTP:
            # Check HTTP status (with caching)
            result = self._validate_external_link(link)
            
        elif link.type in [LinkType.INTERNAL_RELATIVE, LinkType.INTERNAL_ABSOLUTE]:
            # Resolve to absolute path
            target_path = self._resolve_path(link.url, link.source_path, doc_root)
            
            if not os.path.exists(target_path):
                # Try to find similar files
                suggestions = self._find_similar_files(target_path, doc_root)
                result.status = ValidationStatus.BROKEN
                result.suggestions = suggestions
                
                # Check for common issues
                if self._is_case_mismatch(target_path):
                    result.fix_type = FixType.CASE_CORRECTION
                elif self._is_missing_extension(target_path):
                    result.fix_type = FixType.ADD_EXTENSION
            else:
                result.status = ValidationStatus.VALID
                
                # Check anchor if present
                if '#' in link.url:
                    anchor = link.url.split('#')[1]
                    if not self._anchor_exists(target_path, anchor):
                        result.status = ValidationStatus.BROKEN_ANCHOR
                        result.suggestions = self._find_similar_anchors(target_path, anchor)
        
        return result
```

## 3. Reorganization Rules Engine

### 3.1 Rule-Based Reorganizer

```python
class ReorganizationEngine:
    """
    Configurable rule engine for document reorganization
    """
    
    def __init__(self, config: ReorgConfig):
        self.rules = self._load_rules(config)
        self.strategies = {
            'topic_clustering': TopicClusteringStrategy(),
            'dependency_based': DependencyBasedStrategy(),
            'chronological': ChronologicalStrategy(),
            'hierarchical': HierarchicalStrategy()
        }
        
    def generate_reorganization_plan(self, graph: nx.DiGraph) -> ReorgPlan:
        """
        Generate reorganization plan based on active rules
        
        Default Rules:
        1. Group by document type (reports, plans, specs)
        2. Separate active from archived content
        3. Create index files for navigation
        4. Flatten deep hierarchies (max 3 levels)
        5. Consolidate scattered related docs
        """
        
        plan = ReorgPlan()
        
        # Apply categorization rules
        categories = self._categorize_documents(graph)
        
        # Apply each active rule
        for rule in self.rules:
            if rule.enabled:
                changes = rule.apply(graph, categories)
                plan.add_changes(changes)
        
        # Optimize based on strategy
        strategy = self.strategies[self.config.strategy]
        plan = strategy.optimize(plan, graph)
        
        # Validate plan coherence
        self._validate_plan(plan)
        
        return plan
        
    def _categorize_documents(self, graph: nx.DiGraph) -> Dict[str, List[str]]:
        """
        Smart categorization using multiple signals
        """
        categories = defaultdict(list)
        
        for node, data in graph.nodes(data=True):
            # Use explicit metadata
            if 'category' in data.get('metadata', {}):
                categories[data['metadata']['category']].append(node)
                continue
            
            # Infer from path
            path_parts = Path(node).parts
            if 'reports' in path_parts:
                categories['reports'].append(node)
            elif 'planning' in path_parts:
                categories['planning'].append(node)
            elif 'architecture' in path_parts:
                categories['architecture'].append(node)
            elif any(part.startswith('sprint-') for part in path_parts):
                categories['sprint-docs'].append(node)
            else:
                # Use NLP for topic extraction
                topic = self._extract_topic(data.get('content', ''))
                categories[topic].append(node)
        
        return categories
```

### 3.2 Reorganization Rules

```python
class ReorganizationRule:
    """
    Base class for reorganization rules
    """
    
    def apply(self, graph: nx.DiGraph, categories: Dict) -> List[Change]:
        raise NotImplementedError

class ArchiveOldContentRule(ReorganizationRule):
    """
    Archive documents older than threshold
    """
    
    def __init__(self, age_days: int = 90):
        self.age_threshold = time.time() - (age_days * 86400)
        
    def apply(self, graph: nx.DiGraph, categories: Dict) -> List[Change]:
        changes = []
        
        for node, data in graph.nodes(data=True):
            if data.get('last_modified', 0) < self.age_threshold:
                # Check if still referenced
                if graph.in_degree(node) == 0:
                    old_path = node
                    new_path = self._archive_path(node)
                    changes.append(MoveChange(old_path, new_path))
        
        return changes

class ConsolidateScatteredDocsRule(ReorganizationRule):
    """
    Consolidate related documents scattered across directories
    """
    
    def apply(self, graph: nx.DiGraph, categories: Dict) -> List[Change]:
        changes = []
        
        # Find clusters of highly connected documents
        clusters = self._find_document_clusters(graph)
        
        for cluster in clusters:
            if self._is_scattered(cluster):
                # Find optimal location
                target_dir = self._find_optimal_location(cluster, graph)
                
                for doc in cluster:
                    if Path(doc).parent != target_dir:
                        new_path = target_dir / Path(doc).name
                        changes.append(MoveChange(doc, str(new_path)))
        
        return changes
```

## 4. Safe Migration Strategy

### 4.1 Migration Orchestrator

```python
class MigrationOrchestrator:
    """
    Orchestrates safe document migration with rollback capability
    """
    
    def __init__(self, doc_root: str):
        self.doc_root = doc_root
        self.backup_manager = BackupManager(doc_root)
        self.link_updater = LinkUpdater()
        self.validator = MigrationValidator()
        
    def execute_migration(self, plan: ReorgPlan) -> MigrationResult:
        """
        Execute migration with transactional safety
        
        Process:
        1. Create full backup with manifest
        2. Validate plan feasibility
        3. Execute changes in dependency order
        4. Update all affected links
        5. Validate result integrity
        6. Commit or rollback
        """
        
        result = MigrationResult()
        
        # Phase 1: Backup
        backup_id = self.backup_manager.create_backup()
        result.backup_id = backup_id
        
        try:
            # Phase 2: Pre-validation
            validation = self.validator.validate_plan(plan)
            if not validation.is_valid:
                raise MigrationError(f"Plan validation failed: {validation.errors}")
            
            # Phase 3: Execute moves in safe order
            execution_order = self._calculate_execution_order(plan)
            
            for change in execution_order:
                self._execute_change(change)
                result.completed_changes.append(change)
                
                # Update links after each change
                affected_docs = self._find_affected_documents(change)
                for doc in affected_docs:
                    self.link_updater.update_links(doc, change)
            
            # Phase 4: Post-validation
            post_validation = self.validator.validate_structure(self.doc_root)
            if not post_validation.is_valid:
                raise MigrationError(f"Post-migration validation failed: {post_validation.errors}")
            
            # Phase 5: Commit
            self.backup_manager.commit_migration(backup_id)
            result.status = MigrationStatus.SUCCESS
            
        except Exception as e:
            # Rollback on any failure
            self.backup_manager.rollback(backup_id)
            result.status = MigrationStatus.ROLLED_BACK
            result.error = str(e)
            
        return result
```

### 4.2 Backup and Rollback System

```python
class BackupManager:
    """
    Manages backup creation and rollback operations
    """
    
    def create_backup(self) -> str:
        """
        Create timestamped backup with manifest
        
        Backup Structure:
        .backups/
        └── 2025-01-26-123456/
            ├── manifest.json
            ├── files/
            │   └── (original structure preserved)
            └── checksums.txt
        """
        
        backup_id = datetime.now().strftime("%Y-%m-%d-%H%M%S")
        backup_path = Path(self.doc_root) / '.backups' / backup_id
        
        # Create manifest
        manifest = {
            'backup_id': backup_id,
            'timestamp': datetime.now().isoformat(),
            'files': [],
            'total_size': 0
        }
        
        # Copy all markdown files
        for md_file in Path(self.doc_root).rglob("*.md"):
            rel_path = md_file.relative_to(self.doc_root)
            dest_path = backup_path / 'files' / rel_path
            
            dest_path.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(md_file, dest_path)
            
            # Add to manifest
            manifest['files'].append({
                'path': str(rel_path),
                'size': md_file.stat().st_size,
                'checksum': self._calculate_checksum(md_file),
                'modified': md_file.stat().st_mtime
            })
            manifest['total_size'] += md_file.stat().st_size
        
        # Save manifest
        with open(backup_path / 'manifest.json', 'w') as f:
            json.dump(manifest, f, indent=2)
        
        return backup_id
        
    def rollback(self, backup_id: str):
        """
        Restore from backup with verification
        """
        backup_path = Path(self.doc_root) / '.backups' / backup_id
        
        # Load and verify manifest
        with open(backup_path / 'manifest.json') as f:
            manifest = json.load(f)
        
        # Clear current structure
        for md_file in Path(self.doc_root).rglob("*.md"):
            if '.backups' not in str(md_file):
                md_file.unlink()
        
        # Restore from backup
        for file_info in manifest['files']:
            src = backup_path / 'files' / file_info['path']
            dest = Path(self.doc_root) / file_info['path']
            
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dest)
            
            # Verify checksum
            if self._calculate_checksum(dest) != file_info['checksum']:
                raise IntegrityError(f"Checksum mismatch for {file_info['path']}")
```

## 5. Report Generation Templates

### 5.1 Report Generator

```python
class ReportGenerator:
    """
    Generates comprehensive analysis and migration reports
    """
    
    def __init__(self):
        self.templates = {
            'analysis': AnalysisReportTemplate(),
            'migration': MigrationReportTemplate(),
            'health': HealthCheckTemplate()
        }
        
    def generate_analysis_report(self, graph: nx.DiGraph, issues: List[Issue]) -> str:
        """
        Generate pre-migration analysis report
        
        Sections:
        1. Executive Summary
        2. Document Statistics
        3. Link Analysis
        4. Organizational Issues
        5. Dependency Visualization
        6. Recommendations
        """
        
        report = []
        
        # Executive Summary
        report.append(self._generate_executive_summary(graph, issues))
        
        # Document Statistics
        stats = self._calculate_statistics(graph)
        report.append(self._format_statistics(stats))
        
        # Link Analysis
        link_analysis = self._analyze_links(graph)
        report.append(self._format_link_analysis(link_analysis))
        
        # Issue Details
        categorized_issues = self._categorize_issues(issues)
        report.append(self._format_issues(categorized_issues))
        
        # Dependency Visualization
        report.append(self._generate_dependency_viz(graph))
        
        # Recommendations
        recommendations = self._generate_recommendations(graph, issues)
        report.append(self._format_recommendations(recommendations))
        
        return '\n\n'.join(report)
```

### 5.2 Report Templates

```markdown
# Documentation Analysis Report

Generated: {{ timestamp }}
Analyzer Version: {{ version }}

## Executive Summary

- **Total Documents**: {{ total_docs }}
- **Total Links**: {{ total_links }}
- **Broken Links**: {{ broken_links }} ({{ broken_percentage }}%)
- **Orphaned Documents**: {{ orphaned_docs }}
- **Circular Dependencies**: {{ circular_deps }}
- **Average Document Age**: {{ avg_age }} days

### Key Findings

{{ #each key_findings }}
- {{ this }}
{{ /each }}

## Document Organization Health

### Current Structure
```
{{ directory_tree }}
```

### Identified Issues

#### Critical Issues ({{ critical_count }})
{{ #each critical_issues }}
- **{{ this.type }}**: {{ this.description }}
  - Location: `{{ this.location }}`
  - Impact: {{ this.impact }}
  - Suggested Fix: {{ this.fix }}
{{ /each }}

#### Warnings ({{ warning_count }})
{{ #each warnings }}
- {{ this.description }} in `{{ this.location }}`
{{ /each }}

## Link Analysis

### Broken Links by Document
{{ #each broken_links_by_doc }}
#### {{ this.document }}
- Links to fix: {{ this.count }}
{{ #each this.links }}
  - [ ] `{{ this.text }}` → `{{ this.target }}` {{ this.suggestion }}
{{ /each }}
{{ /each }}

## Recommendations

### Immediate Actions
1. Fix {{ broken_links }} broken links
2. Review {{ orphaned_docs }} orphaned documents
3. Resolve {{ circular_deps }} circular dependencies

### Structural Improvements
{{ #each structural_recommendations }}
- {{ this }}
{{ /each }}

## Proposed Reorganization

Based on the analysis, we recommend the following reorganization:

### New Structure
```
{{ proposed_structure }}
```

### Migration Impact
- Documents to move: {{ docs_to_move }}
- Links to update: {{ links_to_update }}
- Estimated time: {{ estimated_time }}

---
*Use `--apply-reorganization` to execute these changes*
```

## 6. Performance Considerations

### 6.1 Optimization Strategies

```python
class PerformanceOptimizer:
    """
    Optimizations for large documentation sets
    """
    
    def __init__(self):
        self.cache = LRUCache(maxsize=1000)
        self.thread_pool = ThreadPoolExecutor(max_workers=cpu_count())
        
    def optimize_parsing(self, file_paths: List[str]) -> List[DocumentNode]:
        """
        Parallel parsing with caching
        """
        # Check cache first
        uncached_paths = [p for p in file_paths if p not in self.cache]
        
        # Parse uncached files in parallel
        if uncached_paths:
            with self.thread_pool as executor:
                futures = {executor.submit(self.parse_single, path): path 
                          for path in uncached_paths}
                
                for future in as_completed(futures):
                    path = futures[future]
                    try:
                        doc = future.result()
                        self.cache[path] = doc
                    except Exception as e:
                        logger.error(f"Failed to parse {path}: {e}")
        
        # Return all documents
        return [self.cache[p] for p in file_paths]
        
    def optimize_link_validation(self, links: List[Link]) -> List[ValidationResult]:
        """
        Batch validation with connection pooling
        """
        # Group by domain for external links
        external_by_domain = defaultdict(list)
        internal_links = []
        
        for link in links:
            if link.type == LinkType.EXTERNAL_HTTP:
                domain = urlparse(link.url).netloc
                external_by_domain[domain].append(link)
            else:
                internal_links.append(link)
        
        results = []
        
        # Validate external links with connection reuse
        with requests.Session() as session:
            session.mount('https://', HTTPAdapter(max_retries=3))
            
            for domain, domain_links in external_by_domain.items():
                # Rate limit per domain
                for link in domain_links:
                    result = self._validate_external_with_session(link, session)
                    results.append(result)
                    time.sleep(0.1)  # Rate limiting
        
        # Validate internal links in parallel
        with self.thread_pool as executor:
            internal_futures = [executor.submit(self.validate_internal, link) 
                              for link in internal_links]
            results.extend([f.result() for f in as_completed(internal_futures)])
        
        return results
```

### 6.2 Memory Management

```python
class MemoryEfficientProcessor:
    """
    Memory-efficient processing for very large doc sets
    """
    
    def process_in_chunks(self, doc_root: str, chunk_size: int = 100):
        """
        Process documents in chunks to limit memory usage
        """
        md_files = list(Path(doc_root).rglob("*.md"))
        total_files = len(md_files)
        
        for i in range(0, total_files, chunk_size):
            chunk = md_files[i:i + chunk_size]
            
            # Process chunk
            chunk_graph = self.build_partial_graph(chunk)
            
            # Merge with main graph
            self.merge_graphs(self.main_graph, chunk_graph)
            
            # Clear chunk data
            del chunk_graph
            gc.collect()
            
            # Progress update
            progress = min(100, (i + chunk_size) / total_files * 100)
            logger.info(f"Processing: {progress:.1f}% complete")
```

## 7. Integration Points with APM Infrastructure

### 7.1 APM Command Integration

```bash
# New commands for documentation organization
/doc-analyze          # Analyze documentation structure
/doc-health          # Quick health check
/doc-reorganize      # Execute reorganization
/doc-validate-links  # Validate all links
/doc-backup         # Create manual backup
/doc-restore        # Restore from backup
```

### 7.2 Agent Integration

```python
class DocumentationOrganizerAgent:
    """
    Specialized agent for documentation management
    """
    
    def __init__(self):
        self.analyzer = DocumentAnalyzer()
        self.reorganizer = ReorganizationEngine()
        self.reporter = ReportGenerator()
        
    async def handle_command(self, command: str, args: Dict) -> Response:
        """
        Handle documentation organization commands
        """
        
        if command == "doc-analyze":
            # Full analysis
            graph = await self.analyzer.analyze(args.get('path', '.'))
            report = self.reporter.generate_analysis_report(graph)
            return Response(success=True, data=report)
            
        elif command == "doc-reorganize":
            # Generate and optionally execute reorganization
            plan = self.reorganizer.generate_plan(args)
            
            if args.get('dry_run', True):
                return Response(success=True, data=plan.preview())
            else:
                result = await self.reorganizer.execute(plan)
                return Response(success=True, data=result)
```

### 7.3 Session Integration

```python
class DocOrgSession:
    """
    Session management for documentation organization
    """
    
    def __init__(self, session_id: str):
        self.session_id = session_id
        self.state = SessionState()
        
    def track_changes(self, changes: List[Change]):
        """
        Track all changes for potential rollback
        """
        self.state.changes.extend(changes)
        self.state.save()
        
    def generate_session_report(self) -> str:
        """
        Generate report of all session activities
        """
        return self.reporter.generate_session_report(
            session_id=self.session_id,
            changes=self.state.changes,
            duration=self.state.duration,
            metrics=self.state.metrics
        )
```

## 8. Testing Strategy

### 8.1 Unit Tests

```python
class TestDocumentParser:
    """
    Unit tests for document parsing
    """
    
    def test_link_extraction(self):
        content = """
        # Test Document
        
        Here's a [relative link](../other/doc.md) and an 
        [absolute link](/docs/guide.md).
        
        External: [Google](https://google.com)
        Anchor: [Section](#section-1)
        """
        
        parser = DocumentParser()
        links = parser.extract_links(content, "/test/doc.md")
        
        assert len(links) == 4
        assert links[0].type == LinkType.INTERNAL_RELATIVE
        assert links[1].type == LinkType.INTERNAL_ABSOLUTE
        assert links[2].type == LinkType.EXTERNAL_HTTP
        assert links[3].type == LinkType.ANCHOR
        
    def test_broken_link_detection(self):
        # Test with mock filesystem
        with mock_filesystem() as fs:
            fs.create_file("/docs/source.md", "[Link](target.md)")
            # Don't create target.md
            
            validator = LinkValidator()
            result = validator.validate_all("/docs")
            
            assert len(result.broken_links) == 1
            assert result.broken_links[0].url == "target.md"
```

### 8.2 Integration Tests

```python
class TestReorganizationEngine:
    """
    Integration tests for reorganization
    """
    
    def test_safe_migration(self):
        # Setup test environment
        with temp_docs_environment() as env:
            env.create_structure({
                "docs/": {
                    "guide.md": "# Guide\n[Link](../scattered/related.md)",
                    "scattered/": {
                        "related.md": "# Related\n[Back](../guide.md)"
                    }
                }
            })
            
            # Run reorganization
            engine = ReorganizationEngine()
            plan = engine.generate_plan(env.path)
            result = engine.execute(plan)
            
            # Verify structure
            assert (env.path / "docs" / "related.md").exists()
            assert not (env.path / "docs" / "scattered" / "related.md").exists()
            
            # Verify links updated
            content = (env.path / "docs" / "guide.md").read_text()
            assert "[Link](related.md)" in content
```

### 8.3 Performance Tests

```python
class TestPerformance:
    """
    Performance benchmarks
    """
    
    def test_large_documentation_set(self):
        # Generate 1000 documents with interconnected links
        docs = generate_test_docs(count=1000, links_per_doc=10)
        
        start_time = time.time()
        
        analyzer = DocumentAnalyzer()
        graph = analyzer.analyze(docs)
        
        analysis_time = time.time() - start_time
        
        # Performance assertions
        assert analysis_time < 30  # Should complete in 30 seconds
        assert analyzer.memory_usage() < 500 * 1024 * 1024  # Less than 500MB
```

## 9. Error Handling and Recovery

```python
class ErrorHandler:
    """
    Comprehensive error handling for doc organization
    """
    
    def handle_migration_error(self, error: Exception, context: Dict):
        """
        Handle errors during migration with recovery options
        """
        
        if isinstance(error, FileNotFoundError):
            # Attempt to locate moved file
            suggestions = self.find_file_suggestions(context['file'])
            return RecoveryAction.SKIP_WITH_WARNING
            
        elif isinstance(error, PermissionError):
            # Try alternative approach
            return RecoveryAction.RETRY_WITH_ELEVATED
            
        elif isinstance(error, IntegrityError):
            # Critical - must rollback
            return RecoveryAction.ROLLBACK_REQUIRED
            
        else:
            # Log and continue if possible
            logger.error(f"Unexpected error: {error}")
            return RecoveryAction.SKIP_WITH_ERROR
```

## 10. Configuration Schema

```yaml
# doc-organizer-config.yaml
version: "1.0"

analysis:
  # Paths to scan
  include_paths:
    - "project_docs/"
    - "templates/docs/"
  
  # Paths to exclude
  exclude_paths:
    - "**/node_modules/"
    - "**/.git/"
    - "**/dist/"
  
  # File patterns
  file_patterns:
    - "*.md"
    - "*.markdown"
  
  # Link validation
  link_validation:
    check_external: true
    external_timeout: 5
    cache_duration: 3600
    rate_limit:
      requests_per_second: 10
      per_domain: 2

reorganization:
  # Strategy: topic_clustering, dependency_based, chronological, hierarchical
  strategy: "dependency_based"
  
  # Rules configuration
  rules:
    archive_old_content:
      enabled: true
      age_days: 90
      
    consolidate_scattered:
      enabled: true
      similarity_threshold: 0.8
      
    create_indexes:
      enabled: true
      max_items_per_index: 50
      
    flatten_hierarchy:
      enabled: true
      max_depth: 3
  
  # Safety settings
  safety:
    dry_run_default: true
    require_backup: true
    validation_level: "strict"

reporting:
  # Output formats
  formats:
    - "markdown"
    - "json"
    - "html"
  
  # Report sections
  include_sections:
    - "executive_summary"
    - "statistics"
    - "issues"
    - "recommendations"
    - "dependency_graph"
  
  # Visualization
  visualization:
    generate_graphs: true
    graph_format: "svg"
    max_nodes_in_viz: 100

performance:
  # Parallel processing
  parallel:
    enabled: true
    max_workers: 4
  
  # Memory management
  memory:
    chunk_size: 100
    cache_size: 1000
  
  # Progress reporting
  progress:
    report_interval: 10
    show_eta: true
```

## Implementation Timeline

### Phase 1: Core Engine (Week 1-2)
- Document parser and graph builder
- Link extraction and validation
- Basic reporting

### Phase 2: Reorganization Rules (Week 3)
- Rule engine framework
- Standard reorganization rules
- Plan generation and preview

### Phase 3: Migration System (Week 4)
- Backup and restore functionality
- Safe migration execution
- Link updating system

### Phase 4: Integration (Week 5)
- APM command integration
- Agent implementation
- Performance optimization

### Phase 5: Testing & Polish (Week 6)
- Comprehensive test suite
- Documentation
- Performance tuning

## Conclusion

This implementation plan provides a robust, scalable solution for organizing and maintaining documentation within the APM framework. The system is designed to handle large documentation sets efficiently while ensuring data integrity through comprehensive backup and rollback capabilities. The rule-based approach allows for flexible reorganization strategies that can be customized to meet specific organizational needs.