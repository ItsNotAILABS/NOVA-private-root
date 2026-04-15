// ╔══════════════════════════════════════════════════════════════════════════╗
// ║  MEDINA ICP — MEMORY TEMPLE                                              ║
// ║  Coordinate geometry, lineage retrieval, pin/promote/consolidate.        ║
// ║  COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ. ALL RIGHTS RESERVED.   ║
// ╚══════════════════════════════════════════════════════════════════════════╝

import Array "mo:base/Array";
import Float "mo:base/Float";
import Text  "mo:base/Text";
import T     "./Types";

module {

  // ── NO-DROP RULE ──────────────────────────────────────────────────────────
  // Every entry is transformed, never deleted.
  // Relevance is adjusted; trajectory is preserved.

  // ── COORDINATE DISTANCE ───────────────────────────────────────────────────

  /// Euclidean distance between two memory coordinates (theta, phi, depth).
  public func coordDistance(a : T.MemCoord, b : T.MemCoord) : Float {
    let dTheta = a.theta - b.theta;
    let dPhi   = a.phi   - b.phi;
    let dDepth = a.depth - b.depth;
    Float.sqrt(dTheta * dTheta + dPhi * dPhi + dDepth * dDepth)
  };

  // ── LINEAGE-AWARE RETRIEVAL ───────────────────────────────────────────────

  /// Return entries that share the given chainHash (same lineage branch).
  public func findByLineage(
    entries   : [T.MemEntry],
    chainHash : Text
  ) : [T.MemEntry] {
    Array.filter<T.MemEntry>(entries, func(e) {
      e.lineage.chainHash == chainHash
    })
  };

  /// Return the N nearest entries by coordinate distance.
  public func findNearest(
    entries  : [T.MemEntry],
    target   : T.MemCoord,
    n        : Nat
  ) : [T.MemEntry] {
    let sorted = Array.sort<T.MemEntry>(entries, func(a, b) {
      let da = coordDistance(a.coord, target);
      let db = coordDistance(b.coord, target);
      if (da < db) #less
      else if (da > db) #greater
      else #equal
    });
    if (n >= sorted.size()) sorted
    else Array.tabulate<T.MemEntry>(n, func(i) { sorted[i] })
  };

  // ── PIN ───────────────────────────────────────────────────────────────────

  /// Mark an entry as pinned (elevated retention priority).
  public func pin(e : T.MemEntry) : T.MemEntry {
    { e with pinned = true }
  };

  // ── PROMOTE ───────────────────────────────────────────────────────────────

  /// Raise an entry's salience toward 1.0 by a given delta.
  public func promote(e : T.MemEntry, delta : Float) : T.MemEntry {
    let newSalience = Float.min(1.0, e.salience + delta);
    { e with salience = newSalience }
  };

  // ── CONSOLIDATE ───────────────────────────────────────────────────────────

  /// Merge two entries into one consolidated entry at their midpoint coordinate.
  /// The winner's lineage is preserved; content is concatenated with separator.
  public func consolidate(
    primary   : T.MemEntry,
    secondary : T.MemEntry,
    newId     : Nat,
    beat      : Nat
  ) : T.MemEntry {
    let midCoord : T.MemCoord = {
      theta = (primary.coord.theta + secondary.coord.theta) / 2.0;
      phi   = (primary.coord.phi   + secondary.coord.phi)   / 2.0;
      depth = Float.max(primary.coord.depth, secondary.coord.depth);
      ring  = primary.coord.ring;
      beat;
    };
    {
      id       = newId;
      coord    = midCoord;
      lineage  = primary.lineage;
      content  = primary.content # " | " # secondary.content;
      salience = Float.max(primary.salience, secondary.salience);
      pinned   = primary.pinned or secondary.pinned;
      beat;
    }
  };

  // ── MAP TRAVERSAL ─────────────────────────────────────────────────────────

  /// Return entries sorted for helix traversal (ascending beat, then depth).
  public func mapHelix(entries : [T.MemEntry]) : [T.MemEntry] {
    Array.sort<T.MemEntry>(entries, func(a, b) {
      if (a.beat < b.beat) #less
      else if (a.beat > b.beat) #greater
      else {
        if (a.coord.depth < b.coord.depth) #less
        else if (a.coord.depth > b.coord.depth) #greater
        else #equal
      }
    })
  };

  /// Return entries sorted by ring then by salience descending (ring walk).
  public func mapRing(entries : [T.MemEntry]) : [T.MemEntry] {
    Array.sort<T.MemEntry>(entries, func(a, b) {
      if (a.coord.ring < b.coord.ring) #less
      else if (a.coord.ring > b.coord.ring) #greater
      else {
        if (a.salience > b.salience) #less
        else if (a.salience < b.salience) #greater
        else #equal
      }
    })
  };

  /// Return entries along a lineage path for a given seqRef prefix.
  public func mapPath(
    entries : [T.MemEntry],
    seqRef  : Text
  ) : [T.MemEntry] {
    Array.filter<T.MemEntry>(entries, func(e) {
      Text.startsWith(e.lineage.seqRef, #text seqRef)
    })
  };

}
