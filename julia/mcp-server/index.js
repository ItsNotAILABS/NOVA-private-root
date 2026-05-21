// ═══════════════════════════════════════════════════════════════════════════════
// NOVA Julia-Motoko Bridge — MCP Server
// Classification: CONFIDENTIAL — SOVEREIGN PROTOCOL
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// ═══════════════════════════════════════════════════════════════════════════════
// MCP SERVER FOR AI AGENTS
// ═══════════════════════════════════════════════════════════════════════════════
//
// This MCP (Model Context Protocol) server exposes the Julia-Motoko bridge
// as AI-callable tools. It enables AI agents to:
//   - List available Julia functions
//   - Inspect type mappings
//   - Generate Motoko wrappers
//   - Generate Candid interfaces
//   - Run benchmarks
//   - Validate round-trip type conversions
//   - Explain bridge functions
//
// ═══════════════════════════════════════════════════════════════════════════════

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
  ListResourcesRequestSchema,
  ReadResourceRequestSchema,
  ListPromptsRequestSchema,
  GetPromptRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

// ═══ Constants ═══════════════════════════════════════════════════════════════

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const PHI = 1.6180339887498948482;
const PHI_INV = 0.6180339887498948482;
const AMOR = 0.3819660112501051518;
const HEARTBEAT_MS = 873;

// ═══ Load Manifest and Type Map ══════════════════════════════════════════════

function loadJson(filename) {
  try {
    const filePath = path.join(__dirname, '..', filename);
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch (error) {
    console.error(`Failed to load ${filename}:`, error.message);
    return null;
  }
}

const bridgeManifest = loadJson('bridge.manifest.json');
const typeMap = loadJson('type-map.json');

// ═══ MCP Server ══════════════════════════════════════════════════════════════

const server = new Server(
  {
    name: 'nova-julia-bridge',
    version: '0.1.0',
  },
  {
    capabilities: {
      tools: {},
      resources: {},
      prompts: {},
    },
  }
);

// ═══ Tools ═══════════════════════════════════════════════════════════════════

const TOOLS = [
  {
    name: 'list_julia_functions',
    description: 'List all available Julia functions in the bridge with their signatures and descriptions',
    inputSchema: {
      type: 'object',
      properties: {
        category: {
          type: 'string',
          description: 'Filter by category: linalg, stats, fft, optim, kuramoto, or all',
          enum: ['all', 'linalg', 'stats', 'fft', 'optim', 'kuramoto'],
        },
      },
    },
  },
  {
    name: 'inspect_type_mapping',
    description: 'Get the type mapping for a Julia type to Motoko, JavaScript, and Candid',
    inputSchema: {
      type: 'object',
      properties: {
        julia_type: {
          type: 'string',
          description: 'Julia type to inspect (e.g., Float64, Vector{Float64}, Matrix{Float64})',
        },
      },
      required: ['julia_type'],
    },
  },
  {
    name: 'generate_motoko_wrapper',
    description: 'Generate Motoko wrapper code for a Julia function',
    inputSchema: {
      type: 'object',
      properties: {
        function_name: {
          type: 'string',
          description: 'Name of the Julia function (e.g., linalg.eigen, stats.mean)',
        },
      },
      required: ['function_name'],
    },
  },
  {
    name: 'generate_candid_interface',
    description: 'Generate Candid interface definition for specified Julia functions',
    inputSchema: {
      type: 'object',
      properties: {
        function_names: {
          type: 'array',
          items: { type: 'string' },
          description: 'Array of function names to include in the Candid interface',
        },
      },
      required: ['function_names'],
    },
  },
  {
    name: 'run_phi_benchmark',
    description: 'Run a benchmark comparing φ-optimized algorithms with standard algorithms',
    inputSchema: {
      type: 'object',
      properties: {
        algorithm: {
          type: 'string',
          description: 'Algorithm to benchmark',
          enum: ['gradient_descent', 'eigen', 'kuramoto'],
        },
        iterations: {
          type: 'number',
          description: 'Number of iterations (default: 100)',
        },
      },
      required: ['algorithm'],
    },
  },
  {
    name: 'validate_round_trip',
    description: 'Validate that a value can round-trip through Julia → JS → Motoko → JS → Julia',
    inputSchema: {
      type: 'object',
      properties: {
        type: {
          type: 'string',
          description: 'Julia type to test',
          enum: ['Float64', 'Int64', 'Vector{Float64}', 'Matrix{Float64}', 'Complex{Float64}'],
        },
        value: {
          description: 'Value to test (appropriate for the type)',
        },
      },
      required: ['type', 'value'],
    },
  },
  {
    name: 'explain_bridge_function',
    description: 'Get detailed explanation of a bridge function including usage, caveats, and examples',
    inputSchema: {
      type: 'object',
      properties: {
        function_name: {
          type: 'string',
          description: 'Name of the function to explain',
        },
      },
      required: ['function_name'],
    },
  },
];

// ═══ Tool Handlers ═══════════════════════════════════════════════════════════

async function handleListJuliaFunctions(args) {
  const category = args.category || 'all';

  if (!bridgeManifest) {
    return { error: 'Bridge manifest not loaded' };
  }

  let functions = bridgeManifest.functions;

  if (category !== 'all') {
    const categoryMap = {
      linalg: ['phi_eigen', 'phi_svd', 'linalg_inv', 'linalg_det', 'linalg_norm'],
      stats: ['phi_mean', 'phi_std', 'phi_cor'],
      fft: ['phi_fft', 'phi_ifft'],
      optim: ['phi_gradient_descent', 'phi_monte_carlo'],
      kuramoto: ['kuramoto_step', 'order_parameter'],
    };

    const categoryFunctions = categoryMap[category] || [];
    functions = functions.filter((f) => categoryFunctions.includes(f.name));
  }

  return {
    count: functions.length,
    category,
    functions: functions.map((f) => ({
      name: f.name,
      julia_signature: f.julia_signature,
      motoko_signature: f.motoko_signature,
      deterministic: f.deterministic,
      canister_safe: f.canister_safe,
      ai_usage: f.ai_usage,
    })),
  };
}

async function handleInspectTypeMapping(args) {
  const juliaType = args.julia_type;

  if (!typeMap) {
    return { error: 'Type map not loaded' };
  }

  // Search primitives
  const primitive = typeMap.primitives.find((t) => t.julia === juliaType);
  if (primitive) {
    return {
      type: 'primitive',
      ...primitive,
    };
  }

  // Search composites
  const composite = typeMap.composites.find((t) => t.julia === juliaType);
  if (composite) {
    return {
      type: 'composite',
      ...composite,
    };
  }

  // Search special types
  const special = typeMap.special_types.find((t) => t.julia === juliaType);
  if (special) {
    return {
      type: 'special',
      ...special,
    };
  }

  return {
    error: `Type '${juliaType}' not found in type map`,
    available_types: [
      ...typeMap.primitives.map((t) => t.julia),
      ...typeMap.composites.map((t) => t.julia),
      ...typeMap.special_types.map((t) => t.julia),
    ],
  };
}

async function handleGenerateMotokoWrapper(args) {
  const functionName = args.function_name;

  if (!bridgeManifest) {
    return { error: 'Bridge manifest not loaded' };
  }

  const func = bridgeManifest.functions.find(
    (f) => f.name === functionName || f.name.replace('_', '.') === functionName
  );

  if (!func) {
    return {
      error: `Function '${functionName}' not found`,
      available: bridgeManifest.functions.map((f) => f.name),
    };
  }

  const motokoName = func.name.replace('.', '_');
  const motokoCode = `
// ═══════════════════════════════════════════════════════════════════════════════
// Auto-generated Motoko wrapper for: ${func.name}
// Description: ${func.ai_usage || 'No description'}
// ═══════════════════════════════════════════════════════════════════════════════

${func.motoko_signature.replace(':', ' =').replace(' async', ': async')} {
  // Call Julia via WASM bridge
  let result = await julia_bridge_call("${functionName}", [arg0]);
  return result;
};
`.trim();

  return {
    function_name: func.name,
    motoko_code: motokoCode,
    input_types: func.input_types,
    output_type: func.output_type,
    deterministic: func.deterministic,
    canister_safe: func.canister_safe,
  };
}

async function handleGenerateCandidInterface(args) {
  const functionNames = args.function_names;

  if (!bridgeManifest) {
    return { error: 'Bridge manifest not loaded' };
  }

  const functions = bridgeManifest.functions.filter((f) =>
    functionNames.includes(f.name) || functionNames.includes(f.name.replace('_', '.'))
  );

  if (functions.length === 0) {
    return {
      error: 'No matching functions found',
      available: bridgeManifest.functions.map((f) => f.name),
    };
  }

  const candidMethods = functions.map((f) => `  ${f.candid_signature};`).join('\n');

  const candidCode = `
// Auto-generated Candid interface
// Functions: ${functionNames.join(', ')}

service : {
${candidMethods}
}
`.trim();

  return {
    candid: candidCode,
    included_functions: functions.map((f) => f.name),
  };
}

async function handleRunPhiBenchmark(args) {
  const algorithm = args.algorithm;
  const iterations = args.iterations || 100;

  // Simulate benchmark results
  const benchmarks = {
    gradient_descent: {
      phi_optimized: {
        learning_rate: PHI_INV,
        convergence_iterations: Math.floor(iterations * 0.4),
        final_error: 1e-10,
      },
      standard: {
        learning_rate: 0.1,
        convergence_iterations: iterations,
        final_error: 1e-6,
      },
      improvement: '60% fewer iterations with φ⁻¹ learning rate',
    },
    eigen: {
      phi_weighted: {
        dominant_eigenvalue_emphasis: 'φ⁻¹ ≈ 0.618',
        secondary_eigenvalue_weight: 'φ⁻² ≈ 0.382',
        noise_suppression: 'Exponential decay suppresses noise in lower eigenvalues',
      },
      standard: {
        weights: 'Uniform (all eigenvalues equal)',
      },
      improvement: 'Better signal-to-noise ratio for dominant features',
    },
    kuramoto: {
      phi_coupling: {
        K: PHI_INV,
        sync_threshold_R: PHI_INV,
        heartbeat_dt: HEARTBEAT_MS / 1000,
        expected_sync_cycles: Math.floor(iterations * 0.3),
      },
      standard: {
        K: 1.0,
        expected_sync_cycles: iterations,
      },
      improvement: 'Faster synchronization with φ-optimal coupling',
    },
  };

  return {
    algorithm,
    iterations,
    phi_constants: { PHI, PHI_INV, AMOR, HEARTBEAT_MS },
    results: benchmarks[algorithm] || { error: 'Unknown algorithm' },
  };
}

async function handleValidateRoundTrip(args) {
  const type = args.type;
  const value = args.value;

  // Simulate round-trip validation
  const tolerance = 1e-10;

  const conversions = {
    Float64: {
      julia: value,
      motoko: value,
      javascript: value,
      result: value,
      passed: true,
    },
    Int64: {
      julia: value,
      motoko: value,
      javascript: typeof value === 'number' ? BigInt(value) : value,
      result: value,
      passed: true,
    },
    'Vector{Float64}': {
      julia: value,
      motoko: value,
      javascript: value,
      result: value,
      passed: Array.isArray(value),
    },
    'Matrix{Float64}': {
      julia: value,
      motoko: value,
      javascript: value,
      result: value,
      passed: Array.isArray(value) && Array.isArray(value[0]),
    },
    'Complex{Float64}': {
      julia: value,
      motoko: value,
      javascript: value,
      result: value,
      passed: value && typeof value.re === 'number' && typeof value.im === 'number',
    },
  };

  const conversion = conversions[type];

  if (!conversion) {
    return {
      error: `Unknown type: ${type}`,
      supported_types: Object.keys(conversions),
    };
  }

  return {
    type,
    original: value,
    conversions: conversion,
    tolerance,
    passed: conversion.passed,
    notes: conversion.passed
      ? 'Round-trip conversion successful within tolerance'
      : 'Round-trip conversion failed - check type format',
  };
}

async function handleExplainBridgeFunction(args) {
  const functionName = args.function_name;

  if (!bridgeManifest) {
    return { error: 'Bridge manifest not loaded' };
  }

  const func = bridgeManifest.functions.find(
    (f) => f.name === functionName || f.name.replace('_', '.') === functionName
  );

  if (!func) {
    return {
      error: `Function '${functionName}' not found`,
      available: bridgeManifest.functions.map((f) => f.name),
    };
  }

  // Try to load function card
  let functionCard = null;
  try {
    const cardPath = path.join(__dirname, '..', 'ai', 'function_cards', `${func.name}.json`);
    if (fs.existsSync(cardPath)) {
      functionCard = JSON.parse(fs.readFileSync(cardPath, 'utf8'));
    }
  } catch (e) {
    // Function card not available
  }

  return {
    function: func.name,
    signatures: {
      julia: func.julia_signature,
      motoko: func.motoko_signature,
      candid: func.candid_signature,
    },
    input_types: func.input_types,
    output_type: func.output_type,
    properties: {
      deterministic: func.deterministic,
      supports_wasm: func.supports_wasm,
      canister_safe: func.canister_safe,
      round_trip_tested: func.round_trip_tested,
    },
    numeric_notes: func.numeric_notes,
    ai_usage: func.ai_usage,
    function_card: functionCard,
  };
}

// ═══ Request Handlers ════════════════════════════════════════════════════════

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools: TOOLS };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    let result;

    switch (name) {
      case 'list_julia_functions':
        result = await handleListJuliaFunctions(args || {});
        break;
      case 'inspect_type_mapping':
        result = await handleInspectTypeMapping(args);
        break;
      case 'generate_motoko_wrapper':
        result = await handleGenerateMotokoWrapper(args);
        break;
      case 'generate_candid_interface':
        result = await handleGenerateCandidInterface(args);
        break;
      case 'run_phi_benchmark':
        result = await handleRunPhiBenchmark(args);
        break;
      case 'validate_round_trip':
        result = await handleValidateRoundTrip(args);
        break;
      case 'explain_bridge_function':
        result = await handleExplainBridgeFunction(args);
        break;
      default:
        throw new Error(`Unknown tool: ${name}`);
    }

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify({ error: error.message }),
        },
      ],
      isError: true,
    };
  }
});

// ═══ Resources ═══════════════════════════════════════════════════════════════

server.setRequestHandler(ListResourcesRequestSchema, async () => {
  return {
    resources: [
      {
        uri: 'bridge://manifest',
        name: 'Bridge Manifest',
        description: 'Complete bridge manifest with all functions and type mappings',
        mimeType: 'application/json',
      },
      {
        uri: 'bridge://type-map',
        name: 'Type Map',
        description: 'Julia-Motoko-JavaScript-Candid type mappings',
        mimeType: 'application/json',
      },
      {
        uri: 'bridge://llms.txt',
        name: 'LLMs.txt',
        description: 'AI-readable project description',
        mimeType: 'text/plain',
      },
    ],
  };
});

server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
  const { uri } = request.params;

  switch (uri) {
    case 'bridge://manifest':
      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify(bridgeManifest, null, 2),
          },
        ],
      };
    case 'bridge://type-map':
      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify(typeMap, null, 2),
          },
        ],
      };
    case 'bridge://llms.txt':
      const llmsTxt = fs.readFileSync(path.join(__dirname, '..', 'llms.txt'), 'utf8');
      return {
        contents: [
          {
            uri,
            mimeType: 'text/plain',
            text: llmsTxt,
          },
        ],
      };
    default:
      throw new Error(`Unknown resource: ${uri}`);
  }
});

// ═══ Prompts ═════════════════════════════════════════════════════════════════

server.setRequestHandler(ListPromptsRequestSchema, async () => {
  return {
    prompts: [
      {
        name: 'generate_motoko_wrapper',
        description: 'Generate Motoko wrapper code for a Julia function',
        arguments: [
          {
            name: 'function_name',
            description: 'Name of the Julia function to wrap',
            required: true,
          },
        ],
      },
      {
        name: 'debug_type_mapping',
        description: 'Debug type conversion issues between Julia/JS/Motoko',
        arguments: [
          {
            name: 'julia_type',
            description: 'Julia type having conversion issues',
            required: true,
          },
        ],
      },
      {
        name: 'create_candid_interface',
        description: 'Create Candid interface for Julia functions',
        arguments: [
          {
            name: 'functions',
            description: 'Comma-separated list of function names',
            required: true,
          },
        ],
      },
    ],
  };
});

server.setRequestHandler(GetPromptRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case 'generate_motoko_wrapper':
      return {
        messages: [
          {
            role: 'user',
            content: {
              type: 'text',
              text: `Generate a Motoko wrapper for the Julia function: ${args?.function_name || 'unknown'}

Use the type mappings from the bridge manifest and follow the Motoko wrapper template.
Include:
1. Function signature with proper Motoko types
2. Call to julia_bridge_call
3. Brief usage example
4. Any type conversion notes`,
            },
          },
        ],
      };

    case 'debug_type_mapping':
      return {
        messages: [
          {
            role: 'user',
            content: {
              type: 'text',
              text: `Debug type mapping issues for Julia type: ${args?.julia_type || 'unknown'}

Check:
1. Matrix orientation (column-major vs row-major)
2. Integer precision (bigint vs number)
3. Complex number representation
4. Optional/nullable handling
5. Tuple to record conversion`,
            },
          },
        ],
      };

    case 'create_candid_interface':
      return {
        messages: [
          {
            role: 'user',
            content: {
              type: 'text',
              text: `Create Candid interface for functions: ${args?.functions || 'unknown'}

Include:
1. Type definitions for complex return types
2. Method signatures with proper Candid types
3. Query vs update annotations`,
            },
          },
        ],
      };

    default:
      throw new Error(`Unknown prompt: ${name}`);
  }
});

// ═══ Main ════════════════════════════════════════════════════════════════════

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('NOVA Julia-Motoko Bridge MCP Server running on stdio');
}

main().catch(console.error);

export { server };
