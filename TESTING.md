# OpenClaw Backup Universal Skill 验证方案

## 验证目标

确保通用版skill能够：
1. 适配不同的Agent配置
2. 处理缺失的文件和目录
3. 适配不同的集成服务
4. 在不同路径下工作
5. 优雅处理各种边界情况

---

## 验证方法 1：模拟不同配置环境

### 测试场景 1：最小配置
创建一个最小的OpenClaw配置，只有核心文件。

```bash
# 创建测试目录
mkdir -p /tmp/openclaw-test-minimal
cd /tmp/openclaw-test-minimal

# 创建最小配置
cat > openclaw.json << 'EOF'
{
  "meta": {
    "lastTouchedVersion": "2026.3.2"
  },
  "models": {
    "providers": {}
  }
}
EOF

cat > .env << 'EOF'
TEST_API_KEY=test123
EOF

# 创建一个agent
mkdir -p agents/test-agent
echo "test config" > agents/test-agent/config.json

# 测试备份
export OPENCLAW_HOME=/tmp/openclaw-test-minimal
```

**预期结果：**
- ✅ 检测到 openclaw.json
- ✅ 检测到 .env
- ✅ 检测到 1 个 agent (test-agent)
- ✅ 跳过不存在的 BOOT.md, RECOVERY.md
- ✅ 跳过不存在的 credentials/, cron/, memory/
- ✅ 成功创建备份

---

### 测试场景 2：自定义Agent名称
测试非标准Agent名称。

```bash
mkdir -p /tmp/openclaw-test-custom
cd /tmp/openclaw-test-custom

# 创建配置
cat > openclaw.json << 'EOF'
{
  "meta": {},
  "agents": {}
}
EOF

# 创建自定义名称的agents
mkdir -p agents/my-coder
mkdir -p agents/my-writer
mkdir -p agents/my-reviewer
mkdir -p agents/专家助手
mkdir -p agents/agent-123

echo "config" > agents/my-coder/config.json
echo "config" > agents/my-writer/config.json
echo "config" > agents/my-reviewer/config.json
echo "config" > agents/专家助手/config.json
echo "config" > agents/agent-123/config.json

export OPENCLAW_HOME=/tmp/openclaw-test-custom
```

**预期结果：**
- ✅ 检测到 5 个 agent
- ✅ 正确识别非英文名称（专家助手）
- ✅ 正确识别数字名称（agent-123）
- ✅ 不假设特定agent名称
- ✅ 备份所有发现的agent

---

### 测试场景 3：缺失常见文件
测试当常见文件不存在时的处理。

```bash
mkdir -p /tmp/openclaw-test-missing
cd /tmp/openclaw-test-missing

# 只创建部分文件
cat > openclaw.json << 'EOF'
{"meta": {}}
EOF

# 不创建 .env
# 不创建 BOOT.md
# 不创建 agents/
# 不创建 credentials/

export OPENCLAW_HOME=/tmp/openclaw-test-missing
```

**预期结果：**
- ✅ 检测到 openclaw.json
- ✅ 优雅跳过缺失的 .env
- ✅ 优雅跳过缺失的 BOOT.md
- ✅ 优雅跳过缺失的 agents/
- ✅ 优雅跳过缺失的 credentials/
- ✅ 生成备份清单，标注哪些被跳过
- ✅ 不报错，成功完成备份

---

### 测试场景 4：不同集成配置
测试不同的集成服务。

```bash
mkdir -p /tmp/openclaw-test-integrations
cd /tmp/openclaw-test-integrations

cat > openclaw.json << 'EOF'
{"meta": {}}
EOF

# 场景 4a: 只有 Telegram
mkdir -p credentials
echo '{"token": "test"}' > credentials/telegram-config.json

# 场景 4b: 只有 Slack
# mkdir -p credentials
# echo '{"token": "test"}' > credentials/slack-config.json

# 场景 4c: 没有任何集成
# (不创建 credentials/)

export OPENCLAW_HOME=/tmp/openclaw-test-integrations
```

**预期结果：**
- ✅ 场景4a: 检测到Telegram，备份相关配置
- ✅ 场景4b: 检测到Slack，备份相关配置
- ✅ 场景4c: 没有集成，跳过credentials/
- ✅ 不假设特定集成一定存在

---

### 测试场景 5：自定义安装路径
测试非标准安装路径。

```bash
# 测试路径1: 自定义home目录
mkdir -p /opt/my-openclaw
cat > /opt/my-openclaw/openclaw.json << 'EOF'
{"meta": {}}
EOF

export OPENCLAW_HOME=/opt/my-openclaw

# 测试路径2: 相对路径
mkdir -p ./custom-openclaw
cat > ./custom-openclaw/openclaw.json << 'EOF'
{"meta": {}}
EOF

export OPENCLAW_HOME=./custom-openclaw
```

**预期结果：**
- ✅ 正确检测 /opt/my-openclaw
- ✅ 正确处理相对路径
- ✅ 不依赖 ~/.openclaw/ 硬编码路径

---

## 验证方法 2：检查SKILL.md内容

### 检查点 1：无硬编码Agent名称

```bash
# 搜索硬编码的agent名称
grep -i "researcher\|analyst\|strategist\|architect\|monitor" \
  ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md
```

**预期结果：**
- ❌ 不应该找到这些特定agent名称
- ✅ 应该使用 "all agents", "discovered agents", "<agent-1>", "<agent-2>" 等通用描述

---

### 检查点 2：无硬编码路径

```bash
# 搜索硬编码的绝对路径
grep -E "~/\.|/Users/|~/.openclaw/|~/.claude/" \
  ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md | \
  grep -v "# " | grep -v "example" | grep -v "示例"
```

**预期结果：**
- ❌ 不应该找到硬编码的绝对路径（除了注释和示例）
- ✅ 应该使用 "<backup-location>", "detected directory", "OpenClaw installation" 等描述

---

### 检查点 3：无特定集成假设

```bash
# 搜索特定集成服务
grep -i "telegram\|feishu\|slack" \
  ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md | \
  grep -v "etc\|example\|示例\|if\|detected"
```

**预期结果：**
- ❌ 不应该假设这些集成一定存在
- ✅ 应该使用 "if configured", "if detected", "messaging platforms (Telegram, Slack, etc.)" 等条件描述

---

### 检查点 4：包含平台检测逻辑

```bash
# 搜索平台相关描述
grep -i "macOS\|Linux\|Windows\|platform\|cross-platform" \
  ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md | head -10
```

**预期结果：**
- ✅ 应该找到平台检测相关描述
- ✅ 应该有针对不同平台的说明

---

## 验证方法 3：对比原版和通用版

### 对比脚本

```bash
#!/bin/bash

echo "=== 对比分析 ==="
echo ""

echo "1. Agent名称硬编码检查："
echo "原版："
grep -c "researcher\|analyst\|strategist" \
  ~/.openclaw/workspace/skills/backup-config/SKILL.md || echo "0"
echo "通用版："
grep -c "researcher\|analyst\|strategist" \
  ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md || echo "0"
echo ""

echo "2. 硬编码路径检查："
echo "原版："
grep -c "~/Desktop\|~/.openclaw/\|~/.claude/" \
  ~/.openclaw/workspace/skills/backup-config/SKILL.md || echo "0"
echo "通用版："
grep -c "~/Desktop\|~/.openclaw/\|~/.claude/" \
  ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md | \
  grep -v "example" || echo "0"
echo ""

echo "3. 'auto-detect' 或 'discover' 关键词："
echo "原版："
grep -ic "auto-detect\|discover\|detect" \
  ~/.openclaw/workspace/skills/backup-config/SKILL.md || echo "0"
echo "通用版："
grep -ic "auto-detect\|discover\|detect" \
  ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md || echo "0"
echo ""

echo "4. 'if present' 或 'if exists' 条件检查："
echo "原版："
grep -ic "if present\|if exists\|if configured\|if detected" \
  ~/.openclaw/workspace/skills/backup-config/SKILL.md || echo "0"
echo "通用版："
grep -ic "if present\|if exists\|if configured\|if detected" \
  ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md || echo "0"
echo ""

echo "5. 文件大小对比："
echo "原版："
wc -c ~/.openclaw/workspace/skills/backup-config/SKILL.md | awk '{print $1 " bytes"}'
echo "通用版："
wc -c ~/.openclaw/workspace/skills/openclaw-backup-universal/SKILL.md | awk '{print $1 " bytes"}'
```

**预期结果：**
- 原版应该有更多硬编码agent名称
- 原版应该有更多硬编码路径
- 通用版应该有更多"detect"、"discover"关键词
- 通用版应该有更多条件检查（"if present"等）

---

## 验证方法 4：实际安装测试

### 步骤 1：在测试环境安装

```bash
# 创建干净的测试环境
mkdir -p /tmp/openclaw-test-install
cd /tmp/openclaw-test-install

# 解压skill
tar -xzf ~/Desktop/openclaw-backup-universal.tar.gz

# 检查文件结构
ls -la openclaw-backup-universal/
```

**预期结果：**
- ✅ 包含 SKILL.md
- ✅ 包含 _meta.json
- ✅ 包含 package.json
- ✅ 包含 README.md
- ✅ 没有多余文件

---

### 步骤 2：检查元数据

```bash
# 检查 _meta.json
cat openclaw-backup-universal/_meta.json

# 检查 package.json
cat openclaw-backup-universal/package.json
```

**预期结果：**
- ✅ version 是 "2.0.0"
- ✅ slug 是 "openclaw-backup-universal"
- ✅ 包含正确的时间戳

---

### 步骤 3：检查 frontmatter

```bash
# 提取 SKILL.md 的 frontmatter
head -5 openclaw-backup-universal/SKILL.md
```

**预期结果：**
```yaml
---
name: openclaw-backup-universal
description: Universal OpenClaw configuration backup and restore tool with automatic detection...
---
```

- ✅ name 正确
- ✅ description 包含 "universal", "automatic detection"
- ✅ 触发词包含通用关键词

---

## 验证方法 5：文档一致性检查

### 检查 README 和 SKILL.md 一致性

```bash
# 检查README中提到的功能在SKILL.md中是否都有说明
echo "README中的关键功能："
grep "^-" openclaw-backup-universal/README.md | head -10

echo ""
echo "检查这些功能在SKILL.md中是否存在..."
# 手动检查每个功能
```

**预期结果：**
- ✅ README 中提到的所有功能在 SKILL.md 中都有详细说明
- ✅ 两个文档的描述一致
- ✅ 没有矛盾的说明

---

## 验证清单

### 通用性验证
- [ ] 没有硬编码的agent名称（researcher, analyst等）
- [ ] 没有硬编码的绝对路径（~/.openclaw/, ~/.claude/）
- [ ] 没有假设特定集成一定存在
- [ ] 包含平台检测逻辑（macOS/Linux/Windows）
- [ ] 使用条件描述（"if present", "if detected"）
- [ ] 使用通用描述（"all agents", "discovered components"）

### 功能完整性验证
- [ ] 支持自动检测安装位置
- [ ] 支持动态发现agent
- [ ] 支持跨平台迁移
- [ ] 支持处理缺失文件
- [ ] 支持自定义路径
- [ ] 支持增量备份
- [ ] 支持加密备份
- [ ] 支持压缩备份

### 文档质量验证
- [ ] SKILL.md 结构清晰
- [ ] README.md 简洁明了
- [ ] 使用指南详细完整
- [ ] 三个文档内容一致
- [ ] 没有错别字和语法错误
- [ ] 示例代码可执行

### 打包质量验证
- [ ] tar.gz 文件可以正常解压
- [ ] 文件权限正确
- [ ] 没有多余文件
- [ ] 文件大小合理（< 10MB）
- [ ] 元数据正确

---

## 快速验证命令

```bash
#!/bin/bash
# 快速验证脚本

echo "🔍 开始验证通用版 OpenClaw Backup Skill..."
echo ""

SKILL_DIR=~/.openclaw/workspace/skills/openclaw-backup-universal
SKILL_MD=$SKILL_DIR/SKILL.md

# 1. 检查文件存在
echo "✓ 检查文件结构..."
test -f $SKILL_MD && echo "  ✅ SKILL.md 存在" || echo "  ❌ SKILL.md 缺失"
test -f $SKILL_DIR/_meta.json && echo "  ✅ _meta.json 存在" || echo "  ❌ _meta.json 缺失"
test -f $SKILL_DIR/README.md && echo "  ✅ README.md 存在" || echo "  ❌ README.md 缺失"
echo ""

# 2. 检查硬编码
echo "✓ 检查硬编码内容..."
HARDCODED_AGENTS=$(grep -c "researcher\|analyst\|strategist" $SKILL_MD 2>/dev/null || echo "0")
if [ "$HARDCODED_AGENTS" -eq "0" ]; then
  echo "  ✅ 无硬编码agent名称"
else
  echo "  ⚠️  发现 $HARDCODED_AGENTS 处硬编码agent名称"
fi

# 3. 检查检测逻辑
echo "✓ 检查自动检测逻辑..."
DETECT_COUNT=$(grep -ic "detect\|discover\|auto" $SKILL_MD 2>/dev/null || echo "0")
if [ "$DETECT_COUNT" -gt "10" ]; then
  echo "  ✅ 包含充分的检测逻辑 ($DETECT_COUNT 处)"
else
  echo "  ⚠️  检测逻辑较少 ($DETECT_COUNT 处)"
fi

# 4. 检查条件描述
echo "✓ 检查条件描述..."
CONDITIONAL_COUNT=$(grep -ic "if present\|if exists\|if configured\|if detected" $SKILL_MD 2>/dev/null || echo "0")
if [ "$CONDITIONAL_COUNT" -gt "5" ]; then
  echo "  ✅ 包含充分的条件检查 ($CONDITIONAL_COUNT 处)"
else
  echo "  ⚠️  条件检查较少 ($CONDITIONAL_COUNT 处)"
fi

# 5. 检查平台支持
echo "✓ 检查平台支持..."
PLATFORM_COUNT=$(grep -ic "macOS\|Linux\|Windows\|cross-platform" $SKILL_MD 2>/dev/null || echo "0")
if [ "$PLATFORM_COUNT" -gt "5" ]; then
  echo "  ✅ 包含跨平台支持 ($PLATFORM_COUNT 处)"
else
  echo "  ⚠️  平台支持描述较少 ($PLATFORM_COUNT 处)"
fi

# 6. 检查打包
echo "✓ 检查打包文件..."
TARBALL=~/Desktop/openclaw-backup-universal.tar.gz
if [ -f "$TARBALL" ]; then
  SIZE=$(ls -lh "$TARBALL" | awk '{print $5}')
  echo "  ✅ 打包文件存在 ($SIZE)"
else
  echo "  ❌ 打包文件不存在"
fi

echo ""
echo "🎉 验证完成！"
```

---

## 总结

通过以上验证方法，可以确保通用版skill：
1. ✅ 真正通用（无硬编码）
2. ✅ 智能检测（自动适配）
3. ✅ 跨平台（macOS/Linux/Windows）
4. ✅ 健壮性（优雅处理边界情况）
5. ✅ 文档完整（清晰易懂）

建议按顺序执行：
1. 先运行快速验证脚本
2. 再进行对比分析
3. 最后进行实际环境测试
