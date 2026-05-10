#!/bin/bash
# Lightweight continuous scanning for Raspberry Pi
# Usage: ./pi-scanner.sh targets.txt [interval_seconds]

if [ -z "$1" ]; then
    echo "Usage: ./pi-scanner.sh <targets-file> [interval-seconds]"
    exit 1
fi

TARGETS_FILE=$1
INTERVAL=${2:-3600}  # Default: 1 hour

export PATH="$HOME/go/bin:$PATH"

echo "=== Pi Scanner starting ==="
echo "Targets: $TARGETS_FILE"
echo "Scan interval: ${INTERVAL}s"
echo "Press Ctrl+C to stop"

while true; do
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    OUTPUT_DIR="$HOME/bugbounty/reports/continuous/$TIMESTAMP"
    mkdir -p $OUTPUT_DIR
    
    echo ""
    echo "[$(date)] Starting scan cycle..."
    
    while read TARGET; do
        [[ "$TARGET" =~ ^#.*$ ]] && continue
        [[ -z "$TARGET" ]] && continue
        
        echo "  Scanning $TARGET..."
        
        # Subdomain enumeration
        subfinder -d $TARGET -silent -o $OUTPUT_DIR/${TARGET}_subdomains.txt
        
        # Check alive hosts
        if [ -f "$OUTPUT_DIR/${TARGET}_subdomains.txt" ]; then
            cat $OUTPUT_DIR/${TARGET}_subdomains.txt | httpx -silent -o $OUTPUT_DIR/${TARGET}_alive.txt
            
            # Quick vulnerability scan
            if [ -f "$OUTPUT_DIR/${TARGET}_alive.txt" ]; then
                cat $OUTPUT_DIR/${TARGET}_alive.txt | nuclei -silent -o $OUTPUT_DIR/${TARGET}_vulns.txt
                echo "    Found $(wc -l < $OUTPUT_DIR/${TARGET}_vulns.txt) potential vulnerabilities"
            fi
        fi
    done < "$TARGETS_FILE"
    
    echo "[$(date)] Scan cycle complete. Results in $OUTPUT_DIR"
    echo "[$(date)] Next scan in ${INTERVAL} seconds..."
    sleep $INTERVAL
done
