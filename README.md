[中文版](README_zh.md)

# 🧠 SmartResearch - Chain of Learning & Thinking (CoLT)

[![Ruby Version](https://img.shields.io/badge/Ruby-3.1%2B-red)](https://www.ruby-lang.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**An AI-powered assistant that evolves through iterative learning loops**

## 🌟 Core Concept: Chain of Learning & Thinking (CoLT)

Unlike traditional Chain-of-Thought (CoT) approaches, SmartResearch implements an enhanced **Learning & Thinking Cycle**:

```
[Think] → [Search] → [Learn] → [Store] → [Repeat]
```

This self-reinforcing loop enables persistent knowledge accumulation and adaptive reasoning.

## 🚀 Key Features

- **Autonomous Learning Engine**
  - Web/Local knowledge retrieval
  - Contextual knowledge analysis
  - SQLite-based memory storage
- **Interactive CLI Interface**
  - Real-time thinking visualization
  - Dual-feedback mechanism:
    - Result validation
    - Knowledge correction
- **Extensible Architecture**
  - Modular plugin system
  - Custom learning strategies
  - Multi-source integration

## 📦 Installation

### Requirements
- Ruby 3.1+
- SQLite3

```bash
git clone https://github.com/zhuangbiaowei/SmartResearch.git
cd SmartResearch
bundle install
```

## 🛠️ Usage

```bash
./bin/smart_research

# Sample Interaction
[SmartResearch v0.1] > What task shall we conquer today?
> Explain quantum computing basics

[THINKING] Generating initial hypotheses...
[SEARCHING] Local knowledge (3 entries found) + Web resources
[LEARNING] Integrating 2 new concepts into knowledge base...

Output: Quantum computing leverages qubits to...
```

## 📚 Feedback Mechanism

**Correct Results:**
```bash
[Feedback] Is this answer correct? (Y/n/d) d
> The explanation about superposition needs refinement
```

**Audit Knowledge:**
```bash
[Knowledge Audit] Recent additions:
1. [Qubit] Stored confidence: 82% (Source: wiki_2023)
> Which entry to correct? 1
> New content: Qubits can exist in superposition states...
```

## 🤝 Contribution

We welcome:
- New learning strategies
- Knowledge connectors
- UI enhancements
- Test cases

Please read our [Contribution Guide](CONTRIBUTING.md).

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.