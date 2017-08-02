#!/bin/bash
#
# Script de instalação para a VM que mede a disponibilidade durante a migração
# Deve ser adicionado no momento da criação da instancia (no openstack Console)
#	mas pode ser usado pelo Rally.
# Isso evita que tenha-se que criar uma snapshot customizada

# Vars
IPERF="iperf3"
IPERF_I=$IPERF"_3.1.3-1_amd64.deb"
LIBIPERF="libiperf0"
LIBIPERF_I=$LIBIPERF"_3.1.3-1_amd64.deb"

# Install

sudo apt-get remove $IPERF3 $LIBIPERF
wget https://iperf.fr/download/ubuntu/$LIBIPERF_I
wget https://iperf.fr/download/ubuntu/$IPERF_I
sudo chmod +x $LIBIPERF_I $IPERF_I
sudo dpkg -i $LIBIPERF_I $IPERF_I
rm $LIBIPERF_I $IPERF_I

# Install NetData
sudo apt-get update && sudo apt-get upgrade -y
bash <(curl -Ss https://my-netdata.io/kickstart-static64.sh) --dont-wait

sudo apt-get install stress -y

#stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M --timeout 100s 

