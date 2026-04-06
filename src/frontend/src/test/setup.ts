// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║  VITEST SETUP FILE                                                                                        ║
// ║  Global test configuration and matchers                                                                   ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝

import '@testing-library/jest-dom';

// Mock WebGL context for Three.js tests
class MockWebGLRenderingContext {
  getExtension() { return null; }
  getParameter() { return ''; }
  createTexture() { return {}; }
  bindTexture() {}
  texImage2D() {}
  texParameteri() {}
  createBuffer() { return {}; }
  bindBuffer() {}
  bufferData() {}
  createProgram() { return {}; }
  attachShader() {}
  linkProgram() {}
  getProgramParameter() { return true; }
  useProgram() {}
  getUniformLocation() { return {}; }
  getAttribLocation() { return 0; }
  enableVertexAttribArray() {}
  vertexAttribPointer() {}
  createShader() { return {}; }
  shaderSource() {}
  compileShader() {}
  getShaderParameter() { return true; }
  deleteShader() {}
  uniform1i() {}
  uniform1f() {}
  uniform2f() {}
  uniform3f() {}
  uniform4f() {}
  uniformMatrix4fv() {}
  drawArrays() {}
  drawElements() {}
  viewport() {}
  clear() {}
  clearColor() {}
  enable() {}
  disable() {}
  blendFunc() {}
  depthFunc() {}
  cullFace() {}
  frontFace() {}
  pixelStorei() {}
}

// Mock canvas element
HTMLCanvasElement.prototype.getContext = function(contextId: string) {
  if (contextId === 'webgl' || contextId === 'webgl2') {
    return new MockWebGLRenderingContext() as unknown as WebGLRenderingContext;
  }
  return null;
};

// Mock ResizeObserver
global.ResizeObserver = class ResizeObserver {
  observe() {}
  unobserve() {}
  disconnect() {}
};

// Mock requestAnimationFrame
global.requestAnimationFrame = (callback: FrameRequestCallback) => {
  return setTimeout(callback, 16);
};

global.cancelAnimationFrame = (handle: number) => {
  clearTimeout(handle);
};

// Mock IntersectionObserver
global.IntersectionObserver = class IntersectionObserver {
  root = null;
  rootMargin = '';
  thresholds = [];
  observe() {}
  unobserve() {}
  disconnect() {}
  takeRecords() { return []; }
} as unknown as typeof IntersectionObserver;
