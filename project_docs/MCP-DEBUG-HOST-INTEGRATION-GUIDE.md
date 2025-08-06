# APM Debug Host MCP Server Integration Guide

## Overview

The APM Debug Host MCP Server provides seamless integration with Claude Code, enabling persistent development server hosting with full console output visibility. This guide covers installation, configuration, and usage.

## Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [Claude Code Integration](#claude-code-integration)
- [Usage](#usage)
- [Health Monitoring](#health-monitoring)
- [Troubleshooting](#troubleshooting)
- [Advanced Configuration](#advanced-configuration)
- [Uninstallation](#uninstallation)

## Installation

### Automatic Installation (Recommended)

The MCP Debug Host Server is integrated into the APM Framework installer:

```bash
# Run APM installer
cd /path/to/apm-framework
./installer/install.sh

# When prompted, select "Yes" for MCP Debug Host installation
# The installer will:
# - Check Node.js 18+ requirement
# - Install MCP server dependencies
# - Generate .mcp.json configuration
# - Set up Claude Code integration
# - Run health checks
```

### Manual Installation

If you need to install separately or troubleshoot:

```bash
# Navigate to MCP host directory
cd installer/mcp-host

# Install dependencies
npm install

# Run configuration setup
node cli.js install --environment development

# Verify installation
node cli.js health-check --verbose
```

### Prerequisites

- **Node.js 18+**: Required for MCP server runtime
- **npm**: Package manager for Node.js dependencies
- **Claude Code**: For MCP integration (optional but recommended)

## Configuration

### Automatic Configuration

The installer automatically generates `.mcp.json` with optimal settings:

```json
{
  "mcpServers": {
    "apm-debug-host": {
      "command": "node",
      "args": ["path/to/installer/mcp-host/src/index.js"],
      "env": {
        "PORT": "8080",
        "MCP_PORT": "3000",
        "ENVIRONMENT": "development",
        "API_KEY": "apm_generated_secure_key"
      },
      "description": "APM Debug Host MCP Server for persistent process management",
      "capabilities": [
        "server:start",
        "server:stop",
        "server:logs", 
        "server:status",
        "tech-stack:detect",
        "dashboard:access"
      ]
    }
  }
}
```

### Manual Configuration

Generate custom configuration:

```bash
# Generate development config
node cli.js generate-config --environment development --port 8080

# Generate production config  
node cli.js generate-config --environment production --port 3000 --server-name prod-debug-host

# Custom project configuration
node cli.js generate-config --project-path /path/to/project --output /custom/path/.mcp.json
```

### Environment-Specific Settings

#### Development Environment
- Debug logging enabled
- Auto-restart on crashes
- Dashboard UI available
- Verbose error reporting

#### Staging Environment  
- Balanced logging level
- Performance monitoring
- Limited debug features
- Stability focused

#### Production Environment
- Minimal logging (warnings/errors only)
- Maximum performance
- Dashboard disabled
- Enhanced security

## Claude Code Integration

### Automatic Integration

The installer configures Claude Code integration automatically:

1. **MCP Server Registration**: Adds server to Claude Code's MCP configuration
2. **Tool Availability**: Makes all MCP tools available in Claude Code sessions
3. **Persistent Sessions**: Enables server persistence across Claude Code sessions
4. **Real-time Monitoring**: Provides live console output visibility

### Manual Integration

If automatic integration fails:

```bash
# Check Claude Code configuration path
ls ~/.claude/.mcp.json

# Verify MCP server is registered
node cli.js status --verbose

# Regenerate configuration
node cli.js generate-config --output ~/.claude/.mcp.json
```

### Available MCP Tools

Once integrated, these tools are available in Claude Code:

- **`server:start`**: Start development server with tech stack detection
- **`server:stop`**: Gracefully stop running server
- **`server:logs`**: Stream real-time server logs with filtering
- **`server:status`**: Get server health and performance metrics
- **`tech-stack:detect`**: Auto-detect project framework and configuration
- **`dashboard:access`**: Open web dashboard for visual monitoring

## Usage

### Starting a Development Server

```bash
# Claude Code session - use MCP tools
Use server:start to launch your development server
The system will auto-detect your tech stack and start appropriate server

# Manual CLI usage
node cli.js status                    # Check if server is running
cd your-project && npm start         # Start your project normally
```

### Monitoring Server Output

#### Web Dashboard (Recommended)
- **URL**: http://localhost:8080
- **Features**: Real-time logs, server controls, session management
- **Access**: Use `dashboard:access` MCP tool or visit URL directly

#### MCP Tool Monitoring
```bash
# In Claude Code, use:
server:logs --follow --filter="error"     # Stream error logs
server:status                             # Get current status
```

#### CLI Monitoring
```bash
node cli.js status --verbose              # Detailed status report
node cli.js health-check                  # Comprehensive health check
```

### Managing Multiple Projects

The MCP server supports multiple concurrent development servers:

```json
{
  "sessions": {
    "react-app": {
      "framework": "react",
      "port": 3000,
      "status": "running"
    },
    "api-server": { 
      "framework": "express",
      "port": 8000,
      "status": "running"
    }
  }
}
```

### Tech Stack Auto-Detection

Supported frameworks with zero configuration:

- **Frontend**: React, Next.js, Vue, Angular, Svelte, Gatsby
- **Backend**: Express, Fastify, Django, Flask, FastAPI  
- **PHP**: Laravel, Symfony, vanilla PHP
- **Full-Stack**: Next.js, Nuxt.js, SvelteKit

## Health Monitoring

### Automatic Health Checks

The system continuously monitors:

- **Process Health**: Server status, memory usage, CPU load
- **Port Management**: Conflict detection, automatic assignment
- **Log Health**: Rotation, storage limits, error patterns
- **Configuration**: Validity, environment consistency

### Manual Health Checks

```bash
# Comprehensive health check
node cli.js health-check --verbose

# JSON report for automation
node cli.js health-check --json --output health-report.json

# Quick status check
node cli.js status
```

### Health Dashboard

Access real-time health metrics at http://localhost:8080:

- **System Resources**: CPU, memory, disk usage
- **Active Sessions**: Running servers and their status
- **Error Patterns**: Recent errors and warnings
- **Performance Metrics**: Response times, throughput

## Troubleshooting

### Common Issues

#### 1. Port Conflicts
```bash
# Check port availability
node cli.js health-check | grep -i port

# Solution: Use different port
node cli.js generate-config --port 8081
```

#### 2. Node.js Version Issues
```bash
# Check Node.js version
node --version

# Solution: Upgrade to Node.js 18+
nvm install 18
nvm use 18
```

#### 3. Permission Errors
```bash
# Check permissions
node cli.js health-check --verbose | grep -i permission

# Solution: Fix directory permissions
sudo chown -R $USER:$USER /path/to/installer/mcp-host
```

#### 4. MCP Integration Not Working
```bash
# Check Claude Code configuration
cat ~/.claude/.mcp.json

# Regenerate MCP configuration
node cli.js generate-config --output ~/.claude/.mcp.json

# Restart Claude Code application
```

### Diagnostic Commands

```bash
# Full diagnostic report
node cli.js health-check --verbose --json --output diagnostics.json

# Check specific components
node cli.js status --verbose

# Validate configuration
node cli.js generate-config --environment development --verbose
```

### Log Analysis

Log files are stored in:
- **Application Logs**: `logs/app.log`
- **Error Logs**: `logs/error.log`  
- **Access Logs**: `logs/access.log`
- **Installation Logs**: `~/.apm/logs/installer.log`

```bash
# View recent errors
tail -f logs/error.log

# Search for specific issues
grep -i "error\|warning" logs/app.log

# Analyze installation issues
cat ~/.apm/logs/installer.log | grep -i mcp
```

## Advanced Configuration

### Custom Environment Variables

```bash
# Set custom configuration
export APM_MCP_HOST_PORT=9000
export APM_MCP_HOST_CONFIG=/custom/config.json
export NODE_ENV=production

# Generate configuration with custom variables
node cli.js generate-config --environment production
```

### Custom Framework Detection

```json
{
  "detection": {
    "customPatterns": {
      "my-framework": {
        "pattern": "my-framework.json",
        "command": "my-framework start",
        "port": 4000
      }
    }
  }
}
```

### Performance Tuning

```json
{
  "processes": {
    "maxConcurrent": 20,
    "defaultTimeout": 60000,
    "memoryLimit": "1GB",
    "cpuLimit": 80
  },
  "monitoring": {
    "metricsInterval": 5000,
    "healthCheckInterval": 30000
  }
}
```

### Security Configuration

```json
{
  "security": {
    "apiKey": "your-secure-api-key",
    "allowedOrigins": ["http://localhost:3000"],
    "rateLimiting": {
      "enabled": true,
      "maxRequests": 100,
      "windowMs": 60000
    }
  }
}
```

## Uninstallation

### Automatic Uninstallation

```bash
# Complete removal with confirmation
node cli.js uninstall --force --verbose

# Dry run to see what would be removed
node cli.js uninstall --dry-run --verbose
```

### Manual Cleanup

```bash
# Stop all services
node cli.js status
# Stop any running servers

# Remove configuration
rm ~/.claude/.mcp.json
rm ~/.apm/mcp-config.json

# Remove application files
rm -rf installer/mcp-host/node_modules
rm -rf installer/mcp-host/logs

# Remove system services (if installed)
sudo systemctl stop apm-debug-host
sudo systemctl disable apm-debug-host
sudo rm /etc/systemd/system/apm-debug-host.service
```

### Rollback Failed Installation

```bash
# Rollback with state file
node cli.js rollback --state installation-state.json --verbose

# Best-effort rollback without state
node cli.js rollback --verbose
```

## Support and Resources

### Documentation
- **Main Documentation**: https://docs.apm-framework.com/mcp-debug-host
- **API Reference**: https://docs.apm-framework.com/mcp-api
- **Troubleshooting**: https://docs.apm-framework.com/troubleshooting

### Community
- **GitHub Issues**: https://github.com/apm-framework/debug-host-mcp/issues
- **Discussions**: https://github.com/apm-framework/debug-host-mcp/discussions
- **Discord**: https://discord.gg/apm-framework

### Getting Help

1. **Check Health Status**: Run `node cli.js health-check --verbose`
2. **Review Logs**: Check application and installation logs
3. **Search Documentation**: Look for similar issues in docs
4. **Create Issue**: Provide health check output and logs

## Version Information

- **MCP Server Version**: 1.0.0
- **MCP Protocol Version**: 1.0
- **Minimum Node.js**: 18.0.0
- **APM Framework**: 3.3.0+
- **Claude Code Integration**: Compatible with all versions

## Changelog

### v1.0.0 (2025-08-01)
- Initial release with Epic 23 completion
- Complete MCP configuration system
- Health monitoring and validation
- Installation rollback capabilities
- Comprehensive documentation
- Claude Code integration
- Multi-framework support