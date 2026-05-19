/* eslint-env worker */
'use strict';

self.onmessage = function (event) {
  var payload = event.data || {};
  if (payload.type !== 'run') return;

  var blocks = ['hypothesis matrix', 'experimental design', 'replication protocol'];
  var summary = 'Structured methodology blocks: ' + blocks.join(' | ');
  self.postMessage({ type: 'result', botId: 'BOT-DRL-002', summary: summary, score: 0.94, stage: payload.stage });
};
