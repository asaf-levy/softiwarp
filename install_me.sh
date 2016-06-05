#!/bin/bash

sudo yum install -y kernel-devel libtool autoconf rdma libibverbs-utils libibcommon libibcm-devel libibverbs yum-utils librdmacm-utils librdmacm-devel

cd kernel
make -j 4
sudo make install

cd ../userlib/
./autogen.sh
./autogen.sh
./configure prefix=/usr libdir=/usr/lib
make -j 4
sudo make install
sudo cp siw.driver /etc/libibverbs.d/

sudo modprobe rdma_cm
sudo modprobe ib_uverbs
sudo modprobe rdma_ucm
sudo modprobe siw

sudo ldconfig

echo  "* soft memlock unlimited" | sudo tee /etc/security/limits.d/rdma.conf
echo  "* hard memlock unlimited" | sudo tee --append /etc/security/limits.d/rdma.conf

cd ..

echo "to verify installation run \"ibv_devinfo\""
echo "following a restart run \"sudo modprobe siw\" in order to get softiwarp to work"

