import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const required = ['package.json', 'app.json', 'eas.json', 'app/_layout.tsx', 'app/index.tsx', 'app/preview.tsx'];
for (const file of required) {
  if (!fs.existsSync(path.join(root, file))) throw new Error(`missing ${file}`);
}
const pkg = JSON.parse(fs.readFileSync(path.join(root, 'package.json'), 'utf8'));
if (!pkg.dependencies.expo || !pkg.dependencies['expo-router']) throw new Error('missing Expo dependencies');
const app = JSON.parse(fs.readFileSync(path.join(root, 'app.json'), 'utf8'));
if (!app.expo.scheme || !app.expo.extra?.capsuleStudioDefaultUrl) throw new Error('missing Expo deep link or server config');
console.log(JSON.stringify({ ok: true, app: app.expo.name, slug: app.expo.slug, scheme: app.expo.scheme }, null, 2));
