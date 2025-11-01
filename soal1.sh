#config nodes

#Durin
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.90.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.90.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.90.3.1
    netmask 255.255.255.0

auto eth4
iface eth4 inet static
    address 10.90.4.1
    netmask 255.255.255.0

auto eth5
iface eth5 inet static
    address 10.90.5.1
    netmask 255.255.255.0

post-up sysctl -w net.ipv4.ip_forward=1
post-up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
post-up echo "nameserver 192.168.122.1" > /etc/resolv.conf

service networking restart
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth3 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth4 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth4 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth5 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i eth5 -o eth0 -j ACCEPT

#Elandil
auto eth0
iface eth0 inet static
    address 10.90.1.3
    netmask 255.255.255.0
    gateway 10.90.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Isildur
auto eth0
iface eth0 inet static
    address 10.90.1.3
    netmask 255.255.255.0
    gateway 10.90.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Anarion
auto eth0
iface eth0 inet static
    address 10.90.1.4
    netmask 255.255.255.0
    gateway 10.90.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Miriel
auto eth0
iface eth0 inet static
    address 10.90.1.5
    netmask 255.255.255.0
    gateway 10.90.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Amandil
auto eth0
iface eth0 inet dhcp

#Elros
auto eth0
iface eth0 inet static
    address 10.90.1.6
    netmask 255.255.255.0
    gateway 10.90.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Galadriel
auto eth0
iface eth0 inet static
    address 10.90.2.2
    netmask 255.255.255.0
    gateway 10.90.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Celeborn
auto eth0
iface eth0 inet static
    address 10.90.2.3
    netmask 255.255.255.0
    gateway 10.90.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Oropher
auto eth0
iface eth0 inet static
    address 10.90.2.4
    netmask 255.255.255.0
    gateway 10.90.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Gilgalad
auto eth0
iface eth0 inet dhcp

#Celebrimbor
auto eth0
iface eth0 inet static
    address 10.90.2.5
    netmask 255.255.255.0
    gateway 10.90.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Pharazon
auto eth0
iface eth0 inet static
    address 10.90.2.6
    netmask 255.255.255.0
    gateway 10.90.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Khamul
auto eth0
iface eth0 inet dhcp

#Erendis
auto eth0
iface eth0 inet static
    address 10.90.3.2
    netmask 255.255.255.0
    gateway 10.90.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Amdir
auto eth0
iface eth0 inet static
    address 10.90.3.3
    netmask 255.255.255.0
    gateway 10.90.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Aldarion
auto eth0
iface eth0 inet static
    address 10.90.4.2
    netmask 255.255.255.0
    gateway 10.90.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Palantir
auto eth0
iface eth0 inet static
    address 10.90.4.3
    netmask 255.255.255.0
    gateway 10.90.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Narvi
auto eth0
iface eth0 inet static
    address 10.90.4.4
    netmask 255.255.255.0
    gateway 10.90.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

#Minastir
auto eth0
iface eth0 inet static
    address 10.90.5.2
    netmask 255.255.255.0
    gateway 10.90.5.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
