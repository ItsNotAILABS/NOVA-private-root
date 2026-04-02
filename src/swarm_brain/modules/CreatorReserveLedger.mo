// ╔═══════════════════════════════════════════════════════════════════════════════════════════════════════════╗
// ║                                                                                                           ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.                                    ║
// ║                                                                                                           ║
// ║  INTELLECTUAL PROPERTY NOTICE                                                                             ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  Owner:        Alfredo Medina Hernandez                                                                   ║
// ║  Location:     Dallas, Texas, United States of America                                                    ║
// ║  Contact:      MedinaSITech@outlook.com                                                                   ║
// ║  Framework:    Medina Doctrine                                                                            ║
// ║                                                                                                           ║
// ║  LEGAL PROTECTION                                                                                         ║
// ║  ─────────────────────────────────────────────────────────────────────────────────────────────────────── ║
// ║  This source code, including all algorithms, mathematical formulations, architectural designs,            ║
// ║  naming conventions, data structures, and conceptual frameworks contained herein, constitutes             ║
// ║  the exclusive intellectual property of Alfredo Medina Hernandez.                                        ║
// ║                                                                                                           ║
// ║  PROTECTED UNDER:                                                                                         ║
// ║  • United States Copyright Law (17 U.S.C. §§ 101-1332)                                                   ║
// ║  • Berne Convention for the Protection of Literary and Artistic Works                                     ║
// ║  • WIPO Copyright Treaty (WCT)                                                                            ║
// ║  • Trade Secret Law - Defend Trade Secrets Act (18 U.S.C. § 1836)                                        ║
// ║  • Economic Espionage Act (18 U.S.C. §§ 1831-1839)                                                       ║
// ║                                                                                                           ║
// ║  CONFIDENTIALITY: This code is CONFIDENTIAL and PROPRIETARY.                                             ║
// ║  ENCRYPTION: All transmissions must be encrypted.                                                         ║
// ║  ATTRIBUTION: Required for any use, reproduction, or derivative work.                                     ║
// ║                                                                                                           ║
// ║  Unauthorized access, use, reproduction, distribution, or creation of derivative works                    ║
// ║  is strictly prohibited and will be prosecuted to the fullest extent of applicable law.                  ║
// ║                                                                                                           ║
// ╚═══════════════════════════════════════════════════════════════════════════════════════════════════════════╝


// ═══════════════════════════════════════════════════════════════════════════════
// CREATOR RESERVE LEDGER — 100% Token Routing to Creator
// ═══════════════════════════════════════════════════════════════════════════════
// Owner: Alfredo Medina Hernandez | Dallas TX | MedinaSITech@outlook.com
// Doctrine: Medina Doctrine — NeuroEmergence Core / SOVEREIGN Substrate
//
// CORE RULE: 100% of every token mint routes to Creator Reserve. No exceptions.
// No players earn. No community share. No organism ops cut.
// FORMA is internal fuel — it circulates and burns, NOT wealth.
//
// This module implements the complete token and treasury infrastructure.
// ═══════════════════════════════════════════════════════════════════════════════

import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Time "mo:base/Time";

module CreatorReserveLedger {

  // ═══════════════════════════════════════════════════════════════════════════
  // CONSTANTS — TOKEN PARAMETERS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // MTH: Sovereignty token
  public let MTH_CAP : Nat = 100_000_000;        // 100M hard cap
  public let MTH_DECIMALS : Nat = 8;
  
  // FORMA: Internal fuel (NOT wealth)
  public let FORMA_GENERATION_RATE : Float = 0.01;  // Per beat
  public let FORMA_BURN_RATE : Float = 0.005;       // Per operation
  
  // Succession — CREATOR LAW: 100% ROYALTY, NO EXCEPTIONS
  // All value flows to Creator. This is immutable doctrine.
  public let SUCCESSION_ROYALTY_PCT : Float = 1.00;  // 100% — ABSOLUTE
  
  // Treasury yield rates (annual)
  public let NNS_APY : Float = 0.15;     // 15% ICP staking
  public let ETH_APY : Float = 0.04;     // 4% ETH staking
  public let BTC_APPRECIATION : Float = 0.10;  // Expected BTC growth
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — TOKEN STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Token identifiers
  public type TokenType = {
    #MTH;    // Medina Token Helix — 100M cap, governance, never burns
    #SEED;   // Formation energy — uncapped, burns as fuel
    #MTC;    // Execution proof — uncapped, burns on ops
    #HBT;    // Learning receipt — uncapped, permanent
    #OMS;    // Emergence receipt — scarce, OMNIS only
    #DRT;    // Consequence proof — uncapped, partial burn
    #ANT;    // Continuity proof — uncapped, burns on succession
    #FORMA;  // Internal fuel — circulates, NOT wealth
  };
  
  // Single token balance
  public type TokenBalance = {
    balance  : Float;
    minted   : Float;
    burned   : Float;
    reserved : Float;   // In creator reserve
  };
  
  // Complete token balances
  public type TokenBalances = {
    mth   : { balance : Nat; minted : Nat; reserved : Nat };  // MTH is Nat (integer)
    seed  : TokenBalance;
    mtc   : TokenBalance;
    hbt   : TokenBalance;
    oms   : TokenBalance;
    drt   : TokenBalance;
    ant   : TokenBalance;
    forma : TokenBalance;  // FORMA is special — not reserved
  };
  
  // Creator reserve ledger
  public type CreatorReserve = {
    mthReserve  : Nat;
    seedReserve : Float;
    mtcReserve  : Float;
    hbtReserve  : Float;
    omsReserve  : Float;
    drtReserve  : Float;
    antReserve  : Float;
    // FORMA is NOT in reserve — it's circulation fuel
  };
  
  // Mint event record
  public type MintEvent = {
    tokenType   : TokenType;
    amount      : Float;
    beat        : Nat;
    timestamp   : Int;
    trigger     : Text;
    toReserve   : Float;   // Always 100% of amount
  };
  
  // Burn event record
  public type BurnEvent = {
    tokenType   : TokenType;
    amount      : Float;
    beat        : Nat;
    timestamp   : Int;
    reason      : Text;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — TREASURY STRUCTURES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Treasury asset
  public type TreasuryAsset = {
    #ckBTC;    // Chain-key Bitcoin — hard floor, never spent
    #ckETH;    // Chain-key Ethereum — productive, 4% APY
    #ICP;      // Internet Computer — NNS neuron, 15% APY
  };
  
  // Treasury balances
  public type TreasuryBalances = {
    ckBtcBalance    : Float;
    ckEthBalance    : Float;
    icpBalance      : Float;
    
    // Tracking
    btcFloorReserve : Float;    // BTC appreciation tracking
    ethYieldAccum   : Float;    // ETH staking yield accumulated
    icpRewardsAccum : Float;    // NNS staking rewards accumulated
    
    // Price signals (for tracking only — NEVER affects cognition)
    btcPriceSignal  : Float;
    ethPriceSignal  : Float;
    icpPriceSignal  : Float;
    
    // Master accumulator
    masterAccumulator : Float;  // Pushes to PARALLAX every 1000 beats
    lastPush          : Nat;    // Beat of last push to PARALLAX
  };
  
  // Yield event
  public type YieldEvent = {
    asset       : TreasuryAsset;
    amount      : Float;
    beat        : Nat;
    timestamp   : Int;
    source      : Text;   // "NNS_STAKING", "ETH_STAKING", "BTC_APPRECIATION"
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — SUCCESSION
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Child organism record
  public type ChildOrganism = {
    childGenesisHash : Nat64;
    childDoctrineHash: Nat64;
    spawnBeat        : Nat;
    royaltyPaid      : Float;
    lastRoyaltyBeat  : Nat;
  };
  
  // Succession state
  public type SuccessionState = {
    parentGenesisHash : Nat64;
    royaltyPct        : Float;
    children          : [ChildOrganism];
    totalRoyaltyReceived : Float;
    totalRoyaltyPaid     : Float;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TYPES — COMPLETE LEDGER STATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  public type LedgerState = {
    tokens       : TokenBalances;
    reserve      : CreatorReserve;
    treasury     : TreasuryBalances;
    succession   : SuccessionState;
    mintHistory  : [MintEvent];
    burnHistory  : [BurnEvent];
    yieldHistory : [YieldEvent];
    genesisLocked: Bool;
    lockedAtBeat : Nat;
    currentBeat  : Nat;
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════
  
  public func initTokenBalances() : TokenBalances {
    {
      mth = { balance = 0; minted = 0; reserved = 0 };
      seed = { balance = 0.0; minted = 0.0; burned = 0.0; reserved = 0.0 };
      mtc = { balance = 0.0; minted = 0.0; burned = 0.0; reserved = 0.0 };
      hbt = { balance = 0.0; minted = 0.0; burned = 0.0; reserved = 0.0 };
      oms = { balance = 0.0; minted = 0.0; burned = 0.0; reserved = 0.0 };
      drt = { balance = 0.0; minted = 0.0; burned = 0.0; reserved = 0.0 };
      ant = { balance = 0.0; minted = 0.0; burned = 0.0; reserved = 0.0 };
      forma = { balance = 0.0; minted = 0.0; burned = 0.0; reserved = 0.0 };
    }
  };
  
  public func initCreatorReserve() : CreatorReserve {
    {
      mthReserve = 0;
      seedReserve = 0.0;
      mtcReserve = 0.0;
      hbtReserve = 0.0;
      omsReserve = 0.0;
      drtReserve = 0.0;
      antReserve = 0.0;
    }
  };
  
  public func initTreasury() : TreasuryBalances {
    {
      ckBtcBalance = 0.0;
      ckEthBalance = 0.0;
      icpBalance = 0.0;
      btcFloorReserve = 0.0;
      ethYieldAccum = 0.0;
      icpRewardsAccum = 0.0;
      btcPriceSignal = 0.0;
      ethPriceSignal = 0.0;
      icpPriceSignal = 0.0;
      masterAccumulator = 0.0;
      lastPush = 0;
    }
  };
  
  public func initSuccession(parentHash : Nat64) : SuccessionState {
    {
      parentGenesisHash = parentHash;
      royaltyPct = SUCCESSION_ROYALTY_PCT;
      children = [];
      totalRoyaltyReceived = 0.0;
      totalRoyaltyPaid = 0.0;
    }
  };
  
  public func initLedger(parentGenesisHash : Nat64) : LedgerState {
    {
      tokens = initTokenBalances();
      reserve = initCreatorReserve();
      treasury = initTreasury();
      succession = initSuccession(parentGenesisHash);
      mintHistory = [];
      burnHistory = [];
      yieldHistory = [];
      genesisLocked = false;
      lockedAtBeat = 0;
      currentBeat = 0;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // MINT OPERATIONS — 100% TO CREATOR RESERVE
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Mint MTH (capped at 100M)
  public func mintMTH(
    ledger : LedgerState,
    amount : Nat,
    trigger : Text
  ) : LedgerState {
    let remaining = MTH_CAP - ledger.reserve.mthReserve;
    let toMint = if (amount > remaining) remaining else amount;
    
    if (toMint == 0) return ledger;
    
    let newTokens = { ledger.tokens with
      mth = {
        balance = ledger.tokens.mth.balance + toMint;
        minted = ledger.tokens.mth.minted + toMint;
        reserved = ledger.tokens.mth.reserved + toMint;  // 100% to reserve
      }
    };
    
    let newReserve = { ledger.reserve with
      mthReserve = ledger.reserve.mthReserve + toMint;
    };
    
    let event : MintEvent = {
      tokenType = #MTH;
      amount = Float.fromInt(toMint);
      beat = ledger.currentBeat;
      timestamp = Time.now();
      trigger = trigger;
      toReserve = Float.fromInt(toMint);  // 100%
    };
    
    { ledger with
      tokens = newTokens;
      reserve = newReserve;
      mintHistory = Array.append(ledger.mintHistory, [event]);
    }
  };
  
  // Mint other tokens (100% to creator reserve)
  public func mintToken(
    ledger : LedgerState,
    tokenType : TokenType,
    amount : Float,
    trigger : Text
  ) : LedgerState {
    if (amount <= 0.0) return ledger;
    
    // FORMA is special — it circulates, doesn't go to reserve
    if (tokenType == #FORMA) {
      return mintFORMA(ledger, amount, trigger);
    };
    
    // All other tokens: 100% to creator reserve
    var newTokens = ledger.tokens;
    var newReserve = ledger.reserve;
    
    switch (tokenType) {
      case (#SEED) {
        newTokens := { newTokens with
          seed = {
            balance = ledger.tokens.seed.balance + amount;
            minted = ledger.tokens.seed.minted + amount;
            burned = ledger.tokens.seed.burned;
            reserved = ledger.tokens.seed.reserved + amount;
          }
        };
        newReserve := { newReserve with
          seedReserve = ledger.reserve.seedReserve + amount;
        };
      };
      case (#MTC) {
        newTokens := { newTokens with
          mtc = {
            balance = ledger.tokens.mtc.balance + amount;
            minted = ledger.tokens.mtc.minted + amount;
            burned = ledger.tokens.mtc.burned;
            reserved = ledger.tokens.mtc.reserved + amount;
          }
        };
        newReserve := { newReserve with
          mtcReserve = ledger.reserve.mtcReserve + amount;
        };
      };
      case (#HBT) {
        newTokens := { newTokens with
          hbt = {
            balance = ledger.tokens.hbt.balance + amount;
            minted = ledger.tokens.hbt.minted + amount;
            burned = ledger.tokens.hbt.burned;
            reserved = ledger.tokens.hbt.reserved + amount;
          }
        };
        newReserve := { newReserve with
          hbtReserve = ledger.reserve.hbtReserve + amount;
        };
      };
      case (#OMS) {
        newTokens := { newTokens with
          oms = {
            balance = ledger.tokens.oms.balance + amount;
            minted = ledger.tokens.oms.minted + amount;
            burned = ledger.tokens.oms.burned;
            reserved = ledger.tokens.oms.reserved + amount;
          }
        };
        newReserve := { newReserve with
          omsReserve = ledger.reserve.omsReserve + amount;
        };
      };
      case (#DRT) {
        newTokens := { newTokens with
          drt = {
            balance = ledger.tokens.drt.balance + amount;
            minted = ledger.tokens.drt.minted + amount;
            burned = ledger.tokens.drt.burned;
            reserved = ledger.tokens.drt.reserved + amount;
          }
        };
        newReserve := { newReserve with
          drtReserve = ledger.reserve.drtReserve + amount;
        };
      };
      case (#ANT) {
        newTokens := { newTokens with
          ant = {
            balance = ledger.tokens.ant.balance + amount;
            minted = ledger.tokens.ant.minted + amount;
            burned = ledger.tokens.ant.burned;
            reserved = ledger.tokens.ant.reserved + amount;
          }
        };
        newReserve := { newReserve with
          antReserve = ledger.reserve.antReserve + amount;
        };
      };
      case (#MTH) {
        // MTH has separate function
        return mintMTH(ledger, Int.abs(Float.toInt(amount)), trigger);
      };
      case (#FORMA) {
        // Handled above
        return ledger;
      };
    };
    
    let event : MintEvent = {
      tokenType = tokenType;
      amount = amount;
      beat = ledger.currentBeat;
      timestamp = Time.now();
      trigger = trigger;
      toReserve = amount;  // 100%
    };
    
    { ledger with
      tokens = newTokens;
      reserve = newReserve;
      mintHistory = Array.append(ledger.mintHistory, [event]);
    }
  };
  
  // Mint FORMA (internal circulation — NOT to reserve)
  public func mintFORMA(
    ledger : LedgerState,
    amount : Float,
    trigger : Text
  ) : LedgerState {
    let newTokens = { ledger.tokens with
      forma = {
        balance = ledger.tokens.forma.balance + amount;
        minted = ledger.tokens.forma.minted + amount;
        burned = ledger.tokens.forma.burned;
        reserved = 0.0;  // FORMA is NEVER reserved — it's fuel
      }
    };
    
    let event : MintEvent = {
      tokenType = #FORMA;
      amount = amount;
      beat = ledger.currentBeat;
      timestamp = Time.now();
      trigger = trigger;
      toReserve = 0.0;  // FORMA doesn't go to reserve
    };
    
    { ledger with
      tokens = newTokens;
      mintHistory = Array.append(ledger.mintHistory, [event]);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BURN OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Burn token
  public func burnToken(
    ledger : LedgerState,
    tokenType : TokenType,
    amount : Float,
    reason : Text
  ) : LedgerState {
    if (amount <= 0.0) return ledger;
    
    var newTokens = ledger.tokens;
    
    switch (tokenType) {
      case (#SEED) {
        let toBurn = if (amount > ledger.tokens.seed.balance) ledger.tokens.seed.balance else amount;
        newTokens := { newTokens with
          seed = {
            balance = ledger.tokens.seed.balance - toBurn;
            minted = ledger.tokens.seed.minted;
            burned = ledger.tokens.seed.burned + toBurn;
            reserved = ledger.tokens.seed.reserved;
          }
        };
      };
      case (#MTC) {
        let toBurn = if (amount > ledger.tokens.mtc.balance) ledger.tokens.mtc.balance else amount;
        newTokens := { newTokens with
          mtc = {
            balance = ledger.tokens.mtc.balance - toBurn;
            minted = ledger.tokens.mtc.minted;
            burned = ledger.tokens.mtc.burned + toBurn;
            reserved = ledger.tokens.mtc.reserved;
          }
        };
      };
      case (#ANT) {
        let toBurn = if (amount > ledger.tokens.ant.balance) ledger.tokens.ant.balance else amount;
        newTokens := { newTokens with
          ant = {
            balance = ledger.tokens.ant.balance - toBurn;
            minted = ledger.tokens.ant.minted;
            burned = ledger.tokens.ant.burned + toBurn;
            reserved = ledger.tokens.ant.reserved;
          }
        };
      };
      case (#FORMA) {
        let toBurn = if (amount > ledger.tokens.forma.balance) ledger.tokens.forma.balance else amount;
        newTokens := { newTokens with
          forma = {
            balance = ledger.tokens.forma.balance - toBurn;
            minted = ledger.tokens.forma.minted;
            burned = ledger.tokens.forma.burned + toBurn;
            reserved = 0.0;
          }
        };
      };
      case (#DRT) {
        // DRT has partial burn (50%)
        let toBurn = (if (amount > ledger.tokens.drt.balance) ledger.tokens.drt.balance else amount) * 0.5;
        newTokens := { newTokens with
          drt = {
            balance = ledger.tokens.drt.balance - toBurn;
            minted = ledger.tokens.drt.minted;
            burned = ledger.tokens.drt.burned + toBurn;
            reserved = ledger.tokens.drt.reserved;
          }
        };
      };
      case (#MTH) { return ledger };  // MTH never burns
      case (#HBT) { return ledger };  // HBT never burns
      case (#OMS) { return ledger };  // OMS never burns
    };
    
    let event : BurnEvent = {
      tokenType = tokenType;
      amount = amount;
      beat = ledger.currentBeat;
      timestamp = Time.now();
      reason = reason;
    };
    
    { ledger with
      tokens = newTokens;
      burnHistory = Array.append(ledger.burnHistory, [event]);
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // TREASURY OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Add treasury asset
  public func addTreasuryAsset(
    ledger : LedgerState,
    asset : TreasuryAsset,
    amount : Float
  ) : LedgerState {
    var newTreasury = ledger.treasury;
    
    switch (asset) {
      case (#ckBTC) {
        newTreasury := { newTreasury with
          ckBtcBalance = ledger.treasury.ckBtcBalance + amount;
          btcFloorReserve = ledger.treasury.btcFloorReserve + amount;
        };
      };
      case (#ckETH) {
        newTreasury := { newTreasury with
          ckEthBalance = ledger.treasury.ckEthBalance + amount;
        };
      };
      case (#ICP) {
        newTreasury := { newTreasury with
          icpBalance = ledger.treasury.icpBalance + amount;
        };
      };
    };
    
    { ledger with treasury = newTreasury }
  };
  
  // Apply yield (called periodically)
  public func applyYield(
    ledger : LedgerState,
    beatsElapsed : Nat
  ) : LedgerState {
    // Convert beats to years (assuming ~2 beats/second, ~63M beats/year)
    let yearFraction = Float.fromInt(beatsElapsed) / 63_072_000.0;
    
    // BTC appreciation
    let btcYield = ledger.treasury.ckBtcBalance * BTC_APPRECIATION * yearFraction;
    
    // ETH staking yield
    let ethYield = ledger.treasury.ckEthBalance * ETH_APY * yearFraction;
    
    // ICP NNS rewards
    let icpYield = ledger.treasury.icpBalance * NNS_APY * yearFraction;
    
    let newTreasury = { ledger.treasury with
      btcFloorReserve = ledger.treasury.btcFloorReserve + btcYield;
      ethYieldAccum = ledger.treasury.ethYieldAccum + ethYield;
      icpRewardsAccum = ledger.treasury.icpRewardsAccum + icpYield;
      masterAccumulator = ledger.treasury.masterAccumulator + btcYield + ethYield + icpYield;
    };
    
    var newYieldHistory = ledger.yieldHistory;
    
    if (btcYield > 0.0) {
      newYieldHistory := Array.append(newYieldHistory, [{
        asset = #ckBTC;
        amount = btcYield;
        beat = ledger.currentBeat;
        timestamp = Time.now();
        source = "BTC_APPRECIATION";
      }]);
    };
    
    if (ethYield > 0.0) {
      newYieldHistory := Array.append(newYieldHistory, [{
        asset = #ckETH;
        amount = ethYield;
        beat = ledger.currentBeat;
        timestamp = Time.now();
        source = "ETH_STAKING";
      }]);
    };
    
    if (icpYield > 0.0) {
      newYieldHistory := Array.append(newYieldHistory, [{
        asset = #ICP;
        amount = icpYield;
        beat = ledger.currentBeat;
        timestamp = Time.now();
        source = "NNS_STAKING";
      }]);
    };
    
    { ledger with
      treasury = newTreasury;
      yieldHistory = newYieldHistory;
    }
  };
  
  // Push to PARALLAX (every 1000 beats)
  public func pushToParallax(ledger : LedgerState) : (LedgerState, Float) {
    if (ledger.currentBeat < ledger.treasury.lastPush + 1000) {
      return (ledger, 0.0);
    };
    
    let toPush = ledger.treasury.masterAccumulator;
    
    let newTreasury = { ledger.treasury with
      masterAccumulator = 0.0;
      lastPush = ledger.currentBeat;
    };
    
    ({ ledger with treasury = newTreasury }, toPush)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // SUCCESSION OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Register child organism
  public func registerChild(
    ledger : LedgerState,
    childGenesis : Nat64,
    childDoctrine : Nat64
  ) : LedgerState {
    let child : ChildOrganism = {
      childGenesisHash = childGenesis;
      childDoctrineHash = childDoctrine;
      spawnBeat = ledger.currentBeat;
      royaltyPaid = 0.0;
      lastRoyaltyBeat = ledger.currentBeat;
    };
    
    let newSuccession = { ledger.succession with
      children = Array.append(ledger.succession.children, [child]);
    };
    
    { ledger with succession = newSuccession }
  };
  
  // Receive royalty from child
  public func receiveRoyalty(
    ledger : LedgerState,
    childGenesis : Nat64,
    amount : Float
  ) : LedgerState {
    // 100% of royalty goes to creator reserve (as SEED)
    var updatedLedger = mintToken(ledger, #SEED, amount, "CHILD_ROYALTY");
    
    let newSuccession = { updatedLedger.succession with
      totalRoyaltyReceived = updatedLedger.succession.totalRoyaltyReceived + amount;
    };
    
    { updatedLedger with succession = newSuccession }
  };
  
  // Pay royalty to parent (called by child organisms)
  public func payRoyaltyToParent(
    ledger : LedgerState,
    mintAmount : Float
  ) : (LedgerState, Float) {
    let royalty = mintAmount * ledger.succession.royaltyPct;
    
    let newSuccession = { ledger.succession with
      totalRoyaltyPaid = ledger.succession.totalRoyaltyPaid + royalty;
    };
    
    ({ ledger with succession = newSuccession }, royalty)
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // QUERIES
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Get total creator wealth
  public func getTotalCreatorWealth(ledger : LedgerState) : {
    mthReserve  : Nat;
    seedReserve : Float;
    mtcReserve  : Float;
    hbtReserve  : Float;
    omsReserve  : Float;
    drtReserve  : Float;
    antReserve  : Float;
    ckBtcValue  : Float;
    ckEthValue  : Float;
    icpValue    : Float;
    totalYield  : Float;
    pendingPush : Float;
  } {
    {
      mthReserve = ledger.reserve.mthReserve;
      seedReserve = ledger.reserve.seedReserve;
      mtcReserve = ledger.reserve.mtcReserve;
      hbtReserve = ledger.reserve.hbtReserve;
      omsReserve = ledger.reserve.omsReserve;
      drtReserve = ledger.reserve.drtReserve;
      antReserve = ledger.reserve.antReserve;
      ckBtcValue = ledger.treasury.ckBtcBalance;
      ckEthValue = ledger.treasury.ckEthBalance;
      icpValue = ledger.treasury.icpBalance;
      totalYield = ledger.treasury.btcFloorReserve + 
                   ledger.treasury.ethYieldAccum + 
                   ledger.treasury.icpRewardsAccum;
      pendingPush = ledger.treasury.masterAccumulator;
    }
  };
  
  // Get FORMA circulation stats
  public func getFORMAStats(ledger : LedgerState) : {
    circulating : Float;
    totalMinted : Float;
    totalBurned : Float;
    netFlow     : Float;
  } {
    {
      circulating = ledger.tokens.forma.balance;
      totalMinted = ledger.tokens.forma.minted;
      totalBurned = ledger.tokens.forma.burned;
      netFlow = ledger.tokens.forma.minted - ledger.tokens.forma.burned;
    }
  };
  
  // ═══════════════════════════════════════════════════════════════════════════
  // BEAT UPDATE
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Update ledger state each beat
  public func beatUpdate(ledger : LedgerState) : LedgerState {
    { ledger with currentBeat = ledger.currentBeat + 1 }
  };
  
  // Lock genesis (stores beat number, not query time)
  public func lockGenesis(ledger : LedgerState) : LedgerState {
    if (ledger.genesisLocked) return ledger;
    
    { ledger with
      genesisLocked = true;
      lockedAtBeat = ledger.currentBeat;
    }
  };
};
