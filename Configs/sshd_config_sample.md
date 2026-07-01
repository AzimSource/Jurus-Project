## SSH Hardening Configuration Sample

The SSH service was hardened to reduce unauthorized administrative access.  
The configuration below shows the important SSH security settings applied on the Ubuntu Server.

```bash
# Custom SSH port
Port 2222

# Disable direct root login
PermitRootLogin no

# Limit authentication attempts
MaxAuthTries 3

# Allow only specific user to login through SSH
AllowUsers azim

# Enable public key authentication
PubkeyAuthentication yes

# Disable password-based SSH login
PasswordAuthentication no

# Disable X11 forwarding
X11Forwarding no
```

### Security Purpose

| Configuration | Purpose |
|---|---|
| `Port 2222` | Changes SSH from the default port 22 to reduce automated scanning exposure |
| `PermitRootLogin no` | Prevents direct root login through SSH |
| `MaxAuthTries 3` | Limits repeated login attempts |
| `AllowUsers azim` | Restricts SSH login to the authorized user only |
| `PubkeyAuthentication yes` | Enables SSH key-based authentication |
| `PasswordAuthentication no` | Disables password login and requires a private key |
| `X11Forwarding no` | Disables unnecessary graphical forwarding feature |

### Validation Commands

```bash
sudo sshd -t && echo "SSHD configuration validation: OK"
sudo systemctl restart ssh
sudo ss -tulpn | grep ssh
```

Expected result:

```text
LISTEN ... :2222 ... sshd
```
