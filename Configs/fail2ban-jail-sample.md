# Fail2Ban SSH Jail Configuration Sample

This file shows the Fail2Ban SSH jail configuration used to protect the Ubuntu Server from repeated failed SSH login attempts.

## Configuration File

File location:

```bash
/etc/fail2ban/jail.local
```

## SSH Jail Configuration

```ini
[sshd]
enabled = true
port = 2222
filter = sshd
backend = systemd
maxretry = 3
findtime = 10m
bantime = 10m
```

## Configuration Explanation

| Setting | Value | Explanation |
|---|---|---|
| `[sshd]` | SSH jail | Defines the jail for protecting the SSH service |
| `enabled` | `true` | Enables Fail2Ban protection for SSH |
| `port` | `2222` | Monitors SSH running on custom port 2222 |
| `filter` | `sshd` | Uses the default SSH filter to detect failed login attempts |
| `backend` | `systemd` | Reads SSH authentication events from systemd journal |
| `maxretry` | `3` | Bans an IP after 3 failed login attempts |
| `findtime` | `10m` | Failed attempts are counted within a 10-minute window |
| `bantime` | `10m` | Banned IP address remains blocked for 10 minutes |

## Security Purpose

Fail2Ban was implemented to reduce the risk of SSH brute-force attacks.  
When an attacker repeatedly fails to authenticate through SSH, Fail2Ban detects the failed attempts and automatically bans the source IP address.

In this project, SSH was moved from the default port `22` to custom port `2222`, so the Fail2Ban jail was configured to monitor port `2222`.

## Validation Commands

Check Fail2Ban service status:

```bash
sudo systemctl status fail2ban --no-pager
```

Check active Fail2Ban jails:

```bash
sudo fail2ban-client status
```

Check SSH jail status:

```bash
sudo fail2ban-client status sshd
```

View Fail2Ban logs:

```bash
sudo tail -n 30 /var/log/fail2ban.log
```

## Expected Result

After repeated failed SSH login attempts, the attacker IP should appear in the banned IP list.

Example:

```text
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed: 3
`- Actions
   |- Currently banned: 1
   |- Total banned: 1
   `- Banned IP list: IP_ADDRESS
```

## Demo Explanation

During the demo, this configuration proves that SSH brute-force protection is active.  
The server monitors failed SSH login attempts on port `2222`, and if an IP address fails login 3 times within 10 minutes, Fail2Ban automatically blocks that IP for 10 minutes.
