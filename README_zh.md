[English](README.md)

# 🧠 SmartResearch - 学思链（CoLT），助力研究的最佳工具

[![Ruby 版本](https://img.shields.io/badge/Ruby-3.1%2B-red)](https://www.ruby-lang.org)
[![许可证: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**通过迭代学习循环进化的AI智能助手**

## 🌟 核心机制：学思链（CoLT）

与传统思维链（CoT）不同，SmartResearch 实现了增强的**学习思考循环**：

```
[思考] → [搜索] → [学习] → [存储] → [循环]
```

这种自我强化的循环可实现持续知识积累和自适应推理。

## 🚀 主要功能

- **自主学习引擎**
  - 网络/本地知识检索
  - 上下文知识分析
  - 基于SQLite的记忆存储
- **交互式命令行界面**
  - 实时思考过程可视化
  - 双重反馈机制：
    - 结果验证
    - 知识修正
- **可扩展架构**
  - 模块化插件系统
  - 自定义学习策略
  - 多源数据集成

## 📦 安装

### 环境要求
- Ruby 3.1+
- SQLite3

```bash
git clone https://github.com/zhuangbiaowei/SmartResearch.git
cd SmartResearch
bundle install
```

## 🛠️ 使用指南

```bash
./bin/smart_research

# 示例交互
[SmartResearch v0.1] > 今天要解决什么任务？
> 解释量子计算基础

[思考中] 生成初始假设...
[搜索中] 本地知识（找到3条记录） + 网络资源
[学习中] 将2个新概念整合到知识库...

输出：量子计算利用量子比特...
```

## 📚 反馈机制

**结果修正：**
```bash
[反馈] 回答是否正确？(Y/n/d) d
> 关于量子叠加的解释需要改进
```

**知识审计：**
```bash
[知识审计] 最近添加条目：
1. [量子比特] 置信度82%（来源：wiki_2023）
> 选择要修正的条目：1
> 新内容：量子比特可同时处于叠加态...
```

## 🤝 参与贡献

欢迎贡献：
- 新学习策略
- 知识连接器
- 界面优化
- 测试用例

请阅读[贡献指南](CONTRIBUTING.md)。

## 📄 许可证

MIT 许可证 - 详见 [LICENSE](LICENSE)。