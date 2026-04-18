# AGENTS.md

This document is the operating guide for automated coding agents and contributors working in this repository.

## Scope

- Applies to the entire repository unless a deeper-level `AGENTS.md` is added in a subdirectory.
- Follow these instructions together with any task-specific user request.

## Project overview

NOVA (PARALLAX) is an Internet Computer (DFX/Motoko) codebase with:

- **Primary backend canisters (Motoko)** under `src/`
  - `src/swarm_brain/`
  - `src/swarm_organism/`
- **Frontend (Vite + React + TypeScript)** under `src/frontend/`
- **Motoko tests** under `tests/motoko/`
- **CI build verification** under `.github/workflows/motoko-check.yml`

## Safety and boundaries

- Treat this repository as **prototype/confidential code**.
- Do not change ownership/sovereignty logic without explicit request.
- Keep changes focused; avoid broad refactors unless required.
- Prefer minimal diffs that preserve existing naming and style.

## Recommended workflow

1. Read relevant files first (`README`, architecture docs, touched modules).
2. Make the smallest viable code change.
3. Run targeted verification for touched areas.
4. Update docs if behavior/usage changes.
5. Commit with a clear message.

## Environment and tooling

### Motoko / DFX

CI uses DFX `0.24.3`, so align with that when possible.

Typical local validation flow:

```bash
dfx --version
dfx start --background --clean
dfx canister create --all
dfx build
dfx stop
```

### Frontend

From `src/frontend`:

```bash
npm install
npm run dev
npm run build
npm run test:run
```

## Testing expectations

- For Motoko changes, run at least `dfx build`.
- For frontend changes, run `npm run build` and relevant tests (`npm run test:run`).
- If a full test pass is too expensive, run the most relevant subset and state what was validated.

## File and code conventions

- Keep files ASCII unless existing content requires Unicode.
- Avoid introducing new dependencies unless necessary.
- If adding dependencies, use the package manager and current stable versions.
- Add concise comments only where logic is non-obvious.
- Do not rewrite copyright or proprietary notices.

## PR and commit guidance

- Use descriptive, scoped commit messages.
- Keep one logical change per commit whenever practical.
- Include a short verification summary in PR description:
  - What changed
  - Why it changed
  - How it was validated
  - Any known limitations

## Quick directory map

- `src/swarm_brain/` - Core organism brain and module graph
- `src/swarm_organism/` - Organism-level orchestration canister
- `src/frontend/` - Web UI (Vite/React)
- `tests/motoko/` - Motoko test suites and runner
- `.github/workflows/` - CI workflows
- `dfx.json` - Canister definitions and DFX config

