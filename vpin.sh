#!/bin/bash

# default variable declarations
SERVER_NAME="server"
CLIENT_NAME="client1"  # support for multiple clients later TODO
CLIENT_KEY=$CLIENT_NAME+".key"
CLIENT_ENCRYPTED_KEY=$CLIENT_NAME+".3des.key"

HOME_DIR=`pwd`

# ask for non-default variable names
#echo "Please enter your static IP: "
#read input_variable
#STATIC_IP=$input_variable
echo "Please enter you public IP: "
read input_variable
PUBLIC_IP=$input_variable

sed -i "s/remote/remote\ $PUBLIC_IP\ 1194/" Default.txt

# ensure the Pi is up to date
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade

# install Open VPN on the Pi
sudo apt-get install openvpn

# setup easy-rsa
sudo -s
cp –r /usr/share/doc/openvpn/examples/easy-rsa/2.0 /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa
sed -i 's/`pwd`/\/etc\/openvpn\/easy-rsa/' vars

# generate keys
source vars
./clean-all
./build-ca
# Common Name (hostname) server

./build-key-server $SERVER_NAME
# Common Name (hostname) server
# Challenge Password (blank)
# Optional company name (blank)

# generate client keys
./build-key-pass $CLIENT_NAME
# Enter the PEM passphrase
# Veryfy PEM
# Common Name (hostname) client1
# Challenge Password (blank)
# Optional company name (blank)

cd keys
openssl rsa -in $CLIENT_KEY -des3 -out $CLIENT_ENCRYPTED_KEY
# Enter pass phrase
# Enter PEM pass phrase
# Verify PEM

# generate diffie-hellman key exchange
cd /etc/openvpn/easy-rsa
./build-dh
# Generate HMAC key (DoS)
openvpn –-genkey –-secret keys/ta.key

# place config file at /etc/openvpn/server.conf
cp $HOME_DIR/server.conf /etc/openvpn/

# get IP address with `hostname -I`
# allow packet forwarding in /etc/sysctl.conf, then apply changes
sed -ri '28 s/^#//' /etc/sysctl.conf
sysctl -p

# create the firewall script
cp $HOME_DIR/firewall-openvpn-rules.sh /etc/

# open a hole in the firewall at /etc/firewall-openvpn-rules.sh
chmod 700 /etc/firewall-openvpn-rules.sh
chown root /etc/firewall-openvpn-rules.sh

sed -i '4 a pre-up \/etc\/firewall-openvpn-rules.sh' /etc/network/interfaces
sed -ri '5 s/^/\t/' /etc/network/interfaces

# Changes:
# iface eth0 inet dhcp
#      pre-up /etc/firewall-openvpn-rules.sh
sudo reboot
