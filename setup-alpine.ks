# Use US layout with US variant
KEYMAPOPTS="us us"

# Set hostname to alpine-test
HOSTNAMEOPTS="-n alpine-test"

# Contents of /etc/network/interfaces
INTERFACESOPTS="auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
    hostname alpine-test
"

# Search domain of example.com, Google public nameserver
#DNSOPTS="-d example.com 8.8.8.8"

# Set timezone to UTC
TIMEZONEOPTS="-z Europe/Paris"

# set http/ftp proxy
PROXYOPTS="none"

# Add a random mirror
APKREPOSOPTS="-f"

# Install Openssh
SSHDOPTS="-c openssh"

# Use openntpd
NTPOPTS="-c openntpd"

# Use /dev/sda as a data disk
#DISKOPTS="-m data /dev/sda"
DISKOPTS="-m sys -L -v /dev/vda"
SWAP_SIZE="1024"
