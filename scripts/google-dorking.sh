#!/bin/bash
# 🔎 Google Dorking for Hidden Bug Bounty Programs
# Finds self-hosted programs that platforms don't list

OUTPUT_FILE=~/bugbounty/targets/dork_findings.txt

echo "🔎 === GOOGLE DORKING FOR HIDDEN PROGRAMS ==="
echo ""

mkdir -p ~/bugbounty/targets

# Dork 1: Responsible disclosure pages
echo "[1/6] Searching: responsible disclosure policy pages..."
echo "  Query: inurl:\"responsible-disclosure\" OR inurl:\"vulnerability-disclosure\" -site:hackerone.com -site:bugcrowd.com"
echo "  → Open in browser: https://www.google.com/search?q=inurl:%22responsible-disclosure%22+OR+inurl:%22vulnerability-disclosure%22+-site:hackerone.com+-site:bugcrowd.com"
echo ""

# Dork 2: Bug bounty pages
echo "[2/6] Searching: bug bounty program pages..."
echo "  Query: inurl:\"bug-bounty\" OR inurl:\"bugbounty\" intext:\"reward\" -site:hackerone.com -site:bugcrowd.com"
echo "  → Open in browser: https://www.google.com/search?q=inurl:%22bug-bounty%22+OR+inurl:%22bugbounty%22+intext:%22reward%22+-site:hackerone.com+-site:bugcrowd.com"
echo ""

# Dork 3: Security pages
echo "[3/6] Searching: company security pages..."
echo "  Query: site:*.com/security intext:\"bounty\" OR intext:\"reward\" -site:hackerone.com -site:bugcrowd.com"
echo "  → Open in browser: https://www.google.com/search?q=site:*.com/security+intext:%22bounty%22+OR+intext:%22reward%22+-site:hackerone.com+-site:bugcrowd.com"
echo ""

# Dork 4: Acknowledgments pages
echo "[4/6] Searching: hacker acknowledgment pages..."
echo "  Query: inurl:\"hall-of-fame\" OR inurl:\"thank-you\" intext:\"security researcher\" -site:hackerone.com -site:bugcrowd.com"
echo "  → Open in browser: https://www.google.com/search?q=inurl:%22hall-of-fame%22+OR+inurl:%22thank-you%22+intext:%22security+researcher%22+-site:hackerone.com+-site:bugcrowd.com"
echo ""

# Dork 5: Direct contact
echo "[5/6] Searching: direct security contacts..."
echo "  Query: intext:\"security@\" intext:\"responsible disclosure\" -site:hackerone.com -site:bugcrowd.com"
echo "  → Open in browser: https://www.google.com/search?q=intext:%22security@%22+intext:%22responsible+disclosure%22+-site:hackerone.com+-site:bugcrowd.com"
echo ""

# Dork 6: Reddit discoveries
echo "[6/6] Searching: Reddit program announcements..."
echo "  Query: site:reddit.com/r/netsec OR site:reddit.com/r/bugbounty intext:\"launched\" intext:\"program\" -site:hackerone.com -site:bugcrowd.com"
echo "  → Open in browser: https://www.google.com/search?q=site:reddit.com/r/netsec+OR+site:reddit.com/r/bugbounty+intext:%22launched%22+intext:%22program%22+-site:hackerone.com+-site:bugcrowd.com"
echo ""

echo "✅ Dork queries ready!"
echo ""
echo "📋 NEXT STEPS:"
echo "1. Open each Google link above in your browser"
echo "2. Extract company names/URLs from results"
echo "3. Add to: ~/bugbounty/targets/dork_findings.txt"
echo "4. Run: ./scripts/security-txt-scanner.sh ~/bugbounty/targets/dork_findings.txt"
