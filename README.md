[中文版](README_zh.md)

# 🧠 SmartResearch - Chain of Learning & Thinking (CoLT)

[![Ruby Version](https://img.shields.io/badge/Ruby-3.1%2B-red)](https://www.ruby-lang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![SmartAgent](https://img.shields.io/badge/SmartAgent-Enabled-green)](https://github.com/zhuangbiaowei/smart_agent)
[![SmartPrompt](https://img.shields.io/badge/SmartPrompt-Integrated-blue)](https://github.com/zhuangbiaowei/smart_prompt)

**An AI-powered research assistant with autonomous learning capabilities and MCP integration**

## 🌟 Core Concept: Chain of Learning & Thinking (CoLT)

SmartResearch implements an enhanced **Learning & Thinking Cycle** that goes beyond traditional Chain-of-Thought approaches:

```
[Think] → [Search] → [Learn] → [Store] → [Repeat]
```

This self-reinforcing loop enables persistent knowledge accumulation, adaptive reasoning, and continuous improvement through iterative learning.

## 🚀 Key Features

### 🤖 Intelligent Agent System
- **Multi-Model Support**: Seamless integration with DeepSeek, Qwen, Kimi, and other leading LLMs
- **Tool Orchestration**: Dynamic tool calling with MCP (Model Context Protocol) integration
- **Autonomous Workflows**: Agents coordinate workers and tools for complex multi-step tasks

### 🔧 MCP Integration
- **OpenDigger**: Open source project analytics and metrics
- **All-in-One Tools**: Comprehensive toolset for research and analysis
- **Extensible Architecture**: Easy integration of new MCP servers and tools

### 📚 Knowledge Management
- **Structured Storage**: SQLite-based research topic and document management
- **Vector Search**: Semantic search with pgvector integration for intelligent retrieval
- **Tag System**: Hierarchical tagging and relationship management for organized research

### 💬 Interactive CLI Interface
- **Real-time Visualization**: Live thinking process display with RubyRich TUI
- **Conversation Management**: Save, load, and organize research conversations
- **Model Switching**: On-the-fly model selection for optimal task performance

### 🔍 Research Tools
- **Web Scraping**: MetaScrape integration for content extraction
- **Code Generation**: Dynamic Ruby code generation and execution
- **Weather & Location**: Practical tools for real-world context
- **Database Query**: SQL query capabilities for data analysis

## 📦 Installation

### Requirements
- Ruby 3.1+
- SQLite3
- PostgreSQL (for vector search capabilities)
- Node.js (for MCP server dependencies)

```bash
git clone https://github.com/zhuangbiaowei/SmartResearch.git
cd SmartResearch
bundle install
```

### MCP Server Setup
```bash
# Install OpenDigger MCP server
cd /root/open-digger-mcp-server
npm install
npm run build
```

## 🛠️ Usage

### Basic Interaction
```bash
./bin/smart_research

# Sample Interaction
[SmartResearch v0.5] > What research shall we conduct today?
> Analyze the latest trends in quantum computing

[THINKING] Generating research hypotheses...
[SEARCHING] Querying knowledge base and external sources...
[LEARNING] Integrating new findings into research topics...
```

### Advanced Features

**Research Topic Management:**
```bash
# Create research topics
> Create research topic "Quantum Computing Advancements 2024"

# Search and organize findings
> Find related papers on quantum supremacy
```

**Tool Integration:**
```bash
# Use OpenDigger for open source analysis
> Analyze Vue.js project metrics on GitHub

# Web content extraction
> Scrape and analyze research paper from arXiv
```

**Conversation Management:**
- `F2`: Save current conversation
- `F3`: Load previous conversation
- `F4`: Switch AI models
- `F6`: Insert new line
- `↑/↓`: Navigate chat history

## 🏗️ Architecture Overview

### Core Components
- **Application Layer**: RubyRich-based TUI with component architecture
- **Agent System**: SmartAgent framework for LLM orchestration
- **Tool Ecosystem**: MCP-integrated tools for extended capabilities
- **Knowledge Base**: Structured storage with vector search

### Workflow Pattern
1. **User Input** → Processed by Application layer
2. **Agent Coordination** → Routes to appropriate workers
3. **LLM Interaction** → Generates responses or tool calls
4. **Tool Execution** → MCP servers and custom tools
5. **Knowledge Integration** → Stores findings in research topics
6. **Response Generation** → Returns comprehensive answers

## 🔧 Available Tools

### MCP Tools
- `opendigger`: Open source project analytics
- `all_in_one`: Comprehensive tool collection
- `amap`: Location and mapping services

### Custom Tools
- `get_weather`: Weather information retrieval
- `get_code`: Dynamic code generation and execution
- `meta_scrape`: Web content extraction
- `create_research_topic`: Research organization
- `query_db`: Database query capabilities

## 🤝 Contribution

We welcome contributions in:
- New MCP server integrations
- Additional research tools
- UI/UX enhancements
- Test cases and documentation
- Performance optimizations

Please read our [Contribution Guide](CONTRIBUTING.md) for details.

## 📚 Learning Resources

- [Technical Introduction](TECHNICAL_INTRODUCTION.md) - Detailed architecture overview
- [SmartAgent Framework](https://github.com/zhuangbiaowei/smart_agent) - Agent system documentation
- [MCP Protocol](https://modelcontextprotocol.io/) - Model Context Protocol specification

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

## 🚀 Roadmap

- [ ] Enhanced vector search with hybrid retrieval
- [ ] Multi-modal research capabilities
- [ ] Collaborative research features
- [ ] Advanced visualization tools
- [ ] Plugin system for custom integrations