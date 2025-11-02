#Node Erendis
nano /etc/bind/zones/db.k-53.com
#isi config dengan :
$TTL    604800
@       IN      SOA     ns1.k-53.com. root.k-53.com. (
                            5         ; Serial (increment setiap update)
                       604800         ; Refresh
                        86400         ; Retry
                      2419200         ; Expire
                       604800 )       ; Negative Cache TTL

@       IN      NS      ns1.k-53.com.
@       IN      NS      ns2.k-53.com.

ns1         IN  A   10.90.3.2      ; Erendis
ns2         IN  A   10.90.3.3      ; Amdir

palantir    IN  A   10.90.4.3
elros       IN  A   10.90.1.6
pharazon    IN  A   10.90.2.6
elendil     IN  A   10.90.1.3
isildur     IN  A   10.90.1.4
anarion     IN  A   10.90.1.5
galadriel   IN  A   10.90.2.2
celeborn    IN  A   10.90.2.3
oropher     IN  A   10.90.2.4

www         IN  CNAME   k-53.com.

@    IN  TXT   "Cincin Sauron -> elros.k-53.com"
@    IN  TXT   "Aliansi Terakhir -> pharazon.k-53.com"

#Lalu
nano /etc/bind/zones/db.3.90.10.in-addr.arpa
#isi config dengan :
$TTL    604800
@       IN      SOA     ns1.k-53.com. root.k-53.com. (
                            5
                       604800
                        86400
                      2419200
                       604800 )

@       IN      NS      ns1.k-53.com.
@       IN      NS      ns2.k-53.com.

2   IN  PTR     ns1.k-53.com.
3   IN  PTR     ns2.k-53.com.


#Lalu
named-checkconf
named-checkzone k-53.com /etc/bind/zones/db.k-53.com
named-checkzone 3.90.10.in-addr.arpa /etc/bind/zones/db.3.90.10.in-addr.arpa
service bind9 restart

#Node Amdir
ls /var/lib/bind/ #Pastiin datanya masuk

#Node Erendis
dig @localhost k-53.com
dig @localhost www.k-53.com
dig @localhost TXT cincin-sauron.k-53.com
dig -x 10.90.3.2 @localhost
dig -x 10.90.3.3 @localhost

#Node Amdir
dig @localhost k-53.com
dig @localhost www.k-53.com
dig @localhost TXT aliansi-terakhir.k-53.com
dig -x 10.90.3.3 @localhost

#Node Client (elros misalnya)
echo "nameserver 10.90.3.2" > /etc/resolv.conf
echo "nameserver 10.90.3.3" >> /etc/resolv.conf

nslookup www.k-53.com
dig TXT cincin-sauron.k-53.com
dig TXT aliansi-terakhir.k-53.com
host 10.90.3.2
host 10.90.3.3
