# 🛍️ SHOPIFY IDOR HUNTING PLAN

## Why Shopify?
- Complex multi-tenant architecture
- Hundreds of API endpoints
- Multiple user roles (staff, admin, collaborator, customer)
- Real financial data (orders, payouts, customers)
- Max bounty: $100,000

## 📋 Setup Checklist

### Step 1: Create 2 Development Stores
1. Go to: https://www.shopify.com/free-trial
2. Create Store A (your main account)
3. Create Store B (different email)
4. Note: Shopify dev stores are FREE for testing

### Step 2: Get API Credentials
For EACH store:
1. Settings → Apps and sales channels → Develop apps
2. Create custom app → "IDOR Test App"
3. Configure Admin API scopes:
   - read_orders, write_orders
   - read_products, write_products
   - read_customers, write_customers
   - read_fulfillments
   - read_inventory
4. Install app → Copy API Key + Access Token

### Step 3: Create Test Data (Store A)
- Create 5 test orders
- Create 10 test customers
- Create 3 test products
- Create 2 test discounts

### Step 4: Map All API Endpoints
Browse Store A admin with DevTools open → Network tab
Look for: /admin/api/*, /admin/orders/*, /admin/customers/*

## 🎯 IDOR Test Matrix

### Priority 1: Orders (Highest Impact)
[ ] GET /admin/api/2026-01/orders/{order_id}.json
[ ] PUT /admin/api/2026-01/orders/{order_id}.json
[ ] GET /admin/api/2026-01/orders/{order_id}/transactions.json
[ ] GET /admin/api/2026-01/orders/{order_id}/fulfillments.json
[ ] POST /admin/api/2026-01/orders/{order_id}/fulfillments.json

### Priority 2: Customers (Privacy Impact)
[ ] GET /admin/api/2026-01/customers/{customer_id}.json
[ ] PUT /admin/api/2026-01/customers/{customer_id}.json
[ ] GET /admin/api/2026-01/customers/{customer_id}/orders.json
[ ] GET /admin/api/2026-01/customers/search.json

### Priority 3: Products (Business Impact)
[ ] GET /admin/api/2026-01/products/{product_id}.json
[ ] PUT /admin/api/2026-01/products/{product_id}.json
[ ] DELETE /admin/api/2026-01/products/{product_id}.json
[ ] GET /admin/api/2026-01/products/{product_id}/variants.json

### Priority 4: Discounts (Financial Impact)
[ ] GET /admin/api/2026-01/price_rules/{rule_id}.json
[ ] PUT /admin/api/2026-01/price_rules/{rule_id}.json
[ ] GET /admin/api/2026-01/price_rules/{rule_id}/discount_codes.json

### Priority 5: Draft Orders
[ ] GET /admin/api/2026-01/draft_orders/{draft_order_id}.json
[ ] PUT /admin/api/2026-01/draft_orders/{draft_order_id}.json

### Priority 6: Gift Cards
[ ] GET /admin/api/2026-01/gift_cards/{gift_card_id}.json
[ ] PUT /admin/api/2026-01/gift_cards/{gift_card_id}/disable.json

## 🧪 Testing Methodology

For EACH endpoint:
1. As Store A: Create object → Note ID
2. As Store B: Try to access/modify Store A's object
3. Test all HTTP methods: GET, PUT, POST, DELETE
4. Test different ID types: sequential, UUID, base64
5. Test with different API versions

## 📝 Success Criteria

IDOR CONFIRMED if:
- Store B can READ Store A's private data → Medium-High severity
- Store B can MODIFY Store A's data → High severity
- Store B can DELETE Store A's data → High-Critical severity
- Store B can CREATE objects in Store A → Medium severity

## 💰 Expected Bounties

| Finding Type | Expected Bounty |
|-------------|----------------|
| Read orders from other stores | $2,000-$10,000 |
| Modify other stores' orders | $5,000-$20,000 |
| Access customer PII | $2,000-$10,000 |
| Modify products/discounts | $1,000-$5,000 |
| Delete other stores' data | $5,000-$20,000 |
