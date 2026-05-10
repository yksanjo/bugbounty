#!/bin/bash
# 🛡️ STRICT VULNERABILITY VALIDATION PROTOCOL
# This script MUST pass before ANY report is written.

TARGET_URL=$1
VULN_TYPE=$2
PAYLOAD=$3
EXPECTED_OUTCOME=$4

echo "🛡️ === VULNERABILITY VALIDATION PROTOCOL ==="
echo "Target: $TARGET_URL"
echo "Type: $VULN_TYPE"
echo ""

# 1. OWNERSHIP CHECK
echo "[1/3] Checking Ownership..."
DOMAIN=$(echo $TARGET_URL | awk -F/ '{print $3}')
WHOIS_ORG=$(whois $DOMAIN 2>/dev/null | grep -i "org\|owner\|registrant" | head -1)
echo "WHOIS Info: $WHOIS_ORG"
echo ""

# 2. EXPLOITATION VERIFICATION
echo "[2/3] Attempting Safe Exploitation..."
echo "Sending payload..."

if [ "$VULN_TYPE" == "SQLi" ]; then
    # Time-based blind SQLi check
    START_TIME=$(date +%s)
    curl -s -o /dev/null -w "%{http_code}" -X POST "$TARGET_URL" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --data-urlencode "$PAYLOAD"
    END_TIME=$(date +%s)
    
    DELAY=$((END_TIME - START_TIME))
    echo "⏱️ Response Time: ${DELAY}s"
    
    if [ $DELAY -ge 5 ]; then
        echo "✅ **VALIDATION SUCCESSFUL**: Time-based SQL Injection confirmed!"
        echo "   Server paused for $DELAY seconds."
        VALIDATION=true
    else
        echo "❌ **VALIDATION FAILED**: No time delay detected. Scanner likely false positive."
        VALIDATION=false
    fi
elif [ "$VULN_TYPE" == "XSS" ]; then
    RESPONSE=$(curl -s "$TARGET_URL?$PAYLOAD")
    if echo "$RESPONSE" | grep -q "$PAYLOAD"; then
        if echo "$RESPONSE" | grep -q "<script>"; then
             echo "✅ **VALIDATION SUCCESSFUL**: Reflected XSS confirmed!"
             VALIDATION=true
        else
             echo "⚠️  **PARTIAL**: Payload reflected but likely encoded/escaped."
             VALIDATION=false
        fi
    else
        echo "❌ **VALIDATION FAILED**: Payload not reflected."
        VALIDATION=false
    fi
fi

echo ""
echo "[3/3] Final Verdict"
echo "======================"
if [ "$VALIDATION" == true ]; then
    echo "🟢 **SUBMIT REPORT** - Vulnerability is verified and exploitable."
    echo "   -> Proceed to writing manual report with this proof."
else
    echo "🔴 **DO NOT SUBMIT** - Scanner gave a false positive."
    echo "   -> Discard finding."
fi
