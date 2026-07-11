import { Stack, useLocalSearchParams } from 'expo-router';
import { StyleSheet, View } from 'react-native';
import { WebView } from 'react-native-webview';

export default function PreviewScreen() {
  const params = useLocalSearchParams<{ url?: string; title?: string }>();
  const url = params.url || 'about:blank';
  return (
    <View style={styles.page}>
      <Stack.Screen options={{ title: params.title || 'Preview' }} />
      <WebView source={{ uri: url }} style={styles.webview} originWhitelist={['*']} />
    </View>
  );
}

const styles = StyleSheet.create({
  page: { flex: 1, backgroundColor: '#020617' },
  webview: { flex: 1, backgroundColor: '#020617' }
});
