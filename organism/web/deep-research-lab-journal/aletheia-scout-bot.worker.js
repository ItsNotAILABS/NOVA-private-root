/* eslint-env worker */
'use strict';

self.onmessage = function (event) {
  var payload = event.data || {};
  if (payload.type !== 'run') return;

  var sources = ['arXiv corpus', 'lab notebook records', 'peer benchmark datasets'];
  var summary = 'Prioritized sources: ' + sources.join(', ');
  self.postMessage({ type: 'result', botId: 'BOT-DRL-001', summary: summary, score: 0.96, stage: payload.stage });
};
