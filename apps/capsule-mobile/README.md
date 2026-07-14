# NOVA Capsule Mobile

Expo Go app creation and live preview lane for NOVA Capsule Studio.

This app gives the production system a fast mobile surface:

- **Expo Go** for fast user demos and internal app previews.
- **AI App Builder on phone** for prompt -> build -> preview workflows.
- **NOVA / CAIN / ORO controls** for runtime build routing, defensive review, and demo/resource planning.
- **Expo Orbit** for one-click simulator/device launch of local builds, EAS builds, updates, and Snack-style flows.
- **EAS Build** for installable Android APKs, iOS simulator builds, and production builds.
- **Capsule Studio WebView previews** so generated apps can be shown from phone/simulator while the server runs locally or on an internal host.

## Start Capsule Studio first

From repo root:

```bash
cd apps/capsule-studio
npm start
```

Default server:

```text
http://127.0.0.1:8787
```

For a physical phone, bind the server to the LAN:

```bash
HOST=0.0.0.0 npm start
```

Windows PowerShell:

```powershell
$env:HOST="0.0.0.0"; npm start
```

Then use your computer LAN IP instead of `127.0.0.1`, for example:

```text
http://192.168.1.10:8787
```

## Run in Expo Go

```bash
cd apps/capsule-mobile
npm install
npx expo start
```

Scan the QR code with Expo Go.

## App creation flow

1. Start Capsule Studio.
2. Start Expo Go.
3. Enter the Capsule Studio server URL in the phone app.
4. Tap **Connect**.
5. Select **Operator** or **User Demo** mode.
6. Type an app idea in **AI App Builder**.
7. Tap **Build + Preview**.
8. Capsule Studio builds the workspace through `/api/ai/build-app`.
9. Expo Go opens the generated app in a WebView.
10. Tap **Share URL** to send the preview link to users on the same LAN.

## Runtime organism controls

The phone app surfaces the internal heavy frameworks:

- **NOVA** — build and runtime creation route.
- **CAIN** — defensive review and safety/challenge route.
- **ORO** — user demo, resource, handoff, and operations route.

The app calls:

```text
GET  /api/internal-ai/status
GET  /api/internal-ai/user-lanes
POST /api/internal-ai/alpha-route
```

## Run with Expo Orbit

Orbit is the launch/control lane for simulators and device builds.

Use it for:

- launching Android emulators
- launching iOS simulators on macOS
- installing APK files
- installing iOS simulator `.app` files
- launching EAS builds on devices/simulators
- installing updates on Android and simulators
- opening pinned EAS projects and latest builds

Suggested workflow:

```bash
cd apps/capsule-mobile
npx expo start
```

Then use Orbit to open the simulator/device or install the latest EAS build.

## EAS builds

Development build:

```bash
eas build --profile development --platform android
```

Preview build:

```bash
eas build --profile preview --platform android
```

iOS simulator build on macOS:

```bash
eas build --profile development --platform ios
```

## What the mobile app does

- connects to Capsule Studio server
- displays server health and internal AI version
- lists generated coding workspaces
- creates web/Python workspaces
- sends app prompts to the AI App Builder
- opens frontend previews inside a mobile WebView
- shares generated app preview URLs
- triggers local deploy from mobile
- displays operator logs
- routes NOVA / CAIN / ORO alpha requests

## Boundary

Expo Go is the fastest demo lane. EAS builds are the installable lane. Orbit is the one-click launch/install lane. Capsule Studio remains the runtime server that creates/runs/previews/deploys the generated apps.

The mobile app does not claim external hosting or app-store release by itself. Public deployment requires a separate verified deployment receipt.

## More docs

See:

```text
docs/EXPO_GO_CREATION_LANE.md
```
