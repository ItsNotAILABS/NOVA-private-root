import { useEffect, useMemo, useState } from 'react';
import { Alert, Linking, Pressable, ScrollView, StyleSheet, Text, TextInput, View } from 'react-native';
import Constants from 'expo-constants';
import { router } from 'expo-router';

type Workspace = { id: string; name: string; template?: string; preview?: string; status?: string };
type Health = { ok: boolean; app?: string; version?: string };

const defaultUrl = (Constants.expoConfig?.extra?.capsuleStudioDefaultUrl as string) || 'http://127.0.0.1:8787';

export default function Index() {
  const [serverUrl, setServerUrl] = useState(defaultUrl);
  const [health, setHealth] = useState<Health | null>(null);
  const [workspaces, setWorkspaces] = useState<Workspace[]>([]);
  const [log, setLog] = useState('Ready. Connect to Capsule Studio.');

  const normalized = useMemo(() => serverUrl.replace(/\/$/, ''), [serverUrl]);

  async function api(path: string, init?: RequestInit) {
    const response = await fetch(`${normalized}${path}`, { headers: { 'content-type': 'application/json' }, ...init });
    const data = await response.json();
    if (!response.ok) throw new Error(data.error || data.message || 'Request failed');
    return data;
  }

  async function refresh() {
    try {
      const h = await api('/api/health');
      const w = await api('/api/workspaces');
      setHealth(h);
      setWorkspaces(w.workspaces || []);
      setLog(JSON.stringify({ health: h, workspace_count: w.workspaces?.length || 0 }, null, 2));
    } catch (error: any) {
      setHealth(null);
      setLog(`Connection failed: ${error.message}\n\nFor a physical phone, replace 127.0.0.1 with your computer LAN IP, for example http://192.168.1.10:8787.`);
    }
  }

  async function createWorkspace(template: string) {
    try {
      const data = await api('/api/workspaces', { method: 'POST', body: JSON.stringify({ name: `${template.toUpperCase()} Mobile Demo`, template }) });
      setLog(JSON.stringify(data, null, 2));
      await refresh();
    } catch (error: any) {
      Alert.alert('Create failed', error.message);
    }
  }

  async function deploy(workspaceId: string) {
    const data = await api('/api/deploy/local', { method: 'POST', body: JSON.stringify({ workspaceId }) });
    setLog(JSON.stringify(data, null, 2));
  }

  function preview(workspace: Workspace) {
    const url = `${normalized}/preview/${workspace.id}/index.html`;
    router.push({ pathname: '/preview', params: { url, title: workspace.name } });
  }

  function openExternal(workspace: Workspace) {
    Linking.openURL(`${normalized}/preview/${workspace.id}/index.html`);
  }

  useEffect(() => { refresh(); }, []);

  return (
    <ScrollView style={styles.page} contentContainerStyle={styles.content}>
      <Text style={styles.eyebrow}>NOVA Production Mobile Lane</Text>
      <Text style={styles.title}>Capsule Mobile</Text>
      <Text style={styles.lede}>Use Expo Go for live demos, EAS builds for real installs, and Orbit for one-click simulator/device launches.</Text>

      <View style={styles.card}>
        <Text style={styles.label}>Capsule Studio Server</Text>
        <TextInput style={styles.input} value={serverUrl} onChangeText={setServerUrl} autoCapitalize="none" autoCorrect={false} />
        <View style={styles.row}>
          <Pressable style={styles.button} onPress={refresh}><Text style={styles.buttonText}>Connect</Text></Pressable>
          <Pressable style={styles.buttonGhost} onPress={() => createWorkspace('web')}><Text style={styles.buttonText}>New Web</Text></Pressable>
          <Pressable style={styles.buttonGhost} onPress={() => createWorkspace('python')}><Text style={styles.buttonText}>New Python</Text></Pressable>
        </View>
        <Text style={styles.status}>{health?.ok ? `LIVE · ${health.app} ${health.version}` : 'Not connected'}</Text>
      </View>

      <Text style={styles.section}>Workspaces</Text>
      {workspaces.length === 0 ? <Text style={styles.muted}>No workspaces loaded yet.</Text> : workspaces.map((workspace) => (
        <View key={workspace.id} style={styles.workspace}>
          <Text style={styles.workspaceTitle}>{workspace.name}</Text>
          <Text style={styles.muted}>{workspace.template || 'workspace'} · {workspace.id}</Text>
          <View style={styles.row}>
            <Pressable style={styles.button} onPress={() => preview(workspace)}><Text style={styles.buttonText}>Preview</Text></Pressable>
            <Pressable style={styles.buttonGhost} onPress={() => deploy(workspace.id)}><Text style={styles.buttonText}>Deploy Local</Text></Pressable>
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
  title: { color: '#f8fafc', fontSize: 54, lineHeight: 58, fontWeight: '900' },
  lede: { color: '#cbd5e1', fontSize: 17, lineHeight: 26 },
  card: { backgroundColor: '#0f172a', borderColor: '#1e40af', borderWidth: 1, borderRadius: 24, padding: 18, gap: 12 },
  label: { color: '#f8fafc', fontWeight: '800' },
  input: { color: '#f8fafc', borderWidth: 1, borderColor: '#334155', borderRadius: 14, padding: 12, backgroundColor: '#020617' },
  row: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginTop: 8 },
  button: { backgroundColor: '#2563eb', paddingHorizontal: 14, paddingVertical: 11, borderRadius: 14 },
  buttonGhost: { backgroundColor: '#172554', borderColor: '#38bdf8', borderWidth: 1, paddingHorizontal: 14, paddingVertical: 11, borderRadius: 14 },
  buttonText: { color: '#f8fafc', fontWeight: '900' },
  status: { color: '#bbf7d0', fontWeight: '800' },
  section: { color: '#f8fafc', fontSize: 24, fontWeight: '900', marginTop: 12 },
  muted: { color: '#94a3b8', lineHeight: 22 },
  workspace: { backgroundColor: '#0f172a', borderColor: '#334155', borderWidth: 1, borderRadius: 20, padding: 16, gap: 8 },
  workspaceTitle: { color: '#f8fafc', fontSize: 20, fontWeight: '900' },
  log: { color: '#dbeafe', backgroundColor: '#020617', borderColor: '#334155', borderWidth: 1, borderRadius: 16, padding: 14, fontFamily: 'Courier', overflow: 'hidden' }
});
