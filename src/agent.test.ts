import { inference, initializeLogger, voice } from '@livekit/agents';
import { afterEach, beforeEach, describe, it } from 'vitest';
import { Assistant } from './agent';

type TestableAgentSession = InstanceType<typeof voice.AgentSession> & {
  run(options: { userInput: string }): voice.testing.RunResult;
};

// Initialize logger for testing
initializeLogger({ pretty: false, level: 'debug' });

describe('agent evaluation', () => {
  let session: TestableAgentSession;
  let llmInstance: inference.LLM;

  beforeEach(async () => {
    llmInstance = new inference.LLM({ model: 'openai/gpt-5.1' });
    session = new voice.AgentSession({ llm: llmInstance }) as TestableAgentSession;
    await session.start({ agent: new Assistant() });
  });

  afterEach(async () => {
    await session?.close();
  });

  it('offers assistance', { timeout: 30000 }, async () => {
    // Run an agent turn following the user's greeting
    const result = await session.run({ userInput: 'Hello' }).wait();

    // Evaluate the agent's response for friendliness
    await result.expect
      .nextEvent()
      .isMessage({ role: 'assistant' })
      .judge(llmInstance, {
        intent: `\
Greets the user in a friendly manner.

Optional context that may or may not be included:
- Offer of assistance with any request the user may have
- Other small talk or chit chat is acceptable, so long as it is friendly and not too intrusive
`,
      });

    // Assert that there are no unexpected further events
    result.expect.noMoreEvents();
  });
});
