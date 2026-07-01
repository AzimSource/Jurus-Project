# VAPT Before and After Remediation

This document summarizes the Vulnerability Assessment and Penetration Testing (VAPT) findings before and after security hardening was applied to the Secure IT Helpdesk Ticketing System Infrastructure.

## Objective

The purpose of this VAPT activity is to identify security weaknesses in the osTicket infrastructure and validate that remediation actions successfully reduced the attack surface.

## Tools Used

| Tool | Purpose |
|---|---|
| Nmap | Network scanning and service enumeration |
| Nikto | Web server vulnerability scanning |
| curl | Manual HTTP response and header validation |
| Manual Testing | Validation of SSH, firewall, database, and application controls |

## VAPT Summary

| Finding | Before Remediation | Remediation Applied | After Remediation |
|---|---|---|---|
| SSH exposed on default port | SSH was accessible on default port `22` | Changed SSH port to `2222` and updated UFW rules | Port `22` became filtered and SSH was accessible through port `2222` |
| SSH password authentication | Password-based SSH login was allowed | Enabled key-based authentication and disabled password login | SSH login required private key authentication |
| Direct root SSH login | Root login could increase administrative access risk | Configured `PermitRootLogin no` | Direct root SSH login was disabled |
| Open network services | Initial scan showed exposed SSH and HTTP services | Applied UFW default deny incoming policy and allowed only required ports | Only required ports were accessible: `80`, `443`, and `2222` |
| SSH brute-force attempts | Repeated failed SSH login attempts could occur | Implemented Fail2Ban SSH jail | Repeated failed login attempts were banned automatically |
| Sensitive file exposure | `/web.config` was accessible | Blocked access using Apache `FilesMatch` rule | `/web.config` returned `403 Forbidden` |
| Unnecessary HTTP methods | Web server responded to unnecessary HTTP methods | Restricted HTTP methods to `GET`, `POST`, and `HEAD` | Unnecessary HTTP methods were blocked |
| Missing security headers | HTTP response had limited browser-side protection | Added Apache security headers | Security headers appeared in `curl -I` output |
| HTTP-only web access | osTicket was initially accessible through HTTP only | Enabled HTTPS using self-signed TLS certificate | osTicket was accessible through HTTPS on port `443` |
| Weak SSL/TLS protocols | TLS hardening was not configured initially | Disabled SSLv2, SSLv3, TLS 1.0, and TLS 1.1 | HTTPS virtual host used stronger TLS configuration |
| osTicket setup directory | Setup directory could be risky if left after installation | Removed `/var/www/osticket/setup` | Setup directory was no longer available |
| osTicket configuration file permission | Configuration file required permission hardening | Secured `ost-config.php` ownership and permission | File permission was verified using `ls -l` |
| Database access control | Database access needed separation from root account | Created dedicated `osticket_user@localhost` for `osticket_db` | osTicket used a dedicated local database user |
| Backup integrity | Backup files could not be verified for changes or corruption | Added SHA256 checksum generation and verification | Backup files returned `OK` during checksum validation |

## Key Validation Commands

### Network Scan

```bash
nmap -sV -p 22,80,443,2222 192.168.194.131
```

Expected result:

```text
22/tcp filtered
80/tcp open http
443/tcp open ssl/http
2222/tcp open ssh
```

### Database Exposure Check

```bash
nmap -sV -p 3306 192.168.194.131
```

Expected result:

```text
3306/tcp closed or filtered
```

### SSH Hardening Validation

```bash
sudo grep -E "Port|PermitRootLogin|PubkeyAuthentication|PasswordAuthentication|MaxAuthTries|X11Forwarding|AllowUsers" /etc/ssh/sshd_config
sudo ss -tulpn | grep ssh
```

Expected configuration:

```text
Port 2222
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
MaxAuthTries 3
X11Forwarding no
AllowUsers azim
```

### Firewall Validation

```bash
sudo ufw status verbose
```

### Fail2Ban Validation

```bash
sudo fail2ban-client status sshd
```

Expected result:

```text
Status for the jail: sshd
Currently banned: 1
Banned IP list: 192.168.194.129
```

### Security Headers Validation

```bash
curl -I http://192.168.194.131
```

Expected headers:

```text
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Referrer-Policy: no-referrer-when-downgrade
```

### Sensitive File Blocking

```bash
curl -I http://192.168.194.131/web.config
```

Expected result:

```text
HTTP/1.1 403 Forbidden
```

### HTTPS Validation

```bash
curl -k -I https://192.168.194.131
```

Expected result:

```text
HTTP/1.1 200 OK
Strict-Transport-Security: max-age=31536000; includeSubDomains
```

### Backup Integrity Validation

```bash
sudo sha256sum -c /backup/osticket/checksums/backup_*.sha256
```

Expected result:

```text
OK
```

## Result

The VAPT activity showed that the osTicket helpdesk infrastructure was significantly improved after remediation. The final system reduced unnecessary network exposure, strengthened SSH access, protected sensitive web files, enabled HTTPS, improved application security headers, restricted database access, and validated backup integrity.

## Conclusion

The before-and-after VAPT results prove that the system is more secure compared to the default installation. The implemented controls improved confidentiality, integrity, availability, monitoring, and recovery readiness of the helpdesk infrastructure.
