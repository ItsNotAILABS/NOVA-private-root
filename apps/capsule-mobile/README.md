# NOVA Capsule Mobile

Expo mobile preview app for NOVA Capsule Studio.

This app gives the production system a fast mobile lane:

- **Expo Go** for fast user demos and internal app previews.
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

For a physical phone, use your computer LAN IP instead of `127.0.0.1`, for example:

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
- lists generated coding workspaces
- creates web/Python workspaces
- opens frontend previews inside a mobile WebView
- triggers local deploy from mobile
- displays operator logs

## Boundary

Expo Go is the fastest demo lane. EAS builds are the installable lane. Orbit is the one-click launch/install lane. Capsule Studio remains the runtime server that creates/runs/previews/deploys the generated apps.
