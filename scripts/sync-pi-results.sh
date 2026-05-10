#!/bin/bash
# Sync results from Pi to Mac
# Usage: ./sync-pi-results.sh

PI_USER="yojinbot"
PI_IP="100.109.137.47"
PI_PASS="4588"

echo "=== Syncing Pi Results to Mac ==="

# Create local directory
mkdir -p ~/bugbounty/reports/from-pi

# Sync new results
sshpass -p "$PI_PASS" rsync -avz --progress \
    $PI_USER@$PI_IP:~/bugbounty/reports/ \
    ~/bugbounty/reports/from-pi/ 2>/dev/null

echo ""
echo "=== Synced Results ==="
ls -la ~/bugbounty/reports/from-pi/ | head -10

echo ""
echo "=== Vulnerability Summary ==="
find ~/bugbounty/reports/from-pi -name "vulns.txt" -exec cat {} \; 2>/dev/null | head -50
