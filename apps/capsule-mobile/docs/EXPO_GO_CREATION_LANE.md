# Expo Go App Creation Lane

Status: production-facing mobile demo lane for NOVA Capsule Studio.

This app turns a phone into the front door for generated app demos. Capsule Studio remains the server/runtime. Expo Go becomes the user-visible creation and preview surface.

## What changed

The mobile app is no longer only a workspace viewer. It now supports:

- Operator and User Demo modes.
- Capsule Studio server URL entry for local or LAN hosts.
- AI app prompt entry from the phone.
- `POST /api/ai/build-app` from Expo Go.
- Immediate WebView preview of the generated app.
- URL sharing for users on the same network.
- NOVA / CAIN / ORO route buttons through `POST /api/internal-ai/alpha-route`.
- User lane display through `GET /api/internal-ai/user-lanes`.
- Workspace deploy, open, and preview controls.

## Run the server

From the root repo:

```bash
cd apps/capsule-studio
npm start
```

For a real phone, bind the server to the network:

```bash
HOST=0.0.0.0 npm start
```

Windows PowerShell:

```powershell
$env:HOST="0.0.0.0"; npm start
```

Then use your computer LAN IP in the mobile app:

```text
http://192.168.1.10:8787
```

Do not use `127.0.0.1` from a physical phone. On a phone, `127.0.0.1` means the phone itself, not your laptop.

## Run Expo Go

```bash
cd apps/capsule-mobile
npm install
npx expo start
```

Scan the QR code with Expo Go.

## Demo flow

1. Start Capsule Studio on the laptop.
2. Start Expo Go.
3. Enter the laptop LAN URL.
4. Tap **Connect**.
5. Choose **Operator** or **User Demo**.
6. Enter an app idea.
7. Tap **Build + Preview**.
8. The generated app opens in the phone WebView.
9. Tap **Share URL** to send the preview link to another user on the same network.

## Runtime roles

- **NOVA** builds and routes app creation.
- **ORO** frames resources, demos, handoffs, and user-facing flows.
- **CAIN** reviews defensive/safety boundaries and challenge routes.

## Public demo boundary

Use the mobile app to show generated apps, local-first browser intelligence demos, workspace previews, and safe product walkthroughs.

Do not use this lane to claim public hosting, certified security, external deployment, or production app-store release unless that artifact has actually been built and verified.

## Installable lane

Expo Go is the fastest live demo lane. Use EAS when an installable build is needed:

```bash
eas build --profile preview --platform android
```

For iOS simulator builds on macOS:

```bash
eas build --profile development --platform ios
```

## Validation

Run:

```bash
npm run check
```

The check verifies Expo config, required files, WebView preview, share/open controls, internal AI endpoints, NOVA/CAIN/ORO markers, and app creation controls.
