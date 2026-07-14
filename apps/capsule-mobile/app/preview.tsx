import { Stack, useLocalSearchParams } from 'expo-router';
import { Linking, Pressable, Share, StyleSheet, Text, View } from 'react-native';
import { WebView } from 'react-native-webview';

export default function PreviewScreen() {
  const params = useLocalSearchParams<{ url?: string; title?: string }>();
  const url = params.url || 'about:blank';
  const title = params.title || 'Preview';

  async function sharePreview() {
    await Share.share({ title, message: `NOVA Capsule generated app preview:\n${url}` });
  }

  return (
    <View style={styles.page}>
      <Stack.Screen options={{ title }} />
      <View style={styles.toolbar}>
        <Text style={styles.url} numberOfLines={1}>{url}</Text>
        <Pressable style={styles.button} onPress={() => Linking.openURL(url)}><Text style={styles.buttonText}>Open</Text></Pressable>
        <Pressable style={styles.buttonGhost} onPress={sharePreview}><Text style={styles.buttonText}>Share</Text></Pressable>
      </View>
      <WebView source={{ uri: url }} style={styles.webview} originWhitelist={['*']} />
    </View>
  );
}

const styles = StyleSheet.create({
  page: { flex: 1, backgroundColor: '#020617' },
  toolbar: { backgroundColor: '#0f172a', borderBottomColor: '#334155', borderBottomWidth: 1, padding: 10, gap: 8, flexDirection: 'row', alignItems: 'center' },
  url: { color: '#cbd5e1', flex: 1, fontSize: 12 },
  button: { backgroundColor: '#2563eb', paddingHorizontal: 12, paddingVertical: 8, borderRadius: 12 },
  buttonGhost: { backgroundColor: '#172554', borderColor: '#38bdf8', borderWidth: 1, paddingHorizontal: 12, paddingVertical: 8, borderRadius: 12 },
  buttonText: { color: '#f8fafc', fontWeight: '900' },
  webview: { flex: 1, backgroundColor: '#020617' },
});
