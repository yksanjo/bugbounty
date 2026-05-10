# 🎯 IDOR HUNTING GUIDE - GitLab + Shopify

## 💰 Why These Two Targets

| Target | Max Bounty | IDOR Payout | Why It's Good |
|--------|-----------|------------|--------------|
| **GitLab** | $150,000 | $500-$5,000 | Open source, clear scope, documented |
| **Shopify** | $100,000 | $500-$10,000 | E-commerce APIs = tons of IDOR potential |

**Real IDOR bounties paid:**
- GitLab ML Model Registry IDOR → $1,160
- Shopify Partner Portal IDOR → $500
- Multiple GitLab IDORs → $1,000-$4,000 each

---

## 📋 GitLab IDOR Hunting

### In-Scope Assets:
- **gitlab.com** (main SaaS product)
- **GitLab Community Edition** (self-hosted)
- **GitLab Enterprise Edition**
- **All API endpoints**: `https://gitlab.com/api/v4/*`
- **GitLab Pages**
- **GitLab Container Registry**

### Out-of-Scope (DON'T test):
- DoS attacks
- Social engineering
- Third-party integrations
- GitLab.com infrastructure (only app-level bugs)

### 🔍 Where to Find IDOR in GitLab:

#### 1. Project/Repository APIs
```
GET /api/v4/projects/:id
GET /api/v4/projects/:id/repository/tree
GET /api/v4/projects/:id/issues
GET /api/v4/projects/:id/merge_requests
GET /api/v4/projects/:id/snippets

TEST: Create User A with private project
      Create User B (no access to project)
      As User B, try to access User A's project ID
      If you see data → IDOR!
```

#### 2. User/Group APIs
```
GET /api/v4/users/:id
GET /api/v4/users/:id/projects
GET /api/v4/groups/:id
GET /api/v4/groups/:id/members

TEST: Check if you can view other users' private info
```

#### 3. Issue/Merge Request APIs
```
GET /api/v4/projects/:id/issues/:issue_id
GET /api/v4/projects/:id/merge_requests/:mr_id
PUT /api/v4/projects/:id/issues/:issue_id
DELETE /api/v4/projects/:id/issues/:issue_id

TEST: Can you modify/delete others' issues/MRs?
```

#### 4. Snippet/Code APIs
```
GET /api/v4/snippets/:id
GET /api/v4/projects/:id/snippets
POST /api/v4/snippets

TEST: Access private snippets from other users
```

#### 5. CI/CD Pipeline APIs
```
GET /api/v4/projects/:id/pipelines
GET /api/v4/projects/:id/jobs
GET /api/v4/projects/:id/pipeline_schedules

TEST: View other projects' pipeline configs (may contain secrets)
```

### 🛠️ GitLab IDOR Testing Steps:

```bash
# Step 1: Create 2 GitLab accounts
User A: your_main_account
User B: test_account_2

# Step 2: As User A, create a private project
# Note the project ID (e.g., 12345678)

# Step 3: Get User A's API token
# Settings → Access Tokens → Create token with full scope

# Step 4: Test as User B
curl -H "PRIVATE-TOKEN: <USER_B_TOKEN>" \
  "https://gitlab.com/api/v4/projects/12345678"

# If you get project info → IDOR CONFIRMED!
# Expected: 404 or 403 (not found/forbidden)
```

---

## 📋 Shopify IDOR Hunting

### In-Scope Assets:
- **shopify.com** (main site)
- **partners.shopify.com** (partner dashboard)
- **shopify.dev** (developer portal)
- **Shopify Admin**: `*.myshopify.com/admin`
- **Shopify APIs**:
  - `https://<shop>.myshopify.com/admin/api/*`
  - `https://<shop>.myshopify.com/api/*`
- **Shop apps** (only Shopify-built apps, not third-party)

### Out-of-Scope:
- Third-party apps/themes
- Shopify infrastructure/network
- Social engineering
- DDoS/DoS
- Shopify Payments (separate program)

### 🔍 Where to Find IDOR in Shopify:

#### 1. Order APIs
```
GET /admin/api/2026-01/orders/:order_id.json
GET /admin/api/2026-01/orders/:order_id/transactions.json
PUT /admin/api/2026-01/orders/:order_id.json

TEST: Access orders from different shops
      Create Shop A and Shop B
      As Shop A, try to read Shop B's orders
```

#### 2. Customer APIs
```
GET /admin/api/2026-01/customers/:customer_id.json
GET /admin/api/2026-01/customers/:customer_id/orders.json

TEST: View other shops' customer data
```

#### 3. Product APIs
```
GET /admin/api/2026-01/products/:product_id.json
GET /admin/api/2026-01/products/:product_id/variants.json

TEST: Access private products from other shops
```

#### 4. Partner Dashboard
```
https://partners.shopify.com/:partner_id/*
GET /api/partners/:partner_id
GET /api/partners/:partner_id/shops
GET /api/partners/:partner_id/payouts

TEST: Access other partners' financial data
```

#### 5. App/Extension APIs
```
GET /admin/api/2026-01/apps/:app_id.json
GET /admin/api/2026-01/app_proxies/:proxy_id.json

TEST: Modify other apps' configurations
```

### 🛠️ Shopify IDOR Testing Steps:

```bash
# Step 1: Create 2 Shopify stores
Store A: test-store-a.myshopify.com
Store B: test-store-b.myshopify.com

# Step 2: Create test orders/customers in Store A

# Step 3: Get API credentials for both stores
# Settings → Apps → Develop apps → Create app

# Step 4: Test cross-store access
curl -X GET \
  "https://test-store-b.myshopify.com/admin/api/2026-01/orders/ORDER_ID_FROM_STORE_A.json" \
  -H "X-Shopify-Access-Token: <STORE_B_TOKEN>"

# If you see Store A's order → IDOR CONFIRMED!
# Expected: 404 (not found)
```

---

## 🎯 Manual Testing Methodology

### Daily Workflow (2-4 hours/day):

**Hour 1: Recon**
```
1. Map all API endpoints for target
2. Identify endpoints with numeric IDs
3. List all user-controllable objects:
   - Projects, repos, users, groups (GitLab)
   - Orders, customers, products (Shopify)
```

**Hour 2-3: IDOR Testing**
```
1. Create 2 accounts (Attacker + Victim)
2. As Victim: Create objects, note IDs
3. As Attacker: Try to access Victim's objects
4. Test all HTTP methods: GET, PUT, POST, DELETE
5. Test different ID formats:
   - Sequential: 1, 2, 3
   - UUID: 550e8400-e29b-41d4-a716-446655440000
   - Global: gid://gitlab/Project/123
```

**Hour 4: Documentation**
```
1. Screenshot proof
2. Save curl commands
3. Write impact statement
4. Draft report
```

---

## 📝 Report Template (IDOR)

```markdown
# IDOR: [Brief description of what can be accessed]

## Summary
Authenticated users can [access/modify/delete] [resource] belonging to other users by manipulating the [parameter] in [endpoint].

## Steps to Reproduce
1. Create User A and User B
2. As User A, create [resource] (ID: XXXXX)
3. As User B, send request:
   ```
   GET /api/v1/resource/XXXXX HTTP/1.1
   Host: target.com
   Authorization: Bearer <USER_B_TOKEN>
   ```
4. Observe response contains User A's data

## Impact
- Attacker can read [sensitive data] from any user
- Attacker can modify/delete other users' [resource]
- [Add specific business impact]

## Proof of Concept
[Attach screenshots + curl commands]

## Suggested Fix
Implement proper authorization checks to verify the authenticated user has permission to access the requested resource.
```

---

## 💡 Pro Tips for IDOR Success

### 1. Test ALL HTTP Methods
```
GET /api/resource/123  → Read
POST /api/resource/123 → Create
PUT /api/resource/123  → Update
DELETE /api/resource/123 → Delete
PATCH /api/resource/123 → Partial update
```

### 2. Try ID Manipulation
```
Sequential IDs:  1, 2, 3, 4...
UUID:            xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Base64:          eyJpZCI6MTIzfQ==
Global IDs:      gid://gitlab/Project/123
Hashed IDs:      abc123def456
```

### 3. Check GraphQL Endpoints
```
GitLab: https://gitlab.com/api/graphql
Shopify: https://<shop>.myshopify.com/api/graphql

Query:
{
  project(fullPath: "user/private-project") {
    name
    description
  }
}
```

### 4. Test API Versioning
```
/api/v1/resource/123
/api/v2/resource/123
/api/v3/resource/123
/api/2025-01/resource/123
/api/2026-01/resource/123
```

---

## 📊 Expected Timeline

| Week | Activity | Expected Outcome |
|------|----------|-----------------|
| **1** | Setup accounts, map APIs | List of 50+ IDOR test points |
| **2** | Test GitLab IDORs | 0-2 potential findings |
| **3** | Test Shopify IDORs | 0-2 potential findings |
| **4** | Verify findings, write reports | 1 submission |
| **5** | Submit + await triage | First payout: $500-$2,000 |

---

## 🚀 Quick Start (TODAY):

1. **Create GitLab accounts** (main + test)
2. **Create Shopify stores** (2 test stores)
3. **Map API endpoints** (use browser dev tools)
4. **Start testing** with curl/Postman

---

**Ready to start? Pick GitLab or Shopify and we'll begin testing!** 🚀
