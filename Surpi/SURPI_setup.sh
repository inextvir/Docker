#!/bin/bash
#
#	SURPI_setup.sh
#
#	This script will install SURPI and its dependencies. It has been tested with Ubuntu 12.04.
#	The script has been designed to work on a newly installed OS, though should also work on an existing system.
#
#	Several Ubuntu packages are installed, as well as some perl modules - please inspect the code if you have concerns
#	about these installations on an existing system.
#
#	SURPI is sensitive to the use of specific versions of its software dependencies. We will likely work to validate
#	new versions over time, but currently we are using specific versions for these dependencies. These versions may
#	conflict with versions on an existing system.
#
#	Chiu Laboratory
#	University of California, San Francisco
#	January, 2014
#
# Copyright (C) 2014 Scot Federman - All Rights Reserved
# Permission to copy and modify is granted under the BSD license
# Last revised 6/6/2014

export DEBIAN_FRONTEND=noninteractive

#
##
### install & update Ubuntu packages
##
#

# Install packages necessary for the SURPI pipeline.
apt-get update -y
apt-get install -y curl libz-dev wget make csh htop python-dev gcc unzip g++ g++-4.6 cpanminus ghostscript blast2 python-matplotlib git pigz parallel ncbi-blast+
apt-get upgrade -y

#
##
### install EC2 CLI tools
##
#

apt-get install -y openjdk-7-jre
wget http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
mkdir /usr/local/ec2
unzip ec2-api-tools.zip -d /usr/local/ec2

echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre" >> ~/.bashrc
echo "export EC2_HOME=/usr/local/ec2/ec2-api-tools-1.6.13.0/" >> ~/.bashrc
echo "PATH=\$PATH:$EC2_HOME/bin" >> ~/.bashrc

#
##
### install Perl Modules
##
#

# for taxonomy
cpanm DBI
cpanm DBD::SQLite

# for twitter updates
cpanm Net::Twitter::Lite::WithAPIv1_1
cpanm Net::OAuth


#
##
### install SURPI scripts
##
#

#Install via git clone
cd /usr/local/bin
sudo git clone https://github.com/chiulab/surpi.git
cd ~

echo "PATH=\$PATH:/usr/local/bin" >> ~/.bashrc
echo "PATH=\$PATH:/usr/local/bin/surpi" >> ~/.bashrc

#
##
### install gt (genometools)
##
#
#Works in Ubuntu 14.10
curl -O "http://genometools.org/pub/genometools-1.5.4.tar.gz"
tar xvfz genometools-1.5.4.tar.gz
cd genometools-1.5.4
make 64bit=yes curses=no cairo=no
make "prefix=/usr/local" 64bit=yes curses=no cairo=no install
cd ~

#
##
### install seqtk
##
#
# 6/4/14 - discovered that current version of seqtk (1.0-r57) is buggy. We should install 1.0-r31
curl "https://codeload.github.com/lh3/seqtk/zip/1.0" > seqtk.zip
unzip seqtk.zip
cd seqtk-1.0
make
mv seqtk "/usr/local/bin/"
cd ~

#
##
### install fastq
##
#
mkdir fastq
cd fastq
wget "https://raw.github.com/brentp/bio-playground/master/reads-utils/fastq.cpp"
g++ -O2 -o fastq fastq.cpp
mv fastq "/usr/local/bin/"
chmod +x "/usr/local/bin/fastq"
cd ~

#
##
### install cutadapt
##
#
curl -O "https://files.pythonhosted.org/packages/44/16/cf42365624044fd4c2491015fb7292e8cf67a8832d77be103d55103ebf6d/cutadapt-1.2.1.tar.gz"
tar xvfz cutadapt-1.2.1.tar.gz
cd cutadapt-1.2.1
python setup.py build
python setup.py install
cd ~

#
##
### install prinseq-lite.pl
##
#

wget https://downloads.sourceforge.net/project/prinseq/standalone/prinseq-lite-0.20.4.tar.gz
tar xvfz prinseq-lite-0.20.3.tar.gz
cp prinseq-lite-0.20.3/prinseq-lite.pl "/usr/local/bin//"
chmod +x "/usr/local/bin/prinseq-lite.pl"

#
##
### compile and install dropcache (must be after SURPI scripts)
##
#

gcc /usr/local/bin/surpi/source/dropcache.c -o dropcache
mv dropcache "/usr/local/bin/"
chown root "/usr/local/bin/dropcache"
chmod u+s "/usr/local/bin/dropcache"

#
##
### install SNAP
##
#

curl -O "http://snap.cs.berkeley.edu/downloads/snap-0.15.4-linux.tar.gz"
tar xvfz snap-0.15.4-linux.tar.gz
cp snap-0.15.4-linux/snap "/usr/local/bin/"

#
##
### install RAPSearch
##
#

wget "https://sourceforge.net/projects/rapsearch2/files/RAPSearch2.15_64bits.tar.gz"
tar xvfz RAPSearch2.15_64bits.tar.gz
cd RAPSearch2.15_64bits
./install
cp bin/* "/usr/local/bin/"
cd ~

### install fastQValidator from sourcecode
##
#
# http://genome.sph.umich.edu/wiki/FastQValidator

wget "https://genome.sph.umich.edu/w/images/2/20/FastQValidatorLibStatGen.0.1.1a.tgz"
tar xvf FastQValidatorLibStatGen.0.1.1a.tgz
cd fastQValidator_0.1.1a
#Set up libstat Dependency
rm -r libStatGen
wget https://github.com/statgen/libStatGen/archive/master.tar.gz
tar xvzf master.tar.gz
mv libStatGen-master libStatGen
make all
# build fastQValidator
cd ..
make all
cp fastQValidator/bin/fastQValidator "/usr/local/bin/"
cd ~


#
##
### install AbySS 1.5.2
##
#
# http://www.bcgsc.ca/platform/bioinfo/software/abyss

#Download ABySS
wget "https://github.com/bcgsc/abyss/releases/download/1.5.2/abyss-1.5.2.tar.gz"
tar xvfz abyss-1.5.2.tar.gz

#Set up Boost Dependency
cd abyss-1.5.2
wget "https://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.gz"
tar xvfz boost_1_57_0.tar.gz
ln -s boost_1_57_0/boost boost

#Install packaged dependencies
#apt-get install -y openmpi-bin sparsehash libopenmpi-dev # Ubuntu 12.04
apt-get install -y openmpi-bin libsparsehash-dev libopenmpi-dev # Ubuntu 14.10

# Configure ABySS
./configure --with-mpi=/usr/lib/openmpi CPPFLAGS=-I/usr/include/google
make AM_CXXFLAGS=-Wall
make install
cd ~

#
##
### install Minimo
##
#

apt-get -y install mummer
cpanm DBI
cpanm Statistics::Descriptive
cpanm XML::Parser

curl -O "http://iweb.dl.sourceforge.net/project/amos/amos/3.1.0/amos-3.1.0.tar.gz"
tar xvfz amos-3.1.0.tar.gz
cd amos-3.1.0
./configure --prefix=/usr/local CXX='g++-4.6'
make
make install
cd ~
source ~/.bashrc
