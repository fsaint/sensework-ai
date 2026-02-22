# Claude Code Project Instructions

## Site: sensework.ai

Static site for Sensework.ai - "Making sense of work with AI"

## Deployment Flow

**This site deploys via GitHub Actions (never directly):**

1. Make changes to content or code
2. Commit and push to `main` branch
3. GitHub Actions automatically:
   - Runs `python build.py`
   - Deploys `dist/` to Cloudflare Pages

**Never run `wrangler pages deploy` directly.**

## Quick Commands

```bash
# Build locally
python build.py

# Preview (open in browser)
open dist/index.html

# Deploy (push to GitHub)
git add -A && git commit -m "Update content" && git push
```

## Content Management

Use Claude Code skills:

- `/site` - List and manage content
- `/new-article` - Create a new article
- `/build-site` - Build the site locally
- `/seo-audit` - Run SEO audit
- `/seo-tips` - Quick SEO recommendations

## File Structure

```
sensework.ai/
├── site/
│   ├── config.json             # Site configuration
│   └── content/
│       ├── homepage.json       # Homepage content
│       └── articles/           # Blog articles
├── templates/                  # Jinja2 templates
├── shared/style.css           # Styles
├── dist/                       # Built output (git-ignored)
└── .github/workflows/deploy.yml
```

## GitHub Secrets (must be configured)

| Secret | Description |
|--------|-------------|
| `CLOUDFLARE_API_TOKEN` | API token with Pages:Edit permission |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account ID |

## GitHub Variables (must be configured)

| Variable | Value |
|----------|-------|
| `CLOUDFLARE_PROJECT_NAME` | `sensework-ai` |

## Setup Checklist

- [ ] GitHub repo created
- [ ] Cloudflare Pages project `sensework-ai` created
- [ ] `CLOUDFLARE_API_TOKEN` secret set
- [ ] `CLOUDFLARE_ACCOUNT_ID` secret set
- [ ] `CLOUDFLARE_PROJECT_NAME` variable set
- [ ] First deployment successful

Run `./validate.sh` to check setup status.
