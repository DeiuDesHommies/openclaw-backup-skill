# OpenClaw 通用备份技能

一个真正通用的 OpenClaw 备份解决方案，可自动适配任何配置。

[![Release](https://img.shields.io/github/v/release/DeiuDesHommies/openclaw-backup-skill)](https://github.com/DeiuDesHommies/openclaw-backup-skill/releases)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

[English](README.md) | 简体中文

## 🚀 快速安装（一键命令）

```bash
curl -fsSL https://raw.githubusercontent.com/DeiuDesHommies/openclaw-backup-skill/main/install.sh | bash
```

或者下载后手动安装：

```bash
wget https://github.com/DeiuDesHommies/openclaw-backup-skill/releases/download/v1.0.0/openclaw-backup-universal.tar.gz
tar -xzf openclaw-backup-universal.tar.gz -C ~/.openclaw/workspace/skills/
```

## 为什么说是"通用"？

与假设固定结构的传统备份工具不同，本技能：

- ✅ **自动检测** OpenClaw 安装位置
- ✅ **发现** 所有 agent（无论名称如何）
- ✅ **适配** 已启用的集成
- ✅ **支持** macOS、Linux 和 Windows
- ✅ **优雅处理** 缺失的组件
- ✅ **无需配置**

## 核心特性

### 🔍 智能发现
- 自动查找 OpenClaw 安装位置
- 扫描所有配置文件
- 动态检测所有 agent
- 识别已启用的集成

### 🌍 跨平台
- macOS（Intel 和 Apple Silicon）
- Linux（所有发行版）
- Windows（10/11）
- Docker 容器

### 🎯 版本无关
- 适用于所有 OpenClaw 版本
- 处理配置架构变更
- 支持版本间迁移

### 🔒 安全可靠
- 从不假设文件存在
- 备份前验证
- 创建还原点
- 失败时回滚

## 安装方法

### 🎯 方法 1：一键安装（推荐）

```bash
curl -fsSL https://raw.githubusercontent.com/DeiuDesHommies/openclaw-backup-skill/main/install.sh | bash
```

这将：
- ✅ 自动检测 OpenClaw 安装位置
- ✅ 下载最新版本
- ✅ 解压到正确位置
- ✅ 显示如何启用技能

### 📦 方法 2：手动下载

```bash
# 从 GitHub releases 下载
wget https://github.com/DeiuDesHommies/openclaw-backup-skill/releases/download/v1.0.0/openclaw-backup-universal.tar.gz

# 解压到 skills 目录
tar -xzf openclaw-backup-universal.tar.gz -C ~/.openclaw/workspace/skills/

# 在 openclaw.json 中启用
# 添加到 "skills" → "entries"：
{
  "openclaw-backup-universal": {
    "enabled": true
  }
}

# 重启 OpenClaw
openclaw gateway restart
```

### ⚡ 方法 3：快速安装（如果支持）

```bash
openclaw skill install openclaw-backup-universal
```

## 快速开始

安装后，只需说：

```
"备份我的 openclaw 配置"
```

就这么简单！技能将：
1. 检测 OpenClaw 安装位置
2. 发现所有组件
3. 创建完整备份
4. 生成还原说明

## 使用示例

### 完整备份
```
"备份我的 openclaw 配置"
"创建备份"
"备份所有内容"
```

### 选择性备份
```
"只备份配置文件"
"只备份 agent"
"备份我的凭证"
```

### 定时备份
```
"设置每日备份"
"创建自动备份计划"
```

### 还原
```
"从备份还原"
"恢复我的 openclaw 配置"
```

### 迁移
```
"创建迁移备份"
"从 ~/Downloads 还原迁移备份"
```

## 为什么是通用的？

### 无硬编码路径
- 自动检测 OpenClaw 位置
- 支持自定义安装路径
- 处理重定位的配置

### 无假设结构
- 动态发现 agent
- 不假设特定 agent 名称
- 适配您的 agent 配置

### 无固定集成
- 检测已启用的集成
- 只备份您使用的内容
- 处理自定义集成

### 平台独立
- 使用平台适当的路径
- 适配操作系统约定
- 正确处理路径分隔符

## 兼容性

### OpenClaw 版本
- ✅ 所有版本（版本无关设计）
- ✅ 自动适配配置架构变更
- ✅ 支持最新 npm 发布版本

### 平台
- ✅ macOS 10.15+
- ✅ Linux（Ubuntu、Debian、Fedora、Arch 等）
- ✅ Windows 10/11
- ✅ Docker 容器
- ✅ WSL2

### 部署类型
- ✅ 原生安装
- ✅ Docker 部署
- ✅ 多用户环境
- ✅ 自定义路径

## 配置（可选）

技能开箱即用，但您可以自定义：

### 设置备份位置
```bash
export OPENCLAW_BACKUP_DIR=~/Documents/openclaw-backups
```

### 排除模式
在 OpenClaw 根目录创建 `.backupignore`：
```
*.log
sessions/
cache/
*.tmp
```

### 保留策略
```
"保留最近 14 个备份"
"删除 60 天前的备份"
```

## 故障排除

### "无法检测 OpenClaw 安装"

**解决方案：**
```
"从 /custom/path 备份 openclaw"
```

或设置环境变量：
```bash
export OPENCLAW_HOME=/custom/path/to/openclaw
```

### "备份位置不可写"

**解决方案：**
```
"备份到 ~/Documents"
```

### "某些组件未备份"

这是正常的！技能只备份存在的内容。检查清单：
```
cat backup-manifest.json
```

## 高级功能

- **增量备份** - 仅备份更改的文件
- **加密备份** - 保护敏感数据
- **压缩备份** - 节省空间
- **远程备份** - 网络/云位置
- **备份验证** - 完整性检查
- **备份比较** - 查看变更

详细文档请参阅 SKILL.md。

## 与原始技能的比较

| 功能 | 原始版本 | 通用版本 |
|---------|----------|-----------|
| 自动检测 | ❌ | ✅ |
| 跨平台 | ⚠️ | ✅ |
| 版本无关 | ❌ | ✅ |
| 动态 agent | ❌ | ✅ |
| 处理缺失文件 | ⚠️ | ✅ |
| 需要配置 | ✅ | ❌ |

## 贡献

发现不兼容的配置？请报告：
- 您的 OpenClaw 版本
- 您的平台
- 您的配置结构
- 错误消息

## 许可证

MIT 许可证 - 可自由使用、修改和分发

## 支持

- 文档：参见 SKILL.md
- 问题：报告配置不兼容
- 社区：分享您的备份策略

---

**本技能适配您的 OpenClaw，而不是反过来。** 🎯
