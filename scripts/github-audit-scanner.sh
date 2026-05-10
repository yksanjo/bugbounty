#!/bin/bash
# 🐙 GitHub Organization Audit Scanner
# Finds vulnerabilities in company open source repos

ORG_NAME=$1

if [ -z "$ORG_NAME" ]; then
    echo "Usage: ./github-audit-scanner.sh <github-org>"
    echo "Example: ./github-audit-scanner.sh automattic"
    exit 1
fi

echo "🐙 === GITHUB ORG AUDIT SCANNER ==="
echo "Scanning: https://github.com/$ORG_NAME"
echo ""

OUTPUT_DIR=~/bugbounty/reports/github-audit/$ORG_NAME
mkdir -p $OUTPUT_DIR

# Step 1: Get all public repos
echo "[1/4] Fetching public repositories..."
gh api "/orgs/$ORG_NAME/repos?per_page=100&type=public" --jq '.[].html_url' > $OUTPUT_DIR/repos.txt 2>/dev/null

if [ ! -s "$OUTPUT_DIR/repos.txt" ]; then
    echo "⚠️  Could not fetch repos via GitHub CLI. Trying alternative method..."
    curl -s "https://api.github.com/orgs/$ORG_NAME/repos?per_page=100" | grep -o '"html_url":"[^"]*"' | cut -d'"' -f4 > $OUTPUT_DIR/repos.txt
fi

REPO_COUNT=$(wc -l < $OUTPUT_DIR/repos.txt)
echo "✅ Found $REPO_COUNT public repositories"
echo ""

# Step 2: Clone and scan each repo
echo "[2/4] Scanning repositories for vulnerabilities..."

while read REPO_URL; do
    REPO_NAME=$(echo $REPO_URL | sed 's|.*/||')
    echo "  Scanning: $REPO_NAME..."
    
    # Quick clone (shallow)
    git clone --depth 1 $REPO_URL $OUTPUT_DIR/$REPO_NAME 2>/dev/null
    
    if [ -d "$OUTPUT_DIR/$REPO_NAME" ]; then
        # Check for hardcoded secrets
        echo "    - Checking for secrets..."
        grep -r "password\|secret\|token\|api_key\|apikey" $OUTPUT_DIR/$REPO_NAME --include="*.py" --include="*.js" --include="*.rb" --include="*.go" -l 2>/dev/null > $OUTPUT_DIR/$REPO_NAME/secrets.txt
        
        # Check for SQL queries (potential SQLi)
        echo "    - Checking for SQL injection vectors..."
        grep -r "SELECT\|INSERT\|UPDATE\|DELETE\|query(" $OUTPUT_DIR/$REPO_NAME --include="*.py" --include="*.js" --include="*.rb" -l 2>/dev/null > $OUTPUT_DIR/$REPO_NAME/sql_queries.txt
        
        # Check for XSS patterns
        echo "    - Checking for XSS vectors..."
        grep -r "innerHTML\|document.write\|eval(\|setTimeout(" $OUTPUT_DIR/$REPO_NAME --include="*.js" --include="*.html" -l 2>/dev/null > $OUTPUT_DIR/$REPO_NAME/xss_vectors.txt
        
        # Check for hardcoded credentials
        SECRET_COUNT=$(wc -l < $OUTPUT_DIR/$REPO_NAME/secrets.txt 2>/dev/null || echo "0")
        SQL_COUNT=$(wc -l < $OUTPUT_DIR/$REPO_NAME/sql_queries.txt 2>/dev/null || echo "0")
        XSS_COUNT=$(wc -l < $OUTPUT_DIR/$REPO_NAME/xss_vectors.txt 2>/dev/null || echo "0")
        
        if [ "$SECRET_COUNT" -gt 0 ] || [ "$SQL_COUNT" -gt 0 ] || [ "$XSS_COUNT" -gt 0 ]; then
            echo "    🚨 POTENTIAL FINDINGS: $SECRET_COUNT secrets, $SQL_COUNT SQL queries, $XSS_COUNT XSS vectors"
            echo "    Review: $OUTPUT_DIR/$REPO_NAME/"
        else
            echo "    ✅ Clean"
        fi
        
        # Cleanup
        rm -rf $OUTPUT_DIR/$REPO_NAME
    fi
    
done < $OUTPUT_DIR/repos.txt

echo ""
echo "[3/4] Generating report..."
echo "[4/4] Audit complete!"
echo ""
echo "📁 Results saved to: $OUTPUT_DIR"
echo "📊 Review findings for manual verification before submission"
