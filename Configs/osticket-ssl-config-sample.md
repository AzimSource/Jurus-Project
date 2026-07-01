# Apache osTicket SSL/TLS Configuration Sample

This file shows the Apache SSL/TLS configuration used to enable HTTPS for the osTicket web application.

## Configuration File

File location:

```bash
/etc/apache2/sites-available/osticket-ssl.conf
```

## SSL/TLS Configuration Sample

```apache
SSLCertificateFile /etc/ssl/certs/osticket-selfsigned.crt
SSLCertificateKeyFile /etc/ssl/private/osticket-selfsigned.key

SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLCipherSuite HIGH:!aNULL:!MD5

Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
```

## Configuration Explanation

| Configuration | Purpose |
|---|---|
| `SSLCertificateFile` | Defines the SSL/TLS certificate file used for HTTPS |
| `SSLCertificateKeyFile` | Defines the private key file for the certificate |
| `SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1` | Disables weak SSL/TLS versions and allows stronger protocols |
| `SSLCipherSuite HIGH:!aNULL:!MD5` | Allows stronger cipher suites and blocks weak/null/MD5-based ciphers |
| `Strict-Transport-Security` | Forces browsers to use HTTPS for future connections |

## Security Purpose

HTTPS was enabled to encrypt communication between the client and the osTicket server.  
This helps protect login credentials, ticket information, and session data from being exposed in plaintext.

In this lab environment, a self-signed certificate was used. For a production environment, a trusted certificate from a Certificate Authority should be used.

## Validation Commands

Check Apache SSL configuration:

```bash
sudo grep -E "SSLProtocol|SSLCipherSuite|Strict-Transport-Security|SSLCertificate" /etc/apache2/sites-available/osticket-ssl.conf
```

Check Apache configuration syntax:

```bash
sudo apache2ctl configtest
```

Restart Apache:

```bash
sudo systemctl restart apache2
```

Check HTTPS response:

```bash
curl -k -I https://IP_ADDRESS
```

Check SSL/TLS connection:

```bash
openssl s_client -connect IP_ADDRESS:443
```

## Expected Result

The HTTPS response should show that the web server is reachable over port `443`.

Example:

```text
HTTP/1.1 200 OK
Strict-Transport-Security: max-age=31536000; includeSubDomains
```

The Nmap scan should also show port `443` open:

```bash
nmap -sV -p 443 <IP ADDRESS>
```

Expected result:

```text
443/tcp open ssl/http
```

## Demo Explanation

During the demo, this configuration proves that HTTPS was enabled for osTicket.  
The server uses a self-signed certificate for lab testing, disables weak SSL/TLS protocols, applies stronger cipher settings, and adds the HSTS header to encourage secure HTTPS communication.
