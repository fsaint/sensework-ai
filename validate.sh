#!/bin/bash
#
# Validate site deployment setup
#

echo "========================================"
echo "  Site Deployment Validation"
echo "========================================"
echo ""

ERRORS=0

# Check site config
echo "Checking site configuration..."
if [ -f "site/config.json" ]; then
    DOMAIN=$(python3 -c "import json; print(json.load(open('site/config.json'))['domain'])" 2>/dev/null)
    if [ -z "$DOMAIN" ] || [ "$DOMAIN" == "DOMAIN_PLACEHOLDER" ]; then
        echo "  ❌ Domain not configured in site/config.json"
        ERRORS=$((ERRORS+1))
    else
        echo "  ✅ Domain: $DOMAIN"
    fi
else
    echo "  ❌ site/config.json not found"
    ERRORS=$((ERRORS+1))
fi

# Check GitHub repo
echo ""
echo "Checking GitHub repository..."
if gh repo view &> /dev/null 2>&1; then
    REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner)
    echo "  ✅ Repository: $REPO"
else
    echo "  ❌ Not a GitHub repository or not logged in"
    ERRORS=$((ERRORS+1))
fi

# Check GitHub secrets
echo ""
echo "Checking GitHub secrets..."
if gh secret list 2>/dev/null | grep -q "CLOUDFLARE_API_TOKEN"; then
    echo "  ✅ CLOUDFLARE_API_TOKEN is set"
else
    echo "  ❌ CLOUDFLARE_API_TOKEN not set"
    ERRORS=$((ERRORS+1))
fi

if gh secret list 2>/dev/null | grep -q "CLOUDFLARE_ACCOUNT_ID"; then
    echo "  ✅ CLOUDFLARE_ACCOUNT_ID is set"
else
    echo "  ❌ CLOUDFLARE_ACCOUNT_ID not set"
    ERRORS=$((ERRORS+1))
fi

# Check GitHub variables
echo ""
echo "Checking GitHub variables..."
CF_PROJECT=$(gh variable list 2>/dev/null | grep "CLOUDFLARE_PROJECT_NAME" | awk '{print $2}')
if [ -n "$CF_PROJECT" ]; then
    echo "  ✅ CLOUDFLARE_PROJECT_NAME: $CF_PROJECT"
else
    echo "  ❌ CLOUDFLARE_PROJECT_NAME not set"
    ERRORS=$((ERRORS+1))
fi

# Check workflow file
echo ""
echo "Checking workflow..."
if [ -f ".github/workflows/deploy.yml" ]; then
    echo "  ✅ Workflow file exists"
else
    echo "  ❌ .github/workflows/deploy.yml not found"
    ERRORS=$((ERRORS+1))
fi

# Check latest deployment
echo ""
echo "Checking deployments..."
LAST_RUN=$(gh run list --limit 1 --json status,conclusion,createdAt 2>/dev/null)
if [ -n "$LAST_RUN" ]; then
    STATUS=$(echo "$LAST_RUN" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d[0]['status'] if d else 'none')" 2>/dev/null)
    CONCLUSION=$(echo "$LAST_RUN" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d[0].get('conclusion','') if d else '')" 2>/dev/null)

    if [ "$STATUS" == "completed" ] && [ "$CONCLUSION" == "success" ]; then
        echo "  ✅ Latest deployment: success"
    elif [ "$STATUS" == "completed" ]; then
        echo "  ❌ Latest deployment: $CONCLUSION"
        ERRORS=$((ERRORS+1))
    else
        echo "  ⏳ Deployment in progress: $STATUS"
    fi
else
    echo "  ⚠️  No deployments yet"
fi

# Test build locally
echo ""
echo "Testing local build..."
if python3 build.py > /dev/null 2>&1; then
    if [ -f "dist/index.html" ]; then
        echo "  ✅ Build successful"
    else
        echo "  ❌ Build ran but dist/index.html not created"
        ERRORS=$((ERRORS+1))
    fi
else
    echo "  ❌ Build failed - run 'python3 build.py' for details"
    ERRORS=$((ERRORS+1))
fi

# Summary
echo ""
echo "========================================"
if [ $ERRORS -eq 0 ]; then
    echo "  ✅ All checks passed!"
    echo ""
    echo "  Your site should be live at:"
    echo "  https://${CF_PROJECT}.pages.dev"
else
    echo "  ❌ $ERRORS issue(s) found"
    echo ""
    echo "  Run ./onboard.sh to fix setup issues"
fi
echo "========================================"

exit $ERRORS
