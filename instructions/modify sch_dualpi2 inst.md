To modify `sch_dualpi2.c` and rebuild it so your custom changes (like adding `pr_info()` statements) appear in the running kernel, follow these **steps for editing and compiling an out-of-tree kernel module**, assuming you're using the L4S testing kernel from `L4STeam`.

---

### ✅ **Step-by-Step Guide to Modify and Rebuild `sch_dualpi2.c`**

---

#### **1. Prerequisites**

Ensure you have the following installed:

```bash
sudo apt install build-essential linux-headers-$(uname -r)
```

---

#### **2. Create a Working Directory**

Create a custom module directory (say `dualpi2-custom`) and copy the original source:

```bash
mkdir ~/dualpi2-custom
cd ~/dualpi2-custom
wget https://raw.githubusercontent.com/L4STeam/linux/testing/net/sched/sch_dualpi2.c
```

---

#### **3. Create a Minimal `Makefile`**

Here’s a simple Makefile to build `sch_dualpi2.c` as an out-of-tree module:

```makefile
obj-m += sch_dualpi2.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
```

---

#### **4. Modify `sch_dualpi2.c`**

Insert a `pr_info()` or `printk()` in any function to test changes:

```c
#include <linux/module.h>  // Required for all kernel modules
#include <linux/kernel.h>  // Needed for KERN_INFO

// Inside e.g., dualpi2_enqueue()
pr_info("Custom DualPI2 Enqueue: packet length = %u\n", skb->len);
```

---

#### **5. Build the Module**

```bash
make
```

After successful compilation, you'll get `sch_dualpi2.ko`.

---

#### **6. Unload Old Module and Load the Custom One**

First, remove the old module (if loaded):

```bash
sudo modprobe -r sch_dualpi2
```

Then load your custom one:

```bash
sudo insmod sch_dualpi2.ko
```

---

#### **7. Check Kernel Log for Output**

Use `dmesg` to verify your `pr_info()` or `printk()` output:

```bash
dmesg | tail -n 50
```

---

### 🔄 Optional: Permanently Replace Kernel Module (Not Usually Needed)

If you want the system to load your custom module automatically:

```bash
sudo cp sch_dualpi2.ko /lib/modules/$(uname -r)/kernel/net/sched/sch_dualpi2.ko
sudo depmod -a
sudo modprobe sch_dualpi2
```

> ⚠️ This **overwrites** the original module in `/lib/modules`. Be cautious and keep a backup.

---

Would you like a ready-made `dualpi2-custom` folder with a Makefile and sample changes zipped for you to download?
