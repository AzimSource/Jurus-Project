# Apache osTicket Virtual Host Configuration Sample

This file shows the Apache virtual host configuration used to host and harden the osTicket web application.

## Configuration File

File location:

```bash
/etc/apache2/sites-available/osticket.conf
```

## Important Configuration Sample

```apache
<VirtualHost *:80>
    ServerName 192.168.194.131
    DocumentRoot /var/www/osticket

    <Directory /var/www/osticket>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # Apache security headers
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set Referrer-Policy "no-referrer-when-downgrade"

    # Block sensitive file access
    <FilesMatch "^web\.config$">
        Require all denied
    </FilesMatch>

    # Restrict unnecessary HTTP methods
    RewriteEngine On
    RewriteCond %{REQUEST_METHOD} !^(GET|POST|HEAD)$
    RewriteRule .* - [R=405,L]

    ErrorLog ${APACHE_LOG_DIR}/osticket_error.log
    CustomLog ${APACHE_LOG_DIR}/osticket_access.log combined
</VirtualHost>
```

## Configuration Explanation

| Configuration | Purpose |
|---|---|
| `VirtualHost *:80` | Hosts osTicket on HTTP port 80 |
| `DocumentRoot /var/www/osticket` | Points Apache to the osTicket application directory |
| `Options -Indexes` | Prevents directory listing |
| `AllowOverride All` | Allows osTicket `.htaccess` rules to work |
| `Require all granted` | Allows web access to the osTicket directory |
| `X-Frame-Options` | Helps prevent clickjacking |
| `X-Content-Type-Options` | Prevents MIME type sniffing |
| `X-XSS-Protection` | Enables browser XSS protection for older browsers |
| `Referrer-Policy` | Reduces referrer information leakage |
| `FilesMatch "^web\.config$"` | Blocks public access to sensitive `web.config` file |
| `RewriteCond %{REQUEST_METHOD}` | Restricts unnecessary HTTP methods |
| `ErrorLog` | Stores osTicket Apache error logs |
| `CustomLog` | Stores osTicket Apache access logs |

## Security Purpose

This Apache configuration was applied to reduce the attack surface of the osTicket web application.  
The configuration adds browser security headers, blocks sensitive file access, disables directory listing, restricts unnecessary HTTP methods, and separates osTicket logs for easier monitoring.

## Validation Commands

Check Apache configuration syntax:

```bash
sudo apache2ctl configtest
```

Restart Apache:

```bash
sudo systemctl restart apache2
```

Check security headers:

```bash
curl -I http://192.168.194.131
```

Check sensitive file blocking:

```bash
curl -I http://192.168.194.131/web.config
```

Check unnecessary HTTP method restriction:

```bash
curl -X PUT -I http://192.168.194.131
```

Check osTicket Apache logs:

```bash
sudo tail -n 30 /var/log/apache2/osticket_error.log
sudo tail -n 30 /var/log/apache2/osticket_access.log
```

## Expected Result

Security headers should appear in the HTTP response:

```text
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Referrer-Policy: no-referrer-when-downgrade
```

Access to `/web.config` should return:

```text
HTTP/1.1 403 Forbidden
```

Unnecessary HTTP methods such as `PUT` should return:

```text
HTTP/1.1 405 Method Not Allowed
```

## Demo Explanation

During the demo, this configuration proves that the osTicket web application was hardened at the Apache level.  
The server applies security headers, blocks sensitive file access, restricts unnecessary HTTP methods, and records web activity using dedicated Apache logs.
