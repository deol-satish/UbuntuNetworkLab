To set up **remote login (SSH) from a Windows host to your Ubuntu VMs** in VirtualBox with automatic login (passwordless access), follow these steps:

---

## **Step 1: Enable SSH on Ubuntu VMs**
On each Ubuntu VM (Client, Router, Server):

1. **Install OpenSSH Server**:
   ```bash
   sudo apt update
   sudo apt install -y openssh-server
   ```
2. **Enable and Start SSH**:
   ```bash
   sudo systemctl enable ssh
   sudo systemctl start ssh
   ```

3. **Check if SSH is Running**:
   ```bash
   sudo systemctl status ssh
   ```

4. **Find the VM’s IP Address**:
   ```bash
   ip a
   ```
   - Note the IP address assigned to the internal network (e.g., `192.168.1.2` for Client VM, `192.168.2.2` for Server VM).

---

## **Step 2: Configure Port Forwarding in VirtualBox (Optional for NAT)**
If your VM network is **NAT**, set up **port forwarding**:
1. Open **VirtualBox → Select VM → Settings → Network → Adapter 1**.
2. Click **Advanced → Port Forwarding**.
3. Add a new rule:
   - **Name**: SSH
   - **Protocol**: TCP
   - **Host IP**: 127.0.0.1
   - **Host Port**: 2222 (or any unused port)
   - **Guest IP**: (Leave empty)
   - **Guest Port**: 22

Now, SSH from Windows using:
```powershell
ssh username@127.0.0.1 -p 3322
```
*(Replace `username` with your Ubuntu username.)*

---

## **Step 3: Set Up Automatic SSH Login (Passwordless Access)**
On your **Windows Host**:

1. **Generate an SSH Key** (if not already created):
   - Open **PowerShell** and run:
     ```powershell
     ssh-keygen -t rsa -b 4096
     ```
   - Press **Enter** to accept the default location (`C:\Users\YourUser\.ssh\id_rsa`).
   - If prompted for a passphrase, just press **Enter** (for automatic login).

2. **Copy the Public Key to Ubuntu VM**:
   - Use **SCP** or **SSH** to transfer the key to the Ubuntu VM:
     ```powershell
     ssh-copy-id username@192.168.1.2
     ```
   - If `ssh-copy-id` is unavailable, manually copy the key:
     ```powershell
     type $env:USERPROFILE\.ssh\id_rsa.pub | ssh username@192.168.1.2 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
     ```
   - Make sure correct permissions are set:
     ```bash
     chmod 600 ~/.ssh/authorized_keys
     chmod 700 ~/.ssh
     ```

---

## **Step 4: Automate SSH Login with a Windows Batch Script**
Create a **batch script** (`auto-login.bat`) to connect automatically:
```batch
@echo off
ssh username@192.168.1.2
```
Save and double-click to run.

Alternatively, use **PowerShell**:
```powershell
Start-Process "ssh" -ArgumentList "username@192.168.1.2"
```

---

### **Now, you can SSH from Windows to Ubuntu without entering a password! 🚀**
Would you like to configure X11 forwarding or a GUI remote desktop (RDP/VNC)?