# Sync Instructions for `FreddyCreates/potential-succotash`

The GitHub App could read the public repository, but write operations returned `403 Resource not accessible by integration`. Until the integration has write access, copy this folder into the public repo manually or re-run with an installation that can write to the repo.

## Copy Map

```text
public-release/potential-succotash/PUBLIC_RELEASE.md
  -> PUBLIC_RELEASE.md

public-release/potential-succotash/docs/public/INSTALL_AND_FIRST_RUN.md
  -> docs/public/INSTALL_AND_FIRST_RUN.md

public-release/potential-succotash/docs/public/PRIVACY_BOUNDARY.md
  -> docs/public/PRIVACY_BOUNDARY.md

public-release/potential-succotash/docs/public/SECURITY_BOUNDARY.md
  -> docs/public/SECURITY_BOUNDARY.md

public-release/potential-succotash/docs/public/MARKETING_LAUNCH_COPY.md
  -> docs/public/MARKETING_LAUNCH_COPY.md

public-release/potential-succotash/docs/public/ROADMAP_PUBLIC.md
  -> docs/public/ROADMAP_PUBLIC.md

public-release/potential-succotash/protocols/public/browser-intelligence-public-manifest.json
  -> protocols/public/browser-intelligence-public-manifest.json
```

## Suggested Commit Message

```text
Add public-safe Sonic Ninja release documentation
```

## Suggested PR Title

```text
Public-safe browser intelligence release kit
```

## Public Repo Release Order

1. Add the files above.
2. Link `PUBLIC_RELEASE.md` from `README.md`.
3. Confirm extension install flow.
4. Confirm build/test commands.
5. Add screenshots or a short demo.
6. Create a GitHub Release.
7. Publish the marketing launch copy.
