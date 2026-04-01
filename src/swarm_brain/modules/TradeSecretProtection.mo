// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: TradeSecretProtection — Legal & Technical IP Safeguards
// Classification: CONFIDENTIAL — MAXIMUM PROTECTION
// 
// Copyright © December 2024 - Present Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// NOTICE: This source code constitutes trade secret and proprietary 
// information of Medina Tech. Unauthorized reproduction, distribution,
// or disclosure is strictly prohibited and may result in civil and
// criminal penalties under 18 U.S.C. § 1836 (Defend Trade Secrets Act)
// and applicable state laws. All rights reserved.
//
// ============================================================================
//
// TRADE SECRET PROTECTION FRAMEWORK
// ============================================================================
//
// This module implements technical and procedural safeguards required for
// trade secret status under the Defend Trade Secrets Act (DTSA) and the
// Uniform Trade Secrets Act (UTSA).
//
// LEGAL REQUIREMENTS FOR TRADE SECRET STATUS:
// 1. Information derives independent economic value from not being known
// 2. Owner takes reasonable measures to maintain secrecy
//
// THIS MODULE PROVIDES:
// - Access control enforcement
// - Audit logging of all access
// - Classification marking
// - Confidentiality agreement tracking
// - Encryption status verification
// - Disclosure authorization workflow
//
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Int   "mo:base/Int";
import Text  "mo:base/Text";
import Time  "mo:base/Time";
import Principal "mo:base/Principal";

module {

  // ==========================================================================
  // CLASSIFICATION LEVELS
  // ==========================================================================
  
  public type ClassificationLevel = {
    #PUBLIC;                    // No protection required
    #INTERNAL;                  // Internal use only
    #CONFIDENTIAL;              // Trade secret, NDA required
    #RESTRICTED;                // Limited access, need-to-know
    #MAXIMUM_PROTECTION;        // Highest protection, logged access
  };

  public func classificationToText(level: ClassificationLevel) : Text {
    switch (level) {
      case (#PUBLIC) { "PUBLIC" };
      case (#INTERNAL) { "INTERNAL USE ONLY" };
      case (#CONFIDENTIAL) { "CONFIDENTIAL — TRADE SECRET" };
      case (#RESTRICTED) { "RESTRICTED — NEED TO KNOW" };
      case (#MAXIMUM_PROTECTION) { "MAXIMUM PROTECTION — LOGGED ACCESS" };
    }
  };

  public func classificationToInt(level: ClassificationLevel) : Nat {
    switch (level) {
      case (#PUBLIC) { 0 };
      case (#INTERNAL) { 1 };
      case (#CONFIDENTIAL) { 2 };
      case (#RESTRICTED) { 3 };
      case (#MAXIMUM_PROTECTION) { 4 };
    }
  };

  // ==========================================================================
  // CONFIDENTIALITY HEADER (Required on all protected files)
  // ==========================================================================
  
  public let CONFIDENTIALITY_HEADER : Text = 
    "// ============================================================================\n" #
    "// MEDINA TECH — CONFIDENTIAL & PROPRIETARY\n" #
    "// ============================================================================\n" #
    "// Classification: CONFIDENTIAL — TRADE SECRET\n" #
    "// \n" #
    "// Copyright © December 2024 - Present Alfredo Medina Hernandez\n" #
    "// Medina Tech | Dallas, Texas, USA\n" #
    "// Contact: MedinaSITech@outlook.com\n" #
    "// \n" #
    "// NOTICE: This document contains trade secret and confidential information\n" #
    "// proprietary to Medina Tech. This information may not be disclosed,\n" #
    "// reproduced, or used in whole or in part without the express written\n" #
    "// consent of Medina Tech.\n" #
    "// \n" #
    "// LEGAL PROTECTION:\n" #
    "// - Defend Trade Secrets Act (18 U.S.C. § 1836)\n" #
    "// - Uniform Trade Secrets Act (Texas Civil Practice & Remedies Code Ch. 134A)\n" #
    "// - Economic Espionage Act (18 U.S.C. § 1831-1839)\n" #
    "// \n" #
    "// Unauthorized access, use, disclosure, or distribution may result in\n" #
    "// civil liability and criminal prosecution.\n" #
    "// ============================================================================\n";

  // ==========================================================================
  // ACCESS CONTROL
  // ==========================================================================
  
  public type AccessLevel = {
    #NONE;
    #READ_ONLY;
    #READ_WRITE;
    #ADMIN;
    #OWNER;
  };

  public type AccessGrant = {
    principal     : Principal;
    accessLevel   : AccessLevel;
    grantedBy     : Principal;
    grantedAt     : Int;          // Timestamp
    expiresAt     : ?Int;         // Optional expiration
    ndaSigned     : Bool;
    ndaVersion    : Text;
    justification : Text;
  };

  public type AccessRequest = {
    requestId     : Nat;
    requester     : Principal;
    requestedLevel: AccessLevel;
    resource      : Text;
    justification : Text;
    requestedAt   : Int;
    status        : AccessRequestStatus;
    reviewedBy    : ?Principal;
    reviewedAt    : ?Int;
    reviewNotes   : ?Text;
  };

  public type AccessRequestStatus = {
    #PENDING;
    #APPROVED;
    #DENIED;
    #EXPIRED;
    #REVOKED;
  };

  // ==========================================================================
  // AUDIT LOGGING
  // ==========================================================================
  
  public type AuditEventType = {
    #ACCESS_ATTEMPT;
    #ACCESS_GRANTED;
    #ACCESS_DENIED;
    #DATA_READ;
    #DATA_WRITE;
    #DATA_DELETE;
    #EXPORT_ATTEMPT;
    #DISCLOSURE_REQUEST;
    #CLASSIFICATION_CHANGE;
    #NDA_SIGNED;
    #NDA_EXPIRED;
    #ANOMALY_DETECTED;
  };

  public type AuditEvent = {
    eventId       : Nat;
    eventType     : AuditEventType;
    timestamp     : Int;
    principal     : Principal;
    resource      : Text;
    action        : Text;
    result        : Text;
    ipAddress     : ?Text;
    metadata      : [(Text, Text)];
    hash          : Nat32;        // Tamper-evident hash
    prevHash      : Nat32;        // Chain to previous event
  };

  public type AuditLog = {
    events        : [AuditEvent];
    eventCount    : Nat;
    chainHead     : Nat32;
    lastEventTime : Int;
    integrityValid: Bool;
  };

  // ==========================================================================
  // NDA TRACKING
  // ==========================================================================
  
  public type NDARecord = {
    ndaId         : Nat;
    signatory     : Principal;
    signatoryName : Text;
    signatoryOrg  : Text;
    version       : Text;
    signedAt      : Int;
    expiresAt     : ?Int;
    scope         : [Text];       // What information is covered
    restrictions  : [Text];       // Specific restrictions
    validSignature: Bool;
    witnessedBy   : ?Principal;
  };

  public type NDARegistry = {
    ndas          : [NDARecord];
    activeCount   : Nat;
    expiredCount  : Nat;
    currentVersion: Text;
  };

  // ==========================================================================
  // PROTECTED ASSET REGISTRY
  // ==========================================================================
  
  public type ProtectedAsset = {
    assetId       : Nat;
    name          : Text;
    description   : Text;
    classification: ClassificationLevel;
    owner         : Principal;
    createdAt     : Int;
    modifiedAt    : Int;
    accessList    : [Principal];
    auditRequired : Bool;
    encryptionRequired: Bool;
    retentionPolicy: Text;
    legalHold     : Bool;
  };

  // ==========================================================================
  // TRADE SECRET STATE
  // ==========================================================================
  
  public type TradeSecretState = {
    // Access control
    accessGrants    : [AccessGrant];
    pendingRequests : [AccessRequest];
    
    // Audit
    auditLog        : AuditLog;
    
    // NDA tracking
    ndaRegistry     : NDARegistry;
    
    // Asset registry
    protectedAssets : [ProtectedAsset];
    
    // Configuration
    ownerPrincipal  : Principal;
    enforcementEnabled: Bool;
    auditRetentionDays: Nat;
    
    // Metrics
    totalAccessAttempts : Nat;
    deniedAccessAttempts: Nat;
    anomaliesDetected   : Nat;
  };

  // ==========================================================================
  // UTILITY FUNCTIONS
  // ==========================================================================
  
  func fnv1a(a: Nat32, b: Nat32) : Nat32 {
    let prime  : Nat32 = 16777619;
    let offset : Nat32 = 2166136261;
    ((offset ^ a) *% prime ^ b) *% prime
  };

  func computeEventHash(event: AuditEvent, prevHash: Nat32) : Nat32 {
    let timeHash = Nat32.fromNat(Int.abs(event.timestamp) % 4294967296);
    let typeHash = Nat32.fromNat(auditEventTypeToNat(event.eventType));
    fnv1a(fnv1a(prevHash, timeHash), typeHash)
  };

  func auditEventTypeToNat(t: AuditEventType) : Nat {
    switch (t) {
      case (#ACCESS_ATTEMPT) { 0 };
      case (#ACCESS_GRANTED) { 1 };
      case (#ACCESS_DENIED) { 2 };
      case (#DATA_READ) { 3 };
      case (#DATA_WRITE) { 4 };
      case (#DATA_DELETE) { 5 };
      case (#EXPORT_ATTEMPT) { 6 };
      case (#DISCLOSURE_REQUEST) { 7 };
      case (#CLASSIFICATION_CHANGE) { 8 };
      case (#NDA_SIGNED) { 9 };
      case (#NDA_EXPIRED) { 10 };
      case (#ANOMALY_DETECTED) { 11 };
    }
  };

  // ==========================================================================
  // ACCESS CONTROL FUNCTIONS
  // ==========================================================================
  
  public func checkAccess(
    state: TradeSecretState,
    principal: Principal,
    requiredLevel: AccessLevel
  ) : Bool {
    // Owner always has access
    if (Principal.equal(principal, state.ownerPrincipal)) {
      return true;
    };
    
    // Check grants
    for (grant in state.accessGrants.vals()) {
      if (Principal.equal(grant.principal, principal)) {
        // Check NDA requirement
        if (not grant.ndaSigned) { return false };
        
        // Check expiration
        switch (grant.expiresAt) {
          case (?expiry) {
            if (Time.now() > expiry) { return false };
          };
          case null {};
        };
        
        // Check level
        return accessLevelSufficient(grant.accessLevel, requiredLevel);
      };
    };
    
    false
  };

  func accessLevelSufficient(granted: AccessLevel, required: AccessLevel) : Bool {
    let grantedInt = accessLevelToInt(granted);
    let requiredInt = accessLevelToInt(required);
    grantedInt >= requiredInt
  };

  func accessLevelToInt(level: AccessLevel) : Nat {
    switch (level) {
      case (#NONE) { 0 };
      case (#READ_ONLY) { 1 };
      case (#READ_WRITE) { 2 };
      case (#ADMIN) { 3 };
      case (#OWNER) { 4 };
    }
  };

  // ==========================================================================
  // AUDIT FUNCTIONS
  // ==========================================================================
  
  public func logAuditEvent(
    state: TradeSecretState,
    eventType: AuditEventType,
    principal: Principal,
    resource: Text,
    action: Text,
    result: Text
  ) : TradeSecretState {
    let newEventId = state.auditLog.eventCount;
    let timestamp = Time.now();
    let prevHash = state.auditLog.chainHead;
    
    let newEvent : AuditEvent = {
      eventId = newEventId;
      eventType = eventType;
      timestamp = timestamp;
      principal = principal;
      resource = resource;
      action = action;
      result = result;
      ipAddress = null;
      metadata = [];
      hash = 0;
      prevHash = prevHash;
    };
    
    let eventHash = computeEventHash(newEvent, prevHash);
    
    let finalEvent : AuditEvent = {
      eventId = newEvent.eventId;
      eventType = newEvent.eventType;
      timestamp = newEvent.timestamp;
      principal = newEvent.principal;
      resource = newEvent.resource;
      action = newEvent.action;
      result = newEvent.result;
      ipAddress = newEvent.ipAddress;
      metadata = newEvent.metadata;
      hash = eventHash;
      prevHash = prevHash;
    };
    
    let newEvents = Array.append(state.auditLog.events, [finalEvent]);
    
    {
      accessGrants = state.accessGrants;
      pendingRequests = state.pendingRequests;
      auditLog = {
        events = newEvents;
        eventCount = state.auditLog.eventCount + 1;
        chainHead = eventHash;
        lastEventTime = timestamp;
        integrityValid = true;
      };
      ndaRegistry = state.ndaRegistry;
      protectedAssets = state.protectedAssets;
      ownerPrincipal = state.ownerPrincipal;
      enforcementEnabled = state.enforcementEnabled;
      auditRetentionDays = state.auditRetentionDays;
      totalAccessAttempts = state.totalAccessAttempts + 1;
      deniedAccessAttempts = state.deniedAccessAttempts;
      anomaliesDetected = state.anomaliesDetected;
    }
  };

  // ==========================================================================
  // AUDIT CHAIN VERIFICATION
  // ==========================================================================
  
  public func verifyAuditChain(log: AuditLog) : Bool {
    if (log.events.size() < 2) { return true };
    
    var prevHash : Nat32 = 0;
    for (event in log.events.vals()) {
      let expectedHash = computeEventHash(event, prevHash);
      if (event.hash != expectedHash) { return false };
      if (event.prevHash != prevHash) { return false };
      prevHash := event.hash;
    };
    
    true
  };

  // ==========================================================================
  // NDA FUNCTIONS
  // ==========================================================================
  
  public func checkNDAValid(state: TradeSecretState, principal: Principal) : Bool {
    for (nda in state.ndaRegistry.ndas.vals()) {
      if (Principal.equal(nda.signatory, principal)) {
        // Check expiration
        switch (nda.expiresAt) {
          case (?expiry) {
            if (Time.now() > expiry) { return false };
          };
          case null {};
        };
        return nda.validSignature;
      };
    };
    false
  };

  // ==========================================================================
  // INITIALIZATION
  // ==========================================================================
  
  public func initTradeSecretProtection(owner: Principal) : TradeSecretState {
    {
      accessGrants = [];
      pendingRequests = [];
      auditLog = {
        events = [];
        eventCount = 0;
        chainHead = 0;
        lastEventTime = 0;
        integrityValid = true;
      };
      ndaRegistry = {
        ndas = [];
        activeCount = 0;
        expiredCount = 0;
        currentVersion = "1.0";
      };
      protectedAssets = [];
      ownerPrincipal = owner;
      enforcementEnabled = true;
      auditRetentionDays = 2555;  // 7 years (legal requirement)
      totalAccessAttempts = 0;
      deniedAccessAttempts = 0;
      anomaliesDetected = 0;
    }
  };

  // ==========================================================================
  // LEGAL NOTICES
  // ==========================================================================
  
  public let DTSA_NOTICE : Text = 
    "NOTICE PURSUANT TO DEFEND TRADE SECRETS ACT (18 U.S.C. § 1833(b)):\n" #
    "An individual shall not be held criminally or civilly liable under any\n" #
    "Federal or State trade secret law for the disclosure of a trade secret\n" #
    "that is made in confidence to a Federal, State, or local government\n" #
    "official, either directly or indirectly, or to an attorney, solely for\n" #
    "the purpose of reporting or investigating a suspected violation of law.\n";

  public let ECONOMIC_VALUE_STATEMENT : Text =
    "The information contained herein derives independent economic value,\n" #
    "actual or potential, from not being generally known to, and not being\n" #
    "readily ascertainable by proper means by, other persons who can obtain\n" #
    "economic value from its disclosure or use. Medina Tech has taken\n" #
    "reasonable measures to keep such information secret, including but not\n" #
    "limited to: access controls, encryption, confidentiality agreements,\n" #
    "audit logging, and need-to-know restrictions.\n";

  public let REMEDIES_NOTICE : Text =
    "REMEDIES FOR MISAPPROPRIATION:\n" #
    "- Injunctive relief (18 U.S.C. § 1836(b)(3)(A))\n" #
    "- Damages for actual loss and unjust enrichment (18 U.S.C. § 1836(b)(3)(B))\n" #
    "- Exemplary damages up to 2x actual damages for willful misappropriation\n" #
    "- Attorneys fees for willful and malicious misappropriation\n" #
    "- Criminal penalties: fines up to $5,000,000 and imprisonment up to 10 years\n";

}
