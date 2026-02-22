# Create New Article

Create a new article for this site.

## Instructions

1. Ask for article details:
   - **Title** (required): Article title
   - **Description** (required): SEO meta description (1-2 sentences)
   - **Author** (optional): Author name
   - **Tags** (optional): Comma-separated tags
   - **Image** (optional): Path to hero image (e.g., /media/images/hero.jpg)

2. Generate slug from title:
   - Lowercase
   - Replace spaces with hyphens
   - Remove special characters
   - Example: "Getting Started Guide" → "getting-started-guide"

3. Create article file at `site/content/articles/{slug}.json`:
```json
{
  "title": "{title}",
  "description": "{description}",
  "date": "$CURRENT_DATE",
  "author": "{author}",
  "image": "{image}",
  "tags": [{tags}],
  "content": "Start writing your article content here.\n\n## Section 1\n\nYour content..."
}
```

4. After creating, show the user:
   - File path created
   - URL the article will be at: `/{slug}/`
   - Remind them to edit the content field with their article

5. Ask if they want to build the site now.

## Arguments

If arguments provided, parse as: `title`

$ARGUMENTS
