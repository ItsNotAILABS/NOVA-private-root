// ═══════════════════════════════════════════════════════════════════════════
// NOVA × DALLAS ISD — FULL AI CLASSROOM PLATFORM (Build №43)
// Language: CPL (TypeScript + JSX substrate)
// ═══════════════════════════════════════════════════════════════════════════
//
// ARCHITECTURE — MULTIPLE BACKENDS:
//   BACKEND 1: dallas_isd canister    → TEKS curriculum, φ-math engine, grants
//   BACKEND 2: nova_student canister  → student sessions, SM-2 quiz, AI tutor
//   BACKEND 3: swarm_brain canister   → real AI responses (via nova_student.askTutor)
//
// DATA FLOW (Casa de Inteligencia):
//   Student asks question
//     → DallasISDApp (CPL view, visualization layer)
//     → novaStudentActor.askTutor(sessionId, subject, question)
//     → nova_student canister [on-chain session log + progress update]
//     → swarm_brain.tutorQuery(subject, question, context) [real AI]
//     → nova_stream.publish(STUDENT_ASK) [event bus]
//     → response returned to frontend
//
//   Student loads a concept
//     → dallasISDCanisterActor.getConceptContent(conceptId)
//     → dallas_isd canister [on-chain curriculum content]
//     → CPL view renders the on-chain content
//
//   Math engine values (φ, Fibonacci, Feigenbaum)
//     → dallasISDCanisterActor.getMathEngine()
//     → dallas_isd canister [sovereign constants stored on-chain]
//     → CPL visualizations use ON-CHAIN values, not local hardcode
//
// SUBJECTS: Mathematics · Science · Social Studies · ELA · Computer Science
// VOICE: Web Speech API — student speaks, NOVA responds aloud
// GRANT-COMPLIANT: Title I, Title IV-A, TEA STEM, NSF, E-Rate on-chain
//
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
// FREE FOR ALL DALLAS ISD & DALLAS COUNTY PUBLIC SCHOOLS
// MEDINA TECH — DALLAS, TEXAS
// ═══════════════════════════════════════════════════════════════════════════

import React, { useCallback, useEffect, useRef, useState } from 'react';
import { getNovaStudentActor, type AskTutorResult } from '../canister/novaStudentActor';
import {
  getDallasISDCanisterActor,
  type TEKSConceptSummary,
  type ConceptContent,
  type MathEngine,
  type GrantEntry,
  type ClassroomStatus,
} from '../canister/dallasISDCanisterActor';

// ── §1  TYPES & CONSTANTS ─────────────────────────────────────────────────

type Subject = 'HOME' | 'MATH' | 'SCIENCE' | 'SOCIAL_STUDIES' | 'ELA' | 'CS';
type ToolTab = 'TUTOR' | 'CONCEPTS' | 'QUIZ' | 'GRANTS';

const SUBJECT_COLORS: Record<Subject, string> = {
  HOME: '#4af', MATH: '#c8a84e', SCIENCE: '#4ecdc4',
  SOCIAL_STUDIES: '#a78bfa', ELA: '#f97316', CS: '#34d399',
};

const SUBJECT_ICONS: Record<Subject, string> = {
  HOME: '⊕', MATH: 'φ', SCIENCE: '⚗', SOCIAL_STUDIES: '🗺', ELA: '📖', CS: '💻',
};

interface ChatMessage {
  id:        string;
  role:      'NOVA' | 'STUDENT';
  text:      string;
  teksRef?:  string;
  confidence?: number;
  mathDepth?: number;
  timestamp: number;
}

// SM-2 quiz state (local mirror of on-chain state — synced on update)
interface LocalQuizCard {
  cardId:     string;
  subject:    Subject;
  question:   string;
  answer:     string;
  hint:       string;
  reps:       number;
  interval:   number;
  easiness:   number;
  nextReview: number;
  isDue:      boolean;
}

const QUIZ_BANK: LocalQuizCard[] = [
  { cardId:'m1', subject:'MATH', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:'What is the Golden Ratio φ to 4 decimal places?',
    answer:'1.6180', hint:'φ = (1 + √5) / 2' },
  { cardId:'m2', subject:'MATH', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:'What is F(10) in the Fibonacci sequence?',
    answer:'55', hint:'Count: 1,1,2,3,5,8,13,21,34,55' },
  { cardId:'m3', subject:'MATH', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:'Derivative of f(x) = x⁴?',
    answer:'4x³', hint:'Power rule: d/dx[xⁿ] = n·xⁿ⁻¹' },
  { cardId:'s1', subject:'SCIENCE', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:'What is the overall equation for photosynthesis?',
    answer:'6CO₂ + 6H₂O + light → C₆H₁₂O₆ + 6O₂',
    hint:'Carbon dioxide + water + light → glucose + oxygen' },
  { cardId:'s2', subject:'SCIENCE', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:'Period of a pendulum of length 1m (g=9.81)?',
    answer:'T ≈ 2.007 seconds', hint:'T = 2π√(L/g)' },
  { cardId:'s3', subject:'SCIENCE', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:"State Newton's Second Law as an equation.",
    answer:'F = ma', hint:'Force = mass × acceleration' },
  { cardId:'c1', subject:'CS', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:'Big-O complexity of binary search?',
    answer:'O(log n)', hint:'Each step eliminates half the remaining elements' },
  { cardId:'e1', subject:'ELA', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:'What is the difference between a simile and a metaphor?',
    answer:'Simile uses "like" or "as"; metaphor is a direct comparison',
    hint:'Simile: "She runs like the wind." Metaphor: "She is the wind."' },
  { cardId:'ss1', subject:'SOCIAL_STUDIES', reps:0, interval:1, easiness:2.5, nextReview:0, isDue:true,
    question:'Year Texas declared independence from Mexico?',
    answer:'1836', hint:'Battle of San Jacinto was also 1836' },
];

// ── §2  VOICE ENGINE ──────────────────────────────────────────────────────

declare global {
  interface Window {
    SpeechRecognition:       new () => SpeechRecognition;
    webkitSpeechRecognition: new () => SpeechRecognition;
  }
}

function speakText(text: string, rate = 0.9) {
  if (!window.speechSynthesis) return;
  window.speechSynthesis.cancel();
  const utt  = new SpeechSynthesisUtterance(text.slice(0, 280));
  utt.rate   = rate;
  utt.pitch  = 1.0;
  const voices = window.speechSynthesis.getVoices();
  const pref   = voices.find(v => v.name.includes('Samantha') || v.name.includes('Google US'));
  if (pref) utt.voice = pref;
  window.speechSynthesis.speak(utt);
}

// ── §3  STYLE SYSTEM ──────────────────────────────────────────────────────

const DS = {
  root: {
    width:'100%', height:'100%', background:'#030810', color:'#c8d8f0',
    fontFamily:"'SF Mono','Fira Code',monospace",
    display:'flex', flexDirection:'column' as const, overflow:'hidden',
  },
  topBar: {
    padding:'10px 20px', background:'#050d1a', borderBottom:'1px solid #0a2040',
    display:'flex', alignItems:'center', gap:12, flexShrink:0,
  },
  topTitle: { fontSize:13, color:'#c8a84e', fontWeight:700, letterSpacing:'0.08em' },
  topSub:   { fontSize:9, color:'#3a6080', letterSpacing:'0.15em', textTransform:'uppercase' as const },
  subjectBar: {
    display:'flex', gap:0, padding:'0 0', background:'#030810',
    borderBottom:'1px solid #0a2040', flexShrink:0, overflowX:'auto' as const,
  },
  subjectTab: (active: boolean, subject: Subject) => ({
    padding:'10px 16px', fontSize:10, cursor:'pointer',
    color: active ? SUBJECT_COLORS[subject] : '#3a5070',
    borderBottom:`2px solid ${active ? SUBJECT_COLORS[subject] : 'transparent'}`,
    letterSpacing:'0.1em', textTransform:'uppercase' as const,
    whiteSpace:'nowrap' as const, userSelect:'none' as const,
    transition:'all 0.15s', display:'flex', alignItems:'center', gap:6,
  }),
  toolBar: {
    display:'flex', gap:0, borderBottom:'1px solid #0a2040', flexShrink:0,
  },
  toolTab: (active: boolean, color: string) => ({
    padding:'8px 16px', fontSize:9, cursor:'pointer',
    color: active ? color : '#3a5070',
    background: active ? '#060e1c' : 'transparent',
    borderBottom:`1px solid ${active ? color + '60' : 'transparent'}`,
    letterSpacing:'0.12em', textTransform:'uppercase' as const,
    userSelect:'none' as const, borderRight:'1px solid #0a2040',
    transition:'all 0.1s',
  }),
  content: { flex:1, display:'flex', overflow:'hidden', minHeight:0 },
  chatPanel: {
    flex:1, display:'flex', flexDirection:'column' as const,
    borderRight:'1px solid #0a2040', overflow:'hidden', minWidth:0,
  },
  chatHeader: {
    padding:'12px 20px', borderBottom:'1px solid #0a2040',
    display:'flex', alignItems:'center', gap:10,
    background:'#040c18', flexShrink:0,
  },
  messages: {
    flex:1, overflowY:'auto' as const, padding:'16px 20px',
    display:'flex', flexDirection:'column' as const, gap:12, minHeight:0,
  },
  msgRow: (role: 'NOVA' | 'STUDENT') => ({
    display:'flex', justifyContent: role === 'STUDENT' ? 'flex-end' : 'flex-start',
  }),
  msgBubble: (role: 'NOVA' | 'STUDENT', color: string) => ({
    maxWidth:'85%', padding:'10px 14px',
    background: role === 'NOVA' ? '#050e1c' : '#082040',
    border:`1px solid ${role === 'NOVA' ? color + '30' : '#1050a0'}`,
    borderRadius: role === 'NOVA' ? '4px 16px 16px 16px' : '16px 4px 16px 16px',
    fontSize:12, lineHeight:1.8, color:'#c8d8f0', whiteSpace:'pre-wrap' as const,
  }),
  msgMeta: { fontSize:8, color:'#2a4060', marginTop:3 },
  typing: {
    display:'flex', gap:4, alignItems:'center', padding:'8px 14px',
    background:'#050e1c', border:'1px solid #0a2040',
    borderRadius:'4px 16px 16px 16px', width:'fit-content',
  },
  dot: (i: number) => ({
    width:6, height:6, borderRadius:'50%', background:'#4af',
    animationName:'novaDotPulse', animationDuration:'1.2s',
    animationDelay:`${i*0.2}s`, animationIterationCount:'infinite',
  }),
  inputRow: {
    padding:'12px 20px', borderTop:'1px solid #0a2040',
    display:'flex', gap:8, alignItems:'flex-end',
    background:'#040c18', flexShrink:0,
  },
  textarea: {
    flex:1, background:'#050d1a', border:'1px solid #0a2040',
    borderRadius:8, padding:'10px 14px', color:'#c8d8f0',
    fontFamily:'inherit', fontSize:12, resize:'none' as const,
    outline:'none', minHeight:44, maxHeight:100, overflowY:'auto' as const,
  },
  sendBtn: (color: string, disabled: boolean) => ({
    padding:'0 14px', height:40,
    background: disabled ? '#050d1a' : `${color}20`,
    border:`1px solid ${disabled ? '#0a2040' : color}`,
    borderRadius:8, color: disabled ? '#3a5070' : color,
    cursor: disabled ? 'not-allowed' : 'pointer', fontFamily:'inherit',
    fontSize:10, letterSpacing:'0.1em', textTransform:'uppercase' as const,
    transition:'all 0.15s',
  }),
  voiceBtn: (active: boolean) => ({
    width:40, height:40,
    background: active ? '#f8440030' : '#050d1a',
    border:`1px solid ${active ? '#f84' : '#0a2040'}`,
    borderRadius:8, color: active ? '#f84' : '#3a6080', cursor:'pointer',
    fontSize:16, display:'flex', alignItems:'center', justifyContent:'center',
    transition:'all 0.15s',
  }),
  sidePanel: {
    width:300, display:'flex', flexDirection:'column' as const, overflow:'hidden',
    borderLeft:'1px solid #0a2040',
  },
  sidePanelScroll: {
    flex:1, overflowY:'auto' as const, padding:14,
    display:'flex', flexDirection:'column' as const, gap:10,
  },
  card: {
    background:'#050d1a', border:'1px solid #0a2040', borderRadius:6,
    overflow:'hidden',
  },
  cardHead: (color: string) => ({
    padding:'7px 12px', borderBottom:'1px solid #0a2040',
    fontSize:8, color, letterSpacing:'0.15em', textTransform:'uppercase' as const,
    display:'flex', justifyContent:'space-between',
  }),
  cardBody: { padding:'10px 12px' },
  metricRow: {
    display:'flex', justifyContent:'space-between', padding:'4px 0',
    borderBottom:'1px solid #0a1828', fontSize:10,
  },
  metricLabel: { color:'#3a6080', fontSize:9, letterSpacing:'0.08em', textTransform:'uppercase' as const },
  metricValue: (color='#c8d8f0') => ({ color, fontWeight:700, fontSize:11 }),
  progressBar: {
    height:4, borderRadius:2, background:'#0a2040', overflow:'hidden', marginTop:3,
  },
  progressFill: (pct: number, color: string) => ({
    height:'100%', width:`${Math.min(100,pct)}%`, background:color,
    borderRadius:2, transition:'width 0.4s',
  }),
  conceptItem: {
    padding:'7px 12px', borderBottom:'1px solid #0a1828', cursor:'pointer',
    fontSize:10, transition:'background 0.1s',
  },
  conceptDepth: (d: number) => ({
    display:'inline-block', width:d*4, height:4, borderRadius:2,
    background:'#c8a84e', marginLeft:4, verticalAlign:'middle',
  }),
  fullArea: {
    flex:1, overflowY:'auto' as const, padding:20,
    display:'flex', flexDirection:'column' as const, gap:14,
  },
  quizCard: {
    background:'#050d1a', border:'1px solid #0a2040', borderRadius:8,
    padding:20, display:'flex', flexDirection:'column' as const, gap:12,
  },
  qualBtn: (q: number, selected: boolean) => {
    const colors = ['#f44','#f66','#fa0','#fa0','#4f4','#4f4'];
    return {
      padding:'8px 12px',
      background: selected ? `${colors[q]}25` : '#030810',
      border:`1px solid ${selected ? colors[q] : '#0a2040'}`,
      borderRadius:6, color: selected ? colors[q] : '#3a5070',
      cursor:'pointer', fontSize:9, fontFamily:'inherit',
      letterSpacing:'0.1em', textTransform:'uppercase' as const,
      transition:'all 0.15s',
    };
  },
  input: {
    width:'100%', background:'#030810', border:'1px solid #0a2040',
    borderRadius:4, padding:'6px 10px', color:'#c8d8f0',
    fontFamily:'inherit', fontSize:11, outline:'none', boxSizing:'border-box' as const,
  },
  btn: (color='#4af') => ({
    padding:'8px 16px', background:`${color}15`, border:`1px solid ${color}`,
    borderRadius:6, color, cursor:'pointer', fontFamily:'inherit', fontSize:10,
    letterSpacing:'0.1em', textTransform:'uppercase' as const, transition:'all 0.15s',
  }),
  statusPill: (ok: boolean) => ({
    fontSize:8, padding:'2px 8px',
    background: ok ? '#4f420' : '#f4420',
    border:`1px solid ${ok ? '#4f4' : '#f44'}`,
    borderRadius:3, color: ok ? '#4f4' : '#f44',
    letterSpacing:'0.1em',
  }),
};

// Inject keyframes
let _kfInjected = false;
function injectKf() {
  if (_kfInjected) return;
  const s = document.createElement('style');
  s.textContent = `
    @keyframes novaDotPulse {
      0%,80%,100%{transform:scale(0.6);opacity:0.4;}
      40%{transform:scale(1.2);opacity:1;}
    }
    @keyframes novaFadeIn {
      from{opacity:0;transform:translateY(4px);}
      to{opacity:1;transform:translateY(0);}
    }
    .nova-msg{animation:novaFadeIn 0.2s ease;}
    .nova-concept-item:hover{background:#0a1828!important;}
  `;
  document.head.appendChild(s);
  _kfInjected = true;
}

// ── §4  MAIN COMPONENT ────────────────────────────────────────────────────

export function DallasISDApp() {
  injectKf();

  // ── Backend state
  const [mathEngine,   setMathEngine]   = useState<MathEngine | null>(null);
  const [concepts,     setConcepts]     = useState<TEKSConceptSummary[]>([]);
  const [grants,       setGrants]       = useState<GrantEntry[]>([]);
  const [classStatus,  setClassStatus]  = useState<ClassroomStatus | null>(null);
  const [backendOk,    setBackendOk]    = useState(false);
  const [backendMsg,   setBackendMsg]   = useState('Connecting to backends...');

  // ── Student session
  const [sessionId,    setSessionId]    = useState('');
  const [studentName,  setStudentName]  = useState('');
  const [showNamePrompt, setShowNamePrompt] = useState(true);
  const [progress,     setProgress]     = useState({ math:0, science:0, social_studies:0, ela:0, cs:0, overall:0 });

  // ── UI state
  const [subject,  setSubject]  = useState<Subject>('HOME');
  const [tool,     setTool]     = useState<ToolTab>('TUTOR');
  const [messages, setMessages] = useState<ChatMessage[]>([]);
  const [input,    setInput]    = useState('');
  const [typing,   setTyping]   = useState(false);
  const [listening,setListening]= useState(false);
  const [voiceOn,  setVoiceOn]  = useState(true);
  const [voiceSupport, setVoiceSupport] = useState(false);

  // ── Concepts panel
  const [selectedConcept, setSelectedConcept]   = useState<string | null>(null);
  const [conceptContent,  setConceptContent]    = useState<ConceptContent | null>(null);
  const [loadingConcept,  setLoadingConcept]    = useState(false);

  // ── Quiz state (local cards, synced to nova_student backend)
  const [quizCards,   setQuizCards]    = useState<LocalQuizCard[]>(QUIZ_BANK);
  const [quizIdx,     setQuizIdx]      = useState(0);
  const [showAnswer,  setShowAnswer]   = useState(false);
  const [showHint,    setShowHint]     = useState(false);
  const [studentAns,  setStudentAns]   = useState('');
  const [quizQuality, setQuizQuality]  = useState<number | null>(null);
  const [quizStreak,  setQuizStreak]   = useState(0);
  const [quizSession, setQuizSession]  = useState(false);

  const messagesEndRef = useRef<HTMLDivElement>(null);
  const recognitionRef = useRef<SpeechRecognition | null>(null);

  const color = SUBJECT_COLORS[subject];

  // ── §4.1  INIT — connect to both backends
  useEffect(() => {
    injectKf();
    setVoiceSupport(!!(window.SpeechRecognition || window.webkitSpeechRecognition));

    const init = async () => {
      try {
        // Connect to dallas_isd canister
        const disd   = getDallasISDCanisterActor();
        const status = await disd.getClassroomStatus();
        setClassStatus(status);

        const eng = await disd.getMathEngine();
        setMathEngine(eng);

        const gs = await disd.getGrantManifest();
        setGrants(gs);

        setBackendOk(true);
        setBackendMsg(`dallas_isd ✓ · ${status.conceptCount} concepts on-chain · φ=${eng.phi.toFixed(4)}`);
      } catch (e) {
        setBackendMsg(`Backend unavailable (${e instanceof Error ? e.message : 'error'}) — local mode`);
        // Still functional with local constants
        setBackendOk(false);
      }
    };
    init();
  }, []);

  // Load concepts when subject changes
  useEffect(() => {
    if (subject === 'HOME') { setConcepts([]); return; }
    const load = async () => {
      try {
        const disd = getDallasISDCanisterActor();
        const list = await disd.getAllConcepts(subject);
        setConcepts(list);
      } catch (_) { setConcepts([]); }
    };
    load();
  }, [subject]);

  // Scroll to bottom
  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior:'smooth' });
  }, [messages, typing]);

  // ── §4.2  Start student session on name submit
  const startSession = async (name: string) => {
    setStudentName(name);
    setShowNamePrompt(false);
    try {
      const student = getNovaStudentActor();
      const result  = await student.startSession(name);
      setSessionId(result.sessionId);
      // Load existing progress
      const prog = await student.getAllProgress(result.sessionId);
      setProgress({
        math: Number(prog.math), science: Number(prog.science),
        social_studies: Number(prog.social_studies),
        ela: Number(prog.ela), cs: Number(prog.cs),
        overall: Number(prog.overall),
      });
    } catch (_) {
      // Generate local session ID if backend unavailable
      setSessionId(`LOCAL-${Date.now()}`);
    }
    // Greeting
    setTimeout(() => {
      addNova(`Hey ${name}! I'm NOVA — your AI tutor. I'm connected to the Dallas ISD curriculum backend — every concept, formula, and lesson plan is stored on-chain. Pick a subject and ask me anything!`);
    }, 300);
  };

  // ── §4.3  AI Tutoring — calls nova_student → swarm_brain
  const addNova = (text: string, meta?: Partial<ChatMessage>) => {
    setMessages(prev => [...prev, {
      id: Date.now() + Math.random().toString(),
      role:'NOVA', text, subject, timestamp: Date.now(), ...meta,
    }]);
    if (voiceOn) speakText(text);
  };

  const sendMessage = useCallback(async (text: string) => {
    if (!text.trim()) return;
    setInput('');
    setMessages(prev => [...prev, {
      id: Date.now() + Math.random().toString(),
      role:'STUDENT', text, subject, timestamp: Date.now(),
    }]);
    setTyping(true);

    try {
      if (sessionId) {
        // Call nova_student backend → swarm_brain AI
        const student = getNovaStudentActor();
        const result: AskTutorResult = await student.askTutor(sessionId, subject, text);

        setTyping(false);

        if (result.ok) {
          addNova(result.response, {
            teksRef:    result.teksRef,
            confidence: result.confidence,
            mathDepth:  Number(result.mathDepth),
          });
          // Update progress from backend
          const prog = await student.getAllProgress(sessionId);
          setProgress({
            math: Number(prog.math), science: Number(prog.science),
            social_studies: Number(prog.social_studies),
            ela: Number(prog.ela), cs: Number(prog.cs),
            overall: Number(prog.overall),
          });
          // Record engagement in dallas_isd backend
          try {
            const disd = getDallasISDCanisterActor();
            await disd.recordEngagement('DALLAS-ISD-STUDENT', studentName, subject);
          } catch (_) {}
        } else {
          addNova(`Backend response: ${result.response}`);
        }
      } else {
        // No session — fallback
        await new Promise(r => setTimeout(r, 600));
        setTyping(false);
        addNova(`Ask your question in context of ${subject.replace('_',' ')}. To get full AI responses backed by swarm_brain intelligence, start with your name above.`);
      }
    } catch (e) {
      setTyping(false);
      addNova(`nova_student canister: ${e instanceof Error ? e.message : 'error'}. Configure VITE_NOVA_STUDENT_CANISTER_ID for production AI.`);
    }
  }, [sessionId, subject, voiceOn, studentName]);

  // ── §4.4  Voice input
  const toggleListen = () => {
    if (!voiceSupport) return;
    if (listening) { recognitionRef.current?.stop(); setListening(false); return; }
    const SR = window.SpeechRecognition || window.webkitSpeechRecognition;
    const rec = new SR();
    rec.lang = 'en-US';
    rec.onresult = e => {
      setInput(Array.from(e.results).map(r => r[0].transcript).join(' '));
      setListening(false);
    };
    rec.onerror = () => setListening(false);
    rec.onend   = () => setListening(false);
    rec.start();
    recognitionRef.current = rec;
    setListening(true);
  };

  // ── §4.5  Load concept content from dallas_isd backend
  const loadConceptContent = async (conceptId: string) => {
    setSelectedConcept(conceptId);
    setConceptContent(null);
    setLoadingConcept(true);
    try {
      const disd    = getDallasISDCanisterActor();
      const content = await disd.getConceptContent(conceptId);
      setConceptContent(content?.[0] ?? null);
    } catch (_) { setConceptContent(null); }
    setLoadingConcept(false);
  };

  // ── §4.6  SM-2 Quiz — syncs to nova_student backend
  const dueCards = quizCards.filter(c =>
    subject === 'HOME' ? true : c.subject === subject
  ).filter(c => c.isDue || c.reps === 0);

  const currentCard = dueCards[quizIdx % Math.max(dueCards.length, 1)];

  const handleQuizQuality = async (q: number) => {
    setQuizQuality(q);
    if (q >= 3) setQuizStreak(s => s + 1);
    else         setQuizStreak(0);

    // Sync SM-2 to nova_student backend
    if (sessionId && currentCard) {
      try {
        const student = getNovaStudentActor();
        await student.updateQuizCard(sessionId, currentCard.cardId, BigInt(q));
      } catch (_) {}
    }

    // Update local card state (SM-2 algorithm)
    setQuizCards(prev => prev.map(c => {
      if (c.cardId !== currentCard?.cardId) return c;
      let { reps, easiness, interval } = c;
      if (q < 3) { reps=0; interval=1; }
      else {
        if (reps===0) interval=1; else if (reps===1) interval=6;
        else interval=Math.round(interval*easiness);
        reps++;
      }
      easiness = Math.max(1.3, easiness + 0.1 - (5-q)*(0.08+(5-q)*0.02));
      return { ...c, reps, interval, easiness, nextReview: Date.now() + interval*86400000, isDue: false };
    }));
  };

  const nextQuizCard = () => {
    setShowAnswer(false); setShowHint(false);
    setQuizQuality(null); setStudentAns('');
    setQuizIdx(i => i + 1);
  };

  // ── §5  RENDERS ───────────────────────────────────────────────────────────

  // Name prompt overlay
  if (showNamePrompt) {
    return (
      <div style={{ ...DS.root, alignItems:'center', justifyContent:'center' }}>
        <div style={{ textAlign:'center', maxWidth:400, padding:32 }}>
          <div style={{ fontSize:32, marginBottom:16 }}>⊕</div>
          <div style={{ fontSize:16, color:'#c8a84e', fontWeight:700, marginBottom:8 }}>
            NOVA × Dallas ISD AI Classroom
          </div>
          <div style={{ fontSize:10, color:'#3a6080', marginBottom:24, letterSpacing:'0.1em' }}>
            TEKS-ALIGNED · FREE · POWERED BY NOVA ORGANISM
          </div>
          <input
            style={{ ...DS.input, marginBottom:12, textAlign:'center', fontSize:13 }}
            placeholder="Enter your first name to start..."
            autoFocus
            onKeyDown={e => { if (e.key === 'Enter' && e.currentTarget.value.trim()) startSession(e.currentTarget.value.trim()); }}
          />
          <button
            style={{ ...DS.btn('#c8a84e'), width:'100%', padding:'12px 0', fontSize:12 }}
            onClick={e => {
              const inp = e.currentTarget.previousElementSibling as HTMLInputElement;
              if (inp?.value.trim()) startSession(inp.value.trim());
            }}
          >
            Start Learning →
          </button>
          <div style={{ marginTop:16, fontSize:8, color:'#2a4060' }}>
            Powered by nova_student + dallas_isd + swarm_brain canisters on ICP
          </div>
        </div>
      </div>
    );
  }

  const SUBJECTS: Subject[] = ['HOME','MATH','SCIENCE','SOCIAL_STUDIES','ELA','CS'];

  // ── Topic suggestions (used in side panel and to guide students)
  const TOPIC_SUGGESTIONS: Record<Subject, string[]> = {
    HOME: ['Ask me anything!','How does ICP work?','What is the NOVA organism?'],
    MATH: ['Explain Fibonacci','How does the golden ratio work?','Derivative of x³?','What is the logistic map?','Kuramoto oscillators','How does a pendulum work?'],
    SCIENCE: ['Explain photosynthesis','Newton\'s laws','What is Schumann resonance?','How does DNA replicate?','Wave speed formula','Atomic structure'],
    SOCIAL_STUDIES: ['Texas Revolution','US Constitution branches','Civil Rights Movement','Supply and demand','Texas geography'],
    ELA: ['How to write a thesis?','What is a metaphor?','Analyze Romeo and Juliet','Essay structure','Figurative language devices'],
    CS: ['Explain algorithms','What is Big-O?','Python for loops','Boolean logic','How does blockchain work?'],
  };

  // ── Tutor tab
  const renderTutor = () => (
    <div style={DS.content}>
      {/* Chat panel */}
      <div style={DS.chatPanel}>
        <div style={DS.chatHeader}>
          <div style={{
            width:32, height:32, borderRadius:'50%',
            background:`linear-gradient(135deg, #0a3060, ${color}40)`,
            border:`2px solid ${color}`,
            display:'flex', alignItems:'center', justifyContent:'center',
            fontSize:14, color, flexShrink:0,
          }}>{SUBJECT_ICONS[subject]}</div>
          <div>
            <div style={{ fontSize:12, color, fontWeight:700 }}>NOVA AI Tutor</div>
            <div style={{ fontSize:9, color:'#3a6080', letterSpacing:'0.12em', textTransform:'uppercase' }}>
              {subject === 'HOME' ? 'All Subjects' : subject.replace('_',' ')} · TEKS · swarm_brain powered
            </div>
          </div>
          <div style={{ marginLeft:'auto', display:'flex', gap:8, alignItems:'center' }}>
            <div style={DS.statusPill(backendOk)}>
              {backendOk ? '● LIVE' : '● LOCAL'}
            </div>
            {voiceSupport && (
              <button style={DS.voiceBtn(listening)} onClick={toggleListen} title="Voice input">🎤</button>
            )}
          </div>
        </div>

        <div style={DS.messages}>
          {messages.map(m => (
            <div key={m.id} className="nova-msg" style={DS.msgRow(m.role)}>
              <div>
                <div style={DS.msgBubble(m.role, color)}>{m.text}</div>
                {m.teksRef && (
                  <div style={{ ...DS.msgMeta, color:'#4af60', maxWidth:'85%' }}>
                    📋 {m.teksRef}
                    {m.confidence !== undefined && ` · confidence: ${(m.confidence*100).toFixed(0)}%`}
                    {m.mathDepth !== undefined && ` · depth: ${m.mathDepth}`}
                  </div>
                )}
              </div>
            </div>
          ))}
          {typing && (
            <div style={DS.msgRow('NOVA')}>
              <div style={{ ...DS.typing, border:`1px solid ${color}30` }}>
                {[0,1,2].map(i => <div key={i} style={DS.dot(i)} />)}
                <span style={{ fontSize:9, color:'#3a5070', marginLeft:4 }}>swarm_brain...</span>
              </div>
            </div>
          )}
          <div ref={messagesEndRef} />
        </div>

        <div style={DS.inputRow}>
          <textarea
            style={{ ...DS.textarea, borderColor: listening ? '#f84' : '#0a2040' }}
            placeholder={listening ? '🎤 Listening...' : 'Ask NOVA anything...'}
            value={input}
            onChange={e => setInput(e.target.value)}
            onKeyDown={e => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendMessage(input); }}}
            rows={1}
          />
          {voiceSupport && (
            <button style={DS.voiceBtn(listening)} onClick={toggleListen}>🎤</button>
          )}
          <button style={DS.sendBtn(color, !input.trim())}
            onClick={() => sendMessage(input)} disabled={!input.trim()}>
            Ask →
          </button>
        </div>
      </div>

      {/* Side panel — topics, progress, backend status */}
      <div style={DS.sidePanel}>
        <div style={DS.sidePanelScroll}>
          {/* Topics */}
          <div style={DS.card}>
            <div style={DS.cardHead(color)}>
              <span>Topics — click to ask</span>
            </div>
            {TOPIC_SUGGESTIONS[subject].map(t => (
              <div key={t} className="nova-concept-item" style={DS.conceptItem}
                onClick={() => { setInput(t); }}>
                → {t}
              </div>
            ))}
          </div>

          {/* Progress (from nova_student backend) */}
          <div style={DS.card}>
            <div style={DS.cardHead('#4af')}>
              <span>Your Progress</span>
              <span style={{ color:'#3a5070', fontSize:7 }}>nova_student</span>
            </div>
            <div style={DS.cardBody}>
              <div style={{ ...DS.metricRow, border:'none', marginBottom:2 }}>
                <span style={{ fontSize:9, color:'#3a5070' }}>Student: {studentName}</span>
              </div>
              {([
                ['MATH','Math',progress.math],
                ['SCIENCE','Science',progress.science],
                ['SOCIAL_STUDIES','Soc. Studies',progress.social_studies],
                ['ELA','ELA',progress.ela],
                ['CS','CS',progress.cs],
              ] as [Subject, string, number][]).map(([s, label, val]) => (
                <div key={s} style={{ marginBottom:6 }}>
                  <div style={{ display:'flex', justifyContent:'space-between', marginBottom:2 }}>
                    <span style={{ fontSize:9, color:SUBJECT_COLORS[s] }}>{label}</span>
                    <span style={{ fontSize:9, color:'#3a5070' }}>{val}%</span>
                  </div>
                  <div style={DS.progressBar}>
                    <div style={DS.progressFill(val, SUBJECT_COLORS[s])} />
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Backend status */}
          <div style={DS.card}>
            <div style={DS.cardHead('#3a6080')}>Backend Status</div>
            <div style={DS.cardBody}>
              {[
                ['dallas_isd', backendOk, `${classStatus?.conceptCount ?? 0} concepts`],
                ['nova_student', !!sessionId, sessionId.slice(0,16) || 'none'],
                ['swarm_brain', backendOk, 'via nova_student'],
                ['nova_stream', backendOk, 'STUDENT_ASK events'],
              ].map(([name, ok, detail]) => (
                <div key={String(name)} style={{ ...DS.metricRow, padding:'5px 0' }}>
                  <div style={{ display:'flex', gap:6, alignItems:'center' }}>
                    <div style={{ width:6, height:6, borderRadius:'50%',
                      background: ok ? '#4f4' : '#f44', boxShadow: ok ? '0 0 4px #4f4' : undefined }} />
                    <span style={{ fontSize:9, color:'#8090a8' }}>{String(name)}</span>
                  </div>
                  <span style={{ fontSize:8, color:'#3a5070', maxWidth:120, textAlign:'right',
                    overflow:'hidden', textOverflow:'ellipsis', whiteSpace:'nowrap' }}>
                    {String(detail)}
                  </span>
                </div>
              ))}
              {mathEngine && (
                <div style={{ marginTop:8, fontSize:8, color:'#4a6080', lineHeight:1.7 }}>
                  φ={mathEngine.phi.toFixed(10)}<br/>
                  Feigenbaum={mathEngine.feigenbaum.toFixed(6)}<br/>
                  Heartbeat={String(mathEngine.heartbeat)}ms<br/>
                  Schumann={mathEngine.schumann}Hz
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );

  // ── Concepts tab — curriculum from dallas_isd backend
  const renderConcepts = () => (
    <div style={DS.content}>
      {/* Concept list */}
      <div style={{ width:280, borderRight:'1px solid #0a2040', overflowY:'auto', flexShrink:0 }}>
        <div style={{ padding:'10px 12px', borderBottom:'1px solid #0a2040',
          fontSize:8, color:'#3a6080', letterSpacing:'0.15em' }}>
          {concepts.length} CONCEPTS — dallas_isd CANISTER
        </div>
        {concepts.length === 0 && subject !== 'HOME' && (
          <div style={{ padding:16, fontSize:10, color:'#3a5070', textAlign:'center' }}>
            {backendOk ? 'Loading from dallas_isd canister...' :
              'Bootstrap dallas_isd canister to load TEKS curriculum on-chain.'}
          </div>
        )}
        {concepts.map(c => (
          <div key={c.conceptId} className="nova-concept-item"
            style={{ ...DS.conceptItem, background: selectedConcept===c.conceptId ? '#0a1828' : 'transparent' }}
            onClick={() => loadConceptContent(c.conceptId)}>
            <div style={{ fontWeight: selectedConcept===c.conceptId ? 700 : 400, color }}>
              {c.title}
            </div>
            <div style={{ display:'flex', justifyContent:'space-between', marginTop:3 }}>
              <span style={{ fontSize:8, color:'#3a5070' }}>{c.teksGrade}</span>
              <span style={{ display:'flex', gap:2 }}>
                {Array.from({ length: Number(c.mathDepth) }, (_, i) => (
                  <div key={i} style={{ width:4, height:4, borderRadius:1, background:color }} />
                ))}
              </span>
            </div>
          </div>
        ))}
      </div>

      {/* Concept content from backend */}
      <div style={{ flex:1, overflowY:'auto', padding:20 }}>
        {!selectedConcept && (
          <div style={{ textAlign:'center', color:'#3a5070', fontSize:11, marginTop:40 }}>
            <div style={{ fontSize:32, marginBottom:12 }}>📚</div>
            <div>Select a concept from the list.</div>
            <div style={{ marginTop:8, fontSize:9, color:'#2a4060' }}>
              Content loaded from dallas_isd canister — on-chain TEKS curriculum.
            </div>
          </div>
        )}
        {loadingConcept && (
          <div style={{ textAlign:'center', color:'#3a5070', marginTop:40 }}>
            Loading from dallas_isd canister...
          </div>
        )}
        {selectedConcept && conceptContent && (
          <div style={{ display:'flex', flexDirection:'column', gap:14 }}>
            <div style={DS.card}>
              <div style={DS.cardHead('#4af')}>
                <span>Concept Explanation — dallas_isd canister</span>
                <span style={{ color:'#3a5070', fontSize:7 }}>on-chain content</span>
              </div>
              <div style={{ ...DS.cardBody, fontSize:11, lineHeight:1.8, whiteSpace:'pre-wrap', color:'#c8d8f0' }}>
                {conceptContent.text || 'No content stored. Run bootstrapConceptContent() on the dallas_isd canister.'}
              </div>
            </div>
            {conceptContent.formula && (
              <div style={DS.card}>
                <div style={DS.cardHead('#c8a84e')}>Mathematical Formula</div>
                <div style={{ background:'#020810', padding:'12px 16px', fontSize:12,
                  color:'#c8a84e', fontFamily:'monospace', lineHeight:1.9, whiteSpace:'pre-wrap' }}>
                  {conceptContent.formula}
                </div>
              </div>
            )}
            {conceptContent.physics && (
              <div style={DS.card}>
                <div style={DS.cardHead('#4ecdc4')}>Physics Connection</div>
                <div style={{ ...DS.cardBody, fontSize:11, lineHeight:1.8, color:'#9090b8', whiteSpace:'pre-wrap' }}>
                  {conceptContent.physics}
                </div>
              </div>
            )}
            <button style={DS.btn(color)} onClick={() => {
              setTool('TUTOR');
              setInput(`Explain the concept "${selectedConcept}" in detail for my grade level`);
            }}>
              💬 Ask NOVA to Explain This
            </button>
          </div>
        )}
        {selectedConcept && !conceptContent && !loadingConcept && (
          <div style={{ padding:16, fontSize:10, color:'#3a5070' }}>
            No content stored for this concept yet. Run bootstrapConceptContent() on the dallas_isd canister.
          </div>
        )}
      </div>
    </div>
  );

  // ── Quiz tab — SM-2 synced to nova_student backend
  const renderQuiz = () => {
    if (dueCards.length === 0) return (
      <div style={{ ...DS.fullArea, alignItems:'center', justifyContent:'center', textAlign:'center' }}>
        <div style={{ fontSize:32, marginBottom:12 }}>✅</div>
        <div style={{ color:'#4f4', fontSize:14, marginBottom:8 }}>All cards reviewed!</div>
        <div style={{ fontSize:10, color:'#8090a8' }}>
          SM-2 algorithm schedules your next review optimally.<br/>
          Review state synced to nova_student canister — your progress is permanent on ICP.
        </div>
      </div>
    );

    return (
      <div style={DS.fullArea}>
        {/* Progress bar */}
        <div style={{ display:'flex', gap:12, alignItems:'center' }}>
          <div style={{ flex:1, ...DS.progressBar }}>
            <div style={DS.progressFill((quizIdx/Math.max(dueCards.length,1))*100, color)} />
          </div>
          <span style={{ fontSize:9, color:'#3a5070' }}>{quizIdx}/{dueCards.length} due</span>
          <span style={{ fontSize:9, color:'#c8a84e' }}>🔥 {quizStreak}</span>
          <span style={{ fontSize:8, color:'#2a4060' }}>nova_student SM-2</span>
        </div>

        {currentCard && (
          <div style={DS.quizCard}>
            <div style={{ display:'flex', gap:8, alignItems:'center' }}>
              <span style={{
                fontSize:8, padding:'2px 8px',
                background:`${SUBJECT_COLORS[currentCard.subject]}15`,
                border:`1px solid ${SUBJECT_COLORS[currentCard.subject]}40`,
                borderRadius:3, color:SUBJECT_COLORS[currentCard.subject],
                letterSpacing:'0.12em',
              }}>{currentCard.subject}</span>
              <span style={{ fontSize:8, color:'#3a5070' }}>
                Interval: {currentCard.interval}d · EF: {currentCard.easiness.toFixed(2)} · Reps: {currentCard.reps}
              </span>
            </div>

            <div style={{ fontSize:13, color:'#e0e8f8', lineHeight:1.6, fontWeight:600 }}>
              {currentCard.question}
            </div>

            {showHint && (
              <div style={{ fontSize:10, color:'#c8a84e', background:'#0a1828', padding:'8px 12px', borderRadius:4 }}>
                💡 {currentCard.hint}
              </div>
            )}

            {!showAnswer && (
              <div style={{ display:'flex', gap:8 }}>
                <input style={{ ...DS.input, flex:1 }} placeholder="Type your answer..."
                  value={studentAns} onChange={e => setStudentAns(e.target.value)}
                  onKeyDown={e => { if (e.key === 'Enter') setShowAnswer(true); }} />
                {!showHint && <button style={DS.btn('#fa0')} onClick={() => setShowHint(true)}>Hint</button>}
                <button style={DS.btn(color)} onClick={() => setShowAnswer(true)}>Check</button>
              </div>
            )}

            {showAnswer && (
              <>
                <div style={{ background:'#020d18', border:'1px solid #0a2040', borderRadius:6, padding:'10px 14px' }}>
                  <div style={{ fontSize:9, color:'#3a6080', marginBottom:4, letterSpacing:'0.12em' }}>CORRECT ANSWER</div>
                  <div style={{ fontSize:12, color:'#4f4', lineHeight:1.7, whiteSpace:'pre-wrap' }}>
                    {currentCard.answer}
                  </div>
                  {studentAns && (
                    <div style={{ marginTop:6, fontSize:9, color:'#8090a8' }}>
                      Your answer: <span style={{ color:'#c8d8f0' }}>{studentAns}</span>
                    </div>
                  )}
                </div>

                {quizQuality === null ? (
                  <div>
                    <div style={{ fontSize:9, color:'#3a6080', marginBottom:8, letterSpacing:'0.1em' }}>
                      HOW WELL DID YOU KNOW IT? — saved to nova_student canister
                    </div>
                    <div style={{ display:'flex', gap:6, flexWrap:'wrap' as const }}>
                      {[0,1,2,3,4,5].map(q => (
                        <button key={q} style={DS.qualBtn(q, false)} onClick={() => handleQuizQuality(q)}>
                          {['Again','Hard','Okay','Good','Easy','Perfect'][q]}
                        </button>
                      ))}
                    </div>
                  </div>
                ) : (
                  <div style={{ display:'flex', alignItems:'center', gap:12 }}>
                    <div style={{ fontSize:10, color:'#4f4' }}>
                      Synced to nova_student · Next review: {quizQuality < 3 ? 'Tomorrow' : `${currentCard.interval}d`}
                    </div>
                    <button style={{ ...DS.btn(color), marginLeft:'auto' }} onClick={nextQuizCard}>
                      Next Card →
                    </button>
                  </div>
                )}
              </>
            )}
          </div>
        )}

        <div style={DS.card}>
          <div style={DS.cardHead('#3a6080')}>All Cards — SM-2 Schedule (nova_student canister)</div>
          {quizCards.filter(c => subject==='HOME' || c.subject===subject).map(c => (
            <div key={c.cardId} style={{ ...DS.metricRow, padding:'5px 12px' }}>
              <span style={{ fontSize:9, color:'#8090a8', flex:1 }}>
                {c.question.slice(0,50)}{c.question.length>50?'…':''}
              </span>
              <span style={{ fontSize:9, color: c.isDue||c.reps===0 ? '#f44' : '#4f4', marginLeft:8 }}>
                {c.isDue||c.reps===0 ? 'DUE' : `+${c.interval}d`}
              </span>
            </div>
          ))}
        </div>
      </div>
    );
  };

  // ── Grants tab — from dallas_isd canister
  const renderGrants = () => (
    <div style={DS.fullArea}>
      <div style={{ fontSize:10, color:'#8090a8', lineHeight:1.8, padding:'12px 16px',
        background:'#050d1a', border:'1px solid #0a2040', borderRadius:6 }}>
        Grant data loaded from the dallas_isd sovereign canister on ICP.
        All grants are TEKS-aligned. NOVA Digital Classroom qualifies for all programs below.
        Permanent on-chain — cannot be altered.
      </div>
      {grants.length === 0 && (
        <div style={{ textAlign:'center', color:'#3a5070', fontSize:10, marginTop:20 }}>
          {backendOk ? 'Run bootstrapGrants() on the dallas_isd canister to load grant data.' :
            'Backend unavailable — grant data stored in dallas_isd canister on ICP.'}
        </div>
      )}
      {grants.map(g => (
        <div key={g.name} style={DS.card}>
          <div style={{ ...DS.cardHead('#c8a84e'), display:'flex', justifyContent:'space-between' }}>
            <span>{g.name}</span>
            <span style={{ color:'#4f4' }}>{g.amount}</span>
          </div>
          <div style={DS.cardBody}>
            {[['Agency', g.agency],['Eligible', g.eligible],['Use', g.use_]].map(([l,v]) => (
              <div key={l} style={DS.metricRow}>
                <span style={DS.metricLabel}>{l}</span>
                <span style={{ fontSize:10, color:'#c8d8f0', textAlign:'right', maxWidth:'70%' }}>{v}</span>
              </div>
            ))}
            <div style={{ marginTop:8, fontSize:9, color:'#4af', padding:'6px 8px',
              background:'#0a2040', borderRadius:4 }}>
              ✓ NOVA: {g.align}
            </div>
          </div>
        </div>
      ))}
    </div>
  );

  return (
    <div style={DS.root}>
      {/* Top bar */}
      <div style={DS.topBar}>
        <div>
          <div style={DS.topTitle}>NOVA × Dallas ISD — AI Classroom</div>
          <div style={DS.topSub}>
            dallas_isd · nova_student · swarm_brain · Free · TEKS · ICP
          </div>
        </div>
        <div style={{ marginLeft:'auto', display:'flex', gap:8, alignItems:'center' }}>
          <div style={DS.statusPill(backendOk)}>{backendOk ? '● BACKENDS LIVE' : '● LOCAL MODE'}</div>
          {voiceSupport && (
            <button onClick={() => setVoiceOn(!voiceOn)} style={{
              padding:'4px 10px', fontSize:8, fontFamily:'inherit',
              background: voiceOn ? '#4af20' : '#050d1a',
              border:`1px solid ${voiceOn ? '#4af' : '#0a2040'}`,
              borderRadius:4, color: voiceOn ? '#4af' : '#3a6080', cursor:'pointer',
              letterSpacing:'0.1em',
            }}>
              {voiceOn ? '🔊 VOICE ON' : '🔇 VOICE OFF'}
            </button>
          )}
          <div style={{ fontSize:8, color:'#2a4060' }}>BUILD №43 · {studentName}</div>
        </div>
      </div>

      {/* Subject bar */}
      <div style={DS.subjectBar}>
        {SUBJECTS.map(s => (
          <button key={s} style={DS.subjectTab(subject===s, s)}
            onClick={() => { setSubject(s); setMessages([]); setTool('TUTOR'); setSelectedConcept(null); }}>
            <span>{SUBJECT_ICONS[s]}</span>
            {s==='SOCIAL_STUDIES' ? 'SOC STUDIES' : s}
          </button>
        ))}
      </div>

      {/* Tool bar */}
      <div style={DS.toolBar}>
        {(['TUTOR','CONCEPTS','QUIZ','GRANTS'] as ToolTab[]).map(t => (
          <button key={t} style={DS.toolTab(tool===t, color)} onClick={() => setTool(t)}>
            {t==='TUTOR' ? '💬 Tutor' : t==='CONCEPTS' ? '📚 Concepts' :
             t==='QUIZ'  ? '📝 Quiz'  : '📋 Grants'}
          </button>
        ))}
      </div>

      {/* Tiny backend status strip */}
      <div style={{ padding:'3px 16px', background:'#020810', borderBottom:'1px solid #0a1828',
        fontSize:8, color:'#2a4060', flexShrink:0 }}>
        {backendMsg}
      </div>

      {/* Content */}
      {tool === 'TUTOR'    && renderTutor()}
      {tool === 'CONCEPTS' && renderConcepts()}
      {tool === 'QUIZ'     && renderQuiz()}
      {tool === 'GRANTS'   && renderGrants()}
    </div>
  );
}

export default DallasISDApp;
