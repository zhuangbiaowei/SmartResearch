# SmartResearch: A Technical Deep Dive

## 1. Introduction

SmartResearch is an AI-powered assistant built on the principle of **Chain of Learning & Thinking (CoLT)**. Unlike traditional AI interaction models, its core is designed around a continuous, self-reinforcing loop: `[Think] → [Search] → [Learn] → [Store] → [Repeat]`.

This document provides a technical overview of the project's architecture, core workflows, and the technologies that power its interactive command-line interface (CLI).

## 2. Core Architecture

The project is architected in a modular way, separating concerns between the user interface, application logic, and AI interaction.

- **Entry Point (`bin/smart_research`)**: A simple Ruby script that loads the main library and starts the command-line interface.

- **Main Library (`lib/smart_research.rb`)**: This file acts as a central hub. It loads all necessary dependencies, including the application components and the core `SmartPrompt` and `SmartAgent` libraries. It defines the `SmartResearch::CLI` class which kicks off the application.

- **Application Orchestrator (`lib/smart_research/application.rb`)**: The `Application` class is the heart of the user-facing side of the project. Its key responsibilities are:
    - **UI Layout**: Assembling the various UI components (`Content`, `Sidebar`, `InputArea`, etc.) into a cohesive layout.
    - **Engine Initialization**: Setting up the `SmartPrompt::Engine` (for LLM communication) and `SmartAgent::Engine` (for managing agent workflows).
    - **Event Handling**: Orchestrating the calls to agents and workers based on user input and updating the UI in response.

- **Agents (`agents/`)**: Agents are high-level controllers or "managers". They are responsible for orchestrating the steps needed to fulfill a user's request. An agent's primary job is to decide *what* to do next, which often involves calling a "worker" to think, executing a tool, and then looping until the task is complete.

- **Workers (`workers/`)**: Workers are the "thinkers" that directly interface with the Large Language Model (LLM). They take the context provided by an Agent, combine it with a system prompt (`sys_msg`) that defines their role and capabilities, and send the final request to the LLM to get a response or a tool-use suggestion.

## 3. The `smart_bot` Workflow: Agent & Worker Collaboration

The `smart_bot` is the primary interaction entity, and its logic is split between an agent and a worker. This separation enables complex, multi-step reasoning.

Here is a step-by-step breakdown of its workflow:

1.  **Request Initiation**: The user enters a query into the CLI. The `Application` class routes this request to the `:smart_bot` agent.

2.  **Agent Enters Loop**: The `smart_bot` agent (`agents/smart_bot.rb`) starts a `while` loop. This loop will continue as long as the LLM needs to use tools.

3.  **Agent Calls Worker**: Inside the loop, the agent calls the `:smart_bot` worker (`workers/smart_bot.rb`), passing it the user's query and granting it access to the available tools.

4.  **Worker Interacts with LLM**: The worker defines the LLM's persona and instructions via a `sys_msg` ("You are a smart assistant that can use tools..."). It sends the user's query to the LLM.

5.  **LLM Decision**: The LLM analyzes the request. It can either:
    a. **Request a Tool**: If the query requires external information (e.g., "search the web"), the LLM returns a structured command to the agent requesting a specific tool call.
    b. **Provide a Final Answer**: If it has enough information, it generates a direct response.

6.  **Agent Executes or Exits**:
    a. **If a tool is requested**: The agent receives the tool-call command (`result.call_tools` is true). It executes the specified tool, captures the output, and **repeats the loop from step 3**, this time including the tool's output as new context for the worker.
    b. **If a final answer is provided**: The agent sees that no tool was requested (`result.call_tools` is false). It breaks the loop.

7.  **Response to User**: The agent returns the final answer to the `Application`, which then displays it in the CLI.

This iterative process allows `smart_bot` to "think" step-by-step, gather information, and formulate a comprehensive answer.

## 4. Interactive CLI with `ruby_rich`

The CLI is not a simple, static text display. It's a dynamic, responsive interface powered by the `ruby_rich` gem.

- **Component-Based Layout**: The UI is constructed from modular components found in `lib/smart_research/components/`. The `Application` class assembles these components (`Root`, `Main`, `Sidebar`, `Content`, `InputArea`) into a nested grid layout using `split_row` and `split_column`.

- **Live Rendering**: The entire interface is managed by `RubyRich::Live.start`. This function takes over the terminal screen and runs a render loop (e.g., 24 times per second). It also handles listening for keyboard input.

- **Declarative Updates**: To update the UI (e.g., display the AI's streaming response), the code does **not** manually manipulate the terminal. Instead, it simply modifies the data bound to a component. For example, it appends text to the `content_panel.content` string. The `RubyRich::Live` engine automatically detects this change and efficiently redraws only the necessary parts of the screen on its next refresh cycle.

This modern, declarative approach makes building and managing a complex TUI (Text-based User Interface) significantly more structured and maintainable.
