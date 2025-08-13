# MCP Plopdock Server Implementation Guide

## 🎯 Overview

This guide provides step-by-step instructions for implementing the MCP (Model Context Protocol) Plopdock Server integration into the APM Framework installer. The MCP Plopdock solves the problem of invisible console output when AI agents start development servers.

### What You'll Build
- A persistent server that manages all development processes
- A web dashboard for viewing console output
- Integration with Claude Code via MCP protocol
- Automatic installation through the APM installer

### Prerequisites
- Basic knowledge of JavaScript/Node.js
- Understanding of bash scripting
- Familiarity with system services (systemd/launchd)
- Node.js 18+ installed on your system

---

## 📁 Project Structure

```
agentic-persona-mapping/
├── installer/
│   ├── install.sh                    # Main installer (you'll modify this)
│   ├── mcp-host/                    # New directory to create
│   │   ├── install-mcp-host.sh      # MCP-specific installer
│   │   ├── package.json             # Node.js dependencies
│   │   ├── src/                     # MCP server source code
│   │   │   ├── index.js             # Main server entry point
│   │   │   ├── process-manager.js   # Process management logic
│   │   │   ├── log-store.js         # Log storage and retrieval
│   │   │   ├── mcp-tools.js         # MCP tool definitions
│   │   │   ├── tech-stack-detector.js # Detect project types
│   │   │   ├── dashboard/           # Web dashboard
│   │   │   │   ├── server.js        # Express server for dashboard
│   │   │   │   ├── public/          # Frontend assets
│   │   │   │   │   ├── index.html   # Dashboard HTML
│   │   │   │   │   ├── app.js       # Dashboard JavaScript
│   │   │   │   │   └── style.css    # Dashboard styles
│   │   │   │   └── websocket.js    # WebSocket handler
│   │   │   └── adapters/            # Tech stack adapters
│   │   │       ├── base-adapter.js  # Base adapter class
│   │   │       ├── node-adapter.js  # Node.js projects
│   │   │       ├── php-adapter.js   # PHP projects
│   │   │       └── python-adapter.js # Python projects
│   │   └── templates/
│   │       ├── systemd.service.template  # Linux service
│   │       └── launchd.plist.template    # macOS service
│   └── templates/
│       ├── mcp.json.template        # MCP configuration
│       └── hooks/
│           └── mcp-notify.sh        # Server detection hook
└── project_docs/
    └── MCP-DEBUG-HOST-IMPLEMENTATION-GUIDE.md # This file
```

---

## 🚀 Step-by-Step Implementation

### Step 1: Create the MCP Host Directory Structure

```bash
# From the installer directory
cd installer/
mkdir -p mcp-host/src/dashboard/public
mkdir -p mcp-host/src/adapters
mkdir -p mcp-host/templates
```

### Step 2: Create package.json

Create `installer/mcp-host/package.json`:

```json
{
  "name": "@apm/plopdock-mcp",
  "version": "1.0.0",
  "description": "APM Plopdock MCP Server for persistent process management",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "dev": "node src/index.js --debug"
  },
  "dependencies": {
    "express": "^4.18.2",
    "ws": "^8.13.0",
    "winston": "^3.8.2",
    "node-pty": "^0.10.1",
    "portfinder": "^1.0.32",
    "uuid": "^9.0.0",
    "dotenv": "^16.0.3"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
```

### Step 3: Implement the Main MCP Server

Create `installer/mcp-host/src/index.js`:

```javascript
#!/usr/bin/env node

const { Server } = require('@modelcontextprotocol/sdk/server/index.js');
const { StdioServerTransport } = require('@modelcontextprotocol/sdk/server/stdio.js');
const ProcessManager = require('./process-manager');
const LogStore = require('./log-store');
const DashboardServer = require('./dashboard/server');
const { setupTools } = require('./mcp-tools');
const winston = require('winston');
const path = require('path');
require('dotenv').config();

// Configure logger
const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ 
      filename: path.join(process.env.HOME, '.apm-plopdock', 'server.log') 
    })
  ]
});

// Initialize components
const processManager = new ProcessManager(logger);
const logStore = new LogStore(logger);
const dashboardServer = new DashboardServer(processManager, logStore, logger);

// Create MCP server
const server = new Server(
  {
    name: 'apm-plopdock',
    version: '1.0.0'
  },
  {
    capabilities: {
      tools: {}
    }
  }
);

// Setup MCP tools
setupTools(server, processManager, logStore, logger);

// Start dashboard
const dashboardPort = process.env.PORT || 8080;
dashboardServer.start(dashboardPort).then(() => {
  logger.info(`Dashboard started on port ${dashboardPort}`);
});

// Handle shutdown
process.on('SIGINT', async () => {
  logger.info('Shutting down MCP Plopdock...');
  await processManager.stopAll();
  await dashboardServer.stop();
  process.exit(0);
});

// Start MCP server
const transport = new StdioServerTransport();
server.connect(transport).then(() => {
  logger.info('MCP Plopdock Server started');
}).catch((error) => {
  logger.error('Failed to start MCP server:', error);
  process.exit(1);
});
```

### Step 4: Implement Process Manager

Create `installer/mcp-host/src/process-manager.js`:

```javascript
const { spawn } = require('child_process');
const { v4: uuidv4 } = require('uuid');
const EventEmitter = require('events');
const TechStackDetector = require('./tech-stack-detector');

class ProcessManager extends EventEmitter {
  constructor(logger) {
    super();
    this.logger = logger;
    this.processes = new Map();
    this.detector = new TechStackDetector();
  }

  async startServer(params) {
    const { command, cwd, env, port, sessionName } = params;
    
    // Check if already running on port
    const existing = this.findByPort(port);
    if (existing && existing.status === 'running') {
      return {
        sessionId: existing.id,
        status: 'already_running',
        port: existing.port,
        url: `http://localhost:${port}`
      };
    }
    
    // Detect tech stack if not provided
    if (!command) {
      const detected = await this.detector.detectAndGetCommand(cwd);
      if (!detected) {
        throw new Error('Could not detect project type or start command');
      }
      Object.assign(params, detected);
    }
    
    // Create session
    const sessionId = uuidv4();
    const startTime = Date.now();
    
    // Spawn process
    const child = spawn(command, {
      cwd,
      env: { ...process.env, ...env },
      shell: true,
      detached: true
    });
    
    // Create session object
    const session = {
      id: sessionId,
      name: sessionName || `Server on port ${port}`,
      command,
      cwd,
      port,
      pid: child.pid,
      startTime,
      status: 'starting',
      logs: [],
      process: child
    };
    
    // Capture output
    child.stdout.on('data', (data) => {
      const log = {
        timestamp: Date.now(),
        type: 'stdout',
        data: data.toString()
      };
      session.logs.push(log);
      this.emit('log', { sessionId, log });
      
      // Check if server is ready
      if (this.isServerReady(data.toString())) {
        session.status = 'running';
        this.emit('server-ready', session);
      }
    });
    
    child.stderr.on('data', (data) => {
      const log = {
        timestamp: Date.now(),
        type: 'stderr',
        data: data.toString()
      };
      session.logs.push(log);
      this.emit('log', { sessionId, log });
    });
    
    child.on('exit', (code) => {
      session.status = 'stopped';
      session.exitCode = code;
      this.emit('process-exit', { sessionId, code });
    });
    
    // Store session
    this.processes.set(sessionId, session);
    
    return {
      sessionId,
      pid: child.pid,
      port,
      status: 'starting',
      url: `http://localhost:${port}`
    };
  }
  
  stopServer(sessionId) {
    const session = this.processes.get(sessionId);
    if (!session) {
      throw new Error(`Session ${sessionId} not found`);
    }
    
    if (session.process && session.status === 'running') {
      // Kill process group
      process.kill(-session.process.pid, 'SIGTERM');
      session.status = 'stopping';
    }
    
    return { success: true };
  }
  
  getLogs(sessionId, options = {}) {
    const session = this.processes.get(sessionId);
    if (!session) {
      return [];
    }
    
    const { tail = 100, filter } = options;
    let logs = session.logs;
    
    if (filter) {
      const regex = new RegExp(filter, 'i');
      logs = logs.filter(log => regex.test(log.data));
    }
    
    return logs.slice(-tail);
  }
  
  getAllSessions() {
    return Array.from(this.processes.values()).map(session => ({
      id: session.id,
      name: session.name,
      command: session.command,
      port: session.port,
      status: session.status,
      pid: session.pid,
      startTime: session.startTime,
      uptime: Date.now() - session.startTime
    }));
  }
  
  findByPort(port) {
    for (const session of this.processes.values()) {
      if (session.port === port) {
        return session;
      }
    }
    return null;
  }
  
  isServerReady(output) {
    const readyPatterns = [
      /listening on/i,
      /server started/i,
      /ready on/i,
      /compiled successfully/i,
      /webpack compiled/i,
      /vite.*ready/i
    ];
    
    return readyPatterns.some(pattern => pattern.test(output));
  }
  
  async stopAll() {
    for (const session of this.processes.values()) {
      if (session.status === 'running') {
        this.stopServer(session.id);
      }
    }
  }
}

module.exports = ProcessManager;
```

### Step 5: Implement MCP Tools

Create `installer/mcp-host/src/mcp-tools.js`:

```javascript
function setupTools(server, processManager, logStore, logger) {
  // Tool: server:start
  server.setRequestHandler('tools/call', async (request) => {
    if (request.params.name === 'server:start') {
      try {
        const result = await processManager.startServer(request.params.arguments);
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(result, null, 2)
            }
          ]
        };
      } catch (error) {
        logger.error('Error starting server:', error);
        throw error;
      }
    }
    
    if (request.params.name === 'server:stop') {
      try {
        const { sessionId } = request.params.arguments;
        const result = processManager.stopServer(sessionId);
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(result, null, 2)
            }
          ]
        };
      } catch (error) {
        logger.error('Error stopping server:', error);
        throw error;
      }
    }
    
    if (request.params.name === 'server:logs') {
      try {
        const { sessionId, tail, filter } = request.params.arguments;
        const logs = processManager.getLogs(sessionId, { tail, filter });
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(logs, null, 2)
            }
          ]
        };
      } catch (error) {
        logger.error('Error getting logs:', error);
        throw error;
      }
    }
    
    if (request.params.name === 'server:status') {
      try {
        const sessions = processManager.getAllSessions();
        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify({ sessions }, null, 2)
            }
          ]
        };
      } catch (error) {
        logger.error('Error getting status:', error);
        throw error;
      }
    }
  });
  
  // List available tools
  server.setRequestHandler('tools/list', async () => {
    return {
      tools: [
        {
          name: 'server:start',
          description: 'Start a development server',
          inputSchema: {
            type: 'object',
            properties: {
              command: { type: 'string', description: 'Command to run (auto-detected if not provided)' },
              cwd: { type: 'string', description: 'Working directory' },
              env: { type: 'object', description: 'Environment variables' },
              port: { type: 'number', description: 'Port number' },
              sessionName: { type: 'string', description: 'Name for this session' }
            },
            required: ['cwd']
          }
        },
        {
          name: 'server:stop',
          description: 'Stop a running server',
          inputSchema: {
            type: 'object',
            properties: {
              sessionId: { type: 'string', description: 'Session ID to stop' }
            },
            required: ['sessionId']
          }
        },
        {
          name: 'server:logs',
          description: 'Get logs from a server session',
          inputSchema: {
            type: 'object',
            properties: {
              sessionId: { type: 'string', description: 'Session ID' },
              tail: { type: 'number', description: 'Number of recent logs', default: 100 },
              filter: { type: 'string', description: 'Filter pattern' }
            }
          }
        },
        {
          name: 'server:status',
          description: 'Get status of all server sessions',
          inputSchema: {
            type: 'object',
            properties: {}
          }
        }
      ]
    };
  });
}

module.exports = { setupTools };
```

### Step 6: Create Tech Stack Detector

Create `installer/mcp-host/src/tech-stack-detector.js`:

```javascript
const fs = require('fs').promises;
const path = require('path');

class TechStackDetector {
  async detectAndGetCommand(projectPath) {
    // Check for Node.js projects
    if (await this.fileExists(path.join(projectPath, 'package.json'))) {
      const packageJson = JSON.parse(
        await fs.readFile(path.join(projectPath, 'package.json'), 'utf8')
      );
      
      const scripts = packageJson.scripts || {};
      
      // Check common dev script names
      for (const scriptName of ['dev', 'start', 'serve', 'develop']) {
        if (scripts[scriptName]) {
          return {
            command: `npm run ${scriptName}`,
            port: this.detectPort(scripts[scriptName]) || 3000,
            framework: this.detectFramework(packageJson)
          };
        }
      }
    }
    
    // Check for PHP projects
    if (await this.fileExists(path.join(projectPath, 'artisan'))) {
      return {
        command: 'php artisan serve',
        port: 8000,
        framework: 'laravel'
      };
    }
    
    if (await this.fileExists(path.join(projectPath, 'composer.json'))) {
      return {
        command: 'php -S localhost:8000',
        port: 8000,
        framework: 'php'
      };
    }
    
    // Check for Python projects
    if (await this.fileExists(path.join(projectPath, 'manage.py'))) {
      return {
        command: 'python manage.py runserver',
        port: 8000,
        framework: 'django'
      };
    }
    
    if (await this.fileExists(path.join(projectPath, 'requirements.txt'))) {
      const content = await fs.readFile(
        path.join(projectPath, 'requirements.txt'), 
        'utf8'
      );
      
      if (content.includes('flask')) {
        return {
          command: 'flask run',
          port: 5000,
          framework: 'flask',
          env: { FLASK_ENV: 'development' }
        };
      }
      
      if (content.includes('fastapi')) {
        return {
          command: 'uvicorn main:app --reload',
          port: 8000,
          framework: 'fastapi'
        };
      }
    }
    
    return null;
  }
  
  async fileExists(filePath) {
    try {
      await fs.access(filePath);
      return true;
    } catch {
      return false;
    }
  }
  
  detectPort(script) {
    // Try to extract port from script
    const portMatch = script.match(/(?:--port|PORT=)(\d+)/);
    if (portMatch) {
      return parseInt(portMatch[1]);
    }
    
    // Framework-specific defaults
    if (script.includes('vite')) return 5173;
    if (script.includes('next')) return 3000;
    if (script.includes('nuxt')) return 3000;
    if (script.includes('webpack-dev-server')) return 8080;
    
    return null;
  }
  
  detectFramework(packageJson) {
    const deps = { 
      ...packageJson.dependencies, 
      ...packageJson.devDependencies 
    };
    
    if (deps.next) return 'nextjs';
    if (deps.nuxt) return 'nuxt';
    if (deps['@angular/core']) return 'angular';
    if (deps.vue) return 'vue';
    if (deps.react) return 'react';
    if (deps.svelte) return 'svelte';
    
    return 'node';
  }
}

module.exports = TechStackDetector;
```

### Step 7: Create Dashboard Server

Create `installer/mcp-host/src/dashboard/server.js`:

```javascript
const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const path = require('path');

class DashboardServer {
  constructor(processManager, logStore, logger) {
    this.processManager = processManager;
    this.logStore = logStore;
    this.logger = logger;
    this.app = express();
    this.server = null;
    this.wss = null;
    
    this.setupRoutes();
    this.setupWebSocket();
  }
  
  setupRoutes() {
    // Serve static files
    this.app.use(express.static(path.join(__dirname, 'public')));
    
    // API routes
    this.app.get('/api/sessions', (req, res) => {
      const sessions = this.processManager.getAllSessions();
      res.json({ sessions });
    });
    
    this.app.get('/api/sessions/:id/logs', (req, res) => {
      const { id } = req.params;
      const { tail = 100, filter } = req.query;
      
      const logs = this.processManager.getLogs(id, {
        tail: parseInt(tail),
        filter
      });
      
      res.json({ logs });
    });
    
    this.app.post('/api/sessions/:id/stop', (req, res) => {
      const { id } = req.params;
      
      try {
        const result = this.processManager.stopServer(id);
        res.json(result);
      } catch (error) {
        res.status(404).json({ error: error.message });
      }
    });
    
    // Health check
    this.app.get('/api/health', (req, res) => {
      res.json({ status: 'ok', uptime: process.uptime() });
    });
  }
  
  setupWebSocket() {
    // Listen for process manager events
    this.processManager.on('log', ({ sessionId, log }) => {
      this.broadcast({
        type: 'log',
        sessionId,
        log
      });
    });
    
    this.processManager.on('server-ready', (session) => {
      this.broadcast({
        type: 'server-ready',
        session: {
          id: session.id,
          name: session.name,
          port: session.port,
          status: session.status
        }
      });
    });
    
    this.processManager.on('process-exit', ({ sessionId, code }) => {
      this.broadcast({
        type: 'process-exit',
        sessionId,
        code
      });
    });
  }
  
  broadcast(data) {
    if (!this.wss) return;
    
    const message = JSON.stringify(data);
    this.wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message);
      }
    });
  }
  
  async start(port) {
    return new Promise((resolve, reject) => {
      this.server = http.createServer(this.app);
      
      // Create WebSocket server
      this.wss = new WebSocket.Server({ server: this.server });
      
      this.wss.on('connection', (ws) => {
        this.logger.info('Dashboard client connected');
        
        // Send initial state
        ws.send(JSON.stringify({
          type: 'initial-state',
          sessions: this.processManager.getAllSessions()
        }));
        
        ws.on('close', () => {
          this.logger.info('Dashboard client disconnected');
        });
      });
      
      this.server.listen(port, () => {
        this.logger.info(`Dashboard server listening on port ${port}`);
        resolve();
      });
      
      this.server.on('error', reject);
    });
  }
  
  async stop() {
    if (this.wss) {
      this.wss.close();
    }
    
    if (this.server) {
      return new Promise((resolve) => {
        this.server.close(resolve);
      });
    }
  }
}

module.exports = DashboardServer;
```

### Step 8: Create Dashboard Frontend

Create `installer/mcp-host/src/dashboard/public/index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>APM Plopdock Dashboard</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <header>
      <h1>🚀 APM Plopdock Dashboard</h1>
      <div class="connection-status" id="connectionStatus">
        <span class="status-dot"></span>
        <span class="status-text">Connecting...</span>
      </div>
    </header>
    
    <div class="sessions-grid" id="sessionsGrid">
      <!-- Sessions will be populated here -->
    </div>
    
    <div class="log-viewer" id="logViewer">
      <div class="log-header">
        <h3>Console Output</h3>
        <div class="log-controls">
          <input type="text" 
                 id="logFilter" 
                 placeholder="Filter logs..."
                 class="log-filter">
          <button id="clearLogs" class="btn btn-secondary">Clear</button>
        </div>
      </div>
      <div class="log-content" id="logContent">
        <div class="log-placeholder">Select a session to view logs</div>
      </div>
    </div>
  </div>
  
  <script src="app.js"></script>
</body>
</html>
```

Create `installer/mcp-host/src/dashboard/public/style.css`:

```css
:root {
  --primary-color: #2563eb;
  --success-color: #10b981;
  --warning-color: #f59e0b;
  --error-color: #ef4444;
  --bg-primary: #0f172a;
  --bg-secondary: #1e293b;
  --bg-tertiary: #334155;
  --text-primary: #f1f5f9;
  --text-secondary: #94a3b8;
  --border-color: #334155;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
  background-color: var(--bg-primary);
  color: var(--text-primary);
  line-height: 1.6;
}

.container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
}

header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 1px solid var(--border-color);
}

h1 {
  font-size: 28px;
  font-weight: 600;
}

.connection-status {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  background-color: var(--bg-secondary);
  border-radius: 20px;
}

.status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background-color: var(--warning-color);
}

.status-dot.connected {
  background-color: var(--success-color);
}

.sessions-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.session-card {
  background-color: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  padding: 20px;
  transition: all 0.2s;
}

.session-card:hover {
  border-color: var(--primary-color);
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.1);
}

.session-card.selected {
  border-color: var(--primary-color);
  background-color: var(--bg-tertiary);
}

.session-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
}

.session-name {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 4px;
}

.session-command {
  font-size: 12px;
  font-family: 'Monaco', 'Consolas', monospace;
  color: var(--text-secondary);
  margin-bottom: 12px;
}

.session-meta {
  display: flex;
  gap: 12px;
  font-size: 13px;
  color: var(--text-secondary);
  margin-bottom: 16px;
}

.session-status {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

.session-status.running {
  background-color: rgba(16, 185, 129, 0.1);
  color: var(--success-color);
}

.session-status.starting {
  background-color: rgba(245, 158, 11, 0.1);
  color: var(--warning-color);
}

.session-status.stopped {
  background-color: rgba(239, 68, 68, 0.1);
  color: var(--error-color);
}

.session-actions {
  display: flex;
  gap: 8px;
}

.btn {
  padding: 6px 12px;
  border: none;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background-color: var(--primary-color);
  color: white;
}

.btn-primary:hover {
  background-color: #1d4ed8;
}

.btn-secondary {
  background-color: var(--bg-tertiary);
  color: var(--text-primary);
}

.btn-secondary:hover {
  background-color: #475569;
}

.btn-danger {
  background-color: var(--error-color);
  color: white;
}

.btn-danger:hover {
  background-color: #dc2626;
}

.log-viewer {
  background-color: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  height: 500px;
  display: flex;
  flex-direction: column;
}

.log-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  border-bottom: 1px solid var(--border-color);
}

.log-header h3 {
  font-size: 18px;
  font-weight: 600;
}

.log-controls {
  display: flex;
  gap: 12px;
}

.log-filter {
  padding: 6px 12px;
  background-color: var(--bg-tertiary);
  border: 1px solid var(--border-color);
  border-radius: 6px;
  color: var(--text-primary);
  font-size: 13px;
  width: 200px;
}

.log-content {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  font-family: 'Monaco', 'Consolas', monospace;
  font-size: 13px;
  line-height: 1.4;
}

.log-entry {
  margin-bottom: 2px;
  white-space: pre-wrap;
  word-break: break-all;
}

.log-entry.stdout {
  color: var(--text-primary);
}

.log-entry.stderr {
  color: var(--error-color);
}

.log-timestamp {
  color: var(--text-secondary);
  margin-right: 8px;
}

.log-placeholder {
  color: var(--text-secondary);
  text-align: center;
  margin-top: 100px;
}

@media (max-width: 768px) {
  .sessions-grid {
    grid-template-columns: 1fr;
  }
  
  .log-filter {
    width: 120px;
  }
}
```

Create `installer/mcp-host/src/dashboard/public/app.js`:

```javascript
class DashboardApp {
  constructor() {
    this.ws = null;
    this.sessions = new Map();
    this.selectedSessionId = null;
    this.logBuffer = new Map();
    
    this.initializeWebSocket();
    this.bindEvents();
  }
  
  initializeWebSocket() {
    const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    const wsUrl = `${protocol}//${window.location.host}`;
    
    this.ws = new WebSocket(wsUrl);
    
    this.ws.onopen = () => {
      this.updateConnectionStatus(true);
      console.log('Connected to MCP Plopdock');
    };
    
    this.ws.onclose = () => {
      this.updateConnectionStatus(false);
      console.log('Disconnected from MCP Plopdock');
      
      // Reconnect after 3 seconds
      setTimeout(() => this.initializeWebSocket(), 3000);
    };
    
    this.ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      this.handleMessage(data);
    };
  }
  
  handleMessage(data) {
    switch (data.type) {
      case 'initial-state':
        this.loadSessions(data.sessions);
        break;
        
      case 'log':
        this.appendLog(data.sessionId, data.log);
        break;
        
      case 'server-ready':
        this.updateSession(data.session);
        break;
        
      case 'process-exit':
        this.handleProcessExit(data.sessionId, data.code);
        break;
    }
  }
  
  loadSessions(sessions) {
    this.sessions.clear();
    sessions.forEach(session => {
      this.sessions.set(session.id, session);
    });
    this.renderSessions();
  }
  
  updateSession(sessionData) {
    const session = this.sessions.get(sessionData.id);
    if (session) {
      Object.assign(session, sessionData);
      this.renderSessions();
    }
  }
  
  appendLog(sessionId, log) {
    if (!this.logBuffer.has(sessionId)) {
      this.logBuffer.set(sessionId, []);
    }
    
    const logs = this.logBuffer.get(sessionId);
    logs.push(log);
    
    // Keep only last 1000 logs per session
    if (logs.length > 1000) {
      logs.shift();
    }
    
    // Update UI if this session is selected
    if (sessionId === this.selectedSessionId) {
      this.renderLog(log);
      this.autoScroll();
    }
  }
  
  handleProcessExit(sessionId, code) {
    const session = this.sessions.get(sessionId);
    if (session) {
      session.status = 'stopped';
      session.exitCode = code;
      this.renderSessions();
    }
  }
  
  renderSessions() {
    const grid = document.getElementById('sessionsGrid');
    grid.innerHTML = '';
    
    this.sessions.forEach(session => {
      const card = this.createSessionCard(session);
      grid.appendChild(card);
    });
  }
  
  createSessionCard(session) {
    const card = document.createElement('div');
    card.className = 'session-card';
    if (session.id === this.selectedSessionId) {
      card.classList.add('selected');
    }
    
    const uptime = this.formatUptime(session.uptime);
    
    card.innerHTML = `
      <div class="session-header">
        <div>
          <div class="session-name">${session.name}</div>
          <div class="session-command">${session.command}</div>
        </div>
        <div class="session-status ${session.status}">
          <span class="status-dot"></span>
          ${session.status}
        </div>
      </div>
      <div class="session-meta">
        <span>Port: ${session.port}</span>
        <span>PID: ${session.pid || 'N/A'}</span>
        <span>Uptime: ${uptime}</span>
      </div>
      <div class="session-actions">
        <button class="btn btn-primary" onclick="app.selectSession('${session.id}')">
          View Logs
        </button>
        ${session.status === 'running' ? `
          <button class="btn btn-secondary" onclick="app.openInBrowser(${session.port})">
            Open
          </button>
          <button class="btn btn-danger" onclick="app.stopSession('${session.id}')">
            Stop
          </button>
        ` : ''}
      </div>
    `;
    
    return card;
  }
  
  selectSession(sessionId) {
    this.selectedSessionId = sessionId;
    this.renderSessions();
    this.renderLogs();
  }
  
  renderLogs() {
    const content = document.getElementById('logContent');
    const logs = this.logBuffer.get(this.selectedSessionId) || [];
    
    if (logs.length === 0) {
      content.innerHTML = '<div class="log-placeholder">No logs yet</div>';
      return;
    }
    
    content.innerHTML = '';
    logs.forEach(log => this.renderLog(log));
    this.autoScroll();
  }
  
  renderLog(log) {
    const content = document.getElementById('logContent');
    const entry = document.createElement('div');
    entry.className = `log-entry ${log.type}`;
    
    const timestamp = new Date(log.timestamp).toLocaleTimeString();
    entry.innerHTML = `<span class="log-timestamp">${timestamp}</span>${this.escapeHtml(log.data)}`;
    
    content.appendChild(entry);
  }
  
  autoScroll() {
    const content = document.getElementById('logContent');
    content.scrollTop = content.scrollHeight;
  }
  
  async stopSession(sessionId) {
    if (!confirm('Are you sure you want to stop this server?')) {
      return;
    }
    
    try {
      const response = await fetch(`/api/sessions/${sessionId}/stop`, {
        method: 'POST'
      });
      
      if (!response.ok) {
        throw new Error('Failed to stop session');
      }
    } catch (error) {
      console.error('Error stopping session:', error);
      alert('Failed to stop session');
    }
  }
  
  openInBrowser(port) {
    window.open(`http://localhost:${port}`, '_blank');
  }
  
  updateConnectionStatus(connected) {
    const statusDot = document.querySelector('.status-dot');
    const statusText = document.querySelector('.status-text');
    
    if (connected) {
      statusDot.classList.add('connected');
      statusText.textContent = 'Connected';
    } else {
      statusDot.classList.remove('connected');
      statusText.textContent = 'Disconnected';
    }
  }
  
  bindEvents() {
    // Clear logs button
    document.getElementById('clearLogs').addEventListener('click', () => {
      if (this.selectedSessionId) {
        this.logBuffer.set(this.selectedSessionId, []);
        this.renderLogs();
      }
    });
    
    // Log filter
    let filterTimeout;
    document.getElementById('logFilter').addEventListener('input', (e) => {
      clearTimeout(filterTimeout);
      filterTimeout = setTimeout(() => {
        this.filterLogs(e.target.value);
      }, 300);
    });
  }
  
  filterLogs(filter) {
    const content = document.getElementById('logContent');
    const entries = content.querySelectorAll('.log-entry');
    
    entries.forEach(entry => {
      if (filter && !entry.textContent.toLowerCase().includes(filter.toLowerCase())) {
        entry.style.display = 'none';
      } else {
        entry.style.display = 'block';
      }
    });
  }
  
  formatUptime(ms) {
    const seconds = Math.floor(ms / 1000);
    const minutes = Math.floor(seconds / 60);
    const hours = Math.floor(minutes / 60);
    
    if (hours > 0) {
      return `${hours}h ${minutes % 60}m`;
    } else if (minutes > 0) {
      return `${minutes}m ${seconds % 60}s`;
    } else {
      return `${seconds}s`;
    }
  }
  
  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }
}

// Initialize app when DOM is ready
const app = new DashboardApp();
```

### Step 9: Create MCP Host Installer Script

Create `installer/mcp-host/install-mcp-host.sh`:

```bash
#!/bin/bash

# MCP Plopdock Installation Script
# This script installs and configures the MCP Plopdock Server

set -e

# Colors
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_HOME="$HOME/.apm-plopdock"

echo -e "${GREEN}Installing MCP Plopdock Server...${NC}"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Node.js installation
check_nodejs() {
    if ! command_exists node; then
        echo -e "${RED}Error: Node.js is not installed${NC}"
        echo "Please install Node.js 18 or later from https://nodejs.org"
        return 1
    fi
    
    # Check Node.js version
    NODE_VERSION=$(node -v | cut -d'v' -f2)
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1)
    
    if [ "$NODE_MAJOR" -lt 18 ]; then
        echo -e "${YELLOW}Warning: Node.js 18+ recommended (found v$NODE_VERSION)${NC}"
    fi
    
    return 0
}

# Install MCP server files
install_mcp_server() {
    echo "Creating MCP home directory..."
    mkdir -p "$MCP_HOME"
    
    echo "Copying server files..."
    cp -r "$SCRIPT_DIR/"* "$MCP_HOME/"
    
    echo "Installing dependencies..."
    cd "$MCP_HOME"
    npm install --production --silent
    
    echo -e "${GREEN}✓ MCP server files installed${NC}"
}

# Generate configuration
generate_config() {
    echo "Generating configuration..."
    
    # Generate API key
    if command_exists openssl; then
        API_KEY=$(openssl rand -hex 32)
    else
        API_KEY=$(date +%s | sha256sum | base64 | head -c 32)
    fi
    
    # Create .env file
    cat > "$MCP_HOME/.env" << EOF
# MCP Plopdock Configuration
MCP_API_KEY=$API_KEY
PORT=8080
LOG_LEVEL=info
NODE_ENV=production
EOF
    
    chmod 600 "$MCP_HOME/.env"
    
    # Create config.json
    cat > "$MCP_HOME/config.json" << EOF
{
  "version": "1.0.0",
  "port": 8080,
  "apiKey": "$API_KEY",
  "storage": {
    "logs": {
      "path": "$MCP_HOME/logs",
      "maxSize": "100MB",
      "rotation": "daily"
    }
  },
  "processes": {
    "maxConcurrent": 10,
    "defaultTimeout": 86400
  }
}
EOF
    
    echo -e "${GREEN}✓ Configuration generated${NC}"
    echo -e "${BLUE}API Key: $API_KEY${NC}"
}

# Update MCP configuration
update_mcp_config() {
    echo "Updating MCP configuration..."
    
    # Find or create .mcp.json
    local MCP_CONFIG=""
    
    if [ -f "$TARGET_DIR/.mcp.json" ]; then
        MCP_CONFIG="$TARGET_DIR/.mcp.json"
    elif [ -f "$HOME/.mcp.json" ]; then
        MCP_CONFIG="$HOME/.mcp.json"
    else
        MCP_CONFIG="$TARGET_DIR/.mcp.json"
        echo '{}' > "$MCP_CONFIG"
    fi
    
    # Check if jq is available
    if ! command_exists jq; then
        echo -e "${YELLOW}Warning: jq not found. Please manually add MCP server to $MCP_CONFIG${NC}"
        echo "Add this configuration:"
        cat << EOF
{
  "mcpServers": {
    "apm-plopdock": {
      "command": "node",
      "args": ["$MCP_HOME/src/index.js"],
      "env": {
        "CONFIG_PATH": "$MCP_HOME/config.json",
        "PROJECT_ROOT": "$TARGET_DIR"
      }
    }
  }
}
EOF
        return
    fi
    
    # Update configuration with jq
    jq --arg home "$MCP_HOME" \
       --arg project "$TARGET_DIR" \
       '.mcpServers["apm-plopdock"] = {
          "command": "node",
          "args": [($home + "/src/index.js")],
          "env": {
            "CONFIG_PATH": ($home + "/config.json"),
            "PROJECT_ROOT": $project
          }
        }' "$MCP_CONFIG" > tmp.json && mv tmp.json "$MCP_CONFIG"
    
    echo -e "${GREEN}✓ MCP configuration updated in: $MCP_CONFIG${NC}"
}

# Setup system service
setup_service() {
    echo "Setting up system service..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Create systemd service
        cat > /tmp/apm-plopdock.service << EOF
[Unit]
Description=APM Plopdock MCP Server
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$MCP_HOME
ExecStart=$(which node) $MCP_HOME/src/index.js
Restart=always
RestartSec=10
Environment="NODE_ENV=production"

[Install]
WantedBy=multi-user.target
EOF
        
        # Install service
        if command_exists systemctl; then
            sudo mv /tmp/apm-plopdock.service /etc/systemd/system/
            sudo systemctl daemon-reload
            sudo systemctl enable apm-plopdock
            sudo systemctl start apm-plopdock
            
            echo -e "${GREEN}✓ Systemd service installed and started${NC}"
        else
            echo -e "${YELLOW}Systemd not available. Please start manually.${NC}"
        fi
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Create LaunchAgent for macOS
        PLIST_PATH="$HOME/Library/LaunchAgents/com.apm.plopdock.plist"
        mkdir -p "$HOME/Library/LaunchAgents"
        
        cat > "$PLIST_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.apm.plopdock</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(which node)</string>
        <string>$MCP_HOME/src/index.js</string>
    </array>
    <key>WorkingDirectory</key>
    <string>$MCP_HOME</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$MCP_HOME/logs/stdout.log</string>
    <key>StandardErrorPath</key>
    <string>$MCP_HOME/logs/stderr.log</string>
</dict>
</plist>
EOF
        
        # Load the service
        launchctl load "$PLIST_PATH"
        
        echo -e "${GREEN}✓ LaunchAgent installed and started${NC}"
    fi
}

# Create hooks for server detection
setup_hooks() {
    echo "Setting up hooks..."
    
    local HOOKS_DIR="$TARGET_DIR/.apm/hooks"
    mkdir -p "$HOOKS_DIR"
    
    # Create server detection hook
    cat > "$HOOKS_DIR/mcp-notify.sh" << 'EOF'
#!/bin/bash
# Hook to notify MCP server about process starts

# Parse tool input
TOOL_NAME="$1"
TOOL_INPUT="$2"

if [[ "$TOOL_NAME" == "Bash" ]]; then
    # Extract command from input
    COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command' 2>/dev/null || echo "$TOOL_INPUT")
    
    # Check if it's a server start command
    if [[ "$COMMAND" =~ (npm|yarn|pnpm|node).*(start|dev|serve) ]]; then
        # Notify MCP server (optional - for logging)
        curl -s -X POST http://localhost:8080/api/hook/notify \
            -H "Content-Type: application/json" \
            -d "{
                \"type\": \"server-start\",
                \"command\": \"$COMMAND\",
                \"timestamp\": $(date +%s)
            }" || true
    fi
fi
EOF
    
    chmod +x "$HOOKS_DIR/mcp-notify.sh"
    
    echo -e "${GREEN}✓ Hooks configured${NC}"
}

# Main installation flow
main() {
    echo -e "${BLUE}=== MCP Plopdock Installation ===${NC}"
    echo ""
    
    # Check prerequisites
    if ! check_nodejs; then
        exit 1
    fi
    
    # Install components
    install_mcp_server
    generate_config
    update_mcp_config
    setup_service
    setup_hooks
    
    # Create log directory
    mkdir -p "$MCP_HOME/logs"
    
    echo ""
    echo -e "${GREEN}=== Installation Complete ===${NC}"
    echo ""
    echo "MCP Plopdock Dashboard: ${BLUE}http://localhost:8080${NC}"
    echo "Configuration: $MCP_HOME/config.json"
    echo "Logs: $MCP_HOME/logs/"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Restart Claude Code to connect to MCP server"
    echo "2. Visit the dashboard at http://localhost:8080"
    echo "3. Start any dev server - it will appear automatically!"
    echo ""
    echo -e "${GREEN}Happy debugging! 🚀${NC}"
}

# Run main installation
main
```

### Step 10: Create Service Templates

Create `installer/mcp-host/templates/systemd.service.template`:

```ini
[Unit]
Description=APM Plopdock MCP Server
After=network.target

[Service]
Type=simple
User={{USER}}
WorkingDirectory={{MCP_HOME}}
ExecStart={{NODE_PATH}} {{MCP_HOME}}/src/index.js
Restart=always
RestartSec=10
Environment="NODE_ENV=production"
Environment="PATH=/usr/local/bin:/usr/bin:/bin"

# Security
NoNewPrivileges=true
PrivateTmp=true
ProtectSystem=strict
ProtectHome=read-only
ReadWritePaths={{MCP_HOME}}/logs

[Install]
WantedBy=multi-user.target
```

Create `installer/mcp-host/templates/launchd.plist.template`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.apm.plopdock</string>
    <key>ProgramArguments</key>
    <array>
        <string>{{NODE_PATH}}</string>
        <string>{{MCP_HOME}}/src/index.js</string>
    </array>
    <key>WorkingDirectory</key>
    <string>{{MCP_HOME}}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <dict>
        <key>SuccessfulExit</key>
        <false/>
    </dict>
    <key>StandardOutPath</key>
    <string>{{MCP_HOME}}/logs/stdout.log</string>
    <key>StandardErrorPath</key>
    <string>{{MCP_HOME}}/logs/stderr.log</string>
    <key>EnvironmentVariables</key>
    <dict>
        <key>NODE_ENV</key>
        <string>production</string>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
```

### Step 11: Update Main Installer

Modify `installer/install.sh` to add MCP host installation:

```bash
# Add after line 600 (after template processing)

# Function to install MCP Plopdock
install_mcp_host() {
    echo ""
    echo -e "${YELLOW}Optional: MCP Plopdock Server${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [ "$USE_DEFAULTS" = true ]; then
        INSTALL_MCP="yes"
    else
        echo ""
        echo "The MCP Plopdock provides:"
        echo "• Persistent server hosting across AI agent sessions"
        echo "• Full console output visibility in web dashboard"
        echo "• Automatic process management for all tech stacks"
        echo "• Real-time log streaming at http://localhost:8080"
        echo ""
        
        # Check if .mcp.json exists
        if [ -f "$TARGET_DIR/.mcp.json" ] || [ -f "$HOME/.mcp.json" ]; then
            echo -e "${BLUE}Note: Existing MCP configuration found${NC}"
        fi
        
        printf "${YELLOW}Install MCP Plopdock Server? [Y/n]: ${NC}"
        read INSTALL_MCP
        INSTALL_MCP="${INSTALL_MCP:-Y}"
    fi
    
    if [[ "$INSTALL_MCP" =~ ^[Yy] ]]; then
        echo ""
        echo -e "${GREEN}Installing MCP Plopdock...${NC}"
        
        # Export TARGET_DIR for the installer
        export TARGET_DIR
        
        # Run MCP installer
        if [ -f "$INSTALLER_DIR/mcp-host/install-mcp-host.sh" ]; then
            bash "$INSTALLER_DIR/mcp-host/install-mcp-host.sh"
        else
            echo -e "${RED}Error: MCP installer not found${NC}"
            echo "Expected at: $INSTALLER_DIR/mcp-host/install-mcp-host.sh"
        fi
    else
        echo -e "${YELLOW}Skipping MCP Plopdock installation${NC}"
    fi
}

# Add to main installation flow
# After configure_project_settings();
install_mcp_host
```

### Step 12: Create MCP Configuration Template

Create `installer/templates/mcp.json.template`:

```json
{
  "mcpServers": {
    "apm-plopdock": {
      "command": "node",
      "args": ["{{MCP_HOME}}/src/index.js"],
      "env": {
        "CONFIG_PATH": "{{MCP_HOME}}/config.json",
        "PROJECT_ROOT": "{{PROJECT_ROOT}}",
        "PORT": "8080"
      }
    }
  }
}
```

---

## 📝 Testing Instructions

### 1. Test the Installation

```bash
# Make installer executable
chmod +x installer/install.sh
chmod +x installer/mcp-host/install-mcp-host.sh

# Run installer
./installer/install.sh

# When prompted, choose to install MCP Plopdock
```

### 2. Verify Installation

```bash
# Check if service is running
systemctl status apm-plopdock  # Linux
launchctl list | grep apm        # macOS

# Check if dashboard is accessible
curl http://localhost:8080/api/health

# Check MCP configuration
cat .mcp.json | jq '.mcpServers["apm-plopdock"]'
```

### 3. Test with Claude Code

1. Restart Claude Code
2. Run a command like `npm run dev`
3. Check dashboard at http://localhost:8080
4. Verify logs are streaming

---

## 🐛 Troubleshooting

### Common Issues

1. **Port 8080 already in use**
   - Edit `~/.apm-plopdock/config.json`
   - Change port number
   - Restart service

2. **MCP server not connecting**
   - Check `.mcp.json` exists
   - Verify paths are correct
   - Check Claude Code logs

3. **No logs appearing**
   - Verify server is running
   - Check WebSocket connection in browser console
   - Look at server logs: `~/.apm-plopdock/logs/server.log`

### Debug Commands

```bash
# View MCP server logs
tail -f ~/.apm-plopdock/logs/server.log

# Test MCP connection
echo '{}' | node ~/.apm-plopdock/src/index.js

# Manually start server
cd ~/.apm-plopdock && npm start
```

---

## 🎉 Success Criteria

Your implementation is successful when:

1. ✅ APM installer offers MCP host installation
2. ✅ MCP server installs without errors
3. ✅ `.mcp.json` is created/updated correctly
4. ✅ Dashboard is accessible at http://localhost:8080
5. ✅ Claude Code can use `server:start` tool
6. ✅ Console output appears in dashboard
7. ✅ Multiple tech stacks are detected correctly
8. ✅ Service starts automatically on boot

---

## 📚 Additional Resources

- [MCP Protocol Documentation](https://modelcontextprotocol.io)
- [Node.js Child Process Documentation](https://nodejs.org/api/child_process.html)
- [WebSocket API Reference](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket)
- [Systemd Service Files](https://www.freedesktop.org/software/systemd/man/systemd.service.html)

This completes the implementation guide. Follow each step carefully, test thoroughly, and you'll have a fully functional MCP Plopdock Server integrated with the APM installer!