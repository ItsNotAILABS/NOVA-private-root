'use strict';

self.onmessage = function(event) {
  var data = event.data || {};
  var started = Date.now();
  var stage = data.stage || 'DEPLOY_READY';
  var owner = (data.payload && data.payload.owner) || 'operations';
  setTimeout(function() {
    self.postMessage({
      stage: stage,
      latencyMs: Date.now() - started,
      message: 'Post-deploy monitor armed for ' + owner
    });
  }, 105);
};
