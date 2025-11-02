#Node Minastir
apt-get update
apt-get install bind9 -y

nano /etc/bind/named.conf.options
#isi config dengan :
options {
    directory "/var/cache/bind";

    recursion yes;
    allow-recursion { 10.90.0.0/16; 127.0.0.1; };

    listen-on { any; };
    listen-on-v6 { none; };

    dnssec-validation auto;

    auth-nxdomain no;

    forwarders {
        1.1.1.1;
        8.8.8.8;
    };

    forward only;
};

#Lalu
service bind9 restart

#Node Lainnya (selain durin dan minastir)
echo "nameserver 10.90.5.2" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf

#Node Minastir
service named status
cat /etc/bind/named.conf.options

netstat-tulnp | grep named
ss -tulnp | grep named

dig google.com
host google.com
nslookup google.com

tail -n 20 /var/log/syslog | grep named

#Node Lainnya (selain durin dan minastir)
cat /etc/resolv.conf

nslookup google.com 10.90.5.2
dig @10.90.5.2 google.com
host google.com 10.90.5.2
ping google.com #CTRL + C to stop

nslookup k53.com 10.90.5.2
dig @10.90.5.2 k53.com