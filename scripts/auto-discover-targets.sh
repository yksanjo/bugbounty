#!/bin/bash
# Automated Bug Bounty Target Discovery & Sync
# Pulls targets from Chaos, scans, and syncs to Pi

export PATH=$HOME/go/bin:$PATH
export TMPDIR=$HOME/tmp

PI_USER="yojinbot"
PI_IP="100.109.137.47"
PI_PASS="4588"

echo "=== 🎯 Automated Target Discovery ==="
echo ""

# Step 1: Get Chaos API key if not set
if [ -z "$PDCP_API_KEY" ]; then
    echo "⚠️  PDCP_API_KEY not set!"
    echo "Get your free key at: https://cloud.projectdiscovery.io"
    echo ""
    echo "Then run:"
    echo "  export PDCP_API_KEY='your-key-here'"
    echo ""
    echo "Continuing with limited targets..."
    CHAOS_TARGETS=""
else
    echo "🔍 Fetching targets from Chaos..."
    CHAOS_TARGETS=$(chaos -o ~/bugbounty/targets/chaos_domains.txt 2>/dev/null | wc -l)
    echo "✅ Found $CHAOS_TARGETS domains from Chaos"
fi

# Step 2: Curate high-value targets
echo ""
echo "📝 Curating bug bounty targets..."

cat > ~/bugbounty/targets/auto_discovered.txt << 'TARGETS'
# Auto-discovered bug bounty targets
# HackerOne Programs
shopify.com
myshopify.com
github.com
gitlab.com
uber.com
lyft.com
airbnb.com
stripe.com
snapchat.com
dropbox.com
twitter.com
x.com
wordpress.com
wp.com
gravatar.com
akismet.com
tumblr.com

# Bugcrowd Programs
opera.com
netflix.com
tesla.com
indeed.com
paypal.com
mastercard.com

# Direct Programs
google.com
microsoft.com
apple.com
facebook.com
instagram.com
whatsapp.com
mozilla.org

# Web3/Crypto
immunefi.com
code4rena.com
sherlock.xyz

# European Platforms
intigriti.com
yeswehack.com

# Additional high-value targets
mail.ru
grab.com
zendesk.com
slack.com
zoom.us
TARGETS

# Step 3: Filter alive hosts only
echo ""
echo "🌐 Checking which targets are alive..."
cat ~/bugbounty/targets/auto_discovered.txt | grep -v '^#' | grep -v '^$' | httpx -silent -o ~/bugbounty/targets/alive_targets.txt

ALIVE_COUNT=$(wc -l < ~/bugbounty/targets/alive_targets.txt)
echo "✅ $ALIVE_COUNT targets are alive and scannable"

# Step 4: Sync to Pi
echo ""
echo "🥧 Syncing targets to Raspberry Pi..."
sshpass -p "$PI_PASS" scp ~/bugbounty/targets/alive_targets.txt $PI_USER@$PI_IP:~/bugbounty/targets.txt
echo "✅ Targets synced to Pi"

# Step 5: Restart Pi scanner
echo ""
echo "🔄 Restarting Pi scanner..."
sshpass -p "$PI_PASS" ssh $PI_USER@$PI_IP "sudo systemctl restart bugbounty-scanner && sleep 5 && tail -10 ~/bugbounty/scanner.log"

echo ""
echo "=== ✅ Setup Complete ==="
echo "Pi is now scanning $ALIVE_COUNT targets!"
echo ""
echo "📊 Monitor with: ./bugbounty/scripts/monitor-pi.sh"
echo "📥 Sync results: ./bugbounty/scripts/sync-pi-results.sh"
