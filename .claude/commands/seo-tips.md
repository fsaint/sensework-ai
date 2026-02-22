# SEO Tips & Quick Fixes

Provide quick, actionable SEO tips for specific content or issues.

## Usage

Run `/seo-tips` with optional arguments:
- `/seo-tips title` - Get title tag recommendations
- `/seo-tips meta` - Get meta description recommendations
- `/seo-tips content [slug]` - Analyze specific article content
- `/seo-tips images` - Check image optimization
- `/seo-tips schema` - Verify structured data
- `/seo-tips speed` - Performance recommendations

## Quick Reference Guide

### Title Tags (50-60 chars)
**Formula**: Primary Keyword + Secondary Keyword + Brand
**Examples**:
- "Static Site Generator Guide | Build Fast Websites | MySite"
- "10 SEO Tips for 2025: Rank Higher on Google"

**Checklist**:
- [ ] Under 60 characters
- [ ] Primary keyword near the beginning
- [ ] Compelling and click-worthy
- [ ] Unique across all pages
- [ ] Brand name at end (optional)

### Meta Descriptions (150-160 chars)
**Formula**: Hook + Value Proposition + CTA
**Examples**:
- "Learn how to build blazing-fast static sites with our step-by-step guide. Includes templates, deployment tips, and SEO best practices. Start building today."

**Checklist**:
- [ ] 150-160 characters
- [ ] Includes primary keyword naturally
- [ ] Has a call-to-action
- [ ] Unique per page
- [ ] Summarizes page value

### URL Slugs (3-5 words)
**Good**: `/static-site-seo-guide`
**Bad**: `/2024/01/15/the-ultimate-guide-to-seo-for-static-sites-part-1`

**Checklist**:
- [ ] 3-5 words only
- [ ] Lowercase
- [ ] Hyphens (not underscores)
- [ ] No dates
- [ ] No stop words (the, and, of)
- [ ] Contains primary keyword

### H1 Headings
**Checklist**:
- [ ] Exactly ONE per page
- [ ] Contains primary keyword
- [ ] Different from title tag (can overlap)
- [ ] Describes page content clearly
- [ ] Under 70 characters ideal

### Content Structure for Featured Snippets
To win featured snippets, structure content like this:

```
## What is [Topic]?

[Topic] is [40-60 word direct definition/answer].
[Additional context and details...]
```

**For lists**:
```
## How to [Do Thing]

1. **Step One**: Description
2. **Step Two**: Description
3. **Step Three**: Description
```

**For comparisons**:
Use tables with clear headers.

### Image Optimization Checklist
- [ ] Descriptive filename: `seo-audit-checklist.webp` not `IMG_1234.jpg`
- [ ] WebP or AVIF format
- [ ] Compressed (< 100KB thumbnails, < 500KB hero)
- [ ] Width and height attributes set
- [ ] Alt text under 125 chars, descriptive
- [ ] Lazy loading for below-fold images only
- [ ] NOT lazy loading hero/LCP image

### Internal Linking Rules
- Every article links to 3-5 related articles
- Use descriptive anchor text: "learn about SEO best practices" not "click here"
- Link from older content to newer content
- Link from high-authority pages to important pages
- No orphaned pages

### Schema Markup Quick Check
Run `python build.py` then check generated HTML for:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  ...
}
</script>
```

**Required fields for Article**:
- headline
- datePublished
- description

**Recommended fields**:
- author (with @type: Person)
- publisher (with @type: Organization)
- image
- dateModified

### E-E-A-T Quick Wins

**Experience**:
- Add "Tested on..." or "Based on my experience with..."
- Include screenshots, real examples
- Share specific results/data

**Expertise**:
- Add author bio with credentials
- Link to author's other work
- Cite sources

**Authoritativeness**:
- Get mentioned/linked from other sites
- Build social proof
- Create comprehensive, definitive content

**Trustworthiness**:
- Add contact information
- Show privacy policy
- Keep content accurate and updated
- Display dates on articles

### Speed Optimization Tips

1. **Images**: Convert to WebP, compress, set dimensions
2. **CSS**: Keep under 50KB, inline critical CSS
3. **Fonts**: Use system font stack or preload web fonts
4. **HTML**: Minimize, use semantic elements
5. **Hosting**: Use CDN (Cloudflare Pages does this automatically)

### Common Mistakes to Avoid

1. **Duplicate title tags** across pages
2. **Missing meta descriptions**
3. **Multiple H1 tags** on one page
4. **Keyword stuffing** in content
5. **Broken internal links**
6. **Missing alt text** on images
7. **Slow-loading images** (uncompressed, wrong format)
8. **Orphaned pages** with no internal links
9. **Non-descriptive anchor text** ("click here", "read more")
10. **Missing canonical tags**

## User Arguments

$ARGUMENTS
