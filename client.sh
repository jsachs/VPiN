#!/bin/bash

sudo -s

cp MakeOpenVPN.sh /etc/openvpn/easy-rsa/keys/
cp Default.txt /etc/openvpn/easy-rsa/keys/

# execute the .opvn creation script
cd /etc/openvpn/easy-rsa/keys/
chmod 700 MakeOpenVPN.sh
./MakeOpenVPN.sh

# connect with Fugu to download the openvpn file
# retrieve the following:
# - ca.key Root CA key
# - client1.key
# - client1.3des.key
# - client1.ovpn
