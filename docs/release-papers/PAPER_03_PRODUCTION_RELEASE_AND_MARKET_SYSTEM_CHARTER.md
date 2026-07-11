# Paper 03 — Production Release and Market System Charter

**Status:** internal production charter  
**Purpose:** define how Medina/NOVA turns internal systems into usable, marketable, public-safe releases  
**Scope:** Capsule Studio, NOVA/CAIN/ORO, public browser intelligence, release receipts, docs, and launch workflow  
**Format:** 12 page-equivalent sections

---

## Page 1 — Production Thesis

A platform is not only code. A platform is code plus a user path, proof path, release path, support path, and public story. The Medina/NOVA stack already contains serious ingredients: Capsule Studio, internal organisms, browser intelligence, extension surfaces, offline AI, memory, security awareness, and build automation. The production problem is organization. This charter converts those parts into a release operating system.

The rule: every release must be useful, explainable, installable, bounded, and provable.

## Page 2 — Release Roles

NOVA owns creation and runtime coordination. CAIN owns challenge and boundary review. ORO owns resource planning and release sequencing. Public browser intelligence owns the user-facing product. Capsule Studio owns app generation and local runtime workspaces. GitHub owns traceability and pull request receipts.

```json
{
  "release_roles": {
    "NOVA": "build and orchestrate",
    "CAIN": "challenge and protect",
    "ORO": "resource and package",
    "BrowserProduct": "install and use",
    "GitHub": "trace and publish"
  }
}
```

## Page 3 — Public-Safe Release Rules

Public language must be accurate. Do not publish private internals, secret architecture, exploit details, private trunk names, or claims that require third-party proof. Public pages should describe what users can do today: install, open, summarize, research, remember, scan, export, and build. If a capability is experimental, say so.

A release is public-safe when it passes CAIN review for claims, cyber boundary, privacy language, and install accuracy.

## Page 4 — Documentation Stack

Every serious release should include seven documents: README, PUBLIC_RELEASE, INSTALL, PRODUCT_CHARTER, PRIVACY_BOUNDARY, SECURITY_BOUNDARY, and ROADMAP. Internal releases also need PRODUCTION, OPERATOR_BOUNDARY, MANIFEST, RECEIPTS, and INTERNAL_CHARTER.

```text
public docs = adoption + trust
internal docs = governance + proof
release docs = repeatability + marketing
```

## Page 5 — Code Surfaces

The platform has three main code surfaces. Capsule Studio creates and manages workspaces. The internal AI layer routes requests through organisms and gates. The browser AI repo exposes the public user surface. Production means these surfaces should not be tangled. They should exchange manifests and public-safe packets.

Example bridge contract:

```json
{
  "product": "browser-intelligence",
  "publicRepo": "FreddyCreates/potential-succotash",
  "privateGovernance": "ItsNotAILABS/NOVA-private-root",
  "allowedBridge": ["capability_manifest", "release_status", "public_docs", "safe_claims"],
  "deniedBridge": ["secrets", "private_trunk", "unreleased internals"]
}
```

## Page 6 — Receipts and Manifests

Receipts are how the system proves work happened. A receipt should include timestamp, actor lane, organism, route, decision, changed artifacts, hash, and boundary. Manifests are how the system describes what exists. A manifest should include products, capabilities, docs, build surfaces, test surfaces, safe claims, denied claims, and release status.

No public launch should be based on memory alone. The repo should contain the release packet.

## Page 7 — Marketing System

Marketing should not start with the internal organism names. It should start with user outcomes. For browser intelligence: read faster, research deeper, remember more, stay aware, export results, and keep core workflows local. For Capsule Studio: describe an app, generate it, edit it, preview it, deploy locally. For the platform: build, govern, release.

The message ladder is:

1. User outcome.
2. Product surface.
3. Technical proof.
4. Governance boundary.
5. Roadmap.

## Page 8 — Launch Channels

The public repo can support GitHub Releases, README launch, docs site, extension ZIP, desktop build instructions, LinkedIn/X posts, demos, and screenshots. The internal root repo supports charters, release packets, and operator instructions. The same message should be adapted to each channel but not diluted.

```md
GitHub: installation and proof.
Website: outcome and demos.
X/LinkedIn: story and screenshots.
Docs: trust and support.
Internal root: governance and release gates.
```

## Page 9 — Cyber-Tech Release Gate

Cyber language must be handled carefully. Public wording can say "safety awareness," "phishing indicators," "suspicious content cues," and "defensive review." It should not say the product prevents all attacks, replaces security teams, or provides offensive capability. CAIN should review all cyber claims and produce a receipt.

Any request for exploit chains, malware, persistence, evasion, credential theft, or unauthorized access must be denied or converted into defensive education.

## Page 10 — Build-to-Market Workflow

The workflow is: build in root, inspect code, generate internal papers, create public-safe packet, apply to public repo, open PR, review, merge, tag release, publish release notes, market with approved copy. This keeps public releases connected to private proof without leaking private internals.

```bash
# conceptual workflow
root/build -> root/review -> public/docs -> public/release -> public/market
```

## Page 11 — Platform Creation Roadmap

The next platform milestone is a visible dashboard that shows product inventory, release status, docs status, gates, receipts, and public-safe readiness. The dashboard should allow the founder to click a product and see: current repo, install command, public docs, internal status, pending risks, and next action.

After that, connect Capsule Studio to import public repo manifests and generate release packets automatically.

## Page 12 — Production Acceptance

Production begins when a user can install the public product, understand the promise, use the basic workflow, and trust the boundaries. Marketing begins when the public repo contains clear product docs, release notes, install steps, privacy boundary, security boundary, and screenshots or demos. Platform maturity begins when NOVA, CAIN, and ORO can govern that process repeatedly.
