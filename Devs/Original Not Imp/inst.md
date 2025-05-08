# Guide: Modifying and Compiling the `sch_dualpi2.c` Kernel Module

This guide outlines the steps to modify the `net/sched/sch_dualpi2.c` file, part of the Linux kernel's networking subsystem, and recompile it.

**❗ Important Disclaimer:** Modifying kernel code can be risky. Errors can lead to system instability, panics, or data loss. Always back up important data before proceeding. It's recommended to test kernel changes in a virtual machine or a dedicated test environment first.

## Prerequisites

1.  **Linux System:** You'll need a Linux system to perform these operations.
2.  **Kernel Source Code:** You need the source code for the kernel you intend to modify.
    * **For the currently running kernel:** It's crucial to get the exact source version.
    * **For a new kernel version:** Download the desired version from [kernel.org](https://www.kernel.org/).
3.  **Build Tools:** Essential tools for kernel compilation. On Debian/Ubuntu-based systems, you can install them with:
    ```bash
    sudo apt update
    sudo apt install build-essential libncurses-dev bison flex libssl-dev libelf-dev bc rsync
    ```
    Package names may vary for other distributions (e.g., `kernel-devel` on Fedora/RHEL based systems).
4.  **Sufficient Disk Space:** Kernel sources and compilation can take up several gigabytes.
5.  **Root Privileges:** Needed for installing the new kernel/module.

## Step 1: Obtain and Prepare Kernel Sources

1.  **Identify Your Kernel Version (if modifying the running kernel):**
    ```bash
    uname -r
    ```
    This will output something like `5.15.0-custom`.

2.  **Get the Kernel Sources:**
    * **Matching Running Kernel (Recommended for module changes):**
        * Some distributions provide packages for their kernel sources (e.g., `linux-source` on Debian/Ubuntu).
            ```bash
            sudo apt install linux-source-$(uname -r)
            cd /usr/src/
            sudo tar -xjf linux-source-$(uname -r | cut -d'-' -f1,2).tar.bz2 # Adjust filename as needed
            cd linux-source-$(uname -r | cut -d'-' -f1,2)
            ```
        * Alternatively, download the exact version from [kernel.org](https://www.kernel.org/) and extract it.
    * **For a Specific Version (e.g., if building a new kernel):**
        Download the tarball from [kernel.org](https://www.kernel.org/), extract it, and `cd` into the source directory.
        ```bash
        wget [https://cdn.kernel.org/pub/linux/kernel/vX.x/linux-X.Y.Z.tar.xz](https://cdn.kernel.org/pub/linux/kernel/vX.x/linux-X.Y.Z.tar.xz) # Replace X.Y.Z
        tar -xf linux-X.Y.Z.tar.xz
        cd linux-X.Y.Z
        ```

3.  **Prepare the Source Tree:**
    * Copy your current kernel configuration (if building for the running kernel and sources are fresh):
        ```bash
        cp /boot/config-$(uname -r) .config
        ```
    * Ensure the configuration is up-to-date and prepare the build scripts:
        ```bash
        make olddefconfig # Or 'make menuconfig' to review options
        make prepare
        make scripts
        ```

## Step 2: Check Kernel Configuration for `sch_dualpi2`

The `sch_dualpi2` module is controlled by a Kconfig option. You need to know if it's configured to be built as a module (`m`) or built directly into the kernel (`y`).

1.  **Check `.config` file:**
    Open the `.config` file in the root of the kernel source tree and search for `CONFIG_NET_SCH_DUALPI2`:
    ```bash
    grep CONFIG_NET_SCH_DUALPI2 .config
    ```
    * If you see `CONFIG_NET_SCH_DUALPI2=m`, it's built as a loadable module. This is the easier case for recompilation.
    * If you see `CONFIG_NET_SCH_DUALPI2=y`, it's built into the kernel. You'll need to recompile the entire kernel.
    * If it's commented out (`# CONFIG_NET_SCH_DUALPI2 is not set`) or missing, you'll need to enable it using `make menuconfig` (under Networking options -> Networking support -> Traffic Control -> DualPI2 scheduler), save the configuration, and then proceed.

## Step 3: Modify `net/sched/sch_dualpi2.c`

1.  Navigate to the file:
    ```bash
    cd net/sched/
    ```
    (Assuming you are in the root of the kernel source tree).
2.  Open `sch_dualpi2.c` with your preferred text editor (e.g., `vim`, `nano`, `gedit`):
    ```bash
    nano sch_dualpi2.c
    ```
3.  Make your desired code changes and save the file.

## Step 4: Compile the Module/Kernel

The compilation process depends on how `CONFIG_NET_SCH_DUALPI2` is set.

### Case A: `CONFIG_NET_SCH_DUALPI2=m` (Compiled as a Module)

This is the most straightforward scenario for modifying an existing module.

1.  Navigate to the root of the kernel source tree.
2.  Compile the `net/sched` directory or the specific module:
    ```bash
    # To rebuild all modules in net/sched:
    make M=net/sched
    # Or, to attempt to build just the sch_dualpi2 module (if supported by Makefiles):
    # make net/sched/sch_dualpi2.ko
    ```
    The compiled module `sch_dualpi2.ko` will be located in the `net/sched/` directory within your source tree.

### Case B: `CONFIG_NET_SCH_DUALPI2=y` (Built into the Kernel)

If the module is built into the kernel, you must recompile the entire kernel.

1.  Navigate to the root of the kernel source tree.
2.  Compile the kernel. This can take a significant amount of time. Replace `$(nproc)` with the number of CPU cores you want to use for compilation (e.g., `4` for 4 cores).
    ```bash
    make -j$(nproc)
    ```
3.  If the compilation is successful, you need to install the new kernel and its modules.
    ```bash
    sudo make modules_install
    sudo make install
    ```
    This will install the new kernel image, System.map, and update your bootloader (e.g., GRUB).

4.  **Reboot your system** to use the new kernel with your changes.
    ```bash
    sudo reboot
    ```

## Step 5: Install and Test the Modified Module (Only for Case A)

If you recompiled `sch_dualpi2` as a module (`.ko` file):

1.  **Backup the existing module (optional but recommended):**
    ```bash
    sudo cp /lib/modules/$(uname -r)/kernel/net/sched/sch_dualpi2.ko /lib/modules/$(uname -r)/kernel/net/sched/sch_dualpi2.ko.bak
    ```
2.  **Copy your newly compiled module** to the system's module directory. (Ensure `$(uname -r)` matches the kernel version you compiled against).
    ```bash
    sudo cp net/sched/sch_dualpi2.ko /lib/modules/$(uname -r)/kernel/net/sched/
    ```
    (The source path `net/sched/sch_dualpi2.ko` is relative to the root of your kernel build directory).

3.  **Update module dependencies:**
    ```bash
    sudo depmod -a
    ```
4.  **Unload the currently loaded module (if it's in use):**
    ```bash
    sudo modprobe -r sch_dualpi2
    ```
    If it's in use by an active qdisc, you might need to remove that qdisc first using the `tc` command.

5.  **Load your new module:**
    ```bash
    sudo modprobe sch_dualpi2
    ```
6.  **Check for errors:**
    ```bash
    dmesg | tail
    ```
    Look for any messages related to `sch_dualpi2` loading or any errors.

7.  **Test its functionality:**
    Use the `tc` (traffic control) utility to add the `dualpi2` qdisc to a network interface and verify its behavior according to your changes.
    Example:
    ```bash
    # Replace <interface> with your network interface (e.g., eth0, enp3s0)
    sudo tc qdisc add dev <interface> root dualpi2
    sudo tc qdisc show dev <interface>
    # ... further tests specific to your modifications ...
    sudo tc qdisc del dev <interface> root
    ```

## Step 6: Reverting Changes

* **If compiled as a module (Case A):**
    * If you backed up the original module:
        ```bash
        sudo cp /lib/modules/$(uname -r)/kernel/net/sched/sch_dualpi2.ko.bak /lib/modules/$(uname -r)/kernel/net/sched/sch_dualpi2.ko
        sudo depmod -a
        sudo modprobe -r sch_dualpi2
        sudo modprobe sch_dualpi2
        ```
    * Alternatively, rebuild the module from the original (unmodified) source code.
* **If compiled into the kernel (Case B):**
    * You'll need to revert your code changes in `sch_dualpi2.c`, recompile the kernel (`make -j$(nproc)`), reinstall it (`sudo make modules_install && sudo make install`), and reboot.
    * Alternatively, if your bootloader (GRUB) keeps older kernel versions, you can select a previous, working kernel at boot time.

## Further Resources

* **Linux Kernel Documentation:** The `Documentation` directory in the kernel source tree is an invaluable resource.
* **Kernel Newbies:** [https://kernelnewbies.org/](https://kernelnewbies.org/)
* **Linux Kernel Development (Book by Robert Love):** A good resource for understanding kernel development.

This guide provides a general workflow. Specifics might vary slightly depending on your Linux distribution and kernel version. Always be careful and test thoroughly.


