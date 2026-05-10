# Bug Bounty Setup Guide

## Installed Tools (Mac)

### Go-based Tools (ProjectDiscovery Suite)
- **Nuclei** - Template-based vulnerability scanner
- **Katana** - Advanced web crawler
- **Subfinder** - Subdomain enumeration
- **httpx** - HTTP probing and technology detection
- **Naabu** - Fast port scanner
- **Amass** - Network mapping and subdomain discovery

### Other Tools
- **Nikto** - Web server vulnerability scanner
- **OWASP ZAP** - (Pending installation)

## Directory Structure

```
~/bugbounty/
├── scripts/          # Automation scripts
│   ├── recon.sh         # Full reconnaissance
│   └── pi-scanner.sh    # Continuous Pi scanner
├── targets.txt       # Target domains (edit this!)
├── wordlists/        # Custom wordlists
├── reports/          # Scan results organized by target
├── config/           # Configuration files
└── tools/            # Additional tools
```

## Quick Start

### 1. Add Targets
Edit `~/bugbounty/targets.txt` and add your target domains:
```
example.com
target.org
```

### 2. Run Full Recon (Mac)
```bash
cd ~/bugbounty/scripts
./recon.sh example.com
```

### 3. Continuous Scan (Pi)
```bash
cd ~/bugbounty/scripts
./pi-scanner.sh ~/bugbounty/targets.txt 3600
```

---

## Raspberry Pi 4 Setup

### Step 1: Prepare Your Pi
SSH into your Raspberry Pi:
```bash
ssh pi@<pi-ip-address>
```

### Step 2: Install Go on Pi
```bash
# Download Go for ARM64
wget https://go.dev/dl/go1.21.6.linux-arm64.tar.gz
sudo tar -C /usr/local -xzf go1.21.6.linux-arm64.tar.gz

# Add to PATH
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc
```

### Step 3: Install Bug Bounty Tools on Pi
```bash
# Install ProjectDiscovery tools
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

# Update Nuclei templates
nuclei -update-templates
```

### Step 4: Copy Scripts to Pi
From your Mac:
```bash
scp -r ~/bugbounty pi@<pi-ip>:~/bugbounty
```

### Step 5: Run Scanner on Pi
```bash
cd ~/bugbounty/scripts
./pi-scanner.sh ~/bugbounty/targets.txt 3600
```

### Step 6: Run as Background Service (Optional)
Create a systemd service for continuous scanning:
```bash
sudo nano /etc/systemd/system/bugbounty-scanner.service
```

Add this content:
```ini
[Unit]
Description=Bug Bounty Continuous Scanner
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/bugbounty/scripts
ExecStart=/home/pi/bugbounty/scripts/pi-scanner.sh /home/pi/bugbounty/targets.txt 3600
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl enable bugbounty-scanner
sudo systemctl start bugbounty-scanner
sudo systemctl status bugbounty-scanner
```

---

## Tool Usage Examples

### Subdomain Enumeration
```bash
# Using Subfinder
subfinder -d example.com -o subdomains.txt

# Using Amass
amass enum -d example.com -o amass_results.txt

# Combine both
cat subdomains.txt amass_results.txt | sort -u > all_subdomains.txt
```

### HTTP Probing
```bash
# Find alive hosts
cat subdomains.txt | httpx -silent -o alive.txt

# With tech detection
cat subdomains.txt | httpx -tech-detect -o alive_tech.txt
```

### Port Scanning
```bash
# Quick scan top 100 ports
naabu -host example.com -top-ports 100

# Full port scan
naabu -host example.com -p - -o ports.txt
```

### Vulnerability Scanning
```bash
# Basic Nuclei scan
cat alive.txt | nuclei -o vulns.txt

# With specific templates
cat alive.txt | nuclei -t cves/ -o cves.txt

# Critical/High only
cat alive.txt | nuclei -s critical,high -o critical_vulns.txt
```

### Web Crawling
```bash
# Basic crawl
katana -u https://example.com -o crawl_results.txt

# Deep crawl with JS parsing
katana -u https://example.com -d 3 -js-crawl -o deep_crawl.txt
```

### Nikto Scan
```bash
# Single target
nikto -h https://example.com -output nikto_results.txt

# Multiple targets
nikto -h targets.txt -Format csv -output nikto_results.csv
```

---

## Important Notes

### ⚠️ Ethical Hacking Guidelines
1. **Only scan targets you have permission to test**
2. Sign up for bug bounty programs on:
   - HackerOne: https://hackerone.com
   - Bugcrowd: https://bugcrowd.com
   - Intigriti: https://intigriti.com
3. Always follow the program's scope and rules
4. Report vulnerabilities responsibly

### Rate Limiting
- Use `-rl` flag to rate limit requests (e.g., `nuclei -rl 100`)
- Avoid scanning during peak hours
- Respect `robots.txt` when appropriate

### Pi Limitations
- Pi 4 has 2-8GB RAM - avoid memory-intensive scans
- Use `-c` flag to control concurrency
- Consider running scans during off-peak hours

---

## Next Steps

1. [ ] Register for bug bounty programs
2. [ ] Add authorized targets to `targets.txt`
3. [ ] Configure API keys for better results:
   - Subfinder: `subfinder -config`
   - Amass: `amass intel -whois`
4. [ ] Set up Pi as continuous scanner
5. [ ] Review and customize scanning parameters

## Resources
- Nuclei Templates: https://github.com/projectdiscovery/nuclei-templates
- Bug Bounty Hunting: https://bugbountyhunt.com
- Hacker101: https://www.hacker101.com (Free training)
