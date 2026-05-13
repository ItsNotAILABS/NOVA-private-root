import test from 'node:test';
import assert from 'node:assert/strict';
import { QUERY_TYPES, QUERY_STATUS, InternalQueries, ExternalQueries, QueryRecord } from './index.js';

test('InternalQueries returns provider state through query executor', async () => {
  const queries = new InternalQueries();
  queries.registerStateProvider('profile', () => ({ name: 'NOVA' }));

  const result = await queries.query('state:profile', {});
  assert.deepEqual(result, { name: 'NOVA' });
});

test('ExternalQueries tracks auth-requirement contract', () => {
  const queries = new ExternalQueries();
  queries.register('public:status', async () => ({ ok: true }));
  queries.register('private:status', async () => ({ ok: true }), { authRequired: true });

  assert.equal(queries.requiresAuth('public:status'), false);
  assert.equal(queries.requiresAuth('private:status'), true);
});

test('QueryRecord transitions to CACHED and FAILED states', () => {
  const cached = new QueryRecord(QUERY_TYPES.CACHE, 'path', {}, 'sdk');
  cached.complete({ value: 1 }, true);
  assert.equal(cached.status, QUERY_STATUS.CACHED);
  assert.equal(cached.cached, true);

  const failed = new QueryRecord(QUERY_TYPES.EXTERNAL, 'path', {}, 'user');
  failed.fail(new Error('boom'));
  assert.equal(failed.status, QUERY_STATUS.FAILED);
});
