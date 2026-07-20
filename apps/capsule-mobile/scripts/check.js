import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const required = ['package.json', 'app.json', 'eas.json', 'README.md', 'app/_layout.tsx', 'app/index.tsx', 'app/preview.tsx', 'docs/EXPO_GO_CREATION_LANE.md'];
for (const file of required) {
  if (!fs.existsSync(path.join(root, file))) throw new Error(`missing ${file}`);
}

const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
if (!pkg.dependencies.expo || !pkg.dependencies['expo-router'] || !pkg.dependencies['react-native-webview']) throw new Error('missing Expo/mobile preview dependencies');

const app = JSON.parse(fs.readFileSync(path.join(root, 'app.json'), 'utf8'));
if (!app.expo.scheme || !app.expo.extra?.capsuleStudioDefaultUrl) throw new Error('missing Expo deep link or server config');
if (app.expo.icon || app.expo.android?.adaptiveIcon?.foregroundImage) throw new Error('asset references must not point at missing files in Expo Go lane');

const index = fs.readFileSync(path.join(root, 'app/index.tsx'), 'utf8');
for (const marker of [
  '/api/ai/build-app',
  '/api/internal-ai/alpha-route',
  '/api/internal-ai/user-lanes',
  'NOVA',
  'CAIN',
  'ORO',
  'Build + Preview',
  'Share URL',
  'User Demo',
]) {
  if (!index.includes(marker)) throw new Error(`missing mobile creation marker: ${marker}`);
}

const preview = fs.readFileSync(path.join(root, 'app/preview.tsx'), 'utf8');
if (!preview.includes('WebView') || !preview.includes('Share.share') || !preview.includes('Linking.openURL')) throw new Error('preview screen must support webview, share, and external open');

console.log(JSON.stringify({ ok: true, app: app.expo.name, version: app.expo.version, slug: app.expo.slug, scheme: app.expo.scheme, lane: 'expo-go-app-creation' }, null, 2));
