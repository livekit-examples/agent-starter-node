import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    ssr: 'src/agent.ts', // marks entry as Node
    target: 'node18',
    sourcemap: true,
    outDir: 'dist',
    rollupOptions: {
      output: {
        entryFileNames: 'agent.js',
      },
    },
  },
});
