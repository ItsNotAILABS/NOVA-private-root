export const NOVA_SURFACES = [
  {
    id: "nova-phone",
    name: "NOVA Phone",
    type: "pwa",
    path: "organism/web/dashboards/nova-phone.html",
    platformRole: "mobile_operator_surface",
    bridgeScript: "/public/platform-bridge.js",
    bridge: {
      status: "/api/dashboard",
      apps: "/api/apps",
      ai: "/api/ai/respond"
    },
    launchModes: ["local_platform", "static_preview", "installed_pwa"],
    enabled: true
  },
  {
    id: "capsule-studio",
    name: "NOVA Capsule Studio",
    type: "builder_app",
    path: "apps/capsule-studio",
    platformRole: "app_builder_surface",
    bridgeScript: "/public/platform-bridge.js",
    nodeClient: "platform/nova-app-platform/integrations/capsuleStudioPlatformClient.js",
    bridge: {
      status: "/api/dashboard",
      registerApp: "/api/operator/register-app",
      receipt: "/api/operator/receipt",
      ai: "/api/ai/respond"
    },
    launchModes: ["local_platform", "builder_runtime"],
    enabled: true
  }
];

export function listSurfaces() {
  return NOVA_SURFACES.map((surface) => ({ ...surface }));
}

export function getSurface(id) {
  return NOVA_SURFACES.find((surface) => surface.id === id) || null;
}

export function buildSurfaceContract() {
  return {
    schema: "nova-platform-surface-contract-v0.1",
    platform: "NOVA App Platform",
    surfaces: listSurfaces(),
    bridge: {
      browserScript: "/public/platform-bridge.js",
      localBaseUrl: "http://127.0.0.1:8899",
      surfaceIndex: "/surfaces"
    },
    boundary: {
      browserReceivesOpenAIKey: false,
      writeRoutesRequireOperatorToken: true,
      receiptsRequiredForOperatorWrites: true,
      staticSurfacesCanReadDashboard: true,
      staticSurfacesCannotBypassServerGateway: true
    }
  };
}

export function surfaceRegistry() {
  return buildSurfaceContract();
}

export function launchContract(id) {
  const surface = getSurface(id);
  if (!surface) return null;
  return {
    schema: "nova-surface-launch-contract-v0.1",
    surface,
    platformBaseUrl: "http://127.0.0.1:8899",
    bridgeScript: "http://127.0.0.1:8899/public/platform-bridge.js",
    requiredEnv: id === "capsule-studio" ? ["NOVA_PLATFORM_URL", "NOVA_OPERATOR_TOKEN"] : ["NOVA_PLATFORM_URL"],
    boundary: {
      openaiKeyServerSideOnly: true,
      writeRequiresOperatorToken: true
    }
  };
}
