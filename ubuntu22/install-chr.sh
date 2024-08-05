#!/bin/bash

# Meminta input versi MikroTik yang akan diinstal
read -p "Masukkan versi MikroTik yang akan diinstal (misalnya 6.47.10): " VERSION

# Meminta input antarmuka jaringan yang akan digunakan
read -p "Masukkan antarmuka jaringan yang akan digunakan (misalnya eth0): " INTERFACE

# Mengunduh image MikroTik CHR
wget https://download.mikrotik.com/routeros/$VERSION/chr-$VERSION.img.zip -O chr.img.zip && \
gunzip -c chr.img.zip > chr.img && \
mount -o loop,offset=512 chr.img /mnt && \
ADDRESS=$(ip addr show $INTERFACE | grep 'inet ' | awk '{print $2}' | head -n 1) && \
GATEWAY=$(ip route list | grep default | awk '{print $3}') && \
echo "/ip dhcp-client remove 0;
/ip address add address=$ADDRESS interface=[/interface ethernet find where name=$INTERFACE];
/ip route add gateway=$GATEWAY;
/system identity set name=CHRBARU;
" > /mnt/rw/autorun.scr && \
umount /mnt && \
echo u > /proc/sysrq-trigger && \
dd if=chr.img bs=1024 of=/dev/vda && \
rm chr.img chr.img.zip && \
echo "Instalasi MikroTik CHR versi $VERSION selesai. Silakan reboot sistem untuk mem-boot dari perangkat yang baru diinstal."