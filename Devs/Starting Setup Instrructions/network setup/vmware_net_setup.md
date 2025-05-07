To set up a **client-server-router** network in **VirtualBox** using Ubuntu VMs, follow these steps:

---

### **Step 1: Create Virtual Machines**
1. **Create Three Ubuntu VMs**:
   - **Client** (Ubuntu)
   - **Router** (Ubuntu)
   - **Server** (Ubuntu)

2. **Configure Network Interfaces**:
   - The **Client** and **Router** will be connected via **Network 1**.
   - The **Router** and **Server** will be connected via **Network 2**.

---

### **Step 2: Configure Network Interfaces in VirtualBox**
In VirtualBox:
1. **Client VM (Ubuntu)**
   - **Adapter 1**: Attached to **"Internal Network"** (Name: `intneta`)
   
2. **Router VM (Ubuntu)**
   - **Adapter 1**: Attached to **"Internal Network"** (Name: `intneta`)
   - **Adapter 2**: Attached to **"Internal Network"** (Name: `intnetb`)

3. **Server VM (Ubuntu)**
   - **Adapter 1**: Attached to **"Internal Network"** (Name: `intnetb`)

---

### **Step 3: Configure Network on Ubuntu VMs**
#### **Router VM**
Enable IP forwarding:
```bash
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

Assign static IPs:
```bash
sudo ip addr add 192.168.1.1/24 dev ens37  # Interface to Client 1
sudo ip addr add 192.168.2.1/24 dev ens38  # Interface to Client 2
sudo ip addr add 192.168.3.1/24 dev ens39 # Interface to Server

sudo ip addr add 192.168.1.1/24 dev ens37 
sudo ip addr add 192.168.2.1/24 dev ens38 
sudo ip addr add 192.168.3.1/24 dev ens39
```

Set up NAT (for packet forwarding):
```bash
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
```

#### **Client 1 VM**
Assign a static IP and set the Router as the gateway:
```bash
sudo ip addr add 192.168.1.2/24 dev ens37
sudo ip route add default via 192.168.1.1
```

#### **Client 2 VM**
Assign a static IP and set the Router as the gateway:
```bash
sudo ip addr add 192.168.2.2/24 dev ens37
sudo ip route add default via 192.168.2.1
```

#### **Server VM**
Assign a static IP:
```bash
sudo ip addr add 192.168.3.2/24 dev ens37
```

Add a route back to the Client:
```bash
sudo ip route add 192.168.1.0/24 via 192.168.3.1
sudo ip route add 192.168.2.0/24 via 192.168.3.1
```

sudo ip addr add 192.168.3.2/24 dev ens37
sudo ip route add 192.168.1.0/24 via 192.168.3.1
sudo ip route add 192.168.2.0/24 via 192.168.3.1
---

### **Step 4: Test the Setup**
1. **Ping Router from Client**:
   ```bash
   ping 192.168.1.1
   ```
2. **Ping Router from Server**:
   ```bash
   ping 192.168.2.1
   ```
3. **Ping Server from Client (via Router)**:
   ```bash
   ping 192.168.2.2
   ```

---

### **Step 5: Set Up a Simple Server**
On the **Server VM**, run:
```bash
sudo apt install apache2 -y
```
Check if it's running:
```bash
sudo systemctl status apache2
```
On the **Client VM**, test:
```bash
curl http://192.168.2.2
```

---

That’s it! You now have a **Client-Server-Router** setup in VirtualBox with Ubuntu VMs. 🚀




#### Using `rc.local` (Older method, not recommended for newer versions)
If you're using an older Ubuntu version or prefer a simpler solution, you can add your custom routes to the `/etc/rc.local` file, which runs at the end of the boot process.

1. Open `/etc/rc.local` in a text editor:

   ```bash
   sudo nano /etc/rc.local
   ```

2. Add your custom route commands before `exit 0`:

   ```bash
   ip route add 10.1.1.0/24 via 192.168.1.1
   ```

3. Save the file and make it executable:

   ```bash
   sudo chmod +x /etc/rc.local
   ```

### 3. **Verify Persistence**
After setting your static IP and routes, you can verify that they are applied correctly by restarting your network service or rebooting the machine:

```bash
sudo systemctl restart network-manager   # For NetworkManager
sudo netplan apply                      # For Netplan
```

Check if the settings persist after a reboot:

```bash
ip addr show
ip route show
```

These steps should ensure that your IP settings and routes are kept persistent across system reboots in Ubuntu.