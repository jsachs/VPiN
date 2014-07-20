#!/bin/bash

# default variable declarations
SERVER_NAME="server"
CLIENT_NAME="client1"  # support for multiple clients later TODO
CLIENT_KEY=$CLIENT_NAME+".key"
CLIENT_ENCRYPTED_KEY=$CLIENT_NAME+".3des.key"

# ask for non-default variable names

echo "Please enter your static IP: "
read input_variable
STATIC_IP=$input_variable
echo "Please enter you public IP: "
read input_variable
PUBLIC_IP=$input_variable

# set up the script to run as super user
sudo passwd

# ensure the Pi is up to date
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade

# record the IP address with `ifconfig eth0`

# install Open VPN on the Pi
sudo apt-get install openvpn

# setup easy-rsa
sudo -s
cp –r /usr/share/doc/openvpn/examples/easy-rsa/2.0 /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa
sed -i 's/`pwd`/\/etc\/openvpn\/easy-rsa' vars

# generate keys
source vars
./clean-all
./build-ca
# Country Name (2 letters)
# State or Province
# Locality (city)
# Organization
# Organizational unit
# Common Name (hostname)
# Name
# Email Address
./build-key-server $SERVER_NAME
# Country Name (2 letters)
# State or Province
# Locality (city)
# Organization
# Organizational unit
# Common Name (hostname) <servername>
# Name
# Email Address
# Challenge Password (blank)
# Optional company name (blank)

# generate client keys
./build-key-pass $CLIENT_NAME
# Enter the PEM passphrase
# Veryfy PEM
# Country Name (2 letters)
# State or Province
# Locality (city)
# Organization
# Organizational unit
# Common Name (hostname) Client1
# Name
# Email Address
# Challenge Password (blank)
# Optional company name (blank)

cd keys
openssl rsa -in $CLIENT_KEY -des3 -out $CLIENT_ENCRYPTED_KEY
# Enter pass phrase
# Enter PEM pass phrase
# Verify PEM

# generate diffie-hellman key exchange
cd ..
./build-dh
# Generate HMAC key (DoS)
openvpn –-genkey –-secret keys/ta.key
# I WAS HERE
# place config file at /etc/openvpn/server.conf
# get IP address with `hostname -I`
# allow packet forwarding in /etc/sysctl.conf, then apply changes
sed -i '' 's/^#net/net/g' /etc/sysctl.conf
sysctl -p

# open a hole in the firewall at /etc/firewall-openvpn-rules.sh
chmod 700 /etc/firewall-openvpn-rules.sh
chown root /etc/firewall-openvpn-rules.sh

sed '3 a \tpre-up \/etc\/firewall-openvpn-rules.sh' /etc/network/interfaces

# Changes:
# iface eth0 inet dhcp
#      pre-up /etc/firewall-openvpn-rules.sh
sudo reboot


# ---------- Script 2 -----------


mv MakeOpenVPN.sh /etc/openvpn/easy-rsa/keys/

# clone the gist
cd /etc/openvpn/easy-rsa/keys/
chmod 700 MakeOpenVPN.sh
./MakeOpenVPN.sh

# connect with Fugu to download the openvpn file
# retrieve the following:
# - ca.key Root CA key
# - client1.key
# - client1.3des.key
# - client1.ovpn
