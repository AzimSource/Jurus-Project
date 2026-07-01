# Modul 1: OS
#show service 
hostnamectl
uptime
sudo systemctl status apache2 --no-pager
sudo systemctl status mariadb --no-pager
sudo systemctl status ssh --no-pager

#show key
cat /root/.ssh/id_ed25519  → linux
cat /home/azim/.ssh/authorized_keys → ubuntu

#show ssh hardening configuration
sudo grep -E "Port|PermitRootLogin|PubkeyAuthentication|PasswordAuthentication|MaxAuthTries|X11Forwarding|AllowUsers" /etc/ssh/sshd_config

#show listening port
sudo ss -tulpn | grep ssh


#show password policy
grep -E "minlen|dcredit|ucredit|lcredit|ocredit|retry|difok" /etc/security/pwquality.conf
grep pam_pwquality /etc/pam.d/common-password

#Enable password aging administrative password
chage -l azim

#testpolicy
sudo adduser testpolicy
sudo passwd testpolicy
sudo deluser --remove-home testpolicy

# Modul 2: Network
#firewall rules
sudo ufw status verbose

#scan
nmap -sV -p 22,80,443,2222 192.168.194.131

#show fail2ban
sudo systemctl status fail2ban --no-pager
#show config
sudo cat /etc/fail2ban/jail.local
sudo fail2ban-client status sshd
#Modul 3; Database
#show service
sudo systemctl status mariadb --no-pager

#show mariadb local-only
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
sudo ss -tulpn | grep -E "mysql|mariadb|3306"

#scan nmap
nmap -sV -p 3306 192.168.194.131

#show dedicated database user
sudo mysql -u root -e "SELECT User, Host FROM mysql.user WHERE User='osticket_user';"

#show database grants
sudo mysql -e "SHOW GRANTS FOR 'osticket_user'@'localhost';"

#show ticket data stored in db
sudo mysql -u root -e "USE osticket_db; SELECT t.ticket_id, t.number, c.subject, t.created FROM ost_ticket t LEFT JOIN ost_ticket__cdata c ON t.ticket_id=c.ticket_id ORDER BY t.ticket_id DESC LIMIT 5;"

#Modul 4 Application
→ show ticket creation at admin panel
#setup removed
ls -ld /var/www/osticket/setup

#config file permission
ls -l /var/www/osticket/include/ost-config.php

#show apache header config
sudo grep -R "Header always set" /etc/apache2/sites-available/osticket.conf

#scan apache
curl -I http://192.168.194.131

#show https enable using a self-signed certificate
sudo grep -E "SSLProtocol|SSLCipherSuite|Strict-Transport-Security|SSLCertificate" /etc/apache2/sites-available/osticket-ssl.conf
#scan
curl -k -I https://192.168.194.131
openssl s_client -connect 192.168.194.131:443

#show sensitive file blocked
sudo nano /etc/apache2/sites-available/osticket.conf
curl -I http://192.168.194.131/web.config
nikto -h http://192.168.194.131

#show apache banner hardening
sudo grep -R "ServerTokens\|ServerSignature" /etc/apache2/conf-available/security.conf

#scan apache
curl -I http://192.168.194.131




#Modul5 Monitoring
#show ufw log
sudo tail -n 30 /var/log/ufw.log

#show ssh auth log
sudo tail -n 30 /var/log/auth.log
sudo journalctl -u ssh -n 30 --no-pager

#show fail2ban
sudo fail2ban-client status sshd
sudo tail -n 30 /var/log/fail2ban.log

#Show apache log
sudo ls -lh /var/log/apache2/
sudo tail -n 30 /var/log/apache2/access.log
sudo tail -n 30 /var/log/apache2/error.log
sudo tail -n 30 /var/log/apache2/osticket_error.log


#show logwatch report
cat /tmp/logwatch_security_report.txt
→ generate
sudo logwatch --detail High --range today --format text | less


#Modul 6 BCP
#show backup directory

sudo ls -l /backup/osticket
sudo ls -lh /backup/osticket/db
sudo ls -lh /backup/osticket/files
sudo ls -lh /backup/osticket/checksums
sudo ls -lh /backup/osticket/logs


#show backup script
ls -l /usr/local/bin/osticket_backup.sh
sudo nano /usr/local/bin/osticket_backup.sh
#run
sudo /usr/local/bin/osticket_backup.sh


#manual backup
Backup → mysqldump -u osticket_user -p osticket_db > /backup/osticket/osticket_db_backup_demo.sql

#check
sudo tail -n 20 /backup/osticket/logs/backup.log
sudo ls -lh /backup/osticket/db
sudo ls -lh /backup/osticket/files
sudo ls -lh /backup/osticket/checksums

sudo sh -c 'sha256sum -c /backup/osticket/checksums/backup_*.sha256'

#show crontab 
sudo crontab -l

#backup
sudo sh -c 'mysqldump -u root osticket_db > /backup/osticket/osticket_db_latest.sql'
#check 
sudo ls -lh /backup/osticket/osticket_db_latest.sql

#RTO
sudo mysql -u root -e "DROP DATABASE IF EXISTS osticket_restore_test; CREATE DATABASE osticket_restore_test;"

/usr/bin/time -p sudo sh -c 'mysql -u root osticket_restore_test < /backup/osticket/osticket_db_latest.sql'


#verify
sudo mysql -u root -e "USE osticket_restore_test; SELECT t.ticket_id, t.number, c.subject, t.created FROM ost_ticket t LEFT JOIN ost_ticket__cdata c ON t.ticket_id=c.ticket_id ORDER BY t.ticket_id DESC LIMIT 5;"



