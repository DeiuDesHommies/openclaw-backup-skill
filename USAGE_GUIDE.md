# Universal OpenClaw Backup Skill 使用指南

## 📖 关于这个 Skill

这是一个**完全通用**的 OpenClaw 配置备份工具，与之前的版本不同：

### 🎯 核心特性

| 特性 | 说明 |
|------|------|
| **自动检测** | 无需配置，自动发现你的 OpenClaw 安装位置 |
| **动态适配** | 自动识别所有 Agent（无论叫什么名字） |
| **跨平台** | macOS、Linux、Windows 全支持 |
| **版本无关** | 兼容所有 OpenClaw 版本 |
| **安全可靠** | 从不假设文件存在，优雅处理缺失组件 |

### 为什么需要通用版本？

OpenClaw 是高度可定制的系统，每个用户的配置都不同：
- 有人有 3 个 Agent，有人有 30 个
- Agent 名称各不相同（coder、writer、analyst...）
- 集成服务不同（Telegram、Slack、Discord...）
- 安装路径不同（标准路径、自定义路径、Docker...）

**传统备份工具假设固定结构，遇到不同配置就失败。**

**这个通用版本通过智能检测，适配任何 OpenClaw 配置。**

---

## 🚀 快速开始

### 第一步：下载 Skill

下载 `openclaw-backup-universal.tar.gz` 文件。

### 第二步：安装 Skill

```bash
# 解压到 OpenClaw skills 目录
tar -xzf openclaw-backup-universal.tar.gz -C ~/.openclaw/workspace/skills/
```

### 第三步：启用 Skill

编辑 `~/.openclaw/openclaw.json`：

```json
{
  "skills": {
    "entries": {
      "openclaw-backup-universal": {
        "enabled": true
      }
    }
  }
}
```

### 第四步：重启 OpenClaw

```bash
openclaw gateway restart
```

### 第五步：测试

```
"backup my openclaw config"
```

系统会自动：
1. 检测你的 OpenClaw 安装位置
2. 扫描所有配置文件
3. 发现所有 Agent（无论名称）
4. 识别启用的集成
5. 创建完整备份

---

## 💡 工作原理：基于发现的备份

### 传统备份 vs 通用备份

**传统备份（硬编码）：**
```
❌ 假设 Agent 叫 researcher、analyst、strategist
❌ 假设配置在 ~/.openclaw/
❌ 假设一定有 Telegram 集成
❌ 假设备份到 Desktop
→ 遇到不同配置就失败
```

**通用备份（智能检测）：**
```
✅ 扫描 agents/ 目录，发现所有 Agent
✅ 检测 OpenClaw 安装位置
✅ 识别实际启用的集成
✅ 动态选择备份位置
→ 适配任何配置
```

### 三步工作流程

1. **发现阶段**
   - 定位 OpenClaw 安装目录
   - 扫描配置文件
   - 枚举所有 Agent
   - 检测集成服务

2. **分类阶段**
   - 核心配置
   - Agent 配置
   - 凭证和密钥
   - 运行时数据
   - 可选集成

3. **执行阶段**
   - 仅备份检测到的内容
   - 跳过不存在的组件
   - 生成备份清单
   - 验证完整性

---

## 📦 备份内容（自动检测）

### 核心配置（如果存在）
- `openclaw.json` - 主配置文件
- `.env` - 环境变量和 API 密钥
- `BOOT.md` - 启动配置（如果有）
- `RECOVERY.md` - 恢复指南（如果有）
- `config.yaml` / `config.toml` - 其他配置格式
- 所有备份文件：`*.bak`, `*.backup-*`, `*.old`

### Agent 配置（动态发现）
**不再假设 Agent 名称！**

系统会自动扫描 `agents/` 目录，备份所有发现的 Agent：
- 如果你有 `coder/`、`writer/`、`analyst/` → 全部备份
- 如果你有 `agent-1/`、`agent-2/`、`agent-3/` → 全部备份
- 如果你只有 `main/` → 只备份这一个

**示例：**
```
你的配置：
agents/
├── my-coder/
├── my-writer/
└── my-analyst/

备份结果：
✓ 发现 3 个 Agent
✓ 备份 my-coder/
✓ 备份 my-writer/
✓ 备份 my-analyst/
```

### 认证凭证（如果配置）
自动检测并备份：
- 消息平台（Telegram、Slack、Discord、Feishu 等）
- OAuth Token 和 API 密钥
- Bot 配置和配对信息
- 任何 `credentials/` 或 `auth/` 目录中的文件

### 数据和知识（如果存在）
- `cron/` 或 `scheduler/` - 定时任务
- `shared-learnings/` 或 `knowledge/` - 知识库
- `memory/` - 持久化记忆
- `subagents/` - 子 Agent 记录
- `workspace/` - 工作区状态
- `logs/` - 最近日志（可选）

### 外部集成（自动检测）
如果你有 Claude、Cursor 等 IDE 集成：
- 搜索常见配置位置（`~/.claude/`、`~/.cursor/` 等）
- 如果找到则备份
- 如果没有则跳过

**不会因为缺少某个集成而失败！**

---

## 🎯 使用场景

### 场景 1：日常备份

```
"backup my openclaw config"
```

**自动执行：**
1. 检测 OpenClaw 安装目录
2. 扫描所有配置文件
3. 发现所有 Agent（3个、5个、10个都行）
4. 识别启用的集成（Telegram、Slack 或其他）
5. 创建时间戳备份目录
6. 生成备份清单和恢复指南

**备份位置优先级：**
1. 用户指定位置（如果提供）
2. Desktop 目录（如果存在且可写）
3. `~/openclaw-backups/`（通用回退）
4. 当前目录（最后手段）

---

### 场景 2：跨平台迁移

**从 macOS 迁移到 Linux：**

**在 macOS 上：**
```
"create migration backup"
```

系统创建平台无关的备份：
- 使用相对路径而非绝对路径
- 包含平台兼容性元数据
- 自动处理路径分隔符差异

**在 Linux 上：**
```
"restore migration backup from ~/Downloads"
```

系统自动：
- 翻译路径为 Linux 格式
- 调整文件权限
- 更新平台特定配置
- 验证兼容性

**支持的迁移路径：**
- macOS ↔ macOS
- macOS ↔ Linux
- Linux ↔ Linux
- Windows ↔ Windows
- Windows → Linux（带路径转换）
- Docker ↔ Native

---

### 场景 3：选择性备份

只备份特定组件：

```
"backup just config files"          # 仅核心配置
"backup agent configurations"       # 所有发现的 Agent
"backup my credentials"             # 所有认证信息
"backup shared learnings"           # 知识库和记忆
```

**示例：**
```
用户："I just want to backup my agent configurations"

系统：
1. 扫描 agents/ 目录
2. 发现：agent-a/, agent-b/, agent-c/
3. 创建备份（仅这些 Agent）
4. 报告："已备份 3 个 Agent：agent-a, agent-b, agent-c"
```

---

### 场景 4：定时自动备份

```
"setup daily backups"
```

**自动检测调度器：**
- **macOS**: 使用 launchd 或 cron
- **Linux**: 使用 systemd timer 或 cron
- **Windows**: 使用 Task Scheduler
- **Docker**: 使用容器调度器

**配置保留策略：**
- 保留最近 N 个备份（默认：7）
- 删除超过 X 天的备份（默认：30）
- 最少保留备份数（默认：3）

**通知（如果可用）：**
- 发送完成状态到配置的消息平台
- 如果没有消息集成，写入日志文件

---

### 场景 5：恢复配置

```
"restore from backup"
```

**智能恢复流程：**
1. 定位备份目录
2. 读取备份清单
3. 检测当前 OpenClaw 安装
4. 验证兼容性
5. 停止 OpenClaw 服务（如果运行）
6. 恢复清单中的组件
7. 验证恢复的文件
8. 重启服务

**安全特性：**
- 恢复前备份当前配置
- 覆盖前请求确认
- 先验证备份完整性
- 支持部分恢复
- 失败时可回滚

---

## 🔧 常用命令速查

| 你想做什么 | 对 OpenClaw 说 |
|-----------|----------------|
| 完整备份 | "backup my openclaw config" |
| 备份到指定位置 | "backup to ~/Documents" |
| 仅备份配置 | "backup just config files" |
| 仅备份 Agent | "backup agent configurations" |
| 设置自动备份 | "setup daily backups" |
| 查看备份列表 | "list all backups" |
| 验证备份 | "verify backup integrity" |
| 完整恢复 | "restore from backup" |
| 部分恢复 | "restore just agents from backup" |
| 迁移备份 | "create migration backup" |
| 增量备份 | "create incremental backup" |
| 加密备份 | "create encrypted backup" |
| 压缩备份 | "create compressed backup" |

---

## 🛠️ 高级功能

### 1. 增量备份

只备份自上次备份以来更改的文件。

```
"create incremental backup"
```

**优势：**
- 更快的备份速度
- 更小的备份体积
- 跟踪变更历史

---

### 2. 加密备份

加密敏感数据。

```
"create encrypted backup"
```

**自动加密：**
- `.env` 文件（API 密钥）
- `credentials/` 目录
- 匹配 `*secret*`、`*token*`、`*key*` 的文件

**加密方法：**
- 优先使用 GPG（如果可用）
- 回退到平台加密（Keychain、Secret Service）
- 提示输入密码

---

### 3. 压缩备份

创建单个压缩归档文件。

```
"create compressed backup"
```

**输出：** `openclaw-backup-YYYYMMDD-HHMMSS.tar.gz`

**压缩：**
- Unix 系统使用 tar + gzip
- Windows 使用 zip
- 通常减小 60-80% 体积

---

### 4. 远程备份

备份到远程位置。

```
"backup to /mnt/nas/backups"
"backup to \\server\backups"
```

**支持：**
- 网络驱动器（SMB、NFS）
- 云挂载（rclone、s3fs）
- SSH/SFTP 位置
- 任何可写路径

---

### 5. 备份验证

验证备份完整性而不恢复。

```
"verify backup integrity"
```

**检查：**
- 清单中的所有文件存在
- 文件大小匹配
- 校验和有效（如果可用）
- 备份可恢复

---

### 6. 备份比较

比较两个备份查看变更。

```
"compare backups"
"diff backup-1 and backup-2"
```

**显示：**
- 新增文件
- 删除文件
- 修改文件
- 配置变更

---

## ⚙️ 配置选项（可选）

Skill 开箱即用，但你可以自定义：

### 设置备份位置

```bash
export OPENCLAW_BACKUP_DIR=~/Documents/openclaw-backups
```

或者：
```
"set backup location to ~/Documents/openclaw-backups"
```

---

### 排除模式

创建 `.backupignore` 文件在 OpenClaw 根目录：

```
# 排除模式
*.log
sessions/
cache/
*.tmp
node_modules/
```

或者：
```
"exclude session histories from backup"
"exclude logs from backup"
```

---

### 保留策略

```
"keep last 14 backups"
"delete backups older than 60 days"
```

---

## 🔍 故障排除

### 问题 1："Cannot detect OpenClaw installation"

**原因：** OpenClaw 不在标准位置

**解决方案：**
```
"backup openclaw from /custom/path/to/openclaw"
```

或设置环境变量：
```bash
export OPENCLAW_HOME=/custom/path/to/openclaw
```

---

### 问题 2："Backup location not writable"

**原因：** 没有写入默认位置的权限

**解决方案：**
```
"backup to ~/Documents"
```

或修复权限：
```bash
chmod 755 ~/Desktop
```

---

### 问题 3："Some components not backed up"

**原因：** 某些组件不存在或不可访问

**解决方案：**

这是正常的！Skill 只备份存在的内容。

查看备份清单了解跳过了什么：
```bash
cat backup-manifest.json
```

清单会显示：
- ✓ 已备份的组件
- ⊘ 跳过的组件（不存在）
- ⚠ 警告（存在但无法访问）

---

### 问题 4："Restore fails with version mismatch"

**原因：** 备份来自不同的 OpenClaw 版本

**解决方案：**

Skill 会尝试自动迁移。如果失败：
```
"restore with compatibility mode"
```

或升级/降级 OpenClaw 到匹配备份的版本。

---

### 问题 5："Backup is too large"

**原因：** 包含会话历史或大型缓存

**解决方案：**
```
"backup without session histories"
"backup without caches"
```

或使用增量备份：
```
"create incremental backup"
```

---

## 🌍 平台特定说明

### macOS
- **默认位置**: `~/Desktop/openclaw-backups/`（如果 Desktop 存在）
- **调度器**: launchd 或 cron
- **加密**: 支持 Keychain

### Linux
- **默认位置**: `~/openclaw-backups/`
- **调度器**: systemd timer 或 cron
- **加密**: 支持 Secret Service

### Windows
- **默认位置**: `%USERPROFILE%\Desktop\openclaw-backups\`
- **调度器**: Task Scheduler
- **加密**: 支持 DPAPI

### Docker
- **检测**: 自动检测容器环境
- **备份**: 卷和绑定挂载
- **路径**: 处理容器特定路径

---

## 📋 最佳实践

### 1. 定期备份

**推荐频率：**
- **每天使用**: 每日自动备份
- **每周使用**: 每周自动备份
- **偶尔使用**: 重要变更前手动备份

**设置：**
```
"setup daily backups at 2am"
```

---

### 2. 重要操作前备份

**务必在以下操作前备份：**
- 升级 OpenClaw
- 修改核心配置
- 安装新 Skill 或插件
- 更改 Agent 配置
- 更新 API 密钥

**快速备份：**
```
"quick backup before changes"
```

---

### 3. 测试恢复

**每月验证：**
```
"verify latest backup"
```

**每季度测试恢复：**
1. 创建测试备份
2. 恢复到临时位置
3. 验证所有组件工作
4. 记录恢复时间

---

### 4. 多备份位置

**推荐策略：**
- **本地**: 快速访问，快速恢复
- **网络**: 共享访问，冗余
- **云端**: 异地，灾难恢复

**设置：**
```
"backup to ~/backups"              # 本地
"backup to /mnt/nas/backups"       # 网络
"backup to ~/cloud/backups"        # 云端（通过同步）
```

---

### 5. 保护敏感数据

**对于包含凭证的备份：**
```
"create encrypted backup"
```

**对于云存储：**
```bash
# 上传前加密
gpg -c openclaw-backup-*.tar.gz
# 只上传 .gpg 文件
```

**切勿：**
- 上传未加密的备份到公共云
- 分享未删除凭证的备份
- 将备份提交到版本控制

---

## 🆚 与原版 Skill 的对比

| 特性 | 原版 | 通用版 |
|------|------|--------|
| 自动检测安装位置 | ❌ | ✅ |
| 动态发现 Agent | ❌ | ✅ |
| 跨平台支持 | ⚠️ 部分 | ✅ 完全 |
| 版本无关 | ❌ | ✅ |
| 处理缺失文件 | ⚠️ 可能失败 | ✅ 优雅跳过 |
| 需要配置 | ✅ | ❌ |
| 硬编码路径 | ✅ | ❌ |
| 假设固定结构 | ✅ | ❌ |
| 适配自定义配置 | ❌ | ✅ |

---

## ✅ 成功标准

你会知道 Skill 正常工作当：
- ✅ 备份完成无错误
- ✅ 清单列出你的所有组件
- ✅ 备份可以成功恢复
- ✅ 备份中没有硬编码路径
- ✅ 在不同机器上工作
- ✅ 优雅处理缺失组件

---

## 📞 获取帮助

### 查看 Skill 帮助
```
"how to use backup skill"
```

### 查看备份状态
```
"backup status"
```

### 查看所有备份
```
"list all backups"
```

### 验证备份
```
"verify backup integrity"
```

---

## 🔄 更新 Skill

当有新版本发布时：

1. 下载新版本
2. 删除旧版本：
   ```bash
   rm -rf ~/.openclaw/workspace/skills/openclaw-backup-universal
   ```
3. 安装新版本：
   ```bash
   tar -xzf openclaw-backup-universal-v2.tar.gz -C ~/.openclaw/workspace/skills/
   ```
4. 重启 OpenClaw：
   ```bash
   openclaw gateway restart
   ```

---

## 📝 总结

### 核心优势

1. **零配置** - 开箱即用，自动适配
2. **智能检测** - 发现你的实际配置
3. **跨平台** - 在任何系统上工作
4. **版本无关** - 兼容所有 OpenClaw 版本
5. **安全可靠** - 优雅处理各种情况

### 快速命令

```bash
# 安装
tar -xzf openclaw-backup-universal.tar.gz -C ~/.openclaw/workspace/skills/

# 启用（在 openclaw.json 中）
"openclaw-backup-universal": { "enabled": true }

# 使用
"backup my openclaw config"

# 恢复
"restore from backup"
```

---

## 📄 许可证

MIT License - 自由使用、修改和分发

---

## 🙏 致谢

感谢 OpenClaw 社区的支持和反馈。

如果这个 Skill 帮到了你，欢迎分享给其他 OpenClaw 用户！

---

**这个 Skill 适配你的 OpenClaw，而不是让你适配 Skill。** 🎯
