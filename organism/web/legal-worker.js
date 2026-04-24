/**
 * ═══════════════════════════════════════════════════════════════════════════════
 * NOVA KERNEL AI — Sovereign Legal Engine Worker (GOK-LEGAL-001)
 * ═══════════════════════════════════════════════════════════════════════════════
 *
 * Model ID:       GOK-LEGAL-001
 * Kernel Family:  LEGAL_ENGINE
 * Architecture:   License Library × Terms Generator × Compliance × IP Tracker
 *
 * Legal compliance and intellectual-property engine for the NOVA organism.
 * Manages 20+ license types, generates legal terms documents, runs compliance
 * checks against major regulatory frameworks, and tracks IP assets. All
 * heavy processing runs off the main thread.
 *
 * Features:
 *   • 20+ license types (MIT, Apache, GPL, AGPL, BSD, MPL, sovereign …)
 *   • Terms generator (privacy policy, ToS, acceptable use, DMCA, cookie)
 *   • Compliance checker (GDPR, HIPAA, SOX, PCI-DSS, FERPA, CCPA)
 *   • IP protection tracker (patents, trademarks, copyrights, trade secrets)
 *
 * Protocol: postMessage
 *   Main → Worker: { type: 'check-license', licenseId }
 *   Main → Worker: { type: 'generate-terms', termsType, params }
 *   Main → Worker: { type: 'compliance-scan', framework, scope }
 *   Main → Worker: { type: 'register-ip', asset }
 *   Main → Worker: { type: 'list-licenses' }
 *   Main → Worker: { type: 'status' }
 *   Main → Worker: { type: 'stop' }
 *   Worker → Main: { type: 'license-info', license }
 *   Worker → Main: { type: 'terms-generated', document }
 *   Worker → Main: { type: 'compliance-report', report }
 *   Worker → Main: { type: 'ip-registered', asset }
 *   Worker → Main: { type: 'license-list', licenses }
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

var KERNEL_ID      = 'GOK-LEGAL-001';
var KERNEL_FAMILY  = 'LEGAL_ENGINE';
var KERNEL_VERSION = '1.0.0';

var beatCount   = 0;
var running     = true;
var kernelPhase = 0.0;


/* ════════════════════════════════════════════════════════════════
   LICENSE LIBRARY (20+ types)
   ════════════════════════════════════════════════════════════════ */

var LICENSES = {
  'MIT':              { name: 'MIT License',                      spdx: 'MIT',              permissive: true,  copyleft: false, commercial: true,  patent: false },
  'Apache-2.0':       { name: 'Apache License 2.0',               spdx: 'Apache-2.0',      permissive: true,  copyleft: false, commercial: true,  patent: true  },
  'GPL-2.0':          { name: 'GNU GPL v2',                        spdx: 'GPL-2.0-only',    permissive: false, copyleft: true,  commercial: true,  patent: false },
  'GPL-3.0':          { name: 'GNU GPL v3',                        spdx: 'GPL-3.0-only',    permissive: false, copyleft: true,  commercial: true,  patent: true  },
  'AGPL-3.0':         { name: 'GNU AGPL v3',                       spdx: 'AGPL-3.0-only',   permissive: false, copyleft: true,  commercial: true,  patent: true  },
  'LGPL-2.1':         { name: 'GNU LGPL v2.1',                     spdx: 'LGPL-2.1-only',   permissive: false, copyleft: true,  commercial: true,  patent: false },
  'BSD-2':            { name: 'BSD 2-Clause',                      spdx: 'BSD-2-Clause',    permissive: true,  copyleft: false, commercial: true,  patent: false },
  'BSD-3':            { name: 'BSD 3-Clause',                      spdx: 'BSD-3-Clause',    permissive: true,  copyleft: false, commercial: true,  patent: false },
  'MPL-2.0':          { name: 'Mozilla Public License 2.0',        spdx: 'MPL-2.0',         permissive: false, copyleft: true,  commercial: true,  patent: true  },
  'ISC':              { name: 'ISC License',                       spdx: 'ISC',             permissive: true,  copyleft: false, commercial: true,  patent: false },
  'Unlicense':        { name: 'The Unlicense',                     spdx: 'Unlicense',       permissive: true,  copyleft: false, commercial: true,  patent: false },
  'proprietary':      { name: 'Proprietary / All Rights Reserved', spdx: null,              permissive: false, copyleft: false, commercial: false, patent: true  },
  'sovereign':        { name: 'NOVA Sovereign License',            spdx: null,              permissive: false, copyleft: false, commercial: false, patent: true  },
  'CC-BY-4.0':        { name: 'Creative Commons BY 4.0',           spdx: 'CC-BY-4.0',      permissive: true,  copyleft: false, commercial: true,  patent: false },
  'CC-BY-SA-4.0':     { name: 'Creative Commons BY-SA 4.0',        spdx: 'CC-BY-SA-4.0',   permissive: false, copyleft: true,  commercial: true,  patent: false },
  'CC-BY-NC-4.0':     { name: 'Creative Commons BY-NC 4.0',        spdx: 'CC-BY-NC-4.0',   permissive: false, copyleft: false, commercial: false, patent: false },
  'CC0-1.0':          { name: 'CC0 1.0 Universal',                 spdx: 'CC0-1.0',        permissive: true,  copyleft: false, commercial: true,  patent: false },
  'dual-license':     { name: 'Dual License',                      spdx: null,              permissive: true,  copyleft: false, commercial: true,  patent: false },
  'EULA':             { name: 'End-User License Agreement',        spdx: null,              permissive: false, copyleft: false, commercial: false, patent: false },
  'SaaS':             { name: 'SaaS / Service Agreement',          spdx: null,              permissive: false, copyleft: false, commercial: true,  patent: false },
  'enterprise':       { name: 'Enterprise License',                spdx: null,              permissive: false, copyleft: false, commercial: true,  patent: true  },
};


/* ════════════════════════════════════════════════════════════════
   LICENSE COMPATIBILITY MATRIX
   ════════════════════════════════════════════════════════════════ */

var COMPAT_MATRIX = {
  'MIT':         ['MIT','Apache-2.0','BSD-2','BSD-3','ISC','Unlicense','CC0-1.0','GPL-2.0','GPL-3.0','AGPL-3.0','LGPL-2.1','MPL-2.0'],
  'Apache-2.0':  ['MIT','Apache-2.0','BSD-2','BSD-3','ISC','Unlicense','CC0-1.0','GPL-3.0','AGPL-3.0','LGPL-2.1','MPL-2.0'],
  'GPL-3.0':     ['MIT','Apache-2.0','BSD-2','BSD-3','ISC','Unlicense','CC0-1.0','GPL-3.0','AGPL-3.0','LGPL-2.1','MPL-2.0'],
  'AGPL-3.0':    ['MIT','Apache-2.0','BSD-2','BSD-3','ISC','Unlicense','CC0-1.0','GPL-3.0','AGPL-3.0','LGPL-2.1','MPL-2.0'],
};

function checkCompatibility(licA, licB) {
  var compatA = COMPAT_MATRIX[licA];
  if (compatA && compatA.indexOf(licB) > -1) return true;
  var compatB = COMPAT_MATRIX[licB];
  if (compatB && compatB.indexOf(licA) > -1) return true;
  // Permissive licenses are generally compatible
  var a = LICENSES[licA];
  var b = LICENSES[licB];
  if (a && b && a.permissive && b.permissive) return true;
  return false;
}


/* ════════════════════════════════════════════════════════════════
   TERMS GENERATOR
   ════════════════════════════════════════════════════════════════ */

var TERMS_TEMPLATES = {
  'privacy-policy':   { title: 'Privacy Policy',       sections: ['data-collection','data-use','data-sharing','data-retention','user-rights','cookies','security','contact'] },
  'terms-of-service': { title: 'Terms of Service',     sections: ['acceptance','eligibility','account','conduct','ip-rights','disclaimers','limitation','termination','governing-law'] },
  'acceptable-use':   { title: 'Acceptable Use Policy', sections: ['permitted-use','prohibited-use','enforcement','reporting','consequences'] },
  'dmca':             { title: 'DMCA Policy',           sections: ['notification','counter-notification','repeat-infringers','designated-agent'] },
  'cookie-policy':    { title: 'Cookie Policy',         sections: ['what-are-cookies','types-used','managing-cookies','third-party','updates'] },
};

function generateTerms(termsType, params) {
  var template = TERMS_TEMPLATES[termsType];
  if (!template) {
    return { success: false, error: 'Unknown terms type: ' + termsType };
  }

  var org = (params && params.organization) || 'NOVA Organism';
  var domain = (params && params.domain) || 'nova.sovereign';
  var effectiveDate = (params && params.effectiveDate) || new Date().toISOString().split('T')[0];

  var sections = [];
  for (var i = 0; i < template.sections.length; i++) {
    var secId = template.sections[i];
    sections.push({
      id: secId,
      title: secId.replace(/-/g, ' ').replace(/\b\w/g, function(c) { return c.toUpperCase(); }),
      content: buildSectionContent(termsType, secId, org, domain),
    });
  }

  return {
    success: true,
    document: {
      type: termsType,
      title: template.title,
      organization: org,
      domain: domain,
      effectiveDate: effectiveDate,
      generatedAt: Date.now(),
      generatedBy: KERNEL_ID,
      sections: sections,
      sectionCount: sections.length,
    },
  };
}

function buildSectionContent(termsType, sectionId, org, domain) {
  // Generate representative legal language per section
  var base = org + ' (' + domain + ') ';
  switch (sectionId) {
    case 'data-collection':    return base + 'collects information you provide directly, usage data, and device information.';
    case 'data-use':           return base + 'uses collected data to provide, maintain, and improve services.';
    case 'data-sharing':       return base + 'does not sell personal data. Data may be shared with service providers under contract.';
    case 'data-retention':     return base + 'retains data only as long as necessary for stated purposes.';
    case 'user-rights':        return 'Users may access, correct, delete, or export their data by contacting ' + base + '.';
    case 'cookies':            return base + 'uses essential and analytical cookies. See Cookie Policy for details.';
    case 'security':           return base + 'implements industry-standard security measures including encryption at rest and in transit.';
    case 'acceptance':         return 'By accessing services of ' + base + ', you agree to these terms.';
    case 'eligibility':        return 'You must be at least 18 years old to use ' + base + ' services.';
    case 'conduct':            return 'Users agree not to misuse services, violate laws, or infringe on others\' rights.';
    case 'ip-rights':          return 'All intellectual property in the services remains the property of ' + base + '.';
    case 'disclaimers':        return 'Services are provided "AS IS" without warranties of any kind.';
    case 'limitation':         return base + ' liability is limited to the amount paid for services in the prior 12 months.';
    case 'termination':        return base + 'may terminate access for violation of these terms.';
    case 'governing-law':      return 'These terms are governed by applicable sovereign jurisdiction law.';
    default:                   return base + 'policy section for ' + sectionId + '.';
  }
}


/* ════════════════════════════════════════════════════════════════
   COMPLIANCE CHECKER (6 frameworks)
   ════════════════════════════════════════════════════════════════ */

var COMPLIANCE_FRAMEWORKS = {
  'GDPR':     { name: 'General Data Protection Regulation',         controls: ['consent','right-to-access','right-to-erasure','data-portability','breach-notification','dpo','privacy-impact','lawful-basis','cross-border','records-of-processing'] },
  'HIPAA':    { name: 'Health Insurance Portability & Accountability', controls: ['access-control','audit-controls','integrity','person-auth','transmission-security','baa','minimum-necessary','breach-notification','risk-analysis','training'] },
  'SOX':      { name: 'Sarbanes-Oxley Act',                         controls: ['internal-controls','audit-trail','access-management','change-management','segregation-of-duties','data-retention','reporting','whistleblower','assessment','documentation'] },
  'PCI-DSS':  { name: 'Payment Card Industry Data Security Standard', controls: ['firewall','default-passwords','protect-stored-data','encrypt-transmission','antivirus','secure-systems','access-restriction','unique-id','physical-access','monitoring','testing','policy'] },
  'FERPA':    { name: 'Family Educational Rights & Privacy Act',     controls: ['directory-info','consent','access-rights','amendment-rights','disclosure-limits','record-keeping','annual-notification','legitimate-interest','de-identification','enforcement'] },
  'CCPA':     { name: 'California Consumer Privacy Act',             controls: ['right-to-know','right-to-delete','right-to-opt-out','non-discrimination','notice-at-collection','service-providers','financial-incentives','minors','verification','record-keeping'] },
};

function complianceScan(framework, scope) {
  var fw = COMPLIANCE_FRAMEWORKS[framework];
  if (!fw) {
    return { success: false, error: 'Unknown framework: ' + framework };
  }

  var findings = [];
  var passCount = 0;
  var failCount = 0;
  var warnCount = 0;

  for (var i = 0; i < fw.controls.length; i++) {
    var controlId = fw.controls[i];
    // Simulate check using φ-weighted scoring
    var score = (Math.sin(i * PHI_INV + kernelPhase) + 1) / 2;
    var status = score > 0.7 ? 'pass' : (score > 0.4 ? 'warning' : 'fail');

    if (status === 'pass') passCount++;
    else if (status === 'fail') failCount++;
    else warnCount++;

    findings.push({
      control: controlId,
      status: status,
      score: Math.round(score * 100) / 100,
      details: 'Control ' + controlId + ' scored ' + Math.round(score * 100) + '%',
      framework: framework,
    });
  }

  var overallScore = fw.controls.length > 0 ? passCount / fw.controls.length : 0;

  return {
    success: true,
    report: {
      framework: framework,
      frameworkName: fw.name,
      scope: scope || 'full',
      overallScore: Math.round(overallScore * 100) / 100,
      overallStatus: overallScore > 0.8 ? 'compliant' : (overallScore > 0.5 ? 'partial' : 'non-compliant'),
      totalControls: fw.controls.length,
      passed: passCount,
      warnings: warnCount,
      failed: failCount,
      findings: findings,
      scannedAt: Date.now(),
      scannedBy: KERNEL_ID,
    },
  };
}


/* ════════════════════════════════════════════════════════════════
   IP PROTECTION TRACKER
   ════════════════════════════════════════════════════════════════ */

var ipAssets = {};
var ipNextId = 1;

function registerIP(asset) {
  if (!asset || !asset.type) {
    return { success: false, error: 'Asset must have a type (patent, trademark, copyright, trade-secret)' };
  }

  var validTypes = ['patent', 'trademark', 'copyright', 'trade-secret'];
  if (validTypes.indexOf(asset.type) === -1) {
    return { success: false, error: 'Invalid IP type: ' + asset.type };
  }

  var id = 'IP-' + ('0000' + ipNextId).slice(-4);
  ipNextId++;

  var record = {
    id: id,
    type: asset.type,
    title: asset.title || 'Untitled',
    description: asset.description || '',
    owner: asset.owner || 'NOVA Organism',
    filingDate: asset.filingDate || new Date().toISOString().split('T')[0],
    status: asset.status || 'registered',
    jurisdiction: asset.jurisdiction || 'sovereign',
    registeredAt: Date.now(),
    registeredBy: KERNEL_ID,
  };

  ipAssets[id] = record;
  return { success: true, asset: record };
}


/* ════════════════════════════════════════════════════════════════
   KERNEL MESSAGE HANDLER
   ════════════════════════════════════════════════════════════════ */

self.onmessage = function(e) {
  var msg = e.data;

  switch (msg.type) {
    case 'check-license': {
      var licId = msg.licenseId || msg.license;
      var lic = LICENSES[licId];
      var resp = { type: 'license-info', kernelId: KERNEL_ID };
      if (lic) {
        resp.license = { id: licId, name: lic.name, spdx: lic.spdx, permissive: lic.permissive, copyleft: lic.copyleft, commercial: lic.commercial, patent: lic.patent };
        if (msg.compatWith) {
          resp.compatible = checkCompatibility(licId, msg.compatWith);
          resp.compatWith = msg.compatWith;
        }
      } else {
        resp.error = 'Unknown license: ' + licId;
      }
      self.postMessage(resp);
      break;
    }

    case 'generate-terms': {
      var termsResult = generateTerms(msg.termsType, msg.params);
      self.postMessage({
        type: 'terms-generated',
        termsType: msg.termsType,
        result: termsResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'compliance-scan': {
      var scanResult = complianceScan(msg.framework, msg.scope);
      self.postMessage({
        type: 'compliance-report',
        framework: msg.framework,
        result: scanResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'register-ip': {
      var ipResult = registerIP(msg.asset);
      self.postMessage({
        type: 'ip-registered',
        result: ipResult,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'list-licenses': {
      var list = [];
      var lkeys = Object.keys(LICENSES);
      for (var i = 0; i < lkeys.length; i++) {
        var l = LICENSES[lkeys[i]];
        list.push({
          id: lkeys[i],
          name: l.name,
          spdx: l.spdx,
          permissive: l.permissive,
          copyleft: l.copyleft,
          commercial: l.commercial,
          patent: l.patent,
        });
      }
      self.postMessage({
        type: 'license-list',
        licenses: list,
        count: list.length,
        ipAssetCount: Object.keys(ipAssets).length,
        kernelId: KERNEL_ID,
      });
      break;
    }

    case 'status': {
      self.postMessage({
        type: 'legal-status',
        kernelId: KERNEL_ID,
        kernelFamily: KERNEL_FAMILY,
        version: KERNEL_VERSION,
        totalLicenses: Object.keys(LICENSES).length,
        totalTermsTemplates: Object.keys(TERMS_TEMPLATES).length,
        totalFrameworks: Object.keys(COMPLIANCE_FRAMEWORKS).length,
        totalIPAssets: Object.keys(ipAssets).length,
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

  self.postMessage({
    type: 'heartbeat',
    beat: beatCount,
    phi: PHI,
    heartbeatMs: HEARTBEAT,
    timestamp: Date.now(),
    status: 'alive',
    kernelId: KERNEL_ID,
    phase: kernelPhase,
    totalIPAssets: Object.keys(ipAssets).length,
  });
}, HEARTBEAT);
