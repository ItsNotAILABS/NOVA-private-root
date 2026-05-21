/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Notification Worker (GOK-NOTIFY-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-NOTIFY-001
 * Kernel Family:  EVENT_DISPATCH
 * Architecture:   Pub/Sub × Priority Queue × Delivery Tracking × Webhook Dispatch
 *
 * Sovereign notification engine for the NOVA organism. Provides topic-based
 * publish/subscribe messaging, priority-sorted notification queuing, webhook
 * dispatch simulation with retry semantics, per-delivery tracking, and
 * per-topic rate limiting. All dispatches are φ-coupled to the organism pulse.
 *
 * Features:
 *   • Pub/sub: topic-based subscribe, unsubscribe, and publish
 *   • Priority queue: critical > high > normal > low notification ordering
 *   • Delivery tracking: sent → delivered → read (or failed) lifecycle
 *   • Webhook simulation: register endpoints with headers and retry policies
 *   • Rate limiting: per-topic max-per-minute throttle with auto-reset
 *   • Unique delivery IDs for every dispatched notification
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'subscribe', topic, subscriberId }
 *   Main → Worker: { type: 'unsubscribe', topic, subscriberId }
 *   Main → Worker: { type: 'publish', topic, payload, priority }
 *   Main → Worker: { type: 'register-webhook', id, url, topic, headers }
 *   Main → Worker: { type: 'dispatch-webhook', webhookId, payload }
 *   Main → Worker: { type: 'delivery-status', deliveryId }
 *   Main → Worker: { type: 'set-rate-limit', topic, maxPerMinute }
 *   Main → Worker: { type: 'list-topics' }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'subscribed', topic, subscriberId, totalSubscribers, kernelId }
 *   Worker → Main: { type: 'unsubscribed', topic, subscriberId, totalSubscribers, kernelId }
 *   Worker → Main: { type: 'published', topic, deliveryId, subscriberCount, priority, kernelId }
 *   Worker → Main: { type: 'webhook-registered', id, topic, kernelId }
 *   Worker → Main: { type: 'webhook-dispatched', webhookId, deliveryId, status, kernelId }
 *   Worker → Main: { type: 'delivery-report', deliveryId, status, kernelId }
 *   Worker → Main: { type: 'topic-list', topics, kernelId }
 *   Worker → Main: { type: 'heartbeat', ... }
 *
 * COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.
 * MEDINA TECH — SOVEREIGN KERNEL ARCHITECTURE
 */
/* ════════════════════════════════════════════════════════════════
   KERNEL CONSTANTS
   ════════════════════════════════════════════════════════════════ */

var PHI       = 1.6180339887498948482;
var PHI_INV   = 0.6180339887498948482;
var HEARTBEAT = 873;

var KERNEL_ID      = 'GOK-NOTIFY-001';
var KERNEL_FAMILY  = 'EVENT_DISPATCH';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;
/* ════════════════════════════════════════════════════════════════
   DATA STRUCTURES
   ════════════════════════════════════════════════════════════════ */

var topics      = {};   // topic → { subscribers: [], messages: [] }
var webhooks    = {};   // id → { url, topic, headers, retries }
var deliveries  = {};   // deliveryId → { status, timestamp, retries }
var rateLimits  = {};   // topic → { maxPerMinute, count, resetAt }
var notifQueue  = [];   // priority queue of notifications

var PRIORITY_LEVELS = { critical: 4, high: 3, normal: 2, low: 1 };

var deliverySeq = 0;
/* ════════════════════════════════════════════════════════════════
   DELIVERY ID GENERATOR
   ════════════════════════════════════════════════════════════════ */
function generateDeliveryId() {
  deliverySeq++;
  return 'dlv-' + Date.now().toString(36) + '-' + deliverySeq.toString(36) + '-' + beatCount.toString(36);
}
/* ════════════════════════════════════════════════════════════════
   TOPIC MANAGEMENT
   ════════════════════════════════════════════════════════════════ */
function ensureTopic(topic) {
  if (!topics[topic]) {
    topics[topic] = { subscribers: [], messages: [] };
  }
  return topics[topic];
}
/* ════════════════════════════════════════════════════════════════
   PUB/SUB — SUBSCRIBE / UNSUBSCRIBE / PUBLISH
   ════════════════════════════════════════════════════════════════ */
function subscribe(topic, subscriberId) {
  var t = ensureTopic(topic);
  if (t.subscribers.indexOf(subscriberId) === -1) {
    t.subscribers.push(subscriberId);
  }
  return {
    topic: topic,
    subscriberId: subscriberId,
    totalSubscribers: t.subscribers.length,
  };
}

function unsubscribe(topic, subscriberId) {
  var t = ensureTopic(topic);
  var idx = t.subscribers.indexOf(subscriberId);
  if (idx !== -1) {
    t.subscribers.splice(idx, 1);
  }
  return {
    topic: topic,
    subscriberId: subscriberId,
    totalSubscribers: t.subscribers.length,
  };
}

function publish(topic, payload, priority) {
  var t = ensureTopic(topic);
  var prio = priority || 'normal';
  var level = PRIORITY_LEVELS[prio] || PRIORITY_LEVELS.normal;

  if (!checkRateLimit(topic)) {
    return null;
  }

  var deliveryId = generateDeliveryId();

  var message = {
    deliveryId: deliveryId,
    topic: topic,
    payload: payload,
    priority: prio,
    level: level,
    timestamp: Date.now(),
    subscriberCount: t.subscribers.length,
  };

  t.messages.push(message);

  deliveries[deliveryId] = {
    status: 'sent',
    timestamp: Date.now(),
    retries: 0,
    topic: topic,
    priority: prio,
  };

  enqueueNotification(message);

  if (rateLimits[topic]) {
    rateLimits[topic].count++;
  }

  return {
    topic: topic,
    deliveryId: deliveryId,
    subscriberCount: t.subscribers.length,
    priority: prio,
  };
}
/* ════════════════════════════════════════════════════════════════
   PRIORITY QUEUE
   ════════════════════════════════════════════════════════════════ */
function enqueueNotification(notification) {
  var inserted = false;
  for (var i = 0; i < notifQueue.length; i++) {
    if (notification.level > notifQueue[i].level) {
      notifQueue.splice(i, 0, notification);
      inserted = true;
      break;
    }
  }
  if (!inserted) {
    notifQueue.push(notification);
  }
}

function dequeueNext() {
  if (notifQueue.length === 0) return null;
  return notifQueue.shift();
}
/* ════════════════════════════════════════════════════════════════
   DELIVERY TRACKING
   ════════════════════════════════════════════════════════════════ */
function trackDelivery(deliveryId, status) {
  var record = deliveries[deliveryId];
  if (!record) return null;
  var validStatuses = ['sent', 'delivered', 'read', 'failed'];
  if (validStatuses.indexOf(status) === -1) return null;
  record.status = status;
  record.timestamp = Date.now();
  if (status === 'failed') {
    record.retries++;
  }
  return record;
}

function getDeliveryStatus(deliveryId) {
  return deliveries[deliveryId] || null;
}
/* ════════════════════════════════════════════════════════════════
   WEBHOOK SIMULATION
   ════════════════════════════════════════════════════════════════ */
function registerWebhook(id, config) {
  var hook = {
    id: id,
    url: config.url || '',
    topic: config.topic || '',
    headers: config.headers || {},
    retries: config.retries || 3,
    dispatches: 0,
    lastDispatch: 0,
    createdAt: Date.now(),
  };
  webhooks[id] = hook;

  if (hook.topic) {
    subscribe(hook.topic, 'webhook:' + id);
  }

  return hook;
}

// φ-weighted success probability (~62% base) with retries
function dispatchWebhook(webhookId, payload) {
  var hook = webhooks[webhookId];
  if (!hook) return null;

  var deliveryId = generateDeliveryId();
  var success = Math.random() < PHI_INV;
  var attempt = 0;
  var maxRetries = hook.retries;

  while (!success && attempt < maxRetries) {
    attempt++;
    success = Math.random() < (PHI_INV + attempt * 0.1);
  }

  var status = success ? 'delivered' : 'failed';

  deliveries[deliveryId] = {
    status: status,
    timestamp: Date.now(),
    retries: attempt,
    topic: hook.topic,
    priority: 'normal',
    webhookId: webhookId,
    url: hook.url,
  };

  hook.dispatches++;
  hook.lastDispatch = Date.now();

  return {
    webhookId: webhookId,
    deliveryId: deliveryId,
    status: status,
    retries: attempt,
    url: hook.url,
  };
}
/* ════════════════════════════════════════════════════════════════
   RATE LIMITING
   ════════════════════════════════════════════════════════════════ */
function setRateLimit(topic, maxPerMinute) {
  rateLimits[topic] = {
    maxPerMinute: maxPerMinute,
    count: 0,
    resetAt: Date.now() + 60000,
  };
}

function checkRateLimit(topic) {
  var rl = rateLimits[topic];
  if (!rl) return true;

  var now = Date.now();
  if (now >= rl.resetAt) {
    rl.count = 0;
    rl.resetAt = now + 60000;
  }

  return rl.count < rl.maxPerMinute;
}
/* ════════════════════════════════════════════════════════════════
   QUEUE DRAIN — process queued notifications each heartbeat
   ════════════════════════════════════════════════════════════════ */
function drainQueue() {
  var batchSize = Math.max(1, Math.floor(PHI * 3));
  var processed = 0;
  while (processed < batchSize) {
    var notif = dequeueNext();
    if (!notif) break;
    trackDelivery(notif.deliveryId, 'delivered');
    processed++;
  }
}
/* ════════════════════════════════════════════════════════════════
   MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {

    case 'subscribe': {
      var subResult = subscribe(msg.topic, msg.subscriberId);
      self.postMessage({
        type: 'subscribed',
        topic: subResult.topic,
        subscriberId: subResult.subscriberId,
        totalSubscribers: subResult.totalSubscribers,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'unsubscribe': {
      var unsubResult = unsubscribe(msg.topic, msg.subscriberId);
      self.postMessage({
        type: 'unsubscribed',
        topic: unsubResult.topic,
        subscriberId: unsubResult.subscriberId,
        totalSubscribers: unsubResult.totalSubscribers,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'publish': {
      var pubResult = publish(msg.topic, msg.payload, msg.priority);
      if (pubResult) {
        self.postMessage({
          type: 'published',
          topic: pubResult.topic,
          deliveryId: pubResult.deliveryId,
          subscriberCount: pubResult.subscriberCount,
          priority: pubResult.priority,
          kernelId: KERNEL_ID,
        });
      } else {
        self.postMessage({
          type: 'rate-limited',
          topic: msg.topic,
          kernelId: KERNEL_ID,
        });
      }
      break;
    }

    case 'register-webhook': {
      var hook = registerWebhook(msg.id, {
        url: msg.url,
        topic: msg.topic,
        headers: msg.headers,
        retries: msg.retries,
      });
      self.postMessage({
        type: 'webhook-registered',
        id: hook.id,
        topic: hook.topic,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'dispatch-webhook': {
      var dispResult = dispatchWebhook(msg.webhookId, msg.payload);
      if (dispResult) {
        self.postMessage({
          type: 'webhook-dispatched',
          webhookId: dispResult.webhookId,
          deliveryId: dispResult.deliveryId,
          status: dispResult.status,
          retries: dispResult.retries,
          kernelId: KERNEL_ID,
        });
      }
      break;
    }

    case 'delivery-status': {
      var record = getDeliveryStatus(msg.deliveryId);
      self.postMessage({
        type: 'delivery-report',
        deliveryId: msg.deliveryId,
        status: record ? record.status : 'unknown',
        retries: record ? record.retries : 0,
        timestamp: record ? record.timestamp : null,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'set-rate-limit': {
      setRateLimit(msg.topic, msg.maxPerMinute);
      self.postMessage({
        type: 'rate-limit-set',
        topic: msg.topic,
        maxPerMinute: msg.maxPerMinute,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'list-topics': {
      var topicNames = Object.keys(topics);
      var topicSummaries = [];
      for (var i = 0; i < topicNames.length; i++) {
        var name = topicNames[i];
        topicSummaries.push({
          name: name,
          subscribers: topics[name].subscribers.length,
          messages: topics[name].messages.length,
        });
      }
      self.postMessage({
        type: 'topic-list',
        topics: topicSummaries,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      var allTopics = Object.keys(topics);
      var totalSubs = 0;
      for (var s = 0; s < allTopics.length; s++) {
        totalSubs += topics[allTopics[s]].subscribers.length;
      }
      self.postMessage({
        type: 'notify-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalTopics: allTopics.length,
        totalSubscribers: totalSubs,
        totalDeliveries: Object.keys(deliveries).length,
        totalWebhooks: Object.keys(webhooks).length,
        queueLength: notifQueue.length,
        beat: beatCount,
        phase: kernelPhase,
        phi: PHI,
      });
      break;
    }

    case 'stop': {
      running = false;
      clearInterval(_hbi);
      self.postMessage({ type: 'stopped', kernelId: KERNEL_ID });
      break;
    }
  }
};
/* ════════════════════════════════════════════════════════════════
   φ-COUPLED HEARTBEAT — 873ms Kuramoto pulse
   ════════════════════════════════════════════════════════════════ */

var _hbi = setInterval(function() {
  if (!running) return;
  beatCount++;
  kernelPhase += PHI_INV;
  if (kernelPhase > 2 * Math.PI) kernelPhase -= 2 * Math.PI;

  drainQueue();

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
  });
}, HEARTBEAT);
