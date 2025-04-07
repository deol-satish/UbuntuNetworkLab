#!/bin/bash

# VMs and router declaration
client1port="3322"
client2port="3323"
routerport="4422"
serverport="4423"

client1_ipaddr="192.168.11.134"
client2_ipaddr="192.168.11.135"
router_ipaddr="192.168.11.133"
server_ipaddr="192.168.11.136"

vmhostaddr="192.168.56.1"
sshkey="id_rsa"
sshkeypath="$HOME/.ssh/id_rsa"


tcp1="prague"
tcp2="cubic"

duration=30
