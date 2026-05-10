#!/bin/bash
# Monitor Pi bug bounty scanner status

PI_USER="yojinbot"
PI_IP="100.109.137.47"
PI_PASS="4588"

echo "=== Pi Bug Bounty Scanner Status ==="
echo ""

# Check service status
echo "🔧 Service Status:"
sshpass -p "$PI_PASS" ssh $PI_USER@$PI_IP "sudo systemctl status bugbounty-scanner --no-pager -l" 2>/dev/null | grep -E "(Active|Main PID|Status)"

echo ""
echo "📊 Running Processes:"
sshpass -p "$PI_PASS" ssh $PI_USER@$PI_IP "ps aux | grep -E '(scanner|nuclei|httpx|naabu|subfinder)' | grep -v grep" 2>/dev/null

echo ""
echo "📁 Latest Scan Results:"
sshpass -p "$PI_PASS" ssh $PI_USER@$PI_IP "ls -lt ~/bugbounty/reports/ | head -5" 2>/dev/null

echo ""
echo "📝 Recent Logs:"
sshpass -p "$PI_PASS" ssh $PI_USER@$PI_IP "tail -10 ~/bugbounty/scanner.log 2>/dev/null || echo 'No logs yet'"

echo ""
echo "💾 Disk Usage:"
sshpass -p "$PI_PASS" ssh $PI_USER@$PI_IP "df -h / | tail -1"

echo ""
echo "=== Commands ==="
echo "  Start:  ssh $PI_USER@$PI_IP 'sudo systemctl start bugbounty-scanner'"
echo "  Stop:   ssh $PI_USER@$PI_IP 'sudo systemctl stop bugbounty-scanner'"
echo "  Status: ssh $PI_USER@$PI_IP 'sudo systemctl status bugbounty-scanner'"
echo "  Logs:   ssh $PI_USER@$PI_IP 'tail -f ~/bugbounty/scanner.log'"
echo "  Add targets: Edit ~/bugbounty/targets.txt on Pi"
