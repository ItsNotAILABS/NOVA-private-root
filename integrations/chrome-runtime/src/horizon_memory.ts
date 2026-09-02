export interface HorizonEvent {
  id: string;
  kind: 'goal' | 'observation' | 'action' | 'result' | 'error' | 'decision' | 'receipt';
  text: string;
  salience: number;
  unresolved?: boolean;
  timestamp: number;
  embedding?: number[];
}

export interface HorizonState {
  activeGoals: HorizonEvent[];
  unresolved: HorizonEvent[];
  recent: HorizonEvent[];
  compressedSummary: string;
  eventCount: number;
}

export class HorizonMemory {
  private readonly events: HorizonEvent[] = [];
  constructor(private readonly recentLimit = 64, private readonly unresolvedLimit = 64) {}

  append(event: HorizonEvent): void {
    this.events.push({ ...event, embedding: event.embedding ? [...event.embedding] : undefined });
    if (this.events.length > 4096) this.compact();
  }

  resolve(id: string): void {
    const event = this.events.find((item) => item.id === id);
    if (event) event.unresolved = false;
  }

  state(): HorizonState {
    const recent = this.events.slice(-this.recentLimit);
    const activeGoals = this.events.filter((event) => event.kind === 'goal' && event.unresolved !== false).slice(-16);
    const unresolved = this.events.filter((event) => event.unresolved).sort((a,b) => b.salience - a.salience || b.timestamp - a.timestamp).slice(0,this.unresolvedLimit);
    const anchors = [...activeGoals, ...unresolved].filter((event, index, all) => all.findIndex((candidate) => candidate.id === event.id) === index);
    const compressedSummary = anchors.map((event) => `[${event.kind}:${event.id}] ${event.text}`).join('\n');
    return { activeGoals, unresolved, recent, compressedSummary, eventCount: this.events.length };
  }

  compact(): void {
    const keep = this.state();
    const selected = new Map<string,HorizonEvent>();
    for (const event of [...keep.activeGoals, ...keep.unresolved, ...keep.recent]) selected.set(event.id,event);
    this.events.length = 0;
    this.events.push(...[...selected.values()].sort((a,b) => a.timestamp - b.timestamp));
  }
}
