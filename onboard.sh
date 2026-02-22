#!/bin/bash
#
# Site Onboarding Script
# Sets up GitHub repo, Cloudflare Pages, and configures deployment
#

set -e

echo "========================================"
echo "  Static Site Onboarding"
echo "========================================"
echo ""

# Check prerequisites
check_prerequisites() {
    local missing=0

    if ! command -v gh &> /dev/null; then
        echo "❌ GitHub CLI (gh) not installed. Install with: brew install gh"
        missing=1
    fi

    if ! command -v wrangler &> /dev/null; then
        echo "❌ Wrangler CLI not installed. Install with: npm install -g wrangler"
        missing=1
    fi

    if ! gh auth status &> /dev/null 2>&1; then
        echo "❌ Not logged into GitHub. Run: gh auth login"
        missing=1
    fi

    if [ $missing -eq 1 ]; then
        echo ""
        echo "Please install missing prerequisites and try again."
        exit 1
    fi

    echo "✅ Prerequisites checked"
}

# Get site configuration
get_site_config() {
    echo ""
    read -p "Enter domain (e.g., mysite.com): " DOMAIN
    read -p "Enter site title: " TITLE
    read -p "Enter site description: " DESCRIPTION
    read -p "Enter GitHub repo name (default: ${DOMAIN//./-}): " REPO_NAME
    REPO_NAME=${REPO_NAME:-${DOMAIN//./-}}

    # Cloudflare project name (no dots allowed)
    CF_PROJECT_NAME=${DOMAIN//./-}

    echo ""
    echo "Configuration:"
    echo "  Domain: $DOMAIN"
    echo "  Title: $TITLE"
    echo "  GitHub Repo: $REPO_NAME"
    echo "  Cloudflare Project: $CF_PROJECT_NAME"
    echo ""
    read -p "Continue? (y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ]; then
        echo "Aborted."
        exit 0
    fi
}

# Update site config
update_site_config() {
    echo ""
    echo "📝 Updating site configuration..."

    # Update config.json
    cat > site/config.json << EOF
{
  "domain": "$DOMAIN",
  "title": "$TITLE",
  "description": "$DESCRIPTION",
  "language": "en"
}
EOF

    # Update homepage
    cat > site/content/homepage.json << EOF
{
  "hero_title": "Welcome to $TITLE",
  "hero_subtitle": "$DESCRIPTION",
  "cta_text": "Learn More",
  "cta_link": "#about",
  "sections": [
    {
      "title": "About",
      "content": "Welcome to $TITLE. Edit this content in site/content/homepage.json."
    }
  ]
}
EOF

    echo "✅ Site configuration updated"
}

# Create GitHub repository
create_github_repo() {
    echo ""
    echo "📦 Creating GitHub repository..."

    # Initialize git if needed
    if [ ! -d .git ]; then
        git init
    fi

    # Create repo on GitHub
    if gh repo view "$REPO_NAME" &> /dev/null 2>&1; then
        echo "⚠️  Repository $REPO_NAME already exists"
    else
        gh repo create "$REPO_NAME" --private --source=. --push
        echo "✅ GitHub repository created"
    fi
}

# Setup Cloudflare
setup_cloudflare() {
    echo ""
    echo "☁️  Setting up Cloudflare Pages..."

    # Check if logged into Cloudflare
    if ! wrangler whoami &> /dev/null 2>&1; then
        echo "Logging into Cloudflare..."
        wrangler login
    fi

    # Get account ID
    CF_ACCOUNT_ID=$(wrangler whoami 2>/dev/null | grep -oE '[a-f0-9]{32}' | head -1)

    if [ -z "$CF_ACCOUNT_ID" ]; then
        echo "❌ Could not get Cloudflare Account ID"
        read -p "Enter your Cloudflare Account ID manually: " CF_ACCOUNT_ID
    fi

    echo "  Account ID: $CF_ACCOUNT_ID"

    # Create Pages project
    echo "Creating Cloudflare Pages project..."
    wrangler pages project create "$CF_PROJECT_NAME" --production-branch=main 2>/dev/null || echo "  Project may already exist"

    echo "✅ Cloudflare Pages project ready"
}

# Configure GitHub secrets
configure_secrets() {
    echo ""
    echo "🔐 Configuring GitHub secrets..."

    # Get or create API token
    echo ""
    echo "You need a Cloudflare API token with 'Cloudflare Pages: Edit' permission."
    echo "Create one at: https://dash.cloudflare.com/profile/api-tokens"
    echo ""
    read -sp "Enter Cloudflare API Token: " CF_API_TOKEN
    echo ""

    # Set secrets
    echo "$CF_API_TOKEN" | gh secret set CLOUDFLARE_API_TOKEN
    echo "$CF_ACCOUNT_ID" | gh secret set CLOUDFLARE_ACCOUNT_ID

    # Set variable for project name
    gh variable set CLOUDFLARE_PROJECT_NAME --body "$CF_PROJECT_NAME"

    echo "✅ GitHub secrets configured"
}

# Initial commit and deploy
initial_deploy() {
    echo ""
    echo "🚀 Creating initial commit and deploying..."

    git add -A
    git commit -m "Initial site setup for $DOMAIN"
    git push -u origin main

    echo ""
    echo "✅ Pushed to GitHub - deployment starting..."
    echo ""
    echo "Watch deployment at:"
    echo "  https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/actions"
}

# Validate deployment
validate() {
    echo ""
    echo "🔍 Validating setup..."

    # Check GitHub Actions
    echo "Checking GitHub Actions workflow..."
    sleep 5

    RUN_STATUS=$(gh run list --limit 1 --json status -q '.[0].status')
    echo "  Latest workflow status: $RUN_STATUS"

    echo ""
    echo "========================================"
    echo "  Onboarding Complete!"
    echo "========================================"
    echo ""
    echo "Your site will be available at:"
    echo "  https://${CF_PROJECT_NAME}.pages.dev"
    echo ""
    echo "To add a custom domain:"
    echo "  1. Go to Cloudflare Dashboard > Pages > $CF_PROJECT_NAME"
    echo "  2. Click 'Custom domains' > 'Set up a custom domain'"
    echo "  3. Add: $DOMAIN"
    echo ""
    echo "Next steps:"
    echo "  - Edit content in site/content/"
    echo "  - Add articles in site/content/articles/"
    echo "  - Push changes to deploy automatically"
    echo ""
}

# Main
main() {
    check_prerequisites
    get_site_config
    update_site_config
    create_github_repo
    setup_cloudflare
    configure_secrets
    initial_deploy
    validate
}

main
