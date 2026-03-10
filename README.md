# Universal OpenClaw Backup Skill

A truly universal backup solution for OpenClaw that automatically adapts to any configuration.

[![Release](https://img.shields.io/github/v/release/DeiuDesHommies/openclaw-backup-skill)](https://github.com/DeiuDesHommies/openclaw-backup-skill/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 🚀 Quick Install (One Command)

```bash
curl -fsSL https://raw.githubusercontent.com/DeiuDesHommies/openclaw-backup-skill/main/install.sh | bash
```

Or download and run:

```bash
wget https://github.com/DeiuDesHommies/openclaw-backup-skill/releases/download/v1.0.0/openclaw-backup-universal.tar.gz
tar -xzf openclaw-backup-universal.tar.gz -C ~/.openclaw/workspace/skills/
```

## Why Universal?

Unlike traditional backup tools that assume a fixed structure, this skill:

- ✅ **Auto-detects** your OpenClaw installation location
- ✅ **Discovers** all agents (regardless of names)
- ✅ **Adapts** to your enabled integrations
- ✅ **Works** on macOS, Linux, and Windows
- ✅ **Handles** missing components gracefully
- ✅ **No configuration** required

## Key Features

### 🔍 Intelligent Discovery
- Automatically finds OpenClaw installation
- Scans for all configuration files
- Detects all agents dynamically
- Identifies enabled integrations

### 🌍 Cross-Platform
- macOS (Intel & Apple Silicon)
- Linux (all distributions)
- Windows (10/11)
- Docker containers

### 🎯 Version Agnostic
- Works with all OpenClaw versions
- Handles configuration schema changes
- Supports migration between versions

### 🔒 Safe & Reliable
- Never assumes files exist
- Validates before backup
- Creates restore points
- Rollback on failure

## Installation

### 🎯 Method 1: One-Click Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/DeiuDesHommies/openclaw-backup-skill/main/install.sh | bash
```

This will:
- ✅ Auto-detect your OpenClaw installation
- ✅ Download the latest release
- ✅ Extract to the correct location
- ✅ Show you how to enable the skill

### 📦 Method 2: Manual Download

```bash
# Download from GitHub releases
wget https://github.com/DeiuDesHommies/openclaw-backup-skill/releases/download/v1.0.0/openclaw-backup-universal.tar.gz

# Extract to skills directory
tar -xzf openclaw-backup-universal.tar.gz -C ~/.openclaw/workspace/skills/

# Enable in openclaw.json
# Add to "skills" → "entries":
{
  "openclaw-backup-universal": {
    "enabled": true
  }
}

# Restart OpenClaw
openclaw gateway restart
```

### ⚡ Method 3: Quick Install (if supported)

```bash
openclaw skill install openclaw-backup-universal
```

## Quick Start

Once installed, just say:

```
"backup my openclaw config"
```

That's it! The skill will:
1. Detect your OpenClaw installation
2. Discover all components
3. Create a complete backup
4. Generate restore instructions

## Usage Examples

### Full Backup
```
"backup my openclaw config"
"create a backup"
"backup everything"
```

### Selective Backup
```
"backup just config files"
"backup just agents"
"backup my credentials"
```

### Scheduled Backup
```
"setup daily backups"
"create automatic backup schedule"
```

### Restore
```
"restore from backup"
"recover my openclaw config"
```

### Migration
```
"create migration backup"
"restore migration backup from ~/Downloads"
```

## What Makes It Universal?

### No Hardcoded Paths
- Detects OpenClaw location automatically
- Works with custom installation paths
- Handles relocated configurations

### No Assumed Structure
- Discovers agents dynamically
- Doesn't assume specific agent names
- Adapts to your agent configuration

### No Fixed Integrations
- Detects enabled integrations
- Backs up only what you use
- Handles custom integrations

### Platform Independent
- Uses platform-appropriate paths
- Adapts to OS conventions
- Handles path separators correctly

## Compatibility

### OpenClaw Versions
- ✅ v2024.x
- ✅ v2025.x
- ✅ v2026.x
- ✅ Future versions (auto-adapts)

### Platforms
- ✅ macOS 10.15+
- ✅ Linux (Ubuntu, Debian, Fedora, Arch, etc.)
- ✅ Windows 10/11
- ✅ Docker containers
- ✅ WSL2

### Deployment Types
- ✅ Native installation
- ✅ Docker deployment
- ✅ Multi-user environments
- ✅ Custom paths

## Configuration (Optional)

The skill works out-of-the-box, but you can customize:

### Set Backup Location
```bash
export OPENCLAW_BACKUP_DIR=~/Documents/openclaw-backups
```

### Exclude Patterns
Create `.backupignore` in OpenClaw root:
```
*.log
sessions/
cache/
*.tmp
```

### Retention Policy
```
"keep last 14 backups"
"delete backups older than 60 days"
```

## Troubleshooting

### "Cannot detect OpenClaw installation"

**Solution:**
```
"backup openclaw from /custom/path"
```

Or set environment variable:
```bash
export OPENCLAW_HOME=/custom/path/to/openclaw
```

### "Backup location not writable"

**Solution:**
```
"backup to ~/Documents"
```

### "Some components not backed up"

This is normal! The skill only backs up what exists. Check the manifest:
```
cat backup-manifest.json
```

## Advanced Features

- **Incremental backup** - Only changed files
- **Encrypted backup** - Secure sensitive data
- **Compressed backup** - Save space
- **Remote backup** - Network/cloud locations
- **Backup verification** - Integrity checks
- **Backup comparison** - See what changed

See SKILL.md for detailed documentation.

## Comparison with Original Skill

| Feature | Original | Universal |
|---------|----------|-----------|
| Auto-detection | ❌ | ✅ |
| Cross-platform | ⚠️ | ✅ |
| Version-agnostic | ❌ | ✅ |
| Dynamic agents | ❌ | ✅ |
| Handles missing files | ⚠️ | ✅ |
| Configuration required | ✅ | ❌ |

## Contributing

Found a configuration that doesn't work? Please report:
- Your OpenClaw version
- Your platform
- Your configuration structure
- Error messages

## License

MIT License - Free to use, modify, and distribute

## Support

- Documentation: See SKILL.md
- Issues: Report configuration incompatibilities
- Community: Share your backup strategies

---

**This skill adapts to YOUR OpenClaw, not the other way around.** 🎯
