# 🎯 Practice Lab Setup (No Docker Required)

## Option 1: OWASP Juice Shop (Easiest)
```bash
# Install Node.js if needed
brew install node

# Install Juice Shop
npm install @owasp/juice-shop

# Start it
npx juice-shop
# Access at: http://localhost:3000
```

## Option 2: DVWA (Classic)
Requires PHP + MySQL:
```bash
# Install requirements
brew install php mysql

# Download DVWA
git clone https://github.com/digininja/DVWA.git
cd DVWA
cd htdocs
php -S localhost:8080
```

## Option 3: WebGoat (Java-based)
```bash
# Download
brew install --cask webgoat

# Start
webgoat
# Access at: http://localhost:8080/WebGoat
```

---

## What to Practice:

1. **SQL Injection** - Login bypass, data extraction
2. **XSS** - Alert boxes, cookie stealing
3. **File Upload** - Bypass restrictions
4. **IDOR** - Access other users' data
5. **Authentication Bypass** - Skip login screens

---

## Quick Start (No Install):

Use online practice labs:
- **PortSwigger Academy**: https://portswigger.net/web-security (FREE, best)
- **PentesterLab**: https://pentesterlab.com
- **HackTheBox**: https://hackthebox.com
- **TryHackMe**: https://tryhackme.com
