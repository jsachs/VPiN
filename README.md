README

Setup requirements:
1. Install [Raspbian](http://www.raspberrypi.org/downloads/) on your Pi
2. Enable SSH
3. Configure a static IP address on your Pi.
4. Configure DDNS on your Pi.
5. Forward UDP traffic on port 1194.
Instructions for steps 2-5 can be found [here](http://readwrite.com/2014/04/09/raspberry-pi-projects-ssh-remote-desktop-static-ip-tutorial)

Prep:
- Configure your hostname to "server"
- Choose a PEM passphrase
- DO NOT enter challenge phrases

Instructions:
1. Clone the repository
    git clone
2. Within the VPiN directory, run the following:
    sh ./vpin.sh
