// ═══════════════════════════════════════════════════════════════════════════
// NOVA BUILDER — Full Student AI Studio (Build №43)
// Language: CPL (TypeScript + JSX substrate)
// AI Chat + Voice + Code Generation + On-Chain Deploy
// CaffeineAI Replacement · Non-Profit · Free for Students · Cannot Be Shut Down
// Medina Tech · Alfredo Medina Hernandez · Dallas TX · 2026
//
// WHAT THIS IS:
//   Students describe what they want to build in plain English, typed or spoken.
//   NOVA AI guides them, generates Motoko code, and deploys it live on ICP.
//   Every build burns cycles. Pool funded by NOVA protocol. No account limits ever.
//
// VOICE: Web Speech API — SpeechRecognition (input) + SpeechSynthesis (output)
// ═══════════════════════════════════════════════════════════════════════════

import React, { useCallback, useEffect, useRef, useState } from 'react';
import {
  getNovaBuilderActor,
  buildStatusLabel,
  buildStatusColor,
  type BuildSession,
  type BuildSummary,
  type BuilderStatus,
} from '../canister/novaBuilderActor';

// ── §1  NOVA AI CONVERSATION ENGINE ──────────────────────────────────────────
//
// Sovereign local AI that guides students through building on ICP.
// No external API. Runs in the browser. Powered by NOVA math constants.
//
// Conversation flow:
//   GREETING → EXPLORE → REFINE → CONFIRM → BUILDING → COMPLETE
//
// The engine generates contextual responses based on what the student says.
// When the build intent is clear and confirmed, it triggers the canister submit.

const PHI  = 1.6180339887498948482;

type ConvStage = 'GREETING' | 'EXPLORE' | 'REFINE' | 'CONFIRM' | 'BUILDING' | 'COMPLETE' | 'ERROR';

interface ConvMessage {
  id:        string;
  role:      'NOVA' | 'STUDENT';
  text:      string;
  timestamp: number;
  highlight?: 'gold' | 'green' | 'red' | 'blue';
}

interface ConvState {
  stage:         ConvStage;
  buildIntent:   string;
  refinedIntent: string;
  sessionId:     string;
  turnCount:     number;
}

// ── §1.1  RESPONSE GENERATOR ─────────────────────────────────────────────────
//
// NOVA AI response logic. Each stage has multiple response paths.
// The engine reads what the student typed and routes to the right response.

const GREETING_MESSAGES = [
  "Hey! I'm NOVA — your AI builder. Tell me what you want to build and I'll generate the code and deploy it on ICP. What's on your mind?",
  "What's up! I'm NOVA. Describe anything you want to build — an app, a game, a tracker, a calculator — and I'll make it happen on the Internet Computer. What do you want to create?",
  "I'm NOVA, your sovereign AI builder. No limits, no account fees, just describe your idea and I'll build it. What are we making today?",
];

function novaGreeting(): string {
  return GREETING_MESSAGES[Math.floor(Math.random() * GREETING_MESSAGES.length)];
}

// Keywords that help NOVA understand what the student wants
const BUILD_CATEGORIES: Record<string, string[]> = {
  calculator:  ['calculator', 'calc', 'math', 'arithmetic', 'compute', 'equation', 'solve'],
  game:        ['game', 'quiz', 'puzzle', 'trivia', 'score', 'play', 'win', 'challenge'],
  tracker:     ['track', 'tracker', 'log', 'record', 'count', 'monitor', 'habit', 'goal'],
  social:      ['social', 'post', 'message', 'chat', 'share', 'community', 'forum', 'connect'],
  token:       ['token', 'coin', 'currency', 'wallet', 'money', 'finance', 'payment', 'nft'],
  vote:        ['vote', 'poll', 'election', 'survey', 'opinion', 'decide', 'governance'],
  storage:     ['store', 'storage', 'save', 'file', 'data', 'database', 'record', 'note'],
  dao:         ['dao', 'governance', 'organization', 'community', 'proposal', 'decentralized'],
  portfolio:   ['portfolio', 'resume', 'profile', 'showcase', 'display', 'website', 'page'],
  marketplace: ['marketplace', 'buy', 'sell', 'trade', 'auction', 'listing', 'shop', 'store'],
};

function detectCategory(text: string): string | null {
  const lower = text.toLowerCase();
  for (const [cat, keywords] of Object.entries(BUILD_CATEGORIES)) {
    if (keywords.some(kw => lower.includes(kw))) return cat;
  }
  return null;
}

function categoryDescription(cat: string): string {
  const desc: Record<string, string> = {
    calculator:  'a computation tool that handles user inputs and returns results',
    game:        'an interactive experience with scoring and user engagement',
    tracker:     'a data recording system with history and analytics',
    social:      'a communication platform where users interact and share',
    token:       'a digital asset with transfer and balance logic',
    vote:        'a governance system where users submit and tally votes',
    storage:     'a persistent data store accessible by principals',
    dao:         'a decentralized organization with proposals and voting',
    portfolio:   'a public profile displaying work and achievements',
    marketplace: 'a trading platform for digital goods and services',
  };
  return desc[cat] || 'a sovereign on-chain application';
}

function generateExploreResponse(input: string, state: ConvState): { text: string; nextStage: ConvStage } {
  const cat = detectCategory(input);
  const trimmed = input.trim();

  if (trimmed.length < 8) {
    return {
      text: "Give me a bit more to work with — what specifically should it do? Who uses it? What problem does it solve?",
      nextStage: 'EXPLORE',
    };
  }

  if (cat) {
    const questions: Record<string, string> = {
      calculator: `A ${cat} on ICP — nice. Should it handle just basic operations (add/subtract/multiply/divide), or advanced math too (square roots, exponents, Fibonacci)? Also — should multiple users be able to use it at once, or is it personal?`,
      game:       `Love it — a ${cat} on ICP. What's the theme? Should it keep high scores permanently on-chain? Can multiple players compete, or is it single-player?`,
      tracker:    `A ${cat} that lives on ICP — so data is permanent and can never be deleted. What are you tracking? Habits, workouts, goals, grades? Should others be able to see the data, or keep it private?`,
      social:     `A decentralized ${cat} app — no platform can censor it. Should messages be public or direct? Should it have user profiles? What's the main use case — school group chat, community forum?`,
      token:      `A sovereign token on ICP. Should it have a fixed supply (like Bitcoin) or unlimited minting? Who can transfer? Should there be a treasury for funding projects?`,
      vote:       `A ${cat}ing system on ICP — all votes are verifiable and permanent. Open to anyone or specific addresses? Should proposals expire, or stay open forever?`,
      storage:    `A permanent ${cat} system on ICP. Should it be private (only you access) or public (anyone can read)? What format — plain text, JSON records, files?`,
      dao:        `A decentralized organization on ICP — proposals, voting, treasury. How many founding members? What can governance control — smart contract upgrades, treasury spend?`,
      portfolio:  `A sovereign ${cat} on ICP — no platform can take it down. Should it include a skills section, project gallery, contact form? Want it filterable by subject or category?`,
      marketplace:`A ${cat} on ICP — peer-to-peer with no middleman. What's being traded? Should sellers set fixed prices or auction? How does payment work — cycles, ICP, tokens?`,
    };
    return {
      text: questions[cat] || `Tell me more about this ${cat} — what does it specifically do, who uses it, and what makes it valuable?`,
      nextStage: 'REFINE',
    };
  }

  return {
    text: `Interesting idea. Help me understand: what's the core action users do with it? What data does it store? Should it be public or private? And who's the main audience?`,
    nextStage: 'REFINE',
  };
}

function generateRefineResponse(input: string, state: ConvState): { text: string; nextStage: ConvStage; intent?: string } {
  const combined = (state.buildIntent + ' ' + input).trim();
  const cat = detectCategory(combined) || 'application';
  const catDesc = categoryDescription(cat);

  const intent = `Build a sovereign ICP canister: ${combined}. Type: ${cat}. Architecture: ${catDesc}. Features derived from user specification. On-chain, permanent, no account limits.`;

  const summaries = [
    `Got it. Here's what I'm building:\n\n📋 ${cat.toUpperCase()} CANISTER\n"${combined.slice(0, 120)}..."\n\nThis will be a sovereign Motoko canister deployed on ICP — permanent, on-chain, yours forever. Ready to build it?`,
    `Perfect. Building this:\n\n⊕ "${combined.slice(0, 100)}..."\n\nMotoko canister on ICP. Immutable once deployed. No fees for you — cycles come from the NOVA subsidy pool. Type "build it" to go.`,
    `Understood. I have everything I need:\n\n"${combined.slice(0, 110)}..."\n\nThis becomes a real, deployed ICP canister. If it looks good, say "build it" and I'll start generating the code now.`,
  ];

  return {
    text: summaries[state.turnCount % summaries.length],
    nextStage: 'CONFIRM',
    intent,
  };
}

function generateNovaResponse(input: string, state: ConvState): {
  text: string;
  nextStage: ConvStage;
  buildIntent?: string;
  readyToBuild?: boolean;
} {
  const lower = input.toLowerCase().trim();

  // Build trigger words
  const buildTriggers = ['build it', 'build', 'go', 'do it', 'make it', 'yes', 'deploy', 'create it', 'launch', 'submit', 'start', 'run it', 'let\'s go'];
  const isBuildCmd   = buildTriggers.some(t => lower.includes(t));

  // Help / explain triggers
  const helpTriggers = ['what is', 'explain', 'how does', 'what does', 'help', 'confused', 'what\'s icp', 'what are cycles', 'what is a canister'];
  const isHelp       = helpTriggers.some(t => lower.includes(t));

  if (state.stage === 'GREETING' || state.stage === 'EXPLORE') {
    if (isHelp) {
      return {
        text: novaExplain(lower),
        nextStage: 'EXPLORE',
      };
    }
    const { text, nextStage } = generateExploreResponse(input, state);
    return { text, nextStage, buildIntent: input };
  }

  if (state.stage === 'REFINE') {
    if (isBuildCmd && state.buildIntent.length > 10) {
      return {
        text: `🚀 Submitting to the NOVA organism now. swarm_brain is generating your Motoko code...`,
        nextStage: 'BUILDING',
        readyToBuild: true,
      };
    }
    const { text, nextStage, intent } = generateRefineResponse(input, state);
    return { text, nextStage, buildIntent: intent };
  }

  if (state.stage === 'CONFIRM') {
    if (isBuildCmd) {
      return {
        text: `🚀 Let's go. Sending to swarm_brain → sovereign_factory pipeline now. Watch the build log on the right...`,
        nextStage: 'BUILDING',
        readyToBuild: true,
      };
    }
    // Student wants to change something
    return {
      text: `No problem — what do you want to change? Describe the update and I'll revise the plan.`,
      nextStage: 'REFINE',
    };
  }

  if (state.stage === 'COMPLETE' || state.stage === 'ERROR') {
    return {
      text: `Want to build something else? Tell me your next idea.`,
      nextStage: 'EXPLORE',
      buildIntent: '',
    };
  }

  return {
    text: `Tell me more about what you want to build.`,
    nextStage: state.stage,
  };
}

function novaExplain(query: string): string {
  if (query.includes('canister')) return `A canister is a sovereign smart contract on the Internet Computer (ICP). It's like an app that lives on the blockchain — it has its own storage, runs code, and can't be shut down. When I build for you, I'm creating a real canister.`;
  if (query.includes('cycle')) return `Cycles are the fuel that runs ICP canisters — like gas on Ethereum but much cheaper. Normally you'd pay for them, but NOVA has a subsidy pool funded by the protocol. Your builds are free because of that pool.`;
  if (query.includes('icp') || query.includes('internet computer')) return `ICP (Internet Computer Protocol) is a blockchain network by DFINITY. Unlike Ethereum, it can run full web apps, store data, and serve HTTP directly on-chain. NOVA is built on ICP — that's why your app can't be taken down.`;
  if (query.includes('motoko')) return `Motoko is the programming language I use to write your canisters. It's designed specifically for ICP — safe, fast, and expressive. You don't need to learn it — that's what I'm here for.`;
  if (query.includes('nova')) return `NOVA is the sovereign AI organism that powers this builder. It has 42 on-chain canisters, 345 intelligence modules, and 70 autonomous workers. When you submit a build, swarm_brain generates the code and sovereign_factory deploys it.`;
  return `Good question. ICP lets you build permanent apps that no company controls. NOVA is the AI builder layer — you describe what you want, I build it on-chain. No code knowledge required. What do you want to create?`;
}

// ── §2  VOICE ENGINE ─────────────────────────────────────────────────────────
//
// Web Speech API wrapper — no external service.
// SpeechRecognition  → student speaks → text
// SpeechSynthesis    → NOVA speaks → audio

declare global {
  interface Window {
    SpeechRecognition:       new () => SpeechRecognition;
    webkitSpeechRecognition: new () => SpeechRecognition;
  }
}

function getRecognition(): SpeechRecognition | null {
  const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (!SR) return null;
  const rec = new SR();
  rec.continuous    = false;
  rec.interimResults = false;
  rec.lang           = 'en-US';
  return rec;
}

function novaSpeaks(text: string, rate = 0.92, pitch = 0.95) {
  if (!window.speechSynthesis) return;
  window.speechSynthesis.cancel();
  const utt   = new SpeechSynthesisUtterance(text);
  utt.rate    = rate;
  utt.pitch   = pitch;
  utt.volume  = 0.9;
  // prefer a natural voice
  const voices = window.speechSynthesis.getVoices();
  const preferred = voices.find(v =>
    v.name.includes('Samantha') || v.name.includes('Google US') || v.name.includes('Daniel')
  );
  if (preferred) utt.voice = preferred;
  window.speechSynthesis.speak(utt);
}

// ── §3  STYLE SYSTEM ─────────────────────────────────────────────────────────

const S = {
  root: {
    width: '100%',
    height: '100%',
    background: '#030810',
    color: '#c8d8f0',
    fontFamily: "'SF Mono', 'Fira Code', 'Cascadia Code', monospace",
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
  },
  // Top status bar
  statusBar: {
    display: 'flex',
    alignItems: 'center',
    gap: 12,
    padding: '8px 20px',
    background: '#050d1a',
    borderBottom: '1px solid #0a2040',
    flexShrink: 0,
    flexWrap: 'wrap' as const,
  },
  sbLabel: {
    fontSize: 9,
    color: '#3a6080',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
  },
  sbValue: (color = '#4af') => ({
    fontSize: 11,
    color,
    fontWeight: 700,
    marginLeft: 4,
  }),
  sbDivider: {
    width: 1,
    height: 16,
    background: '#0a2040',
    margin: '0 4px',
  },
  // Tab bar
  tabBar: {
    display: 'flex',
    gap: 2,
    padding: '0 20px',
    background: '#030810',
    borderBottom: '1px solid #0a2040',
    flexShrink: 0,
  },
  tab: (active: boolean) => ({
    padding: '10px 20px',
    fontSize: 10,
    color: active ? '#4af' : '#3a5070',
    borderBottom: `2px solid ${active ? '#4af' : 'transparent'}`,
    cursor: 'pointer',
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    transition: 'all 0.15s',
    userSelect: 'none' as const,
  }),
  // Main content area
  content: {
    flex: 1,
    display: 'flex',
    overflow: 'hidden',
    minHeight: 0,
  },
  // Chat panel (left)
  chatPanel: {
    flex: '1 1 0',
    display: 'flex',
    flexDirection: 'column' as const,
    minWidth: 0,
    borderRight: '1px solid #0a2040',
  },
  chatHeader: {
    padding: '12px 20px',
    borderBottom: '1px solid #0a2040',
    display: 'flex',
    alignItems: 'center',
    gap: 10,
    flexShrink: 0,
    background: '#040c18',
  },
  novaAvatar: {
    width: 32,
    height: 32,
    borderRadius: '50%',
    background: 'linear-gradient(135deg, #0a3060, #1060a0)',
    border: '2px solid #4af',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 14,
    color: '#4af',
    flexShrink: 0,
  },
  novaName: {
    fontSize: 12,
    color: '#4af',
    fontWeight: 700,
    letterSpacing: '0.1em',
  },
  novaSubtitle: {
    fontSize: 9,
    color: '#3a6080',
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
  },
  stageBadge: (stage: ConvStage) => {
    const colors: Record<ConvStage, string> = {
      GREETING: '#3a6080', EXPLORE: '#4af', REFINE: '#fa0',
      CONFIRM: '#a78bfa', BUILDING: '#4f4', COMPLETE: '#4f4', ERROR: '#f44',
    };
    return {
      marginLeft: 'auto',
      fontSize: 8,
      padding: '2px 8px',
      background: `${colors[stage]}18`,
      border: `1px solid ${colors[stage]}60`,
      borderRadius: 3,
      color: colors[stage],
      letterSpacing: '0.15em',
    };
  },
  // Messages
  messages: {
    flex: 1,
    overflowY: 'auto' as const,
    padding: '16px 20px',
    display: 'flex',
    flexDirection: 'column' as const,
    gap: 14,
    minHeight: 0,
  },
  msgRow: (role: 'NOVA' | 'STUDENT') => ({
    display: 'flex',
    justifyContent: role === 'STUDENT' ? 'flex-end' : 'flex-start',
  }),
  msgBubble: (role: 'NOVA' | 'STUDENT', highlight?: string) => {
    const bg    = role === 'NOVA'    ? '#050e1c'  : '#082040';
    const bdr   = role === 'NOVA'    ? '#0a2040'  : '#1050a0';
    const rad   = role === 'NOVA'
      ? '4px 16px 16px 16px'
      : '16px 4px 16px 16px';
    const hlMap: Record<string, string> = { gold: '#c8a84e40', green: '#34d39920', red: '#f4444420', blue: '#4af20' };
    return {
      maxWidth: '82%',
      padding: '10px 14px',
      background: highlight ? hlMap[highlight] || bg : bg,
      border: `1px solid ${bdr}`,
      borderRadius: rad,
      fontSize: 12,
      lineHeight: 1.7,
      color: '#c8d8f0',
      whiteSpace: 'pre-wrap' as const,
    };
  },
  msgTime: {
    fontSize: 8,
    color: '#2a4060',
    marginTop: 3,
    textAlign: 'right' as const,
  },
  typingIndicator: {
    display: 'flex',
    gap: 4,
    alignItems: 'center',
    padding: '8px 14px',
    background: '#050e1c',
    border: '1px solid #0a2040',
    borderRadius: '4px 16px 16px 16px',
    width: 'fit-content',
  },
  dot: (delay: number) => ({
    width: 6,
    height: 6,
    borderRadius: '50%',
    background: '#4af',
    animationName: 'novaDotPulse',
    animationDuration: '1.2s',
    animationDelay: `${delay}s`,
    animationIterationCount: 'infinite',
    animationTimingFunction: 'ease-in-out',
  }),
  // Input row
  inputRow: {
    padding: '12px 20px',
    borderTop: '1px solid #0a2040',
    display: 'flex',
    gap: 8,
    alignItems: 'flex-end',
    background: '#040c18',
    flexShrink: 0,
  },
  textarea: {
    flex: 1,
    background: '#050d1a',
    border: '1px solid #0a2040',
    borderRadius: 8,
    padding: '10px 14px',
    color: '#c8d8f0',
    fontFamily: 'inherit',
    fontSize: 12,
    lineHeight: 1.5,
    resize: 'none' as const,
    outline: 'none',
    minHeight: 44,
    maxHeight: 120,
    overflowY: 'auto' as const,
  },
  iconBtn: (color = '#4af', active = false) => ({
    width: 40,
    height: 40,
    borderRadius: 8,
    background: active ? `${color}30` : '#050d1a',
    border: `1px solid ${active ? color : '#0a2040'}`,
    color: active ? color : '#3a6080',
    cursor: 'pointer',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontSize: 16,
    flexShrink: 0,
    transition: 'all 0.15s',
  }),
  sendBtn: (disabled: boolean) => ({
    height: 40,
    padding: '0 16px',
    background: disabled ? '#050d1a' : '#0a3060',
    border: `1px solid ${disabled ? '#0a2040' : '#4af'}`,
    borderRadius: 8,
    color: disabled ? '#3a5070' : '#4af',
    cursor: disabled ? 'not-allowed' : 'pointer',
    fontFamily: 'inherit',
    fontSize: 10,
    letterSpacing: '0.12em',
    textTransform: 'uppercase' as const,
    flexShrink: 0,
    transition: 'all 0.15s',
  }),
  // Studio panel (right)
  studioPanel: {
    width: 380,
    display: 'flex',
    flexDirection: 'column' as const,
    flexShrink: 0,
  },
  studioPanelHeader: {
    padding: '12px 16px',
    borderBottom: '1px solid #0a2040',
    fontSize: 9,
    color: '#3a6080',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    background: '#040c18',
    flexShrink: 0,
  },
  studioBody: {
    flex: 1,
    overflowY: 'auto' as const,
    padding: 14,
    display: 'flex',
    flexDirection: 'column' as const,
    gap: 12,
    minHeight: 0,
  },
  card: {
    background: '#050d1a',
    border: '1px solid #0a2040',
    borderRadius: 6,
    overflow: 'hidden',
  },
  cardHeader: {
    padding: '8px 12px',
    borderBottom: '1px solid #0a2040',
    fontSize: 8,
    color: '#3a6080',
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    display: 'flex',
    alignItems: 'center',
    gap: 6,
  },
  cardBody: {
    padding: '10px 12px',
  },
  buildStatusDot: (color: string) => ({
    width: 6,
    height: 6,
    borderRadius: '50%',
    background: color,
    flexShrink: 0,
    boxShadow: `0 0 4px ${color}`,
  }),
  codeBlock: {
    background: '#020810',
    padding: '10px 12px',
    fontSize: 9,
    color: '#6080a0',
    fontFamily: 'inherit',
    lineHeight: 1.6,
    overflowX: 'auto' as const,
    borderRadius: 4,
    maxHeight: 220,
    overflowY: 'auto' as const,
    whiteSpace: 'pre' as const,
  },
  cyclesBar: (pct: number) => ({
    height: 4,
    borderRadius: 2,
    background: '#0a2040',
    position: 'relative' as const,
    overflow: 'hidden',
    marginTop: 4,
  }),
  cyclesFill: (pct: number) => ({
    height: '100%',
    width: `${Math.min(100, pct)}%`,
    background: pct > 50 ? '#4af' : pct > 20 ? '#fa0' : '#f44',
    borderRadius: 2,
    transition: 'width 0.3s',
  }),
  metricRow: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: '4px 0',
    borderBottom: '1px solid #0a2040',
    fontSize: 10,
  },
  metricLabel: { color: '#3a6080', fontSize: 9, letterSpacing: '0.1em', textTransform: 'uppercase' as const },
  metricValue: (color = '#c8d8f0') => ({ color, fontWeight: 700, fontSize: 11 }),
  historyItem: {
    padding: '8px 12px',
    borderBottom: '1px solid #0a1828',
    fontSize: 10,
    cursor: 'pointer',
    transition: 'background 0.1s',
  },
  buildIntentBadge: {
    display: 'inline-block',
    padding: '2px 8px',
    background: '#0a2040',
    border: '1px solid #4af40',
    borderRadius: 3,
    fontSize: 9,
    color: '#4af',
    letterSpacing: '0.1em',
    maxWidth: '100%',
    overflow: 'hidden',
    textOverflow: 'ellipsis',
    whiteSpace: 'nowrap' as const,
  },
  voiceWave: (active: boolean) => ({
    display: 'flex',
    gap: 2,
    alignItems: 'center',
    height: 20,
    opacity: active ? 1 : 0.3,
  }),
  voiceBar: (i: number, active: boolean) => ({
    width: 3,
    borderRadius: 2,
    background: '#4af',
    height: active ? `${8 + Math.sin(i * PHI) * 6}px` : '4px',
    animationName: active ? 'novaVoiceBar' : undefined,
    animationDuration: `${0.4 + i * 0.08}s`,
    animationIterationCount: 'infinite',
    animationDirection: 'alternate',
    animationTimingFunction: 'ease-in-out',
    transition: 'height 0.2s',
  }),
  // Studio full view (non-chat tab)
  studioFull: {
    flex: 1,
    display: 'flex',
    flexDirection: 'column' as const,
    overflow: 'hidden',
    minHeight: 0,
  },
  studioGrid: {
    flex: 1,
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: 16,
    padding: 20,
    overflow: 'auto' as const,
  },
  intentBox: {
    background: '#050d1a',
    border: '1px solid #0a2040',
    borderRadius: 6,
    padding: '8px 12px',
    fontSize: 11,
    color: '#c8d8f0',
    fontFamily: 'inherit',
    resize: 'vertical' as const,
    outline: 'none',
    minHeight: 80,
    lineHeight: 1.6,
  },
  submitBtn: (disabled: boolean) => ({
    padding: '10px 24px',
    background: disabled ? '#050d1a' : '#0a3060',
    border: `1px solid ${disabled ? '#0a2040' : '#4af'}`,
    borderRadius: 6,
    color: disabled ? '#3a5070' : '#4af',
    cursor: disabled ? 'not-allowed' : 'pointer',
    fontFamily: 'inherit',
    fontSize: 10,
    letterSpacing: '0.15em',
    textTransform: 'uppercase' as const,
    marginTop: 8,
    width: '100%',
    transition: 'all 0.15s',
  }),
};

// Inject keyframes once
const injectKeyframes = () => {
  const style = document.createElement('style');
  style.textContent = `
    @keyframes novaDotPulse {
      0%, 80%, 100% { transform: scale(0.6); opacity: 0.4; }
      40% { transform: scale(1.2); opacity: 1; }
    }
    @keyframes novaVoiceBar {
      from { transform: scaleY(0.5); }
      to   { transform: scaleY(1.5); }
    }
    @keyframes novaFadeIn {
      from { opacity: 0; transform: translateY(4px); }
      to   { opacity: 1; transform: translateY(0); }
    }
    .nova-msg { animation: novaFadeIn 0.2s ease; }
    .nova-history-item:hover { background: #0a1828 !important; }
  `;
  document.head.appendChild(style);
};

// ── §4  MAIN COMPONENT ───────────────────────────────────────────────────────

type TabMode = 'CHAT' | 'STUDIO' | 'HISTORY' | 'CYCLES';

export function NovaBuilderDashboard() {

  // ── State
  const [tab,           setTab]           = useState<TabMode>('CHAT');
  const [messages,      setMessages]      = useState<ConvMessage[]>([]);
  const [convState,     setConvState]     = useState<ConvState>({
    stage: 'GREETING', buildIntent: '', refinedIntent: '', sessionId: '', turnCount: 0,
  });
  const [typing,        setTyping]        = useState(false);
  const [input,         setInput]         = useState('');
  const [listening,     setListening]     = useState(false);
  const [voiceSupport,  setVoiceSupport]  = useState(false);
  const [speaking,      setSpeaking]      = useState(false);
  const [builderStatus, setBuilderStatus] = useState<BuilderStatus | null>(null);
  const [currentSession,setCurrentSession]= useState<BuildSession | null>(null);
  const [recentBuilds,  setRecentBuilds]  = useState<BuildSummary[]>([]);
  const [studioIntent,  setStudioIntent]  = useState('');
  const [submitting,    setSubmitting]    = useState(false);
  const [statusErr,     setStatusErr]     = useState('');
  const [voiceEnabled,  setVoiceEnabled]  = useState(true);

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const recognitionRef = useRef<SpeechRecognition | null>(null);
  const pollRef        = useRef<ReturnType<typeof setInterval> | null>(null);

  // ── Init
  useEffect(() => {
    injectKeyframes();
    setVoiceSupport(!!getRecognition());
    // Post greeting
    setTimeout(() => {
      addNovaMessage(novaGreeting(), 'GREETING');
      if (voiceEnabled) novaSpeaks(novaGreeting());
    }, 400);
    loadStatus();
    const intervalId = setInterval(loadStatus, 12000);
    return () => { clearInterval(intervalId); if (pollRef.current) clearInterval(pollRef.current); };
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages, typing]);

  // ── Load canister status
  const loadStatus = async () => {
    try {
      const actor  = getNovaBuilderActor();
      const status = await actor.getBuilderStatus();
      setBuilderStatus(status);
      const recent = await actor.getRecentBuilds(8n);
      setRecentBuilds(recent);
    } catch (_) {
      // canister not configured yet — local dev
    }
  };

  // ── Message helpers
  const addNovaMessage = useCallback((text: string, stage?: ConvStage, highlight?: ConvMessage['highlight']) => {
    const msg: ConvMessage = {
      id: Date.now().toString() + Math.random(),
      role: 'NOVA',
      text,
      timestamp: Date.now(),
      highlight,
    };
    setMessages(prev => [...prev, msg]);
    if (stage) {
      setConvState(prev => ({ ...prev, stage: stage || prev.stage }));
    }
  }, []);

  const addStudentMessage = useCallback((text: string) => {
    const msg: ConvMessage = {
      id: Date.now().toString() + Math.random(),
      role: 'STUDENT',
      text,
      timestamp: Date.now(),
    };
    setMessages(prev => [...prev, msg]);
  }, []);

  // ── Send message
  const sendMessage = useCallback(async (text: string) => {
    if (!text.trim()) return;
    setInput('');
    addStudentMessage(text);
    setTyping(true);

    // Simulate NOVA thinking (φ-weighted delay)
    await new Promise(r => setTimeout(r, 600 + Math.random() * 400));
    setTyping(false);

    const result = generateNovaResponse(text, convState);

    if (result.buildIntent !== undefined) {
      setConvState(prev => ({ ...prev, buildIntent: result.buildIntent || prev.buildIntent }));
    }

    // Update conversation state
    setConvState(prev => ({
      ...prev,
      stage:       result.nextStage,
      buildIntent: result.buildIntent !== undefined ? result.buildIntent : prev.buildIntent,
      turnCount:   prev.turnCount + 1,
    }));

    addNovaMessage(result.text, result.nextStage);
    if (voiceEnabled) novaSpeaks(result.text);

    // Auto-submit build if AI says ready
    if (result.readyToBuild) {
      const finalIntent = convState.buildIntent || text;
      await submitBuildFromChat(finalIntent);
    }

  }, [convState, addNovaMessage, addStudentMessage, voiceEnabled]);

  // ── Submit build (from chat)
  const submitBuildFromChat = useCallback(async (intent: string) => {
    setConvState(prev => ({ ...prev, stage: 'BUILDING' }));
    try {
      const actor     = getNovaBuilderActor();
      const sessionId = await actor.submitBuild(intent);
      setConvState(prev => ({ ...prev, sessionId }));
      setCurrentSession(null);

      await new Promise(r => setTimeout(r, 800));
      addNovaMessage(
        `✅ Build queued — Session: ${sessionId}\n\nThe NOVA organism is processing. swarm_brain generates the code, sovereign_factory deploys it. Check the right panel for live status.`,
        'BUILDING',
        'green',
      );

      // Poll for completion
      if (pollRef.current) clearInterval(pollRef.current);
      pollRef.current = setInterval(async () => {
        try {
          const sess = await actor.getBuildSession(sessionId);
          setCurrentSession(sess);
          const label = buildStatusLabel(sess.status);
          if (label === 'DEPLOYED') {
            clearInterval(pollRef.current!);
            setConvState(prev => ({ ...prev, stage: 'COMPLETE' }));
            addNovaMessage(
              `🚀 DEPLOYED!\n\nYour canister is live on ICP.\nAddress: ${sess.deployAddress}\nCycles burned: ${sess.cyclesConsumed.toLocaleString()}\n\nThat's your permanent, sovereign app. Nobody can take it down. Want to build something else?`,
              'COMPLETE',
              'gold',
            );
            if (voiceEnabled) novaSpeaks(`Your canister is live! Address ${sess.deployAddress}. What do you want to build next?`);
            loadStatus();
          } else if (label === 'FAILED') {
            clearInterval(pollRef.current!);
            setConvState(prev => ({ ...prev, stage: 'ERROR' }));
            addNovaMessage(
              `Build encountered an issue: ${sess.errorMsg || 'Unknown error'}\n\nThis can happen when the swarm_brain needs to be configured for this environment. Want to try again or modify the intent?`,
              'ERROR',
              'red',
            );
            if (voiceEnabled) novaSpeaks('The build ran into an issue. Want to try again?');
          }
        } catch (_) {}
      }, 2500);

    } catch (e) {
      const err = e instanceof Error ? e.message : String(e);
      setConvState(prev => ({ ...prev, stage: 'ERROR' }));
      addNovaMessage(
        `Canister connection issue: ${err}\n\nNOVA BUILDER requires the nova_builder canister to be configured. In local dev, set VITE_NOVA_BUILDER_CANISTER_ID. Your build intent is saved — try again when ready.`,
        'ERROR',
        'red',
      );
    }
  }, [addNovaMessage, voiceEnabled]);

  // ── Studio direct submit
  const studioSubmit = useCallback(async () => {
    if (!studioIntent.trim() || submitting) return;
    setSubmitting(true);
    setStatusErr('');
    try {
      const actor     = getNovaBuilderActor();
      const sessionId = await actor.submitBuild(studioIntent.trim());
      setCurrentSession(null);
      if (pollRef.current) clearInterval(pollRef.current);
      pollRef.current = setInterval(async () => {
        try {
          const sess = await actor.getBuildSession(sessionId);
          setCurrentSession(sess);
          const label = buildStatusLabel(sess.status);
          if (label === 'DEPLOYED' || label === 'FAILED') {
            clearInterval(pollRef.current!);
            loadStatus();
          }
        } catch (_) {}
      }, 2500);
    } catch (e) {
      setStatusErr(e instanceof Error ? e.message : String(e));
    } finally {
      setSubmitting(false);
    }
  }, [studioIntent, submitting]);

  // ── Voice input
  const toggleListening = useCallback(() => {
    if (!voiceSupport) return;
    if (listening) {
      recognitionRef.current?.stop();
      setListening(false);
      return;
    }
    const rec = getRecognition();
    if (!rec) return;
    recognitionRef.current = rec;
    rec.onresult = (e) => {
      const transcript = Array.from(e.results)
        .map(r => r[0].transcript)
        .join(' ');
      setInput(transcript);
      setListening(false);
    };
    rec.onerror = () => setListening(false);
    rec.onend   = () => setListening(false);
    rec.start();
    setListening(true);
  }, [voiceSupport, listening]);

  const handleKeyDown = (e: React.KeyboardEvent<HTMLTextAreaElement>) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      sendMessage(input);
    }
  };

  // ── §5  RENDER ────────────────────────────────────────────────────────────

  const poolPct = builderStatus
    ? Number(builderStatus.subsidyPoolBalance * 100n / (builderStatus.subsidyThreshold || 1n))
    : 0;

  const sessionStatus = currentSession ? buildStatusLabel(currentSession.status) : null;

  const formatCycles = (n: bigint) => {
    if (n >= 1_000_000_000n) return `${(Number(n) / 1e9).toFixed(2)}B`;
    if (n >= 1_000_000n)     return `${(Number(n) / 1e6).toFixed(2)}M`;
    if (n >= 1_000n)         return `${(Number(n) / 1e3).toFixed(2)}K`;
    return String(n);
  };

  const renderStatusBar = () => (
    <div style={S.statusBar}>
      <div>
        <span style={S.sbLabel}>NOVA Builder</span>
        <span style={S.sbValue('#4f4')}>LIVE</span>
      </div>
      <div style={S.sbDivider} />
      <div>
        <span style={S.sbLabel}>Total Builds</span>
        <span style={S.sbValue()}>
          {builderStatus ? String(builderStatus.totalBuilds) : '—'}
        </span>
      </div>
      <div style={S.sbDivider} />
      <div>
        <span style={S.sbLabel}>Cycles Burned</span>
        <span style={S.sbValue('#fa0')}>
          {builderStatus ? formatCycles(builderStatus.totalCyclesBurned) : '—'}
        </span>
      </div>
      <div style={S.sbDivider} />
      <div>
        <span style={S.sbLabel}>Pool</span>
        <span style={S.sbValue(poolPct > 50 ? '#4f4' : poolPct > 20 ? '#fa0' : '#f44')}>
          {builderStatus ? `${poolPct}%` : '—'}
        </span>
      </div>
      <div style={S.sbDivider} />
      <div>
        <span style={S.sbLabel}>Queue</span>
        <span style={S.sbValue()}>
          {builderStatus ? String(builderStatus.queueDepth) : '—'}
        </span>
      </div>
      {/* Voice toggle */}
      {voiceSupport && (
        <>
          <div style={{ marginLeft: 'auto' }} />
          <button
            onClick={() => setVoiceEnabled(!voiceEnabled)}
            style={{
              ...S.iconBtn('#4af', voiceEnabled),
              width: 'auto',
              padding: '0 10px',
              fontSize: 9,
              letterSpacing: '0.1em',
            }}
          >
            {voiceEnabled ? '🔊 VOICE ON' : '🔇 VOICE OFF'}
          </button>
        </>
      )}
    </div>
  );

  // ── Chat tab
  const renderChat = () => (
    <div style={S.content}>
      {/* Left: conversation */}
      <div style={S.chatPanel}>
        <div style={S.chatHeader}>
          <div style={S.novaAvatar}>N</div>
          <div>
            <div style={S.novaName}>NOVA AI</div>
            <div style={S.novaSubtitle}>Sovereign Builder · Free for Students</div>
          </div>
          <div style={S.stageBadge(convState.stage)}>{convState.stage}</div>
        </div>

        <div style={S.messages}>
          {messages.map(msg => (
            <div key={msg.id} className="nova-msg" style={S.msgRow(msg.role)}>
              <div>
                <div style={S.msgBubble(msg.role, msg.highlight)}>
                  {msg.text}
                </div>
                <div style={S.msgTime}>
                  {new Date(msg.timestamp).toLocaleTimeString()}
                </div>
              </div>
            </div>
          ))}

          {typing && (
            <div style={S.msgRow('NOVA')}>
              <div style={S.typingIndicator}>
                <div style={S.dot(0)} />
                <div style={S.dot(0.2)} />
                <div style={S.dot(0.4)} />
              </div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        <div style={S.inputRow}>
          {/* Voice bars */}
          {voiceSupport && (
            <div style={S.voiceWave(listening)}>
              {[0,1,2,3,4].map(i => (
                <div key={i} style={S.voiceBar(i, listening)} />
              ))}
            </div>
          )}

          <textarea
            style={S.textarea}
            placeholder={listening ? '🎤 Listening...' : 'Describe what you want to build... (Enter to send)'}
            value={input}
            onChange={e => setInput(e.target.value)}
            onKeyDown={handleKeyDown}
            rows={1}
            disabled={convState.stage === 'BUILDING'}
          />

          {voiceSupport && (
            <button
              style={S.iconBtn('#f84', listening)}
              onClick={toggleListening}
              title="Voice input"
            >
              🎤
            </button>
          )}

          <button
            style={S.sendBtn(!input.trim() || convState.stage === 'BUILDING')}
            onClick={() => sendMessage(input)}
            disabled={!input.trim() || convState.stage === 'BUILDING'}
          >
            Send →
          </button>
        </div>
      </div>

      {/* Right: live build studio */}
      <div style={S.studioPanel}>
        <div style={S.studioPanelHeader}>⊕ Build Studio</div>
        <div style={S.studioBody}>

          {/* Session status */}
          {currentSession && (
            <div style={S.card}>
              <div style={S.cardHeader}>
                <div style={S.buildStatusDot(buildStatusColor(currentSession.status))} />
                Session · {currentSession.sessionId.slice(0, 16)}…
              </div>
              <div style={S.cardBody}>
                <div style={S.metricRow}>
                  <span style={S.metricLabel}>Status</span>
                  <span style={S.metricValue(buildStatusColor(currentSession.status))}>
                    {buildStatusLabel(currentSession.status)}
                  </span>
                </div>
                <div style={S.metricRow}>
                  <span style={S.metricLabel}>Cycles</span>
                  <span style={S.metricValue('#fa0')}>
                    {formatCycles(currentSession.cyclesConsumed)}
                  </span>
                </div>
                {currentSession.deployAddress && (
                  <div style={{ marginTop: 6 }}>
                    <div style={{ ...S.metricLabel, marginBottom: 4 }}>Canister Address</div>
                    <div style={{
                      fontSize: 9, color: '#4af', wordBreak: 'break-all',
                      background: '#020810', padding: '6px 8px', borderRadius: 4,
                    }}>
                      {currentSession.deployAddress}
                    </div>
                  </div>
                )}
                {currentSession.errorMsg && (
                  <div style={{ marginTop: 6, fontSize: 9, color: '#f44' }}>
                    {currentSession.errorMsg}
                  </div>
                )}
              </div>
            </div>
          )}

          {/* Generated code preview */}
          {currentSession?.generatedCode && (
            <div style={S.card}>
              <div style={S.cardHeader}>Generated Motoko Code</div>
              <div style={S.codeBlock}>
                {currentSession.generatedCode.slice(0, 2000)}
                {currentSession.generatedCode.length > 2000 && '\n… (truncated)'}
              </div>
            </div>
          )}

          {/* Pool status */}
          {builderStatus && (
            <div style={S.card}>
              <div style={S.cardHeader}>Subsidy Pool</div>
              <div style={S.cardBody}>
                <div style={S.metricRow}>
                  <span style={S.metricLabel}>Balance</span>
                  <span style={S.metricValue(poolPct > 50 ? '#4f4' : '#fa0')}>
                    {formatCycles(builderStatus.subsidyPoolBalance)}
                  </span>
                </div>
                <div style={S.cyclesBar(poolPct)}>
                  <div style={S.cyclesFill(poolPct)} />
                </div>
                <div style={{ marginTop: 6 }}>
                  <div style={S.metricRow}>
                    <span style={S.metricLabel}>Open to Builders</span>
                    <span style={S.metricValue(builderStatus.openToBuilders ? '#4f4' : '#f44')}>
                      {builderStatus.openToBuilders ? 'YES' : 'NO'}
                    </span>
                  </div>
                  <div style={S.metricRow}>
                    <span style={S.metricLabel}>Total Deployed</span>
                    <span style={S.metricValue()}>{String(builderStatus.totalDeployed)}</span>
                  </div>
                  <div style={{ ...S.metricRow, border: 'none' }}>
                    <span style={S.metricLabel}>Total Burned</span>
                    <span style={S.metricValue('#fa0')}>
                      {formatCycles(builderStatus.totalCyclesBurned)}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Idle state */}
          {!currentSession && !builderStatus && (
            <div style={{ padding: 16, textAlign: 'center', color: '#3a5070', fontSize: 10 }}>
              <div style={{ fontSize: 28, marginBottom: 8 }}>⊕</div>
              <div>Describe your idea in the chat.</div>
              <div style={{ marginTop: 4 }}>NOVA AI will guide you to your first deploy.</div>
            </div>
          )}
        </div>
      </div>
    </div>
  );

  // ── Studio tab (raw developer mode)
  const renderStudio = () => (
    <div style={S.studioFull}>
      <div style={S.studioGrid}>
        {/* Left col: intent + submit */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          <div style={S.card}>
            <div style={S.cardHeader}>Build Intent — Plain English</div>
            <div style={S.cardBody}>
              <textarea
                style={S.intentBox}
                placeholder="Describe what you want to build. Be specific: what it does, who uses it, what data it stores, any special features..."
                value={studioIntent}
                onChange={e => setStudioIntent(e.target.value)}
                rows={5}
              />
              <button
                style={S.submitBtn(!studioIntent.trim() || submitting)}
                onClick={studioSubmit}
                disabled={!studioIntent.trim() || submitting}
              >
                {submitting ? '⟳ SUBMITTING...' : '⊕ SUBMIT BUILD'}
              </button>
              {statusErr && (
                <div style={{ color: '#f44', fontSize: 10, marginTop: 8 }}>{statusErr}</div>
              )}
            </div>
          </div>

          {/* Pipeline visualization */}
          <div style={S.card}>
            <div style={S.cardHeader}>Build Pipeline</div>
            <div style={S.cardBody}>
              {(['QUEUED','GENERATING','GENERATED','DEPLOYING','DEPLOYED'] as const).map((s, i) => {
                const active = sessionStatus === s;
                const done   = currentSession && ['DEPLOYED'].includes(sessionStatus || '') &&
                               ['QUEUED','GENERATING','GENERATED','DEPLOYING'].includes(s);
                return (
                  <div key={s} style={{ display: 'flex', alignItems: 'center', gap: 8, padding: '4px 0' }}>
                    <div style={{
                      width: 8, height: 8, borderRadius: '50%',
                      background: active ? '#4af' : done ? '#4f4' : '#1a3050',
                      boxShadow: active ? '0 0 6px #4af' : undefined,
                    }} />
                    <div style={{ fontSize: 10, color: active ? '#4af' : done ? '#4f4' : '#3a5070', flex: 1 }}>
                      {s}
                    </div>
                    {i < 4 && (
                      <div style={{ width: 1, height: 12, background: '#0a2040', marginLeft: 3 }} />
                    )}
                  </div>
                );
              })}
              {sessionStatus === 'FAILED' && (
                <div style={{ fontSize: 10, color: '#f44', marginTop: 4 }}>
                  ✗ FAILED — {currentSession?.errorMsg || 'Unknown error'}
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Right col: session + code */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          {currentSession ? (
            <>
              <div style={S.card}>
                <div style={S.cardHeader}>
                  <div style={S.buildStatusDot(buildStatusColor(currentSession.status))} />
                  Session Status
                </div>
                <div style={S.cardBody}>
                  <div style={S.metricRow}>
                    <span style={S.metricLabel}>ID</span>
                    <span style={{ fontSize: 9, color: '#6080a0', fontFamily: 'inherit' }}>
                      {currentSession.sessionId}
                    </span>
                  </div>
                  <div style={S.metricRow}>
                    <span style={S.metricLabel}>Status</span>
                    <span style={S.metricValue(buildStatusColor(currentSession.status))}>
                      {buildStatusLabel(currentSession.status)}
                    </span>
                  </div>
                  <div style={S.metricRow}>
                    <span style={S.metricLabel}>Cycles Burned</span>
                    <span style={S.metricValue('#fa0')}>
                      {formatCycles(currentSession.cyclesConsumed)}
                    </span>
                  </div>
                  {currentSession.deployAddress && (
                    <div style={{ marginTop: 6 }}>
                      <div style={{ ...S.metricLabel, marginBottom: 4 }}>Deployed Canister</div>
                      <div style={{
                        fontSize: 9, color: '#4f4', wordBreak: 'break-all',
                        background: '#020810', padding: '6px 8px', borderRadius: 4,
                      }}>
                        {currentSession.deployAddress}
                      </div>
                    </div>
                  )}
                </div>
              </div>

              {currentSession.generatedCode && (
                <div style={{ ...S.card, flex: 1, display: 'flex', flexDirection: 'column' }}>
                  <div style={S.cardHeader}>Generated Motoko Code</div>
                  <div style={{ ...S.codeBlock, flex: 1, maxHeight: 'none' }}>
                    {currentSession.generatedCode}
                  </div>
                </div>
              )}
            </>
          ) : (
            <div style={{ ...S.card, padding: 24, textAlign: 'center', color: '#3a5070', fontSize: 10 }}>
              <div style={{ fontSize: 32, marginBottom: 8 }}>⊕</div>
              <div>No active build session.</div>
              <div style={{ marginTop: 4 }}>Submit an intent on the left to start.</div>
            </div>
          )}
        </div>
      </div>
    </div>
  );

  // ── History tab
  const renderHistory = () => (
    <div style={{ flex: 1, overflowY: 'auto', padding: 20 }}>
      {recentBuilds.length === 0 ? (
        <div style={{ textAlign: 'center', color: '#3a5070', fontSize: 11, marginTop: 40 }}>
          <div style={{ fontSize: 32, marginBottom: 8 }}>📦</div>
          No completed builds yet. Submit your first build!
        </div>
      ) : (
        <div style={S.card}>
          <div style={S.cardHeader}>Recent Builds — On-Chain Proof of Work</div>
          {recentBuilds.map((b, i) => (
            <div key={b.sessionId} className="nova-history-item" style={{
              ...S.historyItem,
              borderBottom: i < recentBuilds.length - 1 ? '1px solid #0a1828' : 'none',
            }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
                <span style={S.buildIntentBadge}>
                  {b.intent.slice(0, 60)}{b.intent.length > 60 ? '…' : ''}
                </span>
                <span style={{ color: buildStatusColor(b.status), fontSize: 9, marginLeft: 8 }}>
                  {buildStatusLabel(b.status)}
                </span>
              </div>
              {b.deployAddress && (
                <div style={{ fontSize: 9, color: '#4f4', marginTop: 2 }}>
                  ↳ {b.deployAddress}
                </div>
              )}
              <div style={{ fontSize: 8, color: '#2a4060', marginTop: 2 }}>
                Burned: {formatCycles(b.cyclesConsumed)} · {new Date(Number(b.completedAt) / 1_000_000).toLocaleString()}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );

  // ── Cycles tab
  const renderCycles = () => (
    <div style={{ flex: 1, overflowY: 'auto', padding: 20, display: 'flex', flexDirection: 'column', gap: 16 }}>
      {builderStatus ? (
        <>
          <div style={S.card}>
            <div style={S.cardHeader}>Subsidy Pool Economics</div>
            <div style={S.cardBody}>
              <p style={{ fontSize: 11, color: '#8090a8', lineHeight: 1.7, marginBottom: 12 }}>
                NOVA BUILDER runs on a cycles subsidy pool. Students never pay. Every build
                consumes cycles from this pool — creating direct ICP deflationary pressure.
                The pool is funded by NOVA protocol fees, donations, and grants.
              </p>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Pool Balance</span>
                <span style={S.metricValue(poolPct > 50 ? '#4f4' : '#fa0')}>
                  {formatCycles(builderStatus.subsidyPoolBalance)} cycles
                </span>
              </div>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Threshold</span>
                <span style={S.metricValue()}>{formatCycles(builderStatus.subsidyThreshold)}</span>
              </div>
              <div style={{ margin: '8px 0' }}>
                <div style={S.cyclesBar(poolPct)} />
                <div style={S.cyclesFill(poolPct)} />
              </div>
              <div style={S.metricRow}>
                <span style={S.metricLabel}>Rate Tier</span>
                <span style={S.metricValue(builderStatus.openToBuilders ? '#4f4' : '#f44')}>
                  {builderStatus.openToBuilders ? 'ACCEPTING BUILDS' : 'POOL BELOW THRESHOLD'}
                </span>
              </div>
            </div>
          </div>

          <div style={S.card}>
            <div style={S.cardHeader}>Lifetime Statistics</div>
            <div style={S.cardBody}>
              {[
                ['Total Builds Submitted', String(builderStatus.totalBuilds), '#c8d8f0'],
                ['Total Deployed',         String(builderStatus.totalDeployed), '#4f4'],
                ['Total Failed',           String(builderStatus.totalFailed),   '#f44'],
                ['Total Cycles Burned',    formatCycles(builderStatus.totalCyclesBurned), '#fa0'],
                ['Queue Depth',            String(builderStatus.queueDepth),    '#4af'],
              ].map(([label, value, color]) => (
                <div key={label} style={S.metricRow}>
                  <span style={S.metricLabel}>{label}</span>
                  <span style={S.metricValue(color as string)}>{value}</span>
                </div>
              ))}
            </div>
          </div>

          <div style={S.card}>
            <div style={S.cardHeader}>No-Drop Law — Immutable Covenant</div>
            <div style={{ ...S.cardBody }}>
              {[
                'No account-based limits. Ever.',
                'Every build burns cycles from the subsidy pool — direct ICP deflation.',
                'Pool funded by donations, grants, and NOVA protocol fees — not user charges.',
                'Governance (nova_governance) controls thresholds — not Medina Tech unilaterally.',
                'This canister cannot be shut down — it runs on ICP.',
                'Source code is on-chain. Every deploy is verifiable.',
                'This is not a startup. This is a protocol.',
              ].map((law, i) => (
                <div key={i} style={{ fontSize: 10, color: '#8090a8', padding: '4px 0',
                  borderBottom: '1px solid #0a1828', display: 'flex', gap: 8 }}>
                  <span style={{ color: '#4af', flexShrink: 0 }}>{i+1}.</span>
                  {law}
                </div>
              ))}
            </div>
          </div>
        </>
      ) : (
        <div style={{ textAlign: 'center', color: '#3a5070', fontSize: 11, marginTop: 40 }}>
          <div style={{ fontSize: 32, marginBottom: 8 }}>⟳</div>
          Loading pool economics from canister…
        </div>
      )}
    </div>
  );

  return (
    <div style={S.root}>
      {renderStatusBar()}

      <div style={S.tabBar}>
        {(['CHAT','STUDIO','HISTORY','CYCLES'] as const).map(t => (
          <button key={t} style={S.tab(tab === t)} onClick={() => setTab(t)}>
            {t === 'CHAT'    && '💬 '}
            {t === 'STUDIO'  && '⊕ '}
            {t === 'HISTORY' && '📦 '}
            {t === 'CYCLES'  && '⚡ '}
            {t}
          </button>
        ))}
      </div>

      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', overflow: 'hidden', minHeight: 0 }}>
        {tab === 'CHAT'    && renderChat()}
        {tab === 'STUDIO'  && renderStudio()}
        {tab === 'HISTORY' && renderHistory()}
        {tab === 'CYCLES'  && renderCycles()}
      </div>
    </div>
  );
}

export default NovaBuilderDashboard;
