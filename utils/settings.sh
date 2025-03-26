#!/bin/bash

# VMs and router declaration
client1port="3322"
client2port="3323"
routerport="4422"
serverport="4423"

client1_ipaddr="192.168.236.131"
client2_ipaddr="192.168.236.133"
router_ipaddr="192.168.236.130"
server_ipaddr="192.168.236.132"

vmhostaddr="192.168.56.1"
sshkey="id_rsa"
sshkeypath="$HOME/.ssh/id_rsa"


tcp1="prague"
tcp2="cubic"

duration=300

# Create a variable for the directory name
save_dir="./results"