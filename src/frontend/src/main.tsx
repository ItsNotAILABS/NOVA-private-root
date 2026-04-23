import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './canister/swarmBrainActor';

// Companion bridge endpoint can be injected at deploy-time for phone access.
if (typeof window !== 'undefined') {
  const globalWindow = window as Window & {
    __AURO_API_BASE__?: string;
    __AURO_BRIDGE_TOKEN__?: string;
  };
  const envBase = import.meta.env.VITE_AURO_API_BASE;
  const envToken = import.meta.env.VITE_AURO_BRIDGE_TOKEN;
  if (envBase && typeof envBase === 'string' && envBase.trim().length > 0) {
    globalWindow.__AURO_API_BASE__ = envBase.trim().replace(/\/+$/, '');
  }
  if (envToken && typeof envToken === 'string' && envToken.trim().length > 0) {
    globalWindow.__AURO_BRIDGE_TOKEN__ = envToken.trim();
  }
}

ReactDOM.createRoot(document.getElementById('root') as HTMLElement).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
