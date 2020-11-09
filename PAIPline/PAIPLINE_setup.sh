#!/bin/bash
#
#	PAIPLINE_setup.sh
#

export DEBIAN_FRONTEND=noninteractive
chmod 777 /root
apt-get update
apt-get install -y git python
#
##
###
####
#####
######
####### Conda available dependencies : bowtie2, Blast
######
#####
####
###
##
#
conda install -y -c bioconda bowtie2
conda install -y -c bioconda/label/cf201901 blast


#
##
###
####
#####
######
####### install PAIPline
######
#####
####
###
##
#

cd /usr/local/bin
git clone https://gitlab.com/andreas.andrusch/paipline.git
git clone https://gitlab.com/andreas.andrusch/database-updater.git
cd ~
echo "PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/bin/paipline" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/bin/database-updater" >> ~/.bashrc
. ~/.bashrc
