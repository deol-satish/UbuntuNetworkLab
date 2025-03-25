If SSH root access is disabled on your server, it's likely for security reasons. Many systems disable direct root access via SSH to reduce the risk of unauthorized access. Instead, you are often required to log in with a non-root user and then use `sudo` to perform administrative tasks.

To enable SSH root access, you can follow these steps, but note that doing so can expose your system to more security risks, so proceed with caution:

### 1. **Edit the SSH Configuration File:**
   - Open the SSH configuration file using a text editor. For example:
     ```bash
     sudo nano /etc/ssh/sshd_config
     ```

### 2. **Modify the `PermitRootLogin` Directive:**
   - Look for the line that says `PermitRootLogin` and change it to:
     ```bash
     PermitRootLogin yes
     ```
   - If the line is commented out (with a `#` at the beginning), remove the `#` and modify the line.
   
   **Alternatively,** if you prefer to allow root login only with a specific key (which is more secure), you can set:
   ```bash
   PermitRootLogin prohibit-password
   ```

### 3. **Restart the SSH Service:**
   - After saving the file, restart the SSH service to apply the changes:
     ```bash
     sudo systemctl restart sshd
     ```

### 4. **Check for Security:**
   - If you re-enable root login, make sure you are using a strong password or, preferably, SSH key authentication for added security. Consider disabling password authentication completely by setting `PasswordAuthentication no` in the `sshd_config` file.

### **Important Security Considerations:**
   - Enabling root SSH access can be risky, as it could potentially allow attackers to gain full access to your server if they manage to crack the root password.
   - It's highly recommended to use SSH keys instead of passwords for authentication, and if you absolutely need to enable root login, make sure your root password is very strong.
   - Consider disabling root SSH access after performing necessary tasks, or use `sudo` for administrative tasks.

Would you like to know more about securing your SSH server?