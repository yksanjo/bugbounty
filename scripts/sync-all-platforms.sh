#!/bin/bash
# 🔄 Sync ALL Platform Targets to Pi
# Run this when Pi comes back online

PI_USER="yojinbot"
PI_IP="100.109.137.47"
PI_PASS="4588"

echo "🔄 Syncing all platform targets to Pi..."

# Combine all platform targets
cat ~/bugbounty/targets/bugcrowd_targets.txt \
    ~/bugbounty/targets/intigriti_targets.txt \
    ~/bugbounty/targets/yeswehack_targets.txt \
    ~/bugbounty/targets/direct_programs.txt \
    ~/bugbounty/targets/web3_targets.txt | \
    grep -v '^#' | grep -v '^$' | sort -u > ~/bugbounty/targets/all_platforms.txt

ALIVE=$(wc -l < ~/bugbounty/targets/all_platforms.txt)
echo "Found $ALIVE unique targets across all platforms"

# Filter alive hosts
echo "🌐 Checking which targets respond..."
cat ~/bugbounty/targets/all_platforms.txt | ~/go/bin/httpx -silent -timeout 3 -o ~/bugbounty/targets/alive_platforms.txt

ALIVE=$(wc -l < ~/bugbounty/targets/alive_platforms.txt)
echo "✅ $ALIVE targets are alive"

# Sync to Pi
echo "🥧 Syncing to Raspberry Pi..."
sshpass -p "$PI_PASS" scp ~/bugbounty/targets/alive_platforms.txt $PI_USER@$PI_IP:~/bugbounty/targets.txt

# Restart scanner
sshpass -p "$PI_PASS" ssh $PI_USER@$PI_IP "sudo systemctl restart bugbounty-scanner && tail -10 ~/bugbounty/scanner.log"

echo ""
echo "✅ All platforms synced! Pi is now scanning $ALIVE targets."
