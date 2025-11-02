#Aldarion
apt update && apt install -y isc-dhcp-server
echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

nano /etc/dhcp/dhcpd.conf
#configuration dhcpd.conf

subnet 10.90.4.0 netmask 255.255.255.0 {
  option routers 10.90.4.1;
  option broadcast-address 10.90.4.255;
  option domain-name-servers 10.90.3.3;
}

# Client Dinamis Keluarga Manusia
subnet 10.90.1.0 netmask 255.255.255.0 {
  range 10.90.1.6 10.90.1.34;
  range 10.90.1.68 10.90.1.94;
  option routers 10.90.1.1;
  option broadcast-address 10.90.1.255;
  option domain-name-servers 10.90.3.3;
  default-lease-time 1800;
  max-lease-time 3600;
}

# Client Dinamis Keluarga Peri
subnet 10.90.2.0 netmask 255.255.255.0 {
  range 10.90.2.35 10.90.2.67;
  range 10.90.2.96 10.90.2.121;
  option routers 10.90.2.1;
  option broadcast-address 10.90.2.255;
  option domain-name-servers 10.90.3.3;
  default-lease-time 600;
  max-lease-time 3600;
}

# Fixed Address
subnet 10.90.3.0 netmask 255.255.255.0 {
  option routers 10.90.3.1;
  option broadcast-address 10.90.3.255;
  option domain-name-servers 10.90.3.3;
}

# Khamul yang Misterius (IP Statis)
host Khamul {
  hardware ethernet 02:42:50:5e:30:00;
  fixed-address 10.90.3.95;
}

systemctl restart isc-dhcp-server

#Node Durin
apt update && apt install -y isc-dhcp-relay
echo 'SERVERS="10.90.4.2"' > /etc/default/isc-dhcp-relay
echo 'INTERFACES="eth1 eth2 eth3 eth4"' >> /etc/default/isc-dhcp-relay
echo 'OPTIONS=""' >> /etc/default/isc-dhcp-relay

sysctl -p 
service isc-dhcp-relay restart|

#Node Gilgalad
ip a

#Node Amandil
ip a

#Node khamul
ip a