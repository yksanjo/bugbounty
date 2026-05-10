# 📋 Bug Bounty Platform Registration Checklist

## ✅ MAJOR PLATFORMS

### 1. Intigriti (European)
- [ ] Register: https://account.intigriti.com/account/register
- [ ] Verify email
- [ ] Complete profile
- [ ] Browse programs: https://app.intigriti.com/programs
- **Notes**: Good payouts, less competition than HackerOne

### 2. Synack (Invite-Only)
- [ ] Apply: https://www.synack.com/join-the-synack-community/
- [ ] Requires: LinkedIn, resume, vetting process
- [ ] Wait for approval (can take weeks)
- **Notes**: Highest payouts, but requires application

### 3. YesWeHack (EU/APAC)
- [ ] Register: https://yeswehack.com/sign-up
- [ ] Verify email
- [ ] Complete hacker profile
- [ ] Browse programs
- **Notes**: Popular in Europe, growing fast

### 4. Open Bug Bounty (Free/Community)
- [ ] Register: https://www.openbugbounty.org/register/
- [ ] Submit your first vulnerability
- [ ] Build reputation
- **Notes**: No monetary rewards, good for practice

---

## 🏢 DIRECT PROGRAMS (No Platform)

### 5. Google VRP
- [ ] Read policy: https://bughunters.google.com/
- [ ] Submit via: https://bughunters.google.com/report
- **Targets**: google.com, android.com, chrome.com
- **Bounty**: $500 - $1,000,000

### 6. Microsoft MSRC
- [ ] Register: https://msrc.microsoft.com/
- [ ] Read scope: https://msrc.microsoft.com/report/guidance
- **Targets**: azure.com, microsoft.com, office.com
- **Bounty**: Up to $250,000

### 7. Apple Security Bounty
- [ ] Read policy: https://support.apple.com/en-us/HT212332
- [ ] Submit via: https://security.apple.com/
- **Targets**: apple.com, icloud.com, ios
- **Bounty**: Up to $1,000,000

### 8. Meta Bug Bounty
- [ ] Register: https://www.facebook.com/whitehat/
- [ ] Read policies: https://www.facebook.com/whitehat/terms/
- **Targets**: facebook.com, instagram.com, whatsapp.com
- **Bounty**: $500 - $300,000

### 9. GitHub Security
- [ ] Already on GitHub! Just submit issues to:
- [ ] https://github.com/contact/security
- **Bounty**: $617 - $30,000+

### 10. Mozilla Bug Bounty
- [ ] Read policy: https://www.mozilla.org/en-US/security/bug-bounty/
- [ ] Submit via email: security@mozilla.org
- **Bounty**: $500 - $20,000

### 11. U.S. DoD
- [ ] Register on HackerOne
- [ ] Search "Department of Defense"
- **Bounty**: Points/reputation only (VDP)

---

## 🪙 CRYPTO/WEB3 PLATFORMS

### 12. Immunefi
- [ ] Register: https://immunefi.com/signup/
- [ ] Complete profile
- [ ] Browse bounties: https://immunefi.com/explore/
- **Bounty**: $1,000 - $10,000,000+ (smart contracts)

### 13. Code4rena
- [ ] Register: https://code4rena.com/sign-in
- [ ] Join Discord
- [ ] Participate in audit contests
- **Bounty**: Prize pools $20K-$200K (split among finders)

### 14. Sherlock
- [ ] Register: https://app.sherlock.xyz/
- [ ] Connect wallet
- [ ] Audit smart contracts
- **Bounty**: Contest-based payouts

---

## 🔑 API KEYS TO CONFIGURE

### ProjectDiscovery (Chaos/Nuclei)
- [ ] Sign up: https://cloud.projectdiscovery.io
- [ ] Get API key
- [ ] Run on Mac:
  ```bash
  export PDCP_API_KEY='your-key-here'
  nuclei -auth
  ```
- [ ] Run on Pi:
  ```bash
  ssh yojinbot@100.109.137.47
  export PDCP_API_KEY='your-key-here'
  nuclei -auth
  ```

### HackerOne API
- [ ] Get API key: https://hackerone.com/settings/api
- [ ] Use for:
  - Pulling program scopes
  - Checking report status
  - Auto-discovering targets

### Shodan (Optional)
- [ ] Register: https://account.shodan.io/register
- [ ] Get API key
- [ ] Add to Subfinder config
- **Purpose**: Better subdomain enumeration

### VirusTotal (Optional)
- [ ] Register: https://www.virustotal.com/gui/join
- [ ] Get API key
- [ ] Add to Subfinder config
- **Purpose**: Better subdomain discovery

---

## 📊 Priority Order (Register in This Order)

1. ✅ HackerOne (Already registered)
2. ✅ Bugcrowd (Already registered?)
3. **Intigriti** (Easy, EU-based, good payouts)
4. **YesWeHack** (Growing fast)
5. **Google VRP** (Direct, huge payouts)
6. **Meta** (Direct, well-documented)
7. **Open Bug Bounty** (Free, good practice)
8. **GitHub Security** (Direct, easy)
9. **Mozilla** (Direct, smaller competition)
10. **Immunefi** (Web3, massive payouts)
11. **Synack** (Apply last, takes time to approve)

---

## 🚀 Automation Setup

### Done:
- [x] Chaos CLI installed
- [x] Auto-discover script created
- [x] Pi sync script created

### Next Steps:
1. Get PDCP API key
2. Run `./scripts/auto-discover-targets.sh`
3. Set up cron job for auto-sync

---

## 💰 Expected Timeline

| Week | Action | Expected Outcome |
|------|--------|-----------------|
| 1 | Register all platforms | Access to 15+ programs |
| 2-3 | Submit first bugs | 1-2 valid reports |
| 4-6 | Build reputation | Private invites |
| 7-12 | Consistent submissions | First bounty payments |
| 3-6 months | Multiple programs | $500-$2,000/month |
| 6-12 months | Private programs | $2,000-$10,000/month |
