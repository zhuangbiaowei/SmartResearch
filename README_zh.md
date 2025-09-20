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
- **多模型支持**：无缝集成DeepSeek、Qwen、Kimi等主流大语言模型
- **工具编排**：动态工具调用，支持MCP（模型上下文协议）集成
- **自主工作流**：代理协调工作者和工具完成复杂多步骤任务

### 🔧 MCP 集成
- **OpenDigger**：开源项目分析和指标统计
- **全能工具集**：综合研究和分析工具包
- **可扩展架构**：可以轻松集成新的 MCP 服务器和工具

### 📚 知识管理
- **向量搜索**：采用PG数据库，集成pgvector，实现智能检索
- **标签系统**：分层标签和关系管理，实现有序研究

### 💬 交互式命令行界面
- **实时可视化**：基于RubyRich TUI，在控制台完成所有操作
- **对话管理**：保存、加载和组织研究对话

### 🔍 研究工具
- **网页抓取**：MetaScrape集成，支持内容提取
- **数据库查询**：SQL查询能力支持数据分析

## 📦 安装

### 环境要求
- Ruby 3.1+
- Python 3 + markitdown，将各种内容统一转化为Markdown格式
- SQLite3（用于集成Better_Prompt，记录对话日志，优化各种提示词）
- PostgreSQL + pgvector（向量搜索功能）

```bash
git clone https://github.com/zhuangbiaowei/SmartResearch.git
cd SmartResearch
bundle install
pip3 install markitdown[all]
```

### MCP 服务器设置
```bash
# 安装 OpenDigger MCP 服务器
git clone https://github.com/X-lab2017/open-digger-mcp-server
cd open-digger-mcp-server
npm install
npm run build
```

## 🛠️ 使用指南

### 启动
```bash
./bin/smart_research
```

- 在F2（交流与探索）模式下，直接提出问题，SmartResearch会帮你指定搜索计划。
- 在F3（整理知识库）模式下
    - 输入h，获得帮助
    - 输入dall，下载在探索模式下发现的，所有需要获取完整内容的网页、文档
    - 输入ask 问题，向知识库直接提问
- 在F4（创作与输出）模式下
    - 输入h，获得帮助
    - 输入outline 主题，生成文章提纲并保存到 outline.json
    - wa，写一篇完整的文章，并保存到reports目录下

## 🏗️ 架构概述

### 核心组件
- **应用层**：基于 RubyRich 的 TUI 和组件架构
- **智能代理系统**：SmartAgent 框架进行 LLM 编排
- **工具生态**：MCP 集成工具扩展能力
- **知识库**：支持向量搜索的结构化存储

### 工作流模式
1. **用户输入** → 应用层处理
2. **代理协调** → 路由到适当的工作者
3. **LLM 交互** → 生成响应或工具调用
4. **工具执行** → MCP 服务器和自定义工具
5. **知识整合** → 将发现存储到研究主题
6. **响应生成** → 返回全面答案

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