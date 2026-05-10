#!/bin/bash
# Full recon script for bug bounty targets
# Usage: ./recon.sh target.com

if [ -z "$1" ]; then
    echo "Usage: ./recon.sh <target-domain>"
    exit 1
fi

TARGET=$1
OUTPUT_DIR="$HOME/bugbounty/reports/$TARGET"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "=== Starting reconnaissance on $TARGET ==="
echo "Output directory: $OUTPUT_DIR"

# Create output directories
mkdir -p $OUTPUT_DIR/{subdomains,ports,screenshots,nikto,nuclei,katana}

# Step 1: Subdomain Enumeration
echo "[1/6] Running subdomain enumeration..."
subfinder -d $TARGET -silent -o $OUTPUT_DIR/subdomains/subfinder_${TIMESTAMP}.txt
amass enum -d $TARGET -o $OUTPUT_DIR/subdomains/amass_${TIMESTAMP}.txt

# Combine and sort unique subdomains
cat $OUTPUT_DIR/subdomains/*.txt | sort -u > $OUTPUT_DIR/subdomains/all_${TIMESTAMP}.txt
echo "Found $(wc -l < $OUTPUT_DIR/subdomains/all_${TIMESTAMP}.txt) unique subdomains"

# Step 2: HTTP Probing
echo "[2/6] Running HTTP probing..."
cat $OUTPUT_DIR/subdomains/all_${TIMESTAMP}.txt | httpx -silent -o $OUTPUT_DIR/subdomains/alive_${TIMESTAMP}.txt
echo "Found $(wc -l < $OUTPUT_DIR/subdomains/alive_${TIMESTAMP}.txt) alive hosts"

# Step 3: Port Scanning
echo "[3/6] Running port scan on alive hosts..."
cat $OUTPUT_DIR/subdomains/alive_${TIMESTAMP}.txt | naabu -silent -o $OUTPUT_DIR/ports/ports_${TIMESTAMP}.txt

# Step 4: Vulnerability Scanning
echo "[4/6] Running Nuclei vulnerability scan..."
cat $OUTPUT_DIR/subdomains/alive_${TIMESTAMP}.txt | nuclei -silent -o $OUTPUT_DIR/nuclei/results_${TIMESTAMP}.txt

# Step 5: Web Crawling
echo "[5/6] Running Katana web crawler on main domains..."
cat $OUTPUT_DIR/subdomains/alive_${TIMESTAMP}.txt | head -20 | katana -silent -o $OUTPUT_DIR/katana/crawl_${TIMESTAMP}.txt

# Step 6: Nikto Scan (on first 10 alive hosts to avoid rate limits)
echo "[6/6] Running Nikto on top hosts..."
head -10 $OUTPUT_DIR/subdomains/alive_${TIMESTAMP}.txt | while read url; do
    DOMAIN=$(echo $url | sed 's|http[s]*://||' | sed 's|/.*||')
    nikto -h $url -output $OUTPUT_DIR/nikto/$(echo $DOMAIN | sed 's/[.:]/_/g')_${TIMESTAMP}.txt -Format csv 2>/dev/null &
done

wait

echo ""
echo "=== Recon complete! ==="
echo "Results saved to: $OUTPUT_DIR"
echo ""
echo "Summary:"
echo "  - Subdomains found: $(wc -l < $OUTPUT_DIR/subdomains/all_${TIMESTAMP}.txt)"
echo "  - Alive hosts: $(wc -l < $OUTPUT_DIR/subdomains/alive_${TIMESTAMP}.txt)"
echo "  - Nuclei findings: $(wc -l < $OUTPUT_DIR/nuclei/results_${TIMESTAMP}.txt)"
echo ""
echo "Next steps:"
echo "  - Review Nuclei results: cat $OUTPUT_DIR/nuclei/results_${TIMESTAMP}.txt"
echo "  - Check Nikto reports: ls $OUTPUT_DIR/nikto/"
