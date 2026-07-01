---

# 🎯 Demo Flow (JURUS Analyst)

## Module 1 – Operating System Engineering

### Objective

Secure the Ubuntu Server by applying operating system hardening and securing remote administrative access.

---

## 1. Verify System Services

### Configuration

Verify that the required services are running.

```bash
hostnamectl
uptime
sudo systemctl status apache2 --no-pager
sudo systemctl status mariadb --no-pager
sudo systemctl status ssh --no-pager
```

### Explain

> First, I verify that the Ubuntu Server is running correctly and that Apache, MariaDB, and SSH services are active before applying any security controls.

### Verification

✔ Apache running

✔ MariaDB running

✔ SSH running

---

## 2. SSH Key-Based Authentication

### Configuration

Ubuntu

```bash
cat /home/azim/.ssh/authorized_keys
```

Kali Linux

```bash
ls ~/.ssh
```

(Optional)

```bash
ssh -i ~/.ssh/id_ed25519 -p 2222 azim@192.168.194.131
```

### Explain

> Instead of using passwords, SSH uses key-based authentication. The public key is stored on Ubuntu, while the private key remains securely on the Kali machine.

### Verification

✔ Public key exists

✔ Login succeeds using private key

---

## 3. SSH Hardening

### Configuration

```bash
sudo grep -E "Port|PermitRootLogin|PubkeyAuthentication|PasswordAuthentication|MaxAuthTries|X11Forwarding|AllowUsers" /etc/ssh/sshd_config
```

### Explain

Show one by one.

* Root login disabled
* Password authentication disabled
* Key authentication enabled
* SSH moved to port 2222
* Authentication attempts limited
* Only authorized user allowed

### Verification

```bash
sudo ss -tulpn | grep ssh
```

Expected

```
LISTEN :2222
```

---

## 4. Password Policy

### Configuration

```bash
grep -E "minlen|dcredit|ucredit|lcredit|ocredit|retry|difok" /etc/security/pwquality.conf

grep pam_pwquality /etc/pam.d/common-password
```

### Explain

> Passwords must meet complexity requirements to reduce weak password attacks.

### Verification

Create test account.

```bash
sudo adduser testpolicy
sudo passwd testpolicy
```

Try

```
12345678
```

Explain

> Password rejected because it does not satisfy the password policy.

Delete account

```bash
sudo deluser --remove-home testpolicy
```

---

## 5. Password Aging

```bash
chage -l azim
```

Explain

> Password expiration and warning days are configured to reduce long-term password exposure.

---

# Module 2 – Network Security

### Objective

Protect the server from unauthorized network access.

---

## 1. Firewall

### Configuration

```bash
sudo ufw status verbose
```

Explain

> UFW uses a default deny policy and only required services are allowed.

Highlight

* HTTP

* HTTPS

* SSH 2222

---

## 2. Network Validation

Run on Kali

```bash
nmap -sV -p 22,80,443,2222 <IP ADDRESS>
```

Explain

> Port 22 is no longer accessible while SSH is only available through port 2222.

---

## 3. Fail2Ban

### Configuration

```bash
sudo systemctl status fail2ban

sudo cat /etc/fail2ban/jail.local
```

Explain

> Fail2Ban automatically blocks repeated failed SSH login attempts.

### Verification

```bash
sudo fail2ban-client status sshd
```

Highlight

```
Currently banned

Banned IP List
```

---

# Module 3 – Database Security

### Objective

Protect sensitive helpdesk data.

---

## 1. Verify Database

```bash
sudo systemctl status mariadb
```

---

## 2. Local-only Database

Configuration

```bash
sudo ss -tulpn | grep 3306
```

Explain

> MariaDB listens only on localhost.

Validation

From Kali

```bash
nmap -sV -p 3306 <IP ADDRESS> 
```

Expected

```
closed
filtered
```

---

## 3. Dedicated Database User

```bash
sudo mysql -e "SELECT User,Host FROM mysql.user WHERE User='osticket_user';"

sudo mysql -e "SHOW GRANTS FOR 'osticket_user'@'localhost';"
```

Explain

> osTicket does not use the MariaDB root account.

---

## 4. Verify Ticket Stored

```bash
sudo mysql -u root -e "
USE osticket_db;
SELECT ticket_id,number
FROM ost_ticket
ORDER BY ticket_id DESC
LIMIT 5;"
```

Explain

> The ticket created from osTicket is successfully stored inside the database.

---

# Module 4 – Application Security

### Objective

Reduce web application attack surface.

---

## 1. Live Demo

Create one ticket.

Explain

> User submits ticket.

Staff receives ticket.

---

## 2. Setup Removed

```bash
ls -ld /var/www/osticket/setup
```

Explain

> Attackers cannot rerun installation.

---

## 3. Secure Configuration File

```bash
ls -l /var/www/osticket/include/ost-config.php
```

Explain

> Configuration file has restricted permission.

---

## 4. Security Headers

```bash
curl -I http://IP ADDRESS
```

Highlight

```
X-Frame-Options

X-Content-Type-Options

Referrer-Policy
```

---

## 5. HTTPS

```bash
curl -k -I https://IP ADDRESS
```

Explain

> HTTPS encrypts communication between client and server.

---

## 6. Sensitive File Protection

```bash
curl -I http://IP ADDRESS/web.config
```

Expected

```
403 Forbidden
```

---

## 7. Apache Banner

```bash
curl -I http://IP ADDRESS
```

Explain

> Apache version is hidden to reduce information disclosure.

---

# Module 5 – Security Monitoring

### Objective

Monitor system activities and detect security events.

---

## UFW Logs

```bash
sudo tail /var/log/ufw.log
```

Explain

Blocked traffic.

---

## SSH Logs

```bash
sudo journalctl -u ssh
```

Explain

Successful and failed login.

---

## Fail2Ban Logs

```bash
sudo tail /var/log/fail2ban.log
```

Explain

Automatically banned attacker IP.

---

## Apache Logs

```bash
sudo tail /var/log/apache2/access.log

sudo tail /var/log/apache2/error.log
```

Explain

Monitor web access and application errors.

---

## Logwatch

```bash
cat /tmp/logwatch_security_report.txt
```

Explain

Daily security summary.

---

# Module 6 – Business Continuity Planning

### Objective

Ensure the system can recover after failure.

---

## Backup Directory

```bash
sudo ls -lh /backup/osticket
```

Explain

Backup organization.

---

## Backup Script

```bash
sudo nano /usr/local/bin/osticket_backup.sh
```

Explain

Automated database and file backup.

---

## Execute Backup

```bash
sudo /usr/local/bin/osticket_backup.sh
```

Verification

```
backup.log

database backup

application backup

checksum
```

---

## Checksum

```bash
sudo sha256sum -c ...
```

Explain

Verify backup integrity.

---

## Cron

```bash
sudo crontab -l
```

Explain

Daily backup at 2 AM.

---

## Restore Test

Create test database.

Restore.

Show ticket.

Explain

> Backup is usable because the restored database contains the same ticket records.

---

## Explain RTO/RPO

Finish with

> RTO is **30 minutes**, meaning the service should be restored within 30 minutes. RPO is **24 hours** because backups are performed daily. MTD and MTO are **4 hours**, meaning the organization can tolerate up to four hours of downtime before critical business operations are significantly affected.

---
