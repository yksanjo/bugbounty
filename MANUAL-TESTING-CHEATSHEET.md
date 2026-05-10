# 🛡️ Bug Bounty Manual Testing Cheat Sheet

## 🔍 Step-by-Step Testing Methodology

### Phase 1: Reconnaissance (1-2 days)
```
1. Find all subdomains (Subfinder, Amass)
2. Find all alive hosts (httpx)
3. Find all endpoints (Katana crawler)
4. Map out technologies (Wappalyzer, httpx -tech-detect)
5. Note authentication methods (OAuth, SAML, JWT)
```

### Phase 2: Manual Testing (Where Money Is)

---

## 🎯 Top 10 Vulnerability Types (By Bounty Frequency)

### 1️⃣ **IDOR - Insecure Direct Object Reference**
**What**: Changing ID in URL accesses other user's data
**Test**:
```
https://target.com/api/user/123/profile → Change to 124
https://target.com/api/orders/456 → Change to 457
```
**Bounty**: $500 - $10,000

---

### 2️⃣ **XSS - Cross-Site Scripting**
**What**: Inject JavaScript into pages
**Test**:
```
<input> fields: <script>alert('XSS')</script>
URL parameters: ?search=<script>alert('XSS')</script>
File uploads: filename with XSS payload
```
**Bounty**: $500 - $5,000

---

### 3️⃣ **SQL Injection**
**What**: Manipulate database queries
**Test**:
```
Login: ' OR 1=1 --
Search: ' UNION SELECT username,password FROM users --
URL: ?id=1' OR '1'='1
```
**Bounty**: $2,000 - $20,000

---

### 4️⃣ **Authentication Bypass**
**What**: Access protected areas without proper auth
**Test**:
- Remove auth headers
- Modify JWT tokens (remove signature, change payload)
- Try default credentials (admin/admin)
- Check password reset flows

**Bounty**: $5,000 - $50,000

---

### 5️⃣ **SSRF - Server-Side Request Forgery**
**What**: Make server make requests to internal resources
**Test**:
```
Webhook URL: http://169.254.169.254/latest/meta-data/ (AWS)
Image upload from URL: http://127.0.0.1:22
Redirect: https://evil.com → redirect to internal IP
```
**Bounty**: $5,000 - $30,000

---

### 6️⃣ **File Upload Vulnerabilities**
**What**: Upload malicious files
**Test**:
- Upload .php/.asp file (bypass extension check)
- Upload with double extension: `file.jpg.php`
- Modify Content-Type header
- Upload with path traversal: `../../shell.php`

**Bounty**: $2,000 - $15,000

---

### 7️⃣ **Open Redirect**
**What**: Redirect users to malicious sites
**Test**:
```
https://target.com/redirect?url=https://evil.com
https://target.com/login?next=https://evil.com
```
**Bounty**: $100 - $2,000

---

### 8️⃣ **Business Logic Bugs**
**What**: Abuse application workflows
**Test**:
- Negative quantities in shopping cart
- Skip payment steps
- Reuse coupon codes multiple times
- Race conditions on limited resources

**Bounty**: $1,000 - $20,000

---

### 9️⃣ **Information Disclosure**
**What**: Exposed sensitive data
**Test**:
- Check `/robots.txt`, `/sitemap.xml`
- Look for backup files: `.bak`, `.old`, `.zip`
- Check API responses for internal data
- Review HTTP headers for info leaks

**Bounty**: $100 - $5,000

---

### 🔟 **Subdomain Takeover**
**What**: Claim abandoned subdomains
**Test**:
1. Find CNAME pointing to deleted service
2. Check for "NXDOMAIN" or "NoSuchBucket" errors
3. Create account on that service and claim the subdomain

**Common services**: GitHub Pages, Heroku, AWS S3, Azure
**Bounty**: $500 - $10,000

---

## 🛠️ Testing Tools (Manual)

### Browser Extensions:
- **Burp Suite Community** - Intercept & modify requests
- **HackBar** - Quick payload injection
- **Wappalyzer** - Tech stack detection
- **Cookie Editor** - Modify cookies

### Command Line:
```bash
# Intercept traffic
mitmproxy

# Test for SQLi
sqlmap -u "https://target.com/page?id=1"

# Test for XSS
dalfox url "https://target.com"

# Directory brute force
gobuster dir -u https://target.com -w wordlist.txt
```

---

## 📝 Vulnerability Report Template

```markdown
# [Vulnerability Type] on [Target]

## Summary
Brief description of the bug

## Steps to Reproduce
1. Go to https://target.com/page
2. Click on X
3. Change parameter Y to Z
4. Observe [result]

## Impact
What can an attacker do?
- Access other users' data
- Execute arbitrary code
- Bypass authentication

## Proof of Concept
Screenshots and request/response pairs

## Suggested Fix
How the company can fix this
```

---

## 💡 Pro Tips

1. **Test when you're fresh** - Bugs require focus
2. **Go deep, not wide** - Understand one target thoroughly
3. **Read other people's reports** - Learn from HackerOne's disclosed reports
4. **Test edge cases** - What happens with weird inputs?
5. **Chain vulnerabilities** - XSS + CSRF = Account Takeover
6. **Don't submit duplicates** - Search first!
7. **Write clear reports** - Triagers reject unclear reports

---

## ⚠️ NEVER DO:
- ❌ Access real user data
- ❌ Delete or modify data
- ❌ Run DDoS attacks
- ❌ Exploit beyond proof-of-concept
- ❌ Share vulnerability details publicly

---

## 🎯 Next Steps
1. Practice on intentionally vulnerable apps (DVWA, Juice Shop)
2. Start with VDPs (no bounty, but good practice)
3. Move to paid programs once confident
4. Build reputation → get private invites → higher payouts
