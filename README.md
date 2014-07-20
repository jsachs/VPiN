#VPiN

##Setup requirements
1. Install [Raspbian](http://www.raspberrypi.org/downloads/) on your Pi
2. Enable SSH
3. Configure a static IP address on your Pi (for this setup, I assume 192.168.200.200)
4. Forward UDP traffic on port 1194.
Instructions for steps 2-4 can be found [here](http://readwrite.com/2014/04/09/raspberry-pi-projects-ssh-remote-desktop-static-ip-tutorial)

TODO move this all to a wiki

##Prep work
- Configure your hostname to "server"
- Choose a PEM passphrase
- DO NOT enter challenge phrases
- Determine your external IP address ([whatismyip.com](whatismyip.com) or a similar service)

##Instructions:
1. Clone the repository: `git clone https://github.com/jsachs/VPiN.git`
2. Within the VPiN directory, run the following: `./vpin.sh` This will configure the OpenVPN server.
3. Within the VPiN directory, run the following: `./client.sh` This will prepare the client keys for a VPN connection.

##Acknowledgements
The inspiration for this automated setup comes from the [paper by Eric Jodoin](http://www.sans.org/reading-room/whitepapers/hsoffice/soho-remote-access-vpn-easy-pie-raspberry-pi-34427),
and the [subsequent work on ease of setup done by Lauren Orsini](http://readwrite.com/2014/04/10/raspberry-pi-vpn-tutorial-server-secure-web-browsing).
This is an attempt to further automate the excellent steps and documentation previously put forth.
