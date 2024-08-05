#!/bin/bash

# Meminta input versi MikroTik yang akan diinstal
read -p "Masukkan versi MikroTik yang akan diinstal (misalnya 6.47.10): " VERSION

# Meminta input antarmuka jaringan yang akan digunakan
read -p "Masukkan antarmuka jaringan yang akan digunakan (misalnya eth0): " INTERFACE

# Meminta input username
read -p "Masukkan username MikroTik: " USERNAME

# Meminta input password
read -sp "Masukkan password MikroTik: " PASSWORD
echo

# Meminta input email untuk lisensi
read -p "Masukkan email lisensi MikroTik: " LICENSE_EMAIL

# Meminta input password lisensi
read -sp "Masukkan password lisensi MikroTik: " LICENSE_PASSWORD
echo

# Mengunduh image MikroTik CHR
wget https://download.mikrotik.com/routeros/$VERSION/chr-$VERSION.img.zip -O chr.img.zip && \
gunzip -c chr.img.zip > chr.img && \
sudo mount -o loop,offset=512 chr.img /mnt && \
ADDRESS=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | head -n 1) && \
GATEWAY=$(ip route list | grep default | awk '{print $3}') && \
echo "/ip dhcp-client remove [find];
/ip address add address=$ADDRESS interface=[/interface ethernet find where name=$INTERFACE];
/ip route add gateway=$GATEWAY;
/system identity set name=CHRPerwira;
/user add name=$USERNAME password=$PASSWORD group=full;
/user remove admin;
/system license renew level=p1 account=$LICENSE_EMAIL password=$LICENSE_PASSWORD;
" > /mnt/rw/autorun.scr && \
sudo umount /mnt && \
echo u | sudo tee /proc/sysrq-trigger && \
sudo dd if=chr.img bs=1024 of=/dev/vda && \
echo "Instalasi MikroTik CHR versi $VERSION selesai. Silakan reboot sistem untuk mem-boot dari perangkat yang baru diinstal."