<a href="https://livekit.io/">
  <img src="./.github/assets/livekit-mark.png" alt="LiveKit logo" width="100" height="100">
</a>

# LiveKit Agents Starter - Node.js

A complete starter project for building voice AI apps with [LiveKit Agents for Node.js](https://github.com/livekit/agents-js).

The starter project includes:

- A simple voice AI assistant based on the [AI Voice Assistant quickstart](https://docs.livekit.io/agents/v0/quickstarts/voice-agent/)
- Voice AI pipeline based on [OpenAI](https://docs.livekit.io/agents/v0/integrations/openai/overview/#llm), [Cartesia](https://docs.livekit.io/agents/v0/integrations/cartesia/#tts), and [Deepgram](https://docs.livekit.io/agents/v0/integrations/deepgram/#stt)
  - Easily integrate your preferred [LLM](https://docs.livekit.io/agents/v0/integrations/overview/#llm-integrations), [STT](https://docs.livekit.io/agents/v0/integrations/overview/#stt-integrations), and [TTS](https://docs.livekit.io/agents/v0/integrations/overview/#tts-integrations) instead, or swap to a realtime model like the [OpenAI Realtime API](https://docs.livekit.io/agents/v0/integrations/openai/realtime/)
- [LiveKit Turn Detector](https://docs.livekit.io/agents/v0/voice-agent/#turn-detection-model) for contextually-aware speaker detection, with multilingual support
- [LiveKit Cloud enhanced noise cancellation](https://docs.livekit.io/home/cloud/noise-cancellation/)
- Integrated [metrics and logging](https://docs.livekit.io/agents/v0/build/metrics/)

This starter app is compatible with any [custom web/mobile frontend](https://docs.livekit.io/agents/v0/voice-agent/client-apps/) or [SIP-based telephony](https://docs.livekit.io/agents/v0/voice-agent/telephony/).

## Dev Setup

This project uses [pnpm](https://pnpm.io/) as the package manager.

Clone the repository and install dependencies:

```console
cd agent-starter-nodejs
pnpm install
```

Set up the environment by copying `.env.example` to `.env.local` and filling in the required values:

- `LIVEKIT_URL`: Use [LiveKit Cloud](https://cloud.livekit.io/) or [run your own](https://docs.livekit.io/home/self-hosting/)
- `LIVEKIT_API_KEY`
- `LIVEKIT_API_SECRET`
- `OPENAI_API_KEY`: [Get a key](https://platform.openai.com/api-keys) or use your [preferred LLM provider](https://docs.livekit.io/agents/v0/integrations/overview/#llm-integrations)
- `DEEPGRAM_API_KEY`: [Get a key](https://console.deepgram.com/) or use your [preferred STT provider](https://docs.livekit.io/agents/v0/integrations/overview/#stt-integrations)
- `CARTESIA_API_KEY`: [Get a key](https://play.cartesia.ai/keys) or use your [preferred TTS provider](https://docs.livekit.io/agents/v0/integrations/overview/#tts-integrations)

You can load the LiveKit environment automatically using the [LiveKit CLI](https://docs.livekit.io/home/cli/cli-setup):

```bash
lk app env -w .env.local
```

## Run the agent

Before your first run, you must download certain models such as [Silero VAD](https://docs.livekit.io/agents/v0/voice-agent/#voice-activity-detection-vad-/) and the [LiveKit turn detector](https://docs.livekit.io/agents/v0/voice-agent/#turn-detection-model):

```console
pnpm run download-files
```

To run the agent for use with a frontend or telephony, use the `dev` command:

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
| **Telephony**    | [📚 Documentation](https://docs.livekit.io/agents/v0/voice-agent/telephony/)                                        | Add inbound or outbound calling to your agent      |

For advanced customization, see the [complete frontend guide](https://docs.livekit.io/agents/v0/voice-agent/client-apps/).

## Package Manager Conversion

This project includes a tool to convert between different Node.js package managers. The default is pnpm for fast, efficient dependency management, but you can switch to your preferred package manager.

### Supported Package Managers

- **pnpm** (default) - Fast, disk space efficient package manager
- **npm** - Standard Node.js package manager
- **Yarn Classic** - Alternative package manager (v1)
- **Yarn Berry** - Modern Yarn with Plug'n'Play (v3+)
- **Bun** - All-in-one JavaScript runtime and package manager

### Converting to a Different Package Manager

```bash
# Show available options
make help

# Convert to npm
make convert-to-npm

# Convert to Yarn
make convert-to-yarn

# Convert to Yarn Berry
make convert-to-yarn-berry

# Convert to Bun
make convert-to-bun

# Rollback to previous package manager
make rollback
```

**⚠️ Important Notes:**

- Converting will download the official LiveKit Dockerfile templates and reset any custom Dockerfile modifications
- Your original files are backed up to `.backup.{package-manager}/`
- Lock files are NOT generated automatically - follow the instructions after conversion
- Multiple conversions create multiple backups; rollback shows a menu to select which to restore

## Building and Testing with Docker

To test your agent in a production-like environment, build and run the Docker container locally:

```bash
# Build the Docker image
docker build -t my-agent .

# Run the container with environment variables (LiveKit variables are required, others as needed)
docker run --rm \
  -e LIVEKIT_URL=your-url \
  -e LIVEKIT_API_KEY=your-key \
  -e LIVEKIT_API_SECRET=your-secret \
  -e OPENAI_API_KEY=your-key \
  -e DEEPGRAM_API_KEY=your-key \
  -e CARTESIA_API_KEY=your-key \
  my-agent

# Or use an env file
docker run --rm --env-file .env.local my-agent
```

## Using this template repo for your own project

Once you've started your own project based on this repo, you should:

1. **Check in your `pnpm-lock.yaml`**: This file is currently untracked for the template, but you should commit it to your repository for reproducible builds and proper configuration management. (The same applies to `livekit.toml`, if you run your agents in LiveKit Cloud)

2. **Remove the git tracking test**: Delete the "Check files not tracked in git" step from `.github/workflows/tests.yml` since you'll now want this file to be tracked. These are just there for development purposes in the template repo itself.

## Deploying to production

This project is production-ready and includes a working `Dockerfile`. To deploy it to LiveKit Cloud or another environment, see the [deploying to production](https://docs.livekit.io/agents/v0/deployment/) guide.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
