export const NOVA_SURFACES = [
  {
    id: "nova-phone",
    name: "NOVA Phone",
    type: "pwa",
    path: "organism/web/dashboards/nova-phone.html",
    platformRole: "mobile_operator_surface",
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
    boundary: {
      browserReceivesOpenAIKey: false,
      writeRoutesRequireOperatorToken: true,
      receiptsRequiredForOperatorWrites: true,
      staticSurfacesCanReadDashboard: true,
      staticSurfacesCannotBypassServerGateway: true
    }
  };
}
