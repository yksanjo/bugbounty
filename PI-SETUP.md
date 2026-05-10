# 🥧 Raspberry Pi Bug Bounty Scanner - Setup Complete!

## ✅ What's Running Now

### On Your Raspberry Pi (100.109.137.47):
- **Service**: `bugbounty-scanner.service` (auto-starts on boot)
- **Status**: ✅ Active & Running
- **Scan Cycle**: Every 1 hour (3600 seconds)

### Tools Installed on Pi:
- ✅ **Nuclei** v3.7.1 - Vulnerability scanner
- ✅ **Subfinder** - Subdomain enumeration
- ✅ **httpx** - HTTP probing
- ✅ **Katana** - Web crawler
- ✅ **Naabu** - Port scanner

---

## 📊 Quick Commands

### Monitor Pi Status
```bash
./scripts/monitor-pi.sh
```

### Sync Results to Mac
```bash
./scripts/sync-pi-results.sh
```

### Manual Scan
```bash
ssh yojinbot@100.109.137.47
cd ~/bugbounty/scripts
./scanner.sh ~/bugbounty/targets.txt 3600
```

### Service Control (from Mac)
```bash
# Check status
ssh yojinbot@100.109.137.47 "sudo systemctl status bugbounty-scanner"

# Stop scanner
ssh yojinbot@100.109.137.47 "sudo systemctl stop bugbounty-scanner"

# Start scanner
ssh yojinbot@100.109.137.47 "sudo systemctl start bugbounty-scanner"

# View live logs
ssh yojinbot@100.109.137.47 "tail -f ~/bugbounty/scanner.log"
```

---

## 🎯 Add New Targets

### Method 1: From Mac
```bash
ssh yojinbot@100.109.137.47 "echo 'example.com' >> ~/bugbounty/targets.txt"
```

### Method 2: SSH into Pi
```bash
ssh yojinbot@100.109.137.47
nano ~/bugbounty/targets.txt
```

Targets file: One domain/IP per line

---

## 🔄 How It Works

1. **Every hour**, the scanner:
   - Reads targets from `~/bugbounty/targets.txt`
   - Runs port scan (Naabu)
   - Checks HTTP services (httpx)
   - Scans vulnerabilities (Nuclei)
   - Saves results with timestamp

2. **Results location**:
   - Pi: `~/bugbounty/reports/YYYYMMDD_HHMMSS/`
   - Mac: Run `./scripts/sync-pi-results.sh`

3. **Auto-restart**:
   - Service restarts on Pi boot
   - Restarts on crash automatically

---

## 💡 Next Steps

1. **Add real targets** (register on bug bounty platforms first!)
   - HackerOne: https://hackerone.com
   - Bugcrowd: https://bugcrowd.com
   - Intigriti: https://intigriti.com

2. **Configure API keys** for better results:
   ```bash
   ssh yojinbot@100.109.137.47
   nano ~/.config/subfinder/provider-config.yaml
   ```

3. **Adjust scan interval**:
   ```bash
   # Edit service file
   ssh yojinbot@100.109.137.47 "sudo nano /etc/systemd/system/bugbounty-scanner.service"
   # Change the interval parameter (seconds)
   ```

4. **Set up alerts** for critical findings:
   - Add webhook notifications to scanner.sh
   - Monitor results daily

---

## ⚠️ Important

- **Only scan authorized targets**
- Follow bug bounty program rules
- Raspberry Pi 4 has limited resources - interval of 1hr+ is recommended
- Check disk usage regularly: `ssh yojinbot@100.109.137.47 "df -h"`
- Old results are auto-compressed after 24 hours

---

## 📈 Current Scan Results

**Last scan found**:
- Ports: 22 (SSH), 53 (DNS), 80 (HTTP), 111 (RPC), 443 (HTTPS)
- HTTP Services: http://100.109.137.47, https://100.109.137.47
- Vulnerabilities: Checking now...

Results saved to: `~/bugbounty/reports/from-pi/`
