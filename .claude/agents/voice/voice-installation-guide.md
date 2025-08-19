# Coherence Voice Notification System Installation Guide

This guide provides step-by-step instructions for installing and configuring the complete Coherence Voice Notification system.

## Overview

The Coherence Voice Notification system provides text-to-speech capabilities for all agent personas with:
- **Multi-provider support** (Piper, ElevenLabs, System TTS, Discord, Silent)
- **Automatic fallback** when primary TTS provider fails
- **Persona-specific voices** with customizable mappings
- **Cross-platform compatibility** (WSL2, Linux, macOS)
- **Comprehensive error handling** and graceful degradation

## Prerequisites

### System Requirements

**Minimum Requirements:**
- Bash 4.0+ (for associative arrays)
- Linux/WSL2/macOS with audio support
- 500MB free disk space (for voice models)
- Internet connection (for cloud TTS providers)

**Recommended Requirements:**
- jq (JSON processor) for settings management
- PulseAudio or ALSA for audio playback
- curl and wget for model downloads
- 2GB free disk space (for multiple voice models)

### Required Packages

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y bash curl wget jq pulseaudio-utils alsa-utils
```

**CentOS/RHEL:**
```bash
sudo yum install -y bash curl wget jq pulseaudio-utils alsa-utils
```

**macOS (via Homebrew):**
```bash
brew install bash curl wget jq
```

**WSL2 Specific:**
```bash
# Ensure audio forwarding is working
echo "export PULSE_SERVER=unix:/mnt/wslg/PulseServer" >> ~/.bashrc
source ~/.bashrc
```

## Installation Steps

### Step 1: Create Directory Structure

```bash
# Create APM voice system directories
mkdir -p /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice
mkdir -p /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-providers
mkdir -p /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-setup
mkdir -p /mnt/c/Code/agentic-persona-mapping/.cache/tts
mkdir -p /mnt/c/Code/agentic-persona-mapping/.claude
```

### Step 2: Install Core TTS Manager

Copy the TTS manager template to your project:

```bash
# Generate TTS manager from template
cp templates/templates/claude/agents/voice/tts-manager-template.sh.template \
   /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh

# Replace template variables (see Variable Substitution section)
# Make executable
chmod +x /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh
```

### Step 3: Install TTS Provider Scripts

Generate all TTS provider scripts:

```bash
# Generate provider scripts from templates
for provider in piper elevenlabs system discord none; do
    cp templates/templates/claude/agents/voice/tts-provider-template.sh.template \
       /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-providers/${provider}.sh
    
    # Customize each provider script (see Provider Configuration section)
    # Make executable
    chmod +x /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-providers/${provider}.sh
done
```

### Step 4: Generate Voice Scripts

Create persona-specific voice scripts:

```bash
# Generate all persona voice scripts
bash templates/templates/claude/agents/voice/voice-persona-scripts-template.sh.template generate

# This creates:
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakBase.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakDeveloper.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakArchitect.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakAnalyst.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakQa.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakPm.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakPo.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakSm.sh
# - /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakDesignArchitect.sh
```

### Step 5: Configure Settings

Create or update your settings file:

```bash
# Create settings.json if it doesn't exist
cat > /mnt/c/Code/agentic-persona-mapping/.claude/settings.json << 'EOF'
{
  "env": {
    "TTS_ENABLED": "{{TTS_ENABLED}}",
    "TTS_PROVIDER": "{{TTS_PROVIDER}}",
    "TTS_FALLBACK_PROVIDER": "{{TTS_FALLBACK_PROVIDER}}",
    
    "TTS_PIPER_INSTALL_PATH": "{{TTS_PIPER_INSTALL_PATH}}",
    "TTS_ELEVENLABS_API_KEY": "{{TTS_ELEVENLABS_API_KEY}}",
    "TTS_SYSTEM_VOICE": "{{TTS_SYSTEM_VOICE}}",
    "TTS_DISCORD_WEBHOOK_URL": "{{TTS_DISCORD_WEBHOOK_URL}}",
    
    "TTS_VOICE_ORCHESTRATOR_PIPER": "{{TTS_VOICE_ORCHESTRATOR_PIPER}}",
    "TTS_VOICE_DEVELOPER_PIPER": "{{TTS_VOICE_DEVELOPER_PIPER}}",
    "TTS_VOICE_ARCHITECT_PIPER": "{{TTS_VOICE_ARCHITECT_PIPER}}",
    "TTS_VOICE_ANALYST_PIPER": "{{TTS_VOICE_ANALYST_PIPER}}",
    "TTS_VOICE_QA_PIPER": "{{TTS_VOICE_QA_PIPER}}",
    "TTS_VOICE_PM_PIPER": "{{TTS_VOICE_PM_PIPER}}",
    "TTS_VOICE_PO_PIPER": "{{TTS_VOICE_PO_PIPER}}",
    "TTS_VOICE_SM_PIPER": "{{TTS_VOICE_SM_PIPER}}",
    "TTS_VOICE_DESIGNARCHITECT_PIPER": "{{TTS_VOICE_DESIGNARCHITECT_PIPER}}"
  }
}
EOF
```

## Variable Substitution

Replace the following template variables in all files:

### Core Variables
```bash
# Path variables
/mnt/c/Code/agentic-persona-mapping/.apm                    # /path/to/project/.apm
/mnt/c/Code/agentic-persona-mapping                # /path/to/project
{{VOICE_SCRIPT_PATH}}           # /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice
{{SETTINGS_FILE}}               # /mnt/c/Code/agentic-persona-mapping/.claude/settings.json
{{CACHE_DIR}}                   # /mnt/c/Code/agentic-persona-mapping/.cache/tts

# Configuration variables
{{TTS_ENABLED}}                 # true
{{TTS_PROVIDER}}                # auto
{{TTS_FALLBACK_PROVIDER}}       # none
{{DEFAULT_TTS_PROVIDER}}        # auto
{{DEFAULT_TTS_ENABLED}}         # true
{{DEFAULT_FALLBACK_PROVIDER}}   # none

# Version and metadata
{{VERSION}}                     # Current APM version
{{TEMPLATE_VERSION}}            # Template version (e.g., 1.0.0)
{{GENERATION_TIMESTAMP}}        # Current timestamp
{{TTS_MANAGER_NAME}}            # APM TTS Manager
{{TTS_MANAGER_VERSION}}         # Manager version
```

### Provider-Specific Variables
```bash
# Piper TTS
{{TTS_PIPER_INSTALL_PATH}}      # /mnt/c/Code/agentic-persona-mapping/.piper

# ElevenLabs
{{TTS_ELEVENLABS_API_KEY}}      # Your ElevenLabs API key
{{TTS_ELEVENLABS_ENABLED}}      # true/false

# Discord
{{TTS_DISCORD_ENABLED}}         # true/false
{{TTS_DISCORD_WEBHOOK_URL}}     # Discord webhook URL

# Voice mappings (see Voice Configuration section)
{{TTS_VOICE_*_*}}              # Voice IDs for persona/provider combinations
```

### Provider Preference
```bash
{{PROVIDER_PREFERENCE_ORDER}}   # piper, elevenlabs, system, discord, none
{{PROVIDER_PREFERENCE_ARRAY}}   # ("piper" "elevenlabs" "system" "discord" "none")
```

## Provider Configuration

### Piper TTS (Offline, Recommended)

Piper provides high-quality offline text-to-speech:

```bash
# Install Piper TTS
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh configure piper

# Or manually:
mkdir -p {{TTS_PIPER_INSTALL_PATH}}
cd {{TTS_PIPER_INSTALL_PATH}}

# Download Piper binary (Linux x64)
wget https://github.com/rhasspy/piper/releases/latest/download/piper_linux_x86_64.tar.gz
tar -xzf piper_linux_x86_64.tar.gz
mv piper/piper .
chmod +x piper

# Download voice models
mkdir -p models
cd models

# Download recommended voices
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/ryan/medium/en_US-ryan-medium.onnx
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/joe/medium/en_US-joe-medium.onnx
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/amy/medium/en_US-amy-medium.onnx
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/hfc_female/medium/en_US-hfc_female-medium.onnx
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/kusal/medium/en_US-kusal-medium.onnx

# Download corresponding model configs
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/ryan/medium/en_US-ryan-medium.onnx.json
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/joe/medium/en_US-joe-medium.onnx.json
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/amy/medium/en_US-amy-medium.onnx.json
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/hfc_female/medium/en_US-hfc_female-medium.onnx.json
wget https://huggingface.co/rhasspy/piper-voices/resolve/v1.0.0/en/en_US/kusal/medium/en_US-kusal-medium.onnx.json
```

### ElevenLabs (Cloud, Premium)

High-quality cloud-based TTS:

```bash
# Get API key from https://elevenlabs.io/
export TTS_ELEVENLABS_API_KEY="your-api-key-here"

# Add to settings.json
# Configure voice mappings (see Voice Configuration section)

# Test ElevenLabs
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test elevenlabs
```

### System TTS (OS Default)

Use the operating system's built-in TTS:

```bash
# Linux (espeak-ng)
sudo apt install espeak-ng

# macOS (built-in say command)
# No additional installation needed

# Test system TTS
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test system
```

### Discord Webhook (Notifications)

Send TTS notifications to Discord:

```bash
# Create Discord webhook in your server
export TTS_DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/..."

# Add to settings.json
# Test Discord integration
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test discord
```

## Voice Configuration

### Default Voice Mappings

Configure voice mappings for each persona:

```json
{
  "env": {
    // Piper voice mappings
    "TTS_VOICE_ORCHESTRATOR_PIPER": "ryan",
    "TTS_VOICE_DEVELOPER_PIPER": "joe",
    "TTS_VOICE_ARCHITECT_PIPER": "ryan",
    "TTS_VOICE_ANALYST_PIPER": "amy",
    "TTS_VOICE_QA_PIPER": "hfc_female",
    "TTS_VOICE_PM_PIPER": "joe",
    "TTS_VOICE_PO_PIPER": "ryan",
    "TTS_VOICE_SM_PIPER": "joe",
    "TTS_VOICE_DESIGNARCHITECT_PIPER": "kusal",
    
    // ElevenLabs voice mappings (replace with actual voice IDs)
    "TTS_VOICE_ORCHESTRATOR_ELEVENLABS": "21m00Tcm4TlvDq8ikWAM",
    "TTS_VOICE_DEVELOPER_ELEVENLABS": "AZnzlk1XvdvUeBnXmlld",
    "TTS_VOICE_ARCHITECT_ELEVENLABS": "EXAVITQu4vr4xnSDxMaL",
    "TTS_VOICE_ANALYST_ELEVENLABS": "ErXwobaYiN019PkySvjV",
    "TTS_VOICE_QA_ELEVENLABS": "MF3mGyEYCl7XYWbV9V6O",
    "TTS_VOICE_PM_ELEVENLABS": "TxGEqnHWrfWFTfGW9XjX",
    "TTS_VOICE_PO_ELEVENLABS": "VR6AewLTigWG4xSOukaG",
    "TTS_VOICE_SM_ELEVENLABS": "pNInz6obpgDQGcFmaJgB",
    "TTS_VOICE_DESIGNARCHITECT_ELEVENLABS": "yoZ06aMxZJJ28mfd3POQ",
    
    // System TTS voice mappings
    "TTS_VOICE_ORCHESTRATOR_SYSTEM": "default",
    "TTS_VOICE_DEVELOPER_SYSTEM": "default",
    "TTS_VOICE_ARCHITECT_SYSTEM": "default",
    "TTS_VOICE_ANALYST_SYSTEM": "default",
    "TTS_VOICE_QA_SYSTEM": "default",
    "TTS_VOICE_PM_SYSTEM": "default",
    "TTS_VOICE_PO_SYSTEM": "default",
    "TTS_VOICE_SM_SYSTEM": "default",
    "TTS_VOICE_DESIGNARCHITECT_SYSTEM": "default"
  }
}
```

### Finding ElevenLabs Voice IDs

```bash
# List available voices
curl -H "xi-api-key: $TTS_ELEVENLABS_API_KEY" \
     https://api.elevenlabs.io/v1/voices | jq '.voices[].voice_id'

# Or use the TTS manager
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh configure elevenlabs
```

## Installation Verification

### Step 1: System Check

```bash
# Run comprehensive diagnostics
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh diagnose
```

### Step 2: Provider Testing

```bash
# Test all available providers
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test-all

# Test specific provider
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test piper
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test elevenlabs
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test system
```

### Step 3: Voice Script Testing

```bash
# Test individual persona scripts
/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakOrchestrator.sh "Coherence Orchestrator test message"
/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakDeveloper.sh "Developer persona test"
/mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/speakQa.sh "QA framework test notification"

# Test all persona scripts
bash templates/templates/claude/agents/voice/voice-persona-scripts-template.sh.template test
```

### Step 4: Integration Testing

```bash
# Test TTS manager integration
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh speak orchestrator "Integration test successful"

# Test fallback functionality
TTS_PROVIDER=nonexistent /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh speak developer "Testing fallback"

# Test voice mappings
for persona in orchestrator developer architect analyst qa pm po sm design_architect; do
    echo "Testing $persona..."
    /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh speak $persona "Testing voice for $persona persona"
done
```

## Troubleshooting

### Common Issues

#### 1. No Audio Output

**Symptoms:** Scripts run without errors but no audio is heard

**Solutions:**
```bash
# Check audio system
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh diagnose

# WSL2 specific
export PULSE_SERVER=unix:/mnt/wslg/PulseServer
pulseaudio --start --log-target=syslog

# Test system audio
speaker-test -t wav -c 2
paplay /usr/share/sounds/alsa/Front_Center.wav
```

#### 2. Piper Models Not Found

**Symptoms:** "Voice model not found" errors

**Solutions:**
```bash
# Check model directory
ls {{TTS_PIPER_INSTALL_PATH}}/models/

# Re-download models
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh configure piper

# Check permissions
chmod -R 755 {{TTS_PIPER_INSTALL_PATH}}
```

#### 3. ElevenLabs API Errors

**Symptoms:** "Authentication failure" or "API errors"

**Solutions:**
```bash
# Verify API key
echo $TTS_ELEVENLABS_API_KEY

# Test API connectivity
curl -H "xi-api-key: $TTS_ELEVENLABS_API_KEY" \
     https://api.elevenlabs.io/v1/voices

# Check rate limits and usage
curl -H "xi-api-key: $TTS_ELEVENLABS_API_KEY" \
     https://api.elevenlabs.io/v1/user/subscription
```

#### 4. Permission Errors

**Symptoms:** "Permission denied" when running scripts

**Solutions:**
```bash
# Fix script permissions
find /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice -name "*.sh" -exec chmod +x {} \;
find /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts -name "*.sh" -exec chmod +x {} \;

# Fix directory permissions
chmod -R 755 /mnt/c/Code/agentic-persona-mapping/.apm/agents
chmod -R 755 /mnt/c/Code/agentic-persona-mapping/.cache/tts
```

#### 5. Settings Not Loading

**Symptoms:** Using default settings instead of configured values

**Solutions:**
```bash
# Verify settings file
cat /mnt/c/Code/agentic-persona-mapping/.claude/settings.json | jq .

# Check jq installation
which jq || sudo apt install jq

# Test settings parsing
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh list
```

### Performance Issues

#### Slow TTS Generation

```bash
# Use faster voice models (low quality)
# In piper provider, change to *-low.onnx models

# Enable caching
export TTS_CACHE_ENABLED=true

# Use local providers for development
export TTS_PROVIDER=piper
```

#### High Memory Usage

```bash
# Clear TTS cache regularly
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh clear-cache

# Limit cache size
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh clear-cache large

# Monitor cache usage
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh cache-stats
```

## Advanced Configuration

### Custom Voice Models

Add custom Piper voice models:

```bash
# Download custom model
wget https://example.com/custom-voice.onnx -O {{TTS_PIPER_INSTALL_PATH}}/models/custom-voice.onnx
wget https://example.com/custom-voice.onnx.json -O {{TTS_PIPER_INSTALL_PATH}}/models/custom-voice.onnx.json

# Update voice mappings
export TTS_VOICE_ORCHESTRATOR_PIPER=custom-voice
```

### Environment-Specific Configuration

```bash
# Development environment (fast, offline)
export TTS_PROVIDER=piper
export TTS_FALLBACK_PROVIDER=none

# Production environment (high quality, fallback)
export TTS_PROVIDER=elevenlabs
export TTS_FALLBACK_PROVIDER=piper

# CI/CD environment (silent)
export TTS_PROVIDER=none
```

### Monitoring and Logging

```bash
# Enable debug logging
export TTS_DEBUG=true
export TTS_VERBOSE=true

# View logs
tail -f /mnt/c/Code/agentic-persona-mapping/.cache/tts/tts-manager.log
tail -f /mnt/c/Code/agentic-persona-mapping/.cache/tts/voice.log

# Monitor usage statistics
/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh usage-stats
```

## Maintenance

### Regular Tasks

1. **Update Voice Models**
   ```bash
   # Check for new Piper models monthly
   /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh configure piper
   ```

2. **Clean Cache**
   ```bash
   # Weekly cache cleanup
   /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh clear-cache old
   ```

3. **Monitor API Usage**
   ```bash
   # Check ElevenLabs usage if using cloud TTS
   curl -H "xi-api-key: $TTS_ELEVENLABS_API_KEY" \
        https://api.elevenlabs.io/v1/user/subscription
   ```

4. **Validate Configuration**
   ```bash
   # Monthly system validation
   /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh diagnose
   /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test-all
   ```

### Backup and Recovery

```bash
# Backup configuration
cp /mnt/c/Code/agentic-persona-mapping/.claude/settings.json settings.json.backup
tar -czf voice-models-backup.tar.gz {{TTS_PIPER_INSTALL_PATH}}/models/

# Restore configuration
cp settings.json.backup /mnt/c/Code/agentic-persona-mapping/.claude/settings.json
tar -xzf voice-models-backup.tar.gz -C /
```

## Uninstallation

To completely remove the voice notification system:

```bash
# Remove voice scripts
rm -rf /mnt/c/Code/agentic-persona-mapping/.apm/agents/voice/
rm -rf /mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-*

# Remove cache
rm -rf /mnt/c/Code/agentic-persona-mapping/.cache/tts/

# Remove voice models (optional)
rm -rf {{TTS_PIPER_INSTALL_PATH}}

# Clean settings (remove TTS_* entries from settings.json)
```

## Support and Resources

### Documentation
- Voice Integration Guide: `voice-integration.md.template`
- TTS Configuration: `tts-configuration.yaml.template`
- Provider Templates: `tts-provider-template.sh.template`

### Community Resources
- Piper TTS: https://github.com/rhasspy/piper
- ElevenLabs API: https://docs.elevenlabs.io/
- Voice Models: https://huggingface.co/rhasspy/piper-voices

### Getting Help
1. Run diagnostics: `/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh diagnose`
2. Check logs: `/mnt/c/Code/agentic-persona-mapping/.cache/tts/*.log`
3. Test individual components: `/mnt/c/Code/agentic-persona-mapping/.apm/agents/scripts/tts-manager.sh test`

This installation guide ensures a complete, working voice notification system for your APM framework with comprehensive error handling, testing, and maintenance procedures.