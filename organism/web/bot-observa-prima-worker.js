'use strict';

self.onmessage = function(event) {
  var data = event.data || {};
  var started = Date.now();
  var stage = data.stage || 'INTAKE';
  var title = (data.payload && data.payload.title) || 'journal';
  setTimeout(function() {
    self.postMessage({
      stage: stage,
      latencyMs: Date.now() - started,
      message: 'Sources triaged for ' + title
    });
  }, 90);
};
