# Project Documentation Structure - APM v4.0.0

This directory contains all project-specific documentation generated and used by the APM Framework agents with **native sub-agent architecture** and **MCP Debug Host integration** for 4-8x faster documentation generation.

## Directory Structure

### base/
Core project documents that serve as the foundation for all development work:
- `prd.md` - Product Requirements Document (created by PM agent)
- `architecture.md` - System Architecture Document (created by Architect agent)
- `frontend-architecture.md` - Frontend Architecture Document (created by Design Architect)
- `project_structure.md` - Project file/folder organization
- `development_workflow.md` - Development process and workflows
- `tech_stack.md` - Technology stack and dependencies
- `data-models.md` - Data structures and models
- `environment-vars.md` - Environment variable documentation

### epics/
Contains epic-level documentation:
- `epic-{n}.md` - Individual epic documents
- `epic-orchestration-guide.md` - Guide for managing epics

### stories/
User story documentation:
- `{epicNum}.{storyNum}.story.md` - Individual story files
- Stories are generated from epics by the SM agent

### qa/
Quality assurance documentation:
- `test-strategy.md` - Overall testing strategy
- `test-plan.md` - Detailed test plans
- `test-report.md` - Test execution reports
- `automation-plan.md` - Test automation plans
- `deployment-plan.md` - Deployment procedures
- `test-plans/` - Individual test plan documents
- `automation/` - Automation scripts and documentation

### index.md
Master index linking all documentation for easy navigation.

## 🚀 What's New in v4.0.0

### Revolutionary Version Management System
- **✨ `/version` Command**: Automated documentation updates with parallel processing
- **🏗️ `/release` Command**: Complete release management with GitHub integration
- **📝 Advanced Documentation Generation**: AI-powered release notes and changelog creation
- **⚡ 4-8x Faster Updates**: Native sub-agent architecture for documentation management
- **🔗 Link Validation**: Automatic URL verification and broken link detection
- **📊 Migration Support**: Automatic migration guide generation for major versions

### Enhanced Command Portfolio
- **70+ Total Commands**: Comprehensive suite including new release management
- **Documentation Commands**: Version, release, doc-compliance, update-all-documentation
- **Build Integration**: Seamless integration with build and distribution processes
- **Quality Assurance**: Built-in validation and consistency checking

## Usage by Agents (v4.0.0 - Release Management Enhanced)

- **Analyst**: Parallel research and analysis with native sub-agents
- **PM**: Concurrent PRD generation and epic management (4x speedup)
- **Architect**: `/parallel-architecture-review` for system-wide analysis
- **Design Architect**: Parallel component and UI/UX analysis
- **PO**: `/groom` with 18 native sub-agents for backlog optimization
- **SM**: `/parallel-sprint` coordinating 2-4 Developer sub-agents
- **Developer**: `/parallel-review` for concurrent code analysis
- **QA**: `/parallel-test` with AI/ML analytics (92% accuracy)

**Performance Impact**: Documentation generation now 4-8x faster with zero CLI crashes

## 📦 Release Management (v4.0.0 - New Feature)

### Version Management Commands

APM v4.0.0 introduces comprehensive release management capabilities:

**New Commands:**
- `/version <version>` - Update all documentation and version references
- `/release <version>` - Complete release process with GitHub integration
- `/doc-compliance` - Ensure all documentation meets quality standards
- `/update-all-documentation` - Comprehensive documentation refresh

**Features:**
- **Parallel Documentation Updates**: 4-8x faster version updates
- **Automated Release Notes**: Generated from git history and change analysis
- **GitHub Integration**: Automatic release creation and package upload
- **Quality Validation**: Link checking, version consistency, content validation
- **Migration Guides**: Auto-generated for major version releases

**Example Usage:**
```bash
# Update to new version with parallel processing
/version 4.1.0

# Create complete release with GitHub integration
/release 4.1.0 --rc

# Validate all documentation
/doc-compliance
```

## MCP Debug Host Integration (v3.3.0+ - Epic 26)

### Development Documentation Requirements

When documenting development server management, agents MUST reference MCP tools instead of direct commands:

**Documentation Standards:**
- **Setup Guides**: Always reference `start_dev_server` MCP tool
- **Deployment Docs**: Include MCP server management workflows
- **Development Workflow**: Document MCP-based development process
- **Troubleshooting**: MCP server diagnostics and log access via `server_logs`

**Real-time Documentation:**
- **Server Status**: Live updates via http://localhost:8080 dashboard
- **Log Integration**: Automatic log capture and documentation
- **Persistent Sessions**: Document survival across Claude Code restarts

