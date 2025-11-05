## SOAL 3

Pada Node Minastir,
Jalankan `apt-get update && apt-get install -y bind9 bind9utils bind9-doc dnsutils` untuk menginstal BIND9 beserta utilitas, dokumentasi, dan tool DNS agar server bisa berfungsi sebagai DNS server lengkap.
lalu, jalankan `cp /etc/bind/named.conf.options /etc/bind/named.conf.options.bak`. Perintah tersebut membuat salinan cadangan file konfigurasi `named.conf.options` menjadi `named.conf.options.bak`, sehingga jika konfigurasi yang baru diubah bermasalah, file asli masih bisa dipulihkan dengan mudah

nano /etc/bind/named.conf.options
isi config dengan :
```
options {
    directory "/var/cache/bind";

    forwarders {
        8.8.8.8;
        8.8.4.4;
        1.1.1.1;
    };

    forward only;

    allow-query { 
        10.90.0.0/16;
        localhost;
    };
    listen-on { any; };
    listen-on-v6 { none; };

    dnssec-validation auto;
    auth-nxdomain no;
    recursion yes;
    allow-recursion { 
        10.90.0.0/16;
        localhost;
    };
};
```

service named restart

Pada Node lainnya selain durin dan minastir, isi config /etc/resolv.conf dengan
`nano /etc/resolv.conf` dan isi confignya dengan
```
nameserver 10.90.5.2
nameserver 8.8.8.8
```

Pada Node Minastir, jalankan `service named status`
lalu `netstat -tulpn  grep named` untuk mengecek apakah proses named (BIND9) sedang listen di port tertentu dan `ss -tulpn  grep named` sebagai  alternatif modern untuk melihat socket/proses named yang aktif.

kemudian, jalankan
```
nslookup google.com
dig google.com
host google.com
```
- `nslookup google.com` melakukan query DNS sederhana untuk domain google.com.
- `dig google.com` melakukan query DNS detail untuk google.com dengan informasi lengkap.
- `host google.com` melakukan lookup DNS singkat untuk google.com.

<img width="628" height="827" alt="image" src="https://github.com/user-attachments/assets/6d5236c0-e4bf-460c-9e0c-a96ccbea28b3" />
<img width="446" height="216" alt="image" src="https://github.com/user-attachments/assets/3db43d62-05f6-4e64-b767-49f77c10eebd" />

Pada node lainnya, jalankan
```
nslookup google.com 10.90.5.2
dig @10.90.5.2 google.com
host google.com 10.90.5.2
ping google.com
```
<img width="572" height="852" alt="image" src="https://github.com/user-attachments/assets/7fa8ccd1-dd8b-45fa-82b0-4bf5beaa7217" />
<img width="706" height="430" alt="image" src="https://github.com/user-attachments/assets/4a886f6a-8199-4233-99f8-054228069d8e" />

## SOAL 4
Pada Node Erendis,
jalankan `apt-get update && apt-get install -y bind9`

`nano /etc/bind/named.conf.local` isi dengan
```
zone "k53.com" {
    type master;
    file "/etc/bind/jarkom/k53.com";
    allow-transfer { 10.90.3.3; };
};
```
zone "k53.com" {
    type master;
    file "/etc/bind/jarkom/k53.com";
    allow-transfer { 10.90.3.3; };
};

buat folder baru dengan `mkdir -p /etc/bind/jarkom`

`nano /etc/bind/jarkom/k53.com` isi dengan
```
$TTL    604800
@       IN      SOA     k53.com. root.k53.com. (
                        2024102801      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
; 
@               IN      NS      ns1.k53.com.
@               IN      NS      ns2.k53.com.
ns1             IN      A       10.90.3.2
ns2             IN      A       10.90.3.3

palantir        IN      A       10.90.4.3
narvi           IN      A       10.90.4.4
elros           IN      A       10.90.1.6
pharazon        IN      A       10.90.2.6
elendil         IN      A       10.90.1.2
isildur         IN      A       10.90.1.3
anarion         IN      A       10.90.1.4
galadriel       IN      A       10.90.2.2
celeborn        IN      A       10.90.2.3
oropher         IN      A       10.90.2.4
```
`nano /etc/bind/named.conf.options` isi dengan
```
options {
    directory "/var/cache/bind";
    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
```
lalu jalankan `service named restart`

Pada Node Amdir,
install bind9 dengan `apt-get update && apt-get install -y bind9`
`nano /etc/bind/named.conf.local` isi dengan
```
zone "k53.com" {
    type slave;
    file "/var/lib/bind/k53.com";
    masters { 10.90.3.2; };
};
```
`nano /etc/bind/named.conf.options` isi dengan
```
options {
    directory "/var/cache/bind";
    allow-query { any; };
    auth-nxdomain no;
    listen-on-v6 { any; };
};
```
lalu jalankan `service named restart`

Kembali ke Node Erendis, jalankan :
- `service named status` untuk menampilkan status layanan bind9(named) apakah aktif atau tidak.
- `named-checkconf` untuk memeriksa sintaks file konfigurasi bind9 untuk memastikan tidak ada error
- `named-checkzone k53.com /etc/bind/jarkom/k53.com` untuk memvalidasi file zona k53.com terhadap konfigurasi yang ada
- `rndc status` untuk menampilkan status detail server DNS bind9 melalui kontrol rndc

Kemudian, jalankan :
- `dig @localhost k53.com` - melakukan query DNS ke server lokal untuk domain utama k53.com guna memastikan zona utama bisa di-resolve.
- `dig @localhost palantir.k53.com` untuk mengecek apakah usbdomain palantir k53.com sudah terdaftar dan dijawab oleh server DNS lokal
- `dig @localhost elros.k53.com` untuk menguji query ke domain/subdomain elros.k53.co, berguna untuk melihat apakah ada kesalahan penulisan (typo) atau memang tidak ada record di server lokal.
<img width="891" height="733" alt="image" src="https://github.com/user-attachments/assets/2b1ba06c-30ab-4497-9645-70a9f5df0588" />
<img width="590" height="366" alt="image" src="https://github.com/user-attachments/assets/78a8b402-20ec-4e80-8d01-563e8de0ee60" />

Pada Node Amdir, jalankan :
- `service named status` untuk menampilkan status layanan BIND9 (named) apakah sedang aktif, berhenti, atau error.
- `ls -la /var/lib/bind/` untuk menampilkan daftar file dan direktori di lokasi penyimpanan file zona BIND9 beserta detail izin, pemilik, dan ukuran.
- `dig @localhost palantir.k53.com` untuk melakukan query DNS ke server lokal untuk memastikan record palantir.k53.com bisa di-resolve sesuai konfigurasi zona.
<img width="587" height="476" alt="image" src="https://github.com/user-attachments/assets/64ef0b55-3657-46e5-a09d-1eb96e34d544" />

Pada Node Miriel, jalankan `echo "nameserver 10.90.3.2" > /etc/resolv.conf` kemudian jalankan `nslookup palantir.k53.com`
<img width="502" height="121" alt="image" src="https://github.com/user-attachments/assets/d81d895f-66b1-4c20-9c16-2519167e57d2" />

## SOAL 5

Pada Node Erendis, jalankan :
`nano /etc/bind/jarkom/k53.com` dan isi dengan
```
$TTL    604800
@       IN      SOA     k53.com. root.k53.com. (
                        2024102801      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@               IN      NS      ns1.k53.com.
@               IN      NS      ns2.k53.com.
ns1             IN      A       10.90.3.2
ns2             IN      A       10.90.3.3

www             IN      CNAME   k53.com.

palantir        IN      A       10.90.4.3
narvi           IN      A       10.90.4.4
elros           IN      A       10.90.1.6
pharazon        IN      A       10.90.2.6
elendil         IN      A       10.90.1.2
isildur         IN      A       10.90.1.3
anarion         IN      A       10.90.1.4
galadriel       IN      A       10.90.2.2
celeborn        IN      A       10.90.2.3
oropher         IN      A       10.90.2.4

elros           IN      TXT     "Cincin Sauron"
pharazon        IN      TXT     "Aliansi Terakhir"
```

`nano /etc/bind/named.conf.local` dengan
```
zone "k53.com" {
    type master;
    file "/etc/bind/jarkom/k53.com";
    allow-transfer { 10.90.3.3; };
};

zone "3.90.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/3.90.10.in-addr.arpa";
    allow-transfer { 10.90.3.3; };
};
```

`nano /etc/bind/jarkom/3.90.10.in-addr.arpa` dengan
```
$TTL    604800
@       IN      SOA     k53.com. root.k53.com. (
                        2024102801      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@       IN      NS      ns1.k53.com.
@       IN      NS      ns2.k53.com.

; PTR Records untuk reverse lookup
3       IN      PTR     ns1.k53.com.    
4       IN      PTR     ns2.k53.com.    
```

lalu service named restart

Pada Node Amdir, jalankan :
`nano /etc/bind/named.conf.local` dan isi dengan
```
zone "k53.com" {
    type slave;
    file "/var/lib/bind/k53.com";
    masters { 10.90.3.2; };
};

zone "3.90.10.in-addr.arpa" {
    type slave;
    masters { 10.90.3.2; };
    file "/var/lib/bind/3.90.10.in-addr.arpa";
};
```

lalu service named restart

Pada node client (Miriel), jalankan `echo "nameserver 10.90.3.2" > /etc/resolv.conf
lalu jalankan :
- `nslookup www.k53.com` & `dig www.k53.com`
  <img width="887" height="487" alt="image" src="https://github.com/user-attachments/assets/c79fb90e-58c5-42cb-a74b-891e5b2771a4" />

- `dig pharazon.k53.com TXT` & `nslookup -type=TXT pharazon.k53.com`
  <img width="582" height="440" alt="image" src="https://github.com/user-attachments/assets/dcdba1db-93fb-4a71-9add-448d18457933" />

- `dig elros.k53.com TXT` & `nslookup -type=TXT elros.k53.com`
  <img width="585" height="442" alt="image" src="https://github.com/user-attachments/assets/48d320a1-214e-4469-9f99-6d23e6402fdf" />


## SOAL 7

Pada Node Elendil, Isildur, Anarion, jalankan :
- `apt-get install -y lsb-release ca-certificates apt-transport-https gnupg2 curl` untuk menginstal paket dasar untuk manajemen repositori, sertifikat SSL, transport HTTPS, GPG, dan curl.
- `curl -sSL https://packages.sury.org/php/README.txt | bash -x` untuk mengambil skrip dari repository Sury dan menjalankannya untuk menambahkan sumber paket PHP terbaru.
- `apt-get install -y php8.4 php8.4-fpm php8.4-mysql php8.4-mbstring php8.4-xml php8.4-curl php8.4-zip unzip nginx git` untuk menginstal PHP 8.4 beserta modul pentingnya, Nginx sebagai web server, unzip untuk ekstraksi arsip, dan Git untuk manajemen kode.
- `curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer` untuk menginstal Composer secara global di /usr/local/bin dengan nama biner composer sehingga bisa dijalankan langsung dari terminal.

lalu masuk ke /var/www dengan `cd /var/www`, kemudian clone git repository yang ada di soal dengan `git clone https://github.com/elshiraphine/laravel-simple-rest-api.git` dan masuk ke laravel-simple-rest-api dengan `cd laravel-simple-rest-api`

Setelah itu, jalankan `composer install && composer update` untuk memasang semua dependensi proyek sesuai file composer.json lalu memperbarui paket ke versi terbaru yang kompatibel.
Kemudian `cp .env.example .env` untuk - menyalin berkas contoh konfigurasi menjadi berkas .env yang digunakan sebagai konfigurasi utama aplikasi dan `php artisan key:generate` untuk - menghasilkan application key baru dan menyimpannya ke dalam berkas .env untuk keperluan enkripsi serta keamanan aplikasi.

Setelah semuanya itu berhasil, jalankan
- `ls -la /var/www/laravel-simple-rest-api/` untuk menampilkan daftar file dan direktori proyek Laravel lengkap dengan izin, pemilik, dan detail lainnya.
- ![WhatsApp Image 2025-11-05 at 20 16 16_8de9171f](https://github.com/user-attachments/assets/363f6dc2-8222-4c3d-87ca-def0b13e0c8e)

- `cat /var/www/laravel-simple-rest-api/.env` untuk menampilkan isi file konfigurasi lingkungan Laravel yang berisi variabel penting aplikasi.
- `ls /var/www/laravel-simple-rest-api/vendor/` untuk menampilkan daftar library dan dependensi PHP yang diinstal melalui Composer.

Terakhir, Cek artisannya dengan `php artisan --version`
![WhatsApp Image 2025-11-05 at 20 16 16_d14e9786](https://github.com/user-attachments/assets/d2f40688-5eae-4dc5-a9ff-7a56651a33ac)
