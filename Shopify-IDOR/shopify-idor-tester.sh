#!/bin/bash
# 🛍️ Shopify IDOR Auto-Tester
# Usage: ./shopify-idor-tester.sh <STORE_A_URL> <STORE_A_TOKEN> <STORE_B_URL> <STORE_B_TOKEN> <ORDER_ID_A> <CUSTOMER_ID_A>

STORE_A_URL=$1
STORE_A_TOKEN=$2
STORE_B_URL=$3
STORE_B_TOKEN=$4
ORDER_ID_A=$5
CUSTOMER_ID_A=$6

if [ -z "$STORE_A_URL" ]; then
    echo "Usage: ./shopify-idor-tester.sh <STORE_A_URL> <TOKEN_A> <STORE_B_URL> <TOKEN_B> <ORDER_ID> <CUSTOMER_ID>"
    echo "Example: ./shopify-idor-tester.sh test-a.myshopify.com shpat_xxx test-b.myshopify.com shpat_yyy 12345 67890"
    exit 1
fi

API_VERSION="2026-01"
RESULTS_FILE=~/bugbounty/Shopify-IDOR/results_$(date +%Y%m%d_%H%M%S).txt

echo "🛍️ === SHOPIFY IDOR AUTOMATED TESTER ===" | tee $RESULTS_FILE
echo "" | tee -a $RESULTS_FILE
echo "Store A: $STORE_A_URL" | tee -a $RESULTS_FILE
echo "Store B: $STORE_B_URL" | tee -a $RESULTS_FILE
echo "" | tee -a $RESULTS_FILE

PASS=0
FAIL=0

run_test() {
    TEST_NUM=$1
    TEST_NAME=$2
    STORE_URL=$3
    TOKEN=$4
    ENDPOINT=$5
    EXPECTED=$6
    
    echo "=== TEST $TEST_NUM: $TEST_NAME ===" | tee -a $RESULTS_FILE
    echo "URL: https://$STORE_URL/admin/api/$API_VERSION/$ENDPOINT" | tee -a $RESULTS_FILE
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X GET \
        "https://$STORE_URL/admin/api/$API_VERSION/$ENDPOINT" \
        -H "X-Shopify-Access-Token: $TOKEN" \
        -H "Content-Type: application/json")
    
    HTTP_CODE=$(echo "$RESPONSE" | tail -1)
    BODY=$(echo "$RESPONSE" | sed '$d')
    
    echo "HTTP Status: $HTTP_CODE" | tee -a $RESULTS_FILE
    
    if echo "$BODY" | grep -q "errors\|not_found\|Unauthorized"; then
        echo "Result: ❌ BLOCKED (Good for Shopify)" | tee -a $RESULTS_FILE
        FAIL=$((FAIL+1))
    else
        echo "Result: 🚨 SUCCESS (Potential IDOR!)" | tee -a $RESULTS_FILE
        echo "Response preview:" | tee -a $RESULTS_FILE
        echo "$BODY" | head -20 | tee -a $RESULTS_FILE
        PASS=$((PASS+1))
    fi
    echo "" | tee -a $RESULTS_FILE
}

echo "🧪 RUNNING IDOR TESTS..." | tee -a $RESULTS_FILE
echo "" | tee -a $RESULTS_FILE

# TEST 1: Can Store B read Store A's order?
run_test 1 "Read Store A's order from Store B" \
    "$STORE_B_URL" "$STORE_B_TOKEN" "orders/$ORDER_ID_A.json" "404"

# TEST 2: Can Store B read Store A's customer?
run_test 2 "Read Store A's customer from Store B" \
    "$STORE_B_URL" "$STORE_B_TOKEN" "customers/$CUSTOMER_ID_A.json" "404"

# TEST 3: Can Store B modify Store A's order?
echo "=== TEST 3: Modify Store A's order from Store B ===" | tee -a $RESULTS_FILE
RESPONSE=$(curl -s -w "\n%{http_code}" -X PUT \
    "https://$STORE_B_URL/admin/api/$API_VERSION/orders/$ORDER_ID_A.json" \
    -H "X-Shopify-Access-Token: $STORE_B_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"order":{"note":"IDOR Test"}}')
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
echo "HTTP Status: $HTTP_CODE" | tee -a $RESULTS_FILE
if echo "$RESPONSE" | grep -q "errors\|not_found"; then
    echo "Result: ❌ BLOCKED" | tee -a $RESULTS_FILE
    FAIL=$((FAIL+1))
else
    echo "Result: 🚨 SUCCESS (Potential IDOR!)" | tee -a $RESULTS_FILE
    PASS=$((PASS+1))
fi
echo "" | tee -a $RESULTS_FILE

# TEST 4: Can Store B delete Store A's order?
echo "=== TEST 4: Delete Store A's order from Store B ===" | tee -a $RESULTS_FILE
RESPONSE=$(curl -s -w "\n%{http_code}" -X DELETE \
    "https://$STORE_B_URL/admin/api/$API_VERSION/orders/$ORDER_ID_A.json" \
    -H "X-Shopify-Access-Token: $STORE_B_TOKEN")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
echo "HTTP Status: $HTTP_CODE" | tee -a $RESULTS_FILE
if [ "$HTTP_CODE" = "404" ] || [ "$HTTP_CODE" = "403" ]; then
    echo "Result: ❌ BLOCKED" | tee -a $RESULTS_FILE
    FAIL=$((FAIL+1))
else
    echo "Result: 🚨 SUCCESS (Potential IDOR!)" | tee -a $RESULTS_FILE
    PASS=$((PASS+1))
fi
echo "" | tee -a $RESULTS_FILE

# TEST 5: Can Store B list Store A's orders via search?
echo "=== TEST 5: Search for Store A's orders from Store B ===" | tee -a $RESULTS_FILE
RESPONSE=$(curl -s -w "\n%{http_code}" \
    "https://$STORE_B_URL/admin/api/$API_VERSION/orders.json?status=any" \
    -H "X-Shopify-Access-Token: $STORE_B_TOKEN")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')
ORDER_COUNT=$(echo "$BODY" | python3 -c "import sys, json; data=json.load(sys.stdin); print(len(data.get('orders', [])))" 2>/dev/null || echo "0")
echo "Orders found: $ORDER_COUNT" | tee -a $RESULTS_FILE
if [ "$ORDER_COUNT" = "0" ]; then
    echo "Result: ❌ BLOCKED" | tee -a $RESULTS_FILE
    FAIL=$((FAIL+1))
else
    echo "Result: ⚠️  Found $ORDER_COUNT orders (check if any belong to Store A)" | tee -a $RESULTS_FILE
    PASS=$((PASS+1))
fi
echo "" | tee -a $RESULTS_FILE

echo "" | tee -a $RESULTS_FILE
echo "=== TEST SUMMARY ===" | tee -a $RESULTS_FILE
echo "Tests passed (IDOR found): $PASS" | tee -a $RESULTS_FILE
echo "Tests failed (Blocked): $FAIL" | tee -a $RESULTS_FILE
echo "" | tee -a $RESULTS_FILE

if [ $PASS -gt 0 ]; then
    echo "🚨 POTENTIAL IDOR VULNERABILITIES FOUND!" | tee -a $RESULTS_FILE
    echo "Review $RESULTS_FILE for details" | tee -a $RESULTS_FILE
else
    echo "✅ All tests blocked - Shopify's security is solid on these endpoints" | tee -a $RESULTS_FILE
    echo "Try testing: Draft orders, gift cards, price rules, or metafields" | tee -a $RESULTS_FILE
fi

echo "" | tee -a $RESULTS_FILE
echo "📁 Results saved to: $RESULTS_FILE"
