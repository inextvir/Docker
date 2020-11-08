#!/bin/bash
#
#	PAIPLINE_setup.sh
#


cd /usr/local/bin

apt-get update
apt-get install -y git python
git clone https://gitlab.com/andreas.andrusch/paipline.git
git clone https://gitlab.com/andreas.andrusch/database-updater.git
cd ~
echo "PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/bin/paipline" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/bin/database-updater" >> ~/.bashrc
. ~/.bashrc
