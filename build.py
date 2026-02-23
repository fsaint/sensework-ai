#!/usr/bin/env python3
"""
Static Site Generator - Single Site Build Script
"""

import json
import shutil
from pathlib import Path
from datetime import datetime

import markdown
from jinja2 import Environment, FileSystemLoader


def load_json(path: Path) -> dict:
    """Load JSON file and return dict."""
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def render_markdown(text: str) -> str:
    """Convert markdown to HTML."""
    return markdown.markdown(text, extensions=['fenced_code', 'tables', 'toc'])


def calculate_reading_time(text: str) -> int:
    """Calculate estimated reading time in minutes."""
    words = len(text.split())
    return max(1, round(words / 200))  # Average 200 words per minute


def generate_json_ld(config: dict, page_type: str, data: dict = None) -> str:
    """Generate JSON-LD structured data."""
    base_url = f"https://{config['domain']}"

    if page_type == "homepage":
        schema = {
            "@context": "https://schema.org",
            "@type": "WebSite",
            "url": base_url,
            "name": config["title"],
            "description": config.get("description", ""),
            "publisher": {
                "@type": "Organization",
                "name": config["title"],
                "url": base_url
            }
        }
    elif page_type == "article":
        schema = {
            "@context": "https://schema.org",
            "@type": "Article",
            "mainEntityOfPage": {
                "@type": "WebPage",
                "@id": f"{base_url}/{data.get('slug', '')}/"
            },
            "url": f"{base_url}/{data.get('slug', '')}/",
            "headline": data.get("title", ""),
            "description": data.get("description", ""),
            "datePublished": data.get("date", ""),
            "publisher": {
                "@type": "Organization",
                "name": config["title"],
                "url": base_url
            }
        }
        # Add optional fields if present
        if data.get("modified_date"):
            schema["dateModified"] = data["modified_date"]
        else:
            schema["dateModified"] = data.get("date", "")

        if data.get("author"):
            schema["author"] = {
                "@type": "Person",
                "name": data["author"]
            }

        if data.get("image"):
            schema["image"] = f"{base_url}{data['image']}"
    else:
        schema = {}

    return json.dumps(schema, indent=2)


def build_site():
    """Build the static site."""
    root = Path(__file__).parent
    config_path = root / "site" / "config.json"

    if not config_path.exists():
        print(f"Error: {config_path} not found")
        return

    config = load_json(config_path)
    domain = config["domain"]

    print(f"Building {domain}...")

    # Setup Jinja2
    env = Environment(loader=FileSystemLoader(root / "templates"))
    env.filters['markdown'] = render_markdown

    # Output directory
    dist = root / "dist"
    if dist.exists():
        shutil.rmtree(dist)
    dist.mkdir(parents=True)

    # Copy assets
    shutil.copytree(root / "shared", dist / "assets")

    # Copy media if exists
    media_src = root / "site" / "media"
    if media_src.exists():
        shutil.copytree(media_src, dist / "media")

    base_url = f"https://{domain}"

    # Build homepage
    homepage_path = root / "site" / "content" / "homepage.json"
    if homepage_path.exists():
        homepage_data = load_json(homepage_path)
        template = env.get_template("homepage.html")
        html = template.render(
            config=config,
            page=homepage_data,
            canonical_url=f"{base_url}/",
            json_ld=generate_json_ld(config, "homepage", homepage_data),
        )
        (dist / "index.html").write_text(html, encoding='utf-8')
        print("  Generated index.html")

    # Build articles
    articles_dir = root / "site" / "content" / "articles"
    articles = []

    if articles_dir.exists():
        for article_path in sorted(articles_dir.glob("*.json")):
            article_data = load_json(article_path)
            slug = article_path.stem
            article_data["slug"] = slug

            # Calculate reading time and render markdown content
            if article_data.get("content"):
                article_data["reading_time"] = calculate_reading_time(article_data["content"])
                article_data["content_html"] = render_markdown(article_data["content"])

            articles.append(article_data)

            # Render article
            template = env.get_template("article.html")
            html = template.render(
                config=config,
                article=article_data,
                canonical_url=f"{base_url}/{slug}/",
                json_ld=generate_json_ld(config, "article", article_data),
            )

            # Create clean URL directory
            article_dir = dist / slug
            article_dir.mkdir(parents=True, exist_ok=True)
            (article_dir / "index.html").write_text(html, encoding='utf-8')
            print(f"  Generated {slug}/index.html")

    # Generate sitemap.xml
    base_url = f"https://{domain}"
    sitemap_urls = [{"loc": base_url + "/", "priority": "1.0"}]
    for article in articles:
        sitemap_urls.append({
            "loc": f"{base_url}/{article['slug']}/",
            "lastmod": article.get("date", ""),
            "priority": "0.8"
        })

    sitemap = '<?xml version="1.0" encoding="UTF-8"?>\n'
    sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
    for url in sitemap_urls:
        sitemap += "  <url>\n"
        sitemap += f"    <loc>{url['loc']}</loc>\n"
        if url.get("lastmod"):
            sitemap += f"    <lastmod>{url['lastmod']}</lastmod>\n"
        sitemap += f"    <priority>{url['priority']}</priority>\n"
        sitemap += "  </url>\n"
    sitemap += "</urlset>"
    (dist / "sitemap.xml").write_text(sitemap, encoding='utf-8')
    print("  Generated sitemap.xml")

    # Generate robots.txt
    robots = f"User-agent: *\nAllow: /\nSitemap: {base_url}/sitemap.xml\n"
    (dist / "robots.txt").write_text(robots, encoding='utf-8')
    print("  Generated robots.txt")

    print(f"  Done! Output: {dist}")


if __name__ == "__main__":
    print("Static Site Generator")
    print("=" * 40)
    build_site()
    print("\nBuild complete!")
