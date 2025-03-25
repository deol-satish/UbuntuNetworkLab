#!/bin/bash

# Set basic configuration values
set -x

# Source the settings file
if [ ! -f ./utils/settings.sh ]; then
    echo "Error: settings.sh file not found"
    exit 1
fi

source ./utils/settings.sh

# Check if variables are set
if [[ -z "$routerport" || -z "$sshkeypath" || -z "$vmhostaddr" ]]; then
    echo "Error: One or more required variables are not set."
    exit 1
fi

Commands to enable IP forwarding, configure interfaces, and set up NAT
# router_setup_commands="
# echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf;
# sudo sysctl -p;
# sudo ip addr add 192.168.1.1/24 dev enp0s8;
# sudo ip addr add 192.168.2.1/24 dev enp0s9;
# sudo ip addr add 192.168.3.1/24 dev enp0s10;
# sudo iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE;
# "

# client1_setup_commands="
# sudo ip addr add 192.168.1.2/24 dev enp0s8;
# sudo ip route add default via 192.168.1.1;
# "

# client2_setup_commands="
# sudo ip addr add 192.168.2.2/24 dev enp0s8;
# sudo ip route add default via 192.168.2.1;
# "


# server_setup_commands="
# sudo ip addr add 192.168.3.2/24 dev enp0s8;
# sudo ip route add 192.168.1.0/24 via 192.168.3.1;
# sudo ip route add 192.168.2.0/24 via 192.168.3.1;
# "



# Execute the commands remotely via SSH
ssh -p "$routerport" root@"$vmhostaddr" "$router_setup_commands"
ssh -p "$client1port" root@"$vmhostaddr" "$client1_setup_commands"
# ssh -p "$client2port" root@"$vmhostaddr" "$client2_setup_commands"
ssh -p "$serverport" root@"$vmhostaddr" "$server_setup_commands"


# ssh -p "$routerport" root@"$vmhostaddr" "$router_setup_commands" & 
# ssh -p "$client1port" root@"$vmhostaddr" "$client1_setup_commands" & 
# ssh -p "$client2port" root@"$vmhostaddr" "$client2_setup_commands" & 
# ssh -p "$serverport" root@"$vmhostaddr" "$server_setup_commands" &
# wait


# ssh -p 3323 root@192.168.56.1 "sudo ip addr add 192.168.2.2/24 dev enp0s8;
# sudo ip route add default via 192.168.2.1;" 

# ssh -p 3322 root@192.168.56.1 "sudo ip addr add 192.168.1.2/24 dev enp0s8;
# sudo ip route add default via 192.168.1.1;" 

# ssh -p 4423 root@192.168.56.1 "sudo ip addr add 192.168.3.2/24 dev enp0s8;
# sudo ip route add 192.168.1.0/24 via 192.168.3.1;
# sudo ip route add 192.168.2.0/24 via 192.168.3.1;" 





# If successful
echo "Test complete"
exit 0

# Error handler
out() {
    echo "Abort test"
    exit 1
}
