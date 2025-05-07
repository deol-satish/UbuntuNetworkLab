Here’s how you can set up a **2 clients - 1 server - 1 router** network in **VMware** using **Ubuntu VMs** with two internal networks:

---

### **Step 1: Create the VMs**
You will need four VMs:
- **Client 1**
- **Client 2**
- **Router**
- **Server**

Make sure all VMs have Ubuntu installed.

---

### **Step 2: Configure Network Adapters in VMware**
You will create **two internal networks**:
1. **Internal Network 1**: Clients ↔ Router
2. **Internal Network 2**: Router ↔ Server

#### **Router VM (Two Interfaces)**
- **Adapter 1**: Connect to "Internal Network 1" (for communication with clients).
- **Adapter 2**: Connect to "Internal Network 2" (for communication with the server).

#### **Client VMs (One Interface Each)**
- **Adapter 1**: Connect to "Internal Network 1" (to communicate with the router).

#### **Server VM (One Interface)**
- **Adapter 1**: Connect to "Internal Network 2" (to communicate with the router).

---

### **Step 3: Assign Static IPs**
#### **On Router VM**
```sh
# Assign IP for Client Network
sudo ip addr add 192.168.1.1/24 dev eth0

# Assign IP for Server Network
sudo ip addr add 192.168.2.1/24 dev eth1
```

#### **On Client 1**
```sh
sudo ip addr add 192.168.1.2/24 dev eth0
sudo ip route add default via 192.168.1.1
```

#### **On Client 2**
```sh
sudo ip addr add 192.168.1.3/24 dev eth0
sudo ip route add default via 192.168.1.1
```

#### **On Server**
```sh
sudo ip addr add 192.168.2.2/24 dev eth0
sudo ip route add default via 192.168.2.1
```

---

### **Step 4: Enable IP Forwarding on the Router**
```sh
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
```
Make it persistent by editing:
```sh
sudo nano /etc/sysctl.conf
```
Uncomment or add:
```
net.ipv4.ip_forward=1
```
Apply changes:
```sh
sudo sysctl -p
```

---

### **Step 5: Configure NAT (If Needed)**
To allow internet access for clients via the router:
```sh
sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
```

---

### **Step 6: Test the Network**
1. **From Clients, test connectivity to the Router**:
   ```sh
   ping 192.168.1.1
   ```

2. **From Clients, test connectivity to the Server**:
   ```sh
   ping 192.168.2.2
   ```

3. **From Server, test connectivity to the Clients**:
   ```sh
   ping 192.168.1.2
   ```

If all pings work, your **2 Clients - 1 Router - 1 Server** network is correctly set up! 🚀