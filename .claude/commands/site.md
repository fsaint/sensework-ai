# Site Content Manager

Manage content for this static site. This skill helps you create, update, and manage site content.

## Available Commands

When the user runs `/site`, ask what they want to do:

1. **list content** - List all content (articles, homepage)
2. **new article** - Create a new article
3. **edit article [slug]** - Edit an existing article
4. **edit homepage** - Edit homepage content
5. **edit config** - Edit site configuration
6. **build** - Build the site
7. **preview** - Build and show file listing

## Directory Structure

```
site/
├── config.json          # Site config
├── content/
│   ├── homepage.json    # Homepage content
│   └── articles/
│       └── {slug}.json  # Article files
└── media/
    └── images/
```

## Content Schemas

### config.json
```json
{
  "domain": "example.com",
  "title": "Site Title",
  "description": "SEO description",
  "language": "en"
}
```

### homepage.json
```json
{
  "hero_title": "Welcome",
  "hero_subtitle": "Tagline",
  "cta_text": "Learn More",
  "cta_link": "/article-slug/",
  "sections": [
    {
      "title": "Section Title",
      "content": "Markdown content here",
      "features": [
        {"title": "Feature", "description": "Description"}
      ]
    }
  ]
}
```

### Article JSON ({slug}.json)
```json
{
  "title": "Article Title",
  "description": "SEO description",
  "date": "YYYY-MM-DD",
  "author": "Author Name",
  "image": "/media/images/hero.jpg",
  "tags": ["tag1", "tag2"],
  "content": "Markdown content here..."
}
```

## Instructions

1. When listing content, read `site/content/` directory structure
2. When creating articles, generate a slug from the title (lowercase, hyphens, no special chars)
3. Always set today's date for new articles: $CURRENT_DATE
4. After creating/editing content, ask if the user wants to build the site
5. For the build command, run: `source .venv/bin/activate && python build.py` or `python3 build.py`

## User Arguments

$ARGUMENTS
