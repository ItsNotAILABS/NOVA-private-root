// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — NOVA Public GitHub Repository Definitions
// 3 named repositories for public release
// ═══════════════════════════════════════════════════════════════════════════════

import type { PublicRepo } from './types';

export const PUBLIC_REPOS: PublicRepo[] = [

  // ═══════════════════════════════════════════════════════════════════════════
  // REPO 1: nova-sdk — The Developer SDK Platform
  // ═══════════════════════════════════════════════════════════════════════════
  {
    name: 'nova-sdk',
    description: 'NOVA Sovereign SDK — Build living AI organisms on the Internet Computer. 50 SDKs across 15 domains: defense, memory, governance, neural, quantum, economic, swarm, cognitive, sensor, frequency, sovereignty, integration, packaging, intelligence, and mathematics. Each SDK wraps real canister endpoints into developer-facing intelligence packages.',
    sdks: [
      'SDK-01', 'SDK-02', 'SDK-03', 'SDK-04', 'SDK-05', 'SDK-06', 'SDK-07', 'SDK-08',
      'SDK-09', 'SDK-10', 'SDK-11', 'SDK-12',
      'SDK-13', 'SDK-14', 'SDK-15', 'SDK-16',
      'SDK-17', 'SDK-18', 'SDK-19', 'SDK-20', 'SDK-21', 'SDK-22',
      'SDK-23', 'SDK-24', 'SDK-25', 'SDK-26', 'SDK-27', 'SDK-28',
      'SDK-29', 'SDK-30', 'SDK-31', 'SDK-32', 'SDK-33',
      'SDK-34', 'SDK-35', 'SDK-36', 'SDK-37',
      'SDK-38', 'SDK-39', 'SDK-40', 'SDK-41',
      'SDK-42', 'SDK-43',
      'SDK-44', 'SDK-45',
      'SDK-46', 'SDK-47',
      'SDK-48',
      'SDK-49',
      'SDK-50',
    ],
    tools: [],
    packages: [],
    language: 'TypeScript + Motoko',
    license: 'NOVA Sovereign License',
    topics: [
      'icp', 'internet-computer', 'motoko', 'ai-organism', 'sovereign-sdk',
      'dfinity', 'canister', 'quantum', 'swarm-intelligence', 'neural-network',
      'token-organism', 'defense-systems', 'memory-temple', 'sacred-mathematics',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // REPO 2: nova-tools — The Developer Toolchain
  // ═══════════════════════════════════════════════════════════════════════════
  {
    name: 'nova-tools',
    description: 'NOVA Developer Toolchain — 50 tools for building, monitoring, analyzing, integrating, and securing NOVA organisms. Includes nova-cli (sovereign build), nova-inspector (state inspection), nova-pulse (real-time monitoring), nova-spectrum (frequency analysis), nova-swarm-viz (3D swarm visualization), and 45 more tools for the complete NOVA development workflow.',
    sdks: [],
    tools: [
      'TOOL-01', 'TOOL-02', 'TOOL-03', 'TOOL-04', 'TOOL-05',
      'TOOL-06', 'TOOL-07', 'TOOL-08', 'TOOL-09', 'TOOL-10',
      'TOOL-11', 'TOOL-12', 'TOOL-13', 'TOOL-14', 'TOOL-15',
      'TOOL-16', 'TOOL-17', 'TOOL-18',
      'TOOL-19', 'TOOL-20', 'TOOL-21', 'TOOL-22', 'TOOL-23',
      'TOOL-24', 'TOOL-25', 'TOOL-26',
      'TOOL-27', 'TOOL-28', 'TOOL-29', 'TOOL-30', 'TOOL-31',
      'TOOL-32', 'TOOL-33', 'TOOL-34',
      'TOOL-35', 'TOOL-36', 'TOOL-37', 'TOOL-38', 'TOOL-39', 'TOOL-40',
      'TOOL-41', 'TOOL-42', 'TOOL-43', 'TOOL-44', 'TOOL-45', 'TOOL-46',
      'TOOL-47', 'TOOL-48', 'TOOL-49', 'TOOL-50',
    ],
    packages: [],
    language: 'TypeScript + Rust + Go',
    license: 'NOVA Developer License',
    topics: [
      'developer-tools', 'cli', 'monitoring', 'analytics', 'security',
      'icp', 'motoko', 'canister-tools', 'devops', 'visualization',
      'graphql', 'rest-api', 'testing', 'benchmarking', 'documentation',
    ],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // REPO 3: nova-workplace — The Developer Workspace
  // ═══════════════════════════════════════════════════════════════════════════
  {
    name: 'nova-workplace',
    description: 'NOVA Workplace — Complete developer workspace combining all 100 API calls, 80 organism packages, 50 SDKs, 50 tools, and 100 F-MODEL intelligence species into one unified development environment. Terminal system with 15 domain surfaces, real-time canister wire, and the sovereign flip engine for building your own organisms on the Internet Computer.',
    sdks: [
      'SDK-01', 'SDK-09', 'SDK-13', 'SDK-17', 'SDK-23',
      'SDK-29', 'SDK-34', 'SDK-38', 'SDK-42', 'SDK-44',
      'SDK-46', 'SDK-48', 'SDK-49', 'SDK-50',
    ],
    tools: [
      'TOOL-01', 'TOOL-02', 'TOOL-03', 'TOOL-05', 'TOOL-08',
      'TOOL-11', 'TOOL-29', 'TOOL-32', 'TOOL-35', 'TOOL-47', 'TOOL-48',
    ],
    packages: [
      'PKG-01', 'PKG-04', 'PKG-06', 'PKG-08', 'PKG-11',
      'PKG-13', 'PKG-15', 'PKG-18', 'PKG-21', 'PKG-23',
      'PKG-25', 'PKG-27', 'PKG-29', 'PKG-30',
    ],
    language: 'TypeScript + React + Motoko',
    license: 'NOVA Workplace License',
    topics: [
      'workspace', 'ide', 'developer-experience', 'ai-organism',
      'icp', 'motoko', 'react', 'terminal', 'dashboard',
      'sovereign-computing', 'quantum-intelligence', 'sacred-mathematics',
    ],
  },
];

/** Get repo by name */
export function getRepoByName(name: string): PublicRepo | undefined {
  return PUBLIC_REPOS.find(r => r.name === name);
}
