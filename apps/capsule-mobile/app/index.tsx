import { useEffect, useMemo, useState } from 'react';
import { Alert, Linking, Pressable, ScrollView, Share, StyleSheet, Text, TextInput, View } from 'react-native';
import Constants from 'expo-constants';
import { router } from 'expo-router';

type Workspace = { id: string; name: string; template?: string; preview?: string; status?: string; createdAt?: string };
type Health = { ok: boolean; app?: string; version?: string; internalAi?: string; ai?: { mode?: string; model?: string } };
type Organism = { id: string; name?: string; stance?: string; type?: string };
type UserLane = { id: string; name?: string; purpose?: string };
type BuildResult = { ok?: boolean; workspace?: Workspace; deployment?: { url?: string }; previewUrl?: string; receipt?: unknown };

type Mode = 'operator' | 'demo';

const defaultUrl = (Constants.expoConfig?.extra?.capsuleStudioDefaultUrl as string) || 'http://127.0.0.1:8787';
const samplePrompts = [
  'Build a polished landing page for a local construction company with services, proof, and contact CTA.',
  'Create a mobile-friendly AI research dashboard with cards, search, and a report export button.',
  'Make a public demo page for Sonic Ninja browser intelligence with privacy-first messaging.',
];

function normalizeUrl(value: string) {
  return value.trim().replace(/\/$/, '');
}

export default function Index() {
  const [serverUrl, setServerUrl] = useState(defaultUrl);
  const [mode, setMode] = useState<Mode>('operator');
  const [health, setHealth] = useState<Health | null>(null);
  const [workspaces, setWorkspaces] = useState<Workspace[]>([]);
  const [organisms, setOrganisms] = useState<Organism[]>([]);
  const [lanes, setLanes] = useState<UserLane[]>([]);
  const [prompt, setPrompt] = useState(samplePrompts[0]);
  const [building, setBuilding] = useState(false);
  const [activeWorkspace, setActiveWorkspace] = useState<Workspace | null>(null);
  const [log, setLog] = useState('Ready. Connect to Capsule Studio, then build and preview apps from Expo Go.');

  const normalized = useMemo(() => normalizeUrl(serverUrl), [serverUrl]);
  const activePreviewUrl = activeWorkspace ? `${normalized}/preview/${activeWorkspace.id}/index.html` : '';

  async function api(path: string, init?: RequestInit) {
    const response = await fetch(`${normalized}${path}`, {
      headers: { 'content-type': 'application/json' },
      ...init,
    });
    const text = await response.text();
    let data: any;
    try { data = JSON.parse(text); } catch { data = { raw: text }; }
    if (!response.ok) throw new Error(data.error || data.message || data.raw || 'Request failed');
    return data;
  }

  async function refresh() {
    try {
      const [h, w, internalStatus, laneStatus] = await Promise.all([
        api('/api/health'),
        api('/api/workspaces'),
        api('/api/internal-ai/status').catch(() => ({ organisms: [] })),
        api('/api/internal-ai/user-lanes').catch(() => ({ lanes: [] })),
      ]);
      setHealth(h);
      const loaded = w.workspaces || [];
      setWorkspaces(loaded);
      setOrganisms(internalStatus.organisms || []);
      setLanes(laneStatus.lanes || []);
      if (!activeWorkspace && loaded.length) setActiveWorkspace(loaded[0]);
      setLog(JSON.stringify({ connected: true, app: h.app, version: h.version, internalAi: h.internalAi, workspaces: loaded.length, organisms: (internalStatus.organisms || []).map((o: Organism) => o.id) }, null, 2));
    } catch (error: any) {
      setHealth(null);
      setLog(`Connection failed: ${error.message}\n\nPhone setup: start Capsule Studio with HOST=0.0.0.0, then replace 127.0.0.1 with your computer LAN IP, for example http://192.168.1.10:8787.`);
    }
  }

  async function createWorkspace(template: string) {
    try {
      const data = await api('/api/workspaces', { method: 'POST', body: JSON.stringify({ name: `${template.toUpperCase()} Mobile Demo`, template }) });
      setActiveWorkspace(data);
      setLog(JSON.stringify({ created: data }, null, 2));
      await refresh();
    } catch (error: any) {
      Alert.alert('Create failed', error.message);
    }
  }

  async function buildApp() {
    if (!prompt.trim()) return Alert.alert('Prompt required', 'Describe the app you want Capsule Studio to build.');
    setBuilding(true);
    try {
      const data: BuildResult = await api('/api/ai/build-app', {
        method: 'POST',
        body: JSON.stringify({
          prompt,
          source: 'expo-go-mobile-creation-lane',
          lane: mode === 'operator' ? 'founder-operator' : 'client-demo-viewer',
          route: 'NOVA.build.mobile-preview',
        }),
      });
      const workspace = data.workspace || (data as any);
      setActiveWorkspace(workspace as Workspace);
      setLog(JSON.stringify({ build: 'complete', workspace, deployment: data.deployment, receipt: data.receipt }, null, 2));
      await refresh();
      if (workspace?.id) preview(workspace as Workspace);
    } catch (error: any) {
      Alert.alert('Build failed', error.message);
      setLog(`Build failed: ${error.message}`);
    } finally {
      setBuilding(false);
    }
  }

  async function alphaRoute(organismId: 'NOVA' | 'CAIN' | 'ORO', intentText: string) {
    try {
      const data = await api('/api/internal-ai/alpha-route', {
        method: 'POST',
        body: JSON.stringify({ organismId, intentText, lane: mode === 'operator' ? 'founder-operator' : 'client-demo-viewer' }),
      });
      setLog(JSON.stringify(data, null, 2));
    } catch (error: any) {
      Alert.alert('Route failed', error.message);
    }
  }

  async function deploy(workspaceId: string) {
    const data = await api('/api/deploy/local', { method: 'POST', body: JSON.stringify({ workspaceId }) });
    setLog(JSON.stringify(data, null, 2));
  }

  function preview(workspace: Workspace) {
    const url = `${normalized}/preview/${workspace.id}/index.html`;
    setActiveWorkspace(workspace);
    router.push({ pathname: '/preview', params: { url, title: workspace.name || workspace.id } });
  }

  function openExternal(workspace: Workspace) {
    Linking.openURL(`${normalized}/preview/${workspace.id}/index.html`);
  }

  async function shareActive() {
    if (!activePreviewUrl) return Alert.alert('No active app', 'Build or select an app first.');
    await Share.share({ title: 'NOVA Capsule App Preview', message: `Open this generated app preview on the same network:\n${activePreviewUrl}` });
  }

  useEffect(() => { refresh(); }, []);

  return (
    <ScrollView style={styles.page} contentContainerStyle={styles.content}>
      <Text style={styles.eyebrow}>NOVA / CAIN / ORO · Expo Go Lane</Text>
      <Text style={styles.title}>Create Apps on Phone</Text>
      <Text style={styles.lede}>Build inside Capsule Studio, review through the organism gates, preview instantly in Expo Go, and share the generated app URL with users on the same network.</Text>

      <View style={styles.card}>
        <View style={styles.splitRow}>
          <Pressable style={mode === 'operator' ? styles.modeActive : styles.mode} onPress={() => setMode('operator')}><Text style={styles.buttonText}>Operator</Text></Pressable>
          <Pressable style={mode === 'demo' ? styles.modeActive : styles.mode} onPress={() => setMode('demo')}><Text style={styles.buttonText}>User Demo</Text></Pressable>
        </View>
        <Text style={styles.label}>Capsule Studio Server</Text>
        <TextInput style={styles.input} value={serverUrl} onChangeText={setServerUrl} autoCapitalize="none" autoCorrect={false} />
        <View style={styles.row}>
          <Pressable style={styles.button} onPress={refresh}><Text style={styles.buttonText}>Connect</Text></Pressable>
          <Pressable style={styles.buttonGhost} onPress={() => createWorkspace('web')}><Text style={styles.buttonText}>New Web</Text></Pressable>
          <Pressable style={styles.buttonGhost} onPress={() => createWorkspace('python')}><Text style={styles.buttonText}>New Python</Text></Pressable>
        </View>
        <Text style={styles.status}>{health?.ok ? `LIVE · ${health.app} ${health.version} · ${health.internalAi || 'internal-ai pending'}` : 'Not connected'}</Text>
      </View>

      <View style={styles.cardGold}>
        <Text style={styles.section}>AI App Builder</Text>
        <Text style={styles.muted}>Describe the app. NOVA builds it, ORO frames demo/use, and CAIN remains available for safety review.</Text>
        <TextInput style={styles.prompt} value={prompt} onChangeText={setPrompt} multiline textAlignVertical="top" autoCapitalize="sentences" />
        <View style={styles.row}>
          <Pressable style={styles.buttonGold} onPress={buildApp} disabled={building}><Text style={styles.darkButtonText}>{building ? 'Building...' : 'Build + Preview'}</Text></Pressable>
          <Pressable style={styles.buttonGhost} onPress={() => setPrompt(samplePrompts[(samplePrompts.indexOf(prompt) + 1 + samplePrompts.length) % samplePrompts.length])}><Text style={styles.buttonText}>Sample</Text></Pressable>
          <Pressable style={styles.buttonGhost} onPress={shareActive}><Text style={styles.buttonText}>Share URL</Text></Pressable>
        </View>
      </View>

      <Text style={styles.section}>Organism Control</Text>
      <View style={styles.grid}>
        {['NOVA', 'CAIN', 'ORO'].map((id) => {
          const organism = organisms.find((item) => item.id === id);
          return (
            <View key={id} style={styles.organismCard}>
              <Text style={styles.organismId}>{id}</Text>
              <Text style={styles.muted}>{organism?.stance || organism?.type || 'registered framework'}</Text>
              <Pressable style={styles.smallButton} onPress={() => alphaRoute(id as 'NOVA' | 'CAIN' | 'ORO', id === 'CAIN' ? 'defensive review of this mobile app creation lane' : id === 'ORO' ? 'prepare user demo resources for generated app preview' : 'build and preview mobile generated app')}><Text style={styles.buttonText}>Route</Text></Pressable>
            </View>
          );
        })}
      </View>
      <Text style={styles.muted}>User lanes loaded: {lanes.length ? lanes.map((lane) => lane.id).join(', ') : 'connect to see lanes'}</Text>

      <Text style={styles.section}>Generated Apps</Text>
      {workspaces.length === 0 ? <Text style={styles.muted}>No workspaces loaded yet.</Text> : workspaces.map((workspace) => (
        <View key={workspace.id} style={activeWorkspace?.id === workspace.id ? styles.workspaceActive : styles.workspace}>
          <Text style={styles.workspaceTitle}>{workspace.name}</Text>
          <Text style={styles.muted}>{workspace.template || 'workspace'} · {workspace.id}</Text>
          <View style={styles.row}>
            <Pressable style={styles.button} onPress={() => preview(workspace)}><Text style={styles.buttonText}>Preview</Text></Pressable>
            <Pressable style={styles.buttonGhost} onPress={() => deploy(workspace.id)}><Text style={styles.buttonText}>Deploy</Text></Pressable>
            <Pressable style={styles.buttonGhost} onPress={() => openExternal(workspace)}><Text style={styles.buttonText}>Open</Text></Pressable>
          </View>
        </View>
      ))}

      <Text style={styles.section}>Operator Log</Text>
      <Text style={styles.log}>{log}</Text>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  page: { flex: 1, backgroundColor: '#020617' },
  content: { padding: 22, gap: 16 },
  eyebrow: { color: '#38bdf8', textTransform: 'uppercase', letterSpacing: 2, fontWeight: '900', marginTop: 12 },
  title: { color: '#f8fafc', fontSize: 48, lineHeight: 52, fontWeight: '900' },
  lede: { color: '#cbd5e1', fontSize: 16, lineHeight: 25 },
  card: { backgroundColor: '#0f172a', borderColor: '#1e40af', borderWidth: 1, borderRadius: 24, padding: 18, gap: 12 },
  cardGold: { backgroundColor: '#111827', borderColor: '#f59e0b', borderWidth: 1, borderRadius: 24, padding: 18, gap: 12 },
  label: { color: '#f8fafc', fontWeight: '800' },
  input: { color: '#f8fafc', borderWidth: 1, borderColor: '#334155', borderRadius: 14, padding: 12, backgroundColor: '#020617' },
  prompt: { color: '#f8fafc', borderWidth: 1, borderColor: '#475569', borderRadius: 16, padding: 14, minHeight: 132, backgroundColor: '#020617', lineHeight: 22 },
  row: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginTop: 8 },
  splitRow: { flexDirection: 'row', gap: 10 },
  grid: { gap: 12 },
  button: { backgroundColor: '#2563eb', paddingHorizontal: 14, paddingVertical: 11, borderRadius: 14 },
  buttonGold: { backgroundColor: '#f59e0b', paddingHorizontal: 16, paddingVertical: 12, borderRadius: 14 },
  buttonGhost: { backgroundColor: '#172554', borderColor: '#38bdf8', borderWidth: 1, paddingHorizontal: 14, paddingVertical: 11, borderRadius: 14 },
  smallButton: { backgroundColor: '#1d4ed8', paddingHorizontal: 12, paddingVertical: 9, borderRadius: 12, marginTop: 10, alignSelf: 'flex-start' },
  mode: { flex: 1, backgroundColor: '#172554', borderColor: '#334155', borderWidth: 1, padding: 12, borderRadius: 14, alignItems: 'center' },
  modeActive: { flex: 1, backgroundColor: '#2563eb', borderColor: '#38bdf8', borderWidth: 1, padding: 12, borderRadius: 14, alignItems: 'center' },
  buttonText: { color: '#f8fafc', fontWeight: '900' },
  darkButtonText: { color: '#111827', fontWeight: '900' },
  status: { color: '#bbf7d0', fontWeight: '800' },
  section: { color: '#f8fafc', fontSize: 23, fontWeight: '900', marginTop: 12 },
  muted: { color: '#94a3b8', lineHeight: 22 },
  organismCard: { backgroundColor: '#0f172a', borderColor: '#334155', borderWidth: 1, borderRadius: 18, padding: 14, gap: 4 },
  organismId: { color: '#f8fafc', fontSize: 22, fontWeight: '900' },
  workspace: { backgroundColor: '#0f172a', borderColor: '#334155', borderWidth: 1, borderRadius: 20, padding: 16, gap: 8 },
  workspaceActive: { backgroundColor: '#0f172a', borderColor: '#f59e0b', borderWidth: 2, borderRadius: 20, padding: 16, gap: 8 },
  workspaceTitle: { color: '#f8fafc', fontSize: 20, fontWeight: '900' },
  log: { color: '#dbeafe', backgroundColor: '#020617', borderColor: '#334155', borderWidth: 1, borderRadius: 16, padding: 14, fontFamily: 'Courier', overflow: 'hidden' },
});
