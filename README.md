<a href="https://livekit.io/">
  <img src="./.github/assets/livekit-mark.png" alt="LiveKit logo" width="100" height="100">
</a>

# LiveKit Agents Starter - Node.js

A complete starter project for building voice AI apps with [LiveKit Agents for Node.js](https://github.com/livekit/agents-js) and [LiveKit Cloud](https://cloud.livekit.io/).

The starter project includes:

- A simple voice AI assistant, ready for extension and customization
- A voice AI pipeline built on [LiveKit Inference](https://docs.livekit.io/agents/models/inference)
  with [models](https://docs.livekit.io/agents/models) from OpenAI, Cartesia, and Deepgram. More than 50 other model providers are supported, including [Realtime models](https://docs.livekit.io/agents/models/realtime)
- Eval suite based on the LiveKit Agents [testing & evaluation framework](https://docs.livekit.io/agents/start/testing)
- [LiveKit Turn Detector](https://docs.livekit.io/agents/logic/turns/turn-detector/) for contextually-aware speaker detection, with multilingual support
- [Background voice cancellation](https://docs.livekit.io/transport/media/noise-cancellation/)
- Deep ession insights from LiveKit [Agent Observability](https://docs.livekit.io/deploy/observability/)
- A Dockerfile ready for [production deployment to LiveKit Cloud](https://docs.livekit.io/deploy/agents/)

This starter app is compatible with any [custom web/mobile frontend](https://docs.livekit.io/frontends/) or [telephony](https://docs.livekit.io/telephony/).

## Using coding agents

This project is designed to work with coding agents like [Claude Code](https://claude.com/product/claude-code), [Cursor](https://www.cursor.com/), and [Codex](https://openai.com/codex/).

For your convenience, LiveKit offers both a CLI and an [MCP server](https://docs.livekit.io/reference/developer-tools/docs-mcp/) that can be used to browse and search its documentation. The [LiveKit CLI](https://docs.livekit.io/intro/basics/cli/) (`lk docs`) works with any coding agent that can run shell commands. Install it for your platform:

**macOS:**

```console
brew install livekit-cli
```

**Linux:**

```console
curl -sSL https://get.livekit.io/cli | bash
```

**Windows:**

```console
winget install LiveKit.LiveKitCLI
```

The `lk docs` subcommand requires version 2.15.0 or higher. Check your version with `lk --version` and update if needed. Once installed, your coding agent can search and browse LiveKit documentation directly from the terminal:

```console
lk docs search "voice agents"
lk docs get-page /agents/start/voice-ai-quickstart
```

See the [Coding agent support](https://docs.livekit.io/intro/coding-agents/) guide for more details, including MCP server setup.

The project includes a complete [AGENTS.md](AGENTS.md) file for these assistants. You can modify this file to suit your needs. To learn more about this file, see [https://agents.md](https://agents.md).

## Dev Setup

Create a project from this template with the LiveKit CLI (recommended):

```bash
lk cloud auth
lk agent init my-agent --template agent-starter-node
```

The CLI clones the template and configures your environment. Then follow the rest of this guide from [Run the agent](#run-the-agent).

This project uses [pnpm](https://pnpm.io/) as the package manager.

<details>
<summary>Alternative: Manual setup without the CLI</summary>

Clone the repository and install dependencies:

```console
cd agent-starter-node
pnpm install
```

Sign up for [LiveKit Cloud](https://cloud.livekit.io/) then set up the environment by copying `.env.example` to `.env.local` and filling in the required keys:

- `LIVEKIT_URL`
- `LIVEKIT_API_KEY`
- `LIVEKIT_API_SECRET`

You can load the LiveKit environment automatically using the [LiveKit CLI](https://docs.livekit.io/intro/basics/cli/):

```bash
lk cloud auth
lk app env -w -d .env.local
```

</details>

## Run the agent

Before your first run, you must download certain models such as [Silero VAD](https://docs.livekit.io/agents/logic/turns/vad/) and the [LiveKit turn detector](https://docs.livekit.io/agents/logic/turns/turn-detector/):

```console
pnpm run download-files
```

To run the agent during development, use the `dev` command:

```console
pnpm run dev
```

In production, use the `start` command:

```console
pnpm run start
```

## Frontend & Telephony

Get started quickly with our pre-built frontend starter apps, or add telephony support:

| Platform         | Link                                                                                                                | Description                                        |
| ---------------- | ------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| **Web**          | [`livekit-examples/agent-starter-react`](https://github.com/livekit-examples/agent-starter-react)                   | Web voice AI assistant with React & Next.js        |
| **iOS/macOS**    | [`livekit-examples/agent-starter-swift`](https://github.com/livekit-examples/agent-starter-swift)                   | Native iOS, macOS, and visionOS voice AI assistant |
| **Flutter**      | [`livekit-examples/agent-starter-flutter`](https://github.com/livekit-examples/agent-starter-flutter)               | Cross-platform voice AI assistant app              |
| **React Native** | [`livekit-examples/voice-assistant-react-native`](https://github.com/livekit-examples/voice-assistant-react-native) | Native mobile app with React Native & Expo         |
| **Android**      | [`livekit-examples/agent-starter-android`](https://github.com/livekit-examples/agent-starter-android)               | Native Android app with Kotlin & Jetpack Compose   |
| **Web Embed**    | [`livekit-examples/agent-starter-embed`](https://github.com/livekit-examples/agent-starter-embed)                   | Voice AI widget for any website                    |
| **Telephony**    | [Documentation](https://docs.livekit.io/telephony/)                                                                 | Add inbound or outbound calling to your agent      |

For advanced customization, see the [complete frontend guide](https://docs.livekit.io/frontends/).

## Using this template repo for your own project

Once you've started your own project based on this repo, you should:

1. **Check in your `pnpm-lock.yaml`**: This file is currently untracked for the template, but you should commit it to your repository for reproducible builds and proper configuration management. (The same applies to `livekit.toml`, if you run your agents in LiveKit Cloud)

2. **Remove the git tracking test**: Delete the "Check files not tracked in git" step from `.github/workflows/tests.yml` since you'll now want this file to be tracked. These are just there for development purposes in the template repo itself.

## Deploying to production

This project is production-ready and includes a working `Dockerfile`. To deploy it to LiveKit Cloud or another environment, see the [deploying to production](https://docs.livekit.io/deploy/agents/) guide.

## Self-hosted LiveKit

You can also self-host LiveKit instead of using LiveKit Cloud. See the [self-hosting](https://docs.livekit.io/transport/self-hosting/local/) guide for more information. If you choose to self-host, you'll need to also use [model plugins](https://docs.livekit.io/agents/models/#plugins) instead of LiveKit Inference and will need to remove the [LiveKit Cloud noise cancellation](https://docs.livekit.io/transport/media/noise-cancellation/) plugin.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
