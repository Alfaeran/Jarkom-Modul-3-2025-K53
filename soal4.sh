#Node Erendis
apt-get update && apt-get install bind9 -y
nano /etc/bind/named.conf.local
#isi config dengan :
zone "k-53.com" {
    type master;
    notify yes;
    also-notify { 10.90.3.3; };
    allow-transfer { 10.90.3.3; };
    file "/etc/bind/zones/db.k-53.com";
};

zone "3.90.10.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 10.90.3.3; };
    allow-transfer { 10.90.3.3; };
    file "/etc/bind/zones/db.3.90.10.in-addr.arpa";
}

mkdir -p /etc/bind/zones
nano /etc/bind/zones/db.k-53.com
#isi config dengan :
$TTL    604800
@       IN      SOA     ns1.k-53.com. root.k-53.com. (
                            3         ; Serial (ubah tiap update)
                       604800         ; Refresh
                        86400         ; Retry
                      2419200         ; Expire
                       604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.k-53.com.
@       IN      NS      ns2.k-53.com.

ns1     IN      A       10.90.3.2    ; Erendis (master)
ns2     IN      A       10.90.3.3    ; Amdir (slave)

palantir    IN  A   10.90.4.3
elros       IN  A   10.90.1.6
pharazon    IN  A   10.90.2.6
elendil     IN  A   10.90.1.3
isildur     IN  A   10.90.1.4
anarion     IN  A   10.90.1.5
galadriel   IN  A   10.90.2.2
celeborn    IN  A   10.90.2.3
oropher     IN  A   10.90.2.4

#Lalu
nano /etc/bind/zones/db.3.90.10.in-addr.arpa
#isi config dengan :
$TTL    604800
@       IN      SOA     ns1.k-53.com. root.k-53.com. (
                            3
                       604800
                        86400
                      2419200
                       604800 )
;
@       IN      NS      ns1.k-53.com.
@       IN      NS      ns2.k-53.com.
2       IN      PTR     ns1.k-53.com.
3       IN      PTR     ns2.k-53.com.

#Lalu
named-checkconf
named-checkzone k-53.com /etc/bind/zones/db.k-53.com
named-checkzone 3.90.10.in-addr.arpa /etc/bind/zones/db.3.90.10.in-addr.arpa
service bind9 restart

#Node Amdir
apt-get update
apt-get install bind9 -y
nano /etc/bind/named.conf.local
#isi config dengan :
zone "k-53.com" {
    type slave;
    masters { 10.90.3.2; };
    file "/var/lib/bind/db.k-53.com";
};

zone "3.90.10.in-addr.arpa" {
    type slave;
    masters { 10.90.3.2; };
    file "/var/lib/bind/db.3.90.10.in-addr.arpa";
};

#Lalu
nano /etc/bind/named.conf.options
#isi config dengan :
options {
    directory "/var/cache/bind";
    allow-query { 10.90.0.0/16; localhost; };
    auth-nxdomain no;
    listen-on-v6 { none; };
    listen-on { any; };
    recursion yes;
    dnssec-validation auto;
};

#Lalu
named-checkconf
service bind9 restart

#Cek
ls /var/lib/bind/

#Node lain
echo "nameserver 10.90.3.2" > /etc/resolv.conf
echo "nameserver 10.90.3.3" >> /etc/resolv.conf

nslookup elros.k-53.com
dig @10.90.3.2 k-53.com
dig @10.90.3.3 k-53.com