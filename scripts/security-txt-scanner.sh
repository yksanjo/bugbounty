#!/bin/bash
# 🔍 security.txt Bulk Scanner
# Finds hidden bug bounty programs that 92% of researchers miss

INPUT_FILE=$1
OUTPUT_FILE=~/bugbounty/targets/security_txt_findings.txt

if [ -z "$INPUT_FILE" ]; then
    echo "Usage: ./security-txt-scanner.sh <domains-file.txt>"
    echo "Example: ./security-txt-scanner.sh ~/bugbounty/targets/alive_platforms.txt"
    exit 1
fi

echo "🔍 === SECURITY.TXT BULK SCANNER ==="
echo "Scanning $(wc -l < $INPUT_FILE) domains for hidden bug bounty programs..."
echo ""

mkdir -p ~/bugbounty/targets

> $OUTPUT_FILE

while read DOMAIN; do
    [[ "$DOMAIN" =~ ^#.*$ ]] && continue
    [[ -z "$DOMAIN" ]] && continue
    
    # Clean domain
    DOMAIN=$(echo $DOMAIN | sed 's|https\?://||' | sed 's|/.*||' | sed 's|:.*||')
    
    # Try both .well-known and root
    RESPONSE=$(curl -sL --max-time 5 "https://$DOMAIN/.well-known/security.txt" 2>/dev/null)
    
    if [ -z "$RESPONSE" ]; then
        RESPONSE=$(curl -sL --max-time 5 "https://$DOMAIN/security.txt" 2>/dev/null)
    fi
    
    # Check for bounty signals
    if echo "$RESPONSE" | grep -qi "bounty\|reward\|vulnerability\|disclosure\|responsible"; then
        echo "🎯 FOUND: $DOMAIN"
        
        # Extract key info
        BOUNTY=$(echo "$RESPONSE" | grep -i "bounty\|reward" | head -1)
        CONTACT=$(echo "$RESPONSE" | grep -i "contact\|email" | head -1)
        ACK=$(echo "$RESPONSE" | grep -i "acknowledg" | head -1)
        POLICY=$(echo "$RESPONSE" | grep -i "policy\|preferred-languages" | head -1)
        
        echo "  Bounty: $BOUNTY" >> $OUTPUT_FILE
        echo "  Contact: $CONTACT" >> $OUTPUT_FILE
        echo "  Policy: $POLICY" >> $OUTPUT_FILE
        echo "  ---" >> $OUTPUT_FILE
        echo ""
        
        sleep 0.5
    fi
    
done < "$INPUT_FILE"

echo ""
echo "✅ Scan complete!"
echo "📁 Results saved to: $OUTPUT_FILE"
echo ""
echo "📊 Summary:"
grep -c "🎯 FOUND" $OUTPUT_FILE 2>/dev/null && echo " programs found with bounty signals" || echo "0 programs found"
