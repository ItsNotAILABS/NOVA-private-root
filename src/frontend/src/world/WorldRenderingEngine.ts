// ═══════════════════════════════════════════════════════════════════════════════
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ═══════════════════════════════════════════════════════════════════════════════
// Module: WorldRenderingEngine — Advanced 3D Rendering Pipeline
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔════════════════════════════════════════════════════════════════════════════════╗
// ║                    WORLD RENDERING ENGINE — VISUAL REALITY                     ║
// ╠════════════════════════════════════════════════════════════════════════════════╣
// ║                                                                                ║
// ║  Complete 3D rendering pipeline for the living world:                          ║
// ║    • Scene graph management                                                    ║
// ║    • Camera systems (perspective, orthographic, VR)                            ║
// ║    • Lighting (directional, point, spot, area)                                 ║
// ║    • Materials and shaders                                                     ║
// ║    • Post-processing effects                                                   ║
// ║    • Particle systems                                                          ║
// ║    • Terrain rendering with LOD                                                ║
// ║    • Sky and atmosphere                                                        ║
// ║    • Water and reflections                                                     ║
// ║                                                                                ║
// ╚════════════════════════════════════════════════════════════════════════════════╝
// ═══════════════════════════════════════════════════════════════════════════════

import type { Vec3, Quaternion } from './WorldPhysicsEngine';
import { vec3, quat } from './WorldPhysicsEngine';

// ═══════════════════════════════════════════════════════════════════════════════
// COLOR AND MATH UTILITIES
// ═══════════════════════════════════════════════════════════════════════════════

export interface Color {
  r: number;  // 0-1
  g: number;
  b: number;
  a: number;
}

export interface Color3 {
  r: number;
  g: number;
  b: number;
}

export const color = {
  white: (): Color => ({ r: 1, g: 1, b: 1, a: 1 }),
  black: (): Color => ({ r: 0, g: 0, b: 0, a: 1 }),
  red: (): Color => ({ r: 1, g: 0, b: 0, a: 1 }),
  green: (): Color => ({ r: 0, g: 1, b: 0, a: 1 }),
  blue: (): Color => ({ r: 0, g: 0, b: 1, a: 1 }),
  transparent: (): Color => ({ r: 0, g: 0, b: 0, a: 0 }),
  
  fromHex: (hex: string): Color => {
    const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})?$/i.exec(hex);
    if (!result) return color.white();
    return {
      r: parseInt(result[1], 16) / 255,
      g: parseInt(result[2], 16) / 255,
      b: parseInt(result[3], 16) / 255,
      a: result[4] ? parseInt(result[4], 16) / 255 : 1,
    };
  },
  
  toHex: (c: Color): string => {
    const toHex = (n: number) => Math.round(n * 255).toString(16).padStart(2, '0');
    return `#${toHex(c.r)}${toHex(c.g)}${toHex(c.b)}${toHex(c.a)}`;
  },
  
  lerp: (a: Color, b: Color, t: number): Color => ({
    r: a.r + (b.r - a.r) * t,
    g: a.g + (b.g - a.g) * t,
    b: a.b + (b.b - a.b) * t,
    a: a.a + (b.a - a.a) * t,
  }),
  
  multiply: (a: Color, b: Color): Color => ({
    r: a.r * b.r,
    g: a.g * b.g,
    b: a.b * b.b,
    a: a.a * b.a,
  }),
  
  add: (a: Color, b: Color): Color => ({
    r: Math.min(1, a.r + b.r),
    g: Math.min(1, a.g + b.g),
    b: Math.min(1, a.b + b.b),
    a: Math.min(1, a.a + b.a),
  }),
  
  scale: (c: Color, s: number): Color => ({
    r: Math.min(1, c.r * s),
    g: Math.min(1, c.g * s),
    b: Math.min(1, c.b * s),
    a: c.a,
  }),
  
  toLinear: (c: Color): Color => ({
    r: Math.pow(c.r, 2.2),
    g: Math.pow(c.g, 2.2),
    b: Math.pow(c.b, 2.2),
    a: c.a,
  }),
  
  toGamma: (c: Color): Color => ({
    r: Math.pow(c.r, 1 / 2.2),
    g: Math.pow(c.g, 1 / 2.2),
    b: Math.pow(c.b, 1 / 2.2),
    a: c.a,
  }),
};

// ═══════════════════════════════════════════════════════════════════════════════
// MATRIX 4x4
// ═══════════════════════════════════════════════════════════════════════════════

export type Matrix4 = Float32Array;  // 16 elements, column-major

export const mat4 = {
  identity: (): Matrix4 => new Float32Array([
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1,
  ]),
  
  translation: (x: number, y: number, z: number): Matrix4 => new Float32Array([
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    x, y, z, 1,
  ]),
  
  scaling: (x: number, y: number, z: number): Matrix4 => new Float32Array([
    x, 0, 0, 0,
    0, y, 0, 0,
    0, 0, z, 0,
    0, 0, 0, 1,
  ]),
  
  rotationX: (angle: number): Matrix4 => {
    const c = Math.cos(angle);
    const s = Math.sin(angle);
    return new Float32Array([
      1, 0, 0, 0,
      0, c, s, 0,
      0, -s, c, 0,
      0, 0, 0, 1,
    ]);
  },
  
  rotationY: (angle: number): Matrix4 => {
    const c = Math.cos(angle);
    const s = Math.sin(angle);
    return new Float32Array([
      c, 0, -s, 0,
      0, 1, 0, 0,
      s, 0, c, 0,
      0, 0, 0, 1,
    ]);
  },
  
  rotationZ: (angle: number): Matrix4 => {
    const c = Math.cos(angle);
    const s = Math.sin(angle);
    return new Float32Array([
      c, s, 0, 0,
      -s, c, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1,
    ]);
  },
  
  fromQuaternion: (q: Quaternion): Matrix4 => {
    const x = q.x, y = q.y, z = q.z, w = q.w;
    const x2 = x + x, y2 = y + y, z2 = z + z;
    const xx = x * x2, xy = x * y2, xz = x * z2;
    const yy = y * y2, yz = y * z2, zz = z * z2;
    const wx = w * x2, wy = w * y2, wz = w * z2;
    
    return new Float32Array([
      1 - (yy + zz), xy + wz, xz - wy, 0,
      xy - wz, 1 - (xx + zz), yz + wx, 0,
      xz + wy, yz - wx, 1 - (xx + yy), 0,
      0, 0, 0, 1,
    ]);
  },
  
  multiply: (a: Matrix4, b: Matrix4): Matrix4 => {
    const result = new Float32Array(16);
    for (let i = 0; i < 4; i++) {
      for (let j = 0; j < 4; j++) {
        result[j * 4 + i] =
          a[i] * b[j * 4] +
          a[i + 4] * b[j * 4 + 1] +
          a[i + 8] * b[j * 4 + 2] +
          a[i + 12] * b[j * 4 + 3];
      }
    }
    return result;
  },
  
  perspective: (fovY: number, aspect: number, near: number, far: number): Matrix4 => {
    const f = 1 / Math.tan(fovY / 2);
    const rangeInv = 1 / (near - far);
    
    return new Float32Array([
      f / aspect, 0, 0, 0,
      0, f, 0, 0,
      0, 0, (near + far) * rangeInv, -1,
      0, 0, near * far * rangeInv * 2, 0,
    ]);
  },
  
  orthographic: (left: number, right: number, bottom: number, top: number, near: number, far: number): Matrix4 => {
    const w = right - left;
    const h = top - bottom;
    const d = far - near;
    
    return new Float32Array([
      2 / w, 0, 0, 0,
      0, 2 / h, 0, 0,
      0, 0, -2 / d, 0,
      -(right + left) / w, -(top + bottom) / h, -(far + near) / d, 1,
    ]);
  },
  
  lookAt: (eye: Vec3, target: Vec3, up: Vec3): Matrix4 => {
    const z = vec3.normalize(vec3.sub(eye, target));
    const x = vec3.normalize(vec3.cross(up, z));
    const y = vec3.cross(z, x);
    
    return new Float32Array([
      x.x, y.x, z.x, 0,
      x.y, y.y, z.y, 0,
      x.z, y.z, z.z, 0,
      -vec3.dot(x, eye), -vec3.dot(y, eye), -vec3.dot(z, eye), 1,
    ]);
  },
  
  inverse: (m: Matrix4): Matrix4 => {
    const result = new Float32Array(16);
    
    const m00 = m[0], m01 = m[1], m02 = m[2], m03 = m[3];
    const m10 = m[4], m11 = m[5], m12 = m[6], m13 = m[7];
    const m20 = m[8], m21 = m[9], m22 = m[10], m23 = m[11];
    const m30 = m[12], m31 = m[13], m32 = m[14], m33 = m[15];
    
    const c00 = m22 * m33 - m32 * m23;
    const c02 = m12 * m33 - m32 * m13;
    const c03 = m12 * m23 - m22 * m13;
    const c04 = m21 * m33 - m31 * m23;
    const c06 = m11 * m33 - m31 * m13;
    const c07 = m11 * m23 - m21 * m13;
    const c08 = m21 * m32 - m31 * m22;
    const c10 = m11 * m32 - m31 * m12;
    const c11 = m11 * m22 - m21 * m12;
    const c12 = m20 * m33 - m30 * m23;
    const c14 = m10 * m33 - m30 * m13;
    const c15 = m10 * m23 - m20 * m13;
    const c16 = m20 * m32 - m30 * m22;
    const c18 = m10 * m32 - m30 * m12;
    const c19 = m10 * m22 - m20 * m12;
    const c20 = m20 * m31 - m30 * m21;
    const c22 = m10 * m31 - m30 * m11;
    const c23 = m10 * m21 - m20 * m11;
    
    const det = m00 * (m11 * c00 - m21 * c02 + m31 * c03) -
                m10 * (m01 * c00 - m21 * c04 + m31 * c06) +
                m20 * (m01 * c02 - m11 * c04 + m31 * c07) -
                m30 * (m01 * c03 - m11 * c06 + m21 * c07);
    
    if (Math.abs(det) < 1e-10) {
      return mat4.identity();
    }
    
    const invDet = 1 / det;
    
    result[0] = (m11 * c00 - m21 * c02 + m31 * c03) * invDet;
    result[1] = (-m01 * c00 + m21 * c04 - m31 * c06) * invDet;
    result[2] = (m01 * c02 - m11 * c04 + m31 * c07) * invDet;
    result[3] = (-m01 * c03 + m11 * c06 - m21 * c07) * invDet;
    result[4] = (-m10 * c00 + m20 * c02 - m30 * c03) * invDet;
    result[5] = (m00 * c00 - m20 * c04 + m30 * c06) * invDet;
    result[6] = (-m00 * c02 + m10 * c04 - m30 * c07) * invDet;
    result[7] = (m00 * c03 - m10 * c06 + m20 * c07) * invDet;
    result[8] = (m10 * c08 - m20 * c10 + m30 * c11) * invDet;
    result[9] = (-m00 * c08 + m20 * c12 - m30 * c16) * invDet;
    result[10] = (m00 * c10 - m10 * c12 + m30 * c19) * invDet;
    result[11] = (-m00 * c11 + m10 * c16 - m20 * c19) * invDet;
    result[12] = (-m10 * c14 + m20 * c18 - m30 * c19) * invDet;
    result[13] = (m00 * c14 - m20 * c20 + m30 * c22) * invDet;
    result[14] = (-m00 * c18 + m10 * c20 - m30 * c23) * invDet;
    result[15] = (m00 * c19 - m10 * c22 + m20 * c23) * invDet;
    
    return result;
  },
  
  transformPoint: (m: Matrix4, p: Vec3): Vec3 => {
    const w = m[3] * p.x + m[7] * p.y + m[11] * p.z + m[15];
    return {
      x: (m[0] * p.x + m[4] * p.y + m[8] * p.z + m[12]) / w,
      y: (m[1] * p.x + m[5] * p.y + m[9] * p.z + m[13]) / w,
      z: (m[2] * p.x + m[6] * p.y + m[10] * p.z + m[14]) / w,
    };
  },
  
  transformVector: (m: Matrix4, v: Vec3): Vec3 => ({
    x: m[0] * v.x + m[4] * v.y + m[8] * v.z,
    y: m[1] * v.x + m[5] * v.y + m[9] * v.z,
    z: m[2] * v.x + m[6] * v.y + m[10] * v.z,
  }),
};

// ═══════════════════════════════════════════════════════════════════════════════
// CAMERA
// ═══════════════════════════════════════════════════════════════════════════════

export type CameraType = 'Perspective' | 'Orthographic' | 'VR';

export interface Camera {
  id: string;
  type: CameraType;
  
  // Transform
  position: Vec3;
  rotation: Quaternion;
  target: Vec3 | null;
  
  // Perspective
  fov: number;            // degrees
  aspect: number;
  near: number;
  far: number;
  
  // Orthographic
  orthoSize: number;
  
  // Matrices (computed)
  viewMatrix: Matrix4;
  projectionMatrix: Matrix4;
  viewProjectionMatrix: Matrix4;
  
  // Frustum planes for culling
  frustumPlanes: { normal: Vec3; distance: number }[];
  
  // Effects
  exposure: number;
  dofEnabled: boolean;
  dofFocusDistance: number;
  dofAperture: number;
}

export function createCamera(type: CameraType = 'Perspective'): Camera {
  return {
    id: `camera_${Date.now().toString(36)}`,
    type,
    position: { x: 0, y: 10, z: -20 },
    rotation: quat.identity(),
    target: vec3.zero(),
    fov: 60,
    aspect: 16 / 9,
    near: 0.1,
    far: 10000,
    orthoSize: 10,
    viewMatrix: mat4.identity(),
    projectionMatrix: mat4.identity(),
    viewProjectionMatrix: mat4.identity(),
    frustumPlanes: [],
    exposure: 1,
    dofEnabled: false,
    dofFocusDistance: 10,
    dofAperture: 0.5,
  };
}

export function updateCamera(camera: Camera): void {
  // View matrix
  if (camera.target) {
    camera.viewMatrix = mat4.lookAt(camera.position, camera.target, { x: 0, y: 1, z: 0 });
  } else {
    const rotMat = mat4.fromQuaternion(quat.conjugate(camera.rotation));
    const transMat = mat4.translation(-camera.position.x, -camera.position.y, -camera.position.z);
    camera.viewMatrix = mat4.multiply(rotMat, transMat);
  }
  
  // Projection matrix
  const fovRad = camera.fov * Math.PI / 180;
  
  if (camera.type === 'Perspective' || camera.type === 'VR') {
    camera.projectionMatrix = mat4.perspective(fovRad, camera.aspect, camera.near, camera.far);
  } else {
    const halfHeight = camera.orthoSize;
    const halfWidth = halfHeight * camera.aspect;
    camera.projectionMatrix = mat4.orthographic(
      -halfWidth, halfWidth, -halfHeight, halfHeight, camera.near, camera.far
    );
  }
  
  // Combined
  camera.viewProjectionMatrix = mat4.multiply(camera.projectionMatrix, camera.viewMatrix);
  
  // Extract frustum planes
  extractFrustumPlanes(camera);
}

function extractFrustumPlanes(camera: Camera): void {
  const m = camera.viewProjectionMatrix;
  camera.frustumPlanes = [
    // Left
    {
      normal: vec3.normalize({ x: m[3] + m[0], y: m[7] + m[4], z: m[11] + m[8] }),
      distance: m[15] + m[12],
    },
    // Right
    {
      normal: vec3.normalize({ x: m[3] - m[0], y: m[7] - m[4], z: m[11] - m[8] }),
      distance: m[15] - m[12],
    },
    // Bottom
    {
      normal: vec3.normalize({ x: m[3] + m[1], y: m[7] + m[5], z: m[11] + m[9] }),
      distance: m[15] + m[13],
    },
    // Top
    {
      normal: vec3.normalize({ x: m[3] - m[1], y: m[7] - m[5], z: m[11] - m[9] }),
      distance: m[15] - m[13],
    },
    // Near
    {
      normal: vec3.normalize({ x: m[3] + m[2], y: m[7] + m[6], z: m[11] + m[10] }),
      distance: m[15] + m[14],
    },
    // Far
    {
      normal: vec3.normalize({ x: m[3] - m[2], y: m[7] - m[6], z: m[11] - m[10] }),
      distance: m[15] - m[14],
    },
  ];
}

export function isPointInFrustum(camera: Camera, point: Vec3): boolean {
  for (const plane of camera.frustumPlanes) {
    const distance = vec3.dot(plane.normal, point) + plane.distance;
    if (distance < 0) return false;
  }
  return true;
}

export function isSphereInFrustum(camera: Camera, center: Vec3, radius: number): boolean {
  for (const plane of camera.frustumPlanes) {
    const distance = vec3.dot(plane.normal, center) + plane.distance;
    if (distance < -radius) return false;
  }
  return true;
}

// ═══════════════════════════════════════════════════════════════════════════════
// LIGHTS
// ═══════════════════════════════════════════════════════════════════════════════

export type LightType = 'Directional' | 'Point' | 'Spot' | 'Area' | 'Ambient';

export interface Light {
  id: string;
  type: LightType;
  enabled: boolean;
  
  // Common
  color: Color3;
  intensity: number;
  castShadows: boolean;
  
  // Position/direction
  position: Vec3;
  direction: Vec3;
  
  // Point/Spot
  range: number;
  attenuation: { constant: number; linear: number; quadratic: number };
  
  // Spot
  innerConeAngle: number;  // degrees
  outerConeAngle: number;
  
  // Area
  areaSize: { width: number; height: number };
  
  // Shadows
  shadowMapSize: number;
  shadowBias: number;
  shadowNormalBias: number;
  shadowNear: number;
  shadowFar: number;
}

export function createDirectionalLight(direction: Vec3, color: Color3 = { r: 1, g: 1, b: 1 }): Light {
  return {
    id: `light_${Date.now().toString(36)}`,
    type: 'Directional',
    enabled: true,
    color,
    intensity: 1,
    castShadows: true,
    position: vec3.zero(),
    direction: vec3.normalize(direction),
    range: Infinity,
    attenuation: { constant: 1, linear: 0, quadratic: 0 },
    innerConeAngle: 0,
    outerConeAngle: 0,
    areaSize: { width: 0, height: 0 },
    shadowMapSize: 2048,
    shadowBias: 0.0001,
    shadowNormalBias: 0.01,
    shadowNear: 0.1,
    shadowFar: 1000,
  };
}

export function createPointLight(position: Vec3, color: Color3 = { r: 1, g: 1, b: 1 }, range: number = 10): Light {
  return {
    id: `light_${Date.now().toString(36)}`,
    type: 'Point',
    enabled: true,
    color,
    intensity: 1,
    castShadows: false,
    position,
    direction: vec3.zero(),
    range,
    attenuation: { constant: 1, linear: 0.09, quadratic: 0.032 },
    innerConeAngle: 0,
    outerConeAngle: 0,
    areaSize: { width: 0, height: 0 },
    shadowMapSize: 512,
    shadowBias: 0.0001,
    shadowNormalBias: 0.01,
    shadowNear: 0.1,
    shadowFar: range,
  };
}

export function createSpotLight(
  position: Vec3,
  direction: Vec3,
  innerAngle: number = 20,
  outerAngle: number = 30
): Light {
  return {
    id: `light_${Date.now().toString(36)}`,
    type: 'Spot',
    enabled: true,
    color: { r: 1, g: 1, b: 1 },
    intensity: 1,
    castShadows: true,
    position,
    direction: vec3.normalize(direction),
    range: 50,
    attenuation: { constant: 1, linear: 0.09, quadratic: 0.032 },
    innerConeAngle: innerAngle,
    outerConeAngle: outerAngle,
    areaSize: { width: 0, height: 0 },
    shadowMapSize: 1024,
    shadowBias: 0.0001,
    shadowNormalBias: 0.01,
    shadowNear: 0.1,
    shadowFar: 50,
  };
}

export function createAmbientLight(color: Color3 = { r: 0.1, g: 0.1, b: 0.15 }): Light {
  return {
    id: `light_${Date.now().toString(36)}`,
    type: 'Ambient',
    enabled: true,
    color,
    intensity: 1,
    castShadows: false,
    position: vec3.zero(),
    direction: vec3.zero(),
    range: Infinity,
    attenuation: { constant: 1, linear: 0, quadratic: 0 },
    innerConeAngle: 0,
    outerConeAngle: 0,
    areaSize: { width: 0, height: 0 },
    shadowMapSize: 0,
    shadowBias: 0,
    shadowNormalBias: 0,
    shadowNear: 0,
    shadowFar: 0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// MATERIALS AND SHADERS
// ═══════════════════════════════════════════════════════════════════════════════

export type ShaderType = 
  | 'PBR'
  | 'Unlit'
  | 'Terrain'
  | 'Water'
  | 'Sky'
  | 'Particle'
  | 'Custom';

export interface Texture {
  id: string;
  width: number;
  height: number;
  format: 'RGBA8' | 'RGB8' | 'RG8' | 'R8' | 'DEPTH24' | 'RGBA16F' | 'RGBA32F';
  wrapS: 'Repeat' | 'Clamp' | 'Mirror';
  wrapT: 'Repeat' | 'Clamp' | 'Mirror';
  minFilter: 'Nearest' | 'Linear' | 'NearestMipmap' | 'LinearMipmap';
  magFilter: 'Nearest' | 'Linear';
  anisotropy: number;
  generateMipmaps: boolean;
}

export interface Material {
  id: string;
  name: string;
  shader: ShaderType;
  
  // PBR properties
  albedo: Color;
  metallic: number;
  roughness: number;
  ao: number;
  emissive: Color3;
  emissiveIntensity: number;
  
  // Textures
  albedoMap: string | null;
  normalMap: string | null;
  metallicMap: string | null;
  roughnessMap: string | null;
  aoMap: string | null;
  emissiveMap: string | null;
  heightMap: string | null;
  
  // Texture transforms
  uvScale: { x: number; y: number };
  uvOffset: { x: number; y: number };
  
  // Rendering
  transparent: boolean;
  alphaTest: number;
  doubleSided: boolean;
  depthWrite: boolean;
  depthTest: boolean;
  blendMode: 'None' | 'Alpha' | 'Additive' | 'Multiply';
  
  // Terrain specific
  terrainLayers: { albedo: string; normal: string; scale: number }[];
  
  // Water specific
  waterDepth: number;
  waterClarity: number;
  waveStrength: number;
  waveSpeed: number;
}

export function createPBRMaterial(name: string): Material {
  return {
    id: `material_${Date.now().toString(36)}`,
    name,
    shader: 'PBR',
    albedo: color.white(),
    metallic: 0,
    roughness: 0.5,
    ao: 1,
    emissive: { r: 0, g: 0, b: 0 },
    emissiveIntensity: 0,
    albedoMap: null,
    normalMap: null,
    metallicMap: null,
    roughnessMap: null,
    aoMap: null,
    emissiveMap: null,
    heightMap: null,
    uvScale: { x: 1, y: 1 },
    uvOffset: { x: 0, y: 0 },
    transparent: false,
    alphaTest: 0,
    doubleSided: false,
    depthWrite: true,
    depthTest: true,
    blendMode: 'None',
    terrainLayers: [],
    waterDepth: 10,
    waterClarity: 0.5,
    waveStrength: 0.1,
    waveSpeed: 1,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// MESH AND GEOMETRY
// ═══════════════════════════════════════════════════════════════════════════════

export interface Vertex {
  position: Vec3;
  normal: Vec3;
  uv: { x: number; y: number };
  tangent?: Vec3;
  color?: Color;
}

export interface Mesh {
  id: string;
  name: string;
  vertices: Float32Array;
  indices: Uint32Array;
  vertexCount: number;
  indexCount: number;
  
  // Attribute layout
  hasNormals: boolean;
  hasUVs: boolean;
  hasTangents: boolean;
  hasColors: boolean;
  
  // Bounds
  boundingBox: { min: Vec3; max: Vec3 };
  boundingSphere: { center: Vec3; radius: number };
  
  // LOD
  lodLevels: { distance: number; meshId: string }[];
}

export function createBoxMesh(width: number = 1, height: number = 1, depth: number = 1): Mesh {
  const hw = width / 2, hh = height / 2, hd = depth / 2;
  
  // Vertices: position (3) + normal (3) + uv (2) = 8 floats per vertex
  const vertices = new Float32Array([
    // Front face
    -hw, -hh, hd,  0, 0, 1,  0, 0,
    hw, -hh, hd,   0, 0, 1,  1, 0,
    hw, hh, hd,    0, 0, 1,  1, 1,
    -hw, hh, hd,   0, 0, 1,  0, 1,
    
    // Back face
    hw, -hh, -hd,  0, 0, -1, 0, 0,
    -hw, -hh, -hd, 0, 0, -1, 1, 0,
    -hw, hh, -hd,  0, 0, -1, 1, 1,
    hw, hh, -hd,   0, 0, -1, 0, 1,
    
    // Top face
    -hw, hh, hd,   0, 1, 0,  0, 0,
    hw, hh, hd,    0, 1, 0,  1, 0,
    hw, hh, -hd,   0, 1, 0,  1, 1,
    -hw, hh, -hd,  0, 1, 0,  0, 1,
    
    // Bottom face
    -hw, -hh, -hd, 0, -1, 0, 0, 0,
    hw, -hh, -hd,  0, -1, 0, 1, 0,
    hw, -hh, hd,   0, -1, 0, 1, 1,
    -hw, -hh, hd,  0, -1, 0, 0, 1,
    
    // Right face
    hw, -hh, hd,   1, 0, 0,  0, 0,
    hw, -hh, -hd,  1, 0, 0,  1, 0,
    hw, hh, -hd,   1, 0, 0,  1, 1,
    hw, hh, hd,    1, 0, 0,  0, 1,
    
    // Left face
    -hw, -hh, -hd, -1, 0, 0, 0, 0,
    -hw, -hh, hd,  -1, 0, 0, 1, 0,
    -hw, hh, hd,   -1, 0, 0, 1, 1,
    -hw, hh, -hd,  -1, 0, 0, 0, 1,
  ]);
  
  const indices = new Uint32Array([
    0, 1, 2, 2, 3, 0,       // Front
    4, 5, 6, 6, 7, 4,       // Back
    8, 9, 10, 10, 11, 8,    // Top
    12, 13, 14, 14, 15, 12, // Bottom
    16, 17, 18, 18, 19, 16, // Right
    20, 21, 22, 22, 23, 20, // Left
  ]);
  
  return {
    id: `mesh_${Date.now().toString(36)}`,
    name: 'Box',
    vertices,
    indices,
    vertexCount: 24,
    indexCount: 36,
    hasNormals: true,
    hasUVs: true,
    hasTangents: false,
    hasColors: false,
    boundingBox: { min: { x: -hw, y: -hh, z: -hd }, max: { x: hw, y: hh, z: hd } },
    boundingSphere: { center: vec3.zero(), radius: Math.sqrt(hw * hw + hh * hh + hd * hd) },
    lodLevels: [],
  };
}

export function createSphereMesh(radius: number = 1, segments: number = 32): Mesh {
  const vertices: number[] = [];
  const indices: number[] = [];
  
  for (let lat = 0; lat <= segments; lat++) {
    const theta = lat * Math.PI / segments;
    const sinTheta = Math.sin(theta);
    const cosTheta = Math.cos(theta);
    
    for (let lon = 0; lon <= segments; lon++) {
      const phi = lon * 2 * Math.PI / segments;
      const sinPhi = Math.sin(phi);
      const cosPhi = Math.cos(phi);
      
      const x = cosPhi * sinTheta;
      const y = cosTheta;
      const z = sinPhi * sinTheta;
      
      const u = lon / segments;
      const v = lat / segments;
      
      // Position
      vertices.push(radius * x, radius * y, radius * z);
      // Normal
      vertices.push(x, y, z);
      // UV
      vertices.push(u, v);
    }
  }
  
  for (let lat = 0; lat < segments; lat++) {
    for (let lon = 0; lon < segments; lon++) {
      const first = lat * (segments + 1) + lon;
      const second = first + segments + 1;
      
      indices.push(first, second, first + 1);
      indices.push(second, second + 1, first + 1);
    }
  }
  
  return {
    id: `mesh_${Date.now().toString(36)}`,
    name: 'Sphere',
    vertices: new Float32Array(vertices),
    indices: new Uint32Array(indices),
    vertexCount: (segments + 1) * (segments + 1),
    indexCount: segments * segments * 6,
    hasNormals: true,
    hasUVs: true,
    hasTangents: false,
    hasColors: false,
    boundingBox: { min: { x: -radius, y: -radius, z: -radius }, max: { x: radius, y: radius, z: radius } },
    boundingSphere: { center: vec3.zero(), radius },
    lodLevels: [],
  };
}

export function createPlaneMesh(width: number = 10, depth: number = 10, segmentsX: number = 1, segmentsZ: number = 1): Mesh {
  const vertices: number[] = [];
  const indices: number[] = [];
  
  const hw = width / 2;
  const hd = depth / 2;
  const stepX = width / segmentsX;
  const stepZ = depth / segmentsZ;
  
  for (let z = 0; z <= segmentsZ; z++) {
    for (let x = 0; x <= segmentsX; x++) {
      const px = -hw + x * stepX;
      const pz = -hd + z * stepZ;
      
      // Position
      vertices.push(px, 0, pz);
      // Normal
      vertices.push(0, 1, 0);
      // UV
      vertices.push(x / segmentsX, z / segmentsZ);
    }
  }
  
  for (let z = 0; z < segmentsZ; z++) {
    for (let x = 0; x < segmentsX; x++) {
      const i = z * (segmentsX + 1) + x;
      indices.push(i, i + segmentsX + 1, i + 1);
      indices.push(i + 1, i + segmentsX + 1, i + segmentsX + 2);
    }
  }
  
  return {
    id: `mesh_${Date.now().toString(36)}`,
    name: 'Plane',
    vertices: new Float32Array(vertices),
    indices: new Uint32Array(indices),
    vertexCount: (segmentsX + 1) * (segmentsZ + 1),
    indexCount: segmentsX * segmentsZ * 6,
    hasNormals: true,
    hasUVs: true,
    hasTangents: false,
    hasColors: false,
    boundingBox: { min: { x: -hw, y: 0, z: -hd }, max: { x: hw, y: 0, z: hd } },
    boundingSphere: { center: vec3.zero(), radius: Math.sqrt(hw * hw + hd * hd) },
    lodLevels: [],
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// POST-PROCESSING
// ═══════════════════════════════════════════════════════════════════════════════

export interface PostProcessEffect {
  id: string;
  name: string;
  enabled: boolean;
  order: number;
}

export interface BloomEffect extends PostProcessEffect {
  name: 'Bloom';
  threshold: number;
  intensity: number;
  radius: number;
}

export interface TonemappingEffect extends PostProcessEffect {
  name: 'Tonemapping';
  mode: 'Reinhard' | 'ACES' | 'Filmic' | 'Uncharted2';
  exposure: number;
  gamma: number;
}

export interface DOFEffect extends PostProcessEffect {
  name: 'DOF';
  focusDistance: number;
  aperture: number;
  focalLength: number;
}

export interface SSAOEffect extends PostProcessEffect {
  name: 'SSAO';
  radius: number;
  intensity: number;
  bias: number;
}

export interface VignetteEffect extends PostProcessEffect {
  name: 'Vignette';
  intensity: number;
  smoothness: number;
  color: Color3;
}

export interface ChromaticAberrationEffect extends PostProcessEffect {
  name: 'ChromaticAberration';
  intensity: number;
}

export interface MotionBlurEffect extends PostProcessEffect {
  name: 'MotionBlur';
  intensity: number;
  samples: number;
}

export interface FogEffect extends PostProcessEffect {
  name: 'Fog';
  mode: 'Linear' | 'Exponential' | 'ExponentialSquared';
  color: Color3;
  density: number;
  start: number;
  end: number;
}

export type PostEffect = 
  | BloomEffect 
  | TonemappingEffect 
  | DOFEffect 
  | SSAOEffect 
  | VignetteEffect
  | ChromaticAberrationEffect
  | MotionBlurEffect
  | FogEffect;

// ═══════════════════════════════════════════════════════════════════════════════
// SKY AND ATMOSPHERE
// ═══════════════════════════════════════════════════════════════════════════════

export interface SkySettings {
  type: 'Procedural' | 'Skybox' | 'Gradient';
  
  // Procedural sky
  sunDirection: Vec3;
  sunIntensity: number;
  sunColor: Color3;
  sunSize: number;
  
  // Atmosphere
  rayleighCoefficient: Vec3;
  mieCoefficient: number;
  mieDirectionalG: number;
  atmosphereHeight: number;
  
  // Colors
  skyTint: Color3;
  groundColor: Color3;
  
  // Stars
  starsEnabled: boolean;
  starsIntensity: number;
  
  // Clouds
  cloudsEnabled: boolean;
  cloudCoverage: number;
  cloudSpeed: number;
  cloudColor: Color3;
  
  // Skybox
  skyboxTexture: string | null;
  skyboxRotation: number;
}

export function createDefaultSkySettings(): SkySettings {
  return {
    type: 'Procedural',
    sunDirection: vec3.normalize({ x: 0.5, y: 0.5, z: 0.5 }),
    sunIntensity: 1,
    sunColor: { r: 1, g: 0.95, b: 0.9 },
    sunSize: 0.04,
    rayleighCoefficient: { x: 5.5e-6, y: 13.0e-6, z: 22.4e-6 },
    mieCoefficient: 21e-6,
    mieDirectionalG: 0.76,
    atmosphereHeight: 8400,
    skyTint: { r: 0.5, g: 0.7, b: 1.0 },
    groundColor: { r: 0.37, g: 0.35, b: 0.35 },
    starsEnabled: true,
    starsIntensity: 1,
    cloudsEnabled: true,
    cloudCoverage: 0.5,
    cloudSpeed: 0.01,
    cloudColor: { r: 1, g: 1, b: 1 },
    skyboxTexture: null,
    skyboxRotation: 0,
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// SCENE GRAPH
// ═══════════════════════════════════════════════════════════════════════════════

export interface SceneNode {
  id: string;
  name: string;
  
  // Transform
  position: Vec3;
  rotation: Quaternion;
  scale: Vec3;
  worldMatrix: Matrix4;
  
  // Hierarchy
  parent: string | null;
  children: string[];
  
  // Rendering
  meshId: string | null;
  materialId: string | null;
  visible: boolean;
  castShadow: boolean;
  receiveShadow: boolean;
  
  // Culling
  frustumCulled: boolean;
  boundingSphere: { center: Vec3; radius: number };
}

export function createSceneNode(name: string): SceneNode {
  return {
    id: `node_${Date.now().toString(36)}_${Math.random().toString(36).substr(2, 5)}`,
    name,
    position: vec3.zero(),
    rotation: quat.identity(),
    scale: vec3.one(),
    worldMatrix: mat4.identity(),
    parent: null,
    children: [],
    meshId: null,
    materialId: null,
    visible: true,
    castShadow: true,
    receiveShadow: true,
    frustumCulled: true,
    boundingSphere: { center: vec3.zero(), radius: 1 },
  };
}

// ═══════════════════════════════════════════════════════════════════════════════
// RENDERING ENGINE
// ═══════════════════════════════════════════════════════════════════════════════

export interface RenderStats {
  drawCalls: number;
  triangles: number;
  vertices: number;
  textureBinds: number;
  shaderSwitches: number;
  frameTime: number;
  fps: number;
}

export class WorldRenderingEngine {
  // Resources
  private meshes: Map<string, Mesh> = new Map();
  private materials: Map<string, Material> = new Map();
  private textures: Map<string, Texture> = new Map();
  
  // Scene
  private nodes: Map<string, SceneNode> = new Map();
  private rootNodes: Set<string> = new Set();
  
  // Lights
  private lights: Map<string, Light> = new Map();
  
  // Cameras
  private cameras: Map<string, Camera> = new Map();
  private activeCamera: string | null = null;
  
  // Post-processing
  private postEffects: PostEffect[] = [];
  
  // Sky
  private skySettings: SkySettings;
  
  // Stats
  private stats: RenderStats = {
    drawCalls: 0,
    triangles: 0,
    vertices: 0,
    textureBinds: 0,
    shaderSwitches: 0,
    frameTime: 0,
    fps: 0,
  };
  
  private lastFrameTime: number = 0;
  
  constructor() {
    this.skySettings = createDefaultSkySettings();
    
    // Create default resources
    this.addMesh(createBoxMesh());
    this.addMesh(createSphereMesh());
    this.addMesh(createPlaneMesh());
    this.addMaterial(createPBRMaterial('default'));
    
    // Create default camera
    const camera = createCamera();
    this.addCamera(camera);
    this.activeCamera = camera.id;
    
    // Create default lights
    const sun = createDirectionalLight({ x: -0.5, y: -1, z: -0.5 });
    this.addLight(sun);
    
    const ambient = createAmbientLight();
    this.addLight(ambient);
  }
  
  // Resource management
  addMesh(mesh: Mesh): void {
    this.meshes.set(mesh.id, mesh);
  }
  
  getMesh(id: string): Mesh | undefined {
    return this.meshes.get(id);
  }
  
  addMaterial(material: Material): void {
    this.materials.set(material.id, material);
  }
  
  getMaterial(id: string): Material | undefined {
    return this.materials.get(id);
  }
  
  addTexture(texture: Texture): void {
    this.textures.set(texture.id, texture);
  }
  
  // Scene management
  addNode(node: SceneNode): void {
    this.nodes.set(node.id, node);
    if (!node.parent) {
      this.rootNodes.add(node.id);
    }
  }
  
  removeNode(id: string): void {
    const node = this.nodes.get(id);
    if (!node) return;
    
    // Remove from parent
    if (node.parent) {
      const parent = this.nodes.get(node.parent);
      if (parent) {
        parent.children = parent.children.filter(c => c !== id);
      }
    } else {
      this.rootNodes.delete(id);
    }
    
    // Remove children recursively
    for (const childId of node.children) {
      this.removeNode(childId);
    }
    
    this.nodes.delete(id);
  }
  
  getNode(id: string): SceneNode | undefined {
    return this.nodes.get(id);
  }
  
  setParent(nodeId: string, parentId: string | null): void {
    const node = this.nodes.get(nodeId);
    if (!node) return;
    
    // Remove from old parent
    if (node.parent) {
      const oldParent = this.nodes.get(node.parent);
      if (oldParent) {
        oldParent.children = oldParent.children.filter(c => c !== nodeId);
      }
    } else {
      this.rootNodes.delete(nodeId);
    }
    
    // Add to new parent
    node.parent = parentId;
    if (parentId) {
      const newParent = this.nodes.get(parentId);
      if (newParent) {
        newParent.children.push(nodeId);
      }
    } else {
      this.rootNodes.add(nodeId);
    }
  }
  
  // Lights
  addLight(light: Light): void {
    this.lights.set(light.id, light);
  }
  
  removeLight(id: string): void {
    this.lights.delete(id);
  }
  
  getLight(id: string): Light | undefined {
    return this.lights.get(id);
  }
  
  getAllLights(): Light[] {
    return Array.from(this.lights.values());
  }
  
  // Cameras
  addCamera(camera: Camera): void {
    this.cameras.set(camera.id, camera);
  }
  
  removeCamera(id: string): void {
    this.cameras.delete(id);
    if (this.activeCamera === id) {
      this.activeCamera = null;
    }
  }
  
  setActiveCamera(id: string): void {
    if (this.cameras.has(id)) {
      this.activeCamera = id;
    }
  }
  
  getActiveCamera(): Camera | null {
    return this.activeCamera ? this.cameras.get(this.activeCamera) ?? null : null;
  }
  
  // Post-processing
  addPostEffect(effect: PostEffect): void {
    this.postEffects.push(effect);
    this.postEffects.sort((a, b) => a.order - b.order);
  }
  
  removePostEffect(id: string): void {
    this.postEffects = this.postEffects.filter(e => e.id !== id);
  }
  
  // Sky
  setSkySettings(settings: Partial<SkySettings>): void {
    this.skySettings = { ...this.skySettings, ...settings };
  }
  
  getSkySettings(): SkySettings {
    return this.skySettings;
  }
  
  // Rendering
  updateWorldMatrices(): void {
    // Update root nodes first
    for (const rootId of this.rootNodes) {
      this.updateNodeWorldMatrix(rootId, mat4.identity());
    }
  }
  
  private updateNodeWorldMatrix(nodeId: string, parentMatrix: Matrix4): void {
    const node = this.nodes.get(nodeId);
    if (!node) return;
    
    // Build local matrix
    const T = mat4.translation(node.position.x, node.position.y, node.position.z);
    const R = mat4.fromQuaternion(node.rotation);
    const S = mat4.scaling(node.scale.x, node.scale.y, node.scale.z);
    
    const localMatrix = mat4.multiply(mat4.multiply(T, R), S);
    node.worldMatrix = mat4.multiply(parentMatrix, localMatrix);
    
    // Update children
    for (const childId of node.children) {
      this.updateNodeWorldMatrix(childId, node.worldMatrix);
    }
  }
  
  render(): RenderStats {
    const startTime = performance.now();
    
    // Reset stats
    this.stats.drawCalls = 0;
    this.stats.triangles = 0;
    this.stats.vertices = 0;
    this.stats.textureBinds = 0;
    this.stats.shaderSwitches = 0;
    
    // Update camera
    const camera = this.getActiveCamera();
    if (camera) {
      updateCamera(camera);
    }
    
    // Update world matrices
    this.updateWorldMatrices();
    
    // Frustum culling
    const visibleNodes: SceneNode[] = [];
    for (const node of this.nodes.values()) {
      if (!node.visible || !node.meshId) continue;
      
      if (node.frustumCulled && camera) {
        const worldCenter = mat4.transformPoint(node.worldMatrix, node.boundingSphere.center);
        if (!isSphereInFrustum(camera, worldCenter, node.boundingSphere.radius)) {
          continue;
        }
      }
      
      visibleNodes.push(node);
    }
    
    // Sort for rendering (opaque front-to-back, transparent back-to-front)
    if (camera) {
      visibleNodes.sort((a, b) => {
        const matA = a.materialId ? this.materials.get(a.materialId) : null;
        const matB = b.materialId ? this.materials.get(b.materialId) : null;
        
        const transA = matA?.transparent ?? false;
        const transB = matB?.transparent ?? false;
        
        if (transA !== transB) return transA ? 1 : -1;
        
        const distA = vec3.distance(mat4.transformPoint(a.worldMatrix, vec3.zero()), camera.position);
        const distB = vec3.distance(mat4.transformPoint(b.worldMatrix, vec3.zero()), camera.position);
        
        return transA ? distB - distA : distA - distB;
      });
    }
    
    // Simulate rendering each node
    for (const node of visibleNodes) {
      const mesh = node.meshId ? this.meshes.get(node.meshId) : null;
      if (mesh) {
        this.stats.drawCalls++;
        this.stats.triangles += mesh.indexCount / 3;
        this.stats.vertices += mesh.vertexCount;
      }
    }
    
    // Calculate frame time
    const endTime = performance.now();
    this.stats.frameTime = endTime - startTime;
    
    // Calculate FPS
    const deltaTime = endTime - this.lastFrameTime;
    this.stats.fps = deltaTime > 0 ? 1000 / deltaTime : 60;
    this.lastFrameTime = endTime;
    
    return { ...this.stats };
  }
  
  getStats(): RenderStats {
    return { ...this.stats };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXPORT SINGLETON
// ═══════════════════════════════════════════════════════════════════════════════

export const worldRenderer = new WorldRenderingEngine();
