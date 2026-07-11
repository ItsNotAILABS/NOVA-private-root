# Expo Go / Orbit Mobile Preview Lane

NOVA Capsule Studio now has a mobile preview lane through `apps/capsule-mobile`.

## Purpose

This lane lets the company show generated apps quickly without waiting for full public deployment every time.

- Use **Expo Go** for instant internal demos.
- Use **Expo Orbit** to launch simulators, install local `.apk` / simulator `.app` files, launch EAS builds, and manage local device/simulator testing.
- Use **EAS Build** for installable internal or production builds.
- Use Capsule Studio as the server/runtime that creates workspaces, serves previews, and performs local deployments.

## Runtime map

```text
Capsule Studio Server
  -> creates/runs/previews/deploys workspaces
  -> serves /api/workspaces and /preview/:workspaceId/index.html

Capsule Mobile Expo App
  -> connects to Capsule Studio URL
  -> creates workspaces
  -> opens generated apps in WebView
  -> triggers local deploy

Expo Go / Orbit / EAS
  -> shows the mobile control surface to users
  -> launches simulator/device builds
  -> enables one-click launch/install workflows
```

## Local demo flow

Terminal 1:

```bash
cd apps/capsule-studio
npm start
```

Terminal 2:

```bash
cd apps/capsule-mobile
npm install
npx expo start
```

Then:

1. Open Expo Go or simulator.
2. Connect to Capsule Studio.
3. Create a web workspace.
4. Tap Preview.
5. Show the generated app inside the mobile shell.

## Physical phone note

A physical phone cannot use the computer's `127.0.0.1`. Set the Capsule Studio URL in the mobile app to the computer LAN address:

```text
http://192.168.x.x:8787
```

## Orbit flow

Use Orbit when the app needs a faster launch/install loop:

- install local Android `.apk`
- install iOS simulator `.app` on macOS
- launch Android emulator or iOS simulator
- launch EAS builds on real devices/simulators
- install updates on supported devices/simulators
- quickly reopen pinned EAS projects/latest builds

## EAS profiles

`apps/capsule-mobile/eas.json` contains:

- `development` — development client, Android APK, iOS simulator
- `preview` — internal preview build, Android APK, iOS simulator
- `production` — production build profile

## Production direction

This gives NOVA two user-facing lanes:

1. **Web app lane** — `apps/capsule-studio`
2. **Mobile preview/control lane** — `apps/capsule-mobile`

The mobile lane is not replacing the web runtime. It is the field/demo/control surface for showing apps to users while Capsule Studio remains the generation and deployment server.
