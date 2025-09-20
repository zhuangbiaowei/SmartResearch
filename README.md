[中文版](README_zh.md)

# 🧠 SmartResearch - Chain of Learning & Thinking (CoLT)

[![Ruby Version](https://img.shields.io/badge/Ruby-3.1%2B-red)](https://www.ruby-lang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![SmartAgent](https://img.shields.io/badge/SmartAgent-Enabled-green)](https://github.com/zhuangbiaowei/smart_agent)
[![SmartPrompt](https://img.shields.io/badge/SmartPrompt-Integrated-blue)](https://github.com/zhuangbiaowei/smart_prompt)

**An AI research assistant with autonomous learning and MCP integration**

## 🌟 Core Mechanism: Chain of Learning & Thinking (CoLT)

SmartResearch implements an enhanced **Learning & Thinking Cycle** that goes beyond traditional Chain-of-Thought:

```
[Think] → [Search] → [Learn] → [Store] → [Repeat]
```

This self-reinforcing loop enables continuous knowledge accumulation, adaptive reasoning, and iterative improvement.

## 🚀 Key Features

### 🤖 Smart Agent System
- **Multi-Model Support**: Seamless integration with DeepSeek, Qwen, Kimi and other major LLMs
- **Tool Orchestration**: Dynamic tool calling with MCP (Model Context Protocol) integration
- **Autonomous Workflows**: Agent coordination of workers and tools for complex multi-step tasks

### 🔧 MCP Integration
- **OpenDigger**: Open source project analysis and metrics statistics
- **All-in-One Toolkit**: Comprehensive research and analysis toolset
- **Extensible Architecture**: Easy integration of new MCP servers and tools

### 📚 Knowledge Management
- **Vector Search**: PostgreSQL with pgvector integration for intelligent retrieval
- **Tag System**: Hierarchical tagging and relationship management for organized research

### 💬 Interactive Command Line Interface
- **Real-time Visualization**: RubyRich TUI-based interface for all operations in console
- **Conversation Management**: Save, load, and organize research conversations

### 🔍 Research Tools
- **Web Scraping**: MetaScrape integration for content extraction
- **Database Query**: SQL query capabilities for data analysis

## 📦 Installation

### Requirements
- Ruby 3.1+
- Python 3 + markitdown (to convert various content to Markdown format)
- SQLite3 (for Better_Prompt integration, conversation logging, prompt optimization)
- PostgreSQL + pgvector (for vector search functionality)

```bash
git clone https://github.com/zhuangbiaowei/SmartResearch.git
cd SmartResearch
bundle install
pip3 install markitdown[all]
```

### MCP Server Setup
```bash
# Install OpenDigger MCP server
git clone https://github.com/X-lab2017/open-digger-mcp-server
cd open-digger-mcp-server
npm install
npm run build
```

## 🛠️ Usage Guide

### Starting
```bash
./bin/smart_research
```

- In F2 (Communication & Exploration) mode: Ask questions directly, SmartResearch will help create search plans
- In F3 (Organize Knowledge Base) mode:
  - Type `h` for help
  - Type `dall` to download all web pages and documents that need complete content discovered in exploration mode
  - Type `ask question` to query the knowledge base directly
- In F4 (Creation & Output) mode:
  - Type `h` for help
  - Type `outline topic` to generate article outline and save to outline.json
  - Type `wa` to write a complete article and save to reports directory

## 🏗️ Architecture Overview

### Core Components
- **Application Layer**: RubyRich-based TUI and component architecture
- **Smart Agent System**: SmartAgent framework for LLM orchestration
- **Tool Ecosystem**: MCP-integrated tool extension capabilities
- **Knowledge Base**: Structured storage supporting vector search

### Workflow Pattern
1. **User Input** → Application layer processing
2. **Agent Coordination** → Routing to appropriate workers
3. **LLM Interaction** → Generating responses or tool calls
4. **Tool Execution** → MCP servers and custom tools
5. **Knowledge Integration** → Storing findings into research topics
6. **Response Generation** → Returning comprehensive answers

## 🤝 Contributing

Welcome contributions in:
- New MCP server integrations
- Additional research tools
- UI/UX optimization improvements
- Test cases and documentation
- Performance optimization

Please read the [Contribution Guide](CONTRIBUTING.md) for details.

## 📚 Learning Resources

- [Technical Introduction](TECHNICAL_INTRODUCTION.md) - Detailed architecture overview
- [SmartAgent Framework](https://github.com/zhuangbiaowei/smart_agent) - Agent system documentation
- [MCP Protocol](https://modelcontextprotocol.io/) - Model Context Protocol specification

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

## 🚀 Development Roadmap

- [ ] Enhanced vector search with hybrid retrieval
- [ ] Multi-modal research capabilities
- [ ] Collaborative research features
- [ ] Advanced visualization tools
- [ ] Plugin system for custom integrations