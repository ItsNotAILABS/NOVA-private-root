import { Stack } from 'expo-router';
import { StatusBar } from 'expo-status-bar';

export default function RootLayout() {
  return (
    <>
      <Stack screenOptions={{ headerStyle: { backgroundColor: '#020617' }, headerTintColor: '#f8fafc', contentStyle: { backgroundColor: '#020617' } }}>
        <Stack.Screen name="index" options={{ title: 'NOVA Capsule Mobile' }} />
        <Stack.Screen name="preview" options={{ title: 'Preview' }} />
      </Stack>
      <StatusBar style="light" />
    </>
  );
}
