import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// ICP environment detection:
// - VITE_IC_HOST=https://icp0.io  → mainnet (asset canister serves the app)
// - VITE_IC_HOST=http://127.0.0.1:8000 → local replica
const isMainnet = process.env.VITE_IC_HOST === 'https://icp0.io';

export default defineConfig({
  plugins: [react()],
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    // Mainnet: assets served from asset canister, so base is relative
    ...(isMainnet && { base: './' }),
  },
  server: {
    proxy: {
      // Proxy /api calls to local dfx replica during dev
      '/api': 'http://127.0.0.1:8000',
    },
  },
  // Ensure environment variables are exposed to the app
  define: {
    'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
  },
  test: {
    globals: true,
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
    include: ['src/**/*.{test,spec}.{js,jsx,ts,tsx}'],
    coverage: {
      reporter: ['text', 'json', 'html'],
      exclude: [
        'node_modules/',
        'src/test/setup.ts',
      ],
    },
  },
});
