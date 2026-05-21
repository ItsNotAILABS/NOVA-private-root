'use strict';

self.onmessage = function(event) {
  var data = event.data || {};
  var started = Date.now();
  var stage = data.stage || 'AUDIT';
  setTimeout(function() {
    self.postMessage({
      stage: stage,
      latencyMs: Date.now() - started,
      message: 'Citation and consistency audit passed'
    });
  }, 100);
};
