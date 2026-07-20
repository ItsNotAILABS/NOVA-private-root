import crypto from 'node:crypto';

const listeners = new Map();
const historyLimit = 1000;

function topicMatches(pattern, topic) {
  if (pattern === '*' || pattern === topic) return true;
  if (pattern.endsWith('.*')) return topic.startsWith(pattern.slice(0, -1));
  return false;
}

export function createEventBus({ getState, save }) {
  const emit = async (topic, payload = {}, metadata = {}) => {
    const state = getState();
    state.events ||= [];
    const event = {
      id:`evt_${crypto.randomUUID().replaceAll('-', '').slice(0, 20)}`,
      topic,
      payload,
      metadata,
      created_at:new Date().toISOString()
    };
    state.events.push(event);
    if (state.events.length > historyLimit) state.events.splice(0, state.events.length - historyLimit);
    await save();
    const pending = [];
    for (const [pattern, handlers] of listeners.entries()) {
      if (!topicMatches(pattern, topic)) continue;
      for (const handler of handlers) pending.push(Promise.resolve().then(() => handler(event)));
    }
    await Promise.allSettled(pending);
    return event;
  };

  const subscribe = (pattern, handler) => {
    const set = listeners.get(pattern) || new Set();
    set.add(handler);
    listeners.set(pattern, set);
    return () => set.delete(handler);
  };

  const query = ({ topic, limit = 100, after } = {}) => {
    const state = getState();
    let rows = [...(state.events || [])];
    if (topic) rows = rows.filter(event => topicMatches(topic, event.topic));
    if (after) rows = rows.filter(event => event.created_at > after);
    return rows.slice(-Math.min(Math.max(Number(limit) || 100, 1), 500)).reverse();
  };

  return { emit, subscribe, query };
}
