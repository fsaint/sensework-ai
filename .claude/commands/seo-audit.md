# SEO Audit & Recommendations

Analyze the site and provide comprehensive SEO recommendations based on 2025/2026 best practices.

## How to Run This Audit

1. Read the site's `config.json`, `homepage.json`, and all articles in `content/articles/`
2. Read the templates (`base.html`, `homepage.html`, `article.html`)
3. Read `shared/style.css` for performance considerations
4. Build the site and analyze the generated HTML in `dist/`
5. Generate a comprehensive SEO report with actionable recommendations

## SEO Audit Categories

### 1. Technical SEO

#### Core Web Vitals & Performance
- **LCP (Largest Contentful Paint)**: Must be under 2.5 seconds
  - Check image sizes and formats (recommend WebP/AVIF)
  - Verify lazy loading is NOT applied to hero/LCP images
  - Check CSS/JS file sizes
- **INP (Interaction to Next Paint)**: Must be under 200ms
  - Minimize JavaScript blocking
- **CLS (Cumulative Layout Shift)**: Must be under 0.1
  - All images must have width/height attributes
  - No layout-shifting elements

#### Crawlability
- Verify `sitemap.xml` exists and is valid
- Verify `robots.txt` exists and references sitemap
- Check for orphaned pages (no internal links pointing to them)
- Ensure all URLs are lowercase, use hyphens, and are under 60 characters

#### Mobile & Security
- Verify viewport meta tag exists
- Confirm responsive design patterns in CSS
- Verify HTTPS is used in all canonical URLs and sitemap

### 2. On-Page SEO

#### Meta Tags (per page)
Required tags to verify in `<head>`:
- `<title>`: 50-60 characters, includes primary keyword
- `<meta name="description">`: 150-160 characters, compelling, includes keyword
- `<link rel="canonical">`: Absolute URL, matches page URL
- `<meta name="viewport">`: Must be present for mobile

#### Open Graph Tags
- `og:type`: "website" for homepage, "article" for articles
- `og:title`: Same as title or slightly different
- `og:description`: Same as meta description
- `og:url`: Canonical URL
- `og:image`: Absolute URL, minimum 1200x630px
- `og:site_name`: Site title

#### Twitter Card Tags
- `twitter:card`: "summary_large_image" recommended
- `twitter:title`, `twitter:description`, `twitter:image`

#### JSON-LD Structured Data
Verify proper schema.org markup:
- **Homepage**: WebSite schema with name, url, description
- **Articles**: Article schema with headline, datePublished, author, description
- Optional but recommended: Organization, BreadcrumbList

#### Heading Structure
- Exactly ONE `<h1>` per page
- Logical hierarchy: H1 → H2 → H3 (no skipping levels)
- H1 should contain primary keyword
- Headings should be descriptive, not generic

#### Content Quality (E-E-A-T)
- **Experience**: First-hand knowledge evident?
- **Expertise**: Author credentials visible?
- **Authoritativeness**: Is the site/author recognized?
- **Trustworthiness**: Clear contact info, accurate content?

Check articles for:
- Author attribution with credentials
- Publication date (and update date if revised)
- Accurate, helpful content
- Original insights, not just aggregated info

### 3. Content SEO

#### URL Slugs
- 3-5 words, 25-60 characters
- Lowercase only
- Hyphens between words (not underscores)
- Include primary keyword
- No dates, special characters, or stop words

#### Content Structure
- Lead with the answer (featured snippet optimization)
- Use clear H2/H3 for sections
- Include FAQ sections where relevant
- Aim for 40-60 word direct answers to questions
- Break up text with lists, tables, images

#### Keyword Optimization
- Primary keyword in: title, H1, first paragraph, URL
- Related keywords naturally throughout
- Don't keyword stuff
- One primary topic per page

#### Internal Linking
- Every page should have 3-10 internal links
- Use descriptive anchor text (not "click here")
- Link to related content contextually
- No orphaned pages
- Important pages within 3 clicks of homepage

### 4. Image SEO

#### Alt Text
- Descriptive, under 125 characters
- Include keywords naturally
- Describe what's IN the image
- Don't start with "Image of..." or "Picture of..."

#### Technical
- Use WebP or AVIF format
- Compress images (aim for < 100KB for thumbnails, < 500KB for hero)
- Include width/height attributes to prevent CLS
- Use descriptive filenames (not IMG_1234.jpg)
- Lazy load below-the-fold images only

### 5. Local SEO (if applicable)

#### NAP Consistency
- Name, Address, Phone identical everywhere
- Include in footer or contact page
- Use LocalBusiness schema

### 6. Off-Page Considerations

#### Social Sharing
- OG images optimized (1200x630px, 16:9 ratio)
- Shareable URLs (clean, descriptive)
- Social meta tags complete

---

## Output Format

Generate a report with:

### SEO Score: X/100

### Critical Issues (Fix Immediately)
- List issues that severely impact SEO

### Warnings (Should Fix)
- List issues that moderately impact SEO

### Recommendations (Nice to Have)
- List optimization opportunities

### Per-Page Analysis
For each page (homepage + articles):
- Title tag analysis
- Meta description analysis
- Heading structure
- Content length and quality notes
- Internal linking status
- Schema markup status

### Action Items Checklist
Prioritized list of specific fixes with file paths and line numbers where applicable.

---

## Reference: Optimal Tag Lengths

| Element | Optimal Length |
|---------|---------------|
| Title tag | 50-60 characters |
| Meta description | 150-160 characters |
| URL slug | 25-60 characters (3-5 words) |
| H1 | Include primary keyword |
| Alt text | Under 125 characters |
| OG image | 1200x630px minimum |
| Featured snippet answer | 40-60 words |

## Reference: Required Schema Types

### WebSite (homepage)
```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "Site Name",
  "url": "https://example.com",
  "description": "Site description"
}
```

### Article (blog posts)
```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "Article Title",
  "description": "Article description",
  "datePublished": "2025-01-15",
  "dateModified": "2025-01-20",
  "author": {
    "@type": "Person",
    "name": "Author Name"
  },
  "publisher": {
    "@type": "Organization",
    "name": "Site Name"
  }
}
```

## User Arguments

$ARGUMENTS
