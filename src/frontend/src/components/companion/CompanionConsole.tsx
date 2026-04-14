import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';

type Role = 'user' | 'assistant' | 'system';

type CompanionMessage = {
  id: string;
  role: Role;
  text: string;
  ts: number;
};

type CommandResult = {
  ok: boolean;
  command: string;
  stdout: string;
  stderr: string;
  code: number;
  dryRun?: boolean;
  allowExec?: boolean;
  resolvedCommand?: string;
  message?: string;
};

type BrowserSpeechRecognition = {
  continuous: boolean;
  interimResults: boolean;
  lang: string;
  onresult: ((event: { results: ArrayLike<ArrayLike<{ transcript: string }>> }) => void) | null;
  onerror: ((event: { error?: string }) => void) | null;
  onend: (() => void) | null;
  start: () => void;
  stop: () => void;
};

type SpeechWindow = Window & {
  webkitSpeechRecognition?: new () => BrowserSpeechRecognition;
  SpeechRecognition?: new () => BrowserSpeechRecognition;
};

const S = {
  root: {
    width: '100%',
    height: '100%',
    display: 'grid',
    gridTemplateColumns: '1fr 300px',
    background: '#040b18',
    color: '#cfe8ff',
  },
  center: {
    display: 'grid',
    gridTemplateRows: '42px 1fr 80px',
    borderRight: '1px solid #1b3857',
  },
  topbar: {
    display: 'flex',
    alignItems: 'center',
    gap: 10,
    padding: '0 14px',
    borderBottom: '1px solid #1b3857',
    fontSize: 12,
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
    color: '#73b6ff',
  },
  stream: {
    overflowY: 'auto' as const,
    padding: 12,
    display: 'flex',
    flexDirection: 'column' as const,
    gap: 8,
  },
  bubble: (role: Role) => ({
    alignSelf: role === 'user' ? 'flex-end' : 'flex-start',
    maxWidth: '86%',
    whiteSpace: 'pre-wrap' as const,
    border: '1px solid #1f466e',
    borderRadius: 8,
    padding: '8px 10px',
    background: role === 'user' ? '#123055' : role === 'assistant' ? '#0b1f35' : '#1f2f24',
    color: '#d8edff',
    fontSize: 13,
    lineHeight: 1.4,
  }),
  composer: {
    display: 'grid',
    gridTemplateColumns: '1fr auto auto auto',
    gap: 8,
    padding: 10,
    borderTop: '1px solid #1b3857',
    alignItems: 'center',
  },
  input: {
    width: '100%',
    height: 42,
    borderRadius: 7,
    border: '1px solid #2c5a86',
    background: '#071628',
    color: '#d8edff',
    padding: '0 12px',
    outline: 'none',
    fontSize: 14,
  },
  btn: (danger = false) => ({
    height: 38,
    borderRadius: 7,
    border: `1px solid ${danger ? '#8d2b2b' : '#2c5a86'}`,
    background: danger ? '#3a1616' : '#10263f',
    color: danger ? '#ffcaca' : '#b8dcff',
    padding: '0 12px',
    cursor: 'pointer',
    fontSize: 12,
    letterSpacing: '0.06em',
    textTransform: 'uppercase' as const,
  }),
  right: {
    display: 'grid',
    gridTemplateRows: '42px auto auto 1fr',
  },
  panelTitle: {
    display: 'flex',
    alignItems: 'center',
    padding: '0 12px',
    borderBottom: '1px solid #1b3857',
    fontSize: 11,
    letterSpacing: '0.08em',
    textTransform: 'uppercase' as const,
    color: '#73b6ff',
  },
  panel: {
    padding: 10,
    borderBottom: '1px solid #1b3857',
    fontSize: 12,
    lineHeight: 1.5,
    color: '#b8dcff',
  },
  statusDot: (on: boolean) => ({
    width: 9,
    height: 9,
    borderRadius: '50%',
    display: 'inline-block',
    background: on ? '#39e58f' : '#7a3d3d',
    marginRight: 8,
  }),
  mono: {
    fontFamily: 'ui-monospace, SFMono-Regular, Menlo, monospace',
    fontSize: 11,
    whiteSpace: 'pre-wrap' as const,
    color: '#9ec9f5',
    background: '#081628',
    border: '1px solid #1b3857',
    borderRadius: 6,
    padding: 8,
    maxHeight: 220,
    overflowY: 'auto' as const,
  },
};

const EXEC_HELP = `Companion commands:
/help
/status
/voice on|off
/shell on|off
/run <command>

Examples:
/run pwd
/run ls
/run git status
`;

export function CompanionConsole() {
  const [input, setInput] = useState('');
  const [messages, setMessages] = useState<CompanionMessage[]>([
    {
      id: 'boot-1',
      role: 'system',
      text: 'AURO companion online. Type /help for command mode.',
      ts: Date.now(),
    },
  ]);
  const [voiceEnabled, setVoiceEnabled] = useState(false);
  const [voiceListening, setVoiceListening] = useState(false);
  const [shellEnabled, setShellEnabled] = useState(false);
  const [lastCommandResult, setLastCommandResult] = useState<CommandResult | null>(null);

  const streamRef = useRef<HTMLDivElement>(null);
  const recognitionRef = useRef<BrowserSpeechRecognition | null>(null);

  const apiBase = useMemo(() => {
    if (typeof window === 'undefined') return 'http://127.0.0.1:8787';
    const anyWindow = window as Window & { __AURO_API_BASE__?: string };
    const runtimeBase = anyWindow.__AURO_API_BASE__ ?? import.meta.env.VITE_AURO_API_BASE ?? 'http://127.0.0.1:8787';
    return runtimeBase.replace(/\/+$/, '');
  }, []);
  const bridgeToken = useMemo(() => {
    if (typeof window === 'undefined') return import.meta.env.VITE_AURO_BRIDGE_TOKEN ?? '';
    const anyWindow = window as Window & { __AURO_BRIDGE_TOKEN__?: string };
    return anyWindow.__AURO_BRIDGE_TOKEN__ ?? import.meta.env.VITE_AURO_BRIDGE_TOKEN ?? '';
  }, []);

  const buildBridgeHeaders = useCallback((): Record<string, string> => {
    const headers: Record<string, string> = { 'Content-Type': 'application/json' };
    const token = bridgeToken.trim();
    if (token.length > 0) headers['x-auro-token'] = token;
    return headers;
  }, [bridgeToken]);

  const push = useCallback((role: Role, text: string) => {
    setMessages(prev => prev.concat({
      id: `${Date.now()}-${Math.random().toString(36).slice(2)}`,
      role,
      text,
      ts: Date.now(),
    }));
  }, []);

  useEffect(() => {
    const el = streamRef.current;
    if (!el) return;
    el.scrollTop = el.scrollHeight;
  }, [messages]);

  const speak = useCallback((text: string) => {
    if (!voiceEnabled) return;
    if (typeof window === 'undefined' || typeof window.speechSynthesis === 'undefined') return;
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.rate = 1.0;
    utterance.pitch = 1.0;
    utterance.lang = 'en-US';
    window.speechSynthesis.cancel();
    window.speechSynthesis.speak(utterance);
  }, [voiceEnabled]);

  const setupRecognition = useCallback(() => {
    if (typeof window === 'undefined') return null;
    const w = window as SpeechWindow;
    const Ctor = w.SpeechRecognition || w.webkitSpeechRecognition;
    if (!Ctor) return null;
    const rec = new Ctor();
    rec.lang = 'en-US';
    rec.continuous = true;
    rec.interimResults = false;
    rec.onresult = (event) => {
      const last = event.results[event.results.length - 1];
      const text = last?.[0]?.transcript?.trim() || '';
      if (!text) return;
      setInput(text);
    };
    rec.onerror = (event) => {
      push('system', `Voice error: ${event.error || 'unknown'}`);
    };
    rec.onend = () => {
      setVoiceListening(false);
    };
    return rec;
  }, [push]);

  const toggleListening = useCallback(() => {
    if (!voiceEnabled) return;
    if (!recognitionRef.current) {
      recognitionRef.current = setupRecognition();
      if (!recognitionRef.current) {
        push('system', 'Speech recognition is not supported in this browser.');
        return;
      }
    }
    if (!voiceListening) {
      recognitionRef.current.start();
      setVoiceListening(true);
    } else {
      recognitionRef.current.stop();
      setVoiceListening(false);
    }
  }, [voiceEnabled, voiceListening, push, setupRecognition]);

  const runLocalCommand = useCallback(async (command: string): Promise<CommandResult> => {
    if (!shellEnabled) {
      return {
        ok: false,
        command,
        stdout: '',
        stderr: 'Shell bridge is disabled. Enable with /shell on.',
        code: 1,
      };
    }
    try {
      const res = await fetch(`${apiBase}/command`, {
        method: 'POST',
        headers: buildBridgeHeaders(),
        body: JSON.stringify({ command }),
      });
      const data = await res.json() as CommandResult;
      return {
        command,
        stdout: '',
        stderr: '',
        code: 0,
        ...data,
      };
    } catch (e) {
      return {
        ok: false,
        command,
        stdout: '',
        stderr: `Bridge error: ${e instanceof Error ? e.message : String(e)}`,
        code: 1,
      };
    }
  }, [apiBase, buildBridgeHeaders, shellEnabled]);

  const handleCommand = useCallback(async (text: string) => {
    const trimmed = text.trim();
    if (!trimmed.startsWith('/')) return false;

    const [cmd, ...rest] = trimmed.split(' ');
    const arg = rest.join(' ').trim();

    if (cmd === '/help') {
      push('assistant', EXEC_HELP);
      return true;
    }
    if (cmd === '/status') {
      push(
        'assistant',
        `Voice: ${voiceEnabled ? 'ON' : 'OFF'}\nListening: ${voiceListening ? 'YES' : 'NO'}\nShell bridge: ${shellEnabled ? 'ON' : 'OFF'}\nBridge URL: ${apiBase}\nBridge token: ${bridgeToken ? 'SET' : 'NOT SET'}`
      );
      return true;
    }
    if (cmd === '/voice') {
      const on = arg.toLowerCase() === 'on';
      const off = arg.toLowerCase() === 'off';
      if (on) {
        setVoiceEnabled(true);
        push('assistant', 'Voice output enabled.');
      } else if (off) {
        setVoiceEnabled(false);
        setVoiceListening(false);
        if (recognitionRef.current) recognitionRef.current.stop();
        push('assistant', 'Voice output disabled.');
      } else {
        push('assistant', 'Usage: /voice on|off');
      }
      return true;
    }
    if (cmd === '/shell') {
      const on = arg.toLowerCase() === 'on';
      const off = arg.toLowerCase() === 'off';
      if (on) {
        setShellEnabled(true);
        push('assistant', 'Shell bridge enabled for this browser session.');
      } else if (off) {
        setShellEnabled(false);
        push('assistant', 'Shell bridge disabled.');
      } else {
        push('assistant', 'Usage: /shell on|off');
      }
      return true;
    }
    if (cmd === '/run') {
      if (!arg) {
        push('assistant', 'Usage: /run <command>');
        return true;
      }
      const result = await runLocalCommand(arg);
      setLastCommandResult(result);
      push('assistant', result.ok ? `OK: ${arg}` : `FAILED: ${arg}\n${result.stderr || 'Unknown error'}`);
      return true;
    }

    push('assistant', `Unknown command: ${cmd}\nType /help.`);
    return true;
  }, [apiBase, bridgeToken, push, runLocalCommand, shellEnabled, voiceEnabled, voiceListening]);

  const chatLocalFallback = useCallback((text: string): string => {
    const t = text.toLowerCase();
    if (t.includes('status')) {
      return 'Core loop is active. Heartbeat, CCVE, and command surfaces are online in this session.';
    }
    if (t.includes('heart') || t.includes('ccve')) {
      return 'Cardio-cerebral vector is active. You can query backend state with getCardioCerebralState when canister is live.';
    }
    if (t.includes('run') || t.includes('computer')) {
      return 'Use command mode: /shell on, then /run <command>.';
    }
    return 'I am online in local companion mode. Use /help for controls.';
  }, []);

  const send = useCallback(async () => {
    const text = input.trim();
    if (!text) return;
    setInput('');
    push('user', text);

    if (await handleCommand(text)) return;

    try {
      const res = await fetch(`${apiBase}/chat`, {
        method: 'POST',
        headers: buildBridgeHeaders(),
        body: JSON.stringify({ message: text }),
      });
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const data = await res.json() as { reply?: string };
      const reply = data.reply || 'No response payload received.';
      push('assistant', reply);
      speak(reply);
    } catch {
      const reply = chatLocalFallback(text);
      push('assistant', reply);
      speak(reply);
    }
  }, [apiBase, buildBridgeHeaders, chatLocalFallback, handleCommand, input, push, speak]);

  return (
    <div style={S.root}>
      <div style={S.center}>
        <div style={S.topbar}>
          <span>AURO Companion Console</span>
          <span style={{ color: '#4f86bd', fontSize: 11 }}>chat + voice + local command bridge</span>
        </div>

        <div ref={streamRef} style={S.stream}>
          {messages.map(m => (
            <div key={m.id} style={S.bubble(m.role)}>
              {m.text}
            </div>
          ))}
        </div>

        <div style={S.composer}>
          <input
            style={S.input}
            value={input}
            onChange={e => setInput(e.target.value)}
            onKeyDown={e => {
              if (e.key === 'Enter') void send();
            }}
            placeholder="Talk to AURO… (/help for command mode)"
          />
          <button style={S.btn()} onClick={() => { void send(); }}>Send</button>
          <button style={S.btn()} onClick={toggleListening} disabled={!voiceEnabled}>
            {voiceListening ? 'Stop Mic' : 'Mic'}
          </button>
          <button
            style={S.btn(true)}
            onClick={() => {
              setMessages([]);
              setLastCommandResult(null);
            }}
          >
            Clear
          </button>
        </div>
      </div>

      <div style={S.right}>
        <div style={S.panelTitle}>Runtime</div>
        <div style={S.panel}>
          <div><span style={S.statusDot(voiceEnabled)} />Voice output: {voiceEnabled ? 'ON' : 'OFF'}</div>
          <div><span style={S.statusDot(voiceListening)} />Voice listening: {voiceListening ? 'ON' : 'OFF'}</div>
          <div><span style={S.statusDot(shellEnabled)} />Shell bridge: {shellEnabled ? 'ON' : 'OFF'}</div>
          <div style={{ marginTop: 8, color: '#8ab9e6' }}>
            Commands: /help /status /voice on /shell on /run ...
          </div>
        </div>

        <div style={S.panelTitle}>Last Command Result</div>
        <div style={S.panel}>
          {lastCommandResult ? (
            <div style={S.mono}>
              {`$ ${lastCommandResult.command}

exit: ${lastCommandResult.code}
ok: ${lastCommandResult.ok}

stdout:
${lastCommandResult.stdout || '(empty)'}

stderr:
${lastCommandResult.stderr || '(empty)'}`}
            </div>
          ) : (
            <div style={{ color: '#7eaad4' }}>No command executed yet.</div>
          )}
        </div>

        <div style={S.panelTitle}>Safety</div>
        <div style={S.panel}>
          Shell bridge is opt-in and disabled by default.
          <br />
          Enable explicitly with <code>/shell on</code>.
          <br />
          Use only on trusted local machine.
        </div>
      </div>
    </div>
  );
}

export default CompanionConsole;
