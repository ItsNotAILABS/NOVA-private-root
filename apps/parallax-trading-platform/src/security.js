import crypto from 'node:crypto';
import { config } from './config.js';

export function secureEqual(a, b) {
  const left = Buffer.from(String(a || ''));
  const right = Buffer.from(String(b || ''));
  return left.length === right.length && crypto.timingSafeEqual(left, right);
}

export function signWebhook(rawBody) {
  return crypto.createHmac('sha256', config.tradingview.secret).update(rawBody).digest('hex');
}

export function verifyTradingView(rawBody, headers) {
  const token = headers['x-parallax-webhook-token'];
  const signature = String(headers['x-parallax-signature'] || '').replace(/^sha256=/, '');
  if (config.tradingview.token && secureEqual(token, config.tradingview.token)) return { ok:true, method:'token' };
  if (config.tradingview.secret && secureEqual(signature, signWebhook(rawBody))) return { ok:true, method:'hmac-sha256' };
  return { ok:false, method:null };
}

export function securityHeaders() {
  return {
    'x-content-type-options':'nosniff',
    'x-frame-options':'SAMEORIGIN',
    'referrer-policy':'strict-origin-when-cross-origin',
    'permissions-policy':'camera=(), microphone=(), geolocation=()',
    'content-security-policy':"default-src 'self'; script-src 'self' https://s3.tradingview.com; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; frame-src https://www.tradingview.com https://s.tradingview.com; connect-src 'self'; font-src 'self' data:"
  };
}
