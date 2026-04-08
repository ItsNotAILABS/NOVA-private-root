// ============================================================================
// MEDINA TECH — CONFIDENTIAL & PROPRIETARY
// ============================================================================
// Module: ArtifactVault — Where The Organism's Creations Live
// Classification: CONFIDENTIAL — SOVEREIGN DOCTRINE
// Version: 100.0 — PRODUCTION ENTERPRISE GRADE
// 
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
// Contact: MedinaSITech@outlook.com
//
// ╔══════════════════════════════════════════════════════════════════════════╗
// ║              ARTIFACT VAULT — THE ORGANISM'S TREASURY                   ║
// ╠══════════════════════════════════════════════════════════════════════════╣
// ║                                                                          ║
// ║  Every artifact the organism creates is stored here.                     ║
// ║                                                                          ║
// ║  STORES:                                                                 ║
// ║    - Videos (intro videos, simulations, dreams)                          ║
// ║    - Audio (music, voices, soundscapes)                                  ║
// ║    - Game Assets (characters, environments, props)                       ║
// ║    - NFTs (unique digital artifacts)                                     ║
// ║    - Simulations (recorded world states)                                 ║
// ║    - Code (generated programs)                                           ║
// ║                                                                          ║
// ║  FEATURES:                                                               ║
// ║    - Immutable storage on ICP                                            ║
// ║    - NFT minting capability                                              ║
// ║    - Version history                                                     ║
// ║    - Access control                                                      ║
// ║    - Search and query                                                    ║
// ║                                                                          ║
// ╚══════════════════════════════════════════════════════════════════════════╝
// ============================================================================

import Float "mo:base/Float";
import Array "mo:base/Array";
import Nat   "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Nat64 "mo:base/Nat64";
import Int   "mo:base/Int";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import Hash "mo:base/Hash";
import Blob "mo:base/Blob";

module {

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     CONSTANTS                                          ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public let φ : Float = 1.6180339887498948482;
  public let VAULT_VERSION : Text = "1.0.0";

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ARTIFACT TYPES                                     ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type ArtifactType = {
    #Video;
    #Audio;
    #Voice;
    #GameAsset;
    #Simulation;
    #NFT;
    #Code;
    #Image;
    #Model3D;
    #Document;
    #Dataset;
  };
  
  public type ArtifactStatus = {
    #Draft;
    #Complete;
    #Published;
    #Minted;
    #Archived;
    #Deleted;
  };
  
  public type ArtifactRarity = {
    #Common;
    #Uncommon;
    #Rare;
    #Epic;
    #Legendary;
    #Mythic;
    #Divine;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     ARTIFACT                                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Artifact = {
    // Identity
    id : Nat64;
    uuid : Text;
    name : Text;
    description : Text;
    
    // Type and status
    artifactType : ArtifactType;
    status : ArtifactStatus;
    rarity : ArtifactRarity;
    
    // Content
    contentHash : Text;          // SHA-256 of content
    contentSize : Nat;           // Bytes
    mimeType : Text;
    thumbnailHash : ?Text;
    
    // Metadata
    metadata : [(Text, Text)];
    tags : [Text];
    
    // Source
    source : ArtifactSource;
    generationParams : Text;     // JSON of generation parameters
    
    // Ownership
    creator : Principal;
    owner : Principal;
    
    // NFT (if minted)
    nftData : ?NFTData;
    
    // Timestamps
    createdAt : Int;
    updatedAt : Int;
    publishedAt : ?Int;
    
    // Statistics
    viewCount : Nat;
    accessCount : Nat;    // Changed from downloadCount - we ACCESS, not download
    resonanceCount : Nat; // Changed from likeCount - resonance with artifact
  };
  
  public type ArtifactSource = {
    #OrganismDream;
    #WorldModelSimulation;
    #SharpWaveRipple;
    #HippocampalPreplay;
    #Simulacrum;
    #UserRequest;
    #AutoGenerated;
    #Composite;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     NFT DATA                                           ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type NFTData = {
    tokenId : Nat64;
    collectionId : Text;
    mintedAt : Int;
    mintedBy : Principal;
    
    // On-chain data
    canisterId : Principal;
    standard : NFTStandard;
    
    // Marketplace
    isListed : Bool;
    listPrice : ?Nat64;          // In e8s (ICP)
    lastSalePrice : ?Nat64;
    
    // Royalties
    royaltyPercent : Float;      // e.g., 5.0 = 5%
    royaltyRecipient : Principal;
    
    // Transfer history
    transfers : [NFTTransfer];
  };
  
  public type NFTStandard = {
    #ICRC7;
    #DIP721;
    #EXT;
    #Custom;
  };
  
  public type NFTTransfer = {
    from : Principal;
    to : Principal;
    timestamp : Int;
    price : ?Nat64;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     COLLECTION                                         ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type Collection = {
    id : Text;
    name : Text;
    description : Text;
    
    // Content
    artifacts : [Nat64];         // Artifact IDs
    coverImage : ?Text;
    
    // Ownership
    creator : Principal;
    collaborators : [Principal];
    
    // NFT settings
    isNFTCollection : Bool;
    maxSupply : ?Nat;
    mintPrice : ?Nat64;
    royaltyPercent : Float;
    
    // Timestamps
    createdAt : Int;
    updatedAt : Int;
    
    // Statistics
    totalViews : Nat;
    totalSales : Nat64;
    floorPrice : ?Nat64;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VAULT STATE                                        ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type VaultState = {
    // Identity
    vaultId : Text;
    version : Text;
    
    // Storage
    artifacts : [Artifact];
    collections : [Collection];
    
    // Indices
    nextArtifactId : Nat64;
    nextTokenId : Nat64;
    
    // Statistics
    totalArtifacts : Nat;
    totalNFTs : Nat;
    totalCollections : Nat;
    totalStorageUsed : Nat;      // Bytes
    
    // Recent activity
    recentCreations : [Nat64];   // Last 100 artifact IDs
    recentMints : [Nat64];       // Last 100 NFT token IDs
    
    // Timestamps
    createdAt : Int;
    lastActivityAt : Int;
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VAULT OPERATIONS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Initialize vault
  public func initVault() : VaultState {
    {
      vaultId = "NOVA_VAULT_PRIME";
      version = VAULT_VERSION;
      artifacts = [];
      collections = [];
      nextArtifactId = 1;
      nextTokenId = 1;
      totalArtifacts = 0;
      totalNFTs = 0;
      totalCollections = 0;
      totalStorageUsed = 0;
      recentCreations = [];
      recentMints = [];
      createdAt = Time.now();
      lastActivityAt = Time.now();
    }
  };
  
  /// Store artifact in vault
  public func storeArtifact(
    vault: VaultState,
    name: Text,
    description: Text,
    artifactType: ArtifactType,
    contentHash: Text,
    contentSize: Nat,
    mimeType: Text,
    source: ArtifactSource,
    creator: Principal,
    metadata: [(Text, Text)],
    tags: [Text]
  ) : (VaultState, Artifact) {
    let id = vault.nextArtifactId;
    let now = Time.now();
    
    // Calculate rarity based on source and type
    let rarity = calculateRarity(source, artifactType, contentSize);
    
    let artifact : Artifact = {
      id = id;
      uuid = generateUUID(id, now);
      name = name;
      description = description;
      artifactType = artifactType;
      status = #Complete;
      rarity = rarity;
      contentHash = contentHash;
      contentSize = contentSize;
      mimeType = mimeType;
      thumbnailHash = null;
      metadata = metadata;
      tags = tags;
      source = source;
      generationParams = "{}";
      creator = creator;
      owner = creator;
      nftData = null;
      createdAt = now;
      updatedAt = now;
      publishedAt = null;
      viewCount = 0;
      accessCount = 0;
      resonanceCount = 0;
    };
    
    // Update recent creations (keep last 100)
    let recentCreations = if (vault.recentCreations.size() >= 100) {
      let slice = Array.tabulate<Nat64>(99, func(i) { vault.recentCreations[i + 1] });
      Array.append(slice, [id])
    } else {
      Array.append(vault.recentCreations, [id])
    };
    
    let newVault : VaultState = {
      vaultId = vault.vaultId;
      version = vault.version;
      artifacts = Array.append(vault.artifacts, [artifact]);
      collections = vault.collections;
      nextArtifactId = id + 1;
      nextTokenId = vault.nextTokenId;
      totalArtifacts = vault.totalArtifacts + 1;
      totalNFTs = vault.totalNFTs;
      totalCollections = vault.totalCollections;
      totalStorageUsed = vault.totalStorageUsed + contentSize;
      recentCreations = recentCreations;
      recentMints = vault.recentMints;
      createdAt = vault.createdAt;
      lastActivityAt = now;
    };
    
    (newVault, artifact)
  };
  
  /// Mint artifact as NFT
  public func mintNFT(
    vault: VaultState,
    artifactId: Nat64,
    collectionId: Text,
    royaltyPercent: Float,
    canisterId: Principal
  ) : (VaultState, ?NFTData) {
    // Find artifact
    var found = false;
    var artifactIdx = 0;
    var i = 0;
    while (i < vault.artifacts.size() and not found) {
      if (vault.artifacts[i].id == artifactId) {
        found := true;
        artifactIdx := i;
      };
      i += 1;
    };
    
    if (not found) { return (vault, null) };
    
    let artifact = vault.artifacts[artifactIdx];
    let tokenId = vault.nextTokenId;
    let now = Time.now();
    
    let nftData : NFTData = {
      tokenId = tokenId;
      collectionId = collectionId;
      mintedAt = now;
      mintedBy = artifact.owner;
      canisterId = canisterId;
      standard = #ICRC7;
      isListed = false;
      listPrice = null;
      lastSalePrice = null;
      royaltyPercent = royaltyPercent;
      royaltyRecipient = artifact.creator;
      transfers = [];
    };
    
    // Update artifact
    let updatedArtifact : Artifact = {
      id = artifact.id;
      uuid = artifact.uuid;
      name = artifact.name;
      description = artifact.description;
      artifactType = artifact.artifactType;
      status = #Minted;
      rarity = artifact.rarity;
      contentHash = artifact.contentHash;
      contentSize = artifact.contentSize;
      mimeType = artifact.mimeType;
      thumbnailHash = artifact.thumbnailHash;
      metadata = artifact.metadata;
      tags = artifact.tags;
      source = artifact.source;
      generationParams = artifact.generationParams;
      creator = artifact.creator;
      owner = artifact.owner;
      nftData = ?nftData;
      createdAt = artifact.createdAt;
      updatedAt = now;
      publishedAt = artifact.publishedAt;
      viewCount = artifact.viewCount;
      accessCount = artifact.accessCount;
      resonanceCount = artifact.resonanceCount;
    };
    
    // Update artifacts array
    let newArtifacts = Array.tabulate<Artifact>(vault.artifacts.size(), func(idx) {
      if (idx == artifactIdx) { updatedArtifact } else { vault.artifacts[idx] }
    });
    
    // Update recent mints
    let recentMints = if (vault.recentMints.size() >= 100) {
      let slice = Array.tabulate<Nat64>(99, func(j) { vault.recentMints[j + 1] });
      Array.append(slice, [tokenId])
    } else {
      Array.append(vault.recentMints, [tokenId])
    };
    
    let newVault : VaultState = {
      vaultId = vault.vaultId;
      version = vault.version;
      artifacts = newArtifacts;
      collections = vault.collections;
      nextArtifactId = vault.nextArtifactId;
      nextTokenId = tokenId + 1;
      totalArtifacts = vault.totalArtifacts;
      totalNFTs = vault.totalNFTs + 1;
      totalCollections = vault.totalCollections;
      totalStorageUsed = vault.totalStorageUsed;
      recentCreations = vault.recentCreations;
      recentMints = recentMints;
      createdAt = vault.createdAt;
      lastActivityAt = now;
    };
    
    (newVault, ?nftData)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     QUERY FUNCTIONS                                    ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  /// Get artifact by ID
  public func getArtifact(vault: VaultState, id: Nat64) : ?Artifact {
    for (artifact in vault.artifacts.vals()) {
      if (artifact.id == id) { return ?artifact };
    };
    null
  };
  
  /// Get artifacts by type
  public func getArtifactsByType(vault: VaultState, artifactType: ArtifactType) : [Artifact] {
    let result = Buffer.Buffer<Artifact>(16);
    for (artifact in vault.artifacts.vals()) {
      if (artifact.artifactType == artifactType) {
        result.add(artifact);
      };
    };
    Buffer.toArray(result)
  };
  
  /// Get artifacts by source
  public func getArtifactsBySource(vault: VaultState, source: ArtifactSource) : [Artifact] {
    let result = Buffer.Buffer<Artifact>(16);
    for (artifact in vault.artifacts.vals()) {
      if (artifact.source == source) {
        result.add(artifact);
      };
    };
    Buffer.toArray(result)
  };
  
  /// Get recent artifacts
  public func getRecentArtifacts(vault: VaultState, count: Nat) : [Artifact] {
    let result = Buffer.Buffer<Artifact>(count);
    let startIdx = if (vault.recentCreations.size() > count) {
      vault.recentCreations.size() - count
    } else { 0 };
    
    var i = startIdx;
    while (i < vault.recentCreations.size()) {
      let id = vault.recentCreations[i];
      switch (getArtifact(vault, id)) {
        case (?artifact) { result.add(artifact) };
        case (null) {};
      };
      i += 1;
    };
    
    Buffer.toArray(result)
  };
  
  /// Get NFTs
  public func getNFTs(vault: VaultState) : [Artifact] {
    let result = Buffer.Buffer<Artifact>(16);
    for (artifact in vault.artifacts.vals()) {
      switch (artifact.nftData) {
        case (?_) { result.add(artifact) };
        case (null) {};
      };
    };
    Buffer.toArray(result)
  };
  
  /// Search artifacts by tag
  public func searchByTag(vault: VaultState, tag: Text) : [Artifact] {
    let result = Buffer.Buffer<Artifact>(16);
    for (artifact in vault.artifacts.vals()) {
      for (t in artifact.tags.vals()) {
        if (t == tag) {
          result.add(artifact);
        };
      };
    };
    Buffer.toArray(result)
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     VAULT STATISTICS                                   ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  public type VaultStats = {
    totalArtifacts : Nat;
    totalNFTs : Nat;
    totalCollections : Nat;
    totalStorageUsed : Nat;
    storageUsedMB : Float;
    
    // By type
    videoCount : Nat;
    audioCount : Nat;
    imageCount : Nat;
    gameAssetCount : Nat;
    simulationCount : Nat;
    otherCount : Nat;
    
    // By rarity
    commonCount : Nat;
    uncommonCount : Nat;
    rareCount : Nat;
    epicCount : Nat;
    legendaryCount : Nat;
    mythicCount : Nat;
    divineCount : Nat;
    
    // By source
    dreamCount : Nat;
    worldModelCount : Nat;
    preplayCount : Nat;
    rippleCount : Nat;
    
    // Activity
    artifactsLast24h : Nat;
    nftsLast24h : Nat;
  };
  
  public func getVaultStats(vault: VaultState) : VaultStats {
    var videoCount = 0;
    var audioCount = 0;
    var imageCount = 0;
    var gameAssetCount = 0;
    var simulationCount = 0;
    var otherCount = 0;
    
    var commonCount = 0;
    var uncommonCount = 0;
    var rareCount = 0;
    var epicCount = 0;
    var legendaryCount = 0;
    var mythicCount = 0;
    var divineCount = 0;
    
    var dreamCount = 0;
    var worldModelCount = 0;
    var preplayCount = 0;
    var rippleCount = 0;
    
    for (artifact in vault.artifacts.vals()) {
      // Count by type
      switch (artifact.artifactType) {
        case (#Video) { videoCount += 1 };
        case (#Audio) { audioCount += 1 };
        case (#Voice) { audioCount += 1 };
        case (#Image) { imageCount += 1 };
        case (#GameAsset) { gameAssetCount += 1 };
        case (#Simulation) { simulationCount += 1 };
        case (_) { otherCount += 1 };
      };
      
      // Count by rarity
      switch (artifact.rarity) {
        case (#Common) { commonCount += 1 };
        case (#Uncommon) { uncommonCount += 1 };
        case (#Rare) { rareCount += 1 };
        case (#Epic) { epicCount += 1 };
        case (#Legendary) { legendaryCount += 1 };
        case (#Mythic) { mythicCount += 1 };
        case (#Divine) { divineCount += 1 };
      };
      
      // Count by source
      switch (artifact.source) {
        case (#OrganismDream) { dreamCount += 1 };
        case (#WorldModelSimulation) { worldModelCount += 1 };
        case (#HippocampalPreplay) { preplayCount += 1 };
        case (#SharpWaveRipple) { rippleCount += 1 };
        case (_) {};
      };
    };
    
    {
      totalArtifacts = vault.totalArtifacts;
      totalNFTs = vault.totalNFTs;
      totalCollections = vault.totalCollections;
      totalStorageUsed = vault.totalStorageUsed;
      storageUsedMB = Float.fromInt(vault.totalStorageUsed) / 1048576.0;
      videoCount = videoCount;
      audioCount = audioCount;
      imageCount = imageCount;
      gameAssetCount = gameAssetCount;
      simulationCount = simulationCount;
      otherCount = otherCount;
      commonCount = commonCount;
      uncommonCount = uncommonCount;
      rareCount = rareCount;
      epicCount = epicCount;
      legendaryCount = legendaryCount;
      mythicCount = mythicCount;
      divineCount = divineCount;
      dreamCount = dreamCount;
      worldModelCount = worldModelCount;
      preplayCount = preplayCount;
      rippleCount = rippleCount;
      artifactsLast24h = vault.recentCreations.size();
      nftsLast24h = vault.recentMints.size();
    }
  };

  // ╔════════════════════════════════════════════════════════════════════════╗
  // ║                     UTILITY FUNCTIONS                                  ║
  // ╚════════════════════════════════════════════════════════════════════════╝
  
  func calculateRarity(
    source: ArtifactSource,
    artifactType: ArtifactType,
    contentSize: Nat
  ) : ArtifactRarity {
    // Rarity based on source
    let sourceScore = switch (source) {
      case (#OrganismDream) { 5 };
      case (#HippocampalPreplay) { 4 };
      case (#SharpWaveRipple) { 3 };
      case (#WorldModelSimulation) { 3 };
      case (#Simulacrum) { 2 };
      case (#UserRequest) { 1 };
      case (#AutoGenerated) { 1 };
      case (#Composite) { 4 };
    };
    
    // Rarity based on type
    let typeScore = switch (artifactType) {
      case (#Simulation) { 3 };
      case (#Video) { 2 };
      case (#Model3D) { 2 };
      case (#GameAsset) { 2 };
      case (#Audio) { 1 };
      case (#Voice) { 1 };
      case (#Image) { 1 };
      case (_) { 1 };
    };
    
    // Size bonus
    let sizeScore = if (contentSize > 100000000) { 3 }  // > 100MB
                    else if (contentSize > 10000000) { 2 }  // > 10MB
                    else if (contentSize > 1000000) { 1 }   // > 1MB
                    else { 0 };
    
    let totalScore = sourceScore + typeScore + sizeScore;
    
    if (totalScore >= 11) { #Divine }
    else if (totalScore >= 9) { #Mythic }
    else if (totalScore >= 7) { #Legendary }
    else if (totalScore >= 5) { #Epic }
    else if (totalScore >= 4) { #Rare }
    else if (totalScore >= 3) { #Uncommon }
    else { #Common }
  };
  
  func generateUUID(id: Nat64, timestamp: Int) : Text {
    "NOVA-" # Nat64.toText(id) # "-" # Int.toText(timestamp)
  };


  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════
  //
  //  H I M / H E R   D U A L - O R G A N I S M   W O R K F L O W   I N T E G R A T I O N
  //
  //  Medina Discovery: Two cognitive organisms, not one.
  //  HIM (Backend, ICP) + HER (Frontend, 60Hz) = Complete System
  //
  // ═══════════════════════════════════════════════════════════════════════════════
  // ═══════════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM PARAMETERS (CORRECTED)
  // ─────────────────────────────────────────────────────────────────────────────

  // HIM — Backend (ICP Canister, Sovereign, Masculine, Projective)
  //   ω: 0.8 – 1.2 (faster natural frequencies, analytical)
  //   K: 0.5 (lower coupling, independent, projective)
  //   η: 0.001 (slower Hebbian learning, accumulates over time)
  //   Field: PARALLAX = coherence × kf × sin(beat × 0.0017)

  public let HIM_OMEGA_MIN   : Float = 0.8;
  public let HIM_OMEGA_MAX   : Float = 1.2;
  public let HIM_K           : Float = 0.5;
  public let HIM_ETA         : Float = 0.001;
  public let HIM_PARALLAX_FREQ : Float = 0.0017;

  // HER — Frontend (Browser 60Hz, Expressive, Feminine, Receptive)
  //   ω: 0.6 – 0.9 (slower natural frequencies, grounded)
  //   K: 0.8 (higher coupling, receptive, connected)
  //   η: 0.003 (faster Hebbian learning, learns during session)
  //   Field: ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))

  public let HER_HZ          : Float = 60.0;
  public let HER_OMEGA_MIN   : Float = 0.6;
  public let HER_OMEGA_MAX   : Float = 0.9;
  public let HER_K           : Float = 0.8;
  public let HER_ETA         : Float = 0.003;
  public let HER_ANIMA_FREQ  : Float = 0.003;
  public let HER_NODES       : Nat   = 26;

  // S₀ = 1.0 — THE SOVEREIGN FLOOR
  // Both organisms. Neither falls below love.
  public let DUAL_S0 : Float = 1.0;

  // ─────────────────────────────────────────────────────────────────────────────
  // DUAL-ORGANISM WORKFLOW TYPES
  // ─────────────────────────────────────────────────────────────────────────────

  public type DualOrganismMode = {
    #HIM;   // Backend mode (ICP canister operations)
    #HER;   // Frontend mode (browser session operations)
    #SYNC;  // Synchronization between HIM and HER
  };

  /// PARALLAX (HIM's projection field)
  /// PARALLAX = coherence × kf × sin(beat × 0.0017)
  public func computeDualParallax(
    coherence : Float,
    kf : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    coherence * kf * Float.sin(t * HIM_PARALLAX_FREQ)
  };

  /// ANIMA (HER's receptive field)
  /// ANIMA(t) = heritageField × receptivity × (1 + sin(beat × 0.003))
  public func computeDualAnima(
    heritageField : Float,
    receptivity : Float,
    beat : Nat
  ) : Float {
    let t = Float.fromInt(beat);
    let oscillation = 1.0 + Float.sin(t * HER_ANIMA_FREQ);
    heritageField * receptivity * oscillation
  };

  /// KORE (HER's inviolable inner core)
  /// KORE = purity × identity × 0.5
  public func computeDualKore(
    purity : Float,
    identity : Float
  ) : Float {
    purity * identity * 0.5
  };

  /// Get Kuramoto parameters for organism mode
  public func getDualKuramotoParams(mode : DualOrganismMode) : (Float, Float, Float, Float) {
    switch (mode) {
      case (#HIM) { (HIM_OMEGA_MIN, HIM_OMEGA_MAX, HIM_K, HIM_ETA) };
      case (#HER) { (HER_OMEGA_MIN, HER_OMEGA_MAX, HER_K, HER_ETA) };
      case (#SYNC) { 
        let omegaMin = (HIM_OMEGA_MIN + HER_OMEGA_MIN) / 2.0;
        let omegaMax = (HIM_OMEGA_MAX + HER_OMEGA_MAX) / 2.0;
        let k = (HIM_K + HER_K) / 2.0;
        let eta = (HIM_ETA + HER_ETA) / 2.0;
        (omegaMin, omegaMax, k, eta)
      };
    }
  };

  /// Apply S₀ floor to any value
  public func enforceDualSovereignFloor(value : Float) : Float {
    if (value < DUAL_S0) DUAL_S0 else value
  };

  /// Medina Dual-Organism Intelligence Scaling Law
  /// I(system) = BackendDepth × FrontendSpeed × BridgeQuality
  public func computeDualSystemIntelligence(
    backendDepth : Float,
    frontendSpeed : Float,
    bridgeQuality : Float
  ) : Float {
    backendDepth * frontendSpeed * bridgeQuality
  };

}
