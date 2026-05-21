// ═══════════════════════════════════════════════════════════════════════════════
// Tests for PROTOCOL-MATH-API, PROTOCOL-POWERSHELL-TRANSLATOR,
// PROTOCOL-PYTHON-BRIDGE, PROTOCOL-MULTI-LANG (BUILD №65)
// ═══════════════════════════════════════════════════════════════════════════════

import { describe, it } from 'node:test';
import assert from 'node:assert/strict';

import {
  PHI, PHI_INV, AMOR, MATH_MODELS, DOMAIN_SUMMARY,
  MathModelRegistry, getMathRegistry,
} from '../PROTOCOL-MATH-API.js';

import {
  JuliaParser, PowerShellGenerator, PowerShellTranslator, getTranslator,
} from '../PROTOCOL-POWERSHELL-TRANSLATOR.js';

import {
  PYTHON_TYPE_MAPPINGS, PYTHON_FUNCTIONS,
  PythonEngine, MotokoPythonBridge, getPythonEngine, getPythonBridge,
} from '../PROTOCOL-PYTHON-BRIDGE.js';

import {
  SUPPORTED_LANGUAGES, RUST_FUNCTIONS, GO_FUNCTIONS, R_FUNCTIONS,
  UniversalBridgeGenerator, getMultiLangBridge,
} from '../PROTOCOL-MULTI-LANG.js';

// ═══ PROTOCOL-MATH-API Tests ═════════════════════════════════════════════════

describe('PROTOCOL-MATH-API', () => {
  it('should have 110+ mathematical models', () => {
    const count = Object.keys(MATH_MODELS).length;
    assert.ok(count >= 110, `Expected 110+ models, got ${count}`);
  });

  it('should have correct constants', () => {
    assert.strictEqual(PHI, 1.6180339887498948482);
    assert.strictEqual(PHI_INV, 0.6180339887498948482);
    assert.strictEqual(AMOR, 0.3819660112501051518);
  });

  it('should cover 8 domains', () => {
    const domains = Object.keys(DOMAIN_SUMMARY);
    assert.strictEqual(domains.length, 8);
  });

  it('MathModelRegistry should search by description', () => {
    const registry = getMathRegistry();
    const results = registry.search('eigenvalue');
    assert.ok(results.length > 0, 'Should find eigenvalue models');
  });

  it('MathModelRegistry should list domain', () => {
    const registry = getMathRegistry();
    const linAlg = registry.listDomain('linear_algebra');
    assert.ok(linAlg.length >= 25, `Expected 25+ linear algebra models, got ${linAlg.length}`);
  });

  it('every model should have julia, python, and motoko fields', () => {
    for (const [key, model] of Object.entries(MATH_MODELS)) {
      assert.ok(model.julia, `${key} missing julia field`);
      assert.ok(model.python, `${key} missing python field`);
      assert.ok(model.motoko, `${key} missing motoko field`);
    }
  });

  it('every model should have unique ID', () => {
    const ids = new Set();
    for (const model of Object.values(MATH_MODELS)) {
      assert.ok(!ids.has(model.id), `Duplicate ID: ${model.id}`);
      ids.add(model.id);
    }
  });
});

// ═══ PROTOCOL-POWERSHELL-TRANSLATOR Tests ════════════════════════════════════

describe('PROTOCOL-POWERSHELL-TRANSLATOR', () => {
  it('JuliaParser should tokenize const declarations', () => {
    const parser = new JuliaParser();
    const tokens = parser.tokenize('const PHI = 1.618');
    assert.ok(tokens.length > 0);
    assert.strictEqual(tokens[0].type, 'KEYWORD');
    assert.strictEqual(tokens[0].value, 'const');
  });

  it('JuliaParser should parse function declarations', () => {
    const parser = new JuliaParser();
    const ast = parser.parse('function hello(x::Float64)\n  return x * 2\nend');
    assert.strictEqual(ast.type, 'program');
    const funcStmt = ast.statements.find(s => s.type === 'function');
    assert.ok(funcStmt, 'Should find function statement');
    assert.strictEqual(funcStmt.name, 'hello');
  });

  it('PowerShellGenerator should translate const', () => {
    const translator = getTranslator();
    const result = translator.translate('const PHI = 1.618');
    assert.ok(result.includes('$PHI = 1.618'), `Got: ${result}`);
  });

  it('detectJulia should identify Julia code', () => {
    const translator = getTranslator();
    assert.ok(translator.detectJulia('function foo(x::Float64)\n  return x\nend'));
    assert.ok(!translator.detectJulia('Write-Host "hello"'));
  });

  it('generateInstallScript should produce valid PowerShell', () => {
    const translator = getTranslator();
    const script = translator.generateInstallScript();
    assert.ok(script.includes('winget install Julialang.Julia'));
    assert.ok(script.includes('Get-Command julia'));
  });

  it('generateNovaModule should produce PowerShell module', () => {
    const translator = getTranslator();
    const module = translator.generateNovaModule();
    assert.ok(module.includes('$Script:PHI = 1.6180339887498948482'));
    assert.ok(module.includes('Invoke-PhiMean'));
    assert.ok(module.includes('Export-ModuleMember'));
  });
});

// ═══ PROTOCOL-PYTHON-BRIDGE Tests ════════════════════════════════════════════

describe('PROTOCOL-PYTHON-BRIDGE', () => {
  it('should have 35+ Python function definitions', () => {
    const count = Object.keys(PYTHON_FUNCTIONS).length;
    assert.ok(count >= 35, `Expected 35+ functions, got ${count}`);
  });

  it('should have type mappings for core Python types', () => {
    assert.strictEqual(PYTHON_TYPE_MAPPINGS['float'], 'Float');
    assert.strictEqual(PYTHON_TYPE_MAPPINGS['int'], 'Int');
    assert.strictEqual(PYTHON_TYPE_MAPPINGS['str'], 'Text');
    assert.strictEqual(PYTHON_TYPE_MAPPINGS['numpy.ndarray'], 'Array Float');
  });

  it('PythonEngine should list functions by category', () => {
    const engine = getPythonEngine();
    const mlFuncs = engine.listFunctions('machine_learning');
    assert.ok(mlFuncs.length >= 4, `Expected 4+ ML functions, got ${mlFuncs.length}`);
  });

  it('PythonEngine should return categories', () => {
    const engine = getPythonEngine();
    const cats = engine.getCategories();
    assert.ok(cats.includes('linear_algebra'));
    assert.ok(cats.includes('optimization'));
    assert.ok(cats.includes('machine_learning'));
  });

  it('MotokoPythonBridge should generate Motoko wrapper', () => {
    const bridge = getPythonBridge();
    const wrapper = bridge.generateMotokoWrapper('numpy.linalg.eig');
    assert.ok(wrapper.includes('public shared func'));
    assert.ok(wrapper.includes('python_bridge_call'));
  });

  it('MotokoPythonBridge should generate Python SDK', () => {
    const bridge = getPythonBridge();
    const sdk = bridge.generatePythonSDK();
    assert.ok(sdk.includes('PHI = 1.6180339887498948482'));
    assert.ok(sdk.includes('def phi_gradient_descent'));
    assert.ok(sdk.includes('def kuramoto_sync'));
  });
});

// ═══ PROTOCOL-MULTI-LANG Tests ═══════════════════════════════════════════════

describe('PROTOCOL-MULTI-LANG', () => {
  it('should support 6 languages', () => {
    assert.strictEqual(Object.keys(SUPPORTED_LANGUAGES).length, 6);
  });

  it('should have Rust function registry', () => {
    assert.ok(Object.keys(RUST_FUNCTIONS).length >= 8);
    assert.ok(RUST_FUNCTIONS['nalgebra::eigen']);
  });

  it('should have Go function registry', () => {
    assert.ok(Object.keys(GO_FUNCTIONS).length >= 7);
    assert.ok(GO_FUNCTIONS['gonum/mat.Eigen']);
  });

  it('should have R function registry', () => {
    assert.ok(Object.keys(R_FUNCTIONS).length >= 10);
    assert.ok(R_FUNCTIONS['base::eigen']);
  });

  it('UniversalBridgeGenerator should list all functions', () => {
    const bridge = getMultiLangBridge();
    const all = bridge.listAllFunctions();
    assert.ok(all.totalCount >= 25, `Expected 25+ total, got ${all.totalCount}`);
  });

  it('should generate universal Motoko wrapper', () => {
    const bridge = getMultiLangBridge();
    const wrapper = bridge.generateUniversalMotokoWrapper('eigen');
    assert.ok(wrapper.includes('julia_bridge'));
    assert.ok(wrapper.includes('python_bridge'));
    assert.ok(wrapper.includes('rust_wasm'));
  });

  it('should find cross-language equivalents', () => {
    const bridge = getMultiLangBridge();
    const equivs = bridge.getEquivalents('PhiLA.eigen(matrix)');
    assert.ok(equivs.rust || equivs.go || equivs.r, 'Should find at least one equivalent');
  });
});
