# GitHub Pages Configuration for NOVA Julia-Motoko Bridge

This directory contains the GitHub Pages configuration for the NOVA Julia-Motoko Bridge landing page.

## Setup Instructions

### 1. Enable GitHub Pages

In your GitHub repository settings:
1. Go to **Settings** → **Pages**
2. Under **Source**, select: **Deploy from a branch**
3. Under **Branch**, select: `main` (or your default branch)
4. Under **Folder**, select: `/docs`
5. Click **Save**

### 2. Access Your Site

After a few minutes, your site will be live at:
```
https://itsnotailabs.github.io/NOVA/julia-motoko-bridge.html
```

### 3. Custom Domain (Optional)

If you want a custom domain:
1. Add a `CNAME` file with your domain name
2. Configure DNS records with your domain provider
3. Enable HTTPS in GitHub Pages settings

## Files

- **`julia-motoko-bridge.html`** — Main landing page with interactive UI
- **`JULIA_MOTOKO_LANDING.md`** — Markdown documentation (GitHub renders)
- **`JULIA_MOTOKO_PRIOR_ART.md`** — Prior art analysis
- **`AUTO_GENERATED_MOTOKO_EXAMPLES.md`** — Code examples
- **`_config.yml`** — Jekyll configuration (for GitHub Pages)

## Jekyll Theme

GitHub Pages uses Jekyll by default. The `_config.yml` configures:
- Site title and description
- Theme (GitHub's Cayman theme)
- Markdown flavor (GFM)
- Excluded files

## Development

To test locally:
```bash
# Install Jekyll
gem install bundler jekyll

# Serve locally
cd docs
jekyll serve

# Visit http://localhost:4000/NOVA/julia-motoko-bridge.html
```

## Notes

- HTML file is served directly (no Jekyll processing)
- Markdown files are automatically rendered by GitHub
- Links are relative to the `docs/` directory
- Assets (images, CSS) should be placed in `docs/assets/`

---

**🌟 NOVA Julia-Motoko Bridge — First in the World 🌟**
