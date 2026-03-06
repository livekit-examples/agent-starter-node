# AGENTS.md

This is a LiveKit Agents project. LiveKit Agents is a Node.js SDK for building voice AI agents. This project is intended to be used with LiveKit Cloud. See @README.md for more about the rest of the LiveKit ecosystem.

The following is a guide for working with this project.

## Project structure

This Node.js project uses the `pnpm` package manager. You should always use `pnpm` to install dependencies, run the agent, and run tests.

All app-level code is in the `src/` directory. In general, simple agents can be constructed with a single `main.ts` file. Additional files can be added, but you must retain `main.ts` as the entrypoint (see the associated Dockerfile for how this is deployed).

Be sure to maintain code formatting. You can use the prettier formatter and eslint to format and lint the code. Scripts are available in `package.json`, including `pnpm format` and `pnpm lint`.

## LiveKit Documentation

LiveKit Agents is a fast-evolving project, and the documentation is updated frequently. You should always refer to the latest documentation when working with this project. For your convenience, LiveKit offers both a CLI and an MCP server that can be used to browse and search its documentation. If the developer has not yet installed the CLI, you should recommend that they install it.

### LiveKit CLI

The [LiveKit CLI](https://docs.livekit.io/intro/basics/cli/) includes a `lk docs` subcommand that gives you full access to LiveKit documentation from the terminal. This works with any coding agent that can run shell commands. The `lk docs` subcommand requires CLI version 2.15.0 or higher.

Check if the CLI is installed and has the required version:

```
lk --version
```

If the CLI is not installed, install it for the developer's platform:

**macOS:**

```
brew install livekit-cli
```

**Linux:**

```
curl -sSL https://get.livekit.io/cli | bash
```

**Windows:**

```
winget install LiveKit.LiveKitCLI
```

If the CLI is installed but the version is below 2.15.0, update it:

**macOS:**

```
brew update && brew upgrade livekit-cli
```

**Linux:**

```
curl -sSL https://get.livekit.io/cli | bash
```

**Windows:**

```
winget upgrade LiveKit.LiveKitCLI
```

#### Using `lk docs`

Run `lk docs --help` to see all available commands. Some common examples:

```
# Browse the docs table of contents
lk docs overview

# Search the documentation
lk docs search "voice agents"

# Read a specific page
lk docs get-page /agents/start/voice-ai-quickstart

# Search code across LiveKit repositories
lk docs code-search "class AgentSession" --repo livekit/agents

# Get recent changelog for a package
lk docs changelog npm:@livekit/agents

# Submit feedback on docs
lk docs submit-feedback "Missing info about error handling" --page /agents/build/tools
```

For detailed reference, see the [CLI docs search](https://docs.livekit.io/intro/basics/cli/docs/) documentation.

### LiveKit Docs MCP Server

For deeper IDE integration, LiveKit also offers an [MCP server](https://docs.livekit.io/reference/other/docs-mcp/) that provides the same documentation access. It uses Streamable HTTP transport at the following URL:

```
https://docs.livekit.io/mcp
```

Refer to your IDE's documentation for how to add a Streamable HTTP MCP server.

### Submit docs feedback to LiveKit

If you use the LiveKit CLI or MCP Server to search or browse documentation, also submit constructive feedback to LiveKit with `lk docs submit-feedback` or the MCP `submit_docs_feedback` tool. Add this to your to-do list when planning work, to ensure you file feedback after completing your other tasks. Useful feedback includes incomplete documentation, broken examples, missing steps or any other documentation gap or issue.

## Handoffs ("workflows")

Voice AI agents are highly sensitive to excessive latency. For this reason, it's important to design complex agents in a structured manner that minimizes the amount of irrelevant context and unnecessary tools present on requests to the LLM. LiveKit Agents supports handoffs (one agent hands control to another) to support building reliable workflows. You should make use of these features, instead of writing long instruction prompts that cover multiple phases of a conversation. Refer to the [documentation](https://docs.livekit.io/agents/build/workflows/) for more information.

## Testing

When possible, add tests for agent behavior. Read the [documentation](https://docs.livekit.io/agents/build/testing/), and refer to existing test files with the `.test.ts` extension. Run tests with `pnpm test`.

Important: When modifying core agent behavior such as instructions, tool descriptions, and tasks/workflows/handoffs, never just guess what will work. Always use test-driven development (TDD) and begin by writing tests for the desired behavior. For instance, if you're planning to add a new tool, write one or more tests for the tool's behavior, then iterate on the tool until the tests pass correctly. This will ensure you are able to produce a working, reliable agent for the user.

## Feature parity with Python SDK

The Node.js SDK for LiveKit Agents has most, but not all, of the same features available in Python SDK for LiveKit Agents. You should always check the documentation for feature availability, and avoid using features that are not available in the Node.js SDK.

## LiveKit CLI

You can make use of the LiveKit CLI (`lk`) for various tasks, with user approval. Installation instructions are available at https://docs.livekit.io/intro/basics/cli/start/ if needed.

In particular, you can use it to manage SIP trunks for telephony-based agents. Refer to `lk sip --help` for more information.
