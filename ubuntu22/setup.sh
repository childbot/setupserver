#!/bin/bash

# Memperbarui paket dan memperbarui indeks paket
sudo apt update
sudo apt upgrade -y

# Menginstal paket yang diperlukan
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Menambahkan kunci GPG resmi Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Menambahkan repositori Docker ke APT sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Memperbarui indeks paket dengan repositori Docker baru
sudo apt update

# Memastikan instalasi dari repositori Docker, bukan dari repositori default Ubuntu
sudo apt-cache policy docker-ce

# Menginstal Docker
sudo apt install -y docker-ce

# Memastikan Docker berjalan
sudo systemctl status docker

# Menambahkan pengguna Anda ke grup Docker (opsional, agar bisa menjalankan Docker tanpa sudo)
sudo usermod -aG docker ${USER}

# Mengaktifkan Docker agar mulai otomatis saat boot
sudo systemctl enable docker

# Menginstruksikan pengguna untuk logout dan login kembali agar perubahan grup diterapkan
echo "Instalasi Docker selesai. Silakan logout dan login kembali agar perubahan grup diterapkan."

# Memverifikasi instalasi Docker
docker --version