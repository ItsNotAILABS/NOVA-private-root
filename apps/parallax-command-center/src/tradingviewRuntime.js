import crypto from 'node:crypto';
import { createId } from './state.js';

const safeEqual = (a, b) => {
  const left = Buffer.from(String(a || ''));
  const right = Buffer.from(String(b || ''));
  return left.length === right.length && crypto.timingSafeEqual(left, right);
};

export function verifyTradingViewRequest({ rawBody, headers, config }) {
  const token