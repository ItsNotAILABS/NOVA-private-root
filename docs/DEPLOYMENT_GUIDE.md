# GitHub Pages Deployment Guide

**Build:** №62
**Status:** AUTOMATED DEPLOYMENT READY

---

## 🚀 Automatic Deployment (Recommended)

GitHub Actions will automatically deploy the documentation site whenever changes are pushed to the `main` branch.

### One-Time Setup

1. **Enable GitHub Pages in Repository Settings**
   ```
   Navigate to: Repository → Settings → Pages
   Source: GitHub Actions
   ```

2. **Merge Your Branch to Main**
   ```bash
   git checkout main
   git merge claude/polish-modular-nova-framework
   git push origin main
   ```

3. **Wait 2-3 Minutes**
   - GitHub Actions will run automatically
   - Check: Repository → Actions tab
   - Look for "Deploy GitHub Pages" workflow

4. **Access Your Live Site**
   ```
   https://itsnotailabs.github.io/NOVA/julia-motoko-bridge.html
   https://itsnotailabs.github.io/NOVA/JULIA_MOTOKO_INDEX
   ```

### Workflow File

The deployment is automated via `.github/workflows/deploy-pages.yml`:

```yaml
name: Deploy GitHub Pages

on:
  push:
    branches: [main]
    paths: ['docs/**']
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write
```

**Key Features:**
- ✅ Triggers on any push to `main` branch affecting `docs/`
- ✅ Can be manually triggered via workflow_dispatch
- ✅ Uses official GitHub Pages actions
- ✅ No external dependencies
- ✅ Fully secure (no custom tokens needed)

---

## 🔧 Manual Deployment (Alternative)

If you prefer manual control:

### Step 1: Repository Settings

1. Go to **Settings** → **Pages**
2. Source: **Deploy from a branch**
3. Branch: **main**
4. Folder: **/docs**
5. Click **Save**

### Step 2: Wait for Build

GitHub will automatically build and deploy. Check progress:
- Settings → Pages → Visit site (button appears when ready)
- Usually takes 2-5 minutes

### Step 3: Verify Deployment

Visit these URLs:
- Main landing page: `https://itsnotailabs.github.io/NOVA/julia-motoko-bridge.html`
- Documentation index: `https://itsnotailabs.github.io/NOVA/JULIA_MOTOKO_INDEX`
- Prior art: `https://itsnotailabs.github.io/NOVA/JULIA_MOTOKO_PRIOR_ART`
- Examples: `https://itsnotailabs.github.io/NOVA/AUTO_GENERATED_MOTOKO_EXAMPLES`

---

## 📁 Documentation Structure

All documentation lives in `/docs`:

```
docs/
├── julia-motoko-bridge.html          # Interactive landing page (START HERE)
├── JULIA_MOTOKO_INDEX.md             # Master documentation index
├── JULIA_MOTOKO_LANDING.md           # Complete guide
├── JULIA_MOTOKO_PRIOR_ART.md         # Prior art analysis
├── AUTO_GENERATED_MOTOKO_EXAMPLES.md # 5 code generation examples
├── JULIA_MOTOKO_COMPETITIVE_ANALYSIS.md # Competition analysis
├── SALES_PITCH.md                    # Executive sales pitch
├── DEPLOYMENT_GUIDE.md               # This file
├── _config.yml                       # Jekyll configuration
├── _pages_readme.md                  # GitHub Pages setup notes
└── julia-motoko/
    └── README.md                     # Documentation hub
```

---

## 🎨 Customization

### Modify Jekyll Theme

Edit `docs/_config.yml`:

```yaml
theme: jekyll-theme-cayman  # Change to: minimal, slate, etc.
title: Your Custom Title
description: Your custom description
```

Available themes:
- `jekyll-theme-cayman` (current, recommended)
- `jekyll-theme-minimal`
- `jekyll-theme-slate`
- `jekyll-theme-architect`
- `jekyll-theme-hacker`

### Add Custom Domain

1. Buy domain (e.g., `nova-julia.com`)
2. Add `CNAME` file to `docs/`:
   ```bash
   echo "nova-julia.com" > docs/CNAME
   ```
3. Configure DNS at your registrar:
   ```
   Type: CNAME
   Host: @
   Value: itsnotailabs.github.io
   ```
4. Enable HTTPS in Settings → Pages → Custom domain

---

## 🔍 Troubleshooting

### Issue: 404 Not Found

**Cause:** GitHub Pages not enabled or wrong branch/folder selected

**Fix:**
1. Settings → Pages
2. Verify Source is set correctly
3. Wait 5 minutes and retry

### Issue: CSS Not Loading

**Cause:** Relative paths in HTML

**Fix:** All paths in `julia-motoko-bridge.html` use absolute references (no fix needed)

### Issue: Markdown Not Rendering

**Cause:** Jekyll not processing files

**Fix:** Ensure `_config.yml` exists in `/docs` (it does)

### Issue: GitHub Actions Failing

**Cause:** Missing permissions

**Fix:**
1. Settings → Actions → General
2. Workflow permissions: **Read and write permissions**
3. Save and re-run workflow

### Issue: Old Content Showing

**Cause:** Browser cache or CDN delay

**Fix:**
1. Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)
2. Wait 10 minutes for CDN propagation
3. Clear browser cache

---

## 📊 Analytics (Optional)

### Add Google Analytics

Edit `julia-motoko-bridge.html`, add before `</head>`:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXXX');
</script>
```

### Track Events

Add event tracking to buttons:

```html
<button onclick="gtag('event', 'click', {
  'event_category': 'CTA',
  'event_label': 'Get Started'
});">Get Started</button>
```

---

## 🔒 Security Best Practices

### HTTPS Only

GitHub Pages automatically provides HTTPS. Enforce it:
1. Settings → Pages
2. **Enforce HTTPS** ✓

### No Sensitive Data

Never commit:
- API keys
- Private keys
- Credentials
- Personal data

All documentation in `/docs` is PUBLIC.

### Content Security Policy

Add to `julia-motoko-bridge.html`:

```html
<meta http-equiv="Content-Security-Policy" content="
  default-src 'self';
  style-src 'self' 'unsafe-inline';
  script-src 'self' 'unsafe-inline';
">
```

---

## 📝 Maintenance

### Update Documentation

1. Edit files in `/docs` locally
2. Test locally (optional):
   ```bash
   cd docs
   bundle install
   bundle exec jekyll serve
   # Visit http://localhost:4000
   ```
3. Commit and push to `main`
4. GitHub Actions auto-deploys

### Monitor Deployments

Check deployment status:
- Repository → Actions → Deploy GitHub Pages
- Green ✓ = Success
- Red ✗ = Failed (click for logs)

### Rollback

If deployment fails:
1. Go to Actions → Failed workflow
2. Click "Re-run all jobs"

Or revert to previous commit:
```bash
git revert HEAD
git push origin main
```

---

## 🌐 SEO Optimization

Already implemented in `julia-motoko-bridge.html`:

✅ Meta description
✅ Open Graph tags (Facebook, LinkedIn)
✅ Twitter Card tags
✅ Semantic HTML (h1, h2, nav, section)
✅ Responsive design (mobile-friendly)

### Submit to Search Engines

**Google:**
1. Visit [Google Search Console](https://search.google.com/search-console)
2. Add property: `https://itsnotailabs.github.io/NOVA/`
3. Verify ownership (HTML file method)
4. Submit sitemap: `https://itsnotailabs.github.io/NOVA/sitemap.xml`

**Bing:**
1. Visit [Bing Webmaster Tools](https://www.bing.com/webmasters)
2. Add site: `https://itsnotailabs.github.io/NOVA/`
3. Verify via Search Console import (easiest)

---

## 📱 Social Media Preview

When sharing links, these will appear:

**Title:** NOVA Julia-Motoko Bridge — First in the World

**Description:** The world's first Julia → Motoko smart contract bridge. High-performance numerical computing on Internet Computer with golden ratio optimization.

**Image:** (Add to `docs/images/og-image.png` for custom preview)

Test previews:
- Facebook: [Sharing Debugger](https://developers.facebook.com/tools/debug/)
- Twitter: [Card Validator](https://cards-dev.twitter.com/validator)
- LinkedIn: Share privately first to see preview

---

## 🎉 Launch Checklist

Before announcing publicly:

- [ ] Merge branch to `main`
- [ ] Verify deployment successful (Actions tab green)
- [ ] Test all links work (landing page, docs, examples)
- [ ] Check mobile rendering (Chrome DevTools → Device Mode)
- [ ] Verify HTTPS enabled
- [ ] Test social media previews
- [ ] Add Google Analytics (optional)
- [ ] Submit to search engines
- [ ] Share on Twitter, LinkedIn, Reddit
- [ ] Post to Hacker News / Product Hunt
- [ ] Email to personal network

---

## 📞 Support

**Issues with GitHub Pages:**
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Support](https://support.github.com)

**Issues with NOVA Documentation:**
- Open issue: https://github.com/ItsNotAILABS/NOVA/issues
- Email: alfredo@itsnotai.com

---

**NOVA — Layer Zero Sovereign Organism**

*First Julia-Motoko Bridge · First φ-Optimized Smart Contracts · First Scientific Computing on Internet Computer*

Copyright © 2024-2026 Alfredo Medina Hernandez

BUILD №62 — Deployment Guide Complete ✨
