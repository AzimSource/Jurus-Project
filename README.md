# 🛡️ JURUS ANALYST - PROJECT

## Secure IT Helpdesk Ticketing System Infrastructure

![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![Platform](https://img.shields.io/badge/Platform-Ubuntu%20Server-orange)
![Application](https://img.shields.io/badge/Application-osTicket-blue)
![Security](https://img.shields.io/badge/Security-Hardening-red)

---

## 📌 Introduction

This project is a **Secure IT Helpdesk Ticketing System Infrastructure** built using **osTicket** on **Ubuntu Server**.

The main goal of this project is to deploy a working helpdesk ticketing system and apply security controls to protect the server, network, database, web application, logs, and backup process.

This project was developed as part of the **JURUS Analyst Project** and uses open-source tools in a virtual lab environment.

---

## ❗ Problem Statement

A default helpdesk system may be exposed to several security risks if it is not properly configured.

Common issues include:

* 🔓 Weak SSH and server configuration
* 🌐 Unnecessary network services exposed
* 🗄️ Insecure database access
* 🧱 Missing web application hardening
* 📄 Lack of log monitoring
* 💾 No tested backup and recovery plan

Because of these risks, a secure and recoverable helpdesk infrastructure is required.

---

## 🎯 Objectives

The objectives of this project are:

* ✅ Deploy a functional osTicket helpdesk system
* ✅ Harden the Ubuntu Server operating system
* ✅ Secure SSH access using key-based authentication
* ✅ Configure firewall rules using UFW
* ✅ Protect SSH from brute-force attacks using Fail2Ban
* ✅ Secure MariaDB database access
* ✅ Harden Apache and osTicket configuration
* ✅ Monitor security logs
* ✅ Implement backup, restore, and checksum validation
* ✅ Validate security improvements using VAPT before and after remediation

---

## 🏗️ Project Architecture

The infrastructure includes:

* 👤 User / Helpdesk Agent
* 🖥️ Ubuntu Server VM
* 🌐 Apache2 Web Server
* 🧩 PHP Runtime
* 🎫 osTicket Application
* 🗄️ MariaDB Database
* 🔐 OpenSSH
* 🧱 UFW Firewall
* 🚫 Fail2Ban
* 📊 Logwatch
* 💾 Backup Storage

---

## 🧰 Tools and Technologies

| Tool             | Purpose                       |
| ---------------- | ----------------------------- |
| 🐧 Ubuntu Server | Main operating system         |
| 🎫 osTicket      | Helpdesk ticketing system     |
| 🌐 Apache2       | Web server                    |
| 🧩 PHP           | Application runtime           |
| 🗄️ MariaDB      | Database server               |
| 🔐 OpenSSH       | Remote administration         |
| 🧱 UFW           | Firewall control              |
| 🚫 Fail2Ban      | Brute-force protection        |
| 📊 Logwatch      | Log summary report            |
| 🔎 Nmap          | Network scanning              |
| 🕷️ Nikto        | Web vulnerability scanning    |
| 💾 Bash Script   | Backup automation             |
| ⏰ Cron           | Scheduled backup              |
| #️⃣ SHA256       | Backup integrity verification |

---

## 🔐 Security Modules Covered

This project covers **6 main security modules**.

---

### 1️⃣ Operating System Engineering

This module focuses on preparing and hardening the Ubuntu Server.

Implemented controls:

* System update and upgrade
* Apache, MariaDB, PHP, and SSH installation
* SSH hardening
* SSH key-based authentication
* Disabled root SSH login
* Disabled password SSH login
* Changed SSH port to `2222`
* Password policy enforcement
* Password aging policy

---

### 2️⃣ Network Security

This module focuses on reducing network exposure.

Implemented controls:

* UFW firewall configuration
* Default deny incoming policy
* Allowed only required ports
* SSH restricted to custom port `2222`
* HTTP and HTTPS allowed for osTicket
* Fail2Ban SSH brute-force protection
* Nmap validation before and after hardening

---

### 3️⃣ Database Security

This module focuses on protecting the osTicket database.

Implemented controls:

* MariaDB service verification
* Dedicated osTicket database
* Dedicated database user
* Database user restricted to `localhost`
* MariaDB not exposed externally
* Database privilege validation
* Ticket data verification from database

---

### 4️⃣ Application Security

This module focuses on hardening osTicket and Apache.

Implemented controls:

* osTicket installation and validation
* Removed setup directory
* Secured `ost-config.php`
* Apache security headers
* Apache banner hardening
* Blocked sensitive file access such as `/web.config`
* Restricted unnecessary HTTP methods
* Enabled HTTPS using self-signed TLS certificate
* Nikto scan before and after remediation

---

### 5️⃣ Security Monitoring

This module focuses on reviewing logs and detecting suspicious activity.

Monitoring sources:

* UFW firewall logs
* SSH authentication logs
* Fail2Ban logs
* Apache access logs
* Apache error logs
* Logwatch security report

This helps detect blocked traffic, failed login attempts, web access activity, and brute-force attacks.

---

### 6️⃣ Business Continuity Planning

This module focuses on backup and recovery.

Implemented controls:

* Backup directory preparation
* Manual database backup using `mysqldump`
* Automated backup script
* Web application file backup
* SHA256 checksum verification
* Daily cron backup schedule
* Restore test using test database
* RTO, RPO, MTD, and MTO defined

BCP metrics:

| Metric | Target     |
| ------ | ---------- |
| RTO    | 30 minutes |
| RPO    | 24 hours   |
| MTD    | 4 hours    |
| MTO    | 4 hours    |

---

## 🔎 VAPT Before and After Remediation

Vulnerability assessment was performed using **Nmap, Nikto, curl, and manual testing**.

Main improvements:

| Finding                    | Remediation                        |
| -------------------------- | ---------------------------------- |
| SSH exposed on port 22     | Changed SSH to port 2222           |
| Password SSH login enabled | Disabled password login            |
| Root SSH risk              | Disabled root login                |
| Open services              | Applied UFW firewall rules         |
| SSH brute-force risk       | Implemented Fail2Ban               |
| Sensitive file exposure    | Blocked `/web.config`              |
| Missing security headers   | Added Apache security headers      |
| HTTP-only access           | Enabled HTTPS                      |
| Database exposure risk     | Restricted MariaDB to localhost    |
| Backup integrity risk      | Added SHA256 checksum verification |

---

## 📂 Repository Structure

```text
Jurus-Project/
├── Configs/
│   ├── ssh-config-sample.md
│   ├── fail2ban-jail-sample.md
│   ├── osticket-apache-config-sample.md
│   └── osticket-ssl-config-sample.md
├── Docs/
│   └── Demo-Flow.md
├── Notes/
│   ├── vapt-before-after.md
│   └── bcp-rto-rpo-mtd.md
├── Scripts/
│   └── osticket_backup.sh
└── README.md
```

---

## 🧪 Demo Validation

During the demo, the following items can be shown:

* Ubuntu Server service status
* SSH hardening configuration
* SSH key-based login
* UFW firewall rules
* Nmap scan result
* Fail2Ban banned IP status
* MariaDB local-only validation
* osTicket ticket creation
* Apache security headers
* HTTPS validation
* UFW, SSH, Fail2Ban, and Apache logs
* Backup script execution
* SHA256 checksum verification
* Database restore test

---

## ⚠️ Limitations

This project was implemented in a virtual lab environment. Some production-level features were not included, such as:

* LDAP or Active Directory integration
* Trusted SSL/TLS certificate
* Centralized SIEM integration
* Offsite backup storage
* High availability setup
* Full disaster recovery simulation

---

## 🚀 Future Enhancements

Future improvements may include:

* Integrating osTicket with LDAP or Active Directory
* Using a trusted TLS certificate
* Adding Wazuh or ELK SIEM monitoring
* Sending automated email alerts
* Implementing offsite backup
* Performing full disaster recovery testing
* Applying stricter database privileges
* Adding automated security audit tools

---

## ✅ Conclusion

This project successfully demonstrates how a default osTicket helpdesk system can be secured using practical infrastructure hardening controls.

The final system includes server hardening, firewall protection, SSH security, database restriction, application hardening, log monitoring, backup automation, and restore validation.

Overall, this project improves the **confidentiality, integrity, availability, monitoring, and recoverability** of the helpdesk infrastructure.

---

## 👤 Author

**Khairul Azim Bin Osman**
JURUS Analyst Project
Secure IT Helpdesk Ticketing System Infrastructure
