[English](README.md)

# 🧠 SmartResearch - 学习与思考链（CoLT）

[![Ruby 版本](https://img.shields.io/badge/Ruby-3.1%2B-red)](https://www.ruby-lang.org)
[![许可证: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![SmartAgent](https://img.shields.io/badge/SmartAgent-已启用-green)](https://github.com/zhuangbiaowei/smart_agent)
[![SmartPrompt](https://img.shields.io/badge/SmartPrompt-已集成-blue)](https://github.com/zhuangbiaowei/smart_prompt)

**具备自主学习和MCP集成的AI研究助手**

## 🌟 核心机制：学习与思考链（CoLT）

SmartResearch 实现了超越传统思维链的增强型**学习思考循环**：

```
[思考] → [搜索] → [学习] → [存储] → [循环]
```

这种自我强化的循环通过迭代学习实现持续知识积累、自适应推理和持续改进。

## 🚀 主要功能

### 🤖 智能代理系统
- **多模型支持**：无缝集成 DeepSeek、Qwen、Kimi 等主流大语言模型
- **工具编排**：动态工具调用，支持 MCP（模型上下文协议）集成
- **自主工作流**：代理协调工作者和工具完成复杂多步骤任务

### 🔧 MCP 集成
- **OpenDigger**：开源项目分析和指标统计
- **全能工具集**：综合研究和分析工具包
- **可扩展架构**：轻松集成新的 MCP 服务器和工具

### 📚 知识管理
- **结构化存储**：基于 SQLite 的研究主题和文档管理
- **向量搜索**：集成 pgvector 的语义搜索，实现智能检索
- **标签系统**：分层标签和关系管理，实现有序研究

### 💬 交互式命令行界面
- **实时可视化**：RubyRich TUI 实时显示思考过程
- **对话管理**：保存、加载和组织研究对话
- **模型切换**：实时切换模型以获得最佳任务性能

### 🔍 研究工具
- **网页抓取**：MetaScrape 集成，支持内容提取
- **代码生成**：动态 Ruby 代码生成和执行
- **天气位置**：实用工具提供现实世界上下文
- **数据库查询**：SQL 查询能力支持数据分析

## 📦 安装

### 环境要求
- Ruby 3.1+
- SQLite3
- PostgreSQL（向量搜索功能）
- Node.js（MCP 服务器依赖）

```bash
git clone https://github.com/zhuangbiaowei/SmartResearch.git
cd SmartResearch
bundle install
```

### MCP 服务器设置
```bash
# 安装 OpenDigger MCP 服务器
cd /root/open-digger-mcp-server
npm install
npm run build
```

## 🛠️ 使用指南

### 基础交互
```bash
./bin/smart_research

# 示例交互
[SmartResearch v0.5] > 今天要开展什么研究？
> 分析量子计算的最新趋势

[思考中] 生成研究假设...
[搜索中] 查询知识库和外部资源...
[学习中] 将新发现整合到研究主题...
```

### 高级功能

**研究主题管理：**
```bash
# 创建研究主题
> 创建研究主题 "2024年量子计算进展"

# 搜索和组织发现
> 查找关于量子霸权的相关论文
```

**工具集成：**
```bash
# 使用 OpenDigger 进行开源分析
> 分析 GitHub 上 Vue.js 项目指标

# 网页内容提取
> 抓取并分析 arXiv 上的研究论文
```

**对话管理：**
- `F2`: 保存当前对话
- `F3`: 加载历史对话
- `F4`: 切换 AI 模型
- `F6`: 插入新行
- `↑/↓`: 浏览聊天历史

## 🏗️ 架构概述

### 核心组件
- **应用层**：基于 RubyRich 的 TUI 和组件架构
- **代理系统**：SmartAgent 框架进行 LLM 编排
- **工具生态**：MCP 集成工具扩展能力
- **知识库**：支持向量搜索的结构化存储

### 工作流模式
1. **用户输入** → 应用层处理
2. **代理协调** → 路由到适当的工作者
3. **LLM 交互** → 生成响应或工具调用
4. **工具执行** → MCP 服务器和自定义工具
5. **知识整合** → 将发现存储到研究主题
6. **响应生成** → 返回全面答案

## 🔧 可用工具

### MCP 工具
- `opendigger`: 开源项目分析
- `all_in_one`: 综合工具集合
- `amap`: 位置和地图服务

### 自定义工具
- `get_weather`: 天气信息检索
- `get_code`: 动态代码生成和执行
- `meta_scrape`: 网页内容提取
- `create_research_topic`: 研究组织管理
- `query_db`: 数据库查询能力

## 🤝 参与贡献

欢迎贡献：
- 新的 MCP 服务器集成
- 额外的研究工具
- UI/UX 优化改进
- 测试用例和文档
- 性能优化

请阅读[贡献指南](CONTRIBUTING.md)了解详情。

## 📚 学习资源

- [技术介绍](TECHNICAL_INTRODUCTION.cn.md) - 详细架构概述
- [SmartAgent 框架](https://github.com/zhuangbiaowei/smart_agent) - 代理系统文档
- [MCP 协议](https://modelcontextprotocol.io/) - 模型上下文协议规范

## 📄 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE)。

## 🚀 发展路线

- [ ] 增强混合检索的向量搜索
- [ ] 多模态研究能力
- [ ] 协作研究功能
- [ ] 高级可视化工具
- [ ] 自定义集成的插件系统