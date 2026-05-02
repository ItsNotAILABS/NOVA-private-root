// ═══════════════════════════════════════════════════════════════════════════════
// AI CONCIERGE — Intelligent Travel Assistant
// BUILD №49 — NOVA V5 Airport Application
// ═══════════════════════════════════════════════════════════════════════════════

import React, { useState } from 'react';

interface ConciergeProps {
  passengerId: string;
}

interface Message {
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
}

export function Concierge({ passengerId }: ConciergeProps) {
  const [messages, setMessages] = useState<Message[]>([
    {
      role: 'assistant',
      content: 'Hello! I\'m your NOVA AI Concierge. I can help you with dining recommendations, gate navigation, flight connections, and more. How can I assist you today?',
      timestamp: new Date()
    }
  ]);
  const [input, setInput] = useState('');

  const handleSend = () => {
    if (!input.trim()) return;

    const userMessage: Message = {
      role: 'user',
      content: input,
      timestamp: new Date()
    };

    // Mock AI response
    const aiResponse: Message = {
      role: 'assistant',
      content: getMockResponse(input),
      timestamp: new Date()
    };

    setMessages([...messages, userMessage, aiResponse]);
    setInput('');
  };

  const getMockResponse = (query: string): string => {
    const lowerQuery = query.toLowerCase();

    if (lowerQuery.includes('restaurant') || lowerQuery.includes('food') || lowerQuery.includes('dining')) {
      return 'I recommend "The Sky Lounge" near Gate A7. They serve excellent Tex-Mex cuisine and accept AEROPORTO tokens. You\'re 5 minutes walking distance from there!';
    } else if (lowerQuery.includes('gate') || lowerQuery.includes('navigate')) {
      return 'Your gate A7 is in Terminal A. From your current location, head north through security, turn right, and it\'s the 7th gate on your left. Walking time: approximately 12 minutes.';
    } else if (lowerQuery.includes('connection') || lowerQuery.includes('transfer')) {
      return 'You have 90 minutes for your connection to LAX → SFO. This is comfortable timing. Your connection gate is B12, which is a 15-minute walk from A7. I\'ll send you a notification 30 minutes before boarding.';
    } else {
      return 'I\'m here to help! You can ask me about restaurants, gate navigation, flight connections, entertainment options, or anything else you need during your journey.';
    }
  };

  return (
    <div style={{
      display: 'flex',
      flexDirection: 'column',
      height: '600px',
      background: 'rgba(255, 255, 255, 0.05)',
      borderRadius: '12px',
      border: '1px solid rgba(255, 255, 255, 0.1)',
      overflow: 'hidden'
    }}>
      <div style={{
        padding: '1.5rem',
        background: 'rgba(0, 0, 0, 0.3)',
        borderBottom: '1px solid rgba(255, 255, 255, 0.1)'
      }}>
        <h2 style={{ margin: 0 }}>🤖 AI Travel Concierge</h2>
        <p style={{ margin: '0.5rem 0 0 0', fontSize: '0.9rem', color: '#95a5a6' }}>
          Powered by NOVA swarm_brain intelligence
        </p>
      </div>

      <div style={{
        flex: 1,
        padding: '1.5rem',
        overflowY: 'auto',
        display: 'flex',
        flexDirection: 'column',
        gap: '1rem'
      }}>
        {messages.map((msg, idx) => (
          <div
            key={idx}
            style={{
              alignSelf: msg.role === 'user' ? 'flex-end' : 'flex-start',
              maxWidth: '70%'
            }}
          >
            <div style={{
              padding: '1rem',
              borderRadius: '12px',
              background: msg.role === 'user' ?
                'linear-gradient(135deg, #f39c12, #e74c3c)' :
                'rgba(255, 255, 255, 0.1)',
              border: msg.role === 'assistant' ? '1px solid rgba(255, 255, 255, 0.2)' : 'none'
            }}>
              {msg.content}
            </div>
            <div style={{
              fontSize: '0.75rem',
              color: '#7f8c8d',
              marginTop: '0.25rem',
              textAlign: msg.role === 'user' ? 'right' : 'left'
            }}>
              {msg.timestamp.toLocaleTimeString()}
            </div>
          </div>
        ))}
      </div>

      <div style={{
        padding: '1.5rem',
        background: 'rgba(0, 0, 0, 0.3)',
        borderTop: '1px solid rgba(255, 255, 255, 0.1)',
        display: 'flex',
        gap: '1rem'
      }}>
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && handleSend()}
          placeholder="Ask me anything..."
          style={{
            flex: 1,
            padding: '0.75rem',
            borderRadius: '8px',
            border: '1px solid rgba(255, 255, 255, 0.2)',
            background: 'rgba(255, 255, 255, 0.05)',
            color: '#e0e0e0',
            fontSize: '1rem'
          }}
        />
        <button
          onClick={handleSend}
          style={{
            padding: '0.75rem 1.5rem',
            borderRadius: '8px',
            border: 'none',
            background: 'linear-gradient(135deg, #f39c12, #e74c3c)',
            color: 'white',
            fontWeight: 'bold',
            cursor: 'pointer'
          }}
        >
          Send
        </button>
      </div>
    </div>
  );
}
