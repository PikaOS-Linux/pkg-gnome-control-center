#! /bin/bash
set -e
DEBIAN_FRONTEND=noninteractive

# Get logos
wget https://github.com/PikaOS-Linux/pika-branding/raw/main/logos/pika-logo-text-dark.svg -O ./debian/pika-logo-dark.png
wget https://github.com/PikaOS-Linux/pika-branding/raw/main/logos/pika-logo-text.svg -O ./debian/pika-logo-icon.png
wget https://github.com/PikaOS-Linux/pika-branding/raw/main/logos/pika-logo-text-dark.svg -O ./debian/ubuntu-logo-dark.png
wget https://github.com/PikaOS-Linux/pika-branding/raw/main/logos/pika-logo-text.svg -O ./debian/ubuntu-logo-icon.png

# Clone Upstream
git clone https://gitlab.gnome.org/GNOME/gnome-control-center -b 45.0
cp -rvf ./debian ./gnome-control-center
cd ./gnome-control-center
for i in $(cat ../patches/series) ; do echo "Applying Patch: $i" && patch -Np1 -i ../patches/$i || echo "Applying Patch $i Failed!"; done

# Get build deps
apt-get build-dep ./ -y

# Build package
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
