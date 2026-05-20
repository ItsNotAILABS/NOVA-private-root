'use strict';

self.onmessage = function(event) {
  var data = event.data || {};
  var started = Date.now();
  var stage = data.stage || 'PACKAGE';
  var env = (data.payload && data.payload.environment) || 'github-pages';
  setTimeout(function() {
    self.postMessage({
      stage: stage,
      latencyMs: Date.now() - started,
      message: 'Deployment package prepared for ' + env
    });
  }, 95);
};
