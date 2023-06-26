#! /bin/bash
set -e
DEBIAN_FRONTEND=noninteractive

# Clone Upstream
git clone https://gitlab.gnome.org/GNOME/gnome-control-center -b 44.0
cp -rvf ./debian ./gnome-control-center
cd ./gnome-control-center
for i in ../patches/* ; do patch -Np1 -i $i; done

# Get build deps
apt-get build-dep ./ -y

# Build package
LOGNAME=root dh_make --createorig -y -l -p gnome-control-center_44.0
dpkg-buildpackage --no-sign

# Move the debs to output
cd ../
mkdir -p ./output
mv ./*.deb ./output/
