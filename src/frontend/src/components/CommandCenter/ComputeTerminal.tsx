// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — Compute Terminal Component
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useRef, useEffect } from 'react';
import type { ComputeNode, Message } from './OroCommandCenter';

const S = {
  root: {
    height: '100%',
    display: 'grid',
    gridTemplateColumns: '280px 1fr',
    gap: 2,
  },
  nodesPanel: {
    background: 'rgba(5, 15, 30, 0.8)',
    borderRight: '1px solid #1a3a5c',
    padding: '12px',
    overflow: 'auto',
  },
  terminalPanel: {
    background: '#020408',
    fontFamily: 'monospace',
    padding: '12px',
    overflow: 'auto',
  },
  sectionTitle: {
    fontSize: 10,
    color: '#4af',
    textTransform: 'uppercase' as const,
    letterSpacing: '0.12em',
    marginBottom: 12,
    display: 'flex',
    alignItems: 'center',
    gap: 8,
  },
  nodeCard: (status: string) => ({
    background: 'rgba(10, 30, 50, 0.6)',
    border: `1px solid ${
      status === 'Online' ? '#2a5a8a' :
      status === 'Busy' ? '#5a8a2a' :
      '#3a2a2a'
    }`,
    borderRadius: 6,
    padding: '10px 12px',
    marginBottom: 8,
  }),
  nodeHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 8,
  },
  nodeName: {
    fontSize: 11,
    fontWeight: 'bold',
    color: '#fff',
  },
  nodeStatus: (status: string) => ({
    fontSize: 8,
    padding: '2px 8px',
    borderRadius: 8,
    textTransform: 'uppercase' as const,
    background:
      status === 'Online' ? '#0a2a3a' :
      status === 'Busy' ? '#2a3a0a' :
      '#2a0a0a',
    color:
      status === 'Online' ? '#4af' :
      status === 'Busy' ? '#af4' :
      '#f44',
    border: `1px solid ${
      status === 'Online' ? '#4af' :
      status === 'Busy' ? '#af4' :
      '#f44'
    }`,
  }),
  nodeMetrics: {
    display: 'grid',
    gridTemplateColumns: '1fr 1fr',
    gap: 8,
  },
  metric: {
    display: 'flex',
    flexDirection: 'column' as const,
    gap: 4,
  },
  metricLabel: {
    fontSize: 8,
    color: '#5a8aba',
    textTransform: 'uppercase' as const,
  },
  metricBar: {
    height: 4,
    background: '#0a1a2a',
    borderRadius: 2,
    overflow: 'hidden',
  },
  metricFill: (value: number, type: string) => ({
    width: `${value * 100}%`,
    height: '100%',
    background:
      type === 'load' ? (value > 0.8 ? '#f44' : value > 0.5 ? '#fa4' : '#4af') :
      (value > 0.8 ? '#f44' : value > 0.5 ? '#fa4' : '#4f8'),
    borderRadius: 2,
  }),
  nodeProcess: {
    marginTop: 8,
    padding: '4px 8px',
    background: 'rgba(80, 255, 120, 0.1)',
    border: '1px solid #4f8',
    borderRadius: 4,
    fontSize: 9,
    color: '#4f8',
  },
  terminalLine: (type: string) => ({
    fontSize: 10,
    lineHeight: 1.6,
    color:
      type === 'System' ? '#888' :
      type === 'Request' ? '#4af' :
      type === 'Response' ? '#4f8' :
      type === 'Alert' ? '#f44' :
      '#6ac',
    marginBottom: 2,
  }),
  timestamp: {
    color: '#3a5a7a',
    marginRight: 8,
  },
  from: {
    color: '#6ac',
    marginRight: 8,
  },
  prompt: {
    color: '#4af',
    marginRight: 4,
  },
  cursor: {
    display: 'inline-block',
    width: 8,
    height: 14,
    background: '#4af',
    animation: 'blink 1s infinite',
    verticalAlign: 'middle',
  },
};

interface Props {
  nodes: ComputeNode[];
  messages: Message[];
}

export function ComputeTerminal({ nodes, messages }: Props) {
  const terminalRef = useRef<HTMLDivElement>(null);
  
  useEffect(() => {
    if (terminalRef.current) {
      terminalRef.current.scrollTop = terminalRef.current.scrollHeight;
    }
  }, [messages]);
  
  const formatTime = (timestamp: number) => {
    const date = new Date(timestamp);
    return date.toLocaleTimeString('en-US', { hour12: false });
  };
  
  return (
    <div style={S.root}>
      {/* Compute Nodes */}
      <div style={S.nodesPanel}>
        <div style={S.sectionTitle}>
          <span>🖥️</span> Compute Nodes
        </div>
        {nodes.map(node => (
          <div key={node.id} style={S.nodeCard(node.status)}>
            <div style={S.nodeHeader}>
              <span style={S.nodeName}>{node.name}</span>
              <span style={S.nodeStatus(node.status)}>{node.status}</span>
            </div>
            <div style={S.nodeMetrics}>
              <div style={S.metric}>
                <span style={S.metricLabel}>CPU Load</span>
                <div style={S.metricBar}>
                  <div style={S.metricFill(node.load, 'load')} />
                </div>
              </div>
              <div style={S.metric}>
                <span style={S.metricLabel}>Memory</span>
                <div style={S.metricBar}>
                  <div style={S.metricFill(node.memory, 'memory')} />
                </div>
              </div>
            </div>
            {node.currentProcess && (
              <div style={S.nodeProcess}>
                ◉ {node.currentProcess}
              </div>
            )}
          </div>
        ))}
      </div>
      
      {/* Terminal Output */}
      <div style={S.terminalPanel} ref={terminalRef}>
        <div style={S.sectionTitle}>
          <span>⌨️</span> System Terminal
        </div>
        
        {/* Boot message */}
        <div style={S.terminalLine('System')}>
          <span style={S.timestamp}>[BOOT]</span>
          <span>ORO Command Center v1.0.0 initialized</span>
        </div>
        <div style={S.terminalLine('System')}>
          <span style={S.timestamp}>[BOOT]</span>
          <span>All compute nodes online. Agents synchronized.</span>
        </div>
        <div style={S.terminalLine('System')}>
          <span style={S.timestamp}>[BOOT]</span>
          <span>Law enforcement module active. Stability budget: 100%</span>
        </div>
        <div style={{ marginBottom: 8 }} />
        
        {/* Messages */}
        {messages.map(msg => (
          <div key={msg.id} style={S.terminalLine(msg.type)}>
            <span style={S.timestamp}>[{formatTime(msg.timestamp)}]</span>
            <span style={S.from}>{msg.from}→{msg.to === 'broadcast' ? 'ALL' : msg.to}:</span>
            <span>{msg.content}</span>
          </div>
        ))}
        
        {/* Cursor */}
        <div style={S.terminalLine('Info')}>
          <span style={S.prompt}>ORO&gt;</span>
          <span style={S.cursor} />
        </div>
      </div>
      
      {/* CSS for cursor blink */}
      <style>{`
        @keyframes blink {
          0%, 50% { opacity: 1; }
          51%, 100% { opacity: 0; }
        }
      `}</style>
    </div>
  );
}
