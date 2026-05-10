# 🧪 IDOR Testing Plan - Start TODAY

## Step 1: Create Test Accounts (30 min)

### GitLab:
- [ ] Account 1: Your main GitLab account
- [ ] Account 2: Create new account (test IDOR victim)
- [ ] Account 1: Create private project → Note Project ID
- [ ] Account 1: Create API token (Settings → Access Tokens)
- [ ] Account 2: Create API token

### Shopify:
- [ ] Create 2 Shopify development stores
  - Use: https://partners.shopify.com (free to create)
- [ ] Store A: Create test order
- [ ] Store B: Generate API credentials

## Step 2: Map API Endpoints (1 hour)

### GitLab API Discovery:
```bash
# Browse gitlab.com with DevTools open
# Go to Network tab → XHR
# Look for:
- /api/v4/projects/*
- /api/v4/users/*
- /api/v4/groups/*
- /api/v4/issues/*
- /api/v4/merge_requests/*
```

### Shopify API Discovery:
```bash
# Browse Shopify admin with DevTools open
# Look for:
- /admin/api/*/orders/*
- /admin/api/*/customers/*
- /admin/api/*/products/*
- /partners/api/*
```

## Step 3: Test IDOR (2-3 hours)

### GitLab IDOR Tests:
- [ ] Test project access with wrong user token
- [ ] Test issue/MR access across projects
- [ ] Test user profile access
- [ ] Test snippet access
- [ ] Test CI/CD pipeline access
- [ ] Test group membership endpoints

### Shopify IDOR Tests:
- [ ] Test order access across stores
- [ ] Test customer access across stores
- [ ] Test product access across stores
- [ ] Test partner dashboard access
- [ ] Test app configurations

## Step 4: Document Findings (1 hour)

For each potential IDOR:
- [ ] Save curl command
- [ ] Screenshot the response
- [ ] Note which user/token was used
- [ ] Document the impact

## Step 5: Submit (If Found)

- [ ] Write custom report (no templates!)
- [ ] Include proof (screenshots + curl)
- [ ] Submit to HackerOne
- [ ] Monitor for triager response
