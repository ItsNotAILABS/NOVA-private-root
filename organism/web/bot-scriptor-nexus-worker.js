'use strict';

self.onmessage = function(event) {
  var data = event.data || {};
  var started = Date.now();
  var stage = data.stage || 'DRAFT';
  var cadence = (data.payload && data.payload.cadence) || 'Weekly';
  setTimeout(function() {
    self.postMessage({
      stage: stage,
      latencyMs: Date.now() - started,
      message: 'Journal sections synthesized (' + cadence + ' cadence)'
    });
  }, 110);
};
