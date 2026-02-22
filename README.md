# Static Site Generator

A simple static site generator with Jinja2 templates, JSON content, and Cloudflare Pages deployment.

## Quick Start

### Automated Onboarding

```bash
./onboard.sh
```

This will:
1. Configure your site (domain, title, description)
2. Create a GitHub repository
3. Set up Cloudflare Pages project
4. Configure deployment secrets
5. Deploy your site

### Prerequisites

- [GitHub CLI](https://cli.github.com/) - `brew install gh`
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/) - `npm install -g wrangler`
- Python 3.8+

## Manual Setup

1. **Configure your site**
   ```bash
   # Edit site/config.json with your domain and title
   ```

2. **Test locally**
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   python build.py
   # Open dist/index.html in browser
   ```

3. **Deploy**
   - Push to GitHub
   - Set repository secrets:
     - `CLOUDFLARE_API_TOKEN`
     - `CLOUDFLARE_ACCOUNT_ID`
   - Set repository variable:
     - `CLOUDFLARE_PROJECT_NAME`

## Directory Structure

```
├── site/
│   ├── config.json           # Site configuration
│   ├── content/
│   │   ├── homepage.json     # Homepage content
│   │   └── articles/
│   │       └── my-post.json  # Article files
│   └── media/
│       └── images/           # Images and assets
├── templates/
│   ├── base.html             # Base layout
│   ├── homepage.html         # Homepage template
│   └── article.html          # Article template
├── shared/
│   └── style.css             # Styles
├── build.py                  # Build script
└── onboard.sh                # Onboarding script
```

## Content Format

### config.json
```json
{
  "domain": "example.com",
  "title": "My Site",
  "description": "Site description for SEO",
  "language": "en"
}
```

### Article (articles/my-post.json)
```json
{
  "title": "Article Title",
  "description": "SEO description",
  "date": "2024-01-15",
  "author": "Author Name",
  "image": "/media/images/hero.jpg",
  "tags": ["tag1", "tag2"],
  "content": "Markdown content here..."
}
```

## Commands

```bash
# Build site
python build.py

# Output in dist/
```

## License

MIT
