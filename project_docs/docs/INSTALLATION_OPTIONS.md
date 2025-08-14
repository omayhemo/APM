# APM Framework Installation Options

## Fixed! Interactive Mode Now Works

The installer has been updated to properly handle interactive mode even when piped through curl.

## Installation Methods

### 1. Interactive Installation (Choose Your Options)
```bash
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash
```

This will prompt you for:
- Project name
- Plopdock MCP Server setup
- TTS provider selection
- Notification preferences
- Python support

### 2. Silent Installation (Use All Defaults)
```bash
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh | bash -s -- --defaults
```

This will:
- Use current directory name as project name
- Skip Plopdock MCP setup
- Use Piper TTS (offline)
- Disable all notifications
- Skip Python virtual environment setup

### 3. Download First, Then Run (Alternative Method)
If you still have issues with interactive mode:

```bash
# Download installer
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/master/install.sh -o install-apm.sh

# Make executable
chmod +x install-apm.sh

# Run interactively
./install-apm.sh

# Or run with defaults
./install-apm.sh --defaults
```

## What Was Fixed

The installer was failing to accept user input when piped through curl because stdin was already being used by the pipe. The fix redirects stdin to `/dev/tty` to allow interactive prompts to work properly.

## Troubleshooting

If you still can't make selections:

1. **Check if you have a TTY**:
   ```bash
   tty
   ```
   Should output something like `/dev/pts/0`

2. **Try the download-first method** shown above

3. **Use the --defaults flag** for a quick installation

## Current Version

The fix is in commit `b0e5de1` and will be available once GitHub's CDN updates (usually 5-10 minutes).

For immediate use:
```bash
curl -fsSL https://raw.githubusercontent.com/omayhemo/APM/b0e5de1/install.sh | bash
```